import type { FastifyReply, FastifyRequest } from "fastify";
import { z } from "zod";

import { config } from "../../config.js";
import { prisma } from "../../lib/db/prisma.js";
import { requireRole } from "../../lib/auth/index.js";
import { sendEmail } from "../../lib/email.js";
import { buildEmailHtml } from "../../lib/email-html.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { logger } from "../../lib/logger.js";
import { sendNotification } from "../notifications/index.js";
import { reconcilePayoutStatus, submitPayout } from "../../lib/payout-service.js";

const adminPayoutActionSchema = z.object({
  reason: z.string().min(5, "Un motif de 5 caractères minimum est requis.")
});

function maskPhone(phone: string): string {
  const normalized = phone.replace(/[\s+\-()]/g, "");
  if (normalized.length <= 4) return normalized;
  return `${normalized.slice(0, 3)}*****${normalized.slice(-4)}`;
}

const payoutVerificationQueueQuerySchema = z.object({
  search: z.string().trim().optional(),
  status: z.enum(["unverified", "rejected", "all"]).optional()
});

export async function listPayoutVerificationQueue(request: FastifyRequest, reply: FastifyReply) {
  try {
    requireRole(request, ["platform_admin"]);
    const query = payoutVerificationQueueQuerySchema.parse(request.query ?? {});
    const statuses =
      query.status === "all" ? ["unverified", "rejected"] : [query.status ?? "unverified"];

    const salons = await prisma.salon.findMany({
      where: {
        payoutPhone: { not: null },
        payoutMethod: { not: null },
        payoutVerificationStatus: { in: statuses },
        ...(query.search
          ? {
              OR: [
                { name: { contains: query.search, mode: "insensitive" } },
                { payoutName: { contains: query.search, mode: "insensitive" } },
                { payoutPhone: { contains: query.search.replace(/\D/g, "") } },
                {
                  staffMembers: {
                    some: {
                      role: "salon_owner",
                      OR: [
                        { fullName: { contains: query.search, mode: "insensitive" } },
                        { email: { contains: query.search, mode: "insensitive" } }
                      ]
                    }
                  }
                }
              ]
            }
          : {})
      },
      select: {
        id: true,
        name: true,
        city: true,
        payoutMethod: true,
        payoutPhone: true,
        payoutName: true,
        payoutVerificationStatus: true,
        payoutVerifiedAt: true,
        updatedAt: true,
        staffMembers: {
          where: { role: "salon_owner" },
          select: { id: true, fullName: true, email: true },
          take: 1
        },
        merchantPayouts: {
          select: { id: true, status: true, safeFailureMessage: true },
          orderBy: { createdAt: "desc" }
        }
      },
      orderBy: [{ payoutVerificationStatus: "asc" }, { updatedAt: "desc" }]
    });

    ok(
      reply,
      salons.map((salon) => {
        const blockedPayouts = salon.merchantPayouts.filter((payout) => payout.status === "blocked");
        const payoutsBlockedForVerification = blockedPayouts.filter(
          (payout) =>
            payout.safeFailureMessage === "salon_payout_details_unverified" ||
            payout.safeFailureMessage === "Coordonnées de paiement modifiées"
        );

        return {
          salonId: salon.id,
          salonName: salon.name,
          city: salon.city,
          ownerUserId: salon.staffMembers[0]?.id ?? null,
          ownerName: salon.staffMembers[0]?.fullName ?? "—",
          ownerEmail: salon.staffMembers[0]?.email ?? null,
          payoutMethod: salon.payoutMethod,
          payoutPhoneMasked: salon.payoutPhone ? maskPhone(salon.payoutPhone) : null,
          payoutName: salon.payoutName,
          payoutVerificationStatus: salon.payoutVerificationStatus,
          payoutVerifiedAt: salon.payoutVerifiedAt?.toISOString() ?? null,
          updatedAt: salon.updatedAt.toISOString(),
          blockedPayoutCount: blockedPayouts.length,
          blockedForVerificationCount: payoutsBlockedForVerification.length,
          totalPayoutCount: salon.merchantPayouts.length
        };
      })
    );
  } catch (e) {
    handleError(e, reply);
  }
}

export async function listPayouts(request: FastifyRequest, reply: FastifyReply) {
  try {
    const session = requireRole(request, ["platform_admin"]);
    const query = request.query as {
      status?: string;
      salonId?: string;
      provider?: string;
      dateFrom?: string;
      dateTo?: string;
    };

    const where: any = {};
    if (query.status) {
      where.status = query.status;
    }
    if (query.salonId) {
      where.salonId = query.salonId;
    }
    if (query.dateFrom || query.dateTo) {
      where.createdAt = {};
      if (query.dateFrom) {
        where.createdAt.gte = new Date(query.dateFrom);
      }
      if (query.dateTo) {
        where.createdAt.lte = new Date(query.dateTo);
      }
    }

    const payouts = await prisma.merchantPayout.findMany({
      where,
      orderBy: { createdAt: "desc" },
      include: {
        salon: { select: { name: true } },
        booking: { select: { id: true, startsAt: true } }
      }
    });

    ok(reply, payouts.map((p) => ({
      id: p.id,
      salonId: p.salonId,
      salonName: p.salon.name,
      bookingId: p.bookingId,
      bookingStartsAt: p.booking?.startsAt.toISOString() ?? null,
      payoutMethod: p.payoutMethod,
      beneficiaryPhoneMasked: maskPhone(p.beneficiaryPhoneSnapshot),
      beneficiaryName: p.beneficiaryNameSnapshot,
      grossAmount: p.grossAmount,
      platformCommission: p.platformCommissionAmount,
      payoutAmount: p.merchantPayoutAmount,
      status: p.status,
      attemptCount: p.attemptCount,
      createdAt: p.createdAt.toISOString(),
      completedAt: p.completedAt?.toISOString() ?? null
    })));
  } catch (e) {
    handleError(e, reply);
  }
}

export async function payoutDetail(request: FastifyRequest, reply: FastifyReply) {
  try {
    const session = requireRole(request, ["platform_admin"]);
    const params = request.params as { payoutId: string };

    const payout = await prisma.merchantPayout.findUnique({
      where: { id: params.payoutId },
      include: {
        salon: { select: { name: true, payoutVerificationStatus: true, isSuspended: true } },
        booking: {
          select: {
            id: true,
            startsAt: true,
            status: true,
            depositPaymentStatus: true
          }
        },
        payment: { select: { id: true, provider: true, status: true, amountXof: true } }
      }
    });

    if (!payout) {
      fail(reply, 404, "payout_not_found", "Règlement introuvable.");
      return;
    }

    // Fetch audit logs related to this payout or booking
    const auditLogs = await prisma.auditLog.findMany({
      where: {
        OR: [
          { entityId: payout.id, entityType: "MerchantPayout" },
          payout.bookingId ? { entityId: payout.bookingId, entityType: "Booking" } : null
        ].filter(Boolean) as any
      },
      orderBy: { createdAt: "desc" }
    });

    ok(reply, {
      payout: {
        id: payout.id,
        salonId: payout.salonId,
        salonName: payout.salon.name,
        bookingId: payout.bookingId,
        bookingStartsAt: payout.booking?.startsAt.toISOString() ?? null,
        payoutMethod: payout.payoutMethod,
        beneficiaryPhoneMasked: maskPhone(payout.beneficiaryPhoneSnapshot),
        beneficiaryName: payout.beneficiaryNameSnapshot,
        grossAmount: payout.grossAmount,
        platformCommission: payout.platformCommissionAmount,
        payoutAmount: payout.merchantPayoutAmount,
        collectionFee: payout.collectionFeeAmount,
        payoutFee: payout.payoutFeeAmount,
        status: payout.status,
        attemptCount: payout.attemptCount,
        nextRetryTime: payout.nextRetryTime?.toISOString() ?? null,
        failureCategory: payout.failureCategory,
        failureCode: payout.failureCode,
        safeFailureMessage: payout.safeFailureMessage,
        disburseToken: payout.disburseToken,
        disburseId: payout.disburseId,
        transactionId: payout.transactionId,
        providerRef: payout.providerRef,
        providerDisburseTxId: payout.providerDisburseTxId,
        eligibleAt: payout.eligibleAt?.toISOString() ?? null,
        initiatedAt: payout.initiatedAt?.toISOString() ?? null,
        submittedAt: payout.submittedAt?.toISOString() ?? null,
        completedAt: payout.completedAt?.toISOString() ?? null,
        failedAt: payout.failedAt?.toISOString() ?? null,
        cancelledAt: payout.cancelledAt?.toISOString() ?? null,
        lastReconciledAt: payout.lastReconciledAt?.toISOString() ?? null,
        createdAt: payout.createdAt.toISOString(),
        updatedAt: payout.updatedAt.toISOString(),
        commissionSnapshot: {
          type: payout.commissionType,
          configuredValue: payout.commissionConfiguredValue,
          baseAmount: payout.commissionBaseAmount,
          calculatedAmount: payout.commissionCalculatedAmount,
          roundingMethod: payout.commissionRoundingMethod,
          policyVersion: payout.policyVersion,
          feeResponsibilityPolicy: payout.feeResponsibilityPolicy
        }
      },
      auditLogs: auditLogs.map((log) => ({
        id: log.id,
        action: log.action,
        summary: log.summary,
        actorName: log.actorName,
        createdAt: log.createdAt.toISOString(),
        severity: log.severity
      }))
    });
  } catch (e) {
    handleError(e, reply);
  }
}

export async function reconcilePayout(request: FastifyRequest, reply: FastifyReply) {
  try {
    const session = requireRole(request, ["platform_admin"]);
    const params = request.params as { payoutId: string };

    const payout = await prisma.merchantPayout.findUnique({
      where: { id: params.payoutId }
    });

    if (!payout) {
      fail(reply, 404, "payout_not_found", "Règlement introuvable.");
      return;
    }

    if (!payout.disburseToken) {
      fail(reply, 400, "not_submitted", "Ce règlement n'a pas encore de token PayDunya de disbursement.");
      return;
    }

    await reconcilePayoutStatus(payout.id);

    const updated = await prisma.merchantPayout.findUnique({
      where: { id: payout.id }
    });

    ok(reply, {
      status: updated?.status,
      lastReconciledAt: updated?.lastReconciledAt?.toISOString()
    });
  } catch (e) {
    handleError(e, reply);
  }
}

export async function retryPayoutEndpoint(request: FastifyRequest, reply: FastifyReply) {
  try {
    const session = requireRole(request, ["platform_admin"]);
    const params = request.params as { payoutId: string };
    const body = adminPayoutActionSchema.parse(request.body);

    const payout = await prisma.merchantPayout.findUnique({
      where: { id: params.payoutId }
    });

    if (!payout) {
      fail(reply, 404, "payout_not_found", "Règlement introuvable.");
      return;
    }

    if (payout.status === "succeeded") {
      fail(reply, 400, "already_succeeded", "Ce règlement a déjà réussi.");
      return;
    }

    await prisma.$transaction(async (tx) => {
      await tx.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: "scheduled",
          attemptCount: payout.attemptCount + 1,
          failureCategory: null,
          failureCode: null,
          safeFailureMessage: null
        }
      });

      await tx.auditLog.create({
        data: {
          action: "admin_retry_payout",
          summary: `Relance manuelle du règlement ${payout.id}. Motif: ${body.reason}`,
          entityType: "MerchantPayout",
          entityId: payout.id,
          actorName: "Administrateur",
          actorUserId: session.sub,
          severity: "info",
          payloadJson: JSON.stringify({ reason: body.reason, oldStatus: payout.status })
        }
      });
    });

    // Execute immediately in background
    submitPayout(payout.id).catch((err) =>
      logger.error("[payout-retry] submitPayout async failed", { payoutId: payout.id, error: String(err) })
    );

    ok(reply, { queued: true });
  } catch (e) {
    handleError(e, reply);
  }
}

export async function approvePayoutEndpoint(request: FastifyRequest, reply: FastifyReply) {
  try {
    const session = requireRole(request, ["platform_admin"]);
    const params = request.params as { payoutId: string };
    const body = adminPayoutActionSchema.parse(request.body);

    const payout = await prisma.merchantPayout.findUnique({
      where: { id: params.payoutId }
    });

    if (!payout) {
      fail(reply, 404, "payout_not_found", "Règlement introuvable.");
      return;
    }

    if (payout.status !== "blocked" && payout.status !== "manual_review") {
      fail(reply, 400, "invalid_status", "Seuls les règlements bloqués ou en revue manuelle peuvent être approuvés.");
      return;
    }

    await prisma.$transaction(async (tx) => {
      await tx.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: "scheduled",
          failureCategory: null,
          failureCode: null,
          safeFailureMessage: null
        }
      });

      await tx.auditLog.create({
        data: {
          action: "admin_approve_payout",
          summary: `Approbation manuelle du règlement bloqué ${payout.id}. Motif: ${body.reason}`,
          entityType: "MerchantPayout",
          entityId: payout.id,
          actorName: "Administrateur",
          actorUserId: session.sub,
          severity: "info",
          payloadJson: JSON.stringify({ reason: body.reason, oldStatus: payout.status })
        }
      });
    });

    // Submit immediately in background
    submitPayout(payout.id).catch((err) =>
      logger.error("[payout-approve] submitPayout async failed", { payoutId: payout.id, error: String(err) })
    );

    ok(reply, { approved: true });
  } catch (e) {
    handleError(e, reply);
  }
}

export async function cancelPayoutEndpoint(request: FastifyRequest, reply: FastifyReply) {
  try {
    const session = requireRole(request, ["platform_admin"]);
    const params = request.params as { payoutId: string };
    const body = adminPayoutActionSchema.parse(request.body);

    const payout = await prisma.merchantPayout.findUnique({
      where: { id: params.payoutId }
    });

    if (!payout) {
      fail(reply, 404, "payout_not_found", "Règlement introuvable.");
      return;
    }

    if (payout.status === "succeeded") {
      fail(reply, 400, "already_succeeded", "Impossible d'annuler un règlement déjà effectué.");
      return;
    }

    await prisma.$transaction(async (tx) => {
      await tx.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: "cancelled",
          cancelledAt: new Date()
        }
      });

      await tx.auditLog.create({
        data: {
          action: "admin_cancel_payout",
          summary: `Annulation du règlement ${payout.id}. Motif: ${body.reason}`,
          entityType: "MerchantPayout",
          entityId: payout.id,
          actorName: "Administrateur",
          actorUserId: session.sub,
          severity: "warning",
          payloadJson: JSON.stringify({ reason: body.reason, oldStatus: payout.status })
        }
      });
    });

    ok(reply, { cancelled: true });
  } catch (e) {
    handleError(e, reply);
  }
}

export async function verifySalonPayoutSettings(request: FastifyRequest, reply: FastifyReply) {
  try {
    const session = requireRole(request, ["platform_admin"]);
    const params = request.params as { salonId: string };
    const body = z.object({
      status: z.enum(["verified", "rejected"])
    }).parse(request.body);

    const salon = await prisma.salon.findUnique({
      where: { id: params.salonId },
      include: {
        staffMembers: {
          where: { role: "salon_owner" },
          select: { id: true, fullName: true, email: true },
          take: 1
        }
      }
    });

    if (!salon) {
      fail(reply, 404, "salon_not_found", "Salon introuvable.");
      return;
    }

    if (!salon.payoutPhone) {
      fail(reply, 400, "no_settings", "Le salon n'a pas configuré ses coordonnées de paiement.");
      return;
    }

    await prisma.$transaction(async (tx) => {
      await tx.salon.update({
        where: { id: params.salonId },
        data: {
          payoutVerificationStatus: body.status,
          payoutVerifiedAt: body.status === "verified" ? new Date() : null,
          payoutVerifiedBy: body.status === "verified" ? session.sub : null
        }
      });

      // If verified, unblock any payouts for this salon that were blocked due to unverified settings
      if (body.status === "verified") {
        await tx.merchantPayout.updateMany({
          where: { salonId: params.salonId, status: "blocked", safeFailureMessage: "salon_payout_details_unverified" },
          data: { status: "scheduled", failureCategory: null, safeFailureMessage: null }
        });
      }

      await tx.auditLog.create({
        data: {
          action: "admin_verify_salon_payout",
          summary: `Validation des coordonnées de paiement du salon ${params.salonId} : ${body.status}`,
          entityType: "Salon",
          entityId: params.salonId,
          actorName: "Administrateur",
          actorUserId: session.sub,
          severity: "info",
          payloadJson: JSON.stringify({ status: body.status })
        }
      });
    });

    const owner = salon.staffMembers[0];
    const ownerFirstName = owner?.fullName?.trim() || "Bonjour";
    const statusLabel = body.status === "verified" ? "approuvées" : "rejetées";
    const notificationTitle =
      body.status === "verified"
        ? "Coordonnées de versement approuvées"
        : "Coordonnées de versement rejetées";
    const notificationBody =
      body.status === "verified"
        ? `Vos coordonnées de versement pour ${salon.name} sont désormais validées.`
        : `Vos coordonnées de versement pour ${salon.name} ont été rejetées. Mettez-les à jour pour débloquer les versements.`;

    if (owner?.id) {
      await sendNotification(owner.id, notificationTitle, notificationBody).catch((err) =>
        logger.warn("verifySalonPayoutSettings: owner notification failed", {
          err: String(err),
          salonId: params.salonId,
          ownerUserId: owner.id
        })
      );
    }

    if (owner?.email) {
      const cta =
        body.status === "verified"
          ? { url: `${config.webOrigin}/pro/payouts`, label: "Voir mes versements" }
          : { url: `${config.webOrigin}/pro/payouts`, label: "Mettre à jour mes coordonnées" };

      await sendEmail({
        to: owner.email,
        subject:
          body.status === "verified"
            ? "Coordonnées de versement approuvées — Beauté Avenue"
            : "Coordonnées de versement rejetées — Beauté Avenue",
        text:
          `Bonjour ${owner.fullName ?? ""},\n\n` +
          `Les coordonnées de versement du salon "${salon.name}" ont été ${statusLabel} par l'administration Beauté Avenue.\n` +
          (body.status === "verified"
            ? "Les versements pourront reprendre automatiquement dès que les autres conditions seront remplies.\n\n"
            : "Les versements restent gelés tant que vous n'avez pas corrigé puis renvoyé vos coordonnées.\n\n") +
          `Accédez à votre espace pro pour voir le statut actuel.\n\n` +
          `— L'équipe Beauté Avenue`,
        html: buildEmailHtml({
          preheader:
            body.status === "verified"
              ? "Vos coordonnées de versement sont validées."
              : "Vos coordonnées de versement nécessitent une correction.",
          greeting: `Bonjour ${ownerFirstName},`,
          bodyLines: [
            `Les coordonnées de versement du salon <strong>${salon.name}</strong> ont été ${statusLabel} par l'administration Beauté Avenue.`,
            body.status === "verified"
              ? "Les versements pourront reprendre automatiquement dès que les autres conditions seront remplies."
              : "Les versements restent gelés tant que vous n'avez pas corrigé puis renvoyé vos coordonnées."
          ],
          cta,
          ignoreNote: false,
          footerNote: "— L'équipe Beauté Avenue"
        })
      }).catch((err) =>
        logger.warn("verifySalonPayoutSettings: owner email failed", {
          err: String(err),
          salonId: params.salonId,
          ownerEmail: owner.email
        })
      );
    }

    ok(reply, { status: body.status });
  } catch (e) {
    handleError(e, reply);
  }
}
