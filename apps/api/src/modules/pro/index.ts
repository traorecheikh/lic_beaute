import argon2 from "argon2";
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
  proStaffUpdateInputSchema
} from "@beauteavenue/contracts";

import { sendEmail } from "../../lib/email.js";
import { config } from "../../config.js";
import { HttpAuthError } from "../../lib/auth/index.js";
import { getOrSetCachedJson, invalidateCacheTags } from "../../lib/cache.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { enqueueJob } from "../../lib/jobs.js";
import { logger } from "../../lib/logger.js";
import { prisma } from "../../lib/db/prisma.js";
import { getDepositMinimumXof } from "../../lib/platform-settings.js";
import { getProAnalytics, getProDashboard } from "./data.js";

import {
  ensurePro,
  ownerOnly,
  managerOrOwner,
  ensureProWriteAccess,
  getFeatureFlags,
  isTeamPhotoRequiredForSalon,
  parseBooleanSetting,
  toSettingMap,
  salonPublicPhoneKey,
  salonInstagramKey,
  salonTeamShowPhotosKey,
  salonTeamShowDescriptionsKey
} from "./shared.js";

import {
  listBookings,
  getBooking,
  acceptBooking,
  rejectBooking,
  startBooking,
  completeBooking,
  createManualBooking,
  markClientNoShow,
  markSalonNoShow
} from "./bookings.js";

import {
  getSubscriptionFeatures,
  getSubscription,
  updateSubscription,
  getChargeStatus,
  subscriptionCheckout,
  executeSubscriptionPayment,
  cancelDowngrade,
  cancelSubscription,
  retainSubscription,
  listPayouts,
  listInvoices,
  downloadInvoicePdf
} from "./subscription.js";

import {
  getPayoutSettings,
  updatePayoutSettings,
  listMerchantPayouts
} from "./payouts.js";

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
      if (body.depositMode === "fixed") {
        if (!body.depositAmountXof) {
          fail(reply, 422, "invalid_deposit", "depositAmountXof requis pour depositMode=fixed."); return;
        }
        if (body.depositAmountXof > body.priceXof / 2) {
          fail(reply, 422, "deposit_exceeds_limit", "L'acompte ne peut pas dépasser 50% du prix de la prestation."); return;
        }
        const depositMinimumXof = await getDepositMinimumXof();
        if (body.depositAmountXof < depositMinimumXof) {
          fail(reply, 422, "deposit_below_platform_minimum", `L'acompte doit être au minimum de ${depositMinimumXof} XOF.`); return;
        }
      }
      if (body.depositMode === "percent") {
        if (!body.depositPercent) {
          fail(reply, 422, "invalid_deposit", "depositPercent requis pour depositMode=percent."); return;
        }
        const computedDepositXof = Math.round((body.depositPercent / 100) * body.priceXof);
        const depositMinimumXof = await getDepositMinimumXof();
        if (computedDepositXof < depositMinimumXof) {
          fail(reply, 422, "deposit_below_platform_minimum", `L'acompte calculé doit être au minimum de ${depositMinimumXof} XOF.`); return;
        }
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
      if (effectiveMode === "fixed") {
        if (!effectiveAmount) {
          fail(reply, 422, "invalid_deposit", "depositAmountXof requis pour depositMode=fixed."); return;
        }
        const price = body.priceXof ?? existing.priceXof;
        if (effectiveAmount > price / 2) {
          fail(reply, 422, "deposit_exceeds_limit", "L'acompte ne peut pas dépasser 50% du prix de la prestation."); return;
        }
        const depositMinimumXof = await getDepositMinimumXof();
        if (effectiveAmount < depositMinimumXof) {
          fail(reply, 422, "deposit_below_platform_minimum", `L'acompte doit être au minimum de ${depositMinimumXof} XOF.`); return;
        }
      }
      if (effectiveMode === "percent") {
        if (!effectivePercent) {
          fail(reply, 422, "invalid_deposit", "depositPercent requis pour depositMode=percent."); return;
        }
        const price = body.priceXof ?? existing.priceXof;
        const computedDepositXof = Math.round((effectivePercent / 100) * price);
        const depositMinimumXof = await getDepositMinimumXof();
        if (computedDepositXof < depositMinimumXof) {
          fail(reply, 422, "deposit_below_platform_minimum", `L'acompte calculé doit être au minimum de ${depositMinimumXof} XOF.`); return;
        }
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
                role: body.role as import("../../generated/prisma/enums.js").Role,
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
                role: body.role as import("../../generated/prisma/enums.js").Role,
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
          const crypto = await import("node:crypto");
          const { buildEmailHtml, escapeHtml } = await import("../../lib/email-html.js");
          const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { name: true } });
          const rawToken = crypto.randomBytes(32).toString("hex");
          const tokenHash = crypto.createHash("sha256").update(rawToken).digest("hex");
          const expiresAt = Date.now() + 24 * 60 * 60 * 1000;
          await prisma.platformSetting.create({
            data: { group: "security", key: `invite:${result.user.id}`, value: JSON.stringify({ tokenHash, expiresAt }), description: `Staff invite token for ${result.user.id}` }
          });
          const loginUrl = `${config.webOrigin}/pro/login?inviteToken=${rawToken}&userId=${encodeURIComponent(result.user.id)}`;
          const staffName = result.user.fullName ?? "collaborateur";
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
              `Ce lien ne peut être utilisé qu'une seule fois.`,
              ``,
              `Si vous ne connaissez pas ce salon, ignorez ce message.`
            ].join("\n"),
            html: buildEmailHtml({
              greeting: `Bonjour ${staffName},`,
              bodyLines: [
                `<strong>${escapeHtml(salonName)}</strong> vous invite à rejoindre votre espace professionnel <strong>Beauté Avenue</strong>.`,
              ],
              cta: { url: loginUrl, label: "Accéder à mon espace" },
              expiryNote: "Ce lien expire dans 24 heures.",
              usageNote: "Il ne peut être utilisé qu'une seule fois."
            })
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
              role: body.role as import("../../generated/prisma/enums.js").Role | undefined
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

      const crypto = await import("node:crypto");
      const { buildEmailHtml, escapeHtml } = await import("../../lib/email-html.js");
      const rawToken = crypto.randomBytes(32).toString("hex");
      const tokenHash = crypto.createHash("sha256").update(rawToken).digest("hex");
      const expiresAt = Date.now() + 24 * 60 * 60 * 1000;
      await prisma.platformSetting.upsert({
        where: { key: `invite:${employee.userId}` },
        create: { group: "security", key: `invite:${employee.userId}`, value: JSON.stringify({ tokenHash, expiresAt }), description: `Staff invite token for ${employee.userId}` },
        update: { value: JSON.stringify({ tokenHash, expiresAt }) }
      });

      const loginUrl = `${config.webOrigin}/pro/login?inviteToken=${rawToken}&userId=${encodeURIComponent(employee.userId)}`;
      const staffName = employee.user.fullName ?? "collaborateur";
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
          `Ce lien ne peut être utilisé qu'une seule fois.`,
          ``,
          `Si vous ne connaissez pas ce salon, ignorez ce message.`
        ].join("\n"),
        html: buildEmailHtml({
          greeting: `Bonjour ${staffName},`,
          bodyLines: [
            `<strong>${escapeHtml(salonName)}</strong> vous invite à rejoindre votre espace professionnel <strong>Beauté Avenue</strong>.`,
          ],
          cta: { url: loginUrl, label: "Accéder à mon espace" },
          expiryNote: "Ce lien expire dans 24 heures.",
          usageNote: "Il ne peut être utilisé qu'une seule fois."
        })
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

  // ═══ Bookings (delegated to ./bookings.ts) ═════════════════════════════

  listBookings = listBookings;
  getBooking = getBooking;
  acceptBooking = acceptBooking;
  rejectBooking = rejectBooking;
  startBooking = startBooking;
  completeBooking = completeBooking;
  createManualBooking = createManualBooking;
  markClientNoShow = markClientNoShow;
  markSalonNoShow = markSalonNoShow;

  // ─── Clients ───────────────────────────────────────────────────────────────

  async listClients(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const query = request.query as { search?: string; page?: string; pageSize?: string };
      const search = query.search?.trim();
      const page = Math.max(0, parseInt(query.page ?? "0", 10));
      const pageSize = Math.min(100, Math.max(1, parseInt(query.pageSize ?? "20", 10)));

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

      const [total, clients] = await Promise.all([
        prisma.user.count({ where: userWhere }),
        prisma.user.findMany({
          where: userWhere,
          select: {
            id: true,
            fullName: true,
            phone: true,
            email: true
          },
          skip: page * pageSize,
          take: pageSize,
          orderBy: { createdAt: "desc" }
        })
      ]);

      const clientIds = clients.map((c) => c.id);
      const stats = clientIds.length > 0
        ? await prisma.booking.groupBy({
            by: ["clientId"],
            where: { salonId, clientId: { in: clientIds }, status: { in: ["completed", "confirmed", "in_progress"] } },
            _count: { id: true },
            _max: { startsAt: true }
          })
        : [];

      const statsMap = new Map(stats.map((s) => [s.clientId, s]));
      const paymentsByClient = new Map<string, number>();
      if (clientIds.length > 0) {
        const payRows = await prisma.$queryRaw<{ clientId: string; total: bigint }[]>`
          SELECT b."clientId", COALESCE(SUM(p."amountXof"), 0) as total
          FROM "Booking" b
          LEFT JOIN "Payment" p ON p."bookingId" = b.id AND p.status = 'succeeded'
          WHERE b."salonId" = ${salonId} AND b."clientId" = ANY(${clientIds})
          GROUP BY b."clientId"
        `;
        for (const row of payRows) {
          paymentsByClient.set(row.clientId, Number(row.total));
        }
      }

      const formattedClients = clients.map((client) => {
        const s = statsMap.get(client.id);
        return {
          id: client.id,
          fullName: client.fullName,
          phone: client.phone,
          email: client.email,
          visitCount: s?._count.id ?? 0,
          totalSpentXof: paymentsByClient.get(client.id) ?? 0,
          lastVisitAt: s?._max.startsAt?.toISOString() ?? null
        };
      });

      ok(reply, { items: formattedClients, total, page, pageSize });
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
      const q = request.query as { page?: string; pageSize?: string };
      const page = Math.max(0, parseInt(q.page ?? "0", 10));
      const pageSize = Math.min(100, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

      const [total, reviews] = await Promise.all([
        prisma.review.count({ where: { salonId } }),
        prisma.review.findMany({
          where: { salonId },
          orderBy: { createdAt: "desc" },
          select: { id: true, rating: true, comment: true, createdAt: true, responseText: true, updatedAt: true, clientId: true },
          skip: page * pageSize,
          take: pageSize
        })
      ]);

      ok(reply, {
        items: reviews.map((r) => ({
          id: r.id,
          rating: r.rating,
          comment: r.comment,
          createdAt: r.createdAt.toISOString(),
          responseText: r.responseText,
          responseAt: r.responseText ? r.updatedAt.toISOString() : null,
          clientId: r.clientId
        })),
        total,
        page,
        pageSize
      });
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

  // ═══ Subscription (delegated to ./subscription.ts) ══════════════════════

  getSubscriptionFeatures = getSubscriptionFeatures;
  getSubscription = getSubscription;
  updateSubscription = updateSubscription;
  getChargeStatus = getChargeStatus;
  subscriptionCheckout = subscriptionCheckout;
  executeSubscriptionPayment = executeSubscriptionPayment;
  cancelDowngrade = cancelDowngrade;
  cancelSubscription = cancelSubscription;
  retainSubscription = retainSubscription;
  listPayouts = listPayouts;
  listInvoices = listInvoices;
  downloadInvoicePdf = downloadInvoicePdf;

  getPayoutSettings = getPayoutSettings;
  updatePayoutSettings = updatePayoutSettings;
  listMerchantPayouts = listMerchantPayouts;
}
