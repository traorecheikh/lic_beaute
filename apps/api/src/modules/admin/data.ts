import { createHash, randomBytes } from "node:crypto";
import argon2 from "argon2";

import {
  AdminAuditDetail,
  AdminDashboard,
  AdminSalonDecisionInput,
  AdminSalonCreateInput,
  AdminSalonDetail,
  AdminSalonQueueFilters,
  AdminSalonQueueItem,
  AdminSubscriptionDetail,
  AdminSubscriptionOverrideInput,
  AdminSubscriptionSummary,
  type CancellationReason
} from "@beauteavenue/contracts";
import { formatMoneyXof } from "@beauteavenue/shared-ts";

import { sendEmail } from "../../lib/email.js";
import { logger } from "../../lib/logger.js";
import { config } from "../../config.js";
import { toPublicBillingProvider } from "../../lib/payment-provider.js";
import { prisma } from "../../lib/db/prisma.js";

// ─── Helpers ──────────────────────────────────────────────────────────────────

function startOfToday() {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return d;
}

function daysAgo(n: number) {
  return new Date(Date.now() - n * 24 * 60 * 60 * 1000);
}

async function writeAuditLog(entry: {
  action: string;
  summary: string;
  entityType: string;
  entityId: string;
  actorName: string;
  severity: "info" | "warning" | "critical";
  payloadJson: string;
  relatedLinks: Array<{ label: string; href: string }>;
}) {
  return prisma.auditLog.create({
    data: {
      action: entry.action,
      summary: entry.summary,
      entityType: entry.entityType,
      entityId: entry.entityId,
      actorName: entry.actorName,
      severity: entry.severity,
      payloadJson: entry.payloadJson,
      relatedLinksJson: JSON.stringify(entry.relatedLinks)
    }
  });
}

function parseBooleanSetting(value: string | undefined, fallback: boolean) {
  if (!value) return fallback;
  const normalized = value.trim().toLowerCase();
  if (normalized === "true" || normalized === "1" || normalized === "yes") return true;
  if (normalized === "false" || normalized === "0" || normalized === "no") return false;
  return fallback;
}

async function buildEntitlements(tier: "standard" | "premium") {
  const isPremium = tier === "premium";
  const rows = await prisma.platformSetting.findMany({
    where: { group: "subscription_features" },
    select: { key: true, value: true }
  });
  const map = Object.fromEntries(rows.map((r) => [r.key, r.value]));
  const depositsEnabled = parseBooleanSetting(map["feature_deposits_enabled"], true);
  const depositsTierRequired = map["feature_deposits_tier_required"] === "standard" ? "standard" : "premium";
  const analyticsEnabled = parseBooleanSetting(map["feature_analytics_enabled"], true);
  const analyticsTierRequired = map["feature_analytics_tier_required"] === "standard" ? "standard" : "premium";

  return [
    { label: "Badge Premium", enabled: isPremium, note: null },
    { label: "Mise en avant", enabled: isPremium, note: isPremium ? "Recommandé dans la découverte." : null },
    { label: "Acompte client", enabled: depositsEnabled && (depositsTierRequired === "standard" || isPremium), note: depositsEnabled ? (isPremium ? "Actif sur services éligibles." : null) : "Désactivé par l'administrateur." },
    { label: "Rapports financiers", enabled: analyticsEnabled && (analyticsTierRequired === "standard" || isPremium), note: null },
    { label: "Galerie étendue", enabled: isPremium, note: isPremium ? null : "Limité à 3 photos." }
  ];
}

async function getSalonOwnerContact(salonId: string) {
  return prisma.user.findFirst({
    where: { salonId, role: "salon_owner" },
    select: { email: true, fullName: true }
  });
}

// ─── Dashboard ────────────────────────────────────────────────────────────────

export async function getAdminDashboard(): Promise<AdminDashboard> {
  const today = startOfToday();
  const sevenDaysAgo = daysAgo(7);
  const fourteenDaysAgo = daysAgo(14);

  const [
    revenueToday,
    bookingsToday,
    activeSalons,
    newRegistrations,
    pendingApprovals,
    subscriptionsNeedingAction,
    auditEventsToday,
    salonsWithRecentBookings,
    approvedSalonsForInactivity
  ] = await Promise.all([
    prisma.payment.aggregate({
      where: { status: "succeeded", createdAt: { gte: today } },
      _sum: { amountXof: true }
    }),
    prisma.booking.count({ where: { createdAt: { gte: today } } }),
    prisma.salon.count({ where: { approvalStatus: "approved", isVisibleInMarketplace: true } }),
    prisma.salon.count({ where: { createdAt: { gte: sevenDaysAgo } } }),
    prisma.salon.count({ where: { approvalStatus: { in: ["pending_review", "needs_info"] } } }),
    prisma.subscription.count({ where: { status: { in: ["past_due", "paused"] } } }),
    prisma.auditLog.count({ where: { createdAt: { gte: today } } }),
    prisma.booking.groupBy({
      by: ["salonId"],
      where: { createdAt: { gte: sevenDaysAgo } },
      _count: { id: true },
      orderBy: { _count: { id: "desc" } },
      take: 10
    }),
    prisma.salon.findMany({
      where: { approvalStatus: "approved" },
      select: { id: true, name: true, city: true, approvalStatus: true }
    })
  ]);

  // Build top growth salons by comparing this week vs last week
  const thisWeekMap = new Map(salonsWithRecentBookings.map((r) => [r.salonId, r._count.id]));
  const topSalonIds = salonsWithRecentBookings.slice(0, 5).map((r) => r.salonId);

  const lastWeekBookings = await prisma.booking.groupBy({
    by: ["salonId"],
    where: { salonId: { in: topSalonIds }, createdAt: { gte: fourteenDaysAgo, lt: sevenDaysAgo } },
    _count: { id: true }
  });
  const lastWeekMap = new Map(lastWeekBookings.map((r) => [r.salonId, r._count.id]));

  const topSalons = await prisma.salon.findMany({
    where: { id: { in: topSalonIds } },
    select: { id: true, name: true, city: true }
  });

  const topGrowthSalons = topSalons
    .map((salon) => {
      const thisWeek = thisWeekMap.get(salon.id) ?? 0;
      const lastWeek = lastWeekMap.get(salon.id) ?? 0;
      const delta = lastWeek === 0 ? 100 : Math.round(((thisWeek - lastWeek) / lastWeek) * 100);
      return { salonId: salon.id, salonName: salon.name, city: salon.city, bookingsThisWeek: thisWeek, bookingDeltaPercent: delta };
    })
    .sort((a, b) => b.bookingDeltaPercent - a.bookingDeltaPercent);

  // Inactivity alerts: approved salons with no bookings in last 7 days
  const activeSalonIds = new Set(salonsWithRecentBookings.map((r) => r.salonId));
  const inactivityAlerts = approvedSalonsForInactivity
    .filter((s) => !activeSalonIds.has(s.id))
    .slice(0, 5)
    .map((s) => ({
      salonId: s.id,
      salonName: s.name,
      city: s.city,
      daysWithoutBookings: 7,
      status: s.approvalStatus as "approved"
    }));

  return {
    kpis: [
      {
        label: "Revenue du jour",
        value: revenueToday._sum.amountXof ?? 0,
        displayValue: formatMoneyXof(revenueToday._sum.amountXof ?? 0),
        note: "Paiements validés après réconciliation."
      },
      {
        label: "Réservations du jour",
        value: bookingsToday,
        displayValue: String(bookingsToday).padStart(2, "0"),
        note: "Inclut les réservations premium avec acompte."
      },
      {
        label: "Salons actifs",
        value: activeSalons,
        displayValue: String(activeSalons),
        note: "Salons approuvés visibles sur la marketplace."
      },
      {
        label: "Nouvelles inscriptions",
        value: newRegistrations,
        displayValue: String(newRegistrations).padStart(2, "0"),
        note: "Demandes de salons sur les 7 derniers jours."
      }
    ],
    topGrowthSalons,
    inactivityAlerts,
    quickLinks: {
      pendingSalonApprovals: pendingApprovals,
      subscriptionsNeedingAction,
      auditEventsToday
    }
  };
}

// ─── Salon queue ──────────────────────────────────────────────────────────────

export async function listPendingSalons(filters: AdminSalonQueueFilters & { page?: number; pageSize?: number }) {
  const page = Math.max(0, filters.page ?? 0);
  const pageSize = Math.min(100, Math.max(1, filters.pageSize ?? 20));

  const [salons, total] = await Promise.all([
    prisma.salon.findMany({
      where: {
        approvalStatus: filters.status
          ? { equals: filters.status as any }
          : { in: ["pending_review", "needs_info"] },
        ...(filters.category && { category: filters.category }),
        ...(filters.city && { city: { contains: filters.city, mode: "insensitive" } }),
        ...(filters.search && {
          OR: [
            { name: { contains: filters.search, mode: "insensitive" } },
            { city: { contains: filters.search, mode: "insensitive" } },
            { staffMembers: { some: { role: "salon_owner", fullName: { contains: filters.search, mode: "insensitive" } } } }
          ]
        })
      },
      include: {
        staffMembers: { where: { role: "salon_owner" }, select: { fullName: true } },
        documents: true
      },
      orderBy: { submittedAt: "asc" },
      take: pageSize,
      skip: page * pageSize
    }),
    prisma.salon.count({
      where: {
        approvalStatus: filters.status
          ? { equals: filters.status as any }
          : { in: ["pending_review", "needs_info"] },
        ...(filters.category && { category: filters.category }),
        ...(filters.city && { city: { contains: filters.city, mode: "insensitive" } }),
        ...(filters.search && {
          OR: [
            { name: { contains: filters.search, mode: "insensitive" } },
            { city: { contains: filters.search, mode: "insensitive" } },
            { staffMembers: { some: { role: "salon_owner", fullName: { contains: filters.search, mode: "insensitive" } } } }
          ]
        })
      }
    })
  ]);

  const items: AdminSalonQueueItem[] = salons.map((salon) => ({
    id: salon.id,
    salonName: salon.name,
    category: salon.category,
    city: salon.city,
    ownerName: salon.staffMembers[0]?.fullName ?? "—",
    submittedAt: salon.submittedAt.toISOString(),
    approvalStatus: salon.approvalStatus as AdminSalonQueueItem["approvalStatus"],
    subscriptionIntentTier: salon.subscriptionIntentTier as AdminSalonQueueItem["subscriptionIntentTier"],
    missingEvidence: (salon.documents as Array<{ status: string; label: string }>).filter((d) => d.status !== "received").map((d) => d.label),
    latestAdminNote: salon.latestAdminNote
  }));

  return { items, total, page, pageSize };
}

export async function listSalons(filters: { search?: string; status?: string; page?: number; pageSize?: number }) {
  const page = Math.max(0, filters.page ?? 0);
  const pageSize = Math.min(100, Math.max(1, filters.pageSize ?? 20));

  const [salons, total] = await Promise.all([
    prisma.salon.findMany({
      where: {
        ...(filters.status && { approvalStatus: filters.status as any }),
        ...(filters.search && {
          OR: [
            { name: { contains: filters.search, mode: "insensitive" } },
            { city: { contains: filters.search, mode: "insensitive" } }
          ]
        })
      },
      include: {
        staffMembers: { where: { role: "salon_owner" }, select: { fullName: true } },
        documents: true
      },
      orderBy: { createdAt: "desc" },
      take: pageSize,
      skip: page * pageSize
    }),
    prisma.salon.count({
      where: {
        ...(filters.status && { approvalStatus: filters.status as any }),
        ...(filters.search && {
          OR: [
            { name: { contains: filters.search, mode: "insensitive" } },
            { city: { contains: filters.search, mode: "insensitive" } }
          ]
        })
      }
    })
  ]);

  const items: AdminSalonQueueItem[] = salons.map((salon) => ({
    id: salon.id,
    salonName: salon.name,
    category: salon.category,
    city: salon.city,
    ownerName: salon.staffMembers[0]?.fullName ?? "—",
    submittedAt: salon.submittedAt.toISOString(),
    approvalStatus: salon.approvalStatus as AdminSalonQueueItem["approvalStatus"],
    subscriptionIntentTier: salon.subscriptionIntentTier as AdminSalonQueueItem["subscriptionIntentTier"],
    missingEvidence: (salon.documents as Array<{ status: string; label: string }>).filter((d) => d.status !== "received").map((d) => d.label),
    latestAdminNote: salon.latestAdminNote
  }));

  return { items, total, page, pageSize };
}

export async function getPendingSalonDetail(salonId: string): Promise<AdminSalonDetail | null> {
  const salon = await prisma.salon.findUnique({
    where: { id: salonId },
    include: {
      staffMembers: { where: { role: "salon_owner" } },
      services: true,
      documents: true,
      gallery: { orderBy: { position: "asc" } },
      subscription: { select: { id: true } }
    }
  });

  if (!salon) return null;

  const owner = salon.staffMembers[0];

  return {
    id: salon.id,
    subscriptionId: salon.subscription?.id ?? null,
    salonName: salon.name,
    category: salon.category,
    city: salon.city,
    address: salon.address,
    description: salon.description,
    owner: {
      fullName: owner?.fullName ?? "—",
      email: owner?.email ?? "",
      phone: owner?.phone ?? ""
    },
    approvalStatus: salon.approvalStatus as AdminSalonDetail["approvalStatus"],
    subscriptionIntentTier: salon.subscriptionIntentTier as AdminSalonDetail["subscriptionIntentTier"],
    submittedAt: salon.submittedAt.toISOString(),
    missingEvidence: salon.documents.filter((d) => d.status !== "received").map((d) => d.label),
    latestAdminNote: salon.latestAdminNote,
    gallery: salon.gallery.map((img) => img.url),
    services: salon.services.map((s) => ({
      id: s.id,
      name: s.name,
      durationMinutes: s.durationMinutes,
      priceXof: s.priceXof,
      depositMode: s.depositMode as "none" | "fixed" | "percent",
      depositAmountXof: s.depositAmountXof,
      depositPercent: s.depositPercent
    })),
    documents: salon.documents.map((d) => ({
      label: d.label,
      status: d.status as "received" | "missing" | "invalid",
      note: d.note,
      fileUrl: d.fileUrl
    }))
  };
}

export async function approveSalon(salonId: string, actorName: string) {
  const salon = await prisma.salon.findUnique({ where: { id: salonId } });
  if (!salon) return null;

  const updated = await prisma.salon.update({
    where: { id: salonId },
    data: { approvalStatus: "approved", isVisibleInMarketplace: false, canReceiveBookings: false, latestAdminNote: "Salon approuvé. Activation en attente d'un abonnement actif." }
  });

  await prisma.subscription.upsert({
    where: { salonId },
    create: { salonId, tier: salon.subscriptionIntentTier, status: "inactive" },
    update: {}
  });

  await writeAuditLog({
    action: "salon.approved",
    summary: `Salon ${salon.name} approuvé.`,
    entityType: "salon",
    entityId: salonId,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify({ salonId, approvalStatus: "approved" }),
    relatedLinks: [{ label: salon.name, href: `/admin/salons/${salonId}` }]
  });

  const owner = await getSalonOwnerContact(salonId);
  if (owner?.email) {
    const { buildEmailHtml } = await import("../../lib/email-html.js");
    await sendEmail({
      to: owner.email,
      subject: "Votre salon est approuvé sur Beauté Avenue",
      text:
        `Bonjour ${owner.fullName ?? ""},\n\n` +
        `Excellente nouvelle: le salon "${salon.name}" a été approuvé.\n` +
        `Dernière étape: activez votre abonnement pour rendre le salon visible et recevoir des réservations.\n\n` +
        `— L'équipe Beauté Avenue`,
      html: buildEmailHtml({
        preheader: "Votre dossier a été validé",
        greeting: `Bonjour ${owner.fullName ?? ""},`,
        bodyLines: [
          `Excellente nouvelle ! Le salon <strong>${salon.name}</strong> a été approuvé.`,
          `Dernière étape : <strong>activez votre abonnement</strong> pour rendre votre salon visible et recevoir vos premières réservations.`
        ],
        cta: { url: `${config.webOrigin}/pro/billing`, label: "Activer mon abonnement" },
        ignoreNote: false,
        footerNote: "— L'équipe Beauté Avenue"
      })
    }).catch((err) =>
      logger.error("approveSalon: failed to send decision email", { err: String(err), ownerEmail: owner.email, salonId })
    );
  }

  return getPendingSalonDetail(updated.id);
}

export async function rejectSalon(salonId: string, input: AdminSalonDecisionInput, actorName: string) {
  const salon = await prisma.salon.findUnique({ where: { id: salonId } });
  if (!salon) return null;

  await prisma.salon.update({
    where: { id: salonId },
    data: { approvalStatus: "rejected", latestAdminNote: input.reason }
  });

  await writeAuditLog({
    action: "salon.rejected",
    summary: `Salon ${salon.name} rejeté.`,
    entityType: "salon",
    entityId: salonId,
    actorName,
    severity: "warning",
    payloadJson: JSON.stringify({ reason: input.reason }),
    relatedLinks: [{ label: salon.name, href: `/admin/salons/${salonId}` }]
  });

  const owner = await getSalonOwnerContact(salonId);
  if (owner?.email) {
    const { buildEmailHtml } = await import("../../lib/email-html.js");
    sendEmail({
      to: owner.email,
      subject: "Dossier salon refusé — Beauté Avenue",
      text:
        `Bonjour ${owner.fullName ?? ""},\n\n` +
        `Le dossier du salon "${salon.name}" a été refusé.\n` +
        `Motif: ${input.reason}\n\n` +
        `Vous pouvez corriger les éléments demandés puis soumettre à nouveau.\n\n` +
        `— L'équipe Beauté Avenue`,
      html: buildEmailHtml({
        preheader: "Votre dossier n'a pas été validé",
        greeting: `Bonjour ${owner.fullName ?? ""},`,
        bodyLines: [
          `Le dossier du salon <strong>${salon.name}</strong> a été refusé.`,
          `<strong>Motif :</strong> ${input.reason}`,
          `Vous pouvez corriger les éléments demandés dans votre espace, puis soumettre à nouveau votre dossier.`
        ],
        cta: { url: `${config.webOrigin}/pro/profile`, label: "Modifier mon dossier" },
        ignoreNote: false,
        footerNote: "— L'équipe Beauté Avenue"
      })
    }).catch((err) =>
      logger.error("rejectSalon: failed to send decision email", { err: String(err), ownerEmail: owner.email, salonId })
    );
  }

  return getPendingSalonDetail(salonId);
}

export async function requestSalonInfo(salonId: string, input: AdminSalonDecisionInput, actorName: string) {
  const salon = await prisma.salon.findUnique({ where: { id: salonId } });
  if (!salon) return null;

  await prisma.salon.update({
    where: { id: salonId },
    data: { approvalStatus: "needs_info", latestAdminNote: input.reason }
  });

  await writeAuditLog({
    action: "salon.request_info",
    summary: `Informations complémentaires demandées à ${salon.name}.`,
    entityType: "salon",
    entityId: salonId,
    actorName,
    severity: "warning",
    payloadJson: JSON.stringify({ reason: input.reason }),
    relatedLinks: [{ label: salon.name, href: `/admin/salons/${salonId}` }]
  });

  const owner = await getSalonOwnerContact(salonId);
  if (owner?.email) {
    const { buildEmailHtml } = await import("../../lib/email-html.js");
    await sendEmail({
      to: owner.email,
      subject: "Informations complémentaires requises — Beauté Avenue",
      text:
        `Bonjour ${owner.fullName ?? ""},\n\n` +
        `Votre dossier pour "${salon.name}" nécessite des informations complémentaires.\n` +
        `Détail: ${input.reason}\n\n` +
        `Connectez-vous à votre espace pro pour mettre à jour votre dossier.\n\n` +
        `— L'équipe Beauté Avenue`,
      html: buildEmailHtml({
        preheader: "Informations complémentaires requises",
        greeting: `Bonjour ${owner.fullName ?? ""},`,
        bodyLines: [
          `Votre dossier pour <strong>${salon.name}</strong> nécessite des informations complémentaires.`,
          `<strong>Détail :</strong> ${input.reason}`,
          `Connectez-vous à votre espace pro pour mettre à jour votre dossier.`
        ],
        cta: { url: `${config.webOrigin}/pro/profile`, label: "Mettre à jour mon dossier" },
        ignoreNote: false,
        footerNote: "— L'équipe Beauté Avenue"
      })
    }).catch((err) =>
      logger.error("requestSalonInfo: failed to send decision email", { err: String(err), ownerEmail: owner.email, salonId })
    );
  }

  return getPendingSalonDetail(salonId);
}

export async function createSalon(data: AdminSalonCreateInput, actorName: string) {
  // Placeholder password — never exposed to anyone; owner sets theirs via setup link.
  const internalPassword = randomBytes(32).toString("hex");

  const salon = await prisma.salon.create({
    data: {
      name: data.name,
      category: data.category,
      city: data.city,
      address: data.address,
      description: data.description,
      approvalStatus: "approved",
      isVisibleInMarketplace: true,
      canReceiveBookings: true,
      staffMembers: {
        create: {
          fullName: data.ownerName,
          email: data.ownerEmail,
          phone: data.ownerPhone,
          role: "salon_owner",
          passwordHash: await argon2.hash(internalPassword)
        }
      }
    }
  });

  await prisma.subscription.create({
    data: { salonId: salon.id, tier: "standard", status: "active" }
  });

  // Generate a one-time 72h setup token and store its hash in platformSetting.
  const owner = await prisma.user.findUnique({ where: { email: data.ownerEmail }, select: { id: true } });
  const setupLink = await (async () => {
    if (!owner) return null;
    const rawToken = randomBytes(32).toString("hex");
    const tokenHash = createHash("sha256").update(rawToken).digest("hex");
    const expiresAt = Date.now() + 72 * 60 * 60 * 1000;
    await prisma.platformSetting.create({
      data: {
        group: "security",
        key: `auth:setup:${owner.id}`,
        value: JSON.stringify({ tokenHash, expiresAt }),
        description: "Account setup token (single-use)"
      }
    });
    return `${config.webOrigin}/pro/setup-account?token=${rawToken}&email=${encodeURIComponent(data.ownerEmail)}`;
  })();

  await writeAuditLog({
    action: "salon.created",
    summary: `Salon ${salon.name} créé manuellement.`,
    entityType: "salon",
    entityId: salon.id,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify({ name: data.name, ownerEmail: data.ownerEmail, city: data.city }),
    relatedLinks: [{ label: salon.name, href: `/admin/salons/${salon.id}` }]
  });

  const { buildEmailHtml } = await import("../../lib/email-html.js");
  sendEmail({
    to: data.ownerEmail,
    subject: "Bienvenue sur Beauté Avenue — Activez votre espace pro",
    text: `Bonjour ${data.ownerName},\n\nVotre espace pro Beauté Avenue a été créé.\n\nActivez votre compte en définissant votre mot de passe via le lien ci-dessous (valable 72h) :\n${setupLink ?? "(lien non disponible — contactez l'administrateur)"}\n\n— L'équipe Beauté Avenue`,
    html: buildEmailHtml({
      preheader: "Activez votre espace professionnel",
      greeting: `Bonjour ${data.ownerName},`,
      bodyLines: [
        `Votre espace professionnel <strong>Beauté Avenue</strong> a été créé.`,
        `Activez votre compte en définissant votre mot de passe via le bouton ci-dessous.`
      ],
      cta: setupLink ? { url: setupLink, label: "Activer mon espace" } : undefined,
      expiryNote: "Ce lien expire dans 72 heures.",
      usageNote: "Il ne peut être utilisé qu'une seule fois.",
      ignoreNote: false,
      footerNote: "— L'équipe Beauté Avenue"
    })
  }).catch((err) => logger.error("createSalon: failed to send setup email", { err: String(err), ownerEmail: data.ownerEmail }));

  return await getPendingSalonDetail(salon.id);
}

// ─── Uniqueness check ─────────────────────────────────────────────────────────

export async function checkSalonUniqueness(fields: { email?: string; phone?: string; name?: string }) {
  const result: { email?: "available" | "taken"; phone?: "available" | "taken"; name?: "available" | "taken" } = {};
  if (fields.email) {
    const existing = await prisma.user.findUnique({ where: { email: fields.email }, select: { id: true } });
    result.email = existing ? "taken" : "available";
  }
  if (fields.phone) {
    const existing = await prisma.user.findFirst({ where: { phone: fields.phone }, select: { id: true } });
    result.phone = existing ? "taken" : "available";
  }
  if (fields.name) {
    const existing = await prisma.salon.findFirst({ where: { name: { equals: fields.name, mode: "insensitive" } }, select: { id: true } });
    result.name = existing ? "taken" : "available";
  }
  return result;
}

// ─── Subscriptions ────────────────────────────────────────────────────────────

export async function listSubscriptions(filters: {
  search?: string;
  tier?: AdminSubscriptionSummary["tier"];
  status?: AdminSubscriptionSummary["status"];
  page?: number;
  pageSize?: number;
}) {
  const page = Math.max(0, filters.page ?? 0);
  const pageSize = Math.min(100, Math.max(1, filters.pageSize ?? 20));

  const [subscriptions, total, premiumCount, standardCount, pausedCount] = await Promise.all([
    prisma.subscription.findMany({
      where: {
        ...(filters.tier && { tier: filters.tier }),
        ...(filters.status && { status: filters.status as any }),
        ...(filters.search && { salon: { name: { contains: filters.search, mode: "insensitive" } } })
      },
      include: { salon: { select: { name: true } } },
      orderBy: { createdAt: "desc" },
      take: pageSize,
      skip: page * pageSize
    }),
    prisma.subscription.count({
      where: {
        ...(filters.tier && { tier: filters.tier }),
        ...(filters.status && { status: filters.status as any }),
        ...(filters.search && { salon: { name: { contains: filters.search, mode: "insensitive" } } })
      }
    }),
    prisma.subscription.count({ where: { tier: "premium" } }),
    prisma.subscription.count({ where: { tier: "standard" } }),
    prisma.subscription.count({ where: { status: "paused" } })
  ]);

  const items: AdminSubscriptionSummary[] = subscriptions.map((sub) => ({
    id: sub.id,
    salonId: sub.salonId,
    salonName: sub.salon.name,
    tier: sub.tier as AdminSubscriptionSummary["tier"],
    status: sub.status as AdminSubscriptionSummary["status"],
    billingProvider: toPublicBillingProvider(sub.billingProvider),
    expiresAt: sub.expiresAt?.toISOString() ?? null,
    autoRenew: sub.autoRenew,
    isComplimentary: sub.isComplimentary
  }));

  return { summary: { premiumCount, standardCount, pausedCount }, items, total, page, pageSize };
}

export async function getSubscriptionDetail(subscriptionId: string): Promise<AdminSubscriptionDetail | null> {
  const sub = await prisma.subscription.findUnique({
    where: { id: subscriptionId },
    include: {
      salon: { select: { name: true } },
      events: { orderBy: { createdAt: "desc" } },
      invoices: { orderBy: { createdAt: "desc" } },
      charges: { where: { status: "pending" }, orderBy: { createdAt: "desc" } }
    }
  });

  if (!sub) return null;

  return {
    id: sub.id,
    salonId: sub.salonId,
    salonName: sub.salon.name,
    tier: sub.tier as AdminSubscriptionDetail["tier"],
    status: sub.status as AdminSubscriptionDetail["status"],
    billingProvider: toPublicBillingProvider(sub.billingProvider),
    expiresAt: sub.expiresAt?.toISOString() ?? null,
    autoRenew: sub.autoRenew,
    isComplimentary: sub.isComplimentary,
    startedAt: sub.startedAt.toISOString(),
    renewedAt: sub.renewedAt?.toISOString() ?? null,
    entitlements: await buildEntitlements(sub.tier as "standard" | "premium"),
    events: sub.events.map((e) => ({
      id: e.id,
      eventType: e.eventType,
      summary: e.summary,
      createdAt: e.createdAt.toISOString(),
      actorName: e.actorName,
      source: e.source as "provider" | "admin" | "system",
      payloadPreview: e.payloadPreview
    })),
    invoices: sub.invoices.map((inv) => ({
      id: inv.id,
      invoiceNumber: inv.invoiceNumber,
      amountXof: inv.amountXof,
      status: inv.status as "issued" | "void" | "paid" | "comped",
      createdAt: inv.createdAt.toISOString(),
      pdfUrl: inv.pdfUrl
    })),
    pendingCharges: sub.charges.map((c) => ({
      id: c.id,
      amountXof: c.amountXof,
      chargeType: c.chargeType as "upgrade" | "renewal",
      provider: c.provider as "paydunya" | "manual",
      status: c.status as "pending" | "authorized" | "succeeded" | "failed" | "refunded",
      createdAt: c.createdAt.toISOString()
    }))
  };
}

export async function overrideSubscription(
  subscriptionId: string,
  input: AdminSubscriptionOverrideInput,
  actorName: string
) {
  const sub = await prisma.subscription.findUnique({
    where: { id: subscriptionId },
    include: { salon: { select: { name: true } } }
  });
  if (!sub) return null;

  const effectiveAt = input.effectiveAt ? new Date(input.effectiveAt) : new Date();

  const updateData: Parameters<typeof prisma.subscription.update>[0]["data"] = {};

  switch (input.action) {
    case "grant_complimentary_premium":
      updateData.tier = "premium";
      updateData.status = "active";
      updateData.isComplimentary = true;
      updateData.autoRenew = false;
      updateData.billingProvider = null;
      if (input.expiresAt) updateData.expiresAt = new Date(input.expiresAt);
      break;
    case "extend_expiry":
      if (input.expiresAt) updateData.expiresAt = new Date(input.expiresAt);
      // also activate if inactive or paused
      if (sub.status === "inactive" || sub.status === "paused") {
        updateData.status = "active";
      }
      break;
    case "downgrade_to_standard":
      updateData.tier = "standard";
      updateData.status = "active";
      updateData.autoRenew = false;
      break;
    case "pause_subscription":
      updateData.status = "paused";
      updateData.autoRenew = false;
      break;
    case "resume_subscription":
      updateData.status = "active";
      updateData.autoRenew = true;
      break;
    case "terminate_subscription":
      updateData.status = "cancelled";
      updateData.autoRenew = false;
      updateData.expiresAt = effectiveAt;
      break;
    case "mark_charge_resolved":
      break;
  }

  await prisma.$transaction(async (tx) => {
    await tx.subscription.update({ where: { id: subscriptionId }, data: updateData });

    if (input.action === "pause_subscription" || input.action === "terminate_subscription") {
      await tx.salon.update({
        where: { id: sub.salonId },
        data: { isVisibleInMarketplace: false, canReceiveBookings: false }
      });
    }

    if (input.action === "grant_complimentary_premium" || input.action === "downgrade_to_standard" || input.action === "resume_subscription" || input.action === "extend_expiry") {
      await tx.salon.update({
        where: { id: sub.salonId },
        data: { isVisibleInMarketplace: true, canReceiveBookings: true }
      });
    }

    if (input.action === "mark_charge_resolved") {
      const chargeId = input.metadata?.subscriptionChargeId;
      const providerRef = input.metadata?.providerReference;
      if (!chargeId || !providerRef) {
        throw Object.assign(new Error("mark_charge_resolved requires subscriptionChargeId and providerReference"), { _status: 422 });
      }
      const charge = await tx.subscriptionCharge.findUnique({ where: { id: chargeId } });
      if (!charge || charge.subscriptionId !== subscriptionId) {
        throw Object.assign(new Error("charge_not_found"), { _status: 422 });
      }
      await tx.subscriptionCharge.update({
        where: { id: chargeId },
        data: { status: "succeeded", providerTxId: providerRef }
      });
    }

    await tx.subscriptionEvent.create({
      data: {
        subscriptionId,
        eventType: input.action,
        summary: input.reason,
        actorName,
        source: "admin",
        payloadPreview: input.metadata?.internalTicket ?? null
      }
    });

    if (input.action === "grant_complimentary_premium") {
      const year = new Date().getFullYear();
      const suffix = randomBytes(4).toString("hex").toUpperCase();
      await tx.billingInvoice.create({
        data: {
          subscriptionId,
          invoiceNumber: `BA-${year}-COMP-${suffix}`,
          amountXof: 0,
          status: "comped",
          pdfUrl: ""
        }
      });
    }

    await tx.auditLog.create({
      data: {
        action: `subscription.${input.action}`,
        summary: `Override ${input.action} appliqué sur ${sub.salon.name}.`,
        entityType: "subscription",
        entityId: subscriptionId,
        actorName,
        severity: input.action === "terminate_subscription" ? "critical" : "warning",
        payloadJson: JSON.stringify(input),
        relatedLinksJson: JSON.stringify([
          { label: sub.salon.name, href: `/admin/subscriptions/${subscriptionId}` }
        ])
      }
    });

    if (updateData.tier) {
      await tx.salon.update({
        where: { id: sub.salonId },
        data: { subscriptionTier: updateData.tier as "standard" | "premium" }
      });
    }
  });

  const owner = await getSalonOwnerContact(sub.salonId);
  if (owner?.email) {
    const { buildEmailHtml } = await import("../../lib/email-html.js");
    await sendEmail({
      to: owner.email,
      subject: "Mise à jour abonnement salon — Beauté Avenue",
      text:
        `Bonjour ${owner.fullName ?? ""},\n\n` +
        `Votre abonnement pour "${sub.salon.name}" a été mis à jour par l'administration.\n` +
        `Action: ${input.action}\n` +
        `Motif: ${input.reason}\n\n` +
        `Consultez votre espace pro pour voir le statut actuel.\n\n` +
        `— L'équipe Beauté Avenue`,
      html: buildEmailHtml({
        preheader: "Mise à jour de votre abonnement",
        greeting: `Bonjour ${owner.fullName ?? ""},`,
        bodyLines: [
          `Votre abonnement pour <strong>${sub.salon.name}</strong> a été mis à jour par l'administration.`,
          `<strong>Action :</strong> ${input.action}`,
          `<strong>Motif :</strong> ${input.reason}`,
          `Consultez votre espace pro pour voir le statut actuel.`
        ],
        cta: { url: `${config.webOrigin}/pro/billing`, label: "Voir mon abonnement" },
        ignoreNote: false,
        footerNote: "— L'équipe Beauté Avenue"
      })
    }).catch((err) =>
      logger.error("overrideSubscription: failed to send subscription email", {
        err: String(err),
        ownerEmail: owner.email,
        subscriptionId
      })
    );
  }

  return getSubscriptionDetail(subscriptionId);
}

// ─── Manual extension (out-of-app payment) ────────────────────────────────────

// ─── Cancellation stats ─────────────────────────────────────────────────────

export async function getCancellationStats() {
  const totalCancelled = await prisma.subscription.count({
    where: { cancelReason: { not: null } }
  });

  const reasons = await prisma.subscription.groupBy({
    by: ["cancelReason"],
    where: { cancelReason: { not: null } },
    _count: { cancelReason: true }
  });

  const stats = reasons
    .filter((r): r is typeof r & { cancelReason: string } => r.cancelReason !== null)
    .map((r) => ({
      reason: r.cancelReason,
      count: r._count.cancelReason,
      percent: totalCancelled > 0 ? Math.round((r._count.cancelReason / totalCancelled) * 100) : 0
    }));

  const reasonLabels: Record<string, { label: string; emoji: string }> = {
    too_expensive: { label: "Trop cher", emoji: "💰" },
    missing_features: { label: "Fonctionnalités manquantes", emoji: "🔧" },
    low_traffic: { label: "Manque de visibilité", emoji: "📉" },
    technical_issues: { label: "Problèmes techniques", emoji: "⚡" },
    poor_support: { label: "Support insatisfaisant", emoji: "🤷" },
    seasonal_closure: { label: "Fermeture saisonnière", emoji: "🏖️" },
    switching_competitor: { label: "Concurrence", emoji: "🏃" },
    business_closure: { label: "Fermeture définitive", emoji: "🔒" },
    payment_issues: { label: "Problèmes de paiement", emoji: "💳" },
    other: { label: "Autre", emoji: "✍️" }
  };

  return {
    totalCancelled,
    items: stats.map((s) => ({
      ...s,
      label: reasonLabels[s.reason]?.label ?? s.reason,
      emoji: reasonLabels[s.reason]?.emoji ?? "❓"
    })),
    retainedCount: await prisma.subscriptionEvent.count({
      where: { eventType: "retained" }
    })
  };
}

export async function manualExtendSubscription(
  subscriptionId: string,
  input: import("@beauteavenue/contracts").AdminManualExtendInput,
  actorName: string
) {
  const sub = await prisma.subscription.findUnique({
    where: { id: subscriptionId },
    include: { salon: { select: { id: true, name: true } } }
  });
  if (!sub) return null;

  const now = new Date();
  const effectiveDate = input.effectiveDate ? new Date(input.effectiveDate) : now;

  const currentExpiry = sub.expiresAt && sub.expiresAt > now ? sub.expiresAt : now;
  const newExpiresAt = new Date(currentExpiry.getTime() + input.durationDays * 24 * 60 * 60 * 1000);

  let chargeId = "";
  let invoiceId = "";

  await prisma.$transaction(async (tx) => {
    if (sub.status === "inactive" || sub.status === "paused") {
      await tx.salon.update({
        where: { id: sub.salon.id },
        data: { isVisibleInMarketplace: true, canReceiveBookings: true }
      });
    }

    const year = new Date().getFullYear();
    const suffix = randomBytes(4).toString("hex").toUpperCase();
    const invoice = await tx.billingInvoice.create({
      data: {
        subscriptionId,
        invoiceNumber: `BA-${year}-MANUAL-${suffix}`,
        amountXof: input.amountXof,
        status: "paid",
        pdfUrl: ""
      }
    });
    invoiceId = invoice.id;

    const charge = await tx.subscriptionCharge.create({
      data: {
        subscriptionId,
        provider: "manual",
        status: "succeeded",
        amountXof: input.amountXof,
        chargeType: "renewal",
        idempotencyKey: `manual-ext-${randomBytes(8).toString("hex")}`,
        invoiceId: invoice.id
      }
    });
    chargeId = charge.id;

    await tx.subscription.update({
      where: { id: subscriptionId },
      data: {
        status: "active",
        expiresAt: newExpiresAt,
        renewedAt: effectiveDate,
        billingProvider: "manual",
        autoRenew: false
      }
    });

    await tx.subscriptionEvent.create({
      data: {
        subscriptionId,
        eventType: "manual_extend",
        summary: input.reason,
        actorName,
        source: "admin",
        payloadPreview: `Manual extension: ${input.amountXof} XOF, ${input.durationDays} days, ref: ${input.reference}`
      }
    });

    await tx.auditLog.create({
      data: {
        action: "subscription.manual_extend",
        summary: `Extension manuelle de ${input.durationDays} jours pour ${sub.salon.name} (${input.amountXof} XOF).`,
        entityType: "subscription",
        entityId: subscriptionId,
        actorName,
        severity: "info",
        payloadJson: JSON.stringify(input),
        relatedLinksJson: JSON.stringify([
          { label: sub.salon.name, href: `/admin/subscriptions/${subscriptionId}` }
        ])
      }
    });
  });

  const owner = await getSalonOwnerContact(sub.salon.id);
  if (owner?.email) {
    const { buildEmailHtml } = await import("../../lib/email-html.js");
    const expiryLabel = newExpiresAt.toLocaleDateString("fr-FR", {
      year: "numeric", month: "long", day: "numeric"
    });
    const amountLabel = (input.amountXof / 100).toLocaleString("fr-FR");
    await sendEmail({
      to: owner.email,
      subject: "Abonnement prolongé — Beauté Avenue",
      text:
        `Bonjour ${owner.fullName ?? ""},\n\n` +
        `Votre abonnement pour "${sub.salon.name}" a été prolongé manuellement.\n` +
        `Montant: ${amountLabel} FCFA\n` +
        `Durée: ${input.durationDays} jours\n` +
        `Nouvelle date d'expiration: ${expiryLabel}\n` +
        `Motif: ${input.reason}\n` +
        `Référence: ${input.reference}\n\n` +
        `Consultez votre espace pro pour voir votre abonnement.\n\n` +
        `— L'équipe Beauté Avenue`,
      html: buildEmailHtml({
        preheader: "Votre abonnement a été prolongé",
        greeting: `Bonjour ${owner.fullName ?? ""},`,
        bodyLines: [
          `Votre abonnement pour <strong>${sub.salon.name}</strong> a été prolongé manuellement.`,
          `<strong>Montant :</strong> ${amountLabel} FCFA`,
          `<strong>Durée :</strong> ${input.durationDays} jours`,
          `<strong>Nouvelle date d'expiration :</strong> ${expiryLabel}`,
          `<strong>Motif :</strong> ${input.reason}`,
          `Référence : ${input.reference}`
        ],
        cta: { url: `${config.webOrigin}/pro/billing`, label: "Voir mon abonnement" },
        ignoreNote: false,
        footerNote: "— L'équipe Beauté Avenue"
      })
    }).catch((err) =>
      logger.error("manualExtendSubscription: failed to send email", {
        err: String(err), ownerEmail: owner.email, subscriptionId
      })
    );
  }

  return {
    id: sub.id,
    subscriptionId,
    salonId: sub.salon.id,
    previousExpiresAt: sub.expiresAt?.toISOString() ?? null,
    newExpiresAt: newExpiresAt.toISOString(),
    amountXof: input.amountXof,
    durationDays: input.durationDays,
    reference: input.reference,
    chargeId,
    invoiceId
  };
}

// ─── Audit log ────────────────────────────────────────────────────────────────

export async function listAuditEvents(filters: { actor?: string; entityType?: string; action?: string; page?: number; pageSize?: number }) {
  const page = Math.max(0, filters.page ?? 0);
  const pageSize = Math.min(200, Math.max(1, filters.pageSize ?? 50));

  const [events, total] = await Promise.all([
    prisma.auditLog.findMany({
      where: {
        ...(filters.actor && { actorName: { contains: filters.actor, mode: "insensitive" } }),
        ...(filters.entityType && { entityType: filters.entityType }),
        ...(filters.action && { action: { contains: filters.action } })
      },
      orderBy: { createdAt: "desc" },
      take: pageSize,
      skip: page * pageSize
    }),
    prisma.auditLog.count({
      where: {
        ...(filters.actor && { actorName: { contains: filters.actor, mode: "insensitive" } }),
        ...(filters.entityType && { entityType: filters.entityType }),
        ...(filters.action && { action: { contains: filters.action } })
      }
    })
  ]);

  return {
    items: events.map((e) => ({
      id: e.id,
      action: e.action,
      summary: e.summary,
      entityType: e.entityType,
      entityId: e.entityId,
      actorName: e.actorName,
      createdAt: e.createdAt.toISOString(),
      severity: e.severity as "info" | "warning" | "critical"
    })),
    total,
    page,
    pageSize
  };
}

export async function listEmailAuditEvents(filters: { status?: string; driver?: string; to?: string; page?: number; pageSize?: number }) {
  const page = Math.max(0, filters.page ?? 0);
  const pageSize = Math.min(200, Math.max(1, filters.pageSize ?? 50));

  const [events, total] = await Promise.all([
    prisma.emailAudit.findMany({
      where: {
        ...(filters.status && { status: filters.status }),
        ...(filters.driver && { driver: filters.driver }),
        ...(filters.to && { to: { contains: filters.to, mode: "insensitive" } })
      },
      orderBy: { createdAt: "desc" },
      take: pageSize,
      skip: page * pageSize
    }),
    prisma.emailAudit.count({
      where: {
        ...(filters.status && { status: filters.status }),
        ...(filters.driver && { driver: filters.driver }),
        ...(filters.to && { to: { contains: filters.to, mode: "insensitive" } })
      }
    })
  ]);

  return {
    items: events.map((e) => ({
      id: e.id,
      to: e.to,
      subject: e.subject,
      driver: e.driver,
      status: e.status,
      errorMessage: e.errorMessage,
      createdAt: e.createdAt.toISOString()
    })),
    total,
    page,
    pageSize
  };
}

async function normalizeSubscriptionAuditReference(
  entityId: string,
  relatedLinks: Array<{ label: string; href: string }>
) {
  const subscription = await prisma.subscription.findFirst({
    where: {
      OR: [
        { id: entityId },
        { salonId: entityId }
      ]
    },
    select: { id: true }
  });

  if (!subscription) {
    return { entityId, relatedLinks };
  }

  return {
    entityId: subscription.id,
    relatedLinks: relatedLinks.map((link) => (
      link.href.startsWith("/admin/subscriptions/")
        ? { ...link, href: `/admin/subscriptions/${subscription.id}` }
        : link
    ))
  };
}

export async function getAuditDetail(auditId: string): Promise<AdminAuditDetail | null> {
  const event = await prisma.auditLog.findUnique({ where: { id: auditId } });
  if (!event) return null;

  const relatedLinks = JSON.parse(event.relatedLinksJson) as Array<{ label: string; href: string }>;
  const normalizedReference = event.entityType === "subscription"
    ? await normalizeSubscriptionAuditReference(event.entityId, relatedLinks)
    : { entityId: event.entityId, relatedLinks };

  return {
    id: event.id,
    action: event.action,
    summary: event.summary,
    entityType: event.entityType,
    entityId: normalizedReference.entityId,
    actorName: event.actorName,
    createdAt: event.createdAt.toISOString(),
    severity: event.severity as "info" | "warning" | "critical",
    payloadJson: event.payloadJson,
    relatedLinks: normalizedReference.relatedLinks
  };
}

// ─── Configuration ────────────────────────────────────────────────────────────

const HIDDEN_SETTING_KEYS = new Set([
  "paydunya_master_key",
  "paydunya_private_key",
  "paydunya_token",
  "platform_name"
]);

export async function getPlatformSettings(group?: string) {
  const rows = await prisma.platformSetting.findMany({
    where: group ? { group } : undefined,
    orderBy: { key: "asc" }
  });
  return rows.filter((s) => !HIDDEN_SETTING_KEYS.has(s.key));
}

export async function updatePlatformSetting(key: string, value: string, actorName: string) {
  const setting = await prisma.platformSetting.upsert({
    where: { key },
    create: { group: "config", key, value, description: "" },
    update: { value }
  });

  const SENSITIVE_KEY_PATTERNS = ["secret", "key", "token", "password", "credential", "api_key", "hmac"];
  const isSensitive = SENSITIVE_KEY_PATTERNS.some((p) => key.toLowerCase().includes(p));
  await writeAuditLog({
    action: "config.setting_updated",
    summary: `Paramètre ${key} mis à jour.`,
    entityType: "config",
    entityId: setting.id,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify({ key, value: isSensitive ? "[REDACTED]" : value }),
    relatedLinks: []
  });

  return setting;
}

export async function listSalonCategories() {
  return prisma.platformSalonCategory.findMany({
    orderBy: { name: "asc" }
  });
}

export async function upsertSalonCategory(data: { name: string; slug: string; enabled?: boolean }, actorName: string) {
  const category = await prisma.platformSalonCategory.upsert({
    where: { slug: data.slug },
    update: { name: data.name, enabled: data.enabled ?? true },
    create: { name: data.name, slug: data.slug, enabled: data.enabled ?? true }
  });

  await writeAuditLog({
    action: "config.category_upserted",
    summary: `Catégorie ${data.name} enregistrée.`,
    entityType: "config",
    entityId: category.id,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify(data),
    relatedLinks: []
  });

  return category;
}

export async function deleteSalonCategory(id: string, actorName: string) {
  const category = await prisma.platformSalonCategory.delete({ where: { id } });
  
  await writeAuditLog({
    action: "config.category_deleted",
    summary: `Catégorie ${category.name} supprimée.`,
    entityType: "config",
    entityId: category.id,
    actorName,
    severity: "warning",
    payloadJson: JSON.stringify(category),
    relatedLinks: []
  });

  return category;
}

export async function listRequiredDocuments() {
  return prisma.platformRequiredDocument.findMany({
    orderBy: { label: "asc" }
  });
}

export async function upsertRequiredDocument(data: { label: string; slug: string; type: string; isRequired: boolean; enabled?: boolean }, actorName: string) {
  const doc = await prisma.platformRequiredDocument.upsert({
    where: { slug: data.slug },
    update: { label: data.label, type: data.type, isRequired: data.isRequired, enabled: data.enabled ?? true },
    create: { label: data.label, slug: data.slug, type: data.type, isRequired: data.isRequired, enabled: data.enabled ?? true }
  });

  await writeAuditLog({
    action: "config.document_upserted",
    summary: `Document requis ${data.label} enregistré.`,
    entityType: "config",
    entityId: doc.id,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify(data),
    relatedLinks: []
  });

  return doc;
}

export async function deleteRequiredDocument(id: string, actorName: string) {
  const doc = await prisma.platformRequiredDocument.delete({ where: { id } });

  await writeAuditLog({
    action: "config.document_deleted",
    summary: `Document requis ${doc.label} supprimé.`,
    entityType: "config",
    entityId: doc.id,
    actorName,
    severity: "warning",
    payloadJson: JSON.stringify(doc),
    relatedLinks: []
  });

  return doc;
}

export async function listServiceSuggestions() {
  return prisma.platformServiceSuggestion.findMany({
    orderBy: { name: "asc" }
  });
}

export async function listServiceSuggestionsPublic() {
  return prisma.platformServiceSuggestion.findMany({
    where: { enabled: true },
    orderBy: { name: "asc" }
  });
}

export async function upsertServiceSuggestion(data: { name: string; category: string; enabled?: boolean }, actorName: string) {
  const suggestion = await prisma.platformServiceSuggestion.upsert({
    where: { name: data.name },
    update: { category: data.category, enabled: data.enabled ?? true },
    create: { name: data.name, category: data.category, enabled: data.enabled ?? true }
  });

  await writeAuditLog({
    action: "config.service_suggestion_upserted",
    summary: `Prestation standard ${data.name} enregistrée.`,
    entityType: "config",
    entityId: suggestion.id,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify(data),
    relatedLinks: []
  });

  return suggestion;
}

export async function deleteServiceSuggestion(id: string, actorName: string) {
  const suggestion = await prisma.platformServiceSuggestion.delete({ where: { id } });

  await writeAuditLog({
    action: "config.service_suggestion_deleted",
    summary: `Prestation standard ${suggestion.name} supprimée.`,
    entityType: "config",
    entityId: suggestion.id,
    actorName,
    severity: "warning",
    payloadJson: JSON.stringify(suggestion),
    relatedLinks: []
  });

  return suggestion;
}

export async function sendMagicLink(salonId: string, actorName: string): Promise<void> {
  const salon = await prisma.salon.findUnique({
    where: { id: salonId },
    include: { staffMembers: { where: { role: "salon_owner" }, take: 1 } }
  });
  if (!salon) throw new Error("salon_not_found");

  const owner = salon.staffMembers[0];
  if (!owner) throw new Error("owner_not_found");
  const ownerEmail = owner.email ?? "";
  const ownerName = owner.fullName ?? "Gérant";

  const rawToken = randomBytes(32).toString("hex");
  const tokenHash = createHash("sha256").update(rawToken).digest("hex");
  const expiresAt = Date.now() + 24 * 60 * 60 * 1000; // 24h

  await prisma.platformSetting.upsert({
    where: { key: `auth:magic:${owner.id}` },
    create: {
      group: "security",
      key: `auth:magic:${owner.id}`,
      value: JSON.stringify({ tokenHash, expiresAt }),
      description: "Magic login token (single-use)"
    },
    update: { value: JSON.stringify({ tokenHash, expiresAt }) }
  });

  const magicLink = `${config.webOrigin}/pro/magic-login?token=${rawToken}&email=${encodeURIComponent(ownerEmail)}`;

  const { buildEmailHtml } = await import("../../lib/email-html.js");
  await sendEmail({
    to: ownerEmail,
    subject: "Beauté Avenue — Lien de connexion rapide",
    text: `Bonjour ${ownerName},\n\nUn administrateur vous a envoyé un lien de connexion rapide pour votre salon.\n\nCliquez sur le lien ci-dessous pour vous connecter automatiquement (valable 24h) :\n${magicLink}\n\nSi vous n'êtes pas à l'origine de cette demande, ignorez cet email.\n\n— L'équipe Beauté Avenue`,
    html: buildEmailHtml({
      preheader: "Connexion rapide à votre espace pro",
      greeting: `Bonjour ${ownerName},`,
      bodyLines: [
        `Un administrateur vous a envoyé un lien de connexion rapide pour votre salon <strong>${salon.name}</strong>.`,
        `Cliquez sur le bouton ci-dessous pour vous connecter automatiquement.`
      ],
      cta: { url: magicLink, label: "Me connecter" },
      expiryNote: "Ce lien expire dans 24 heures.",
      usageNote: "Il ne peut être utilisé qu'une seule fois."
    })
  });

  await writeAuditLog({
    action: "user.magic_link_sent",
    summary: `Lien magique envoyé à ${ownerEmail} (${salon.name}).`,
    entityType: "salon",
    entityId: salonId,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify({ ownerEmail, salonId }),
    relatedLinks: [{ label: salon.name, href: `/admin/salons/${salonId}` }]
  });
}

export async function sendPasswordReset(salonId: string, actorName: string): Promise<void> {
  const salon = await prisma.salon.findUnique({
    where: { id: salonId },
    include: { staffMembers: { where: { role: "salon_owner" }, take: 1 } }
  });
  if (!salon) throw new Error("salon_not_found");

  const owner = salon.staffMembers[0];
  if (!owner) throw new Error("owner_not_found");
  const ownerEmail = owner.email ?? "";
  const ownerName = owner.fullName ?? "Gérant";

  const rawToken = randomBytes(32).toString("hex");
  const tokenHash = createHash("sha256").update(rawToken).digest("hex");
  const expiresAt = Date.now() + 72 * 60 * 60 * 1000;

  await prisma.platformSetting.upsert({
    where: { key: `auth:reset:${owner.id}` },
    create: {
      group: "security",
      key: `auth:reset:${owner.id}`,
      value: JSON.stringify({ tokenHash, expiresAt }),
      description: "Password reset token (single-use)"
    },
    update: { value: JSON.stringify({ tokenHash, expiresAt }) }
  });

  const resetLink = `${config.webOrigin}/pro/reset-password?token=${rawToken}&email=${encodeURIComponent(ownerEmail)}`;

  const { buildEmailHtml } = await import("../../lib/email-html.js");
  await sendEmail({
    to: ownerEmail,
    subject: "Beauté Avenue — Réinitialisation de votre mot de passe",
    text: `Bonjour ${ownerName},\n\nVotre administrateur a initié une réinitialisation de votre mot de passe.\n\nCliquez sur le lien ci-dessous pour définir un nouveau mot de passe (valable 72h) :\n${resetLink}\n\n— L'équipe Beauté Avenue`,
    html: buildEmailHtml({
      preheader: "Réinitialisation de votre mot de passe",
      greeting: `Bonjour ${ownerName},`,
      bodyLines: [
        `Un administrateur a initié une réinitialisation de votre mot de passe pour <strong>${salon.name}</strong>.`,
        `Cliquez sur le bouton ci-dessous pour définir un nouveau mot de passe.`
      ],
      cta: { url: resetLink, label: "Réinitialiser mon mot de passe" },
      expiryNote: "Ce lien expire dans 72 heures.",
      usageNote: "Il ne peut être utilisé qu'une seule fois."
    })
  });

  await writeAuditLog({
    action: "user.password_reset_sent",
    summary: `Lien de réinitialisation envoyé à ${ownerEmail} (${salon.name}).`,
    entityType: "salon",
    entityId: salonId,
    actorName,
    severity: "info",
    payloadJson: JSON.stringify({ ownerEmail, salonId }),
    relatedLinks: [{ label: salon.name, href: `/admin/salons/${salonId}` }]
  });
}
