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
import { fail, ok } from "../../lib/http.js";
import { prisma } from "../../lib/db/prisma.js";
import {
  approveSalon,
  deleteSalonCategory,
  deleteRequiredDocument,
  getAdminDashboard,
  getAuditDetail,
  getPendingSalonDetail,
  getPlatformSettings,
  getSubscriptionDetail,
  listAuditEvents,
  listPendingSalons,
  listSalons,
  listRequiredDocuments,
  listSalonCategories,
  listSubscriptions,
  overrideSubscription,
  rejectSalon,
  requestSalonInfo,
  updatePlatformSetting,
  upsertRequiredDocument,
  upsertSalonCategory,
  createSalon
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
    ok(reply, await getAdminDashboard());
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
    ok(reply, salon);
  }

  async createSalon(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const body = adminSalonCreateInputSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    ok(reply, await createSalon(body, actorName));
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
    ok(reply, subscription);
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
    const { value } = updatePlatformSettingInputSchema.parse(request.body);
    const actorName = await this.resolveActorName(token.sub);
    ok(reply, await updatePlatformSetting(key, value, actorName));
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
}
