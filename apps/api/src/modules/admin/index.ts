import {
  adminAuditFiltersSchema,
  adminSalonDecisionSchema,
  adminSalonQueueFiltersSchema,
  adminSubscriptionOverrideSchema,
  updatePlatformSettingInputSchema,
  upsertSalonCategoryInputSchema,
  upsertRequiredDocumentInputSchema,
  adminSalonCreateInputSchema,
  proServiceCreateInputSchema,
  proServiceUpdateInputSchema
} from "@beauteavenue/contracts";
import type { FastifyReply, FastifyRequest } from "fastify";
import { z } from "zod";

import { requireRole, HttpAuthError } from "../../lib/auth/index.js";
import { getOrSetCachedJson, invalidateCacheTags } from "../../lib/cache.js";
import { config } from "../../config.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { prisma } from "../../lib/db/prisma.js";
import { buildInvoicePdf } from "../../lib/pdf.js";
import {
  approveSalon,
  checkSalonUniqueness,
  createSalon,
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
  getCancellationStats,
  rejectSalon,
  requestSalonInfo,
  updatePlatformSetting,
  upsertRequiredDocument,
  upsertSalonCategory,
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
    const q = request.query as Record<string, string | undefined>;
    const filters = adminSalonQueueFiltersSchema.parse(q);
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(100, Math.max(1, parseInt(q.pageSize ?? "20", 10)));
    ok(reply, await listPendingSalons({ ...filters, page, pageSize }));
  }

  async listSalons(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const q = request.query as Record<string, string | undefined>;
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(100, Math.max(1, parseInt(q.pageSize ?? "20", 10)));
    const filters = z.object({ search: z.string().optional(), status: z.string().optional() }).parse(q);
    ok(reply, await listSalons({ ...filters, page, pageSize }));
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

  async checkUniqueness(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const query = z.object({
      email: z.string().email().optional(),
      phone: z.string().min(5).optional()
    }).parse(request.query);
    ok(reply, await checkSalonUniqueness(query));
  }

  async listSubscriptions(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const q = request.query as Record<string, string | undefined>;
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(100, Math.max(1, parseInt(q.pageSize ?? "20", 10)));
    const query = z.object({
      search: z.string().optional(),
      tier: z.enum(["standard", "premium"]).optional(),
      status: z.enum(["inactive", "active", "past_due", "cancelled", "expired", "paused"]).optional()
    }).parse(q);
    ok(reply, await listSubscriptions({ ...query, page, pageSize }));
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

  async cancellationStats(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    ok(reply, await getCancellationStats());
  }

  async listAudit(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const q = request.query as Record<string, string | undefined>;
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(200, Math.max(1, parseInt(q.pageSize ?? "50", 10)));
    const filters = adminAuditFiltersSchema.parse(q);
    ok(reply, await listAuditEvents({ ...filters, page, pageSize }));
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
    const q = request.query as Record<string, string | undefined>;
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(200, Math.max(1, parseInt(q.pageSize ?? "50", 10)));
    const filters = z.object({
      status: z.string().optional(),
      driver: z.string().optional(),
      to: z.string().optional()
    }).parse(q);
    ok(reply, await listEmailAuditEvents({ ...filters, page, pageSize }));
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

    // Detect price change from free (0) to paid — notify affected salons
    const isPriceKey = key === "subscription_standard_price_xof" || key === "subscription_premium_price_xof";
    if (isPriceKey) {
      const current = await prisma.platformSetting.findUnique({ where: { key } });
      const oldPrice = parseInt(current?.value ?? "0", 10);
      const newPrice = parseInt(value, 10);
      if (oldPrice === 0 && newPrice > 0) {
        const tier = key.includes("standard") ? "standard" : "premium";
        await this.notifyFreeSubscribersOfPriceChange(key, tier, newPrice);
      }
    }

    const updated = await updatePlatformSetting(key, value, actorName);
    await invalidateCacheTags(["kpi:admin", "kpi:pro", "catalog:pricing"]);
    ok(reply, updated);
  }

  private async notifyFreeSubscribersOfPriceChange(settingKey: string, tier: string, newPriceXof: number) {
    // Find active subscriptions for this tier that were activated for free
    const freeSubs = await prisma.subscription.findMany({
      where: {
        tier: tier as any,
        status: "active",
        expiresAt: null, // free subscriptions have no expiry
        charges: {
          some: { amountXof: 0, status: "succeeded" }
        }
      },
      include: {
        salon: {
          include: {
            staffMembers: {
              where: { role: "salon_owner" },
              select: { id: true, fullName: true }
            }
          }
        }
      }
    });

    if (freeSubs.length === 0) return;

    const tierLabel = tier === "premium" ? "Premium" : "Standard";
    const priceLabel = newPriceXof.toLocaleString("fr-FR");
    const gracePeriodEnds = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
    const graceDateLabel = gracePeriodEnds.toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" });

    const title = `Changement de tarif — Plan ${tierLabel}`;
    const body = `Le plan ${tierLabel} n'est plus gratuit. Nouveau tarif : ${priceLabel} XOF/mois. ` +
      `Votre accès actuel est conservé jusqu'au ${graceDateLabel}. Passé cette date, vous devrez souscrire pour continuer.`;

    // Set 30-day grace period on affected subscriptions
    await prisma.subscription.updateMany({
      where: {
        id: { in: freeSubs.map((s) => s.id) }
      },
      data: {
        expiresAt: gracePeriodEnds
      }
    });

    // Notify each salon owner
    for (const sub of freeSubs) {
      for (const owner of sub.salon.staffMembers) {
        await prisma.notification.create({
          data: { userId: owner.id, title, body, channel: "push" }
        }).catch(() => {});
      }
    }

    // Write audit log
    await prisma.auditLog.create({
      data: {
        action: "pricing_change_free_to_paid",
        summary: `${freeSubs.length} abonnement(s) ${tierLabel} gratuit(s) : période de grâce de 30 jours jusqu'au ${graceDateLabel}`,
        entityType: "PlatformSetting",
        entityId: settingKey,
        actorName: "system",
        severity: "warning",
        payloadJson: JSON.stringify({ tier, newPriceXof, affectedCount: freeSubs.length })
      }
    });
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

  async checkUniquenessPublic(request: FastifyRequest, reply: FastifyReply) {
    const { email, phone, name } = request.query as { email?: string; phone?: string; name?: string };
    ok(reply, await checkSalonUniqueness({ email, phone, name }));
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

  // ── PayDunya Sandbox Tester (dev-only) ─────────────────────────────────

  async paydunyaSandboxTest(request: FastifyRequest, reply: FastifyReply) {
    if (config.nodeEnv !== "development") {
      fail(reply, 403, "dev_only", "Ceci est réservé à l'environnement de développement.");
      return;
    }
    const body = z.object({
      amountXof: z.number().int().positive().default(5000),
      description: z.string().default("Test Beauté Avenue"),
    }).parse(request.body);

    try {
      // Step 1: Create checkout invoice (sandbox credentials)
      const MASTER_KEY = config.paydunyaMasterKey || "Z7yxbFqR-rDw3-m5Gy-BxXb-SzwvTTdpGPyG";
      const PRIVATE_KEY = config.paydunyaPrivateKey || "test_private_PSiGEf1TPDIsn9xtNwSF7UQIKwK";
      const PAYDUNYA_TOKEN = config.paydunyaToken || "loj2kfoqtCLHOxeOImBU";

      const invoiceRes = await fetch("https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "PAYDUNYA-MASTER-KEY": MASTER_KEY,
          "PAYDUNYA-PRIVATE-KEY": PRIVATE_KEY,
          "PAYDUNYA-TOKEN": PAYDUNYA_TOKEN
        },
        body: JSON.stringify({
          invoice: { total_amount: body.amountXof, description: body.description },
          store: { name: "Beauté Avenue Test" }
        })
      });

      const invoiceRaw = await invoiceRes.text();
      let invoiceJson: Record<string, unknown>;
      try { invoiceJson = JSON.parse(invoiceRaw); } catch { invoiceJson = { raw: invoiceRaw }; }

      if (invoiceJson.response_code !== "00") {
        ok(reply, {
          invoice: invoiceJson,
          payment: null,
          checkoutUrl: null,
          success: false,
          raw: invoiceRaw
        });
        return;
      }

      const checkoutUrl = String(invoiceJson.response_text ?? "");
      const invoiceToken = String(invoiceJson.token ?? "");

      ok(reply, {
        invoice: invoiceJson,
        payment: null,
        checkoutUrl,
        success: true
      });
    } catch (e) {
      handleError(e, reply);
    }
  }

  async downloadInvoicePdf(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const params = request.params as { invoiceId: string };
    const invoice = await prisma.billingInvoice.findFirst({
      where: { id: params.invoiceId },
      include: {
        subscription: {
          include: {
            salon: { select: { name: true } }
          }
        }
      }
    });
    if (!invoice) { fail(reply, 404, "invoice_not_found", "Facture introuvable."); return; }

    const issuedAt = invoice.createdAt.toLocaleDateString("fr-FR", { day: "2-digit", month: "long", year: "numeric" });
    const amountLabel = invoice.amountXof.toLocaleString("fr-FR");
    const billingProvider = invoice.subscription.billingProvider === "paydunya" ? "PayDunya" : "Manuel";

    const pdf = await buildInvoicePdf({
      invoiceNumber: invoice.invoiceNumber,
      issuedAt,
      status: invoice.status === "paid" ? "Payé" : invoice.status === "comped" ? "Offert" : "Émis",
      amountLabel,
      billingProvider,
      salonName: invoice.subscription.salon.name
    });

    reply
      .header("Content-Type", "application/pdf")
      .header("Content-Disposition", `attachment; filename="${invoice.invoiceNumber}.pdf"`)
      .send(pdf);
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

  // ── Salon Services ────────────────────────────────────────────────────────

  async listSalonServices(request: FastifyRequest, reply: FastifyReply) {
    if (!this.ensureAdmin(request, reply)) return;
    const { salonId } = request.params as { salonId: string };
    const services = await prisma.service.findMany({
      where: { salonId },
      orderBy: { displayOrder: "asc" }
    });
    ok(reply, services.map((s) => ({
      id: s.id,
      name: s.name,
      category: s.category,
      durationMinutes: s.durationMinutes,
      priceXof: s.priceXof,
      depositMode: s.depositMode,
      depositAmountXof: s.depositAmountXof,
      depositPercent: s.depositPercent,
      isActive: s.isActive,
      displayOrder: s.displayOrder
    })));
  }

  async createSalonService(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    try {
      const { salonId } = request.params as { salonId: string };
      const salon = await prisma.salon.findUnique({ where: { id: salonId }, select: { id: true } });
      if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      const body = proServiceCreateInputSchema.parse(request.body);
      const count = await prisma.service.count({ where: { salonId } });
      const service = await prisma.service.create({
        data: { salonId, displayOrder: count, ...body }
      });
      await invalidateCacheTags(["catalog:list", `catalog:salon:${salonId}`, "kpi:pro", "kpi:admin"]);
      ok(reply, {
        id: service.id,
        name: service.name,
        category: service.category,
        durationMinutes: service.durationMinutes,
        priceXof: service.priceXof,
        depositMode: service.depositMode,
        depositAmountXof: service.depositAmountXof,
        depositPercent: service.depositPercent,
        isActive: service.isActive,
        displayOrder: service.displayOrder
      }, 201);
    } catch (e) { handleError(e, reply); }
  }

  async updateSalonService(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    try {
      const { salonId, serviceId } = request.params as { salonId: string; serviceId: string };
      const existing = await prisma.service.findFirst({ where: { id: serviceId, salonId } });
      if (!existing) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }
      const body = proServiceUpdateInputSchema.parse(request.body);
      const service = await prisma.service.update({
        where: { id: serviceId },
        data: body
      });
      await invalidateCacheTags(["catalog:list", `catalog:salon:${salonId}`, "kpi:pro", "kpi:admin"]);
      ok(reply, {
        id: service.id,
        name: service.name,
        category: service.category,
        durationMinutes: service.durationMinutes,
        priceXof: service.priceXof,
        depositMode: service.depositMode,
        depositAmountXof: service.depositAmountXof,
        depositPercent: service.depositPercent,
        isActive: service.isActive,
        displayOrder: service.displayOrder
      });
    } catch (e) { handleError(e, reply); }
  }

  async deleteSalonService(request: FastifyRequest, reply: FastifyReply) {
    const token = this.ensureAdmin(request, reply);
    if (!token) return;
    const { salonId, serviceId } = request.params as { salonId: string; serviceId: string };
    const existing = await prisma.service.findFirst({ where: { id: serviceId, salonId } });
    if (!existing) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }
    await prisma.service.update({ where: { id: serviceId }, data: { isActive: false } });
    await invalidateCacheTags(["catalog:list", `catalog:salon:${salonId}`, "kpi:pro", "kpi:admin"]);
    ok(reply, { deleted: true });
  }
}
