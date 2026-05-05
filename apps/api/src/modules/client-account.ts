import type { FastifyReply, FastifyRequest } from "fastify";

import {
  clientBenefitSchema,
  clientPaymentMethodCreateSchema,
  clientPaymentMethodSchema,
  clientPaymentMethodUpdateSchema,
  clientVoucherSchema,
  paymentProviderSchema,
  profileOptionsSchema,
  proClientBenefitCreateSchema,
  proVoucherCreateSchema,
  redeemVoucherInputSchema
} from "@beauteavenue/contracts";

import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { prisma } from "../lib/prisma.js";

const SENEGAL_CITIES = [
  "Dakar",
  "Pikine",
  "Guédiawaye",
  "Rufisque",
  "Thiès",
  "Mbour",
  "Saint-Louis",
  "Kaolack",
  "Ziguinchor",
  "Diourbel",
  "Touba",
  "Louga"
] as const;

function normalizePhoneNumber(phoneNumber: string) {
  return phoneNumber.replace(/\s+/g, "").trim();
}

function serializePaymentMethod(method: {
  id: string;
  provider: "paytech" | "manual";
  phoneNumber: string;
  label: string | null;
  isDefault: boolean;
  lastUsedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}) {
  return clientPaymentMethodSchema.parse({
    id: method.id,
    // Client methods must remain gateway-backed; treat legacy/manual rows as non-selectable paytech.
    provider: paymentProviderSchema.parse(method.provider === "manual" ? "paytech" : method.provider),
    phoneNumber: method.phoneNumber,
    label: method.label,
    isDefault: method.isDefault,
    lastUsedAt: method.lastUsedAt?.toISOString() ?? null,
    createdAt: method.createdAt.toISOString(),
    updatedAt: method.updatedAt.toISOString()
  });
}

function serializeBenefit(benefit: {
  id: string;
  kind: "membership" | "package";
  name: string;
  status: "active" | "paused" | "expired" | "exhausted" | "cancelled";
  remainingUses: number | null;
  expiresAt: Date | null;
  billingDate: Date | null;
  createdAt: Date;
  salonId: string;
  salon: { name: string };
}) {
  return clientBenefitSchema.parse({
    id: benefit.id,
    kind: benefit.kind,
    name: benefit.name,
    status: benefit.status,
    remainingUses: benefit.remainingUses,
    expiresAt: benefit.expiresAt?.toISOString() ?? null,
    billingDate: benefit.billingDate?.toISOString() ?? null,
    salonId: benefit.salonId,
    salonName: benefit.salon.name,
    createdAt: benefit.createdAt.toISOString()
  });
}

function serializeVoucherRedemption(redemption: {
  id: string;
  status: "active" | "used" | "expired";
  redeemedAt: Date;
  usedAt: Date | null;
  expiresAt: Date | null;
  voucher: {
    code: string;
    title: string;
    description: string | null;
    discountLabel: string;
    salonId: string | null;
    salon: { name: string } | null;
  };
}) {
  const expired = redemption.expiresAt && redemption.expiresAt.getTime() < Date.now();
  const status = redemption.status === "used" ? "used" : expired ? "expired" : redemption.status;
  return clientVoucherSchema.parse({
    id: redemption.id,
    code: redemption.voucher.code,
    title: redemption.voucher.title,
    description: redemption.voucher.description,
    discountLabel: redemption.voucher.discountLabel,
    status,
    expiresAt: redemption.expiresAt?.toISOString() ?? null,
    redeemedAt: redemption.redeemedAt.toISOString(),
    usedAt: redemption.usedAt?.toISOString() ?? null,
    salonId: redemption.voucher.salonId,
    salonName: redemption.voucher.salon?.name ?? null
  });
}

export class ClientAccountController {
  async profileOptions(_request: FastifyRequest, reply: FastifyReply) {
    ok(reply, profileOptionsSchema.parse({
      cities: SENEGAL_CITIES,
      languages: ["fr", "en"],
      contactChannels: ["phone", "sms", "whatsapp"],
      paymentProviders: ["paytech"]
    }));
  }

  async listPaymentMethods(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const items = await prisma.clientPaymentMethod.findMany({
        where: { userId: session.sub },
        orderBy: [{ isDefault: "desc" }, { createdAt: "asc" }]
      });
      ok(reply, { items: items.map(serializePaymentMethod) });
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async createPaymentMethod(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = clientPaymentMethodCreateSchema.parse(request.body);
      const idempotencyKey = request.headers["x-idempotency-key"]?.toString();
      if (idempotencyKey) {
        const existing = await prisma.clientPaymentMethod.findUnique({ where: { idempotencyKey } });
        if (existing && existing.userId === session.sub) {
          ok(reply, serializePaymentMethod(existing), 201);
          return;
        }
      }
      const normalizedPhone = normalizePhoneNumber(body.phoneNumber);
      const hasDefault = await prisma.clientPaymentMethod.count({ where: { userId: session.sub, isDefault: true } });
      const created = await prisma.$transaction(async (tx) => {
        if (!hasDefault) {
          await tx.clientPaymentMethod.updateMany({ where: { userId: session.sub }, data: { isDefault: false } });
        }
        return tx.clientPaymentMethod.create({
          data: {
            userId: session.sub,
            provider: body.provider,
            phoneNumber: normalizedPhone,
            label: body.label ?? null,
            isDefault: hasDefault === 0,
            idempotencyKey: idempotencyKey ?? null
          }
        });
      });
      ok(reply, serializePaymentMethod(created), 201);
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async updatePaymentMethod(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { paymentMethodId: string };
      const body = clientPaymentMethodUpdateSchema.parse(request.body);
      const existing = await prisma.clientPaymentMethod.findFirst({ where: { id: params.paymentMethodId, userId: session.sub } });
      if (!existing) {
        fail(reply, 404, "payment_method_not_found", "Moyen de paiement introuvable.");
        return;
      }
      const updated = await prisma.clientPaymentMethod.update({
        where: { id: params.paymentMethodId },
        data: {
          phoneNumber: body.phoneNumber ? normalizePhoneNumber(body.phoneNumber) : undefined,
          label: body.label === undefined ? undefined : body.label
        }
      });
      ok(reply, serializePaymentMethod(updated));
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async deletePaymentMethod(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { paymentMethodId: string };
      const existing = await prisma.clientPaymentMethod.findFirst({ where: { id: params.paymentMethodId, userId: session.sub } });
      if (!existing) {
        fail(reply, 404, "payment_method_not_found", "Moyen de paiement introuvable.");
        return;
      }
      await prisma.$transaction(async (tx) => {
        await tx.clientPaymentMethod.delete({ where: { id: params.paymentMethodId } });
        if (existing.isDefault) {
          const next = await tx.clientPaymentMethod.findFirst({
            where: { userId: session.sub },
            orderBy: { createdAt: "asc" }
          });
          if (next) {
            await tx.clientPaymentMethod.update({ where: { id: next.id }, data: { isDefault: true } });
          }
        }
      });
      ok(reply, { deleted: true });
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async setDefaultPaymentMethod(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { paymentMethodId: string };
      const existing = await prisma.clientPaymentMethod.findFirst({ where: { id: params.paymentMethodId, userId: session.sub } });
      if (!existing) {
        fail(reply, 404, "payment_method_not_found", "Moyen de paiement introuvable.");
        return;
      }
      await prisma.$transaction(async (tx) => {
        await tx.clientPaymentMethod.updateMany({ where: { userId: session.sub }, data: { isDefault: false } });
        await tx.clientPaymentMethod.update({ where: { id: params.paymentMethodId }, data: { isDefault: true } });
      });
      const updated = await prisma.clientPaymentMethod.findUnique({ where: { id: params.paymentMethodId } });
      ok(reply, serializePaymentMethod(updated!));
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async listBenefits(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const items = await prisma.clientBenefit.findMany({
        where: { userId: session.sub },
        include: { salon: { select: { name: true } } },
        orderBy: [{ status: "asc" }, { createdAt: "desc" }]
      });
      ok(reply, { items: items.map(serializeBenefit) });
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async createBenefitForClient(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["salon_owner", "salon_staff"]);
      const body = proClientBenefitCreateSchema.parse(request.body);
      const actor = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true } });
      if (!actor?.salonId) {
        fail(reply, 403, "forbidden", "Accès interdit.");
        return;
      }
      const client = await prisma.user.findFirst({ where: { id: body.clientId, role: "client" } });
      if (!client) {
        fail(reply, 404, "client_not_found", "Client introuvable.");
        return;
      }
      const created = await prisma.clientBenefit.create({
        data: {
          userId: client.id,
          salonId: actor.salonId,
          kind: body.kind,
          name: body.name,
          remainingUses: body.remainingUses ?? null,
          expiresAt: body.expiresAt ? new Date(body.expiresAt) : null,
          billingDate: body.billingDate ? new Date(body.billingDate) : null
        },
        include: { salon: { select: { name: true } } }
      });
      ok(reply, serializeBenefit(created), 201);
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async listVouchers(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const items = await prisma.clientVoucherRedemption.findMany({
        where: { userId: session.sub },
        include: { voucher: { include: { salon: { select: { name: true } } } } },
        orderBy: { redeemedAt: "desc" }
      });
      ok(reply, { items: items.map(serializeVoucherRedemption) });
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async redeemVoucher(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = redeemVoucherInputSchema.parse(request.body);
      const code = body.code.trim().toUpperCase();
      const voucher = await prisma.voucherDefinition.findUnique({
        where: { code },
        include: { _count: { select: { redemptions: true } }, salon: { select: { name: true } } }
      });
      if (!voucher || !voucher.isActive) {
        fail(reply, 404, "voucher_not_found", "Code introuvable.");
        return;
      }
      if (voucher.expiresAt && voucher.expiresAt.getTime() < Date.now()) {
        fail(reply, 422, "voucher_expired", "Ce code a expiré.");
        return;
      }
      if (voucher.maxRedemptions != null && voucher._count.redemptions >= voucher.maxRedemptions) {
        fail(reply, 422, "voucher_exhausted", "Ce code n'est plus disponible.");
        return;
      }
      const existing = await prisma.clientVoucherRedemption.findUnique({
        where: { userId_voucherId: { userId: session.sub, voucherId: voucher.id } },
        include: { voucher: { include: { salon: { select: { name: true } } } } }
      });
      if (existing) {
        fail(reply, 409, "voucher_already_redeemed", "Ce code a déjà été ajouté à votre compte.");
        return;
      }
      const redeemed = await prisma.clientVoucherRedemption.create({
        data: {
          userId: session.sub,
          voucherId: voucher.id,
          expiresAt: voucher.expiresAt ?? null
        },
        include: { voucher: { include: { salon: { select: { name: true } } } } }
      });
      ok(reply, serializeVoucherRedemption(redeemed), 201);
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async createVoucherDefinition(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["salon_owner", "salon_staff"]);
      const body = proVoucherCreateSchema.parse(request.body);
      const actor = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true } });
      if (!actor?.salonId) {
        fail(reply, 403, "forbidden", "Accès interdit.");
        return;
      }
      const created = await prisma.voucherDefinition.create({
        data: {
          salonId: actor.salonId,
          code: body.code.trim().toUpperCase(),
          title: body.title,
          description: body.description ?? null,
          discountLabel: body.discountLabel,
          expiresAt: body.expiresAt ? new Date(body.expiresAt) : null,
          maxRedemptions: body.maxRedemptions ?? null
        }
      });
      ok(reply, {
        id: created.id,
        code: created.code,
        title: created.title,
        description: created.description,
        discountLabel: created.discountLabel,
        expiresAt: created.expiresAt?.toISOString() ?? null,
        maxRedemptions: created.maxRedemptions
      }, 201);
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  private _handleError(error: unknown, reply: FastifyReply) {
    if (error instanceof HttpAuthError) {
      fail(reply, error.statusCode, error.code, error.message);
      return;
    }
    fail(reply, 500, "internal_error", "Erreur interne.");
  }
}
