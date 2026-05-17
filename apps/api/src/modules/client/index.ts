import type { FastifyReply, FastifyRequest } from "fastify";
import { Prisma } from "../../generated/prisma/client.js";

import {
  clientAddressCreateSchema,
  clientAddressListResponseSchema,
  clientAddressSchema,
  clientAddressUpdateSchema,
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

import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { fail, ok } from "../../lib/http.js";
import { toDbProvider, toPublicGatewayProvider } from "../../lib/payment-provider.js";
import { prisma } from "../../lib/db/prisma.js";

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

function isPrismaKnownError(error: unknown): error is { code: string } {
  return typeof error === "object" && error !== null && "code" in error && typeof (error as { code?: unknown }).code === "string";
}

function serializePaymentMethod(method: {
  id: string;
  provider: "intech" | "manual";
  phoneNumber: string;
  label: string | null;
  isDefault: boolean;
  lastUsedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}) {
  return clientPaymentMethodSchema.parse({
    id: method.id,
    provider: paymentProviderSchema.parse(toPublicGatewayProvider(method.provider)),
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
      contactChannels: ["phone", "sms"],
      paymentProviders: ["intech"]
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
      const headerBag = ((request as unknown as { headers?: Record<string, unknown>; raw?: { headers?: Record<string, unknown> } }).headers
        ?? (request as unknown as { raw?: { headers?: Record<string, unknown> } }).raw?.headers
        ?? {}) as Record<string, unknown>;
      const idempotencyHeader = headerBag["x-idempotency-key"] ?? headerBag["X-Idempotency-Key"];
      const idempotencyKey = typeof idempotencyHeader === "string" ? idempotencyHeader : idempotencyHeader?.toString();
      if (idempotencyKey) {
        const existing = await prisma.clientPaymentMethod.findUnique({ where: { idempotencyKey } });
        if (existing && existing.userId === session.sub) {
          ok(reply, serializePaymentMethod(existing), 201);
          return;
        }
        if (existing && existing.userId !== session.sub) {
          fail(reply, 409, "idempotency_key_conflict", "Cette clé d'idempotence est déjà utilisée.");
          return;
        }
      }
      const normalizedPhone = normalizePhoneNumber(body.phoneNumber);
      const hasDefault = await prisma.clientPaymentMethod.count({ where: { userId: session.sub, isDefault: true } });
      let created;
      try {
        created = await prisma.$transaction(async (tx) => {
          if (!hasDefault) {
            await tx.clientPaymentMethod.updateMany({ where: { userId: session.sub }, data: { isDefault: false } });
          }
          return tx.clientPaymentMethod.create({
            data: {
            userId: session.sub,
            provider: toDbProvider(body.provider) ?? "intech",
            phoneNumber: normalizedPhone,
              label: body.label ?? null,
              isDefault: hasDefault === 0,
              idempotencyKey: idempotencyKey ?? null
            }
          });
        });
      } catch (error) {
        if (idempotencyKey && isPrismaKnownError(error) && error.code === "P2002") {
          const existing = await prisma.clientPaymentMethod.findUnique({ where: { idempotencyKey } });
          if (existing && existing.userId === session.sub) {
            ok(reply, serializePaymentMethod(existing), 201);
            return;
          }
          fail(reply, 409, "idempotency_key_conflict", "Cette clé d'idempotence est déjà utilisée.");
          return;
        }
        throw error;
      }
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
      const hasVisited = await prisma.booking.findFirst({
        where: { clientId: body.clientId, salonId: actor.salonId },
        select: { id: true }
      });
      if (!hasVisited) {
        fail(reply, 403, "client_not_a_customer", "Ce client n'a pas de réservation dans votre salon.");
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
      const redeemed = await this._redeemVoucherWithConcurrencyGuard(session.sub, code);
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
      if (isPrismaKnownError(error) && error.code === "P2002") {
        fail(reply, 409, "voucher_code_exists", "Ce code voucher existe déjà.");
        return;
      }
      this._handleError(error, reply);
    }
  }

  // ── Addresses ──

  async listAddresses(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const items = await prisma.clientAddress.findMany({
        where: { userId: session.sub },
        orderBy: [{ isDefault: "desc" }, { createdAt: "asc" }]
      });
      ok(reply, clientAddressListResponseSchema.parse({
        items: items.map((a) => ({
          id: a.id,
          label: a.label,
          street: a.street,
          city: a.city,
          isDefault: a.isDefault,
          createdAt: a.createdAt.toISOString(),
          updatedAt: a.updatedAt.toISOString()
        }))
      }));
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async createAddress(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = clientAddressCreateSchema.parse(request.body);
      const created = await prisma.$transaction(async (tx) => {
        await tx.clientAddress.updateMany({ where: { userId: session.sub }, data: { isDefault: false } });
        return tx.clientAddress.create({
          data: {
            userId: session.sub,
            label: body.label,
            street: body.street ?? null,
            city: body.city ?? null,
            isDefault: true
          }
        });
      });
      ok(reply, {
        id: created.id,
        label: created.label,
        street: created.street,
        city: created.city,
        isDefault: created.isDefault,
        createdAt: created.createdAt.toISOString(),
        updatedAt: created.updatedAt.toISOString()
      }, 201);
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async updateAddress(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { addressId: string };
      const body = clientAddressUpdateSchema.parse(request.body);
      const existing = await prisma.clientAddress.findFirst({ where: { id: params.addressId, userId: session.sub } });
      if (!existing) {
        fail(reply, 404, "address_not_found", "Adresse introuvable.");
        return;
      }
      const updated = await prisma.$transaction(async (tx) => {
        if (body.isDefault === true) {
          await tx.clientAddress.updateMany({ where: { userId: session.sub }, data: { isDefault: false } });
        }
        return tx.clientAddress.update({
          where: { id: params.addressId },
          data: {
            label: body.label,
            street: body.street === undefined ? undefined : body.street,
            city: body.city === undefined ? undefined : body.city,
            isDefault: body.isDefault === undefined ? undefined : body.isDefault
          }
        });
      });
      ok(reply, {
        id: updated.id,
        label: updated.label,
        street: updated.street,
        city: updated.city,
        isDefault: updated.isDefault,
        createdAt: updated.createdAt.toISOString(),
        updatedAt: updated.updatedAt.toISOString()
      });
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async deleteAddress(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { addressId: string };
      const existing = await prisma.clientAddress.findFirst({ where: { id: params.addressId, userId: session.sub } });
      if (!existing) {
        fail(reply, 404, "address_not_found", "Adresse introuvable.");
        return;
      }
      await prisma.$transaction(async (tx) => {
        await tx.clientAddress.delete({ where: { id: params.addressId } });
        if (existing.isDefault) {
          const next = await tx.clientAddress.findFirst({
            where: { userId: session.sub },
            orderBy: { createdAt: "asc" }
          });
          if (next) {
            await tx.clientAddress.update({ where: { id: next.id }, data: { isDefault: true } });
          }
        }
      });
      ok(reply, { deleted: true });
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  async deleteAccount(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      await prisma.$transaction([
        // Anonymize PII on the user record itself.
        prisma.user.update({
          where: { id: session.sub },
          data: { fullName: "Deleted User", email: `deleted+${session.sub}@beauteavenue.local`, phone: null }
        }),
        // Wipe profile (city, avatar, preferences).
        prisma.clientProfile.deleteMany({ where: { userId: session.sub } }),
        // Remove all auth material.
        prisma.session.deleteMany({ where: { userId: session.sub } }),
        prisma.pushToken.deleteMany({ where: { userId: session.sub } }),
        // Remove contact data.
        prisma.clientAddress.deleteMany({ where: { userId: session.sub } }),
        // Remove loyalty/benefit data not needed post-deletion.
        prisma.clientBenefit.deleteMany({ where: { userId: session.sub } }),
        // Clear free-text notes on bookings to remove operator-entered PII.
        prisma.booking.updateMany({
          where: { clientId: session.sub },
          data: { clientNote: null }
        })
      ]);
      reply.status(204).send();
    } catch (error) {
      this._handleError(error, reply);
    }
  }

  private async _redeemVoucherWithConcurrencyGuard(userId: string, code: string) {
    for (let attempt = 0; attempt < 3; attempt += 1) {
      try {
        return await prisma.$transaction(async (tx) => {
          const voucher = await tx.voucherDefinition.findUnique({
            where: { code },
            include: { salon: { select: { name: true } } }
          });
          if (!voucher || !voucher.isActive) {
            throw new HttpAuthError(404, "voucher_not_found", "Code introuvable.");
          }
          if (voucher.expiresAt && voucher.expiresAt.getTime() < Date.now()) {
            throw new HttpAuthError(422, "voucher_expired", "Ce code a expiré.");
          }

          const existing = await tx.clientVoucherRedemption.findUnique({
            where: { userId_voucherId: { userId, voucherId: voucher.id } },
            include: { voucher: { include: { salon: { select: { name: true } } } } }
          });
          if (existing) {
            throw new HttpAuthError(409, "voucher_already_redeemed", "Ce code a déjà été ajouté à votre compte.");
          }

          if (voucher.maxRedemptions != null) {
            const count = await tx.clientVoucherRedemption.count({
              where: { voucherId: voucher.id }
            });
            if (count >= voucher.maxRedemptions) {
              throw new HttpAuthError(422, "voucher_exhausted", "Ce code n'est plus disponible.");
            }
          }

          return tx.clientVoucherRedemption.create({
            data: {
              userId,
              voucherId: voucher.id,
              expiresAt: voucher.expiresAt ?? null
            },
            include: { voucher: { include: { salon: { select: { name: true } } } } }
          });
        }, { isolationLevel: Prisma.TransactionIsolationLevel.Serializable });
      } catch (error) {
        if (error instanceof HttpAuthError) throw error;
        if (isPrismaKnownError(error) && error.code === "P2002") {
          throw new HttpAuthError(409, "voucher_already_redeemed", "Ce code a déjà été ajouté à votre compte.");
        }
        if (isPrismaKnownError(error) && error.code === "P2034") {
          continue;
        }
        throw error;
      }
    }

    throw new HttpAuthError(409, "voucher_retry_conflict", "Conflit de concurrence, réessayez.");
  }

  private _handleError(error: unknown, reply: FastifyReply) {
    if (error instanceof HttpAuthError) {
      fail(reply, error.statusCode, error.code, error.message);
      return;
    }
    if (isPrismaKnownError(error) && error.code === "P2002") {
      fail(reply, 409, "already_exists", "La ressource existe déjà.");
      return;
    }
    fail(reply, 500, "internal_error", "Erreur interne.");
  }
}
