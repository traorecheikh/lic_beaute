import type { FastifyReply, FastifyRequest } from "fastify";

import { paymentInitiateInputSchema, paydunyaTransactionExecuteInputSchema } from "@beauteavenue/contracts";

import { getPaymentAdapter } from "../../adapters/index.js";
import { config } from "../../config.js";
import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { sendEmail } from "../../lib/email.js";
import { fail, ok } from "../../lib/http.js";
import { enqueueJob } from "../../lib/jobs.js";
import { logger } from "../../lib/logger.js";
import { toDbProvider, toPublicGatewayProvider } from "../../lib/payment-provider.js";
import { prisma } from "../../lib/db/prisma.js";
import { buildBookingConfirmationPdf } from "../../lib/pdf.js";
import { sendNotification } from "../notifications/index.js";
import { checkWebhookReplay } from "../../lib/webhook-replay.js";

// ─── Fee helpers ────────────────────────────────────────────────────────────
const COMMISSION_CACHE_TTL = 60_000;

let _commissionCache: { value: number; expiresAt: number } | null = null;

async function getCommissionPercent(): Promise<number> {
  if (_commissionCache && _commissionCache.expiresAt > Date.now()) {
    return _commissionCache.value;
  }
  const setting = await prisma.platformSetting.findUnique({
    where: { key: "commission_rate_percent" },
    select: { value: true }
  });
  const value = parseFloat(setting?.value ?? "5");
  _commissionCache = { value, expiresAt: Date.now() + COMMISSION_CACHE_TTL };
  return value;
}

function calcFee(amountXof: number, commissionPercent: number) {
  const fee = Math.round(amountXof * commissionPercent / 100);
  return { platformFeeXof: fee, payoutAmountXof: amountXof - fee };
}

function normalizePhoneNumber(phoneNumber: string) {
  return phoneNumber.replace(/\s+/g, "").trim();
}

const WITHDRAW_MODE_MAP: Record<string, string> = {
  wave_senegal: "wave-senegal",
  orange_senegal: "orange-money-senegal",
  free_senegal: "free-money-senegal",
  wizall_senegal: "wizall-senegal"
};

const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  baseOrigin: config.webOrigin,
  paydunyaMasterKey: config.paydunyaMasterKey,
  paydunyaPublicKey: config.paydunyaPublicKey,
  paydunyaPrivateKey: config.paydunyaPrivateKey,
  paydunyaToken: config.paydunyaToken,
  paydunyaEnv: config.paydunyaEnv,
  paydunyaBaseUrl: config.paydunyaBaseUrl
});

function requiresProviderCompletion(result: { url?: string; other_url?: unknown; data?: Record<string, unknown> | undefined } & Record<string, unknown>) {
  if (result.url || result.other_url) return true;
  if (result.pendingProviderConfirmation === true || result.status === "authorized") return true;
  const message = typeof result.message === "string"
    ? result.message.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase()
    : "";
  if (
    message.includes("rediriger vers cette url") ||
    message.includes("en cours de traitement") ||
    message.includes("veuillez completer le paiement") ||
    message.includes("veuillez tapez") ||
    message.includes("compose") ||
    message.includes("valider le paiement")
  ) {
    return true;
  }
  const details = result.data && typeof result.data.details === "object" && result.data.details
    ? result.data.details as Record<string, unknown>
    : null;
  const providerStatus = typeof result.data?.status === "string" ? result.data.status.toUpperCase() : null;
  if (providerStatus === "PENDING" || providerStatus === "PROCESSING") return true;
  const cid = typeof result.data?.cid === "string" ? result.data.cid : typeof details?.cid === "string" ? details.cid : null;
  return Boolean(cid);
}

export class PaymentController {
  async initiate(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = paymentInitiateInputSchema.parse(request.body);

      let payment = await prisma.payment.findFirst({
        where: { bookingId: body.bookingId, status: "pending" },
        include: { booking: true },
        orderBy: { createdAt: "desc" }
      });

      if (!payment) {
        const existing = await prisma.payment.findFirst({
          where: { bookingId: body.bookingId, status: { in: ["authorized", "succeeded"] } },
          include: { booking: true },
          orderBy: { createdAt: "desc" }
        });
        if (existing) {
          ok(reply, {
            paymentId: existing.id,
            redirectUrl: null,
            expiresAt: null,
            status: existing.status
          });
          return;
        }
        fail(reply, 404, "payment_not_found", "Aucun paiement en attente pour cette réservation.");
        return;
      }
      if (payment.booking.clientId !== session.sub) { fail(reply, 403, "forbidden", "Accès interdit."); return; }
      const client = await prisma.user.findUnique({
        where: { id: session.sub },
        select: {
          phone: true,
          paymentMethods: {
            where: { isDefault: true },
            orderBy: { updatedAt: "desc" },
            select: { phoneNumber: true }
          }
        }
      });
      const resolvedPhone = client?.phone?.trim()
        ? normalizePhoneNumber(client.phone)
        : client?.paymentMethods?.[0]?.phoneNumber?.trim()
          ? normalizePhoneNumber(client.paymentMethods[0].phoneNumber)
          : undefined;
      if (config.paymentDriver === "paydunya" && !resolvedPhone) {
        fail(reply, 422, "phone_required", "Numéro de téléphone requis pour initier ce paiement.");
        return;
      }

      const callbackUrl = new URL("/payment/callback", config.webOrigin);
      callbackUrl.searchParams.set("paymentId", payment.id);
      callbackUrl.searchParams.set("bookingId", body.bookingId);
      const result = await paymentAdapter.initiateDeposit({
        paymentId: payment.id,
        amountXof: payment.amountXof,
        description: `Acompte réservation ${body.bookingId}`,
        callbackUrl: callbackUrl.toString(),
        idempotencyKey: payment.idempotencyKey,
        channel: body.channel,
        phone: resolvedPhone
      });

      await prisma.payment.update({
        where: { id: payment.id },
        data: {
          provider: toDbProvider(body.provider) ?? "paydunya",
          providerTxId: result.providerRef,
          webhookSignature: result.providerToken ?? this._extractCheckoutToken(result.redirectUrl)
        }
      });

      ok(reply, {
        paymentId: payment.id,
        redirectUrl: result.redirectUrl,
        expiresAt: result.expiresAt.toISOString()
      });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Payment error", { error });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async getMethods(request: FastifyRequest, reply: FastifyReply) {
    try {
      requireRole(request, ["client", "salon_owner", "salon_staff", "salon_manager", "platform_admin"]);

      if (!paymentAdapter.getAvailableMethods) {
        ok(reply, { methods: [] });
        return;
      }

      const methods = await paymentAdapter.getAvailableMethods();
      ok(reply, { methods });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Get methods error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async executePayment(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = paydunyaTransactionExecuteInputSchema.parse(request.body);

      const payment = await prisma.payment.findUnique({
        where: { id: body.paymentId },
        include: { booking: { select: { clientId: true } } }
      });
      if (!payment) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
      if (payment.booking.clientId !== session.sub) { fail(reply, 403, "forbidden", "Accès interdit."); return; }
      if (payment.status !== "pending" && payment.status !== "authorized") {
        fail(reply, 422, "invalid_status", "Ce paiement ne peut pas être exécuté.");
        return;
      }
      if (!payment.webhookSignature) {
        fail(reply, 422, "missing_invoice_token", "Token de facture manquant.");
        return;
      }

      if (!paymentAdapter.executePayment) {
        fail(reply, 501, "not_supported", "Ce fournisseur ne supporte pas l'exécution séparée.");
        return;
      }

      const result = await paymentAdapter.executePayment({
        paymentId: payment.id,
        method: body.method,
        invoiceToken: payment.webhookSignature,
        details: body.details
      });

      if (result.success) {
        const newStatus = requiresProviderCompletion(result) ? "authorized" : "succeeded";
        await this._applyPaymentStatus(
          { id: payment.id, bookingId: payment.bookingId, amountXof: payment.amountXof, status: payment.status },
          newStatus,
          JSON.stringify({ source: "execute", method: body.method }),
          result.providerTxId ?? payment.providerTxId ?? undefined
        );
      }

      ok(reply, result);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Execute payment error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async webhookPayDunya(request: FastifyRequest, reply: FastifyReply) {
    const rawBody = (request as typeof request & { rawBody?: string }).rawBody ?? JSON.stringify(request.body);

    if (!paymentAdapter.verifyWebhookSignature({ rawBody })) {
      fail(reply, 401, "invalid_signature", "Signature invalide.");
      return;
    }

    await this._handleWebhook(request, reply);
  }

  async status(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff", "salon_manager"]);
      const params = request.params as { paymentId: string };
      const payment = await prisma.payment.findUnique({
        where: { id: params.paymentId },
        include: { booking: { select: { clientId: true, salonId: true } } }
      });
      if (!payment) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
      if (!(await this._canAccessPayment(session, payment, reply))) return;
      ok(reply, {
        id: payment.id,
        status: payment.status,
        amountXof: payment.amountXof,
        provider: toPublicGatewayProvider(payment.provider),
        providerTxId: payment.providerTxId,
        createdAt: payment.createdAt.toISOString()
      });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async reconcile(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff", "salon_manager"]);
      const params = request.params as { paymentId: string };
      const payment = await prisma.payment.findUnique({
        where: { id: params.paymentId },
        include: { booking: true }
      });
      if (!payment) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
      if (!(await this._canAccessPayment(session, payment, reply))) return;
      if (!payment.webhookSignature) {
        fail(reply, 422, "missing_provider_token", "Token fournisseur manquant pour la réconciliation.");
        return;
      }

      const authorizedLongEnough = payment.status === "authorized"
        && (Date.now() - payment.updatedAt.getTime()) > 60_000;

      if (!authorizedLongEnough) {
        const guard = await this._checkReconcileWindow(payment.id);
        if (!guard.allowed) {
          fail(
            reply,
            429,
            "reconcile_throttled",
            `Réconciliation trop fréquente. Réessayez dans ${Math.ceil(guard.retryAfterMs / 1000)}s.`
          );
          return;
        }
      }

      let remoteStatus;
      try {
        remoteStatus = await paymentAdapter.fetchPaymentStatus({ providerToken: payment.webhookSignature });
      } catch (providerError) {
        const msg = String(providerError);
        const isTransient = !msg.includes("401") && !msg.includes("403") && !msg.includes("404");
        if (isTransient) {
          await new Promise((r) => setTimeout(r, 2000));
          remoteStatus = await paymentAdapter.fetchPaymentStatus({ providerToken: payment.webhookSignature });
        } else {
          throw providerError;
        }
      }

      const effectiveStatus = payment.status === "authorized" && remoteStatus === "pending"
        ? "authorized"
        : remoteStatus;

      await this._claimReconcileWindow(payment.id);
      await this._applyPaymentStatus(payment, effectiveStatus, JSON.stringify({
        source: "reconcile",
        paymentId: payment.id,
        providerToken: payment.webhookSignature
      }));

      const refreshed = await prisma.payment.findUnique({ where: { id: payment.id } });
      if (!refreshed) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
      ok(reply, {
        id: refreshed.id,
        status: refreshed.status,
        amountXof: refreshed.amountXof,
        provider: toPublicGatewayProvider(refreshed.provider),
        providerTxId: refreshed.providerTxId,
        createdAt: refreshed.createdAt.toISOString()
      });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Payment reconcile error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  private async _handleWebhook(request: FastifyRequest, reply: FastifyReply) {
    // Use raw bytes captured before JSON parsing; fall back to re-serialized body if hook missed.
    const rawBody = (request as typeof request & { rawBody?: string }).rawBody ?? JSON.stringify(request.body);
    const headers = request.headers ?? {};
    const hmacSignature = this._headerAsString(headers["hmac-signature"]);
    const hmacTimestamp = this._headerAsString(headers.timestamp);

    if (!paymentAdapter.verifyWebhookSignature({
      rawBody,
      signature: hmacSignature,
      timestamp: hmacTimestamp
    })) {
      fail(reply, 401, "invalid_signature", "Signature invalide.");
      return;
    }

    let event: ReturnType<typeof paymentAdapter.parseWebhook>;
    try {
      event = paymentAdapter.parseWebhook(rawBody);
    } catch (err) {
      logger.warn("Webhook payload rejected", { err: String(err) });
      fail(reply, 400, "invalid_payload", "Payload invalide.");
      return;
    }

    // ─── Replay protection ────────────────────────────────────────────────
    // The idempotencyKey uniquely identifies a payment initiation event.
    // If we've already processed a webhook with this key within the replay
    // window, the caller is replaying a captured request.
    const nonce = typeof event.metadata.idempotencyKey === "string"
      ? event.metadata.idempotencyKey
      : null;

    if (nonce && await checkWebhookReplay(nonce)) {
      logger.warn("Replay detected — webhook idempotencyKey already processed", { nonce });
      ok(reply, { received: true });
      return;
    }

    const paymentIdFromMetadata = typeof event.metadata.paymentId === "string" ? event.metadata.paymentId : null;
    const externalTransactionId = typeof event.metadata.externalTransactionId === "string"
      ? event.metadata.externalTransactionId
      : null;

    const fallbackWhere = externalTransactionId
      ? {
          OR: [
            { providerTxId: event.providerRef },
            { webhookSignature: externalTransactionId }
          ]
        }
      : {
          OR: [
            { providerTxId: event.providerRef },
            { webhookSignature: event.providerRef }
          ]
        };

    const paymentCandidate = paymentIdFromMetadata
      ? await prisma.payment.findUnique({
          where: { id: paymentIdFromMetadata },
          include: { booking: true }
        })
      : await prisma.payment.findFirst({
          where: fallbackWhere,
          include: { booking: true }
        });

    // When looking up by metadata.paymentId, verify the provider ref matches to prevent
    // a spoofed paymentId from attaching a callback to an unrelated record.
    const payment = paymentIdFromMetadata && paymentCandidate
      ? (paymentCandidate.providerTxId == null || paymentCandidate.providerTxId === event.providerRef ? paymentCandidate : null)
      : paymentCandidate;

    if (!payment) {
      // Fallback: subscription charge lookup
      const subChargeFallbackWhere = externalTransactionId
        ? {
            OR: [
              { providerTxId: event.providerRef },
              { providerTxId: externalTransactionId }
            ]
          }
        : { providerTxId: event.providerRef };

      const subChargeCandidate = paymentIdFromMetadata
        ? await prisma.subscriptionCharge.findUnique({
            where: { id: paymentIdFromMetadata },
            include: { subscription: true }
          })
        : await prisma.subscriptionCharge.findFirst({
            where: subChargeFallbackWhere,
            include: { subscription: true }
          });

      // Same providerRef binding check for subscription charges
      const subCharge = paymentIdFromMetadata && subChargeCandidate
        ? (subChargeCandidate.providerTxId == null || subChargeCandidate.providerTxId === event.providerRef ? subChargeCandidate : null)
        : subChargeCandidate;

      if (subCharge) {
        // Amount guard: reject if callback amount is present and diverges by more than 1 XOF (rounding)
        if (event.amountXof > 0 && Math.abs(event.amountXof - subCharge.amountXof) > 1) {
          logger.error("Webhook amount mismatch for subscriptionCharge", {
            chargeId: subCharge.id,
            expected: subCharge.amountXof,
            received: event.amountXof
          });
          fail(reply, 422, "amount_mismatch", "Montant du callback incohérent.");
          return;
        }
        await this._applySubscriptionChargeStatus(subCharge, event.status, event.providerRef, rawBody);
        ok(reply, { received: true });
        return;
      }

      ok(reply, { received: true });
      return;
    }

    // Amount guard: reject if callback amount is present and diverges by more than 1 XOF (rounding)
    if (event.amountXof > 0 && Math.abs(event.amountXof - payment.amountXof) > 1) {
      logger.error("Webhook amount mismatch for payment", {
        paymentId: payment.id,
        expected: payment.amountXof,
        received: event.amountXof
      });
      fail(reply, 422, "amount_mismatch", "Montant du callback incohérent.");
      return;
    }

    // Duplicate succeeded webhook — already processed
    if (payment.status === "succeeded" && event.status === "succeeded") {
      logger.warn("Duplicate succeeded webhook ignored", { paymentId: payment.id });
      ok(reply, { received: true });
      return;
    }

    await this._applyPaymentStatus(payment, event.status, rawBody, event.providerRef);

    ok(reply, { received: true });
  }

  async refund(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["salon_owner", "platform_admin"]);
      const params = request.params as { paymentId: string };
      const payment = await prisma.payment.findUnique({
        where: { id: params.paymentId },
        include: { booking: { select: { clientId: true, salonId: true } } }
      });
      if (!payment) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
      if (!(await this._canAccessPayment(session, payment, reply))) return;
      if (!["authorized", "succeeded"].includes(payment.status)) {
        fail(reply, 422, "not_refundable", "Ce paiement ne peut pas être remboursé.");
        return;
      }

      if (!payment.providerTxId) {
        fail(reply, 422, "no_provider_ref", "Référence fournisseur manquante.");
        return;
      }

      // Atomic claim: prevents concurrent double-refund
      const claimed = await prisma.payment.updateMany({
        where: { id: payment.id, status: { in: ["authorized", "succeeded"] } },
        data: { status: "refunded" }
      });
      if (claimed.count === 0) {
        fail(reply, 409, "already_refunded", "Ce paiement a déjà été remboursé.");
        return;
      }

      // Resolve phone number for PayDunya disbursement
      const clientPhone = await this._resolveRefundPhone(payment.bookingId);

      // Resolve method (channel) from payment metadata or booking context
      const paymentMethod = await this._resolveRefundMethod(payment.id);

      const refund = await paymentAdapter.requestRefund({
        providerRef: payment.providerTxId,
        amountXof: payment.amountXof,
        reason: "requested_refund",
        phone: clientPhone ?? undefined,
        method: paymentMethod ?? undefined,
        withdrawMode: paymentMethod ? WITHDRAW_MODE_MAP[paymentMethod] : undefined
      });

      await prisma.$transaction(async (tx) => {
        // Status already updated via atomic claim above; only persist side effects.
        await tx.booking.update({
          where: { id: payment.bookingId },
          data: { depositPaymentStatus: "refunded" }
        });
        await tx.settlementEvent.create({
          data: { bookingId: payment.bookingId, paymentId: payment.id, eventType: "refunded", amountXof: payment.amountXof, providerReference: refund.refundRef }
        });
        await tx.auditLog.create({
          data: {
            action: "payment_refunded",
            summary: `Remboursement ${payment.id}`,
            entityType: "Payment",
            entityId: payment.id,
            actorName: session.role,
            actorUserId: session.sub,
            severity: "info",
            payloadJson: JSON.stringify({
              bookingId: payment.bookingId,
              previousStatus: payment.status,
              newStatus: "refunded",
              refund
            })
          }
        });
      });

      ok(reply, { refunded: true, refundRef: refund.refundRef });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Payment error", { error });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  private async _canAccessPayment(
    session: { sub: string; role: "platform_admin" | "client" | "salon_owner" | "salon_staff" | "salon_manager" },
    payment: { booking: { clientId: string; salonId: string } },
    reply: FastifyReply
  ) {
    if (session.role === "platform_admin") return true;
    if (session.role === "client") {
      if (payment.booking.clientId !== session.sub) {
        fail(reply, 403, "forbidden", "Accès interdit.");
        return false;
      }
      return true;
    }

    const user = await prisma.user.findUnique({
      where: { id: session.sub },
      select: { salonId: true }
    });
    if (!user?.salonId || user.salonId !== payment.booking.salonId) {
      fail(reply, 403, "forbidden", "Accès interdit.");
      return false;
    }
    return true;
  }

  private async _checkReconcileWindow(paymentId: string): Promise<{ allowed: true } | { allowed: false; retryAfterMs: number }> {
    const key = `payment:reconcile:last:${paymentId}`;
    const minInterval = config.paymentReconcileMinIntervalMs;
    const now = Date.now();

    const existing = await prisma.platformSetting.findUnique({ where: { key }, select: { value: true } });
    const lastTs = existing ? Number(existing.value) : 0;
    if (Number.isFinite(lastTs) && lastTs > 0) {
      const elapsed = now - lastTs;
      if (elapsed < minInterval) {
        return { allowed: false as const, retryAfterMs: minInterval - elapsed };
      }
    }
    return { allowed: true as const };
  }

  private async _claimReconcileWindow(paymentId: string): Promise<void> {
    const key = `payment:reconcile:last:${paymentId}`;
    const now = Date.now();
    await prisma.platformSetting.upsert({
      where: { key },
      create: { group: "payment_runtime", key, value: String(now), description: `Last reconcile timestamp for payment ${paymentId}` },
      update: { value: String(now) }
    });
  }

  private _extractCheckoutToken(redirectUrl: string): string | null {
    try {
      const url = new URL(redirectUrl);
      const segments = url.pathname.split("/").filter(Boolean);
      const token = segments[segments.length - 1];
      return token?.trim().length ? token : null;
    } catch {
      return null;
    }
  }

  private _headerAsString(value: string | string[] | undefined): string | undefined {
    if (!value) return undefined;
    if (Array.isArray(value)) return value[0];
    return value;
  }

  private async _applyPaymentStatus(
    payment: {
      id: string;
      bookingId: string;
      amountXof: number;
      status: string;
    },
    newStatus: "pending" | "authorized" | "succeeded" | "failed" | "refunded",
    payloadJson: string,
    providerRefOverride?: string
  ) {
    if (payment.status === newStatus) return;

    const VALID_TRANSITIONS: Record<string, string[]> = {
      pending: ["authorized", "succeeded", "failed"],
      authorized: ["succeeded", "failed", "refunded"],
      succeeded: ["refunded"],
      failed: [],
      refunded: [],
    };
    if (!VALID_TRANSITIONS[payment.status]?.includes(newStatus)) {
      logger.warn("Blocked invalid payment transition", { from: payment.status, to: newStatus, paymentId: payment.id });
      return;
    }

    type AutoConfirmedMeta = { bookingId: string; startsAt: Date; clientId: string; clientEmail: string | null; serviceName: string };
    const autoConfirmedCapture: AutoConfirmedMeta[] = [];

    await prisma.$transaction(async (tx) => {
      await tx.payment.update({
        where: { id: payment.id },
        data: {
          status: newStatus,
          providerTxId: providerRefOverride ?? undefined
        }
      });

      if (newStatus === "authorized" || newStatus === "succeeded") {
        const booking = await tx.booking.findUnique({
          where: { id: payment.bookingId },
          select: {
            status: true,
            startsAt: true,
            clientId: true,
            client: { select: { email: true } },
            service: { select: { name: true } }
          }
        });
        const shouldAutoConfirm = newStatus === "succeeded" && booking?.status === "pending";

        await tx.booking.update({
          where: { id: payment.bookingId },
          data: {
            depositPaymentStatus: newStatus,
            ...(shouldAutoConfirm ? { status: "confirmed" } : {})
          }
        });

        if (shouldAutoConfirm) {
          await tx.bookingEvent.create({
            data: {
              bookingId: payment.bookingId,
              eventType: "auto_confirmed_after_payment",
              fromStatus: "pending",
              toStatus: "confirmed",
              payloadJson: JSON.stringify({ paymentId: payment.id })
            }
          });
          if (booking) {
            autoConfirmedCapture.push({
              bookingId: payment.bookingId,
              startsAt: booking.startsAt,
              clientId: booking.clientId,
              clientEmail: booking.client.email,
              serviceName: booking.service.name
            });
          }
        }

        if (newStatus === "succeeded") {
          const existingSettlement = await tx.settlementEvent.findFirst({
            where: {
              paymentId: payment.id,
              eventType: "held"
            }
          });
          if (!existingSettlement) {
            const commissionPercent = await getCommissionPercent();
            const { platformFeeXof, payoutAmountXof } = calcFee(payment.amountXof, commissionPercent);
            await tx.settlementEvent.create({
              data: {
                bookingId: payment.bookingId,
                paymentId: payment.id,
                eventType: "held",
                amountXof: payment.amountXof,
                platformFeeXof,
                payoutAmountXof,
                providerReference: providerRefOverride
              }
            });
          }
        }
      } else if (newStatus === "failed" || newStatus === "refunded") {
        await tx.booking.update({
          where: { id: payment.bookingId },
          data: { depositPaymentStatus: newStatus }
        });
      }

      await tx.auditLog.create({
        data: {
          action: "payment_webhook",
          summary: `Payment ${payment.id} → ${newStatus}`,
          entityType: "Payment",
          entityId: payment.id,
          actorName: "webhook",
          severity: "info",
          payloadJson
        }
      });
    });

    const autoConfirmedMeta = autoConfirmedCapture[0];
    if (autoConfirmedMeta) {
      const meta = autoConfirmedMeta;
      const runAfter24h = new Date(meta.startsAt.getTime() - 24 * 60 * 60 * 1000);
      const runAfter1h = new Date(meta.startsAt.getTime() - 60 * 60 * 1000);
      const now = Date.now();
      if (runAfter24h.getTime() > now) {
        await enqueueJob({ type: "booking_reminder", payload: { bookingId: meta.bookingId, window: "24h" }, bookingId: meta.bookingId, runAfter: runAfter24h });
      }
      if (runAfter1h.getTime() > now) {
        await enqueueJob({ type: "booking_reminder", payload: { bookingId: meta.bookingId, window: "1h" }, bookingId: meta.bookingId, runAfter: runAfter1h });
      }

      await sendNotification(meta.clientId, "Réservation confirmée", `Votre RDV pour ${meta.serviceName} est confirmé.`).catch((err) =>
        logger.warn("[PAYMENT] push notification failed", { clientId: meta.clientId, err })
      );

      if (meta.clientEmail) {
        try {
          const booking = await prisma.booking.findUnique({
            where: { id: meta.bookingId },
            include: { salon: { select: { name: true } }, service: { select: { name: true, priceXof: true } }, client: { select: { fullName: true } } }
          });
          const pdf = booking ? await buildBookingConfirmationPdf({
            salonName: booking.salon.name,
            serviceName: booking.service.name,
            clientName: booking.client.fullName,
            startsAt: booking.startsAt.toLocaleString("fr-FR"),
            endsAt: booking.endsAt.toLocaleString("fr-FR"),
            depositAmountXof: booking.depositAmountXof,
            totalAmountXof: booking.service.priceXof,
            bookingId: booking.id,
            status: "Confirmée"
          }) : undefined;

          const { buildEmailHtml } = await import("../../lib/email-html.js");
          await sendEmail({
            to: meta.clientEmail,
            subject: "Votre réservation est confirmée | Beauté Avenue",
            text: `Bonjour,\n\nVotre réservation pour "${meta.serviceName}" est confirmée.\n\nÀ très bientôt sur BeautéAvenue.`,
            html: buildEmailHtml({
              preheader: "Réservation confirmée",
              greeting: "Bonjour,",
              bodyLines: [
                `Votre réservation pour <strong>${meta.serviceName}</strong> est confirmée.`
              ],
              ignoreNote: false,
              footerNote: "À très bientôt sur BeautéAvenue."
            }),
            attachments: pdf ? [{ filename: `confirmation-${meta.bookingId.slice(0, 8)}.pdf`, content: pdf, contentType: "application/pdf" }] : undefined
          }).catch((err) => logger.warn("[PAYMENT] confirmation email failed", { to: meta.clientEmail, err }));
        } catch (err) {
          logger.warn("[PAYMENT] confirmation email with PDF failed", { to: meta.clientEmail, err });
        }
      }
    }
  }

  private async _applySubscriptionChargeStatus(
    charge: {
      id: string;
      subscriptionId: string;
      amountXof: number;
      status: string;
      chargeType: string;
    },
    newStatus: "pending" | "authorized" | "succeeded" | "failed" | "refunded",
    providerRef: string | undefined,
    payloadJson: string
  ) {
    if (charge.status === newStatus) return;
    if (charge.status === "refunded") return;

    // Capture owner contact before transaction for email notification
    let ownerContact: { email: string | null; fullName: string | null; salonName: string | null } = { email: null, fullName: null, salonName: null };
    try {
      const sub = await prisma.subscription.findUnique({
        where: { id: charge.subscriptionId },
        select: {
          salon: { select: { id: true, name: true } },
          tier: true
        }
      });
      if (sub) {
        const owner = await prisma.user.findFirst({
          where: { salonId: sub.salon.id, role: "salon_owner" },
          select: { email: true, fullName: true }
        });
        if (owner) {
          ownerContact = { email: owner.email, fullName: owner.fullName, salonName: sub.salon?.name ?? null };
        }
      }
    } catch {
      // Email is non-critical; continue processing
    }

    await prisma.$transaction(async (tx) => {
      await tx.subscriptionCharge.update({
        where: { id: charge.id },
        data: { status: newStatus, ...(providerRef ? { providerTxId: providerRef } : {}) }
      });

      if (newStatus === "succeeded") {
        const invoice = await tx.billingInvoice.create({
          data: {
            subscriptionId: charge.subscriptionId,
            invoiceNumber: `INV-SUB-${charge.id.slice(0, 8).toUpperCase()}`,
            amountXof: charge.amountXof,
            status: "paid"
          }
        });

        await tx.subscriptionCharge.update({
          where: { id: charge.id },
          data: { invoiceId: invoice.id }
        });

        const sub = await tx.subscription.findUnique({
          where: { id: charge.subscriptionId },
          select: { salonId: true, expiresAt: true }
        });

        // Extend from current expiresAt (not now) to preserve already-paid time on early renewal
        const baseDate = sub?.expiresAt && sub.expiresAt > new Date() ? sub.expiresAt : new Date();
        const isUpgrade = charge.chargeType === "upgrade";

        await tx.subscription.update({
          where: { id: charge.subscriptionId },
          data: {
            ...(isUpgrade ? { tier: "premium" } : {}),
            status: "active",
            expiresAt: charge.chargeType === "renewal"
              ? new Date(baseDate.getTime() + 30 * 24 * 60 * 60 * 1000)
              : undefined
          }
        });

        // Reactivate salon distribution flags on successful subscription payment.
        // Also sync tier on upgrade to prevent entitlement split-brain.
        if (sub?.salonId) {
          await tx.salon.update({
            where: { id: sub.salonId },
            data: {
              ...(isUpgrade ? { subscriptionTier: "premium" } : {}),
              isVisibleInMarketplace: true,
              canReceiveBookings: true
            }
          });
        }
      }

      await tx.auditLog.create({
        data: {
          action: "subscription_charge_webhook",
          summary: `SubscriptionCharge ${charge.id} → ${newStatus}`,
          entityType: "SubscriptionCharge",
          entityId: charge.id,
          actorName: "webhook",
          severity: "info",
          payloadJson
        }
      });
    });

    // Send email notification after transaction completes
    if (ownerContact.email) {
      const ownerName = ownerContact.fullName ?? "";
      const salonName = ownerContact.salonName ?? "Votre salon";
      const { buildEmailHtml } = await import("../../lib/email-html.js");
      const amountLabel = (charge.amountXof / 100).toLocaleString("fr-FR");

      if (newStatus === "succeeded") {
        const chargeTypeLabel = charge.chargeType === "upgrade" ? "Passage Premium" : "Renouvellement";
        await sendEmail({
          to: ownerContact.email,
          subject: "Paiement abonnement confirmé | Beauté Avenue",
          text:
            `Bonjour ${ownerName},\n\n` +
            `Le paiement de votre abonnement pour "${salonName}" a été confirmé.\n` +
            `Type: ${chargeTypeLabel}\n` +
            `Montant: ${amountLabel} FCFA\n\n` +
            `Consultez votre espace pro pour suivre votre abonnement.\n\n` +
            `L'équipe Beauté Avenue`,
          html: buildEmailHtml({
            preheader: "Paiement confirmé",
            greeting: `Bonjour ${ownerName},`,
            bodyLines: [
              `Le paiement de votre abonnement pour <strong>${salonName}</strong> a été confirmé.`,
              `<strong>Type :</strong> ${chargeTypeLabel}`,
              `<strong>Montant :</strong> ${amountLabel} FCFA`
            ],
            cta: { url: `${config.webOrigin}/pro/billing`, label: "Voir mon abonnement" },
            ignoreNote: false,
            footerNote: "L'équipe Beauté Avenue"
          })
        }).catch((err) =>
          logger.warn("_applySubscriptionChargeStatus: success email failed", {
            err: String(err), chargeId: charge.id
          })
        );
      } else if (newStatus === "failed") {
        await sendEmail({
          to: ownerContact.email,
          subject: "Paiement abonnement échoué | Beauté Avenue",
          text:
            `Bonjour ${ownerName},\n\n` +
            `Le paiement de votre abonnement pour "${salonName}" a échoué.\n` +
            `Montant: ${amountLabel} FCFA\n\n` +
            `Veuillez réessayer depuis votre espace abonnement.\n\n` +
            `L'équipe Beauté Avenue`,
          html: buildEmailHtml({
            preheader: "Paiement échoué",
            greeting: `Bonjour ${ownerName},`,
            bodyLines: [
              `Le paiement de votre abonnement pour <strong>${salonName}</strong> a échoué.`,
              `<strong>Montant :</strong> ${amountLabel} FCFA`,
              `Veuillez réessayer depuis votre espace abonnement.`
            ],
            cta: { url: `${config.webOrigin}/pro/billing`, label: "Réessayer" },
            ignoreNote: false,
            footerNote: "L'équipe Beauté Avenue"
          })
        }).catch((err) =>
          logger.warn("_applySubscriptionChargeStatus: failure email failed", {
            err: String(err), chargeId: charge.id
          })
        );
      }
    }
  }

  private async _resolveRefundPhone(bookingId: string): Promise<string | null> {
    try {
      const booking = await prisma.booking.findUnique({
        where: { id: bookingId },
        select: { client: { select: { phone: true } } }
      });
      return booking?.client?.phone ?? null;
    } catch {
      return null;
    }
  }

  private async _resolveRefundMethod(paymentId: string): Promise<string | null> {
    try {
      const payment = await prisma.payment.findUnique({
        where: { id: paymentId },
        select: { provider: true }
      });
      return null;
    } catch {
      return null;
    }
  }

  async webhookPayDunyaPayout(request: FastifyRequest, reply: FastifyReply) {
    logger.info("[PAYOUT-WEBHOOK] received callback", { headers: request.headers });

    // Validate content type
    const contentType = request.headers["content-type"] ?? "";
    if (!contentType.includes("application/json") && !contentType.includes("text/plain")) {
      logger.warn("[PAYOUT-WEBHOOK] unsupported content-type", { contentType });
      reply.status(415).send({ error: "unsupported_media_type" });
      return;
    }

    // Validate payload size (max 100KB)
    const rawBody = (request as any).rawBody ?? JSON.stringify(request.body);
    if (rawBody.length > 102400) {
      logger.warn("[PAYOUT-WEBHOOK] oversized payload rejected", { size: rawBody.length });
      reply.status(413).send({ error: "payload_too_large" });
      return;
    }

    let payload: Record<string, any> = {};
    try {
      payload = typeof request.body === "string" ? JSON.parse(request.body) : (request.body as Record<string, any>) ?? {};
    } catch (err) {
      logger.warn("[PAYOUT-WEBHOOK] failed to parse body JSON", { body: request.body });
      reply.status(400).send({ error: "bad_json" });
      return;
    }

    // Validate payload keys - reject if neither disburse_id nor token present
    if (typeof payload !== "object" || Array.isArray(payload)) {
      logger.warn("[PAYOUT-WEBHOOK] invalid payload type");
      reply.status(400).send({ error: "invalid_payload" });
      return;
    }

    const disburseId = typeof payload.disburse_id === "string" ? payload.disburse_id : null;
    const token = typeof payload.token === "string" ? payload.token : (typeof payload.disburse_token === "string" ? payload.disburse_token : null);

    if (!disburseId && !token) {
      logger.warn("[PAYOUT-WEBHOOK] callback missing identifiers", { keys: Object.keys(payload) });
      reply.status(400).send({ error: "missing_identifiers" });
      return;
    }

    // If both identifiers are present, verify they reference the same payout
    // to prevent crafted callbacks from mutating a different payout via OR lookup.
    let payout;
    if (disburseId && token) {
      payout = await prisma.merchantPayout.findFirst({
        where: { disburseId, disburseToken: token }
      });
    } else {
      payout = await prisma.merchantPayout.findFirst({
        where: {
          OR: [
            disburseId ? { disburseId } : null,
            token ? { disburseToken: token } : null
          ].filter(Boolean) as any
        }
      });
    }

    if (!payout) {
      logger.warn("[PAYOUT-WEBHOOK] payout not found for callback", { disburseId, token });
      reply.status(200).send({ ok: false, message: "payout_not_found" });
      return;
    }

    logger.info("[PAYOUT-WEBHOOK] found matching payout, triggering status reconciliation", {
      payoutId: payout.id,
      disburseId: payout.disburseId
    });

    try {
      const { reconcilePayoutStatus } = await import("../../lib/payout-service.js");
      await reconcilePayoutStatus(payout.id);
    } catch (err) {
      logger.error("[PAYOUT-WEBHOOK] reconciliation failed", { payoutId: payout.id, error: String(err) });
    }

    reply.status(200).send({ ok: true });
  }
}
