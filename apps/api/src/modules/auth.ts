import argon2 from "argon2";
import type { FastifyReply, FastifyRequest } from "fastify";

import {
  currentUserSchema,
  emailLoginSchema,
  otpRequestSchema,
  otpVerifySchema,
  refreshInputSchema,
  registerInputSchema,
  updateMeInputSchema
} from "@beauteavenue/contracts";

import { NoopOtpAdapter } from "../adapters/otp.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { prisma } from "../lib/prisma.js";
import { signSession, verifyRefreshToken } from "../lib/session.js";

const otpAdapter = new NoopOtpAdapter();

// In-memory OTP store (phone → { code, expiresAt })
const otpStore = new Map<string, { code: string; expiresAt: number }>();

function generateOtpCode(): string {
  return String(Math.floor(100000 + Math.random() * 900000));
}

async function serializeCurrentUser(userId: string) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { clientProfile: true }
  });
  if (!user) return null;
  return currentUserSchema.parse({
    id: user.id,
    fullName: user.fullName,
    email: user.email ?? null,
    phone: user.phone ?? null,
    role: user.role,
    salonId: user.salonId ?? null,
    city: user.clientProfile?.city ?? null,
    avatarUrl: user.clientProfile?.avatarUrl ?? null,
    preferredContactChannel: user.clientProfile?.preferredContactChannel ?? "phone",
    pushOptIn: user.clientProfile?.pushOptIn ?? true,
    marketingOptIn: user.clientProfile?.marketingOptIn ?? false,
    preferredLanguage: user.clientProfile?.preferredLanguage === "en" ? "en" : "fr"
  });
}

export class AuthController {
  async register(request: FastifyRequest, reply: FastifyReply) {
    const body = registerInputSchema.parse(request.body);

    if (body.type === "client") {
      if (!body.email && !body.phone) {
        fail(reply, 422, "email_or_phone_required", "Email ou téléphone requis.");
        return;
      }
      const existing = await prisma.user.findFirst({
        where: {
          OR: [
            body.email ? { email: body.email } : {},
            body.phone ? { phone: body.phone } : {}
          ].filter((c) => Object.keys(c).length > 0)
        }
      });
      if (existing) {
        fail(reply, 409, "already_exists", "Email ou téléphone déjà utilisé.");
        return;
      }

      const passwordHash = await argon2.hash(body.password);
      const user = await prisma.user.create({
        data: {
          fullName: body.fullName,
          email: body.email ?? null,
          phone: body.phone ?? null,
          passwordHash,
          role: "client"
        }
      });

      const tokens = signSession(user.id, "client");
      await prisma.session.create({
        data: {
          userId: user.id,
          refreshToken: tokens.refreshToken,
          clientType: "app",
          expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
        }
      });
      ok(reply, tokens, 201);
    } else {
      // salon_owner path
      const existing = await prisma.user.findFirst({
        where: { OR: [{ email: body.email }, { phone: body.phone }] }
      });
      if (existing) {
        fail(reply, 409, "already_exists", "Email ou téléphone déjà utilisé.");
        return;
      }

      const passwordHash = await argon2.hash(body.password);

      const result = await prisma.$transaction(async (tx) => {
        const user = await tx.user.create({
          data: {
            fullName: body.fullName,
            email: body.email,
            phone: body.phone,
            passwordHash,
            role: "salon_owner"
          }
        });

        const salon = await tx.salon.create({
          data: {
            name: body.salon.name,
            category: body.salon.category,
            city: body.salon.city,
            address: body.salon.address,
            description: body.salon.description ?? "",
            approvalStatus: "pending_review"
          }
        });

        await tx.user.update({
          where: { id: user.id },
          data: { salonId: salon.id }
        });

        await tx.service.createMany({
          data: body.services.map((s, i) => ({
            salonId: salon.id,
            name: s.name,
            durationMinutes: s.durationMinutes,
            priceXof: s.priceXof,
            depositMode: s.depositMode,
            depositAmountXof: s.depositAmountXof ?? null,
            depositPercent: s.depositPercent ?? null,
            displayOrder: i
          }))
        });

        await tx.salonHours.createMany({
          data: body.hours.map((h) => ({
            salonId: salon.id,
            dayOfWeek: h.dayOfWeek,
            isOpen: h.isOpen,
            opensAt: h.opensAt ?? null,
            closesAt: h.closesAt ?? null
          }))
        });

        return { user, salon };
      });

      const tokens = signSession(result.user.id, "salon_owner");
      await prisma.session.create({
        data: {
          userId: result.user.id,
          refreshToken: tokens.refreshToken,
          clientType: "web",
          expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
        }
      });
      ok(reply, tokens, 201);
    }
  }

  async login(request: FastifyRequest, reply: FastifyReply) {
    const body = emailLoginSchema.parse(request.body);

    const user = await prisma.user.findUnique({ where: { email: body.email } });
    if (!user || !user.passwordHash) {
      fail(reply, 401, "invalid_credentials", "Email ou mot de passe incorrect.");
      return;
    }

    const valid = await argon2.verify(user.passwordHash, body.password);
    if (!valid) {
      fail(reply, 401, "invalid_credentials", "Email ou mot de passe incorrect.");
      return;
    }

    const tokens = signSession(user.id, user.role);
    await prisma.session.create({
      data: {
        userId: user.id,
        refreshToken: tokens.refreshToken,
        clientType: "web",
        expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
      }
    });
    ok(reply, tokens);
  }

  async requestOtp(request: FastifyRequest, reply: FastifyReply) {
    const body = otpRequestSchema.parse(request.body);
    const existingUser = await prisma.user.findUnique({
      where: { phone: body.phone }
    });
    if (existingUser && existingUser.role !== "client") {
      fail(
        reply,
        403,
        "client_role_required",
        "Ce numéro est lié à un compte professionnel. Connectez-vous avec un compte client."
      );
      return;
    }

    const code = generateOtpCode();
    otpStore.set(body.phone, { code, expiresAt: Date.now() + 10 * 60 * 1000 });
    await otpAdapter.send(body.phone, code);
    reply.code(202).send({ accepted: true, channel: config.otpDriver, destination: body.phone });
  }

  async verifyOtp(request: FastifyRequest, reply: FastifyReply) {
    const body = otpVerifySchema.parse(request.body);
    const entry = otpStore.get(body.phone);
    const valid =
      config.otpDriver === "noop" ||
      (entry && entry.code === body.code && entry.expiresAt > Date.now());

    if (!valid) {
      fail(reply, 401, "invalid_otp", "Code OTP invalide ou expiré.");
      return;
    }
    otpStore.delete(body.phone);

    let user = await prisma.user.findUnique({ where: { phone: body.phone } });
    if (user && user.role !== "client") {
      fail(
        reply,
        403,
        "client_role_required",
        "Ce numéro est lié à un compte professionnel. Connectez-vous avec un compte client."
      );
      return;
    }
    if (!user) {
      user = await prisma.user.create({
        data: { fullName: body.phone, phone: body.phone, role: "client" }
      });
    }

    const tokens = signSession(user.id, user.role);
    await prisma.session.create({
      data: {
        userId: user.id,
        refreshToken: tokens.refreshToken,
        clientType: "app",
        expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
      }
    });
    ok(reply, tokens);
  }

  async refresh(request: FastifyRequest, reply: FastifyReply) {
    const body = refreshInputSchema.parse(request.body);

    let payload: { sub: string };
    try {
      payload = verifyRefreshToken(body.refreshToken);
    } catch {
      fail(reply, 401, "invalid_refresh_token", "Refresh token invalide ou expiré.");
      return;
    }

    const session = await prisma.session.findFirst({
      where: { refreshToken: body.refreshToken, userId: payload.sub }
    });
    if (!session || session.expiresAt < new Date()) {
      fail(reply, 401, "session_expired", "Session expirée.");
      return;
    }

    const user = await prisma.user.findUnique({ where: { id: payload.sub } });
    if (!user) {
      fail(reply, 401, "user_not_found", "Utilisateur introuvable.");
      return;
    }

    await prisma.session.delete({ where: { id: session.id } });

    const tokens = signSession(user.id, user.role);
    await prisma.session.create({
      data: {
        userId: user.id,
        refreshToken: tokens.refreshToken,
        clientType: session.clientType,
        expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
      }
    });
    ok(reply, tokens);
  }

  async logout(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const body = refreshInputSchema.safeParse(request.body);
      if (body.success) {
        await prisma.session.deleteMany({
          where: { userId: session.sub, refreshToken: body.data.refreshToken }
        });
      } else {
        await prisma.session.deleteMany({ where: { userId: session.sub } });
      }
    } catch {
      // logout is best-effort — always succeed
    }
    ok(reply, { revoked: true });
  }

  async me(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const user = await serializeCurrentUser(session.sub);
      if (!user) {
        fail(reply, 404, "user_not_found", "Utilisateur introuvable.");
        return;
      }
      ok(reply, user);
    } catch (error) {
      if (error instanceof HttpAuthError) {
        fail(reply, error.statusCode, error.code, error.message);
      } else {
        logger.error("Auth /me error", { error: String(error) });
        fail(reply, 500, "internal_error", "Erreur interne.");
      }
    }
  }

  async updateMe(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const body = updateMeInputSchema.parse(request.body);
      const media = body.avatarMediaId
        ? await prisma.mediaAsset.findUnique({ where: { id: body.avatarMediaId } })
        : null;

      if (body.avatarMediaId && (!media || media.deletedAt || media.ownerType !== "user" || media.ownerId !== session.sub)) {
        fail(reply, 422, "invalid_avatar", "Avatar invalide.");
        return;
      }

      await prisma.$transaction(async (tx) => {
        if (body.fullName !== undefined) {
          await tx.user.update({
            where: { id: session.sub },
            data: { fullName: body.fullName }
          });
        }

        if (
          body.city !== undefined ||
          body.avatarMediaId !== undefined ||
          body.preferredContactChannel !== undefined ||
          body.pushOptIn !== undefined ||
          body.marketingOptIn !== undefined ||
          body.preferredLanguage !== undefined
        ) {
          await tx.clientProfile.upsert({
            where: { userId: session.sub },
            update: {
              city: body.city === undefined ? undefined : body.city,
              avatarMediaId: body.avatarMediaId === undefined ? undefined : body.avatarMediaId,
              avatarUrl: body.avatarMediaId === undefined ? undefined : (media?.publicUrl ?? null),
              preferredContactChannel: body.preferredContactChannel,
              pushOptIn: body.pushOptIn,
              marketingOptIn: body.marketingOptIn,
              preferredLanguage: body.preferredLanguage
            },
            create: {
              userId: session.sub,
              city: body.city ?? null,
              avatarMediaId: body.avatarMediaId ?? null,
              avatarUrl: media?.publicUrl ?? null,
              preferredContactChannel: body.preferredContactChannel ?? "phone",
              pushOptIn: body.pushOptIn ?? true,
              marketingOptIn: body.marketingOptIn ?? false,
              preferredLanguage: body.preferredLanguage ?? "fr"
            }
          });
        }
      });
      ok(reply, await serializeCurrentUser(session.sub));
    } catch (error) {
      if (error instanceof HttpAuthError) {
        fail(reply, error.statusCode, error.code, error.message);
      } else {
        fail(reply, 500, "internal_error", "Erreur interne.");
      }
    }
  }
}
