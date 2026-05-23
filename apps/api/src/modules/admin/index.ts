import {
  adminAuditFiltersSchema,
  adminSalonDecisionSchema,
  adminSalonQueueFiltersSchema,
  adminSubscriptionOverrideSchema,
  updatePlatformSettingInputSchema,
  upsertSalonCategoryInputSchema,
  upsertRequiredDocumentInputSchema,
  adminSalonCreateInputSchema
} from "@beauteavenue/contracts";
import type { FastifyReply, FastifyRequest } from "fastify";
import { z } from "zod";

import { requireRole, HttpAuthError } from "../../lib/auth/index.js";
import { getOrSetCachedJson, invalidateCacheTags } from "../../lib/cache.js";
import { config } from "../../config.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { prisma } from "../../lib/db/prisma.js";
import {
  approveSalon,
  deleteSalonCategory,
  deleteRequiredDocument,
  getAdminDashboard,
  getAuditDetail,
  listEmailAuditEvents,
  getPendingSalonDetail,
  getPlatformSettings,
  getSubscriptionDetail,
  listAuditEvents,
  listPendingSalons,
  listSalons,
  listRequiredDocuments,
  listSalonCategories,
  listSubscriptions,
  manualExtendSubscription,
  overrideSubscription,
  rejectSalon,
  requestSalonInfo,
  updatePlatformSetting,
  upsertRequiredDocument,
  upsertSalonCategory,
  createSalon,
  sendPasswordReset,
  sendMagicLink
} from "./data.js";

export class AdminController {
  private ensureAdmin(request: FastifyRequest, reply: FastifyReply) {
    try {
      return requireRole(request, ["platform_admin"]);
    } catch (error) {
      if (error instanceof HttpAuthError) {
        fail(reply, error.statusCode, error.code, error.message);
        return null;
      }
      fail(reply, 401, "invalid_token", "Session invalide.");
      return null;
    }
  }

  private async resolveActorName(userId: string): Promise<string> {
    const user = await prisma.user.findUnique({ where: { id: userId }, select: { fullName: true } });
    return user?.fullName ?? "Platform Admin";
  }

  async dashboard(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const { value, cacheStatus } = await getOrSetCachedJson({
      key: "kpi:admin:dashboard",
      ttlSeconds: config.cacheTtlKpiSeconds,
      tags: ["kpi:admin"],
      load: () => getAdminDashboard()
    });
    reply.header("x-cache", cacheStatus);
    ok(reply, value);
  }

  async listPendingSalons(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const filters = adminSalonQueueFiltersSchema.parse(request.query);
    ok(reply, await listPendingSalons(filters));
  }

  async listSalons(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const filters = z.object({ search: z.string().optional(), status: z.string().optional() }).parse(request.query);
    ok(reply, await listSalons(filters));
  }

  async salonDetail(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const params = request.params as { salonId: string };
    const salon = await getPendingSalonDetail(params.salonId);
    if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
    ok(reply, salon);
  }

  async approveSalon(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const params = request.params as { salonId: string };
    const actorName = await this.resolveActorName(token.sub);
    const salon = await approveSalon(params.salonId, actorName);
    if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
    await invalidateCacheTags(["kpi:admin", "kpi:pro", "catalog:list", `catalog:salon:${params.salonId}`]);
    ok(reply, salon);
  }

  async rejectSalon(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const params = request.params as { salonId: string };
    const body = adminSalonDecisionSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    const salon = await rejectSalon(params.salonId, body, actorName);
    if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
    await invalidateCacheTags(["kpi:admin", "kpi:pro", "catalog:list", `catalog:salon:${params.salonId}`]);
    ok(reply, salon);
  }

  async requestSalonInfo(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const params = request.params as { salonId: string };
    const body = adminSalonDecisionSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    const salon = await requestSalonInfo(params.salonId, body, actorName);
    if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
    await invalidateCacheTags(["kpi:admin", "kpi:pro"]);
    ok(reply, salon);
  }

  async createSalon(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    try {
      const body = adminSalonCreateInputSchema.parse(request.body);
      const actorName = await this.resolveActorName(token.sub);
      const created = await createSalon(body, actorName);
      await invalidateCacheTags(["kpi:admin"]);
      ok(reply, created);
    } catch (error) {
      handleError(error, reply);
    }
  }

  async listSubscriptions(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const query = z.object({
      search: z.string().optional(),
      tier: z.enum(["standard", "premium"]).optional(),
      status: z.enum(["inactive", "active", "past_due", "cancelled", "expired", "paused"]).optional()
    }).parse(request.query);
    ok(reply, await listSubscriptions(query));
  }

  async subscriptionDetail(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const params = request.params as { subscriptionId: string };
    const subscription = await getSubscriptionDetail(params.subscriptionId);
    if (!subscription) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    ok(reply, subscription);
  }

  async overrideSubscription(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const params = request.params as { subscriptionId: string };
    const body = adminSubscriptionOverrideSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    const subscription = await overrideSubscription(params.subscriptionId, body, actorName);
    if (!subscription) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    await invalidateCacheTags(["kpi:admin", "kpi:pro"]);
    ok(reply, subscription);
  }

  async manualExtendSubscription(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const params = request.params as { subscriptionId: string };
    const body = (await import("@beauteavenue/contracts")).adminManualExtendInputSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    const result = await manualExtendSubscription(params.subscriptionId, body, actorName);
    if (!result) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
    await invalidateCacheTags(["kpi:admin", "kpi:pro"]);
    ok(reply, result);
  }

  async listAudit(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const filters = adminAuditFiltersSchema.parse(request.query);
    ok(reply, await listAuditEvents(filters));
  }

  async auditDetail(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const params = request.params as { auditId: string };
    const event = await getAuditDetail(params.auditId);
    if (!event) { fail(reply, 404, "audit_not_found", "Événement d'audit introuvable."); return; }
    ok(reply, event);
  }

  async listEmailAudit(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const filters = z.object({
      status: z.string().optional(),
      driver: z.string().optional(),
      to: z.string().optional()
    }).parse(request.query);
    ok(reply, await listEmailAuditEvents(filters));
  }

  // ── Configuration ────────────────────────────────────────────────────────

  async listSettings(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const { group } = z.object({ group: z.string().optional() }).parse(request.query);
    ok(reply, await getPlatformSettings(group));
  }

  async updateSetting(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const { key } = request.params as { key: string };
    const RESERVED_PREFIXES = ["otp:", "auth:", "security:"];
    if (RESERVED_PREFIXES.some((p) => key.startsWith(p))) {
      fail(reply, 403, "reserved_key", "Cette clé est réservée au système et ne peut pas être modifiée via l'API.");
      return;
    }
    const { value } = updatePlatformSettingInputSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    const updated = await updatePlatformSetting(key, value, actorName);
    await invalidateCacheTags(["kpi:admin", "kpi:pro", "catalog:pricing"]);
    ok(reply, updated);
  }

  async listCategories(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    ok(reply, await listSalonCategories());
  }

  async upsertCategory(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const data = upsertSalonCategoryInputSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    ok(reply, await upsertSalonCategory(data, actorName));
  }

  async deleteCategory(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const { id } = request.params as { id: string };
    const actorName = await this.resolveActorName(token.sub);
    ok(reply, await deleteSalonCategory(id, actorName));
  }

  async listDocuments(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    ok(reply, await listRequiredDocuments());
  }

  async listCategoriesPublic(_request: FastifyRequest, reply: FastifyReply) {
    ok(reply, await listSalonCategories());
  }

  async listDocumentsPublic(_request: FastifyRequest, reply: FastifyReply) {
    ok(reply, await listRequiredDocuments());
  }

  async upsertDocument(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const data = upsertRequiredDocumentInputSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    ok(reply, await upsertRequiredDocument(data, actorName));
  }

  async deleteDocument(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const { id } = request.params as { id: string };
    const actorName = await this.resolveActorName(token.sub);
    ok(reply, await deleteRequiredDocument(id, actorName));
  }

  async sendPasswordReset(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const { salonId } = request.params as { salonId: string };
    const actorName = await this.resolveActorName(token.sub);
    try {
      await sendPasswordReset(salonId, actorName);
      ok(reply, { sent: true });
    } catch (e) {
      const msg = e instanceof Error ? e.message : "internal_error";
      if (msg === "salon_not_found") { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      if (msg === "owner_not_found") { fail(reply, 422, "owner_not_found", "Aucun gérant trouvé pour ce salon."); return; }
      fail(reply, 500, "internal_error", "Erreur lors de l'envoi du lien.");
    }
  }

  async sendMagicLink(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const { salonId } = request.params as { salonId: string };
    const actorName = await this.resolveActorName(token.sub);
    try {
      await sendMagicLink(salonId, actorName);
      ok(reply, { sent: true });
    } catch (e) {
      const msg = e instanceof Error ? e.message : "internal_error";
      if (msg === "salon_not_found") { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      if (msg === "owner_not_found") { fail(reply, 422, "owner_not_found", "Aucun gérant trouvé pour ce salon."); return; }
      fail(reply, 500, "internal_error", "Erreur lors de l'envoi du lien magique.");
    }
  }
}
