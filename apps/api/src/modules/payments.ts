import type { FastifyReply, FastifyRequest } from "fastify";

import { paymentInitiateInputSchema } from "@beauteavenue/contracts";

import { createPaymentAdapter } from "../adapters/index.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { prisma } from "../lib/prisma.js";

const paymentAdapter = createPaymentAdapter(config.paymentDriver, {
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

      const callbackUrl = `${config.webOrigin}/payment/callback`;
      const result = await paymentAdapter.initiateDeposit({
        paymentId: payment.id,
        amountXof: payment.amountXof,
        description: `Acompte réservation ${body.bookingId}`,
        callbackUrl,
        idempotencyKey: payment.idempotencyKey
      });

      await prisma.payment.update({
        where: { id: payment.id },
        data: {
          provider: body.provider,
          providerTxId: result.providerRef,
          webhookSignature: this._extractCheckoutToken(result.redirectUrl)
        }
      });

      ok(reply, {
        paymentId: payment.id,
        redirectUrl: result.redirectUrl,
        expiresAt: result.expiresAt.toISOString()
      });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Payment error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async status(request: FastifyRequest, reply: FastifyReply) {
    try {
      requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const params = request.params as { paymentId: string };
      const payment = await prisma.payment.findUnique({ where: { id: params.paymentId } });
      if (!payment) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
      ok(reply, {
        id: payment.id,
        status: payment.status,
        amountXof: payment.amountXof,
        provider: payment.provider,
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

  async reconcile(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const params = request.params as { paymentId: string };
      const payment = await prisma.payment.findUnique({
        where: { id: params.paymentId },
        include: { booking: true }
      });
      if (!payment) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
      if (session.role === "client" && payment.booking.clientId !== session.sub) {
        fail(reply, 403, "forbidden", "Accès interdit.");
        return;
      }
      if (!payment.webhookSignature) {
        fail(reply, 422, "missing_provider_token", "Token fournisseur manquant pour la réconciliation.");
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
        provider: refreshed.provider,
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

    let event: ReturnType<typeof paymentAdapter.parseWebhook>;
    try {
      event = paymentAdapter.parseWebhook(rawBody);
    } catch (err) {
      fail(reply, 400, "invalid_payload", "Payload invalide.");
      return;
    }

    const paymentIdFromMetadata = typeof event.metadata.paymentId === "string" ? event.metadata.paymentId : null;
    const payment = paymentIdFromMetadata
      ? await prisma.payment.findUnique({
          where: { id: paymentIdFromMetadata },
          include: { booking: true }
        })
      : await prisma.payment.findFirst({
          where: { providerTxId: event.providerRef },
          include: { booking: true }
        });
    if (!payment) {
      ok(reply, { received: true });
      return;
    }

    await this._applyPaymentStatus(payment, event.status, rawBody, event.providerRef);

    ok(reply, { received: true });
  }

  async refund(request: FastifyRequest, reply: FastifyReply) {
    try {
      requireRole(request, ["salon_owner", "platform_admin"]);
      const params = request.params as { paymentId: string };
      const payment = await prisma.payment.findUnique({ where: { id: params.paymentId }, include: { booking: true } });
      if (!payment) { fail(reply, 404, "payment_not_found", "Paiement introuvable."); return; }
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
        await tx.settlementEvent.create({
          data: { bookingId: payment.bookingId, paymentId: payment.id, eventType: "refunded", amountXof: payment.amountXof, providerReference: refund.refundRef }
        });
        await tx.auditLog.create({
          data: { action: "payment_refunded", summary: `Remboursement ${payment.id}`, entityType: "Payment", entityId: payment.id, actorName: "admin", severity: "info", payloadJson: JSON.stringify(refund) }
        });
      });

      ok(reply, { refunded: true, refundRef: refund.refundRef });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Payment error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
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
        await tx.booking.update({
          where: { id: payment.bookingId },
          data: { depositPaymentStatus: "succeeded" }
        });

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
}
