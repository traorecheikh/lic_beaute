import type { FastifyReply, FastifyRequest } from "fastify";
import type { Prisma } from "../../generated/prisma/client.js";

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
  proSubscriptionUpdateInputSchema
} from "@beauteavenue/contracts";

import { getPaymentAdapter } from "../../adapters/index.js";
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
  intechApiKey: config.intechApiKey,
  intechBaseUrl: config.intechBaseUrl,
  intechCallbackHmacEnabled: config.intechCallbackHmacEnabled,
  intechHmacSecretKey: config.intechHmacSecretKey,
  intechHmacMaxAgeMs: config.intechHmacMaxAgeMs,
  intechRequestTimeoutMs: config.intechRequestTimeoutMs,
  baseOrigin: config.webOrigin
});

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

function parseBooleanSetting(value: string | undefined, fallback: boolean) {
  if (!value) return fallback;
  const normalized = value.trim().toLowerCase();
  if (normalized === "true" || normalized === "1" || normalized === "yes") return true;
  if (normalized === "false" || normalized === "0" || normalized === "no") return false;
  return fallback;
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

function buildInvoicePdfBuffer(input: {
  invoiceNumber: string;
  issuedAt: string;
  status: string;
  amountLabel: string;
  billingProvider: string;
  salonName: string;
}) {
  const rows = [
    { label: "Abonnement mensuel", amount: input.amountLabel }
  ];
  const lineItems = rows
    .map((row, index) => ({
      y: 642 - index * 26,
      ...row
    }))
    .map((row) => [
      "BT",
      `/F1 11 Tf`,
      `56 ${row.y} Td`,
      `(${escapePdfText(row.label)}) Tj`,
      "ET",
      "BT",
      `/F1 11 Tf`,
      `485 ${row.y} Td`,
      `(${escapePdfText(row.amount)} FCFA) Tj`,
      "ET"
    ].join("\n"))
    .join("\n");

  const content = [
    // Header background bar
    "0.95 0.93 0.89 rg",
    "40 770 515 48 re",
    "f",
    // Brand
    "BT",
    "/F2 20 Tf",
    "52 795 Td",
    "(Beaut\\351 Avenue) Tj",
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 781 Td",
    "(Facture d\\'abonnement) Tj",
    "ET",
    // Invoice metadata
    "BT",
    "/F1 10 Tf",
    "370 796 Td",
    `(${escapePdfText(`N° ${input.invoiceNumber}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "370 782 Td",
    `(${escapePdfText(`Date ${input.issuedAt}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "370 768 Td",
    `(${escapePdfText(`Statut ${input.status}`)}) Tj`,
    "ET",
    // Billing section label
    "BT",
    "/F2 12 Tf",
    "52 736 Td",
    "(D\\351tails de facturation) Tj",
    "ET",
    // Detail text
    "BT",
    "/F1 10 Tf",
    "52 720 Td",
    `(${escapePdfText(`Salon: ${input.salonName}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 706 Td",
    `(${escapePdfText(`Mode de r\\350glement: ${input.billingProvider}`)}) Tj`,
    "ET",
    // Table header
    "0.93 0.92 0.90 rg",
    "40 668 515 26 re",
    "f",
    "BT",
    "/F2 10 Tf",
    "56 676 Td",
    "(Libell\\351) Tj",
    "ET",
    "BT",
    "/F2 10 Tf",
    "485 676 Td",
    "(Montant) Tj",
    "ET",
    // Row grid lines
    "0.82 0.80 0.76 RG",
    "1 w",
    "40 668 m 555 668 l S",
    "40 638 m 555 638 l S",
    "40 612 m 555 612 l S",
    // Line items
    lineItems,
    // Total
    "BT",
    "/F2 12 Tf",
    "56 586 Td",
    "(Total TTC) Tj",
    "ET",
    "BT",
    "/F2 12 Tf",
    `450 586 Td`,
    `(${escapePdfText(`${input.amountLabel} FCFA`)}) Tj`,
    "ET",
    // Footer
    "BT",
    "/F1 9 Tf",
    "52 100 Td",
    "(Merci pour votre confiance.) Tj",
    "ET",
    "BT",
    "/F1 9 Tf",
    "52 86 Td",
    "(support@beauteavenue.com  |  +221 33 800 12 34) Tj",
    "ET"
  ].join("\n");

  const objects = [
    "1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n",
    "2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n",
    "3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R /F2 5 0 R >> >> /Contents 6 0 R >> endobj\n",
    "4 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj\n",
    "5 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >> endobj\n",
    `6 0 obj << /Length ${Buffer.byteLength(content, "utf8")} >> stream\n${content}\nendstream\nendobj\n`
  ];

  let pdf = "%PDF-1.4\n";
  const offsets = [0];
  for (const object of objects) {
    offsets.push(Buffer.byteLength(pdf, "utf8"));
    pdf += object;
  }

  const xrefStart = Buffer.byteLength(pdf, "utf8");
  const xref = [
    `xref\n0 ${objects.length + 1}`,
    "0000000000 65535 f ",
    ...offsets.slice(1).map((offset) => `${String(offset).padStart(10, "0")} 00000 n `)
  ].join("\n");

  const trailer = [
    "trailer",
    `<< /Size ${objects.length + 1} /Root 1 0 R >>`,
    "startxref",
    String(xrefStart),
    "%%EOF"
  ].join("\n");

  return Buffer.from(`${pdf}${xref}\n${trailer}\n`, "utf8");
}

async function ensurePro(request: FastifyRequest) {
  const { sub, role } = requireRole(request, ["salon_owner", "salon_staff"]);
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

export class ProController {
  // ─── Dashboard ─────────────────────────────────────────────────────────────

  async dashboard(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      const { value, cacheStatus } = await getOrSetCachedJson({
        key: `kpi:pro:dashboard:${salonId}:${role}`,
        ttlSeconds: config.cacheTtlKpiSeconds,
        tags: ["kpi:pro"],
        load: () => getProDashboard(salonId, role)
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
      const body = proSalonUpdateInputSchema.parse(request.body);
      const { gallery, phone, instagram, teamDisplay, ...salonPayload } = body;

      if (gallery !== undefined) {
        const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true } });
        if (salon?.subscriptionTier === "standard" && gallery.length > 3) {
          fail(reply, 422, "gallery_limit", "Les salons Standard sont limités à 3 photos de galerie.");
          return;
        }
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
      const body = proServiceCreateInputSchema.parse(request.body);
      if (body.depositMode !== "none") {
        const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true } });
        if (salon?.subscriptionTier !== "premium") {
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
      const params = request.params as { serviceId: string };
      const body = proServiceUpdateInputSchema.parse(request.body);
      const existing = await prisma.service.findFirst({ where: { id: params.serviceId, salonId } });
      if (!existing) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }
      if (body.depositMode !== undefined && body.depositMode !== "none") {
        const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true } });
        if (salon?.subscriptionTier !== "premium") {
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
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const staff = await prisma.employee.findMany({
        where: { salonId },
        include: { specialties: { select: { serviceId: true } } }
      });
      ok(reply, staff.map((e) => ({
        id: e.id,
        userId: e.userId,
        displayName: e.displayName,
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
      if (!ownerOnly(role, reply)) return;
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
        const existing = await tx.user.findUnique({ where: { phone: body.phone } });
        if (existing && existing.salonId && existing.salonId !== salonId) {
          throw new HttpAuthError(409, "user_in_other_salon", "Cet utilisateur appartient à un autre salon.");
        }
        if (existing && existing.role === "salon_owner") {
          throw new HttpAuthError(422, "cannot_staff_owner", "Impossible d'ajouter un propriétaire de salon comme employé.");
        }

        const user = existing
          ? await tx.user.update({
              where: { id: existing.id },
              data: { fullName: body.fullName, role: "salon_staff", salonId }
            })
          : await tx.user.create({
              data: { fullName: body.fullName, phone: body.phone, role: "salon_staff", salonId }
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

        return { employee, serviceIds: body.serviceIds };
      });

      ok(reply, {
        id: result.employee.id,
        userId: result.employee.userId,
        displayName: result.employee.displayName,
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
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { employeeId: string };
      const body = proStaffUpdateInputSchema.parse(request.body);
      const existing = await prisma.employee.findFirst({ where: { id: params.employeeId, salonId } });
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
      const params = request.params as { employeeId: string };
      const existing = await prisma.employee.findFirst({ where: { id: params.employeeId, salonId } });
      if (!existing) { fail(reply, 404, "employee_not_found", "Employé introuvable."); return; }
      await prisma.employee.update({ where: { id: params.employeeId }, data: { isActive: false } });
      ok(reply, { deleted: true });
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
      const { salonId } = await ensurePro(request);
      const q = request.query as { status?: string; date?: string; page?: string; pageSize?: string };
      const page = Math.max(0, parseInt(q.page ?? "0", 10));
      const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

      const where: Record<string, unknown> = { salonId };
      if (q.status) where.status = q.status;
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
      const params = request.params as { bookingId: string };
      const booking = await prisma.booking.findFirst({ where: { id: params.bookingId, salonId } });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      if (!allowedFrom.includes(booking.status)) {
        fail(reply, 422, "invalid_status", `Transition invalide depuis ${booking.status}.`); return;
      }

      await prisma.$transaction(async (tx) => {
        await tx.booking.update({ where: { id: booking.id }, data: { status: toStatus as never } });
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
    await this.transitionBooking(request, reply, ["pending"], "confirmed", "accepted");
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
            depositAmountXof: 0,
            clientNote: body.clientName && !body.clientId ? `Nouveau client: ${body.clientName}` : null
          }
        });
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
      const params = request.params as { bookingId: string };
      const body = proCheckoutCompleteInputSchema.parse(request.body);

      const booking = await prisma.booking.findFirst({ where: { id: params.bookingId, salonId } });
      if (!booking) {
        fail(reply, 404, "booking_not_found", "Réservation introuvable.");
        return;
      }
      if (!["confirmed", "in_progress"].includes(booking.status)) {
        fail(reply, 422, "invalid_status", "Seules les réservations confirmées ou en cours peuvent être encaissées.");
        return;
      }

      const subtotalXof = body.lineItems.reduce((sum, item) => sum + item.amountXof, 0);
      const chargedXof = Math.max(0, subtotalXof - body.discountXof);

      await prisma.$transaction(async (tx) => {
        const claimed = await tx.booking.updateMany({
          where: { id: booking.id, status: { in: ["confirmed", "in_progress"] } },
          data: { status: "completed" }
        });
        if (claimed.count === 0) throw Object.assign(new Error("already_completed"), { _http: [409, "already_completed", "Cette réservation a déjà été encaissée."] });
        await tx.bookingEvent.create({
          data: {
            bookingId: booking.id,
            actorUserId: userId,
            eventType: "checkout_completed",
            fromStatus: booking.status,
            toStatus: "completed",
            payloadJson: JSON.stringify({
              paymentMethod: body.paymentMethod,
              lineItems: body.lineItems,
              discountXof: body.discountXof
            })
          }
        });
        await enqueueJob({
          type: "deposit_settlement",
          payload: { bookingId: booking.id },
          dbClient: tx
        });
      });
      await invalidateCacheTags(["kpi:pro", "kpi:admin"]);

      ok(reply, {
        completed: true,
        bookingId: booking.id,
        status: "completed",
        chargedXof
      });
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
      const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { subscriptionTier: true } });
      if (salon?.subscriptionTier !== "premium") {
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

  // ─── Subscription ──────────────────────────────────────────────────────────

  async getSubscription(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const [sub, settings] = await Promise.all([
        prisma.subscription.findUnique({ where: { salonId } }),
        prisma.platformSetting.findMany({
          where: { key: { in: [salonBillingProviderKey(salonId), salonBillingAccountKey(salonId)] } },
          select: { key: true, value: true }
        })
      ]);
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
      const settingMap = toSettingMap(settings);
      const rawProvider = settingMap[salonBillingProviderKey(salonId)];
      const provider = toPublicBillingProvider(rawProvider ?? sub.billingProvider);
      const accountNumber = settingMap[salonBillingAccountKey(salonId)];
      const billingMethod = provider && accountNumber
        ? { provider, accountNumberMasked: maskAccountNumber(accountNumber) }
        : null;
      ok(reply, {
        id: sub.id,
        tier: sub.tier,
        status: sub.status,
        renewsAt: sub.renewedAt?.toISOString() ?? null,
        expiresAt: sub.expiresAt?.toISOString() ?? null,
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
                value: body.billingMethod.accountNumber.trim(),
                description: `Billing account number for salon ${salonId}`
              },
              update: { value: body.billingMethod.accountNumber.trim() }
            });
          }
        }
      });
      ok(reply, { updated: true });
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
      if (config.paymentDriver === "intech" && !owner?.phone) {
        fail(reply, 422, "phone_required", "Numéro de téléphone requis pour initier ce paiement.");
        return;
      }

      const priceRows = await prisma.platformSetting.findMany({
        where: { key: { in: ["subscription_premium_price_xof"] } }
      });
      const priceMap = Object.fromEntries(priceRows.map((r) => [r.key, r.value]));
      const amountXof = parseInt(priceMap["subscription_premium_price_xof"] ?? "25000", 10);
      const idempotencyKey = `sub-${sub.id}-${body.action}-${Date.now()}`;

      const charge = await prisma.subscriptionCharge.create({
        data: { subscriptionId: sub.id, provider: toDbProvider(body.provider) ?? "intech", amountXof, idempotencyKey, chargeType: body.action }
      });

      const result = await paymentAdapter.initiateDeposit({
        paymentId: charge.id,
        amountXof,
        description: `Abonnement ${body.action}`,
        callbackUrl: `${config.webOrigin}/pro/subscription/callback`,
        idempotencyKey,
        phone: owner?.phone ?? undefined
      });

      await prisma.subscriptionCharge.update({ where: { id: charge.id }, data: { providerTxId: result.providerRef } });

      ok(reply, { redirectUrl: result.redirectUrl, chargeId: charge.id });
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
      const pdf = buildInvoicePdfBuffer({
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
