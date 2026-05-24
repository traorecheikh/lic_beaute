import { z } from "zod";

import {
  paymentProviderSchema,
  paymentStatusSchema,
  salonApprovalStatusSchema,
  subscriptionStatusSchema,
  subscriptionTierSchema
} from "./enums.js";

export const adminKpiSchema = z.object({
  label: z.string(),
  value: z.number().nonnegative(),
  displayValue: z.string(),
  note: z.string()
});

export const adminGrowthSalonSchema = z.object({
  salonId: z.string(),
  salonName: z.string(),
  bookingDeltaPercent: z.number(),
  bookingsThisWeek: z.number().int().nonnegative(),
  city: z.string()
});

export const adminInactivityAlertSchema = z.object({
  salonId: z.string(),
  salonName: z.string(),
  daysWithoutBookings: z.number().int().nonnegative(),
  city: z.string(),
  status: salonApprovalStatusSchema
});

export const adminDashboardSchema = z.object({
  kpis: z.array(adminKpiSchema).length(4),
  topGrowthSalons: z.array(adminGrowthSalonSchema),
  inactivityAlerts: z.array(adminInactivityAlertSchema),
  quickLinks: z.object({
    pendingSalonApprovals: z.number().int().nonnegative(),
    subscriptionsNeedingAction: z.number().int().nonnegative(),
    auditEventsToday: z.number().int().nonnegative()
  })
});

export const adminSalonQueueFiltersSchema = z.object({
  search: z.string().trim().optional(),
  category: z.string().trim().optional(),
  city: z.string().trim().optional(),
  status: salonApprovalStatusSchema.optional()
});

export const adminSalonQueueItemSchema = z.object({
  id: z.string(),
  salonName: z.string(),
  category: z.string(),
  city: z.string(),
  ownerName: z.string(),
  submittedAt: z.string().datetime(),
  approvalStatus: salonApprovalStatusSchema,
  subscriptionIntentTier: subscriptionTierSchema,
  missingEvidence: z.array(z.string()),
  latestAdminNote: z.string().nullable()
});

export const adminSalonOwnerSchema = z.object({
  fullName: z.string(),
  email: z.string().email(),
  phone: z.string()
});

export const adminSalonServiceSnapshotSchema = z.object({
  id: z.string(),
  name: z.string(),
  durationMinutes: z.number().int().positive(),
  priceXof: z.number().int().nonnegative(),
  depositMode: z.enum(["none", "fixed", "percent"]),
  depositAmountXof: z.number().int().nonnegative().nullable(),
  depositPercent: z.number().int().nonnegative().nullable()
});

export const adminSalonDetailSchema = z.object({
  id: z.string(),
  subscriptionId: z.string().nullable(),
  salonName: z.string(),
  category: z.string(),
  city: z.string(),
  address: z.string(),
  description: z.string(),
  owner: adminSalonOwnerSchema,
  approvalStatus: salonApprovalStatusSchema,
  subscriptionIntentTier: subscriptionTierSchema,
  submittedAt: z.string().datetime(),
  missingEvidence: z.array(z.string()),
  latestAdminNote: z.string().nullable(),
  gallery: z.array(z.string().url()),
  services: z.array(adminSalonServiceSnapshotSchema),
  documents: z.array(
  z.object({
    label: z.string(),
    status: z.enum(["received", "missing", "invalid"]),
    note: z.string().nullable(),
    fileUrl: z.string().url().nullable()
  })
  )});

export const adminSalonDecisionSchema = z.object({
  reason: z.string().trim().min(3).max(500)
});

export const adminSalonCreateInputSchema = z.object({
  name: z.string().trim().min(2),
  category: z.string().trim().min(1),
  city: z.string().trim().min(1),
  address: z.string().trim().min(5),
  description: z.string().trim().min(10),
  ownerEmail: z.string().email(),
  ownerPhone: z.string().trim().min(8),
  ownerName: z.string().trim().min(2)
});

export const adminSubscriptionSummarySchema = z.object({
  id: z.string(),
  salonId: z.string(),
  salonName: z.string(),
  tier: subscriptionTierSchema,
  status: subscriptionStatusSchema,
  billingProvider: z.enum(["paydunya", "manual"]).nullable(),
  expiresAt: z.string().datetime().nullable(),
  autoRenew: z.boolean(),
  isComplimentary: z.boolean()
});

export const adminSubscriptionEventSchema = z.object({
  id: z.string(),
  eventType: z.string(),
  summary: z.string(),
  createdAt: z.string().datetime(),
  actorName: z.string(),
  source: z.enum(["provider", "admin", "system"]),
  payloadPreview: z.string().nullable()
});

export const billingInvoiceSchema = z.object({
  id: z.string(),
  invoiceNumber: z.string(),
  amountXof: z.number().int().nonnegative(),
  status: z.enum(["issued", "void", "paid", "comped"]),
  createdAt: z.string().datetime(),
  pdfUrl: z.string().url()
});

export const adminSubscriptionDetailSchema = adminSubscriptionSummarySchema.extend({
  startedAt: z.string().datetime(),
  renewedAt: z.string().datetime().nullable(),
  entitlements: z.array(
    z.object({
      label: z.string(),
      enabled: z.boolean(),
      note: z.string().nullable()
    })
  ),
  events: z.array(adminSubscriptionEventSchema),
  invoices: z.array(billingInvoiceSchema)
});

export const adminSubscriptionOverrideActionSchema = z.enum([
  "grant_complimentary_premium",
  "extend_expiry",
  "downgrade_to_standard",
  "pause_subscription",
  "resume_subscription",
  "terminate_subscription",
  "mark_charge_resolved"
]);

export const adminSubscriptionOverrideSchema = z
  .object({
    action: adminSubscriptionOverrideActionSchema,
    reason: z.string().trim().min(3).max(500),
    effectiveAt: z.string().datetime().optional(),
    expiresAt: z.string().datetime().optional(),
    metadata: z
      .object({
        internalTicket: z.string().trim().min(1).optional(),
        subscriptionChargeId: z.string().trim().min(1).optional(),
        providerReference: z.string().trim().min(1).optional()
      })
      .partial()
      .optional()
  })
  .superRefine((value, ctx) => {
    if (
      (value.action === "grant_complimentary_premium" || value.action === "extend_expiry") &&
      !value.expiresAt
    ) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "expiresAt is required for this override action",
        path: ["expiresAt"]
      });
    }

    if (value.action === "mark_charge_resolved" && !value.metadata?.subscriptionChargeId) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "subscriptionChargeId is required for charge resolution",
        path: ["metadata", "subscriptionChargeId"]
      });
    }
  });

export const adminAuditFiltersSchema = z.object({
  actor: z.string().trim().optional(),
  entityType: z.string().trim().optional(),
  action: z.string().trim().optional()
});

export const adminAuditSummarySchema = z.object({
  id: z.string(),
  action: z.string(),
  summary: z.string(),
  entityType: z.string(),
  entityId: z.string(),
  actorName: z.string(),
  createdAt: z.string().datetime(),
  severity: z.enum(["info", "warning", "critical"])
});

export const adminAuditDetailSchema = adminAuditSummarySchema.extend({
  payloadJson: z.string(),
  relatedLinks: z.array(
    z.object({
      label: z.string(),
      href: z.string()
    })
  )
});

export type AdminKpi = z.infer<typeof adminKpiSchema>;
export type AdminGrowthSalon = z.infer<typeof adminGrowthSalonSchema>;
export type AdminInactivityAlert = z.infer<typeof adminInactivityAlertSchema>;
export type AdminDashboard = z.infer<typeof adminDashboardSchema>;
export type AdminSalonQueueFilters = z.infer<typeof adminSalonQueueFiltersSchema>;
export type AdminSalonQueueItem = z.infer<typeof adminSalonQueueItemSchema>;
export type AdminSalonCreateInput = z.infer<typeof adminSalonCreateInputSchema>;
export type AdminSalonDetail = z.infer<typeof adminSalonDetailSchema>;
export type AdminSalonDecisionInput = z.infer<typeof adminSalonDecisionSchema>;
export type AdminSubscriptionSummary = z.infer<typeof adminSubscriptionSummarySchema>;
export type AdminSubscriptionDetail = z.infer<typeof adminSubscriptionDetailSchema>;
export type AdminSubscriptionEvent = z.infer<typeof adminSubscriptionEventSchema>;
export type AdminSubscriptionOverrideAction = z.infer<typeof adminSubscriptionOverrideActionSchema>;
export type AdminSubscriptionOverrideInput = z.infer<typeof adminSubscriptionOverrideSchema>;
export type BillingInvoice = z.infer<typeof billingInvoiceSchema>;
export type AdminAuditFilters = z.infer<typeof adminAuditFiltersSchema>;
export type AdminAuditSummary = z.infer<typeof adminAuditSummarySchema>;
export const adminManualExtendInputSchema = z.object({
  amountXof: z.number().int().positive(),
  durationDays: z.number().int().positive(),
  reason: z.string().trim().min(3).max(500),
  reference: z.string().trim().min(1).max(200),
  effectiveDate: z.string().datetime().optional()
});

export const adminManualExtendResponseSchema = z.object({
  id: z.string(),
  subscriptionId: z.string(),
  salonId: z.string(),
  previousExpiresAt: z.string().datetime().nullable(),
  newExpiresAt: z.string().datetime(),
  amountXof: z.number().int().positive(),
  durationDays: z.number().int().positive(),
  reference: z.string(),
  chargeId: z.string(),
  invoiceId: z.string()
});

export const adminSubscriptionChargeStatusSchema = z.object({
  chargeId: z.string(),
  status: paymentStatusSchema,
  provider: paymentProviderSchema,
  amountXof: z.number().int().nonnegative(),
  chargeType: z.enum(["upgrade", "renewal"]),
  subscriptionId: z.string(),
  subscriptionStatus: subscriptionStatusSchema,
  tier: subscriptionTierSchema,
  expiresAt: z.string().datetime().nullable()
});

export type AdminManualExtendInput = z.infer<typeof adminManualExtendInputSchema>;
export type AdminManualExtendResponse = z.infer<typeof adminManualExtendResponseSchema>;
export type AdminSubscriptionChargeStatus = z.infer<typeof adminSubscriptionChargeStatusSchema>;
export type AdminAuditDetail = z.infer<typeof adminAuditDetailSchema>;
