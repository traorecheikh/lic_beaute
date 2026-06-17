import type { FastifyReply, FastifyRequest } from "fastify";
import type { Prisma } from "../../generated/prisma/client.js";

import {
  proSubscriptionUpdateInputSchema,
  proSubscriptionCheckoutInputSchema,
  proSubscriptionExecuteInputSchema,
  proCancelSubscriptionInputSchema
} from "@beauteavenue/contracts";

import { config } from "../../config.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { logger } from "../../lib/logger.js";
import { toDbProvider, toPublicBillingProvider, toPublicGatewayProvider } from "../../lib/payment-provider.js";
import { prisma } from "../../lib/db/prisma.js";
import { buildInvoicePdf } from "../../lib/pdf.js";

import {
  paymentAdapter,
  ensurePro,
  ownerOnly,
  isPaydunyaTokenCompatibleWithEnv,
  isNonReusableSubscriptionChargeError,
  getFeatureFlags,
  getRetentionOffer,
  requiresProviderCompletion,
  toSettingMap,
  maskAccountNumber,
  encryptBillingAccount,
  decryptBillingAccount,
  salonBillingProviderKey,
  salonBillingAccountKey
} from "./shared.js";

// ─── Subscription Features ───────────────────────────────────────────────

export async function getSubscriptionFeatures(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const flags = await getFeatureFlags();
    const salon = await prisma.salon.findUnique({
      where: { id: salonId },
      select: { subscriptionTier: true }
    });
    const tier = salon?.subscriptionTier ?? "standard";
    const isPremium = tier === "premium";

    const priceRows = await prisma.platformSetting.findMany({
      where: { key: { in: ["subscription_standard_price_xof", "subscription_premium_price_xof"] } }
    });
    const priceMap = Object.fromEntries(priceRows.map((r) => [r.key, r.value]));

    ok(reply, {
      deposits: {
        enabled: flags.depositsEnabled,
        available: flags.depositsEnabled && (flags.depositsTierRequired === "standard" || isPremium)
      },
      analytics: {
        enabled: flags.analyticsEnabled,
        available: flags.analyticsEnabled && (flags.analyticsTierRequired === "standard" || isPremium)
      },
      autoRenew: { enabled: flags.autoRenewEnabled },
      billingProviders: {
        paydunya: flags.billingPaydunya,
        manual: flags.billingManual,
        card: flags.cardPayments
      },
      planTiers: [
        {
          tier: "standard",
          label: "Standard",
          priceLabel: (() => { const p = parseInt(priceMap["subscription_standard_price_xof"] ?? "200", 10); return p === 0 ? "Gratuit" : `${p.toLocaleString("fr-FR")} XOF`; })(),
          priceXof: parseInt(priceMap["subscription_standard_price_xof"] ?? "200", 10),
          features: [
            { label: "Agenda illimité", included: true },
            { label: "Gestion de l'équipe", included: true },
            { label: "Acompte client", included: flags.depositsEnabled && (flags.depositsTierRequired === "standard") },
            { label: "Rapports financiers", included: flags.analyticsEnabled && (flags.analyticsTierRequired === "standard") },
            { label: "Export CSV", included: false },
            { label: "Badge « Vérifié »", included: false },
            { label: "Support prioritaire 24/7", included: false }
          ]
        },
        {
          tier: "premium",
          label: "Premium",
          priceLabel: (() => { const p = parseInt(priceMap["subscription_premium_price_xof"] ?? "300", 10); return p === 0 ? "Gratuit" : `${p.toLocaleString("fr-FR")} XOF`; })(),
          priceXof: parseInt(priceMap["subscription_premium_price_xof"] ?? "300", 10),
          features: [
            { label: "Agenda illimité", included: true },
            { label: "Gestion de l'équipe", included: true },
            { label: "Acompte client", included: flags.depositsEnabled },
            { label: "Rapports financiers", included: flags.analyticsEnabled },
            { label: "Export CSV", included: true },
            { label: "Badge « Vérifié »", included: true },
            { label: "Support prioritaire 24/7", included: true }
          ]
        }
      ]
    });
  } catch (e) { handleError(e, reply); }
}

// ─── Subscription ──────────────────────────────────────────────────────────

export async function getSubscription(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const [sub, settings] = await Promise.all([
      prisma.subscription.findUnique({ where: { salonId } }),
      prisma.platformSetting.findMany({
        where: {
          key: {
            in: [
              salonBillingProviderKey(salonId),
              salonBillingAccountKey(salonId),
              `salon:${salonId}:billing_country`,
              `salon:${salonId}:billing_method`
            ]
          }
        },
        select: { key: true, value: true }
      })
    ]);
    if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    const settingMap = toSettingMap(settings);
    const rawProvider = settingMap[salonBillingProviderKey(salonId)];
    const provider = toPublicBillingProvider(rawProvider ?? sub.billingProvider);
    const encryptedAccountNumber = settingMap[salonBillingAccountKey(salonId)];
    const accountNumber = encryptedAccountNumber ? decryptBillingAccount(encryptedAccountNumber) : null;
    const billingCountry = settingMap[`salon:${salonId}:billing_country`] ?? null;
    const billingMethodCode = settingMap[`salon:${salonId}:billing_method`] ?? null;
    const billingMethod = provider && accountNumber
      ? { provider, accountNumberMasked: maskAccountNumber(accountNumber), country: billingCountry, method: billingMethodCode }
      : null;
    ok(reply, {
      id: sub.id,
      tier: sub.tier,
      pendingTier: sub.pendingTier ?? null,
      status: sub.status,
      renewsAt: sub.expiresAt?.toISOString() ?? null,
      expiresAt: sub.expiresAt?.toISOString() ?? null,
      gracePeriodEndsAt: sub.gracePeriodEndsAt?.toISOString() ?? null,
      isComplimentary: sub.isComplimentary,
      autoRenew: sub.autoRenew,
      billingMethod
    });
  } catch (e) { handleError(e, reply); }
}

export async function updateSubscription(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const body = proSubscriptionUpdateInputSchema.parse(request.body);
    await prisma.$transaction(async (tx) => {
      const updatePayload: Prisma.SubscriptionUpdateInput = {};
      if (body.autoRenew !== undefined) {
        updatePayload.autoRenew = body.autoRenew;
      }
      if (body.billingMethod !== undefined) {
        updatePayload.billingProvider = toDbProvider(body.billingMethod?.provider ?? null);
      }
      if (Object.keys(updatePayload).length > 0) {
        await tx.subscription.update({ where: { salonId }, data: updatePayload });
      }

      if (body.billingMethod !== undefined) {
        const providerKey = salonBillingProviderKey(salonId);
        const accountKey = salonBillingAccountKey(salonId);
        if (body.billingMethod === null) {
          await tx.platformSetting.deleteMany({ where: { key: { in: [providerKey, accountKey] } } });
        } else {
          await tx.platformSetting.upsert({
            where: { key: providerKey },
            create: {
              group: "salon_billing",
              key: providerKey,
              value: body.billingMethod.provider,
              description: `Billing provider for salon ${salonId}`
            },
            update: { value: body.billingMethod.provider }
          });
          await tx.platformSetting.upsert({
            where: { key: accountKey },
            create: {
              group: "salon_billing",
              key: accountKey,
              value: encryptBillingAccount(body.billingMethod.accountNumber.trim()),
              description: `Billing account number for salon ${salonId}`
            },
            update: { value: encryptBillingAccount(body.billingMethod.accountNumber.trim()) }
          });
          if (body.billingMethod.country) {
            await tx.platformSetting.upsert({
              where: { key: `salon:${salonId}:billing_country` },
              create: { group: "salon_billing", key: `salon:${salonId}:billing_country`, value: body.billingMethod.country, description: `Billing country for salon ${salonId}` },
              update: { value: body.billingMethod.country }
            });
          }
          if (body.billingMethod.method) {
            await tx.platformSetting.upsert({
              where: { key: `salon:${salonId}:billing_method` },
              create: { group: "salon_billing", key: `salon:${salonId}:billing_method`, value: body.billingMethod.method, description: `Billing method for salon ${salonId}` },
              update: { value: body.billingMethod.method }
            });
          }
        }
      }
    });
    ok(reply, { updated: true });
  } catch (e) { handleError(e, reply); }
}

export async function getChargeStatus(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const params = request.params as { chargeId: string };
    const sub = await prisma.subscription.findUnique({ where: { salonId } });
    if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    const charge = await prisma.subscriptionCharge.findUnique({
      where: { id: params.chargeId },
      include: { subscription: { select: { status: true, tier: true, expiresAt: true } } }
    });
    if (!charge || charge.subscriptionId !== sub.id) {
      fail(reply, 404, "charge_not_found", "Paiement introuvable."); return;
    }

    let effectiveCharge = charge;
    if (
      config.paymentDriver === "paydunya" &&
      charge.providerTxId &&
      (charge.status === "pending" || charge.status === "authorized")
    ) {
      try {
        const providerStatus = await paymentAdapter.fetchPaymentStatus({ providerToken: charge.providerTxId });
        if (providerStatus === "succeeded") {
          await settleSuccessfulSubscriptionCharge(charge, charge.providerTxId);
        } else if (providerStatus === "failed" || providerStatus === "refunded") {
          await markSubscriptionChargeFailed(charge, providerStatus);
        }
        const refreshed = await prisma.subscriptionCharge.findUnique({
          where: { id: charge.id },
          include: { subscription: { select: { status: true, tier: true, expiresAt: true } } }
        });
        if (refreshed) effectiveCharge = refreshed;
      } catch (error) {
        logger.warn("getChargeStatus: provider reconciliation failed", {
          chargeId: charge.id,
          error: String(error)
        });
      }
    }

    ok(reply, {
      chargeId: effectiveCharge.id,
      status: effectiveCharge.status,
      provider: effectiveCharge.provider,
      amountXof: effectiveCharge.amountXof,
      chargeType: effectiveCharge.chargeType,
      subscriptionId: effectiveCharge.subscriptionId,
      subscriptionStatus: effectiveCharge.subscription?.status ?? sub.status,
      tier: effectiveCharge.subscription?.tier ?? sub.tier,
      expiresAt: effectiveCharge.subscription?.expiresAt?.toISOString() ?? null
    });
  } catch (e) { handleError(e, reply); }
}

export async function subscriptionCheckout(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { userId, salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const body = proSubscriptionCheckoutInputSchema.parse(request.body);

    const sub = await prisma.subscription.findUnique({ where: { salonId } });
    if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    const owner = await prisma.user.findUnique({
      where: { id: userId },
      select: { phone: true }
    });
    if (config.paymentDriver === "paydunya" && !owner?.phone) {
      fail(reply, 422, "phone_required", "Numéro de téléphone requis pour initier ce paiement.");
      return;
    }

    // ── Guard: block invalid action/tier combinations ────────────────────
    if (body.action === "activate" && sub.status === "active") {
      fail(reply, 409, "already_active", "Votre abonnement est déjà actif.");
      return;
    }
    if (body.action === "upgrade" && sub.tier === "premium") {
      fail(reply, 409, "already_premium", "Vous êtes déjà sur le plan Premium.");
      return;
    }
    if (body.action === "upgrade" && sub.tier === "standard" && sub.pendingTier === "premium") {
      fail(reply, 409, "upgrade_pending", "Une mise à niveau est déjà en attente de paiement.");
      return;
    }
    if (body.action === "renewal" && sub.isComplimentary) {
      fail(reply, 409, "complimentary", "Les abonnements complémentaires ne nécessitent pas de renouvellement.");
      return;
    }
    if (body.action === "downgrade") {
      if (sub.tier === "standard") {
        fail(reply, 409, "already_standard", "Vous êtes déjà sur le plan Standard.");
        return;
      }
      await prisma.subscription.update({
        where: { id: sub.id },
        data: { pendingTier: "standard" }
      });
      ok(reply, { downgradeScheduled: true, effectiveAt: sub.expiresAt?.toISOString() ?? null, afterGracePeriod: true });
      return;
    }

    const priceRows = await prisma.platformSetting.findMany({
      where: {
        key: {
          in: [
            "subscription_premium_price_xof",
            "subscription_standard_price_xof",
            "subscription_annual_discount_percent"
          ]
        }
      }
    });
    const priceMap = Object.fromEntries(priceRows.map((r) => [r.key, r.value]));
    const priceKey = body.action === "upgrade"
      ? "subscription_premium_price_xof"
      : body.action === "activate" && body.tier === "premium"
        ? "subscription_premium_price_xof"
        : body.action === "renewal" && sub.tier === "premium"
          ? "subscription_premium_price_xof"
          : "subscription_standard_price_xof";
    const priceStr = priceMap[priceKey];
    if (!priceStr) {
      fail(reply, 500, "pricing_not_configured", "Le prix de l'abonnement n'est pas configuré. Contactez l'administrateur.");
      return;
    }
    const monthlyAmountXof = parseInt(priceStr, 10);
    const annualDiscountPercent = Math.max(
      0,
      Math.min(100, parseInt(priceMap.subscription_annual_discount_percent ?? "0", 10) || 0)
    );
    const amountXof = body.billingCycle === "annual"
      ? Math.round(monthlyAmountXof * 12 * (100 - annualDiscountPercent) / 100)
      : monthlyAmountXof;
    const billingMonth = new Date().toISOString().slice(0, 7);
    const tierSuffix = body.action === "activate" ? `-${body.tier ?? "standard"}` : "";
    const idempotencyKey = `sub-${sub.id}-${body.action}${tierSuffix}-${body.billingCycle}-${billingMonth}`;

    // ── Free tier bypass ────────────────────────────────────────────────
    if (amountXof === 0) {
      const existing = await prisma.subscriptionCharge.findFirst({
        where: { idempotencyKey, status: "succeeded" }
      });
      if (existing) {
        ok(reply, { chargeId: existing.id });
        return;
      }
      const freeCharge = await prisma.subscriptionCharge.create({
        data: {
          subscriptionId: sub.id,
          provider: toDbProvider(body.provider) ?? "paydunya",
          amountXof: 0,
          idempotencyKey,
          chargeType: body.action,
          status: "succeeded",
          providerTxId: "free-tier"
        }
      });
      await settleSuccessfulSubscriptionCharge(freeCharge, "free-tier", JSON.stringify({ free: true }));
      ok(reply, { chargeId: freeCharge.id });
      return;
    }

    const existing = await prisma.subscriptionCharge.findFirst({
      where: { idempotencyKey }
    });
    if (existing?.status === "pending" && existing?.providerTxId && isPaydunyaTokenCompatibleWithEnv(existing.providerTxId)) {
      ok(reply, { redirectUrl: null, chargeId: existing.id, resumed: true });
      return;
    }

    const charge = existing
      ? await prisma.subscriptionCharge.update({
          where: { id: existing.id },
          data: {
            status: "pending",
            provider: toDbProvider(body.provider) ?? "paydunya",
            amountXof,
            chargeType: body.action,
            providerTxId: null,
            invoiceId: null
          }
        })
      : await prisma.subscriptionCharge.create({
          data: { subscriptionId: sub.id, provider: toDbProvider(body.provider) ?? "paydunya", amountXof, idempotencyKey, chargeType: body.action }
        });

    const result = await paymentAdapter.initiateDeposit({
      paymentId: charge.id,
      amountXof,
      description: `Abonnement ${body.action} (${body.billingCycle})`,
      callbackUrl: `${config.webOrigin}/pro/subscription/callback?chargeId=${encodeURIComponent(charge.id)}`,
      idempotencyKey,
      phone: owner?.phone ?? undefined,
      channel: body.channel
    });

    await prisma.subscriptionCharge.update({
      where: { id: charge.id },
      data: { providerTxId: result.providerRef }
    });

    if (body.action === "upgrade") {
      await prisma.subscription.update({
        where: { id: sub.id },
        data: { pendingTier: "premium" }
      });
    }

    ok(reply, { redirectUrl: result.redirectUrl, chargeId: charge.id });
  } catch (e) { handleError(e, reply); }
}

export async function executeSubscriptionPayment(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const params = request.params as { chargeId: string };
    const body = proSubscriptionExecuteInputSchema.parse(request.body);

    const charge = await prisma.subscriptionCharge.findUnique({
      where: { id: params.chargeId },
      include: { subscription: true }
    });

    if (!charge) {
      fail(reply, 404, "charge_not_found", "Frais d'abonnement introuvable.");
      return;
    }

    if (charge.subscription.salonId !== salonId) {
      fail(reply, 403, "forbidden", "Accès interdit.");
      return;
    }

    if (charge.status !== "pending") {
      fail(reply, 422, "invalid_status", "Ce paiement ne peut pas être exécuté.");
      return;
    }

    if (!charge.providerTxId) {
      fail(reply, 422, "missing_invoice_token", "Token de facture PayDunya manquant.");
      return;
    }

    if (!paymentAdapter.executePayment) {
      fail(reply, 501, "not_supported", "Ce fournisseur ne supporte pas l'exécution séparée.");
      return;
    }

    const result = await paymentAdapter.executePayment({
      paymentId: charge.id,
      method: body.method,
      invoiceToken: charge.providerTxId,
      details: body.details
    });

    if (result.success) {
      if (requiresProviderCompletion(result)) {
        await prisma.$transaction(async (tx) => {
          await tx.subscriptionCharge.update({
            where: { id: charge.id },
            data: { status: "authorized", ...(result.providerTxId ? { providerTxId: result.providerTxId } : {}) }
          });
          await tx.auditLog.create({
            data: {
              action: "subscription_charge_execute",
              summary: `SubscriptionCharge ${charge.id} → authorized (${charge.chargeType})`,
              entityType: "SubscriptionCharge",
              entityId: charge.id,
              actorName: "pro_user",
              severity: "info",
              payloadJson: JSON.stringify(result)
            }
          });
        });
        ok(reply, result);
        return;
      }
      await settleSuccessfulSubscriptionCharge(
        charge,
        result.providerTxId ?? charge.providerTxId ?? undefined,
        JSON.stringify(result)
      );
    } else {
      await markSubscriptionChargeFailed(charge, "failed", JSON.stringify(result));
    }

    ok(reply, result);
  } catch (e) {
    handleError(e, reply);
  }
}

export async function settleSuccessfulSubscriptionCharge(
  charge: {
    id: string;
    subscriptionId: string;
    amountXof: number;
    chargeType: string;
    idempotencyKey: string;
    providerTxId: string | null;
  },
  providerTxId?: string,
  payloadJson?: string
) {
  await prisma.$transaction(async (tx) => {
    await tx.subscriptionCharge.update({
      where: { id: charge.id },
      data: { status: "succeeded", ...(providerTxId ? { providerTxId } : {}) }
    });

    const invoice = await tx.billingInvoice.create({
      data: {
        subscriptionId: charge.subscriptionId,
        invoiceNumber: `INV-SUB-${charge.id.slice(0, 8).toUpperCase()}`,
        amountXof: charge.amountXof,
        status: charge.amountXof === 0 ? "comped" : "paid"
      }
    });

    await tx.subscriptionCharge.update({
      where: { id: charge.id },
      data: { invoiceId: invoice.id }
    });

    const sub = await tx.subscription.findUnique({
      where: { id: charge.subscriptionId },
      select: { salonId: true, tier: true, expiresAt: true, pendingTier: true }
    });

    const isUpgrade = charge.chargeType === "upgrade";
    const isRenewal = charge.chargeType === "renewal";
    const isActivate = charge.chargeType === "activate";
    const isAnnualCycle = charge.idempotencyKey.includes("-annual-");
    const cycleDays = isAnnualCycle ? 365 : 30;
    const now = new Date();
    const isFree = charge.amountXof === 0;

    let newExpiresAt: Date | undefined;
    let newTier = sub?.tier ?? "standard";
    let newPendingTier = sub?.pendingTier ?? null;

    if (isActivate) {
      newExpiresAt = isFree ? undefined : new Date(now.getTime() + cycleDays * 24 * 60 * 60 * 1000);
    } else if (isUpgrade) {
      if (config.prorationEnabled) {
        newTier = "premium";
        newPendingTier = null;
        newExpiresAt = new Date(now.getTime() + cycleDays * 24 * 60 * 60 * 1000);
      } else {
        newPendingTier = "premium";
        newExpiresAt = undefined;
      }
    } else if (isRenewal) {
      if (sub?.pendingTier) {
        newTier = sub.pendingTier;
        newPendingTier = null;
      }
      if (isFree) {
        newExpiresAt = undefined;
      } else {
        const baseDate = sub?.expiresAt && sub.expiresAt > now ? sub.expiresAt : now;
        newExpiresAt = new Date(baseDate.getTime() + cycleDays * 24 * 60 * 60 * 1000);
      }
    }

    await tx.subscription.update({
      where: { id: charge.subscriptionId },
      data: {
        tier: newTier,
        pendingTier: newPendingTier,
        status: "active",
        renewedAt: now,
        expiresAt: newExpiresAt ?? null,
        autoRenew: !isFree
      }
    });

    if (sub?.salonId) {
      await tx.salon.update({
        where: { id: sub.salonId },
        data: {
          subscriptionTier: newTier,
          isVisibleInMarketplace: true,
          canReceiveBookings: true
        }
      });
    }

    await tx.auditLog.create({
      data: {
        action: "subscription_charge_execute",
        summary: `SubscriptionCharge ${charge.id} → succeeded (${charge.chargeType})`,
        entityType: "SubscriptionCharge",
        entityId: charge.id,
        actorName: "pro_user",
        severity: "info",
        payloadJson: payloadJson ?? JSON.stringify({ providerTxId })
      }
    });
  });
}

export async function markSubscriptionChargeFailed(
  charge: {
    id: string;
    subscriptionId: string;
    chargeType: string;
  },
  status: "failed" | "refunded",
  payloadJson?: string
) {
  await prisma.$transaction(async (tx) => {
    await tx.subscriptionCharge.update({
      where: { id: charge.id },
      data: { status }
    });

    if (charge.chargeType === "upgrade") {
      await tx.subscription.update({
        where: { id: charge.subscriptionId },
        data: { pendingTier: null }
      });
    }

    await tx.auditLog.create({
      data: {
        action: "subscription_charge_execute",
        summary: `SubscriptionCharge ${charge.id} → ${status} (${charge.chargeType})`,
        entityType: "SubscriptionCharge",
        entityId: charge.id,
        actorName: "pro_user",
        severity: status === "failed" ? "warn" : "info",
        payloadJson: payloadJson ?? JSON.stringify({ status })
      }
    });
  });
}

export async function cancelDowngrade(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;

    const sub = await prisma.subscription.findUnique({ where: { salonId } });
    if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    if (sub.pendingTier !== "standard") {
      fail(reply, 409, "no_downgrade_scheduled", "Aucun rétrogradation planifiée.");
      return;
    }

    await prisma.subscription.update({
      where: { id: sub.id },
      data: { pendingTier: null }
    });

    ok(reply, { cancelled: true });
  } catch (e) { handleError(e, reply); }
}

export async function cancelSubscription(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;

    const sub = await prisma.subscription.findUnique({ where: { salonId } });
    if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    if (sub.status === "inactive" || sub.status === "cancelled") {
      fail(reply, 409, "already_inactive", "L'abonnement est déjà inactif.");
      return;
    }
    if (sub.isComplimentary) {
      fail(reply, 409, "complimentary", "Les abonnements complémentaires ne peuvent pas être résiliés ici.");
      return;
    }

    const body = proCancelSubscriptionInputSchema.parse(request.body);
    const reason = body.reason;
    const additionalInfo = body.additionalInfo ?? null;

    await prisma.subscription.update({
      where: { id: sub.id },
      data: {
        status: "cancelled",
        renewedAt: null,
        expiresAt: null,
        pendingTier: null,
        autoRenew: false,
        cancelReason: reason,
        cancelAdditionalInfo: additionalInfo,
        cancelRequestedAt: new Date()
      }
    });

    const retentionOffer = getRetentionOffer(reason, sub.tier);

    ok(reply, { cancelled: true, retentionOffer });
  } catch (e) { handleError(e, reply); }
}

export async function retainSubscription(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;

    const sub = await prisma.subscription.findUnique({ where: { salonId } });
    if (!sub || sub.status !== "cancelled") {
      fail(reply, 409, "not_cancelled", "L'abonnement n'est pas en état résilié.");
      return;
    }
    if (!sub.cancelReason) {
      fail(reply, 409, "no_retention", "Aucune offre de rétention disponible.");
      return;
    }

    await prisma.subscription.update({
      where: { id: sub.id },
      data: {
        status: "active",
        cancelReason: null,
        cancelAdditionalInfo: null,
        cancelRequestedAt: null
      }
    });

    await prisma.subscriptionEvent.create({
      data: {
        subscriptionId: sub.id,
        eventType: "retained",
        summary: `Client retenu (motif: ${sub.cancelReason}). Offre acceptée.`,
        actorName: "client",
        source: "pro"
      }
    });

    ok(reply, { retained: true });
  } catch (e) { handleError(e, reply); }
}

// ─── Payouts ───────────────────────────────────────────────────────────────

export async function listPayouts(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const events = await prisma.settlementEvent.findMany({
      where: { booking: { salonId } },
      orderBy: { createdAt: "desc" }
    });
    ok(reply, events.map((e) => ({ id: e.id, bookingId: e.bookingId, eventType: e.eventType, amountXof: e.amountXof, createdAt: e.createdAt.toISOString() })));
  } catch (e) { handleError(e, reply); }
}

// ─── Invoices ──────────────────────────────────────────────────────────────

export async function listInvoices(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const sub = await prisma.subscription.findUnique({ where: { salonId } });
    if (!sub) { ok(reply, []); return; }
    const invoices = await prisma.billingInvoice.findMany({
      where: { subscriptionId: sub.id },
      orderBy: { createdAt: "desc" }
    });
    ok(reply, invoices.map((i) => ({
      id: i.id,
      invoiceNumber: i.invoiceNumber,
      amountXof: i.amountXof,
      status: i.status,
      createdAt: i.createdAt.toISOString(),
      pdfUrl: i.pdfUrl.trim().length > 0 ? i.pdfUrl : `/api/v1/pro/invoices/${i.id}/pdf`
    })));
  } catch (e) { handleError(e, reply); }
}

export async function downloadInvoicePdf(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    const params = request.params as { invoiceId: string };
    const sub = await prisma.subscription.findUnique({ where: { salonId } });
    if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }

    const [invoice, salon, providerSetting] = await Promise.all([
      prisma.billingInvoice.findFirst({
        where: { id: params.invoiceId, subscriptionId: sub.id }
      }),
      prisma.salon.findUnique({ where: { id: salonId }, select: { name: true } }),
      prisma.platformSetting.findUnique({
        where: { key: salonBillingProviderKey(salonId) },
        select: { value: true }
      })
    ]);
    if (!invoice) { fail(reply, 404, "invoice_not_found", "Facture introuvable."); return; }

    const issuedAt = new Intl.DateTimeFormat("fr-FR", {
      dateStyle: "medium",
      timeStyle: "short"
    }).format(invoice.createdAt);
    const amountLabel = new Intl.NumberFormat("fr-FR").format(invoice.amountXof);
    const billingProvider = toPublicBillingProvider(providerSetting?.value ?? sub.billingProvider ?? "manual");
    const providerLabel =
      billingProvider === "manual" ? "Manuel" : "Intech";
    const pdf = await buildInvoicePdf({
      invoiceNumber: invoice.invoiceNumber,
      issuedAt,
      status: invoice.status,
      amountLabel,
      billingProvider: providerLabel,
      salonName: salon?.name ?? "Salon partenaire"
    });
    const safeNumber = invoice.invoiceNumber.replace(/[^a-zA-Z0-9._-]/g, "_");
    // nosemgrep: direct-reply-send — binary PDF buffer, content-type enforced, filename sanitized above
    reply.type("application/pdf").header("content-disposition", `attachment; filename="${safeNumber}.pdf"`).send(pdf);
  } catch (e) { handleError(e, reply); }
}
