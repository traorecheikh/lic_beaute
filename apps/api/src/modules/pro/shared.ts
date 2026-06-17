import { createCipheriv, createDecipheriv, randomBytes } from "node:crypto";
import type { FastifyReply, FastifyRequest } from "fastify";

import { getPaymentAdapter } from "../../adapters/index.js";
import { config } from "../../config.js";
import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { fail } from "../../lib/http.js";
import { prisma } from "../../lib/db/prisma.js";

export const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  baseOrigin: config.webOrigin,
  paydunyaMasterKey: config.paydunyaMasterKey,
  paydunyaPublicKey: config.paydunyaPublicKey,
  paydunyaPrivateKey: config.paydunyaPrivateKey,
  paydunyaToken: config.paydunyaToken,
  paydunyaEnv: config.paydunyaEnv,
  paydunyaBaseUrl: config.paydunyaBaseUrl
});

export function isPaydunyaTokenCompatibleWithEnv(token: string | null | undefined) {
  if (!token) return false;
  if (config.paymentDriver !== "paydunya") return true;
  if (token.startsWith("mock-")) return false;
  const isSandboxToken = token.startsWith("test_");
  return config.paydunyaEnv === "sandbox" ? isSandboxToken : !isSandboxToken;
}

export function isNonReusableSubscriptionChargeError(message: string | null | undefined) {
  const normalized = message?.toLowerCase() ?? "";
  const looksAlreadyInitiated =
    normalized.includes("already initiated") ||
    normalized.includes("déjà été initié") ||
    normalized.includes("deja ete initie") ||
    normalized.includes("dej\\\\u00e0") ||
    normalized.includes("deja");
  return looksAlreadyInitiated && normalized.includes("initi");
}

export function salonPublicPhoneKey(salonId: string) {
  return `salon:${salonId}:public_phone`;
}

export function salonInstagramKey(salonId: string) {
  return `salon:${salonId}:instagram`;
}

export function salonTeamShowPhotosKey(salonId: string) {
  return `salon:${salonId}:team_show_photos`;
}

export function salonTeamShowDescriptionsKey(salonId: string) {
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

export function encryptBillingAccount(plaintext: string): string {
  const key = getBillingKey();
  const iv = randomBytes(12);
  const cipher = createCipheriv("aes-256-gcm", key, iv);
  const encrypted = Buffer.concat([cipher.update(plaintext, "utf8"), cipher.final()]);
  const tag = cipher.getAuthTag();
  return `${BILLING_ENC_PREFIX}${iv.toString("hex")}${tag.toString("hex")}${encrypted.toString("hex")}`;
}

export function decryptBillingAccount(stored: string): string {
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

export function salonBillingProviderKey(salonId: string) {
  return `salon:${salonId}:billing_provider`;
}

export function salonBillingAccountKey(salonId: string) {
  return `salon:${salonId}:billing_account_number`;
}

export function toSettingMap(rows: Array<{ key: string; value: string }>) {
  return Object.fromEntries(rows.map((row) => [row.key, row.value]));
}

export function maskAccountNumber(value: string) {
  const trimmed = value.trim();
  if (trimmed.length <= 4) return `***${trimmed}`;
  return `${"*".repeat(Math.max(3, trimmed.length - 4))}${trimmed.slice(-4)}`;
}

export function calcDepositAmount(service: {
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

export function parseBooleanSetting(value: string | undefined, fallback: boolean) {
  if (!value) return fallback;
  const normalized = value.trim().toLowerCase();
  if (normalized === "true" || normalized === "1" || normalized === "yes") return true;
  if (normalized === "false" || normalized === "0" || normalized === "no") return false;
  return fallback;
}

export function requiresProviderCompletion(result: { url?: string; other_url?: unknown; data?: Record<string, unknown> | undefined } & Record<string, unknown>) {
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

export async function isTeamPhotoRequiredForSalon(salonId: string) {
  const key = salonTeamShowPhotosKey(salonId);
  const setting = await prisma.platformSetting.findUnique({
    where: { key },
    select: { value: true }
  });
  return parseBooleanSetting(setting?.value, false);
}

export function escapePdfText(value: string) {
  return value.replace(/\\/g, "\\\\").replace(/\(/g, "\\(").replace(/\)/g, "\\)");
}

export type FeatureFlags = {
  depositsEnabled: boolean;
  depositsTierRequired: "standard" | "premium";
  analyticsEnabled: boolean;
  analyticsTierRequired: "standard" | "premium";
  autoRenewEnabled: boolean;
  billingPaydunya: boolean;
  billingManual: boolean;
  cardPayments: boolean;
};

export async function getFeatureFlags(): Promise<FeatureFlags> {
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

export async function ensurePro(request: FastifyRequest) {
  const { sub, role } = requireRole(request, ["salon_owner", "salon_manager", "salon_staff"]);
  const user = await prisma.user.findUnique({ where: { id: sub }, select: { salonId: true } });
  if (!user?.salonId) throw new HttpAuthError(403, "not_in_salon", "Vous n'êtes associé à aucun salon.");
  return { userId: sub, salonId: user.salonId, role };
}

export function ownerOnly(role: string, reply: FastifyReply): boolean {
  if (role !== "salon_owner") {
    fail(reply, 403, "owner_only", "Action réservée au propriétaire du salon.");
    return false;
  }
  return true;
}

export function managerOrOwner(role: string, reply: FastifyReply): boolean {
  if (role !== "salon_owner" && role !== "salon_manager") {
    fail(reply, 403, "manager_forbidden", "Action réservée aux gestionnaires.");
    return false;
  }
  return true;
}

export const LOCKED_SUBSCRIPTION_STATUSES = new Set(["inactive", "paused", "cancelled", "expired"]);

export async function ensureProWriteAccess(salonId: string, reply: FastifyReply): Promise<boolean> {
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

export interface RetentionOffer {
  type: string;
  title: string;
  description: string;
}

export function getRetentionOffer(reason: string, tier: "standard" | "premium"): RetentionOffer | null {
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
