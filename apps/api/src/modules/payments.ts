import type { FastifyReply, FastifyRequest } from "fastify";

import { paymentInitiateInputSchema } from "@beauteavenue/contracts";

import { createPaymentAdapter } from "../adapters/index.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { prisma } from "../lib/prisma.js";

const paymentAdapter = createPaymentAdapter(config.paymentDriver);

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
        data: { provider: body.provider, providerTxId: result.providerRef }
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

  async webhookWave(request: FastifyRequest, reply: FastifyReply) {
    await this._handleWebhook(request, reply, "x-wave-signature");
  }

  async webhookOrangeMoney(request: FastifyRequest, reply: FastifyReply) {
    await this._handleWebhook(request, reply, "x-orangemoney-signature");
  }

  private async _handleWebhook(request: FastifyRequest, reply: FastifyReply, signatureHeader: string) {
    const rawBody = JSON.stringify(request.body);
    const signature = (request.headers[signatureHeader] as string) ?? "";

    if (!paymentAdapter.verifyWebhookSignature(rawBody, signature)) {
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

    const payment = await prisma.payment.findFirst({
      where: { providerTxId: event.providerRef },
      include: { booking: true }
    });
    if (!payment) {
      ok(reply, { received: true });
      return;
    }

    // Idempotency: already processed
    if (payment.status === "succeeded") {
      ok(reply, { received: true });
      return;
    }

    const newStatus = paymentAdapter.normalizeStatus(event.providerRef ? event.status : payment.status);

    await prisma.$transaction(async (tx) => {
      await tx.payment.update({
        where: { id: payment.id },
        data: { status: newStatus, providerTxId: event.providerRef }
      });

      if (newStatus === "succeeded") {
        await tx.booking.update({
          where: { id: payment.bookingId },
          data: { depositPaymentStatus: "succeeded" }
        });

        await tx.settlementEvent.create({
          data: {
            bookingId: payment.bookingId,
            paymentId: payment.id,
            eventType: "held",
            amountXof: payment.amountXof,
            providerReference: event.providerRef
          }
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
          payloadJson: rawBody
        }
      });
    });

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
}
