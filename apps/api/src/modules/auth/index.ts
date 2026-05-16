import argon2 from "argon2";
import { createHash, timingSafeEqual } from "node:crypto";
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

import { createOtpAdapter, getR2Adapter, getStorageAdapter } from "../../adapters/index.js";
import { config } from "../../config.js";
import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { sendEmail } from "../../lib/email.js";
import { fail, ok } from "../../lib/http.js";
import { logger } from "../../lib/logger.js";
import { prisma } from "../../lib/db/prisma.js";
import { signSession, verifyRefreshToken } from "../../lib/auth/session.js";

const otpAdapter = createOtpAdapter(config.otpDriver, {
  atApiKey: config.atApiKey,
  atUsername: config.atUsername,
  atSenderId: config.atSenderId
});
const OTP_TTL_MS = 5 * 60 * 1000;
const OTP_KEY_PREFIX = "otp:challenge:";
const OTP_RATE_LIMIT_MAX = 3;
const OTP_RATE_LIMIT_WINDOW_MS = 15 * 60 * 1000; // 3 per 15 min per phone
type OtpChallenge = { codeHash: string; expiresAt: number };

function generateOtpCode(): string {
  return String(Math.floor(100000 + Math.random() * 900000));
}

function hashValue(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

function otpStorageKey(phone: string): string {
  return `${OTP_KEY_PREFIX}${hashValue(phone)}`;
}

function otpCodeHash(phone: string, code: string): string {
  return hashValue(`${phone}:${code}:${config.jwtAccessSecret}`);
}

async function persistOtpChallenge(phone: string, code: string) {
  const key = otpStorageKey(phone);
  const value = JSON.stringify({
    codeHash: otpCodeHash(phone, code),
    expiresAt: Date.now() + OTP_TTL_MS
  });
  await prisma.platformSetting.upsert({
    where: { key },
    create: {
      group: "security",
      key,
      value,
      description: "OTP challenge storage"
    },
    update: { value }
  });
}

async function readOtpChallenge(phone: string): Promise<OtpChallenge | null> {
  const key = otpStorageKey(phone);
  const row = await prisma.platformSetting.findUnique({
    where: { key },
    select: { value: true }
  });
  if (!row) return null;
  try {
    const parsed = JSON.parse(row.value) as { codeHash?: string; expiresAt?: number };
    if (!parsed.codeHash || typeof parsed.expiresAt !== "number") return null;
    return { codeHash: parsed.codeHash, expiresAt: parsed.expiresAt };
  } catch {
    return null;
  }
}

async function clearOtpChallenge(phone: string) {
  await prisma.platformSetting.deleteMany({ where: { key: otpStorageKey(phone) } });
}

async function checkOtpRateLimit(phone: string): Promise<{ allowed: false; retryAfterSeconds: number } | { allowed: true }> {
  const key = `otp:ratelimit:${hashValue(phone)}`;
  const now = Date.now();

  const existing = await prisma.platformSetting.findUnique({
    where: { key },
    select: { value: true }
  });

  if (existing) {
    const record = JSON.parse(existing.value) as { count: number; windowStart: number };
    if (now - record.windowStart < OTP_RATE_LIMIT_WINDOW_MS) {
      if (record.count >= OTP_RATE_LIMIT_MAX) {
        const retryAfterSeconds = Math.ceil((OTP_RATE_LIMIT_WINDOW_MS - (now - record.windowStart)) / 1000);
        return { allowed: false, retryAfterSeconds };
      }
      await prisma.platformSetting.update({
        where: { key },
        data: { value: JSON.stringify({ count: record.count + 1, windowStart: record.windowStart }) }
      });
      return { allowed: true };
    }
  }

  await prisma.platformSetting.upsert({
    where: { key },
    create: { group: "security", key, value: JSON.stringify({ count: 1, windowStart: now }), description: "OTP rate limit" },
    update: { value: JSON.stringify({ count: 1, windowStart: now }) }
  });

  return { allowed: true };
}

function constantTimeEquals(a: string, b: string): boolean {
  const left = Buffer.from(a, "utf8");
  const right = Buffer.from(b, "utf8");
  if (left.length !== right.length) return false;
  return timingSafeEqual(left, right);
}

async function serializeCurrentUser(userId: string) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { clientProfile: true }
  });
  if (!user) return null;
  let avatarUrl = user.clientProfile?.avatarUrl ?? null;
  const avatarMediaId = user.clientProfile?.avatarMediaId;
  if (avatarMediaId) {
    const media = await prisma.mediaAsset.findUnique({
      where: { id: avatarMediaId },
      select: {
        publicUrl: true,
        objectKey: true,
        finalObjectKey: true,
        ownerType: true,
        ownerId: true,
        deletedAt: true
      }
    });
    if (media && !media.deletedAt) {
      if (media.publicUrl) {
        avatarUrl = media.publicUrl;
      } else if (media.ownerType === "user" && media.ownerId === user.id) {
        getStorageAdapter(config.storageDriver, {
          storagePath: config.storagePath,
          r2AccountId: config.r2AccountId,
          r2AccessKeyId: config.r2AccessKeyId,
          r2SecretAccessKey: config.r2SecretAccessKey,
          r2Bucket: config.r2Bucket,
          mediaPublicBaseUrl: config.mediaPublicBaseUrl
        });
        const r2 = getR2Adapter();
        const objectKey = media.finalObjectKey ?? media.objectKey;
        if (r2 && objectKey) {
          try {
            avatarUrl = await r2.presignGet(objectKey, 600);
          } catch {
            // Keep nullable avatar when presign fails.
          }
        }
      }
    }
  }
  const preferredContactChannel = user.clientProfile?.preferredContactChannel === "sms"
    ? "sms"
    : "phone";
  return currentUserSchema.parse({
    id: user.id,
    fullName: user.fullName,
    email: user.email ?? null,
    phone: user.phone ?? null,
    role: user.role,
    salonId: user.salonId ?? null,
    city: user.clientProfile?.city ?? null,
    avatarUrl,
    preferredContactChannel,
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

    const lockoutKey = `auth:lockout:${user.id}`;
    const lockoutEntry = await prisma.platformSetting.findUnique({ where: { key: lockoutKey } });
    if (lockoutEntry) {
      try {
        const lock = JSON.parse(lockoutEntry.value) as { lockedUntil: number };
        if (lock.lockedUntil > Date.now()) {
          const remainingMinutes = Math.ceil((lock.lockedUntil - Date.now()) / 60_000);
          fail(reply, 423, "account_locked", `Compte temporairement verrouillé. Réessayez dans ${remainingMinutes} minute(s).`);
          return;
        }
      } catch {}
    }

    const valid = await argon2.verify(user.passwordHash, body.password);
    if (!valid) {
      let attempts = 0;
      try {
        const prev = JSON.parse(lockoutEntry?.value ?? "{}") as { attempts?: number };
        attempts = (prev.attempts ?? 0) + 1;
      } catch { attempts = 1; }

      const maxAttempts = 5;
      const lockoutMinutes = 15;

      if (attempts >= maxAttempts) {
        const lockedUntil = Date.now() + lockoutMinutes * 60 * 1000;
        await prisma.platformSetting.upsert({
          where: { key: lockoutKey },
          update: { value: JSON.stringify({ attempts, lockedUntil }) },
          create: { key: lockoutKey, group: "security", value: JSON.stringify({ attempts, lockedUntil }) }
        });
        fail(reply, 423, "account_locked", `Compte temporairement verrouillé. Réessayez dans ${lockoutMinutes} minute(s).`);
        return;
      }

      await prisma.platformSetting.upsert({
        where: { key: lockoutKey },
        update: { value: JSON.stringify({ attempts }) },
        create: { key: lockoutKey, group: "security", value: JSON.stringify({ attempts }) }
      });
      fail(reply, 401, "invalid_credentials", "Email ou mot de passe incorrect.");
      return;
    }

    await prisma.platformSetting.deleteMany({ where: { key: lockoutKey } });

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

    const rateLimit = await checkOtpRateLimit(body.phone);
    if (!rateLimit.allowed) {
      fail(
        reply,
        429,
        "otp_rate_limited",
        `Trop de tentatives. Réessayez dans ${rateLimit.retryAfterSeconds}s.`
      );
      return;
    }

    const code = generateOtpCode();
    await persistOtpChallenge(body.phone, code);
    await otpAdapter.send(body.phone, code);
    reply.code(202).send({ accepted: true, channel: config.otpDriver, destination: body.phone });
  }

  async verifyOtp(request: FastifyRequest, reply: FastifyReply) {
    const body = otpVerifySchema.parse(request.body);
    const entry = await readOtpChallenge(body.phone);
    const codeHash = otpCodeHash(body.phone, body.code);
    const valid = !!entry && entry.expiresAt > Date.now() && constantTimeEquals(entry.codeHash, codeHash);

    if (!valid) {
      fail(reply, 401, "invalid_otp", "Code OTP invalide ou expiré.");
      return;
    }
    await clearOtpChallenge(body.phone);

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
        logger.error("Auth /me error", { error });
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

      if (body.currentPassword || body.newPassword) {
        if (!body.currentPassword || !body.newPassword) {
          fail(reply, 422, "password_fields_required", "Le mot de passe actuel et le nouveau mot de passe sont requis.");
          return;
        }
        const user = await prisma.user.findUnique({ where: { id: session.sub }, select: { passwordHash: true, email: true, fullName: true } });
        if (!user?.passwordHash) {
          fail(reply, 422, "no_password_set", "Aucun mot de passe défini pour ce compte.");
          return;
        }
        const valid = await argon2.verify(user.passwordHash, body.currentPassword);
        if (!valid) {
          fail(reply, 401, "invalid_current_password", "Mot de passe actuel incorrect.");
          return;
        }
        await prisma.user.update({
          where: { id: session.sub },
          data: { passwordHash: await argon2.hash(body.newPassword) }
        });
        if (user.email) {
          void sendEmail({
            to: user.email,
            subject: "Votre mot de passe a été modifié — Beauté Avenue",
            text: `Bonjour ${user.fullName ?? ""},\n\nVotre mot de passe a bien été modifié. Si vous n'êtes pas à l'origine de cette action, contactez-nous immédiatement.\n\n— Beauté Avenue`
          });
        }
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
