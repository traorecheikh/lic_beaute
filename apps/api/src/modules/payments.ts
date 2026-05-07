import type { FastifyReply, FastifyRequest } from "fastify";

import { paymentInitiateInputSchema } from "@beauteavenue/contracts";

import { getPaymentAdapter } from "../adapters/index.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { toDbProvider, toPublicGatewayProvider } from "../lib/payment-provider.js";
import { prisma } from "../lib/prisma.js";

const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  intechApiKey: config.intechApiKey,
  intechApiSecret: config.intechApiSecret,
  intechEnv: config.intechEnv,
  intechBaseUrl: config.intechBaseUrl,
  intechCallbackHmacEnabled: config.intechCallbackHmacEnabled,
  intechHmacSecretKey: config.intechHmacSecretKey,
  intechHmacMaxAgeMs: config.intechHmacMaxAgeMs,
  intechRequestTimeoutMs: config.intechRequestTimeoutMs,
  paytechApiKey: config.paytechApiKey,
  paytechApiSecret: config.paytechApiSecret,
  paytechEnv: config.paytechEnv,
  baseOrigin: config.webOrigin
});

export class PaymentController {
  async initiate(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = paymentInitiateInputSchema.parse(request.body);

      const payment = await prisma.payment.findFirst({
        where: { bookingId: body.bookingId, status: "pending" },
        include: { booking: true }
      });
      if (!payment) { fail(reply, 404, "payment_not_found", "Aucun paiement en attente pour cette réservation."); return; }
      if (payment.booking.clientId !== session.sub) { fail(reply, 403, "forbidden", "Accès interdit."); return; }
      const client = await prisma.user.findUnique({
        where: { id: session.sub },
        select: { phone: true }
      });
      if (config.paymentDriver === "intech" && !client?.phone) {
        fail(reply, 422, "phone_required", "Numéro de téléphone requis pour initier ce paiement.");
        return;
      }

      const callbackUrl = `${config.webOrigin}/payment/callback`;
      const result = await paymentAdapter.initiateDeposit({
        paymentId: payment.id,
        amountXof: payment.amountXof,
        description: `Acompte réservation ${body.bookingId}`,
        callbackUrl,
        idempotencyKey: payment.idempotencyKey,
        channel: body.channel,
        phone: client?.phone ?? undefined
      });

      await prisma.payment.update({
        where: { id: payment.id },
        data: {
          provider: toDbProvider(body.provider) ?? "intech",
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

  async status(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
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

  async webhookPayTech(request: FastifyRequest, reply: FastifyReply) {
    await this._handleWebhook(request, reply);
  }

  async webhookIntech(request: FastifyRequest, reply: FastifyReply) {
    await this._handleWebhook(request, reply);
  }

  async reconcile(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
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

      const guard = await this._claimReconcileWindow(payment.id);
      if (!guard.allowed) {
        fail(
          reply,
          429,
          "reconcile_throttled",
          `Réconciliation trop fréquente. Réessayez dans ${Math.ceil(guard.retryAfterMs / 1000)}s.`
        );
        return;
      }

      const remoteStatus = await paymentAdapter.fetchPaymentStatus({ providerToken: payment.webhookSignature });
      await this._applyPaymentStatus(payment, remoteStatus, JSON.stringify({
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
    const rawBody = JSON.stringify(request.body);
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
      fail(reply, 400, "invalid_payload", "Payload invalide.");
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

    const payment = paymentIdFromMetadata
      ? await prisma.payment.findUnique({
          where: { id: paymentIdFromMetadata },
          include: { booking: true }
        })
      : await prisma.payment.findFirst({
          where: fallbackWhere,
          include: { booking: true }
        });
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

      const subCharge = paymentIdFromMetadata
        ? await prisma.subscriptionCharge.findUnique({
            where: { id: paymentIdFromMetadata },
            include: { subscription: true }
          })
        : await prisma.subscriptionCharge.findFirst({
            where: subChargeFallbackWhere,
            include: { subscription: true }
          });

      if (subCharge) {
        await this._applySubscriptionChargeStatus(subCharge, event.status, event.providerRef, rawBody);
        ok(reply, { received: true });
        return;
      }

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

      const refund = await paymentAdapter.requestRefund({
        providerRef: payment.providerTxId,
        amountXof: payment.amountXof,
        reason: "requested_refund"
      });

      await prisma.$transaction(async (tx) => {
        await tx.payment.update({ where: { id: payment.id }, data: { status: "refunded" } });
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
    session: { sub: string; role: "platform_admin" | "client" | "salon_owner" | "salon_staff" },
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

  private async _claimReconcileWindow(paymentId: string): Promise<{ allowed: true } | { allowed: false; retryAfterMs: number }> {
    const key = `payment:reconcile:last:${paymentId}`;
    const now = Date.now();

    const existing = await prisma.platformSetting.findUnique({
      where: { key },
      select: { value: true }
    });

    const lastTs = existing ? Number(existing.value) : 0;
    if (Number.isFinite(lastTs) && lastTs > 0) {
      const elapsed = now - lastTs;
      if (elapsed < config.paymentReconcileMinIntervalMs) {
        return { allowed: false, retryAfterMs: config.paymentReconcileMinIntervalMs - elapsed };
      }
    }

    await prisma.platformSetting.upsert({
      where: { key },
      create: {
        group: "payment_runtime",
        key,
        value: String(now),
        description: `Last reconcile timestamp for payment ${paymentId}`
      },
      update: { value: String(now) }
    });

    return { allowed: true };
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
    if (payment.status === "refunded") return;

    await prisma.$transaction(async (tx) => {
      await tx.payment.update({
        where: { id: payment.id },
        data: {
          status: newStatus,
          providerTxId: providerRefOverride ?? undefined
        }
      });

      if (newStatus === "succeeded") {
        const booking = await tx.booking.findUnique({
          where: { id: payment.bookingId },
          select: { status: true, source: true }
        });
        const shouldAutoConfirm = booking?.status === "pending" && booking.source === "marketplace";

        await tx.booking.update({
          where: { id: payment.bookingId },
          data: {
            depositPaymentStatus: "succeeded",
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
        }

        const existingSettlement = await tx.settlementEvent.findFirst({
          where: {
            paymentId: payment.id,
            eventType: "held"
          }
        });
        if (!existingSettlement) {
          await tx.settlementEvent.create({
            data: {
              bookingId: payment.bookingId,
              paymentId: payment.id,
              eventType: "held",
              amountXof: payment.amountXof,
              providerReference: providerRefOverride
            }
          });
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

        await tx.subscription.update({
          where: { id: charge.subscriptionId },
          data: {
            tier: "premium",
            status: "active",
            expiresAt: charge.chargeType === "renewal"
              ? new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
              : undefined
          }
        });
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
  }
}
