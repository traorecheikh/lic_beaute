import argon2 from "argon2";
import { createHash, randomBytes, randomInt, timingSafeEqual } from "node:crypto";
import type { FastifyReply, FastifyRequest } from "fastify";
import { ZodError } from "zod";

import {
  currentUserSchema,
  emailLoginSchema,
  emailOtpRequestSchema,
  emailOtpVerifySchema,
  otpRequestSchema,
  otpVerifySchema,
  refreshInputSchema,
  registerInputSchema,
  updateMeInputSchema
} from "@beauteavenue/contracts";

import { createOtpAdapter, getStorageAdapter } from "../../adapters/index.js";
import { config } from "../../config.js";
import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { sendEmail } from "../../lib/email.js";
import { fail, ok } from "../../lib/http.js";
import { enqueueJob } from "../../lib/jobs.js";
import { logger } from "../../lib/logger.js";
import { prisma } from "../../lib/db/prisma.js";
import { signSession, verifyRefreshToken } from "../../lib/auth/session.js";
import { checkRateLimit, checkAccountRateLimit } from "../../lib/rate-limit.js";

const otpAdapter = createOtpAdapter(config.otpDriver, {
  atApiKey: config.atApiKey,
  atUsername: config.atUsername,
  atSenderId: config.atSenderId
});
const OTP_TTL_MS = 5 * 60 * 1000;
const OTP_RATE_LIMIT_MAX = 3;
const OTP_RATE_LIMIT_WINDOW_MS = 15 * 60 * 1000;
const OTP_MAX_ATTEMPTS = 5;
const MAX_SESSIONS_PER_USER = 10;

function hashRefreshToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

function normalizePhoneNumber(phoneNumber: string) {
  let cleaned = phoneNumber.replace(/\s+/g, "").trim();
  // If it's a local number without country code, assume Senegal (+221)
  if (cleaned.startsWith("0")) {
    cleaned = "+221" + cleaned.slice(1);
  } else if (/^\d{7,12}$/.test(cleaned) && !cleaned.startsWith("+")) {
    cleaned = "+221" + cleaned;
  } else if (!cleaned.startsWith("+")) {
    cleaned = "+" + cleaned;
  }
  return cleaned;
}

async function pruneExcessSessions(userId: string): Promise<void> {
  const sessions = await prisma.session.findMany({
    where: { userId },
    orderBy: { createdAt: "asc" },
    select: { id: true }
  });
  if (sessions.length > MAX_SESSIONS_PER_USER) {
    const excess = sessions.slice(0, sessions.length - MAX_SESSIONS_PER_USER);
    await prisma.session.deleteMany({ where: { id: { in: excess.map((s) => s.id) } } });
  }
}

function generateOtpCode(): string {
  return String(randomInt(100000, 1000000));
}

function hashValue(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

function otpCodeHash(phone: string, code: string): string {
  return hashValue(`${phone}:${code}:${config.jwtAccessSecret}`);
}

function uaHash(request: FastifyRequest): string | null {
  const ua = request.headers["user-agent"];
  return ua ? hashValue(ua) : null;
}

async function persistOtpChallenge(phone: string, code: string) {
  await prisma.otpChallenge.upsert({
    where: { phone: hashValue(phone) },
    create: {
      phone: hashValue(phone),
      codeHash: otpCodeHash(phone, code),
      expiresAt: new Date(Date.now() + OTP_TTL_MS),
      failedAttempts: 0
    },
    update: {
      codeHash: otpCodeHash(phone, code),
      expiresAt: new Date(Date.now() + OTP_TTL_MS),
      failedAttempts: 0
    }
  });
}

async function readOtpChallenge(phone: string) {
  return prisma.otpChallenge.findUnique({ where: { phone: hashValue(phone) } });
}

async function clearOtpChallenge(phone: string) {
  await prisma.otpChallenge.deleteMany({ where: { phone: hashValue(phone) } });
}

async function checkOtpRateLimit(phone: string): Promise<{ allowed: false; retryAfterSeconds: number } | { allowed: true }> {
  const result = await checkRateLimit(
    "otp",
    [{ type: "phone", phone }],
    OTP_RATE_LIMIT_MAX,
    Math.ceil(OTP_RATE_LIMIT_WINDOW_MS / 1000)
  );
  if (result.allowed) return { allowed: true };
  return { allowed: false, retryAfterSeconds: result.retryAfterSeconds };
}

function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

function isPlayReviewEnabled(): boolean {
  return (
    config.playReviewEnabled &&
    config.playReviewEmail.length > 0 &&
    config.playReviewOtp.length > 0
  );
}

function constantTimeEquals(a: string, b: string): boolean {
  const left = Buffer.from(a, "utf8");
  const right = Buffer.from(b, "utf8");
  if (left.length !== right.length) return false;
  return timingSafeEqual(left, right);
}

function reviewUserDisplayName(): string {
  return "Compte test";
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
        const storage = getStorageAdapter(config.storageDriver, {
          storagePath: config.storagePath,
          mediaPublicBaseUrl: config.mediaPublicBaseUrl
        });
        const objectKey = media.finalObjectKey ?? media.objectKey;
        if (objectKey) {
          try {
            avatarUrl = await storage.presignGet(objectKey, 600);
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
  async checkAvailability(request: FastifyRequest, reply: FastifyReply) {
    const { email, phone, excludeUserId } = request.query as { email?: string; phone?: string; excludeUserId?: string };
    const result: Record<string, "available" | "taken"> = {};
    if (email) {
      const existing = await prisma.user.findUnique({ where: { email: normalizeEmail(email) }, select: { id: true } });
      result.email = existing && existing.id !== excludeUserId ? "taken" : "available";
    }
    if (phone) {
      const normalized = normalizePhoneNumber(phone);
      const existing = await prisma.user.findFirst({ where: { phone: normalized }, select: { id: true } });
      result.phone = existing && existing.id !== excludeUserId ? "taken" : "available";
    }
    ok(reply, result);
  }

  async register(request: FastifyRequest, reply: FastifyReply) {
    let body: ReturnType<typeof registerInputSchema.parse>;
    try {
      body = registerInputSchema.parse(request.body);
    } catch (error) {
      if (error instanceof ZodError || (typeof error === "object" && error !== null && "issues" in error)) {
        fail(reply, 422, "invalid_payload", "Données d'inscription invalides.");
        return;
      }
      throw error;
    }

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
          phone: body.phone ? normalizePhoneNumber(body.phone) : null,
          passwordHash,
          role: "client"
        }
      });

      const tokens = signSession(user.id, "client", user.tokenVersion);
      await prisma.session.create({
        data: {
          userId: user.id,
          refreshToken: hashRefreshToken(tokens.refreshToken),
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
            phone: body.phone ? normalizePhoneNumber(body.phone) : body.phone,
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
            latitude: body.salon.latitude ?? null,
            longitude: body.salon.longitude ?? null,
            subscriptionIntentTier: body.subscriptionIntentTier ?? "standard",
            approvalStatus: "pending_review"
          }
        });

        await tx.user.update({
          where: { id: user.id },
          data: { salonId: salon.id }
        });

        if (body.documents && body.documents.length > 0) {
          await tx.salonDocument.createMany({
            data: body.documents.map((doc) => ({
              salonId: salon.id,
              label: doc.label,
              fileUrl: doc.fileUrl,
              status: doc.fileUrl ? "received" : "missing"
            }))
          });
        }

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

      const tokens = signSession(result.user.id, "salon_owner", result.user.tokenVersion);
      await prisma.session.create({
        data: {
          userId: result.user.id,
          refreshToken: hashRefreshToken(tokens.refreshToken),
          clientType: "web",
          userAgentHash: uaHash(request),
          expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
        }
      });
      await pruneExcessSessions(result.user.id);
      void enqueueJob({
        type: "salon_submitted_admin",
        payload: { salonId: result.salon.id, salonName: result.salon.name, resubmission: false }
      }).catch((err) => logger.warn("auth.register: salon_submitted_admin enqueue failed", { err }));

      const { buildEmailHtml } = await import("../../lib/email-html.js");
      void sendEmail({
        to: body.email,
        subject: "Inscription reçue | Beauté Avenue Pro",
        text:
          `Bonjour ${body.fullName},\n\n` +
          `Votre dossier pour "${body.salon.name}" a bien été enregistré sur Beauté Avenue.\n` +
          `Statut actuel : en attente de validation.\n\n` +
          `Vous pouvez vous connecter pour suivre l'évolution de votre dossier.\n\n` +
          `L'équipe Beauté Avenue`,
        html: buildEmailHtml({
          preheader: "Votre inscription a été reçue",
          greeting: `Bonjour ${body.fullName},`,
          bodyLines: [
            `Votre dossier pour <strong>${body.salon.name}</strong> a bien été enregistré sur <strong>Beauté Avenue</strong>.`,
            `Statut actuel : <strong>en attente de validation</strong>.`,
            `Vous pouvez vous connecter à votre espace pro pour suivre l'évolution de votre dossier.`
          ],
          cta: { url: `${config.webOrigin}/pro/`, label: "Suivre mon dossier" },
          ignoreNote: false,
          footerNote: "— L'équipe Beauté Avenue"
        })
      }).catch((err) => logger.error("auth.register salon_owner: failed to send welcome email", { err: String(err), to: body.email }));
      ok(reply, tokens, 201);
    }
  }

  async login(request: FastifyRequest, reply: FastifyReply) {
    let body: ReturnType<typeof emailLoginSchema.parse>;
    try {
      body = emailLoginSchema.parse(request.body);
    } catch (error) {
      if (error instanceof ZodError || (typeof error === "object" && error !== null && "issues" in error)) {
        fail(reply, 422, "invalid_payload", "Identifiants invalides.");
        return;
      }
      throw error;
    }

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
      } catch (parseErr) {
        logger.warn("auth: malformed lockout entry, treating as unlocked", { key: lockoutKey, err: String(parseErr) });
      }
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

    const tokens = signSession(user.id, user.role, user.tokenVersion);
    await prisma.session.create({
      data: {
        userId: user.id,
        refreshToken: hashRefreshToken(tokens.refreshToken),
        clientType: "web",
        userAgentHash: uaHash(request),
        expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
      }
    });
    await pruneExcessSessions(user.id);
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
    const notExpired = !!entry && entry.expiresAt.getTime() > Date.now();
    const valid = notExpired && constantTimeEquals(entry!.codeHash, codeHash);

    if (!valid) {
      if (entry && notExpired) {
        const attempts = entry.failedAttempts + 1;
        if (attempts >= OTP_MAX_ATTEMPTS) {
          await clearOtpChallenge(body.phone);
          fail(reply, 429, "otp_locked", "Trop de tentatives. Veuillez demander un nouveau code.");
        } else {
          await prisma.otpChallenge.update({
            where: { phone: hashValue(body.phone) },
            data: { failedAttempts: attempts }
          });
          fail(reply, 401, "invalid_otp", "Code OTP invalide ou expiré.");
        }
      } else {
        fail(reply, 401, "invalid_otp", "Code OTP invalide ou expiré.");
      }
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
        data: { fullName: "Nouveau client", phone: body.phone, role: "client" }
      });
    }

    const tokens = signSession(user.id, user.role, user.tokenVersion);
    await prisma.session.create({
      data: {
        userId: user.id,
        refreshToken: hashRefreshToken(tokens.refreshToken),
        clientType: "app",
        userAgentHash: uaHash(request),
        expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
      }
    });
    await pruneExcessSessions(user.id);
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
      where: { refreshToken: hashRefreshToken(body.refreshToken), userId: payload.sub }
    });
    if (!session || session.expiresAt < new Date()) {
      fail(reply, 401, "session_expired", "Session expirée.");
      return;
    }

    // Verify user-agent binding if the session was created with one.
    if (session.userAgentHash) {
      const currentUaHash = uaHash(request);
      if (!currentUaHash || currentUaHash !== session.userAgentHash) {
        fail(reply, 401, "device_mismatch", "Refresh interdit depuis un client différent.");
        return;
      }
    }

    const user = await prisma.user.findUnique({ where: { id: payload.sub } });
    if (!user) {
      fail(reply, 401, "user_not_found", "Utilisateur introuvable.");
      return;
    }

    await prisma.session.delete({ where: { id: session.id } });

    // Increment tokenVersion so previously-issued access tokens stop working.
    const updatedUser = await prisma.user.update({
      where: { id: user.id },
      data: { tokenVersion: { increment: 1 } },
      select: { tokenVersion: true }
    });

    const tokens = signSession(user.id, user.role, updatedUser.tokenVersion);
    await prisma.session.create({
      data: {
        userId: user.id,
        refreshToken: hashRefreshToken(tokens.refreshToken),
        clientType: session.clientType,
        userAgentHash: session.userAgentHash,
        expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
      }
    });
    ok(reply, tokens);
  }

  async logout(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff", "salon_manager"]);
      const body = refreshInputSchema.safeParse(request.body);
      if (body.success) {
        // Targeted logout: delete only the session matching this refresh token.
        await prisma.session.deleteMany({
          where: { userId: session.sub, refreshToken: hashRefreshToken(body.data.refreshToken) }
        });
      }
      // If no valid refresh token is provided, do not delete all sessions —
      // a compromised access token should not be able to evict all other devices.

      // Revoke all push tokens on logout so the device stops receiving notifications.
      await prisma.pushToken.updateMany({
        where: { userId: session.sub, revokedAt: null },
        data: { revokedAt: new Date() }
      });
    } catch {
      // logout is best-effort — always succeed
    }
    ok(reply, { revoked: true });
  }

  async me(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff", "salon_manager"]);
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
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff", "salon_manager"]);
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
        const newHash = await argon2.hash(body.newPassword!);
        await prisma.$transaction(async (tx) => {
          await tx.user.update({ where: { id: session.sub }, data: { passwordHash: newHash, tokenVersion: { increment: 1 } } });
          await tx.session.deleteMany({ where: { userId: session.sub } });
        });
        if (user.email) {
          const { buildEmailHtml } = await import("../../lib/email-html.js");
          void sendEmail({
            to: user.email,
            subject: "Mot de passe modifié | Beauté Avenue",
            text: `Bonjour ${user.fullName ?? ""},\n\nVotre mot de passe a bien été modifié. Si vous n'êtes pas à l'origine de cette action, contactez-nous immédiatement.\n\nL'équipe Beauté Avenue`,
            html: buildEmailHtml({
              preheader: "Mot de passe modifié",
              greeting: `Bonjour ${user.fullName ?? ""},`,
              bodyLines: [
                `Votre mot de passe a bien été modifié.`,
                `Si vous n'êtes pas à l'origine de cette action, contactez-nous immédiatement.`
              ],
              cta: { url: `${config.webOrigin}/pro/login`, label: "Me connecter" },
              ignoreNote: false,
              footerNote: "L'équipe Beauté Avenue"
            })
          });
        }
      }

      await prisma.$transaction(async (tx) => {
        const userUpdate: { fullName?: string; phone?: string | null } = {};
        if (body.fullName !== undefined) {
          userUpdate.fullName = body.fullName;
        }
        if (body.phone !== undefined) {
          userUpdate.phone = body.phone ? normalizePhoneNumber(body.phone) : null;
        }
        if (Object.keys(userUpdate).length > 0) {
          await tx.user.update({
            where: { id: session.sub },
            data: userUpdate
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
      } else if (
        error &&
        typeof error === "object" &&
        "code" in error &&
        (error as { code?: string }).code === "P2002"
      ) {
        fail(
          reply,
          409,
          "phone_already_used",
          "Ce numéro de téléphone est déjà utilisé par un autre compte."
        );
      } else {
        fail(reply, 500, "internal_error", "Erreur interne.");
      }
    }
  }

  async setupAccount(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { token, email, password } = request.body as { token?: string; email?: string; password?: string };
      if (!token || !email || !password || typeof token !== "string" || typeof email !== "string" || typeof password !== "string") {
        fail(reply, 400, "missing_fields", "token, email et password sont requis.");
        return;
      }
      if (password.length < 8) {
        fail(reply, 422, "password_too_short", "Le mot de passe doit contenir au moins 8 caractères.");
        return;
      }

      const user = await prisma.user.findUnique({ where: { email }, select: { id: true, role: true } });
      if (!user) {
        fail(reply, 404, "user_not_found", "Compte introuvable.");
        return;
      }

      const settingKey = `auth:setup:${user.id}`;
      const setting = await prisma.platformSetting.findUnique({ where: { key: settingKey } });
      if (!setting) {
        fail(reply, 401, "invalid_setup_token", "Lien d'activation invalide ou déjà utilisé.");
        return;
      }

      let entry: { tokenHash: string; expiresAt: number };
      try {
        entry = JSON.parse(setting.value) as { tokenHash: string; expiresAt: number };
      } catch {
        fail(reply, 401, "invalid_setup_token", "Lien d'activation corrompu.");
        return;
      }

      if (entry.expiresAt < Date.now()) {
        await prisma.platformSetting.delete({ where: { key: settingKey } }).catch(() => {});
        fail(reply, 401, "setup_token_expired", "Ce lien d'activation a expiré (72h). Contactez l'administrateur.");
        return;
      }

      const expectedHash = createHash("sha256").update(token).digest("hex");
      const tokenBuf = Buffer.from(expectedHash, "hex");
      const actualBuf = Buffer.from(entry.tokenHash, "hex");
      const valid = tokenBuf.length === actualBuf.length && timingSafeEqual(tokenBuf, actualBuf);
      if (!valid) {
        fail(reply, 401, "invalid_setup_token", "Lien d'activation invalide.");
        return;
      }

      // Token valid — set password and consume token atomically
      await prisma.$transaction([
        prisma.user.update({ where: { id: user.id }, data: { passwordHash: await argon2.hash(password), tokenVersion: { increment: 1 } } }),
        prisma.platformSetting.delete({ where: { key: settingKey } })
      ]);

      const session = signSession(user.id, user.role as import("../../lib/auth/session.js").AccessTokenRole);
      await prisma.session.create({
        data: { userId: user.id, refreshToken: hashRefreshToken(session.refreshToken), clientType: "web", expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000) }
      });
      await pruneExcessSessions(user.id);
      ok(reply, session);
    } catch (e) {
      if (e instanceof HttpAuthError) {
        fail(reply, e.statusCode, e.code, e.message);
      } else {
        fail(reply, 500, "internal_error", "Erreur interne.");
      }
    }
  }

  async forgotPassword(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { email } = request.body as { email?: string };
      if (!email || typeof email !== "string") {
        fail(reply, 400, "missing_fields", "L'adresse e-mail est requise.");
        return;
      }

      // Per-account + per-IP rate limiting: 3 req/15min per email, 30 req/min per IP
      const rl = await checkAccountRateLimit("forgot-password", email, request, 3, 30, 900);
      if (!rl.allowed) {
        fail(reply, 429, "rate_limited", `Trop de tentatives. Réessayez dans ${rl.retryAfterSeconds}s.`);
        return;
      }

      const user = await prisma.user.findUnique({
        where: { email },
        select: { id: true, role: true, email: true }
      });

      if (!user) {
        ok(reply, { sent: true });
        return;
      }

      if (!["salon_owner", "salon_manager", "salon_staff", "platform_admin"].includes(user.role)) {
        ok(reply, { sent: true });
        return;
      }

      const rawToken = randomBytes(32).toString("hex");
      const tokenHash = createHash("sha256").update(rawToken).digest("hex");
      const expiresAt = Date.now() + 72 * 60 * 60 * 1000;

      await prisma.platformSetting.upsert({
        where: { key: `auth:reset:${user.id}` },
        create: {
          group: "security",
          key: `auth:reset:${user.id}`,
          value: JSON.stringify({ tokenHash, expiresAt }),
          description: "Password reset token (single-use)"
        },
        update: { value: JSON.stringify({ tokenHash, expiresAt }) }
      });

      const resetLink = `${config.webOrigin}/pro/reset-password?token=${rawToken}&email=${encodeURIComponent(email)}`;

      const { buildEmailHtml } = await import("../../lib/email-html.js");
      await sendEmail({
        to: email,
        subject: "Réinitialisation de votre mot de passe | Beauté Avenue",
        text: `Bonjour,\n\nVous avez demandé la réinitialisation de votre mot de passe.\n\nCliquez sur le lien ci-dessous pour définir un nouveau mot de passe (valable 72h) :\n${resetLink}\n\nSi vous n'êtes pas à l'origine de cette demande, ignorez cet email.\n\nL'équipe Beauté Avenue`,
        html: buildEmailHtml({
          preheader: "Réinitialisation de votre mot de passe",
          greeting: "Bonjour,",
          bodyLines: [
            "Vous avez demandé la réinitialisation de votre mot de passe.",
            "Cliquez sur le bouton ci-dessous pour définir un nouveau mot de passe."
          ],
          cta: { url: resetLink, label: "Réinitialiser mon mot de passe" },
          expiryNote: "Ce lien expire dans 72 heures.",
          ignoreNote: true
        })
      });

      ok(reply, { sent: true });
    } catch (e) {
      logger.error("forgotPassword error", { err: String(e) });
      ok(reply, { sent: true });
    }
  }

  async resetPassword(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { token, email, password } = request.body as { token?: string; email?: string; password?: string };
      if (!token || !email || !password || typeof token !== "string" || typeof email !== "string" || typeof password !== "string") {
        fail(reply, 400, "missing_fields", "token, email et password sont requis.");
        return;
      }

      // Per-account + per-IP rate limiting: 5 req/15min per email, 30 req/min per IP
      const rl = await checkAccountRateLimit("reset-password", email, request, 5, 30, 900);
      if (!rl.allowed) {
        fail(reply, 429, "rate_limited", `Trop de tentatives. Réessayez dans ${rl.retryAfterSeconds}s.`);
        return;
      }
      if (password.length < 8) {
        fail(reply, 422, "password_too_short", "Le mot de passe doit contenir au moins 8 caractères.");
        return;
      }

      const user = await prisma.user.findUnique({ where: { email }, select: { id: true, role: true } });
      if (!user) { fail(reply, 404, "user_not_found", "Compte introuvable."); return; }

      const settingKey = `auth:reset:${user.id}`;
      const setting = await prisma.platformSetting.findUnique({ where: { key: settingKey } });
      if (!setting) { fail(reply, 401, "invalid_reset_token", "Lien de réinitialisation invalide ou déjà utilisé."); return; }

      let entry: { tokenHash: string; expiresAt: number };
      try { entry = JSON.parse(setting.value) as { tokenHash: string; expiresAt: number }; }
      catch { fail(reply, 401, "invalid_reset_token", "Lien de réinitialisation corrompu."); return; }

      if (entry.expiresAt < Date.now()) {
        await prisma.platformSetting.delete({ where: { key: settingKey } }).catch(() => {});
        fail(reply, 401, "reset_token_expired", "Ce lien a expiré (72h). Demandez un nouveau lien à l'administrateur.");
        return;
      }

      const expectedHash = createHash("sha256").update(token).digest("hex");
      const tokenBuf = Buffer.from(expectedHash, "hex");
      const actualBuf = Buffer.from(entry.tokenHash, "hex");
      const valid = tokenBuf.length === actualBuf.length && timingSafeEqual(tokenBuf, actualBuf);
      if (!valid) { fail(reply, 401, "invalid_reset_token", "Lien de réinitialisation invalide."); return; }

      await prisma.$transaction([
        prisma.user.update({ where: { id: user.id }, data: { passwordHash: await argon2.hash(password), tokenVersion: { increment: 1 } } }),
        prisma.platformSetting.delete({ where: { key: settingKey } })
      ]);

      const session = signSession(user.id, user.role as import("../../lib/auth/session.js").AccessTokenRole);
      await prisma.session.create({
        data: { userId: user.id, refreshToken: hashRefreshToken(session.refreshToken), clientType: "web", expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000) }
      });
      await pruneExcessSessions(user.id);
      ok(reply, session);
    } catch (e) {
      if (e instanceof HttpAuthError) { fail(reply, e.statusCode, e.code, e.message); }
      else { fail(reply, 500, "internal_error", "Erreur interne."); }
    }
  }

  async magicLogin(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { token, email } = request.body as { token?: string; email?: string };
      if (!token || !email || typeof token !== "string" || typeof email !== "string") {
        fail(reply, 400, "missing_fields", "token et email sont requis.");
        return;
      }

      // Per-account + per-IP rate limiting: 5 req/15min per email, 30 req/min per IP
      const rl = await checkAccountRateLimit("magic-login", email, request, 5, 30, 900);
      if (!rl.allowed) {
        fail(reply, 429, "rate_limited", `Trop de tentatives. Réessayez dans ${rl.retryAfterSeconds}s.`);
        return;
      }

      const user = await prisma.user.findUnique({ where: { email }, select: { id: true, role: true } });
      if (!user) { fail(reply, 404, "user_not_found", "Compte introuvable."); return; }

      const settingKey = `auth:magic:${user.id}`;
      const setting = await prisma.platformSetting.findUnique({ where: { key: settingKey } });
      if (!setting) { fail(reply, 401, "invalid_magic_token", "Lien de connexion invalide ou déjà utilisé."); return; }

      let entry: { tokenHash: string; expiresAt: number };
      try { entry = JSON.parse(setting.value) as { tokenHash: string; expiresAt: number }; }
      catch { fail(reply, 401, "invalid_magic_token", "Lien de connexion corrompu."); return; }

      if (entry.expiresAt < Date.now()) {
        await prisma.platformSetting.delete({ where: { key: settingKey } }).catch(() => {});
        fail(reply, 401, "magic_token_expired", "Ce lien a expiré (24h). Contactez l'administrateur pour un nouveau lien.");
        return;
      }

      const expectedHash = createHash("sha256").update(token).digest("hex");
      const tokenBuf = Buffer.from(expectedHash, "hex");
      const actualBuf = Buffer.from(entry.tokenHash, "hex");
      const valid = tokenBuf.length === actualBuf.length && timingSafeEqual(tokenBuf, actualBuf);
      if (!valid) { fail(reply, 401, "invalid_magic_token", "Lien de connexion invalide."); return; }

      if (!["salon_owner", "salon_manager", "salon_staff"].includes(user.role)) {
        fail(reply, 403, "forbidden", "Ce compte n'a pas accès à l'espace professionnel.");
        return;
      }

      // Token valid — consume token and create session atomically
      const session = signSession(user.id, user.role as import("../../lib/auth/session.js").AccessTokenRole);
      await prisma.$transaction([
        prisma.platformSetting.delete({ where: { key: settingKey } }),
        prisma.session.create({
          data: { userId: user.id, refreshToken: hashRefreshToken(session.refreshToken), clientType: "web", expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000) }
        })
      ]);
      await pruneExcessSessions(user.id);
      ok(reply, session);
    } catch (e) {
      if (e instanceof HttpAuthError) {
        fail(reply, e.statusCode, e.code, e.message);
      } else {
        fail(reply, 500, "internal_error", "Erreur interne.");
      }
    }
  }

  async redeemStaffInvite(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { token, userId } = request.body as { token?: string; userId?: string };
      if (!token || !userId || typeof token !== "string" || typeof userId !== "string") {
        fail(reply, 400, "missing_fields", "Token et userId requis.");
        return;
      }
      const inviteKey = `invite:${userId}`;
      const inviteRecord = await prisma.platformSetting.findUnique({ where: { key: inviteKey } });
      if (!inviteRecord) {
        fail(reply, 401, "invite_already_used", "Ce lien d'invitation a déjà été utilisé ou est invalide.");
        return;
      }
      let entry: { tokenHash: string; expiresAt: number };
      try { entry = JSON.parse(inviteRecord.value) as { tokenHash: string; expiresAt: number }; }
      catch { fail(reply, 401, "invalid_invite_token", "Lien d'invitation corrompu."); return; }
      if (entry.expiresAt < Date.now()) {
        await prisma.platformSetting.delete({ where: { key: inviteKey } }).catch(() => {});
        fail(reply, 401, "invite_expired", "Ce lien d'invitation a expiré (24h).");
        return;
      }
      const expectedHash = createHash("sha256").update(token).digest("hex");
      const tokenBuf = Buffer.from(expectedHash, "hex");
      const actualBuf = Buffer.from(entry.tokenHash, "hex");
      const valid = tokenBuf.length === actualBuf.length && timingSafeEqual(tokenBuf, actualBuf);
      if (!valid) {
        fail(reply, 401, "invalid_invite_token", "Lien d'invitation invalide.");
        return;
      }
      const user = await prisma.user.findUnique({
        where: { id: userId },
        select: { id: true, role: true }
      });
      if (!user || !["salon_staff", "salon_manager", "salon_owner"].includes(user.role)) {
        fail(reply, 403, "forbidden", "Ce compte n'a pas accès à l'espace professionnel.");
        return;
      }
      const session = signSession(user.id, user.role as import("../../lib/auth/session.js").AccessTokenRole);
      await prisma.$transaction(async (tx) => {
        await tx.platformSetting.delete({ where: { key: inviteKey } });
        await tx.session.create({
          data: { userId: user.id, refreshToken: hashRefreshToken(session.refreshToken), clientType: "web", expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000) }
        });
      });
      await pruneExcessSessions(user.id);
      ok(reply, session);
    } catch (e) {
      if (e instanceof HttpAuthError) {
        fail(reply, e.statusCode, e.code, e.message);
      } else {
        fail(reply, 500, "internal_error", "Erreur interne.");
      }
    }
  }

  async requestEmailOtp(request: FastifyRequest, reply: FastifyReply) {
    const body = emailOtpRequestSchema.parse(request.body);

    // Play reviewer bypass — skip rate limit, skip email send, skip challenge persistence
    if (isPlayReviewEnabled() && normalizeEmail(body.email) === normalizeEmail(config.playReviewEmail)) {
      reply.code(202).send({ accepted: true, destination: body.email });
      return;
    }

    const rateLimit = await checkOtpRateLimit(`email:${body.email}`);
    if (!rateLimit.allowed) {
      fail(reply, 429, "otp_rate_limited", `Trop de tentatives. Réessayez dans ${rateLimit.retryAfterSeconds}s.`);
      return;
    }

    const code = generateOtpCode();
    if (config.nodeEnv !== "production") {
      logger.info("[OTP-DEV] email code", { email: body.email, code });
    }
    const codeHash = otpCodeHash(body.email, code);
    await prisma.emailOtpChallenge.upsert({
      where: { email: body.email },
      create: { email: body.email, codeHash, expiresAt: new Date(Date.now() + OTP_TTL_MS), failedAttempts: 0 },
      update: { codeHash, expiresAt: new Date(Date.now() + OTP_TTL_MS), failedAttempts: 0 }
    });

    const { buildEmailHtml } = await import("../../lib/email-html.js");
    void sendEmail({
      to: body.email,
      subject: "Code de vérification | Beauté Avenue",
      text: `Bonjour,\n\nVotre code de vérification Beauté Avenue est : ${code}\n\nCe code est valable 5 minutes. Ne le partagez à personne.\n\nL'équipe Beauté Avenue`,
      html: buildEmailHtml({
        preheader: "Code de vérification",
        greeting: "Bonjour,",
        bodyLines: [
          `Votre code de vérification <strong>Beauté Avenue</strong> est :`,
          `<p style="font-family:monospace;font-size:28px;font-weight:700;letter-spacing:6px;text-align:center;padding:16px;background:#f7f4f2;border-radius:10px;margin:12px 0;color:#3c2e2a">${code}</p>`,
          `Ce code est valable <strong>5 minutes</strong>. Ne le partagez à personne.`
        ],
        cta: undefined,
        ignoreNote: false,
        footerNote: "L'équipe Beauté Avenue"
      })
    }).catch((err) => logger.error("auth.requestEmailOtp: failed to send email", { err: String(err), to: body.email }));

    reply.code(202).send({ accepted: true, destination: body.email });
  }

  async verifyEmailOtp(request: FastifyRequest, reply: FastifyReply) {
    const body = emailOtpVerifySchema.parse(request.body);

    // Play reviewer bypass — checked first, before normal OTP flow
    if (
      isPlayReviewEnabled() &&
      normalizeEmail(body.email) === normalizeEmail(config.playReviewEmail)
    ) {
      const matches = constantTimeEquals(body.code, config.playReviewOtp);
      if (!matches) {
        fail(reply, 401, "invalid_otp", "Code OTP invalide ou expiré.");
        return;
      }
      // Reviewer OTP accepted — find or create user, sign tokens
      let user = await prisma.user.findUnique({ where: { email: body.email } });
      if (!user) {
        user = await prisma.user.create({
          data: {
            fullName: reviewUserDisplayName(),
            email: body.email,
            role: "client"
          }
        });
      } else if (user.fullName.trim().length === 0) {
        user = await prisma.user.update({
          where: { id: user.id },
          data: { fullName: reviewUserDisplayName() }
        });
      }
      const tokens = signSession(user.id, user.role, user.tokenVersion);
      await prisma.session.create({
        data: {
          userId: user.id,
          refreshToken: hashRefreshToken(tokens.refreshToken),
          clientType: "app",
          userAgentHash: uaHash(request),
          expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
        }
      });
      await pruneExcessSessions(user.id);
      ok(reply, tokens);
      return;
    }

    // Normal OTP flow (unchanged)
    const entry = await prisma.emailOtpChallenge.findUnique({ where: { email: body.email } });
    const codeHash = otpCodeHash(body.email, body.code);
    const notExpired = !!entry && entry.expiresAt.getTime() > Date.now();
    const valid = notExpired && constantTimeEquals(entry!.codeHash, codeHash);

    if (!valid) {
      if (entry && notExpired) {
        const attempts = entry.failedAttempts + 1;
        if (attempts >= OTP_MAX_ATTEMPTS) {
          await prisma.emailOtpChallenge.deleteMany({ where: { email: body.email } });
          fail(reply, 429, "otp_locked", "Trop de tentatives. Veuillez demander un nouveau code.");
        } else {
          await prisma.emailOtpChallenge.update({
            where: { email: body.email },
            data: { failedAttempts: attempts }
          });
          fail(reply, 401, "invalid_otp", "Code OTP invalide ou expiré.");
        }
      } else {
        fail(reply, 401, "invalid_otp", "Code OTP invalide ou expiré.");
      }
      return;
    }
    await prisma.emailOtpChallenge.deleteMany({ where: { email: body.email } });

    // If user already exists, sign them in (login flow)
    // If not, create a new account (registration flow)
    let user = await prisma.user.findUnique({ where: { email: body.email } });
    if (!user) {
      user = await prisma.user.create({
        data: { fullName: "", email: body.email, role: "client" }
      });
    }

    const tokens = signSession(user.id, user.role, user.tokenVersion);
    await prisma.session.create({
      data: {
        userId: user.id,
        refreshToken: hashRefreshToken(tokens.refreshToken),
        clientType: "app",
        userAgentHash: uaHash(request),
        expiresAt: new Date(Date.now() + config.jwtRefreshTtlSeconds * 1000)
      }
    });
    await pruneExcessSessions(user.id);
    ok(reply, tokens);
  }

  async requestAccountDeletion(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { email } = request.body as { email?: string };
      if (!email || typeof email !== "string") {
        fail(reply, 400, "missing_fields", "L'adresse e-mail est requise.");
        return;
      }

      const rl = await checkAccountRateLimit("request-deletion", email, request, 3, 30, 900);
      if (!rl.allowed) {
        fail(reply, 429, "rate_limited", `Trop de tentatives. Réessayez dans ${rl.retryAfterSeconds}s.`);
        return;
      }

      const user = await prisma.user.findUnique({
        where: { email },
        select: { id: true, role: true, email: true }
      });

      if (!user) {
        fail(reply, 404, "user_not_found", "Aucun compte trouvé avec cette adresse e-mail.");
        return;
      }

      const userName = user.email ?? "";

      if (user.role !== "client") {
        fail(reply, 403, "forbidden", "Seuls les comptes clients peuvent être supprimés via cette page. Contactez le support.");
        return;
      }

      const rawToken = randomBytes(32).toString("hex");
      const tokenHash = createHash("sha256").update(rawToken).digest("hex");
      const expiresAt = Date.now() + 24 * 60 * 60 * 1000;

      await prisma.platformSetting.upsert({
        where: { key: `auth:delete:${user.id}` },
        create: {
          group: "security",
          key: `auth:delete:${user.id}`,
          value: JSON.stringify({ tokenHash, expiresAt }),
          description: "Account deletion token (single-use)"
        },
        update: { value: JSON.stringify({ tokenHash, expiresAt }) }
      });

      const confirmLink = `${config.webOrigin}/suppression-compte/confirm?token=${rawToken}&email=${encodeURIComponent(email)}`;

      const { buildEmailHtml } = await import("../../lib/email-html.js");
      await sendEmail({
        to: email,
        subject: "Suppression de compte | Beauté Avenue",
        text: `Bonjour,\n\nVous avez demandé la suppression de votre compte Beauté Avenue.\n\nCliquez sur le lien ci-dessous pour confirmer la suppression définitive (valable 24h) :\n${confirmLink}\n\nSi vous n'êtes pas à l'origine de cette demande, ignorez cet email.\n\nL'équipe Beauté Avenue`,
        html: buildEmailHtml({
          preheader: "Confirmation de suppression de compte",
          greeting: "Bonjour,",
          bodyLines: [
            "Vous avez demandé la suppression de votre compte Beauté Avenue.",
            "Cliquez sur le bouton ci-dessous pour confirmer la suppression définitive de votre compte et de vos données personnelles."
          ],
          cta: { url: confirmLink, label: "Confirmer la suppression" },
          expiryNote: "Ce lien expire dans 24 heures.",
          ignoreNote: true
        })
      });

      ok(reply, { sent: true });
    } catch (e) {
      logger.error("requestAccountDeletion error", { err: String(e) });
      fail(reply, 500, "internal_error", "Erreur lors de l'envoi de l'email de confirmation.");
    }
  }

  async confirmAccountDeletion(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { token, email, reasons, feedback } = request.body as {
        token?: string; email?: string; reasons?: string[]; feedback?: string;
      };
      if (!token || !email || typeof token !== "string" || typeof email !== "string") {
        fail(reply, 400, "missing_fields", "token et email sont requis.");
        return;
      }

      const rl = await checkAccountRateLimit("confirm-deletion", email, request, 5, 30, 900);
      if (!rl.allowed) {
        fail(reply, 429, "rate_limited", `Trop de tentatives. Réessayez dans ${rl.retryAfterSeconds}s.`);
        return;
      }

      const user = await prisma.user.findUnique({
        where: { email },
        select: { id: true, role: true, fullName: true }
      });
      if (!user) {
        fail(reply, 404, "user_not_found", "Compte introuvable.");
        return;
      }

      const settingKey = `auth:delete:${user.id}`;
      const setting = await prisma.platformSetting.findUnique({ where: { key: settingKey } });
      if (!setting) {
        fail(reply, 401, "invalid_token", "Lien de confirmation invalide ou déjà utilisé.");
        return;
      }

      let entry: { tokenHash: string; expiresAt: number };
      try {
        entry = JSON.parse(setting.value) as { tokenHash: string; expiresAt: number };
      } catch {
        fail(reply, 401, "invalid_token", "Lien de confirmation corrompu.");
        return;
      }

      if (entry.expiresAt < Date.now()) {
        await prisma.platformSetting.delete({ where: { key: settingKey } }).catch(() => {});
        fail(reply, 401, "token_expired", "Ce lien a expiré (24h). Faites une nouvelle demande.");
        return;
      }

      const expectedHash = createHash("sha256").update(token).digest("hex");
      const tokenBuf = Buffer.from(expectedHash, "hex");
      const actualBuf = Buffer.from(entry.tokenHash, "hex");
      const valid = tokenBuf.length === actualBuf.length && timingSafeEqual(tokenBuf, actualBuf);
      if (!valid) {
        fail(reply, 401, "invalid_token", "Lien de confirmation invalide.");
        return;
      }

      // Consume token and delete account atomically
      const validReasons = Array.isArray(reasons) ? reasons.filter(r => typeof r === "string") : [];
      const metadata = {
        ...(validReasons.length ? { reasons: validReasons } : {}),
        ...(feedback && typeof feedback === "string" && feedback.trim() ? { feedback: feedback.trim() } : {})
      };

      await prisma.$transaction([
        prisma.platformSetting.delete({ where: { key: settingKey } }),
        prisma.user.update({
          where: { id: user.id },
          data: { fullName: "Deleted User", email: `deleted+${user.id}@beauteavenue.local`, phone: null }
        }),
        prisma.clientProfile.deleteMany({ where: { userId: user.id } }),
        prisma.session.deleteMany({ where: { userId: user.id } }),
        prisma.pushToken.deleteMany({ where: { userId: user.id } }),
        prisma.clientAddress.deleteMany({ where: { userId: user.id } }),
        prisma.clientBenefit.deleteMany({ where: { userId: user.id } }),
        prisma.booking.updateMany({
          where: { clientId: user.id },
          data: { clientNote: null }
        }),
        ...(Object.keys(metadata).length ? [
          prisma.auditLog.create({
            data: {
              action: "account_deleted",
              summary: "Compte client supprimé",
              entityType: "user",
              entityId: user.id,
              actorUserId: user.id,
              actorName: "Deleted User",
              severity: "info",
              payloadJson: JSON.stringify(metadata)
            }
          })
        ] : [])
      ]);

      ok(reply, { deleted: true });
    } catch (e) {
      if (e instanceof HttpAuthError) {
        fail(reply, e.statusCode, e.code, e.message);
      } else {
        logger.error("confirmAccountDeletion error", { err: String(e) });
        fail(reply, 500, "internal_error", "Erreur lors de la suppression du compte.");
      }
    }
  }
}
