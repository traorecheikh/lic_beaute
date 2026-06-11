import { createCipheriv, createDecipheriv, randomBytes, randomUUID } from "node:crypto";
import argon2 from "argon2";
import type { FastifyReply, FastifyRequest } from "fastify";
import type { Prisma } from "../../generated/prisma/client.js";
import type { Role } from "../../generated/prisma/enums.js";

import {
  proBlockedSlotCreateInputSchema,
  proCheckoutCompleteInputSchema,
  proHoursUpdateInputSchema,
  proManualBookingInputSchema,
  proReviewResponseInputSchema,
  proSalonUpdateInputSchema,
  proServiceCreateInputSchema,
  proServiceUpdateInputSchema,
  proStaffCreateInputSchema,
  proStaffUpdateInputSchema,
  proSubscriptionCheckoutInputSchema,
  proSubscriptionUpdateInputSchema,
  proSubscriptionExecuteInputSchema,
  proCancelSubscriptionInputSchema
} from "@beauteavenue/contracts";

import { getPaymentAdapter } from "../../adapters/index.js";
import { sendEmail } from "../../lib/email.js";
import { config } from "../../config.js";
import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { fetchAndComputeAvailableSlots } from "../../lib/availability.js";
import { getOrSetCachedJson, invalidateCacheTags } from "../../lib/cache.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { enqueueJob } from "../../lib/jobs.js";
import { logger } from "../../lib/logger.js";
import { toDbProvider, toPublicBillingProvider, toPublicGatewayProvider } from "../../lib/payment-provider.js";
import { prisma } from "../../lib/db/prisma.js";
import { getProAnalytics, getProDashboard } from "./data.js";

const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  baseOrigin: config.webOrigin,
  paydunyaMasterKey: config.paydunyaMasterKey,
  paydunyaPublicKey: config.paydunyaPublicKey,
  paydunyaPrivateKey: config.paydunyaPrivateKey,
  paydunyaToken: config.paydunyaToken,
  paydunyaEnv: config.paydunyaEnv,
  paydunyaBaseUrl: config.paydunyaBaseUrl
});

function isPaydunyaTokenCompatibleWithEnv(token: string | null | undefined) {
  if (!token) return false;
  if (config.paymentDriver !== "paydunya") return true;
  if (token.startsWith("mock-")) return false;
  const isSandboxToken = token.startsWith("test_");
  return config.paydunyaEnv === "sandbox" ? isSandboxToken : !isSandboxToken;
}

function isNonReusableSubscriptionChargeError(message: string | null | undefined) {
  const normalized = message?.toLowerCase() ?? "";
  const looksAlreadyInitiated =
    normalized.includes("already initiated") ||
    normalized.includes("déjà été initié") ||
    normalized.includes("deja ete initie") ||
    normalized.includes("dej\\u00e0") ||
    normalized.includes("deja");
  return looksAlreadyInitiated && normalized.includes("initi");
}

function salonPublicPhoneKey(salonId: string) {
  return `salon:${salonId}:public_phone`;
}

function salonInstagramKey(salonId: string) {
  return `salon:${salonId}:instagram`;
}

function salonTeamShowPhotosKey(salonId: string) {
  return `salon:${salonId}:team_show_photos`;
}

function salonTeamShowDescriptionsKey(salonId: string) {
  return `salon:${salonId}:team_show_descriptions`;
}

const BILLING_ENC_PREFIX = "enc:v1:";

function getBillingKey(): Buffer {
  const raw = config.billingAccountSecret;
  if (!raw) {
    if (config.nodeEnv === "production") {
      throw new Error("BILLING_ACCOUNT_SECRET must be set in production");
    }
    return Buffer.alloc(32, "dev");
  }
  return Buffer.from(raw.slice(0, 64), "hex").subarray(0, 32);
}

function encryptBillingAccount(plaintext: string): string {
  const key = getBillingKey();
  const iv = randomBytes(12);
  const cipher = createCipheriv("aes-256-gcm", key, iv);
  const encrypted = Buffer.concat([cipher.update(plaintext, "utf8"), cipher.final()]);
  const tag = cipher.getAuthTag();
  return `${BILLING_ENC_PREFIX}${iv.toString("hex")}${tag.toString("hex")}${encrypted.toString("hex")}`;
}

function decryptBillingAccount(stored: string): string {
  if (!stored.startsWith(BILLING_ENC_PREFIX)) return stored; // legacy plaintext
  const hex = stored.slice(BILLING_ENC_PREFIX.length);
  const key = getBillingKey();
  const iv = Buffer.from(hex.slice(0, 24), "hex");
  const tag = Buffer.from(hex.slice(24, 56), "hex");
  const data = Buffer.from(hex.slice(56), "hex");
  const decipher = createDecipheriv("aes-256-gcm", key, iv, { authTagLength: 16 });
  decipher.setAuthTag(tag);
  return Buffer.concat([decipher.update(data), decipher.final()]).toString("utf8");
}

function salonBillingProviderKey(salonId: string) {
  return `salon:${salonId}:billing_provider`;
}

function salonBillingAccountKey(salonId: string) {
  return `salon:${salonId}:billing_account_number`;
}

function toSettingMap(rows: Array<{ key: string; value: string }>) {
  return Object.fromEntries(rows.map((row) => [row.key, row.value]));
}

function maskAccountNumber(value: string) {
  const trimmed = value.trim();
  if (trimmed.length <= 4) return `***${trimmed}`;
  return `${"*".repeat(Math.max(3, trimmed.length - 4))}${trimmed.slice(-4)}`;
}

function calcDepositAmount(service: {
  depositMode: string;
  depositAmountXof: number | null;
  depositPercent: number | null;
  priceXof: number;
}): number {
  if (service.depositMode === "fixed") return service.depositAmountXof ?? 0;
  if (service.depositMode === "percent") {
    return Math.round(((service.depositPercent ?? 0) / 100) * service.priceXof);
  }
  return 0;
}

function parseBooleanSetting(value: string | undefined, fallback: boolean) {
  if (!value) return fallback;
  const normalized = value.trim().toLowerCase();
  if (normalized === "true" || normalized === "1" || normalized === "yes") return true;
  if (normalized === "false" || normalized === "0" || normalized === "no") return false;
  return fallback;
}

function requiresProviderCompletion(result: { url?: string; other_url?: unknown; data?: Record<string, unknown> | undefined } & Record<string, unknown>) {
  if (result.url || result.other_url) return true;
  if (result.pendingProviderConfirmation === true || result.status === "authorized") return true;
  const message = typeof result.message === "string"
    ? result.message.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase()
    : "";
  if (
    message.includes("rediriger vers cette url") ||
    message.includes("en cours de traitement") ||
    message.includes("veuillez completer le paiement") ||
    message.includes("veuillez tapez") ||
    message.includes("compose") ||
    message.includes("valider le paiement")
  ) {
    return true;
  }
  const details = result.data && typeof result.data.details === "object" && result.data.details
    ? result.data.details as Record<string, unknown>
    : null;
  const providerStatus = typeof result.data?.status === "string" ? result.data.status.toUpperCase() : null;
  if (providerStatus === "PENDING" || providerStatus === "PROCESSING") return true;
  const cid = typeof result.data?.cid === "string" ? result.data.cid : typeof details?.cid === "string" ? details.cid : null;
  return Boolean(cid);
}

async function isTeamPhotoRequiredForSalon(salonId: string) {
  const key = salonTeamShowPhotosKey(salonId);
  const setting = await prisma.platformSetting.findUnique({
    where: { key },
    select: { value: true }
  });
  return parseBooleanSetting(setting?.value, false);
}

function escapePdfText(value: string) {
  return value.replace(/\\/g, "\\\\").replace(/\(/g, "\\(").replace(/\)/g, "\\)");
}

import { buildInvoicePdf } from "../../lib/pdf.js";

type FeatureFlags = {
  depositsEnabled: boolean;
  depositsTierRequired: "standard" | "premium";
  analyticsEnabled: boolean;
  analyticsTierRequired: "standard" | "premium";
  autoRenewEnabled: boolean;
  billingPaydunya: boolean;
  billingManual: boolean;
  cardPayments: boolean;
};

async function getFeatureFlags(): Promise<FeatureFlags> {
  const rows = await prisma.platformSetting.findMany({
    where: { group: "subscription_features" },
    select: { key: true, value: true }
  });
  const map = Object.fromEntries(rows.map((r) => [r.key, r.value]));
  return {
    depositsEnabled: parseBooleanSetting(map["feature_deposits_enabled"], true),
    depositsTierRequired: map["feature_deposits_tier_required"] === "standard" ? "standard" : "premium",
    analyticsEnabled: parseBooleanSetting(map["feature_analytics_enabled"], true),
    analyticsTierRequired: map["feature_analytics_tier_required"] === "standard" ? "standard" : "premium",
    autoRenewEnabled: parseBooleanSetting(map["feature_auto_renew_enabled"], true),
    billingPaydunya: parseBooleanSetting(map["feature_billing_paydunya"], true),
    billingManual: parseBooleanSetting(map["feature_billing_manual"], true),
    cardPayments: parseBooleanSetting(map["feature_card_payments"], false),
  };
}

async function ensurePro(request: FastifyRequest) {
  const { sub, role } = requireRole(request, ["salon_owner", "salon_manager", "salon_staff"]);
  const user = await prisma.user.findUnique({ where: { id: sub }, select: { salonId: true } });
  if (!user?.salonId) throw new HttpAuthError(403, "not_in_salon", "Vous n'êtes associé à aucun salon.");
  return { userId: sub, salonId: user.salonId, role };
}

function ownerOnly(role: string, reply: FastifyReply): boolean {
  if (role !== "salon_owner") {
    fail(reply, 403, "owner_only", "Action réservée au propriétaire du salon.");
    return false;
  }
  return true;
}

function managerOrOwner(role: string, reply: FastifyReply): boolean {
  if (role !== "salon_owner" && role !== "salon_manager") {
    fail(reply, 403, "manager_forbidden", "Action réservée aux gestionnaires.");
    return false;
  }
  return true;
}

const LOCKED_SUBSCRIPTION_STATUSES = new Set(["inactive", "paused", "cancelled", "expired"]);

async function ensureProWriteAccess(salonId: string, reply: FastifyReply): Promise<boolean> {
  const salon = await prisma.salon.findUnique({
    where: { id: salonId },
    select: { subscription: { select: { status: true } } }
  });
  const status = salon?.subscription?.status;
  if (!status || LOCKED_SUBSCRIPTION_STATUSES.has(status)) {
    fail(reply, 402, "subscription_required", "Abonnement requis pour effectuer cette action. Activez votre abonnement.");
    return false;
  }
  return true;
}

// ─── Retention offers per cancellation reason ───────────────────────────────

interface RetentionOffer {
  type: string;
  title: string;
  description: string;
}

function getRetentionOffer(reason: string, tier: "standard" | "premium"): RetentionOffer | null {
  if (!config.restrictedFeatureEnabled) return null;
  const offers: Record<string, RetentionOffer> = {
    too_expensive: {
      type: "discount",
      title: "On ne vous laisse pas partir si facilement ✊",
      description:
        tier === "premium"
          ? "On vous offre 30 jours Premium gratuits, et si vous restez, -25% sur les 3 prochains mois. Votre salon mérite le meilleur."
          : "On descend le Standard à 10 000 FCFA/mois pendant 3 mois. Vous ne perdez rien, vous économisez."
    },
    missing_features: {
      type: "feature_preview",
      title: "On a encore des cartes dans notre manche 🃏",
      description:
        "Les rapports financiers détaillés, l'intégration WhatsApp et les campagnes SMS arrivent dans 15 jours. Activez-les gratuitement dès maintenant."
    },
    low_traffic: {
      type: "visibility_boost",
      title: "Vous êtes invisible ? On vous met en lumière 🔦",
      description:
        "On vous offre 30 jours de mise en avant dans l'application + badge 'Recommandé'. Vos clientes vous trouveront."
    },
    technical_issues: {
      type: "dedicated_support",
      title: "On règle ça ensemble, maintenant 🛠️",
      description:
        "Un expert dédié vous appelle sous 24h pour résoudre tous vos problèmes techniques. Sans frais."
    },
    poor_support: {
      type: "priority_support",
      title: "On va faire mieux, promis 🤝",
      description:
        "Un gestionnaire dédié vous est attribué. Réponse sous 1h ouvrée. Priorité absolue. Essayez 30 jours."
    },
    seasonal_closure: {
      type: "pause_option",
      title: "Pas besoin de tout arrêter ⏸️",
      description:
        "Mettez votre abonnement en pause au lieu de résilier. Vos données, vos avis, votre classement restent intacts. Vous reprenez quand vous voulez."
    },
    switching_competitor: {
      type: "competitive_match",
      title: "On ne lâche pas si facilement 🥊",
      description:
        "On égalise le prix de votre concurrent ET on vous ajoute 3 mois de fonctionnalités Premium gratuitement. Personne ne fait mieux."
    },
    business_closure: {
      type: "data_preservation",
      title: "Votre histoire mérite d'être conservée 📦",
      description:
        "On garde gratuitement toutes vos données (clients, avis, historique) pendant 6 mois. Si vous rouvrez, vous repartez de zéro… mais en mieux."
    },
    payment_issues: {
      type: "manual_billing",
      title: "Le paiement, c'est pas un frein 💳",
      description:
        "Passez en facturation manuelle : on vous envoie une facture chaque mois, vous payez par virement ou Wave. Pas de frais supplémentaires."
    }
  };

  return offers[reason] ?? null;
}

export class ProController {
  // ─── Dashboard ─────────────────────────────────────────────────────────────

  async dashboard(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role, userId } = await ensurePro(request);
      const { value, cacheStatus } = await getOrSetCachedJson({
        key: `kpi:pro:dashboard:${salonId}:${role}:${userId}`,
        ttlSeconds: config.cacheTtlKpiSeconds,
        tags: ["kpi:pro"],
        load: () => getProDashboard(salonId, role, userId)
      });
      reply.header("x-cache", cacheStatus);
      ok(reply, value);
    } catch (e) { handleError(e, reply); }
  }

  // ─── Salon profile ─────────────────────────────────────────────────────────

  async getSalon(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const [salon, owner, settings] = await Promise.all([
        prisma.salon.findUnique({
          where: { id: salonId },
          include: { gallery: { orderBy: { position: "asc" } }, salonHours: { orderBy: { dayOfWeek: "asc" } } }
        }),
        prisma.user.findFirst({
          where: { salonId, role: "salon_owner" },
          select: { phone: true }
        }),
        prisma.platformSetting.findMany({
          where: {
            key: {
              in: [
                salonPublicPhoneKey(salonId),
                salonInstagramKey(salonId),
                salonTeamShowPhotosKey(salonId),
                salonTeamShowDescriptionsKey(salonId)
              ]
            }
          },
          select: { key: true, value: true }
        })
      ]);
      if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      const settingMap = toSettingMap(settings);
      const showPhotos = parseBooleanSetting(settingMap[salonTeamShowPhotosKey(salonId)], false);
      const showDescriptions = parseBooleanSetting(settingMap[salonTeamShowDescriptionsKey(salonId)], false);
      ok(reply, {
        id: salon.id, name: salon.name, category: salon.category, logoUrl: salon.logoUrl, description: salon.description, city: salon.city,
        address: salon.address, neighborhood: salon.neighborhood, latitude: salon.latitude, longitude: salon.longitude,
        phone: settingMap[salonPublicPhoneKey(salonId)] ?? owner?.phone ?? null,
        instagram: settingMap[salonInstagramKey(salonId)] ?? null,
        averageRating: salon.averageRating,
        subscriptionTier: salon.subscriptionTier, isVisibleInMarketplace: salon.isVisibleInMarketplace,
        canReceiveBookings: salon.canReceiveBookings,
        approvalStatus: salon.approvalStatus,
        teamDisplay: { showPhotos, showDescriptions },
        gallery: salon.gallery.map((g) => g.url),
        hours: salon.salonHours.map((h) => ({ dayOfWeek: h.dayOfWeek, isOpen: h.isOpen, opensAt: h.opensAt, closesAt: h.closesAt }))
      });
    } catch (e) { handleError(e, reply); }
  }

  async updateSalon(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const body = proSalonUpdateInputSchema.parse(request.body);
      const { gallery, phone, instagram, teamDisplay, ...salonPayload } = body;

      const currentSalon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true, approvalStatus: true, name: true } });

      if (gallery !== undefined) {
        if (currentSalon?.subscriptionTier === "standard" && gallery.length > 3) {
          fail(reply, 422, "gallery_limit", "Les salons Standard sont limités à 3 photos de galerie.");
          return;
        }
      }

      const isResubmission = currentSalon?.approvalStatus === "needs_info";
      if (isResubmission) {
        (salonPayload as Record<string, unknown>).approvalStatus = "pending_review";
      }

      if (teamDisplay?.showPhotos === true) {
        const activeWithoutAvatarCount = await prisma.employee.count({
          where: { salonId, isActive: true, avatarUrl: null }
        });
        if (activeWithoutAvatarCount > 0) {
          fail(
            reply,
            422,
            "team_photo_required",
            "Activez des photos équipe uniquement après avoir ajouté une photo à chaque collaborateur actif."
          );
          return;
        }
      }

      await prisma.$transaction(async (tx) => {
        await tx.salon.update({ where: { id: salonId }, data: salonPayload });
        if (gallery !== undefined) {
          await tx.salonGalleryImage.deleteMany({ where: { salonId } });
          if (gallery.length > 0) {
            await tx.salonGalleryImage.createMany({
              data: gallery.map((url, position) => ({ salonId, url, position }))
            });
          }
        }

        if (phone !== undefined) {
          const normalizedPhone = phone?.trim() ?? "";
          const key = salonPublicPhoneKey(salonId);
          if (normalizedPhone.length === 0) {
            await tx.platformSetting.deleteMany({ where: { key } });
          } else {
            await tx.platformSetting.upsert({
              where: { key },
              create: {
                group: "salon_profile",
                key,
                value: normalizedPhone,
                description: `Public phone for salon ${salonId}`
              },
              update: { value: normalizedPhone }
            });
          }
        }

        if (instagram !== undefined) {
          const normalizedInstagram = instagram?.trim() ?? "";
          const key = salonInstagramKey(salonId);
          if (normalizedInstagram.length === 0) {
            await tx.platformSetting.deleteMany({ where: { key } });
          } else {
            await tx.platformSetting.upsert({
              where: { key },
              create: {
                group: "salon_profile",
                key,
                value: normalizedInstagram,
                description: `Instagram profile for salon ${salonId}`
              },
              update: { value: normalizedInstagram }
            });
          }
        }

        if (teamDisplay?.showPhotos !== undefined) {
          const key = salonTeamShowPhotosKey(salonId);
          await tx.platformSetting.upsert({
            where: { key },
            create: {
              group: "salon_profile",
              key,
              value: teamDisplay.showPhotos ? "true" : "false",
              description: `Display team member photos for salon ${salonId}`
            },
            update: { value: teamDisplay.showPhotos ? "true" : "false" }
          });
        }

        if (teamDisplay?.showDescriptions !== undefined) {
          const key = salonTeamShowDescriptionsKey(salonId);
          await tx.platformSetting.upsert({
            where: { key },
            create: {
              group: "salon_profile",
              key,
              value: teamDisplay.showDescriptions ? "true" : "false",
              description: `Display team member descriptions for salon ${salonId}`
            },
            update: { value: teamDisplay.showDescriptions ? "true" : "false" }
          });
        }
      });
      if (isResubmission) {
        void enqueueJob({
          type: "salon_submitted_admin",
          payload: { salonId, salonName: currentSalon?.name ?? salonId, resubmission: true }
        }).catch((err) => logger.warn("updateSalon: salon_submitted_admin enqueue failed", { err }));
      }

      await invalidateCacheTags(["catalog:list", `catalog:salon:${salonId}`, "kpi:pro", "kpi:admin"]);
      const [salon, owner, settings] = await Promise.all([
        prisma.salon.findUnique({
          where: { id: salonId },
          include: { gallery: { orderBy: { position: "asc" } }, salonHours: { orderBy: { dayOfWeek: "asc" } } }
        }),
        prisma.user.findFirst({
          where: { salonId, role: "salon_owner" },
          select: { phone: true }
        }),
        prisma.platformSetting.findMany({
          where: {
            key: {
              in: [
                salonPublicPhoneKey(salonId),
                salonInstagramKey(salonId),
                salonTeamShowPhotosKey(salonId),
                salonTeamShowDescriptionsKey(salonId)
              ]
            }
          },
          select: { key: true, value: true }
        })
      ]);
      if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      const settingMap = toSettingMap(settings);
      const showPhotos = parseBooleanSetting(settingMap[salonTeamShowPhotosKey(salonId)], false);
      const showDescriptions = parseBooleanSetting(settingMap[salonTeamShowDescriptionsKey(salonId)], false);
      await prisma.auditLog.create({
        data: { action: "pro_salon_updated", summary: `Salon ${salonId} mis à jour`, entityType: "Salon", entityId: salonId, actorName: "salon_owner", severity: "info", payloadJson: JSON.stringify(body) }
      });
      ok(reply, {
        id: salon.id, name: salon.name, category: salon.category, logoUrl: salon.logoUrl, description: salon.description, city: salon.city,
        address: salon.address, neighborhood: salon.neighborhood, latitude: salon.latitude, longitude: salon.longitude, averageRating: salon.averageRating,
        phone: settingMap[salonPublicPhoneKey(salonId)] ?? owner?.phone ?? null,
        instagram: settingMap[salonInstagramKey(salonId)] ?? null,
        subscriptionTier: salon.subscriptionTier, isVisibleInMarketplace: salon.isVisibleInMarketplace,
        canReceiveBookings: salon.canReceiveBookings,
        teamDisplay: { showPhotos, showDescriptions },
        gallery: salon.gallery.map((g) => g.url),
        hours: salon.salonHours.map((h) => ({ dayOfWeek: h.dayOfWeek, isOpen: h.isOpen, opensAt: h.opensAt, closesAt: h.closesAt }))
      });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Services ──────────────────────────────────────────────────────────────

  async listServices(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const services = await prisma.service.findMany({
        where: { salonId, isActive: true },
        orderBy: { displayOrder: "asc" }
      });
      ok(reply, services.map((s) => ({ id: s.id, name: s.name, category: s.category, durationMinutes: s.durationMinutes, priceXof: s.priceXof, depositMode: s.depositMode, depositAmountXof: s.depositAmountXof, depositPercent: s.depositPercent, isActive: s.isActive, displayOrder: s.displayOrder })));
    } catch (e) { handleError(e, reply); }
  }

  async createService(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const body = proServiceCreateInputSchema.parse(request.body);
      if (body.depositMode !== "none") {
        const flags = await getFeatureFlags();
        if (!flags.depositsEnabled) {
          fail(reply, 422, "deposits_disabled", "Les acomptes sont désactivés pour le moment.");
          return;
        }
        const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true, subscription: { select: { status: true } } } });
        if (salon?.subscription?.status !== "active") {
          fail(reply, 403, "subscription_inactive", "Abonnement inactif ou expiré."); return;
        }
        if (flags.depositsTierRequired === "premium" && salon?.subscriptionTier !== "premium") {
          fail(reply, 402, "premium_required", "Les dépôts en ligne sont réservés aux salons Premium."); return;
        }
      }
      if (body.depositMode === "fixed" && !body.depositAmountXof) {
        fail(reply, 422, "invalid_deposit", "depositAmountXof requis pour depositMode=fixed."); return;
      }
      if (body.depositMode === "percent" && !body.depositPercent) {
        fail(reply, 422, "invalid_deposit", "depositPercent requis pour depositMode=percent."); return;
      }
      const count = await prisma.service.count({ where: { salonId } });
      const service = await prisma.service.create({
        data: { salonId, displayOrder: count, ...body }
      });
      await invalidateCacheTags(["catalog:list", `catalog:salon:${salonId}`, "kpi:pro", "kpi:admin"]);
      ok(reply, { id: service.id, name: service.name, category: service.category, durationMinutes: service.durationMinutes, priceXof: service.priceXof, depositMode: service.depositMode, depositAmountXof: service.depositAmountXof, depositPercent: service.depositPercent, isActive: service.isActive, displayOrder: service.displayOrder }, 201);
    } catch (e) { handleError(e, reply); }
  }

  async updateService(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { serviceId: string };
      const body = proServiceUpdateInputSchema.parse(request.body);
      const existing = await prisma.service.findFirst({ where: { id: params.serviceId, salonId } });
      if (!existing) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }
      if (body.depositMode !== undefined && body.depositMode !== "none") {
        const flags = await getFeatureFlags();
        if (!flags.depositsEnabled) {
          fail(reply, 422, "deposits_disabled", "Les acomptes sont désactivés pour le moment.");
          return;
        }
        const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true, subscription: { select: { status: true } } } });
        if (salon?.subscription?.status !== "active") {
          fail(reply, 403, "subscription_inactive", "Abonnement inactif ou expiré."); return;
        }
        if (flags.depositsTierRequired === "premium" && salon?.subscriptionTier !== "premium") {
          fail(reply, 402, "premium_required", "Les dépôts en ligne sont réservés aux salons Premium."); return;
        }
      }
      const effectiveMode = body.depositMode ?? existing.depositMode;
      const effectiveAmount = body.depositAmountXof ?? existing.depositAmountXof;
      const effectivePercent = body.depositPercent ?? existing.depositPercent;
      if (effectiveMode === "fixed" && !effectiveAmount) {
        fail(reply, 422, "invalid_deposit", "depositAmountXof requis pour depositMode=fixed."); return;
      }
      if (effectiveMode === "percent" && !effectivePercent) {
        fail(reply, 422, "invalid_deposit", "depositPercent requis pour depositMode=percent."); return;
      }
      const service = await prisma.service.update({ where: { id: params.serviceId }, data: body });
      await invalidateCacheTags(["catalog:list", `catalog:salon:${salonId}`, "kpi:pro", "kpi:admin"]);
      ok(reply, { id: service.id, name: service.name, category: service.category, durationMinutes: service.durationMinutes, priceXof: service.priceXof, depositMode: service.depositMode, depositAmountXof: service.depositAmountXof, depositPercent: service.depositPercent, isActive: service.isActive, displayOrder: service.displayOrder });
    } catch (e) { handleError(e, reply); }
  }

  async deleteService(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { serviceId: string };
      const existing = await prisma.service.findFirst({ where: { id: params.serviceId, salonId } });
      if (!existing) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }
      await prisma.service.update({ where: { id: params.serviceId }, data: { isActive: false } });
      await invalidateCacheTags(["catalog:list", `catalog:salon:${salonId}`, "kpi:pro", "kpi:admin"]);
      ok(reply, { deleted: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Staff ─────────────────────────────────────────────────────────────────

  async listStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId, role } = await ensurePro(request);
      const where: Prisma.EmployeeWhereInput = { salonId };
      
      // Staff can only see themselves in the list (for profile/settings)
      // Managers and owners see everyone
      if (role === "salon_staff") {
        where.userId = userId;
      }

      const staff = await prisma.employee.findMany({
        where,
        include: { 
          specialties: { select: { serviceId: true } },
          user: { select: { email: true, phone: true, role: true } }
        }
      });
      ok(reply, staff.map((e) => ({
        id: e.id,
        userId: e.userId,
        displayName: e.displayName,
        email: e.user.email,
        phone: e.user.phone,
        role: e.user.role,
        avatarUrl: e.avatarUrl,
        description: e.description,
        isActive: e.isActive,
        schedulingEnabled: e.schedulingEnabled,
        serviceIds: e.specialties.map((s) => s.serviceId)
      })));
    } catch (e) { handleError(e, reply); }
  }

  async createStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!managerOrOwner(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const body = proStaffCreateInputSchema.parse(request.body);
      const normalizedAvatarUrl = body.avatarUrl?.trim() ? body.avatarUrl.trim() : null;
      const normalizedDescription = body.description?.trim() ? body.description.trim() : null;
      const photoRequired = await isTeamPhotoRequiredForSalon(salonId);

      if (photoRequired && !normalizedAvatarUrl) {
        fail(reply, 422, "team_photo_required", "Photo obligatoire pour activer un collaborateur.");
        return;
      }

      if (body.serviceIds.length > 0) {
        const salonServices = await prisma.service.findMany({
          where: { salonId, id: { in: body.serviceIds } },
          select: { id: true }
        });
        if (salonServices.length !== body.serviceIds.length) {
          fail(reply, 422, "invalid_specialty", "Un ou plusieurs services n'appartiennent pas à ce salon.");
          return;
        }
      }

      const result = await prisma.$transaction(async (tx) => {
        const existing = await tx.user.findFirst({
          where: {
            OR: [
              body.phone ? { phone: body.phone } : null,
              body.email ? { email: body.email } : null
            ].filter(Boolean) as Prisma.UserWhereInput[]
          }
        });

        if (existing && existing.salonId && existing.salonId !== salonId) {
          throw new HttpAuthError(409, "user_in_other_salon", "Cet utilisateur appartient à un autre salon.");
        }
        if (existing && existing.role === "salon_owner") {
          throw new HttpAuthError(422, "cannot_staff_owner", "Impossible d'ajouter un propriétaire de salon comme employé.");
        }

        const passwordHash = body.password ? await argon2.hash(body.password) : undefined;

        const user = existing
          ? await tx.user.update({
              where: { id: existing.id },
              data: { 
                fullName: body.fullName, 
                role: body.role as Role, 
                salonId,
                email: body.email ?? existing.email,
                phone: body.phone ?? existing.phone,
                passwordHash: passwordHash ?? existing.passwordHash
              }
            })
          : await tx.user.create({
              data: { 
                fullName: body.fullName, 
                phone: body.phone, 
                email: body.email,
                passwordHash,
                role: body.role as Role, 
                salonId 
              }
            });

        const employee = await tx.employee.create({
          data: {
            salonId,
            userId: user.id,
            displayName: body.fullName,
            avatarUrl: normalizedAvatarUrl,
            description: normalizedDescription
          }
        });

        if (body.serviceIds.length > 0) {
          await tx.employeeSpecialty.createMany({
            data: body.serviceIds.map((serviceId) => ({ employeeId: employee.id, serviceId }))
          });
        }

        return { employee, user, serviceIds: body.serviceIds };
      });

      // Send invite email if the staff has an email address
      if (result.user.email) {
        try {
          const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { name: true } });
          const jwt = await import("jsonwebtoken");
          const crypto = await import("node:crypto");
          const jti = crypto.randomUUID();
          const token = jwt.default.sign(
            { sub: result.user.id, type: "staff_invite", jti },
            config.jwtInviteSecret,
            { expiresIn: "24h" }
          );
          await prisma.platformSetting.create({
            data: { group: "security", key: `invite:${jti}`, value: "pending", description: `Staff invite token for ${result.user.id}` }
          });
          const loginUrl = `${config.webOrigin}/pro/login?inviteToken=${encodeURIComponent(token)}`;
          const staffName = result.user.fullName;
          const salonName = salon?.name ?? "Votre salon";
          await sendEmail({
            to: result.user.email,
            subject: `Votre accès à ${salonName} — Beauté Avenue`,
            text: [
              `Bonjour ${staffName},`,
              ``,
              `${salonName} vous a invité(e) à rejoindre l'espace professionnel Beauté Avenue.`,
              ``,
              `Accédez à votre compte (lien valable 24h) :`,
              loginUrl,
              ``,
              `Si vous ne connaissez pas ce salon, ignorez ce message.`
            ].join("\n")
          });
        } catch (emailErr) {
          logger.warn("createStaff: invite email failed", { userId: result.user.id, email: result.user.email, err: emailErr });
        }
      }

      ok(reply, {
        id: result.employee.id,
        userId: result.employee.userId,
        displayName: result.employee.displayName,
        email: result.user.email,
        phone: result.user.phone,
        role: result.user.role,
        avatarUrl: result.employee.avatarUrl,
        description: result.employee.description,
        isActive: result.employee.isActive,
        schedulingEnabled: result.employee.schedulingEnabled,
        serviceIds: result.serviceIds
      }, 201);
    } catch (e) { handleError(e, reply); }
  }

  async updateStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!managerOrOwner(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { employeeId: string };
      const body = proStaffUpdateInputSchema.parse(request.body);
      const existing = await prisma.employee.findFirst({ 
        where: { id: params.employeeId, salonId },
        include: { user: true }
      });
      if (!existing) { fail(reply, 404, "employee_not_found", "Employé introuvable."); return; }
      const photoRequired = await isTeamPhotoRequiredForSalon(salonId);
      const nextAvatar = body.avatarUrl === undefined
        ? existing.avatarUrl
        : (body.avatarUrl?.trim() ? body.avatarUrl.trim() : null);
      const nextIsActive = body.isActive ?? existing.isActive;
      if (photoRequired && nextIsActive && !nextAvatar) {
        fail(reply, 422, "team_photo_required", "Photo obligatoire pour activer un collaborateur.");
        return;
      }

      if (body.serviceIds !== undefined && body.serviceIds.length > 0) {
        const salonServices = await prisma.service.findMany({
          where: { salonId, id: { in: body.serviceIds } },
          select: { id: true }
        });
        if (salonServices.length !== body.serviceIds.length) {
          fail(reply, 422, "invalid_specialty", "Un ou plusieurs services n'appartiennent pas à ce salon.");
          return;
        }
      }

      await prisma.$transaction(async (tx) => {
        await tx.employee.update({
          where: { id: params.employeeId },
          data: {
            displayName: body.displayName,
            avatarUrl: body.avatarUrl === undefined ? undefined : nextAvatar,
            description: body.description === undefined ? undefined : (body.description?.trim() ? body.description.trim() : null),
            isActive: body.isActive,
            schedulingEnabled: body.schedulingEnabled
          }
        });

        if (body.role !== undefined) {
          await tx.user.update({
            where: { id: existing.userId },
            data: {
              role: body.role as Role | undefined
            }
          });
        }

        if (body.serviceIds !== undefined) {
          await tx.employeeSpecialty.deleteMany({ where: { employeeId: params.employeeId } });
          if (body.serviceIds.length > 0) {
            await tx.employeeSpecialty.createMany({
              data: body.serviceIds.map((serviceId) => ({ employeeId: params.employeeId, serviceId }))
            });
          }
        }
      });

      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  async deleteStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { employeeId: string };
      const existing = await prisma.employee.findFirst({ where: { id: params.employeeId, salonId } });
      if (!existing) { fail(reply, 404, "employee_not_found", "Employé introuvable."); return; }
      await prisma.employee.update({ where: { id: params.employeeId }, data: { isActive: false } });
      ok(reply, { deleted: true });
    } catch (e) { handleError(e, reply); }
  }

  async resendStaffInvite(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!managerOrOwner(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { employeeId: string };
      const employee = await prisma.employee.findFirst({
        where: { id: params.employeeId, salonId },
        include: { user: true, salon: { select: { name: true } } }
      });
      if (!employee) { fail(reply, 404, "employee_not_found", "Employé introuvable."); return; }
      if (!employee.user.email) {
        fail(reply, 422, "no_email", "Cet employé n'a pas d'adresse e-mail. Ajoutez-en une pour lui envoyer une invitation.");
        return;
      }

      // Generate a short-lived signed invite token with one-time-use tracking
      const jwt = await import("jsonwebtoken");
      const crypto = await import("node:crypto");
      const jti = crypto.randomUUID();
      const token = jwt.default.sign(
        { sub: employee.user.id, type: "staff_invite", jti },
        config.jwtInviteSecret,
        { expiresIn: "24h" }
      );
      await prisma.platformSetting.create({
        data: { group: "security", key: `invite:${jti}`, value: "pending", description: `Staff invite token for ${employee.user.id}` }
      });

      const loginUrl = `${config.webOrigin}/pro/login?inviteToken=${encodeURIComponent(token)}`;
      const staffName = employee.user.fullName;
      const salonName = employee.salon.name;
      await sendEmail({
        to: employee.user.email,
        subject: `Votre accès à ${salonName} — Beauté Avenue`,
        text: [
          `Bonjour ${staffName},`,
          ``,
          `${salonName} vous a invité(e) à rejoindre l'espace professionnel Beauté Avenue.`,
          ``,
          `Accédez à votre compte (lien valable 24h) :`,
          loginUrl,
          ``,
          `Si vous ne connaissez pas ce salon, ignorez ce message.`
        ].join("\n")
      });

      ok(reply, { sent: true, email: employee.user.email });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Hours ─────────────────────────────────────────────────────────────────

  async getHours(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const hours = await prisma.salonHours.findMany({ where: { salonId }, orderBy: { dayOfWeek: "asc" } });
      ok(reply, hours.map((h) => ({ dayOfWeek: h.dayOfWeek, isOpen: h.isOpen, opensAt: h.opensAt, closesAt: h.closesAt })));
    } catch (e) { handleError(e, reply); }
  }

  async updateHours(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const body = proHoursUpdateInputSchema.parse(request.body);
      if (!body.some((h) => h.isOpen)) { fail(reply, 422, "no_open_day", "Au moins un jour doit être ouvert."); return; }

      await prisma.$transaction(
        body.map((h) =>
          prisma.salonHours.upsert({
            where: { salonId_dayOfWeek: { salonId, dayOfWeek: h.dayOfWeek } },
            create: { salonId, dayOfWeek: h.dayOfWeek, isOpen: h.isOpen, opensAt: h.opensAt ?? null, closesAt: h.closesAt ?? null },
            update: { isOpen: h.isOpen, opensAt: h.opensAt ?? null, closesAt: h.closesAt ?? null }
          })
        )
      );

      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Blocked slots ─────────────────────────────────────────────────────────

  async listBlockedSlots(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const slots = await prisma.blockedSlot.findMany({ where: { salonId }, orderBy: { startsAt: "asc" } });
      ok(reply, slots.map((s) => ({ id: s.id, startsAt: s.startsAt.toISOString(), endsAt: s.endsAt.toISOString(), reason: s.reason, scope: s.scope, employeeId: s.employeeId })));
    } catch (e) { handleError(e, reply); }
  }

  async createBlockedSlot(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId } = await ensurePro(request);
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const body = proBlockedSlotCreateInputSchema.parse(request.body);
      const startsAt = new Date(body.startsAt);
      const endsAt = new Date(body.endsAt);

      if (startsAt.getTime() >= endsAt.getTime()) {
        fail(reply, 422, "invalid_time_range", "L'heure de fin doit être après l'heure de début.");
        return;
      }
      if (body.scope === "employee" && !body.employeeId) {
        fail(reply, 422, "employee_required", "Un employé est requis pour un blocage scope=employee.");
        return;
      }
      if (body.scope === "salon" && body.employeeId) {
        fail(reply, 422, "employee_forbidden", "Ne fournissez pas d'employé pour un blocage scope=salon.");
        return;
      }
      if (body.employeeId) {
        const employee = await prisma.employee.findFirst({
          where: { id: body.employeeId, salonId, isActive: true }
        });
        if (!employee) {
          fail(reply, 422, "employee_not_found", "Employé introuvable pour ce salon.");
          return;
        }
      }

      const slot = await prisma.blockedSlot.create({
        data: { salonId, startsAt, endsAt, reason: body.reason ?? null, scope: body.scope, employeeId: body.employeeId ?? null, createdByUserId: userId }
      });
      ok(reply, { id: slot.id, startsAt: slot.startsAt.toISOString(), endsAt: slot.endsAt.toISOString(), reason: slot.reason, scope: slot.scope, employeeId: slot.employeeId }, 201);
    } catch (e) { handleError(e, reply); }
  }

  async deleteBlockedSlot(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { slotId: string };
      const existing = await prisma.blockedSlot.findFirst({ where: { id: params.slotId, salonId } });
      if (!existing) { fail(reply, 404, "slot_not_found", "Créneau bloqué introuvable."); return; }
      await prisma.blockedSlot.delete({ where: { id: params.slotId } });
      ok(reply, { deleted: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Bookings ──────────────────────────────────────────────────────────────

  async listBookings(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId, role } = await ensurePro(request);
      const q = request.query as { status?: string; date?: string; page?: string; pageSize?: string };
      const page = Math.max(0, parseInt(q.page ?? "0", 10));
      const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

      const where: Prisma.BookingWhereInput = { salonId };
      
      if (role === "salon_staff") {
        const employee = await prisma.employee.findFirst({ where: { userId, salonId } });
        if (employee) {
          where.employeeId = employee.id;
        } else {
          // If for some reason staff has no employee record, they see nothing
          where.id = "none";
        }
      }

      if (q.status) where.status = q.status as any;
      if (q.date) {
        const d = new Date(q.date + "T00:00:00");
        const next = new Date(d); next.setDate(next.getDate() + 1);
        where.startsAt = { gte: d, lt: next };
      }

      const bookings = await prisma.booking.findMany({
        where,
        include: { client: { select: { fullName: true, phone: true } }, service: { select: { name: true } }, employee: { select: { displayName: true } }, payments: { take: 1, orderBy: { createdAt: "desc" } } },
        orderBy: [{ status: "asc" }, { startsAt: "asc" }],
        take: pageSize,
        skip: page * pageSize
      });

      ok(reply, bookings.map((b) => ({
        id: b.id, salonId: b.salonId, serviceId: b.serviceId, serviceName: b.service.name,
        employeeId: b.employeeId, employeeName: b.employee?.displayName ?? null,
        clientId: b.clientId, clientName: b.client?.fullName ?? null, clientPhone: b.client?.phone ?? null,
        startsAt: b.startsAt.toISOString(), endsAt: b.endsAt.toISOString(),
        status: b.status, source: b.source, depositAmountXof: b.depositAmountXof,
        createdAt: b.createdAt.toISOString()
      })));
    } catch (e) { handleError(e, reply); }
  }

  async getBooking(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const params = request.params as { bookingId: string };
      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, salonId },
        include: {
          client: { select: { fullName: true, phone: true } },
          service: { select: { name: true } },
          employee: { select: { displayName: true } },
          payments: { orderBy: { createdAt: "desc" } },
          bookingEvents: { orderBy: { createdAt: "asc" } }
        }
      });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      ok(reply, {
        id: booking.id, salonId: booking.salonId, serviceId: booking.serviceId, serviceName: booking.service.name,
        employeeId: booking.employeeId, employeeName: booking.employee?.displayName ?? null,
        clientId: booking.clientId, clientName: booking.client?.fullName ?? null, clientPhone: booking.client?.phone ?? null,
        startsAt: booking.startsAt.toISOString(), endsAt: booking.endsAt.toISOString(),
        status: booking.status, source: booking.source, depositAmountXof: booking.depositAmountXof,
        createdAt: booking.createdAt.toISOString(),
        payments: booking.payments.map((p) => ({ id: p.id, status: p.status, amountXof: p.amountXof, provider: toPublicGatewayProvider(p.provider) })),
        events: booking.bookingEvents.map((e) => ({ eventType: e.eventType, fromStatus: e.fromStatus, toStatus: e.toStatus, createdAt: e.createdAt.toISOString() }))
      });
    } catch (e) { handleError(e, reply); }
  }

  private async transitionBooking(
    request: FastifyRequest, reply: FastifyReply,
    allowedFrom: string[], toStatus: string, eventType: string,
    afterHook?: (bookingId: string, tx: Parameters<Parameters<typeof prisma.$transaction>[0]>[0]) => Promise<void>
  ) {
    try {
      const { salonId, userId } = await ensurePro(request);
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { bookingId: string };
      const booking = await prisma.booking.findFirst({ where: { id: params.bookingId, salonId } });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      if (!allowedFrom.includes(booking.status)) {
        fail(reply, 422, "invalid_status", `Transition invalide depuis ${booking.status}.`); return;
      }

      await prisma.$transaction(async (tx) => {
        const claimed = await tx.booking.updateMany({
          where: { id: booking.id, status: { in: allowedFrom as never[] } },
          data: { status: toStatus as never }
        });
        if (claimed.count === 0) {
          throw new HttpAuthError(409, "status_conflict", "Statut modifié en parallèle. Réessayez.");
        }
        await tx.bookingEvent.create({ data: { bookingId: booking.id, actorUserId: userId, eventType, fromStatus: booking.status, toStatus } });
        await tx.auditLog.create({
          data: {
            action: `booking_${eventType}`,
            summary: `Transition ${booking.id}: ${booking.status} -> ${toStatus}`,
            entityType: "Booking",
            entityId: booking.id,
            actorName: "pro",
            actorUserId: userId,
            severity: toStatus === "cancelled" ? "warn" : "info",
            payloadJson: JSON.stringify({
              bookingId: booking.id,
              salonId,
              fromStatus: booking.status,
              toStatus,
              eventType
            })
          }
        });
        if (afterHook) await afterHook(booking.id, tx);
      });

      ok(reply, { status: toStatus });
    } catch (e) { handleError(e, reply); }
  }

  async acceptBooking(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const params = request.params as { bookingId: string };
      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, salonId },
        include: {
          payments: {
            where: { status: { in: ["authorized", "succeeded"] } },
            take: 1
          }
        }
      });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      if (booking.depositAmountXof > 0 && booking.payments.length === 0) {
        fail(
          reply,
          422,
          "deposit_not_paid",
          "Acompte non payé. La réservation reste en attente jusqu'au paiement."
        );
        return;
      }
    } catch (e) {
      handleError(e, reply);
      return;
    }
    await this.transitionBooking(request, reply, ["pending"], "confirmed", "accepted", async (bookingId, tx) => {
      const b = await tx.booking.findUnique({ where: { id: bookingId }, select: { startsAt: true, clientId: true } });
      if (!b) return;
      const now = Date.now();
      const runAfter24h = new Date(b.startsAt.getTime() - 24 * 60 * 60 * 1000);
      const runAfter1h = new Date(b.startsAt.getTime() - 60 * 60 * 1000);
      if (runAfter24h.getTime() > now) {
        await enqueueJob({ type: "booking_reminder", payload: { bookingId, window: "24h" }, bookingId, runAfter: runAfter24h, dbClient: tx });
      }
      if (runAfter1h.getTime() > now) {
        await enqueueJob({ type: "booking_reminder", payload: { bookingId, window: "1h" }, bookingId, runAfter: runAfter1h, dbClient: tx });
      }
    });
  }

  async rejectBooking(request: FastifyRequest, reply: FastifyReply) {
    await this.transitionBooking(request, reply, ["pending", "confirmed"], "cancelled", "rejected", async (bookingId, tx) => {
      const payment = await tx.payment.findFirst({ where: { bookingId, status: { in: ["authorized", "succeeded"] } } });
      if (payment) {
        await enqueueJob({
          type: "refund_reconciliation",
          payload: { paymentId: payment.id, bookingId },
          dbClient: tx
        });
      }
    });
    await invalidateCacheTags(["kpi:pro", "kpi:admin"]);
  }

  async startBooking(request: FastifyRequest, reply: FastifyReply) {
    await this.transitionBooking(request, reply, ["confirmed"], "in_progress", "started");
  }

  async completeBooking(request: FastifyRequest, reply: FastifyReply) {
    await this.transitionBooking(request, reply, ["in_progress"], "completed", "completed", async (bookingId, tx) => {
      await enqueueJob({ type: "deposit_settlement", payload: { bookingId }, dbClient: tx });
    });
    await invalidateCacheTags(["kpi:pro", "kpi:admin"]);
  }

  async createManualBooking(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId } = await ensurePro(request);
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const body = proManualBookingInputSchema.parse(request.body);

      const service = await prisma.service.findFirst({ where: { id: body.serviceId, salonId, isActive: true } });
      if (!service) { fail(reply, 422, "service_not_found", "Service introuvable."); return; }

      const startsAt = new Date(body.startsAt);
      if (startsAt.getTime() <= Date.now()) {
        fail(reply, 422, "invalid_start_time", "La réservation doit être planifiée dans le futur.");
        return;
      }
      const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);
      const date = new Date(startsAt.getFullYear(), startsAt.getMonth(), startsAt.getDate());
      const dayOfWeek = startsAt.getDay();

      if (body.employeeId) {
        const employee = await prisma.employee.findFirst({
          where: { id: body.employeeId, salonId, isActive: true, schedulingEnabled: true },
          include: { specialties: { select: { serviceId: true } } }
        });
        if (!employee) {
          fail(reply, 422, "employee_not_available", "Employé introuvable ou indisponible.");
          return;
        }
        if (employee.specialties.length > 0 && !employee.specialties.some((s) => s.serviceId === body.serviceId)) {
          fail(reply, 422, "employee_service_mismatch", "Cet employé ne propose pas ce service.");
          return;
        }
      }

      const availableSlots = await fetchAndComputeAvailableSlots(prisma, {
        salonId,
        date,
        durationMinutes: service.durationMinutes,
        employeeId: body.employeeId
      });

      const slotAvailable = availableSlots.some((s) => new Date(s.startsAt).getTime() === startsAt.getTime());
      if (!slotAvailable) {
        fail(reply, 422, "slot_unavailable", "Ce créneau n'est plus disponible.");
        return;
      }

      const booking = await prisma.$transaction(async (tx) => {
        let resolvedClientId = body.clientId;

        if (!resolvedClientId) {
          if (!body.clientPhone) {
            throw new HttpAuthError(422, "client_required", "Client ou numéro de téléphone requis.");
          }

          const existingClient = await tx.user.findUnique({
            where: { phone: body.clientPhone }
          });

          if (existingClient) {
            if (existingClient.role !== "client") {
              throw new HttpAuthError(422, "client_role_invalid", "Le contact fourni n'est pas un compte client.");
            }
            resolvedClientId = existingClient.id;
          } else {
            const newClient = await tx.user.create({
              data: {
                fullName: body.clientName || body.clientPhone,
                phone: body.clientPhone,
                role: "client"
              }
            });
            resolvedClientId = newClient.id;
          }
        } else {
          const clientExists = await tx.user.findUnique({ where: { id: resolvedClientId } });
          if (!clientExists) throw new HttpAuthError(404, "client_not_found", "Client introuvable.");
          if (clientExists.role !== "client") {
            throw new HttpAuthError(422, "client_role_invalid", "Le client sélectionné est invalide.");
          }
        }

        const depositAmountXof = calcDepositAmount(service);
        const b = await tx.booking.create({
          data: {
            clientId: resolvedClientId,
            salonId,
            serviceId: body.serviceId,
            employeeId: body.employeeId ?? null,
            startsAt,
            endsAt,
            status: "confirmed",
            source: "manual",
            depositAmountXof,
            depositPaymentStatus: depositAmountXof > 0 ? "succeeded" : "pending",
            clientNote: body.clientName && !body.clientId ? `Nouveau client: ${body.clientName}` : null
          }
        });
        if (depositAmountXof > 0) {
          await tx.payment.create({
            data: {
              bookingId: b.id,
              provider: "manual",
              status: "succeeded",
              amountXof: depositAmountXof,
              idempotencyKey: `manual-${b.id}-deposit`
            }
          });
        }
        await tx.bookingEvent.create({ data: { bookingId: b.id, actorUserId: userId, eventType: "created_manual", toStatus: "confirmed" } });
        return b;
      });

      ok(reply, { id: booking.id, startsAt: booking.startsAt.toISOString(), endsAt: booking.endsAt.toISOString(), status: booking.status, source: booking.source }, 201);
    } catch (e) { handleError(e, reply); }
  }

  // ─── Clients ───────────────────────────────────────────────────────────────

  async listClients(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const query = request.query as { search?: string };
      const search = query.search?.trim();

      const userWhere: Prisma.UserWhereInput = {
        bookings: { some: { salonId } }
      };

      if (search && search.length > 0) {
        userWhere.OR = [
          { fullName: { contains: search, mode: "insensitive" } },
          { phone: { contains: search } },
          { email: { contains: search, mode: "insensitive" } }
        ];
      }

      const clients = await prisma.user.findMany({
        where: userWhere,
        select: {
          id: true,
          fullName: true,
          phone: true,
          email: true,
          bookings: {
            where: { salonId },
            select: {
              startsAt: true,
              depositAmountXof: true,
              payments: {
                where: { status: "succeeded" },
                select: { amountXof: true }
              }
            },
            orderBy: { startsAt: "desc" }
          }
        },
        take: 50
      });

      const formattedClients = clients.map((client) => {
        let totalSpentXof = 0;
        let lastVisitAt = null;

        for (const booking of client.bookings) {
          totalSpentXof += booking.payments[0]?.amountXof ?? 0;
          if (!lastVisitAt || booking.startsAt > lastVisitAt) {
            lastVisitAt = booking.startsAt;
          }
        }

        return {
          id: client.id,
          fullName: client.fullName,
          phone: client.phone,
          email: client.email,
          visitCount: client.bookings.length,
          totalSpentXof,
          lastVisitAt: lastVisitAt ? lastVisitAt.toISOString() : null
        };
      });

      formattedClients.sort((a, b) => {
        const timeA = a.lastVisitAt ? new Date(a.lastVisitAt).getTime() : 0;
        const timeB = b.lastVisitAt ? new Date(b.lastVisitAt).getTime() : 0;
        return timeB - timeA;
      });

      ok(reply, formattedClients);
    } catch (e) { handleError(e, reply); }
  }

  async getClient(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const params = request.params as { clientId: string };

      const bookings = await prisma.booking.findMany({
        where: { salonId, clientId: params.clientId },
        include: {
          client: { select: { id: true, fullName: true, phone: true, email: true } },
          service: { select: { name: true } },
          payments: {
            where: { status: "succeeded" },
            orderBy: { createdAt: "desc" },
            take: 1
          }
        },
        orderBy: { startsAt: "desc" }
      });

      if (bookings.length === 0 || !bookings[0].client) {
        fail(reply, 404, "client_not_found", "Client introuvable.");
        return;
      }

      const firstClient = bookings[0].client;
      const visitCount = bookings.length;
      const totalSpentXof = bookings.reduce(
        (sum, booking) => sum + (booking.payments[0]?.amountXof ?? 0),
        0
      );
      const lastVisitAt = bookings[0]?.startsAt ?? null;

      ok(reply, {
        id: firstClient.id,
        fullName: firstClient.fullName,
        phone: firstClient.phone,
        email: firstClient.email,
        visitCount,
        totalSpentXof,
        lastVisitAt: lastVisitAt?.toISOString() ?? null,
        recentBookings: bookings.slice(0, 10).map((booking) => ({
          bookingId: booking.id,
          startsAt: booking.startsAt.toISOString(),
          serviceName: booking.service.name,
          amountXof: booking.payments[0]?.amountXof ?? 0,
          status: booking.status
        }))
      });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Checkout ──────────────────────────────────────────────────────────────

  async getCheckout(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const params = request.params as { bookingId: string };

      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, salonId },
        include: {
          service: { select: { name: true, priceXof: true } },
          employee: { select: { displayName: true } },
          client: { select: { fullName: true } },
          payments: {
            where: { status: { in: ["authorized", "succeeded"] } },
            orderBy: { createdAt: "desc" },
            take: 1
          }
        }
      });

      if (!booking) {
        fail(reply, 404, "booking_not_found", "Réservation introuvable.");
        return;
      }

      const subtotalXof = booking.service.priceXof;
      const depositPaidXof = booking.payments[0]?.amountXof ?? 0;
      const balanceXof = Math.max(0, subtotalXof - depositPaidXof);

      ok(reply, {
        bookingId: booking.id,
        status: booking.status,
        clientName: booking.client?.fullName ?? null,
        serviceName: booking.service.name,
        startsAt: booking.startsAt.toISOString(),
        staffName: booking.employee?.displayName ?? null,
        subtotalXof,
        depositPaidXof,
        balanceXof,
        lineItems: [{ name: booking.service.name, amountXof: subtotalXof }]
      });
    } catch (e) { handleError(e, reply); }
  }

  async completeCheckout(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId } = await ensurePro(request);
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { bookingId: string };
      const body = proCheckoutCompleteInputSchema.parse(request.body);

      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, salonId },
        include: {
          service: { select: { priceXof: true } },
          payments: { where: { status: { in: ["authorized", "succeeded"] } }, take: 1, orderBy: { createdAt: "desc" } }
        }
      });
      if (!booking) {
        fail(reply, 404, "booking_not_found", "Réservation introuvable.");
        return;
      }
      if (!["confirmed", "in_progress"].includes(booking.status)) {
        fail(reply, 422, "invalid_status", "Seules les réservations confirmées ou en cours peuvent être encaissées.");
        return;
      }

      // Authoritative subtotal from service record, not caller-supplied line items
      const subtotalXof = booking.service.priceXof;
      const depositPaidXof = booking.payments[0]?.amountXof ?? 0;
      const discountXof = Math.min(body.discountXof ?? 0, subtotalXof);
      const balanceXof = Math.max(0, subtotalXof - depositPaidXof - discountXof);

      await prisma.$transaction(async (tx) => {
        const claimed = await tx.booking.updateMany({
          where: { id: booking.id, status: { in: ["confirmed", "in_progress"] } },
          data: { status: "completed" }
        });
        if (claimed.count === 0) throw new HttpAuthError(409, "already_completed", "Cette réservation a déjà été encaissée.");
        await tx.bookingEvent.create({
          data: {
            bookingId: booking.id,
            actorUserId: userId,
            eventType: "checkout_completed",
            fromStatus: booking.status,
            toStatus: "completed",
            payloadJson: JSON.stringify({ paymentMethod: body.paymentMethod, softpayMethod: body.softpayMethod, discountXof, balanceXof })
          }
        });
        if (balanceXof > 0) {
          const effectiveMethod = body.paymentMethod === "other" && body.softpayMethod
            ? `softpay-${body.softpayMethod}`
            : body.paymentMethod;
          await tx.settlementEvent.create({
            data: {
              bookingId: booking.id,
              paymentId: null,
              eventType: "balance_collected",
              amountXof: balanceXof,
              providerReference: `manual-${effectiveMethod}`
            }
          });
        }
        await enqueueJob({
          type: "deposit_settlement",
          payload: { bookingId: booking.id },
          dbClient: tx
        });
      });
      await invalidateCacheTags(["kpi:pro", "kpi:admin"]);

      ok(reply, { completed: true, bookingId: booking.id, status: "completed", subtotalXof, depositPaidXof, discountXof, balanceXof });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Reviews ───────────────────────────────────────────────────────────────

  async listReviews(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const reviews = await prisma.review.findMany({
        where: { salonId }, orderBy: { createdAt: "desc" },
        select: { id: true, rating: true, comment: true, createdAt: true, responseText: true, updatedAt: true, clientId: true }
      });
      ok(reply, reviews.map((r) => ({
        id: r.id,
        rating: r.rating,
        comment: r.comment,
        createdAt: r.createdAt.toISOString(),
        responseText: r.responseText,
        responseAt: r.responseText ? r.updatedAt.toISOString() : null,
        clientId: r.clientId
      })));
    } catch (e) { handleError(e, reply); }
  }

  async respondToReview(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId } = await ensurePro(request);
      if (!(await ensureProWriteAccess(salonId, reply))) return;
      const params = request.params as { reviewId: string };
      const body = proReviewResponseInputSchema.parse(request.body);
      const review = await prisma.review.findFirst({ where: { id: params.reviewId, salonId } });
      if (!review) { fail(reply, 404, "review_not_found", "Avis introuvable."); return; }
      await prisma.review.update({ where: { id: params.reviewId }, data: { responseText: body.responseText, responseByUserId: userId } });
      await invalidateCacheTags([`catalog:reviews:${salonId}`, "kpi:pro", "kpi:admin"]);
      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Analytics ─────────────────────────────────────────────────────────────

  async analytics(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const flags = await getFeatureFlags();
      if (!flags.analyticsEnabled) {
        fail(reply, 422, "analytics_disabled", "Les rapports sont désactivés pour le moment.");
        return;
      }
      const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true, subscription: { select: { status: true } } } });
      if (salon?.subscription?.status !== "active") {
        fail(reply, 403, "subscription_inactive", "Abonnement inactif ou expiré."); return;
      }
      if (flags.analyticsTierRequired === "premium" && salon?.subscriptionTier !== "premium") {
        fail(reply, 402, "premium_required", "Les statistiques avancées sont réservées aux salons Premium.");
        return;
      }
      const q = request.query as { period?: string };
      const period = (["7d", "30d", "90d"].includes(q.period ?? "") ? q.period : "30d") as "7d" | "30d" | "90d";
      const { value, cacheStatus } = await getOrSetCachedJson({
        key: `kpi:pro:analytics:${salonId}:${period}`,
        ttlSeconds: config.cacheTtlKpiSeconds,
        tags: ["kpi:pro"],
        load: () => getProAnalytics(salonId, period)
      });
      reply.header("x-cache", cacheStatus);
      ok(reply, value);
    } catch (e) { handleError(e, reply); }
  }

  // ─── Subscription Features ───────────────────────────────────────────────

  async getSubscriptionFeatures(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const flags = await getFeatureFlags();
      const salon = await prisma.salon.findUnique({
        where: { id: salonId },
        select: { subscriptionTier: true }
      });
      const tier = salon?.subscriptionTier ?? "standard";
      const isPremium = tier === "premium";

      const priceRows = await prisma.platformSetting.findMany({
        where: { key: { in: ["subscription_standard_price_xof", "subscription_premium_price_xof"] } }
      });
      const priceMap = Object.fromEntries(priceRows.map((r) => [r.key, r.value]));

      ok(reply, {
        deposits: {
          enabled: flags.depositsEnabled,
          available: flags.depositsEnabled && (flags.depositsTierRequired === "standard" || isPremium)
        },
        analytics: {
          enabled: flags.analyticsEnabled,
          available: flags.analyticsEnabled && (flags.analyticsTierRequired === "standard" || isPremium)
        },
        autoRenew: { enabled: flags.autoRenewEnabled },
        billingProviders: {
          paydunya: flags.billingPaydunya,
          manual: flags.billingManual,
          card: flags.cardPayments
        },
        planTiers: [
          {
            tier: "standard",
            label: "Standard",
            priceLabel: `${priceMap["subscription_standard_price_xof"] ?? "15 000"} XOF`,
            features: [
              { label: "Agenda illimité", included: true },
              { label: "Gestion de l'équipe", included: true },
              { label: "Acompte client", included: flags.depositsEnabled && (flags.depositsTierRequired === "standard") },
              { label: "Rapports financiers", included: flags.analyticsEnabled && (flags.analyticsTierRequired === "standard") },
              { label: "Export CSV", included: false },
              { label: "Badge « Vérifié »", included: false },
              { label: "Support prioritaire 24/7", included: false }
            ]
          },
          {
            tier: "premium",
            label: "Premium",
            priceLabel: `${priceMap["subscription_premium_price_xof"] ?? "30 000"} XOF`,
            features: [
              { label: "Agenda illimité", included: true },
              { label: "Gestion de l'équipe", included: true },
              { label: "Acompte client", included: flags.depositsEnabled },
              { label: "Rapports financiers", included: flags.analyticsEnabled },
              { label: "Export CSV", included: true },
              { label: "Badge « Vérifié »", included: true },
              { label: "Support prioritaire 24/7", included: true }
            ]
          }
        ]
      });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Subscription ──────────────────────────────────────────────────────────

  async getSubscription(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const [sub, settings] = await Promise.all([
        prisma.subscription.findUnique({ where: { salonId } }),
        prisma.platformSetting.findMany({
          where: {
            key: {
              in: [
                salonBillingProviderKey(salonId),
                salonBillingAccountKey(salonId),
                `salon:${salonId}:billing_country`,
                `salon:${salonId}:billing_method`
              ]
            }
          },
          select: { key: true, value: true }
        })
      ]);
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
      const settingMap = toSettingMap(settings);
      const rawProvider = settingMap[salonBillingProviderKey(salonId)];
      const provider = toPublicBillingProvider(rawProvider ?? sub.billingProvider);
      const encryptedAccountNumber = settingMap[salonBillingAccountKey(salonId)];
      const accountNumber = encryptedAccountNumber ? decryptBillingAccount(encryptedAccountNumber) : null;
      const billingCountry = settingMap[`salon:${salonId}:billing_country`] ?? null;
      const billingMethodCode = settingMap[`salon:${salonId}:billing_method`] ?? null;
      const billingMethod = provider && accountNumber
        ? { provider, accountNumberMasked: maskAccountNumber(accountNumber), country: billingCountry, method: billingMethodCode }
        : null;
      ok(reply, {
        id: sub.id,
        tier: sub.tier,
        pendingTier: sub.pendingTier ?? null,
        status: sub.status,
        renewsAt: sub.expiresAt?.toISOString() ?? null,
        expiresAt: sub.expiresAt?.toISOString() ?? null,
        gracePeriodEndsAt: sub.gracePeriodEndsAt?.toISOString() ?? null,
        isComplimentary: sub.isComplimentary,
        autoRenew: sub.autoRenew,
        billingMethod
      });
    } catch (e) { handleError(e, reply); }
  }

  async updateSubscription(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proSubscriptionUpdateInputSchema.parse(request.body);
      await prisma.$transaction(async (tx) => {
        const updatePayload: Prisma.SubscriptionUpdateInput = {};
        if (body.autoRenew !== undefined) {
          updatePayload.autoRenew = body.autoRenew;
        }
        if (body.billingMethod !== undefined) {
          updatePayload.billingProvider = toDbProvider(body.billingMethod?.provider ?? null);
        }
        if (Object.keys(updatePayload).length > 0) {
          await tx.subscription.update({ where: { salonId }, data: updatePayload });
        }

        if (body.billingMethod !== undefined) {
          const providerKey = salonBillingProviderKey(salonId);
          const accountKey = salonBillingAccountKey(salonId);
          if (body.billingMethod === null) {
            await tx.platformSetting.deleteMany({ where: { key: { in: [providerKey, accountKey] } } });
          } else {
            await tx.platformSetting.upsert({
              where: { key: providerKey },
              create: {
                group: "salon_billing",
                key: providerKey,
                value: body.billingMethod.provider,
                description: `Billing provider for salon ${salonId}`
              },
              update: { value: body.billingMethod.provider }
            });
            await tx.platformSetting.upsert({
              where: { key: accountKey },
              create: {
                group: "salon_billing",
                key: accountKey,
                value: encryptBillingAccount(body.billingMethod.accountNumber.trim()),
                description: `Billing account number for salon ${salonId}`
              },
              update: { value: encryptBillingAccount(body.billingMethod.accountNumber.trim()) }
            });
            // Store country/method for PayDunya billing
            if (body.billingMethod.country) {
              await tx.platformSetting.upsert({
                where: { key: `salon:${salonId}:billing_country` },
                create: { group: "salon_billing", key: `salon:${salonId}:billing_country`, value: body.billingMethod.country, description: `Billing country for salon ${salonId}` },
                update: { value: body.billingMethod.country }
              });
            }
            if (body.billingMethod.method) {
              await tx.platformSetting.upsert({
                where: { key: `salon:${salonId}:billing_method` },
                create: { group: "salon_billing", key: `salon:${salonId}:billing_method`, value: body.billingMethod.method, description: `Billing method for salon ${salonId}` },
                update: { value: body.billingMethod.method }
              });
            }
          }
        }
      });
      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  async getChargeStatus(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { chargeId: string };
      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
      const charge = await prisma.subscriptionCharge.findUnique({
        where: { id: params.chargeId },
        include: { subscription: { select: { status: true, tier: true, expiresAt: true } } }
      });
      if (!charge || charge.subscriptionId !== sub.id) {
        fail(reply, 404, "charge_not_found", "Paiement introuvable."); return;
      }

      let effectiveCharge = charge;
      if (
        config.paymentDriver === "paydunya" &&
        charge.providerTxId &&
        (charge.status === "pending" || charge.status === "authorized")
      ) {
        try {
          const providerStatus = await paymentAdapter.fetchPaymentStatus({ providerToken: charge.providerTxId });
          if (providerStatus === "succeeded") {
            await this._settleSuccessfulSubscriptionCharge(charge, charge.providerTxId);
          } else if (providerStatus === "failed" || providerStatus === "refunded") {
            await this._markSubscriptionChargeFailed(charge, providerStatus);
          }
          const refreshed = await prisma.subscriptionCharge.findUnique({
            where: { id: charge.id },
            include: { subscription: { select: { status: true, tier: true, expiresAt: true } } }
          });
          if (refreshed) effectiveCharge = refreshed;
        } catch (error) {
          logger.warn("getChargeStatus: provider reconciliation failed", {
            chargeId: charge.id,
            error: String(error)
          });
        }
      }

      ok(reply, {
        chargeId: effectiveCharge.id,
        status: effectiveCharge.status,
        provider: effectiveCharge.provider,
        amountXof: effectiveCharge.amountXof,
        chargeType: effectiveCharge.chargeType,
        subscriptionId: effectiveCharge.subscriptionId,
        subscriptionStatus: effectiveCharge.subscription?.status ?? sub.status,
        tier: effectiveCharge.subscription?.tier ?? sub.tier,
        expiresAt: effectiveCharge.subscription?.expiresAt?.toISOString() ?? null
      });
    } catch (e) { handleError(e, reply); }
  }

  async subscriptionCheckout(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { userId, salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proSubscriptionCheckoutInputSchema.parse(request.body);

      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
      const owner = await prisma.user.findUnique({
        where: { id: userId },
        select: { phone: true }
      });
      if (config.paymentDriver === "paydunya" && !owner?.phone) {
        fail(reply, 422, "phone_required", "Numéro de téléphone requis pour initier ce paiement.");
        return;
      }

      // ── Guard: block invalid action/tier combinations ────────────────────
      if (body.action === "activate" && sub.status === "active") {
        fail(reply, 409, "already_active", "Votre abonnement est déjà actif.");
        return;
      }
      if (body.action === "upgrade" && sub.tier === "premium") {
        fail(reply, 409, "already_premium", "Vous êtes déjà sur le plan Premium.");
        return;
      }
      if (body.action === "upgrade" && sub.tier === "standard" && sub.pendingTier === "premium") {
        fail(reply, 409, "upgrade_pending", "Une mise à niveau est déjà en attente de paiement.");
        return;
      }
      if (body.action === "renewal" && sub.isComplimentary) {
        fail(reply, 409, "complimentary", "Les abonnements complémentaires ne nécessitent pas de renouvellement.");
        return;
      }
      if (body.action === "downgrade") {
        if (sub.tier === "standard") {
          fail(reply, 409, "already_standard", "Vous êtes déjà sur le plan Standard.");
          return;
        }
        // Downgrade is free — applies after grace period when subscription expires
        await prisma.subscription.update({
          where: { id: sub.id },
          data: { pendingTier: "standard" }
        });
        ok(reply, { downgradeScheduled: true, effectiveAt: sub.expiresAt?.toISOString() ?? null, afterGracePeriod: true });
        return;
      }

      const priceRows = await prisma.platformSetting.findMany({
        where: {
          key: {
            in: [
              "subscription_premium_price_xof",
              "subscription_standard_price_xof",
              "subscription_annual_discount_percent"
            ]
          }
        }
      });
      const priceMap = Object.fromEntries(priceRows.map((r) => [r.key, r.value]));
      // activate: use requested tier (default standard); upgrade → premium; renewal → current tier
      const priceKey = body.action === "upgrade"
        ? "subscription_premium_price_xof"
        : body.action === "activate" && body.tier === "premium"
          ? "subscription_premium_price_xof"
          : body.action === "renewal" && sub.tier === "premium"
            ? "subscription_premium_price_xof"
            : "subscription_standard_price_xof";
      const priceStr = priceMap[priceKey];
      if (!priceStr) {
        fail(reply, 500, "pricing_not_configured", "Le prix de l'abonnement n'est pas configuré. Contactez l'administrateur.");
        return;
      }
      const monthlyAmountXof = parseInt(priceStr, 10);
      const annualDiscountPercent = Math.max(
        0,
        Math.min(100, parseInt(priceMap.subscription_annual_discount_percent ?? "0", 10) || 0)
      );
      const amountXof = body.billingCycle === "annual"
        ? Math.round(monthlyAmountXof * 12 * (100 - annualDiscountPercent) / 100)
        : monthlyAmountXof;
      const billingMonth = new Date().toISOString().slice(0, 7);
      const tierSuffix = body.action === "activate" ? `-${body.tier ?? "standard"}` : "";
      const idempotencyKey = `sub-${sub.id}-${body.action}${tierSuffix}-${body.billingCycle}-${billingMonth}`;

      const existing = await prisma.subscriptionCharge.findFirst({
        where: { idempotencyKey }
      });
      if (existing?.status === "pending" && existing?.providerTxId && isPaydunyaTokenCompatibleWithEnv(existing.providerTxId)) {
        ok(reply, { redirectUrl: null, chargeId: existing.id, resumed: true });
        return;
      }

      // Create or reset the charge row first so we have a real ID for the
      // PayDunya invoice custom_data (webhook lookup) and return_url.
      const charge = existing
        ? await prisma.subscriptionCharge.update({
            where: { id: existing.id },
            data: {
              status: "pending",
              provider: toDbProvider(body.provider) ?? "paydunya",
              amountXof,
              chargeType: body.action,
              providerTxId: null,
              invoiceId: null
            }
          })
        : await prisma.subscriptionCharge.create({
            data: { subscriptionId: sub.id, provider: toDbProvider(body.provider) ?? "paydunya", amountXof, idempotencyKey, chargeType: body.action }
          });

      const result = await paymentAdapter.initiateDeposit({
        paymentId: charge.id,
        amountXof,
        description: `Abonnement ${body.action} (${body.billingCycle})`,
        callbackUrl: `${config.webOrigin}/pro/subscription/callback?chargeId=${encodeURIComponent(charge.id)}`,
        idempotencyKey,
        phone: owner?.phone ?? undefined,
        channel: body.channel
      });

      await prisma.subscriptionCharge.update({
        where: { id: charge.id },
        data: { providerTxId: result.providerRef }
      });

      // Mark pending tier for upgrades so the UI knows an upgrade is in progress
      if (body.action === "upgrade") {
        await prisma.subscription.update({
          where: { id: sub.id },
          data: { pendingTier: "premium" }
        });
      }

      ok(reply, { redirectUrl: result.redirectUrl, chargeId: charge.id });
    } catch (e) { handleError(e, reply); }
  }

  async executeSubscriptionPayment(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { chargeId: string };
      const body = proSubscriptionExecuteInputSchema.parse(request.body);

      const charge = await prisma.subscriptionCharge.findUnique({
        where: { id: params.chargeId },
        include: { subscription: true }
      });

      if (!charge) {
        fail(reply, 404, "charge_not_found", "Frais d'abonnement introuvable.");
        return;
      }

      if (charge.subscription.salonId !== salonId) {
        fail(reply, 403, "forbidden", "Accès interdit.");
        return;
      }

      if (charge.status !== "pending") {
        fail(reply, 422, "invalid_status", "Ce paiement ne peut pas être exécuté.");
        return;
      }

      if (!charge.providerTxId) {
        fail(reply, 422, "missing_invoice_token", "Token de facture PayDunya manquant.");
        return;
      }

      if (!paymentAdapter.executePayment) {
        fail(reply, 501, "not_supported", "Ce fournisseur ne supporte pas l'exécution séparée.");
        return;
      }

      const result = await paymentAdapter.executePayment({
        paymentId: charge.id,
        method: body.method,
        invoiceToken: charge.providerTxId,
        details: body.details
      });

      if (result.success) {
        if (requiresProviderCompletion(result)) {
          await prisma.$transaction(async (tx) => {
            await tx.subscriptionCharge.update({
              where: { id: charge.id },
              data: { status: "authorized", ...(result.providerTxId ? { providerTxId: result.providerTxId } : {}) }
            });
            await tx.auditLog.create({
              data: {
                action: "subscription_charge_execute",
                summary: `SubscriptionCharge ${charge.id} → authorized (${charge.chargeType})`,
                entityType: "SubscriptionCharge",
                entityId: charge.id,
                actorName: "pro_user",
                severity: "info",
                payloadJson: JSON.stringify(result)
              }
            });
          });
          ok(reply, result);
          return;
        }
        await this._settleSuccessfulSubscriptionCharge(
          charge,
          result.providerTxId ?? charge.providerTxId ?? undefined,
          JSON.stringify(result)
        );
      } else {
        await this._markSubscriptionChargeFailed(charge, "failed", JSON.stringify(result));
      }

      ok(reply, result);
    } catch (e) {
      handleError(e, reply);
    }
  }

  private async _settleSuccessfulSubscriptionCharge(
    charge: {
      id: string;
      subscriptionId: string;
      amountXof: number;
      chargeType: string;
      idempotencyKey: string;
      providerTxId: string | null;
    },
    providerTxId?: string,
    payloadJson?: string
  ) {
    await prisma.$transaction(async (tx) => {
      await tx.subscriptionCharge.update({
        where: { id: charge.id },
        data: { status: "succeeded", ...(providerTxId ? { providerTxId } : {}) }
      });

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

      const sub = await tx.subscription.findUnique({
        where: { id: charge.subscriptionId },
        select: { salonId: true, tier: true, expiresAt: true, pendingTier: true }
      });

      const isUpgrade = charge.chargeType === "upgrade";
      const isRenewal = charge.chargeType === "renewal";
      const isActivate = charge.chargeType === "activate";
      const isAnnualCycle = charge.idempotencyKey.includes("-annual-");
      const cycleDays = isAnnualCycle ? 365 : 30;
      const now = new Date();

      let newExpiresAt: Date | undefined;
      let newTier = sub?.tier ?? "standard";
      let newPendingTier = sub?.pendingTier ?? null;

      if (isActivate) {
        newExpiresAt = new Date(now.getTime() + cycleDays * 24 * 60 * 60 * 1000);
      } else if (isUpgrade) {
        if (config.prorationEnabled) {
          newTier = "premium";
          newPendingTier = null;
          newExpiresAt = new Date(now.getTime() + cycleDays * 24 * 60 * 60 * 1000);
        } else {
          newPendingTier = "premium";
          newExpiresAt = undefined;
        }
      } else if (isRenewal) {
        if (sub?.pendingTier) {
          newTier = sub.pendingTier;
          newPendingTier = null;
        }
        const baseDate = sub?.expiresAt && sub.expiresAt > now ? sub.expiresAt : now;
        newExpiresAt = new Date(baseDate.getTime() + cycleDays * 24 * 60 * 60 * 1000);
      }

      await tx.subscription.update({
        where: { id: charge.subscriptionId },
        data: {
          tier: newTier,
          pendingTier: newPendingTier,
          status: "active",
          renewedAt: now,
          expiresAt: newExpiresAt
        }
      });

      if (sub?.salonId) {
        await tx.salon.update({
          where: { id: sub.salonId },
          data: {
            subscriptionTier: newTier,
            isVisibleInMarketplace: true,
            canReceiveBookings: true
          }
        });
      }

      await tx.auditLog.create({
        data: {
          action: "subscription_charge_execute",
          summary: `SubscriptionCharge ${charge.id} → succeeded (${charge.chargeType})`,
          entityType: "SubscriptionCharge",
          entityId: charge.id,
          actorName: "pro_user",
          severity: "info",
          payloadJson: payloadJson ?? JSON.stringify({ providerTxId })
        }
      });
    });
  }

  private async _markSubscriptionChargeFailed(
    charge: {
      id: string;
      subscriptionId: string;
      chargeType: string;
    },
    status: "failed" | "refunded",
    payloadJson?: string
  ) {
    await prisma.$transaction(async (tx) => {
      await tx.subscriptionCharge.update({
        where: { id: charge.id },
        data: { status }
      });

      if (charge.chargeType === "upgrade") {
        await tx.subscription.update({
          where: { id: charge.subscriptionId },
          data: { pendingTier: null }
        });
      }

      await tx.auditLog.create({
        data: {
          action: "subscription_charge_execute",
          summary: `SubscriptionCharge ${charge.id} → ${status} (${charge.chargeType})`,
          entityType: "SubscriptionCharge",
          entityId: charge.id,
          actorName: "pro_user",
          severity: status === "failed" ? "warn" : "info",
          payloadJson: payloadJson ?? JSON.stringify({ status })
        }
      });
    });
  }

  async cancelDowngrade(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;

      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
      if (sub.pendingTier !== "standard") {
        fail(reply, 409, "no_downgrade_scheduled", "Aucun rétrogradation planifiée.");
        return;
      }

      await prisma.subscription.update({
        where: { id: sub.id },
        data: { pendingTier: null }
      });

      ok(reply, { cancelled: true });
    } catch (e) { handleError(e, reply); }
  }

  async cancelSubscription(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;

      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
      if (sub.status === "inactive" || sub.status === "cancelled") {
        fail(reply, 409, "already_inactive", "L'abonnement est déjà inactif.");
        return;
      }
      if (sub.isComplimentary) {
        fail(reply, 409, "complimentary", "Les abonnements complémentaires ne peuvent pas être résiliés ici.");
        return;
      }

      // Parse reason + additional info
      const body = proCancelSubscriptionInputSchema.parse(request.body);
      const reason = body.reason;
      const additionalInfo = body.additionalInfo ?? null;

      // Execute cancellation, storing the reason
      await prisma.subscription.update({
        where: { id: sub.id },
        data: {
          status: "cancelled",
          renewedAt: null,
          expiresAt: null,
          pendingTier: null,
          autoRenew: false,
          cancelReason: reason,
          cancelAdditionalInfo: additionalInfo,
          cancelRequestedAt: new Date()
        }
      });

      // Build personalised retention offer based on reason
      const retentionOffer = getRetentionOffer(reason, sub.tier);

      ok(reply, { cancelled: true, retentionOffer });
    } catch (e) { handleError(e, reply); }
  }

  async retainSubscription(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;

      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub || sub.status !== "cancelled") {
        fail(reply, 409, "not_cancelled", "L'abonnement n'est pas en état résilié.");
        return;
      }
      if (!sub.cancelReason) {
        fail(reply, 409, "no_retention", "Aucune offre de rétention disponible.");
        return;
      }

      // Reinstate the subscription
      await prisma.subscription.update({
        where: { id: sub.id },
        data: {
          status: "active",
          cancelReason: null,
          cancelAdditionalInfo: null,
          cancelRequestedAt: null
        }
      });

      // Log the retention event
      await prisma.subscriptionEvent.create({
        data: {
          subscriptionId: sub.id,
          eventType: "retained",
          summary: `Client retenu (motif: ${sub.cancelReason}). Offre acceptée.`,
          actorName: "client",
          source: "pro"
        }
      });

      ok(reply, { retained: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Payouts ───────────────────────────────────────────────────────────────

  async listPayouts(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const events = await prisma.settlementEvent.findMany({
        where: { booking: { salonId } },
        orderBy: { createdAt: "desc" }
      });
      ok(reply, events.map((e) => ({ id: e.id, bookingId: e.bookingId, eventType: e.eventType, amountXof: e.amountXof, createdAt: e.createdAt.toISOString() })));
    } catch (e) { handleError(e, reply); }
  }

  // ─── Invoices ──────────────────────────────────────────────────────────────

  async listInvoices(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { ok(reply, []); return; }
      const invoices = await prisma.billingInvoice.findMany({
        where: { subscriptionId: sub.id },
        orderBy: { createdAt: "desc" }
      });
      ok(reply, invoices.map((i) => ({
        id: i.id,
        invoiceNumber: i.invoiceNumber,
        amountXof: i.amountXof,
        status: i.status,
        createdAt: i.createdAt.toISOString(),
        pdfUrl: i.pdfUrl.trim().length > 0 ? i.pdfUrl : `/api/v1/pro/invoices/${i.id}/pdf`
      })));
    } catch (e) { handleError(e, reply); }
  }

  async downloadInvoicePdf(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { invoiceId: string };
      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }

      const [invoice, salon, providerSetting] = await Promise.all([
        prisma.billingInvoice.findFirst({
          where: { id: params.invoiceId, subscriptionId: sub.id }
        }),
        prisma.salon.findUnique({ where: { id: salonId }, select: { name: true } }),
        prisma.platformSetting.findUnique({
          where: { key: salonBillingProviderKey(salonId) },
          select: { value: true }
        })
      ]);
      if (!invoice) { fail(reply, 404, "invoice_not_found", "Facture introuvable."); return; }

      const issuedAt = new Intl.DateTimeFormat("fr-FR", {
        dateStyle: "medium",
        timeStyle: "short"
      }).format(invoice.createdAt);
      const amountLabel = new Intl.NumberFormat("fr-FR").format(invoice.amountXof);
      const billingProvider = toPublicBillingProvider(providerSetting?.value ?? sub.billingProvider ?? "manual");
      const providerLabel =
        billingProvider === "manual" ? "Manuel" : "Intech";
      const pdf = buildInvoicePdf({
        invoiceNumber: invoice.invoiceNumber,
        issuedAt,
        status: invoice.status,
        amountLabel,
        billingProvider: providerLabel,
        salonName: salon?.name ?? "Salon partenaire"
      });
      const safeNumber = invoice.invoiceNumber.replace(/[^a-zA-Z0-9._-]/g, "_");
      // nosemgrep: direct-reply-send — binary PDF buffer, content-type enforced, filename sanitized above
      reply.type("application/pdf").header("content-disposition", `attachment; filename="${safeNumber}.pdf"`).send(pdf);
    } catch (e) { handleError(e, reply); }
  }
}
