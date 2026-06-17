import type { FastifyReply, FastifyRequest } from "fastify";
import argon2 from "argon2";
import { z } from "zod";

import { prisma } from "../../lib/db/prisma.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { ensurePro, ownerOnly } from "./shared.js";

const payoutSettingsUpdateSchema = z.object({
  payoutMethod: z.enum(["wave_senegal", "orange_money_senegal"]),
  payoutPhone: z.string().min(9),
  payoutName: z.string().min(2),
  password: z.string().min(1)
});

function maskPhone(phone: string): string {
  const normalized = phone.replace(/[\s+\-()]/g, "");
  if (normalized.length <= 4) return normalized;
  return `${normalized.slice(0, 3)}*****${normalized.slice(-4)}`;
}

export async function getPayoutSettings(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;

    const salon = await prisma.salon.findUnique({
      where: { id: salonId },
      select: {
        payoutMethod: true,
        payoutPhone: true,
        payoutName: true,
        payoutVerificationStatus: true,
        payoutVerifiedAt: true
      }
    });

    if (!salon) {
      fail(reply, 404, "salon_not_found", "Salon introuvable.");
      return;
    }

    ok(reply, {
      payoutMethod: salon.payoutMethod,
      payoutPhone: salon.payoutPhone ? maskPhone(salon.payoutPhone) : null,
      payoutName: salon.payoutName,
      payoutVerificationStatus: salon.payoutVerificationStatus,
      payoutVerifiedAt: salon.payoutVerifiedAt?.toISOString() ?? null
    });
  } catch (e) {
    handleError(e, reply);
  }
}

export async function updatePayoutSettings(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role, userId } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;

    const body = payoutSettingsUpdateSchema.parse(request.body);

    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user || !user.passwordHash) {
      fail(reply, 401, "unauthorized", "Utilisateur non authentifié.");
      return;
    }

    const passwordMatches = await argon2.verify(user.passwordHash, body.password);
    if (!passwordMatches) {
      fail(reply, 403, "invalid_password", "Mot de passe incorrect.");
      return;
    }

    let cleanedPhone = body.payoutPhone.replace(/[\s+\-()]/g, "");
    if (cleanedPhone.startsWith("221")) {
      cleanedPhone = cleanedPhone.substring(3);
    }
    if (cleanedPhone.startsWith("00221")) {
      cleanedPhone = cleanedPhone.substring(5);
    }

    if (!/^\d{9}$/.test(cleanedPhone)) {
      fail(reply, 422, "invalid_phone", "Numéro de téléphone invalide. Doit être un numéro sénégalais valide à 9 chiffres.");
      return;
    }

    const canonicalPhone = `+221${cleanedPhone}`;

    await prisma.$transaction(async (tx) => {
      await tx.salon.update({
        where: { id: salonId },
        data: {
          payoutMethod: body.payoutMethod,
          payoutPhone: canonicalPhone,
          payoutName: body.payoutName,
          payoutVerificationStatus: "unverified",
          payoutVerifiedAt: null,
          payoutVerifiedBy: null
        }
      });

      await tx.merchantPayout.updateMany({
        where: { salonId, status: "scheduled" },
        data: { status: "blocked", failureCategory: "eligibility", safeFailureMessage: "Coordonnées de paiement modifiées" }
      });

      await tx.auditLog.create({
        data: {
          action: "salon_payout_settings_updated",
          summary: `Modification des coordonnées de paiement pour le salon ${salonId}`,
          entityType: "Salon",
          entityId: salonId,
          actorName: user.fullName || "Propriétaire",
          actorUserId: userId,
          severity: "warning",
          payloadJson: JSON.stringify({
            payoutMethod: body.payoutMethod,
            payoutPhoneMasked: maskPhone(canonicalPhone),
            payoutName: body.payoutName
          })
        }
      });
    });

    ok(reply, {
      payoutMethod: body.payoutMethod,
      payoutPhone: maskPhone(canonicalPhone),
      payoutName: body.payoutName,
      payoutVerificationStatus: "unverified"
    });
  } catch (e) {
    handleError(e, reply);
  }
}

export async function listMerchantPayouts(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;

    const payouts = await prisma.merchantPayout.findMany({
      where: { salonId },
      orderBy: { createdAt: "desc" },
      include: {
        booking: {
          select: {
            id: true,
            startsAt: true,
            service: { select: { name: true } }
          }
        }
      }
    });

    ok(reply, payouts.map((p) => ({
      id: p.id,
      bookingId: p.bookingId,
      bookingStartsAt: p.booking?.startsAt.toISOString() ?? null,
      serviceName: p.booking?.service?.name ?? null,
      payoutMethod: p.payoutMethod,
      beneficiaryPhoneMasked: maskPhone(p.beneficiaryPhoneSnapshot),
      beneficiaryName: p.beneficiaryNameSnapshot,
      grossAmount: p.grossAmount,
      platformCommission: p.platformCommissionAmount,
      payoutAmount: p.merchantPayoutAmount,
      status: p.status,
      safeFailureMessage: p.safeFailureMessage,
      createdAt: p.createdAt.toISOString(),
      completedAt: p.completedAt?.toISOString() ?? null
    })));
  } catch (e) {
    handleError(e, reply);
  }
}
