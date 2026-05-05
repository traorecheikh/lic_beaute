import { z } from "zod";

import { bookingStatusSchema, subscriptionStatusSchema, subscriptionTierSchema } from "./enums.js";
import { reviewSchema } from "./review.js";

// ─── Salon profile ────────────────────────────────────────────────────────────

export const proSalonHourSchema = z.object({
  dayOfWeek: z.number().int().min(0).max(6),
  isOpen: z.boolean(),
  opensAt: z.string().nullable(),
  closesAt: z.string().nullable()
});

export const proTeamDisplaySchema = z.object({
  showPhotos: z.boolean(),
  showDescriptions: z.boolean()
});

export const proSalonProfileSchema = z.object({
  id: z.string(),
  name: z.string(),
  category: z.string(),
  logoUrl: z.string().nullable(),
  description: z.string(),
  city: z.string(),
  address: z.string(),
  neighborhood: z.string().nullable(),
  latitude: z.number().min(-90).max(90).nullable(),
  longitude: z.number().min(-180).max(180).nullable(),
  phone: z.string().nullable(),
  instagram: z.string().nullable(),
  averageRating: z.number(),
  subscriptionTier: subscriptionTierSchema,
  isVisibleInMarketplace: z.boolean(),
  canReceiveBookings: z.boolean(),
  teamDisplay: proTeamDisplaySchema,
  gallery: z.array(z.string()),
  hours: z.array(proSalonHourSchema)
});

export const proSalonUpdateInputSchema = z.object({
  category: z.string().optional(),
  logoUrl: z.string().max(1000).nullable().optional(),
  description: z.string().optional(),
  city: z.string().optional(),
  address: z.string().optional(),
  neighborhood: z.string().nullable().optional(),
  latitude: z.number().min(-90).max(90).nullable().optional(),
  longitude: z.number().min(-180).max(180).nullable().optional(),
  teamDisplay: proTeamDisplaySchema.partial().optional(),
  phone: z.string().min(8).max(20).nullable().optional(),
  instagram: z.string().max(200).nullable().optional(),
  gallery: z.array(z.string().min(1)).optional()
});

// ─── Services ─────────────────────────────────────────────────────────────────

export const proServiceSchema = z.object({
  id: z.string(),
  name: z.string(),
  category: z.string(),
  durationMinutes: z.number().int().positive(),
  priceXof: z.number().int().nonnegative(),
  depositMode: z.enum(["none", "fixed", "percent"]),
  depositAmountXof: z.number().int().nonnegative().nullable(),
  depositPercent: z.number().int().min(1).max(100).nullable(),
  isActive: z.boolean(),
  displayOrder: z.number().int()
});

export const proServiceCreateInputSchema = z.object({
  name: z.string().min(1),
  category: z.string().trim().min(1).max(60).optional(),
  durationMinutes: z.number().int().positive(),
  priceXof: z.number().int().nonnegative(),
  depositMode: z.enum(["none", "fixed", "percent"]),
  depositAmountXof: z.number().int().nonnegative().optional(),
  depositPercent: z.number().int().min(1).max(100).optional()
});

export const proServiceUpdateInputSchema = proServiceCreateInputSchema.partial();

// ─── Staff ────────────────────────────────────────────────────────────────────

export const proStaffMemberSchema = z.object({
  id: z.string(),
  userId: z.string(),
  displayName: z.string(),
  avatarUrl: z.string().nullable(),
  description: z.string().nullable(),
  isActive: z.boolean(),
  schedulingEnabled: z.boolean(),
  serviceIds: z.array(z.string())
});

export const proStaffCreateInputSchema = z.object({
  phone: z.string().min(8).max(20),
  fullName: z.string().min(2),
  avatarUrl: z.string().max(1000).nullable().optional(),
  description: z.string().max(240).nullable().optional(),
  serviceIds: z.array(z.string()).optional().default([])
});

export const proStaffUpdateInputSchema = z.object({
  displayName: z.string().optional(),
  avatarUrl: z.string().max(1000).nullable().optional(),
  description: z.string().max(240).nullable().optional(),
  isActive: z.boolean().optional(),
  schedulingEnabled: z.boolean().optional(),
  serviceIds: z.array(z.string()).optional()
});

// ─── Hours ────────────────────────────────────────────────────────────────────

export const proHoursUpdateInputSchema = z.array(proSalonHourSchema).length(7);

// ─── Blocked slots ────────────────────────────────────────────────────────────

export const proBlockedSlotSchema = z.object({
  id: z.string(),
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
  reason: z.string().nullable(),
  scope: z.enum(["salon", "employee"]),
  employeeId: z.string().nullable()
});

export const proBlockedSlotCreateInputSchema = z.object({
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
  reason: z.string().optional(),
  scope: z.enum(["salon", "employee"]).default("salon"),
  employeeId: z.string().optional()
});

// ─── Bookings ─────────────────────────────────────────────────────────────────

export const proBookingDetailSchema = z.object({
  id: z.string(),
  salonId: z.string(),
  serviceId: z.string(),
  serviceName: z.string(),
  employeeId: z.string().nullable(),
  employeeName: z.string().nullable(),
  clientId: z.string().nullable(),
  clientName: z.string().nullable(),
  clientPhone: z.string().nullable(),
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
  status: bookingStatusSchema,
  source: z.string(),
  depositAmountXof: z.number().nonnegative(),
  createdAt: z.string().datetime()
});

export const proBookingPaymentSchema = z.object({
  id: z.string(),
  status: z.string(),
  amountXof: z.number().int().nonnegative(),
  provider: z.string()
});

export const proBookingEventSchema = z.object({
  eventType: z.string(),
  fromStatus: z.string().nullable(),
  toStatus: z.string().nullable(),
  createdAt: z.string().datetime()
});

export const proBookingFullDetailSchema = proBookingDetailSchema.extend({
  payments: z.array(proBookingPaymentSchema),
  events: z.array(proBookingEventSchema)
});

export const proBookingStatusUpdateSchema = z.object({
  status: bookingStatusSchema
});

export const proManualBookingInputSchema = z.object({
  clientId: z.string().optional(),
  serviceId: z.string(),
  employeeId: z.string().optional(),
  startsAt: z.string().datetime(),
  clientName: z.string().optional(),
  clientPhone: z.string().optional()
});

export const proManualBookingCreatedSchema = z.object({
  id: z.string(),
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
  status: bookingStatusSchema,
  source: z.string()
});

// ─── Analytics ────────────────────────────────────────────────────────────────

export const proTopServiceSchema = z.object({
  serviceId: z.string(),
  serviceName: z.string(),
  bookingCount: z.number().int()
});

export const proAnalyticsSchema = z.object({
  period: z.string(),
  bookingCount: z.number().int(),
  completedCount: z.number().int(),
  occupancyPercent: z.number(),
  totalRevenueXof: z.number().int(),
  topServices: z.array(proTopServiceSchema)
});

// ─── Subscription ─────────────────────────────────────────────────────────────

export const proSubscriptionSchema = z.object({
  id: z.string(),
  tier: subscriptionTierSchema,
  status: subscriptionStatusSchema,
  renewsAt: z.string().datetime().nullable(),
  expiresAt: z.string().datetime().nullable(),
  isComplimentary: z.boolean(),
  autoRenew: z.boolean(),
  billingMethod: z
    .object({
      provider: z.enum(["paytech", "manual"]),
      accountNumberMasked: z.string()
    })
    .nullable()
});

export const proSubscriptionUpdateInputSchema = z
  .object({
    autoRenew: z.boolean().optional(),
    billingMethod: z
      .object({
        provider: z.enum(["paytech", "manual"]),
        accountNumber: z.string().trim().min(8).max(20)
      })
      .nullable()
      .optional()
  })
  .superRefine((value, ctx) => {
    if (value.autoRenew === undefined && value.billingMethod === undefined) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "At least one field must be updated",
        path: ["autoRenew"]
      });
    }
  });

export const proSubscriptionCheckoutInputSchema = z.object({
  action: z.enum(["upgrade", "renewal"]),
  provider: z.enum(["paytech", "manual"]).default("paytech")
});

export const proSubscriptionCheckoutResultSchema = z.object({
  redirectUrl: z.string().url(),
  chargeId: z.string()
});

export const proInvoiceSchema = z.object({
  id: z.string(),
  invoiceNumber: z.string(),
  amountXof: z.number().int().nonnegative(),
  status: z.string(),
  createdAt: z.string().datetime(),
  pdfUrl: z.string().nullable()
});

export const proPayoutEventSchema = z.object({
  id: z.string(),
  bookingId: z.string(),
  eventType: z.string(),
  amountXof: z.number().int().nonnegative(),
  createdAt: z.string().datetime()
});

// ─── Pro clients ─────────────────────────────────────────────────────────────

export const proClientSummarySchema = z.object({
  id: z.string(),
  fullName: z.string(),
  phone: z.string().nullable(),
  email: z.string().nullable(),
  visitCount: z.number().int().nonnegative(),
  totalSpentXof: z.number().int().nonnegative(),
  lastVisitAt: z.string().datetime().nullable()
});

export const proClientDetailSchema = proClientSummarySchema.extend({
  recentBookings: z.array(
    z.object({
      bookingId: z.string(),
      startsAt: z.string().datetime(),
      serviceName: z.string(),
      amountXof: z.number().int().nonnegative(),
      status: bookingStatusSchema
    })
  )
});

// ─── Checkout ────────────────────────────────────────────────────────────────

export const proCheckoutLineItemSchema = z.object({
  name: z.string().min(1),
  amountXof: z.number().int().nonnegative()
});

export const proCheckoutDetailsSchema = z.object({
  bookingId: z.string(),
  status: bookingStatusSchema,
  clientName: z.string().nullable(),
  serviceName: z.string(),
  startsAt: z.string().datetime(),
  staffName: z.string().nullable(),
  subtotalXof: z.number().int().nonnegative(),
  depositPaidXof: z.number().int().nonnegative(),
  balanceXof: z.number().int().nonnegative(),
  lineItems: z.array(proCheckoutLineItemSchema)
});

export const proCheckoutCompleteInputSchema = z.object({
  paymentMethod: z.enum(["cash", "paytech", "other"]),
  lineItems: z.array(proCheckoutLineItemSchema).min(1),
  discountXof: z.number().int().nonnegative().default(0)
});

export const proCheckoutCompleteResultSchema = z.object({
  completed: z.boolean(),
  bookingId: z.string(),
  status: bookingStatusSchema,
  chargedXof: z.number().int().nonnegative()
});

// ─── Availability ─────────────────────────────────────────────────────────────

export const availabilitySlotSchema = z.object({
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
  employeeId: z.string().nullable()
});

export const availabilityQuerySchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  serviceId: z.string(),
  employeeId: z.string().optional()
});

// ─── Pro dashboard ────────────────────────────────────────────────────────────

export const proDashboardSchema = z.object({
  pendingBookingCount: z.number().int(),
  todayBookingCount: z.number().int(),
  totalRevenueXof: z.number().int().nullable()
});

// ─── Reviews ─────────────────────────────────────────────────────────────────

export { reviewSchema };

export const proReviewResponseInputSchema = z.object({
  responseText: z.string().min(1).max(1000)
});

export const proReviewSchema = reviewSchema.extend({
  clientId: z.string()
});

// ─── Exports ─────────────────────────────────────────────────────────────────

export type ProSalonProfile = z.infer<typeof proSalonProfileSchema>;
export type ProSalonUpdateInput = z.infer<typeof proSalonUpdateInputSchema>;
export type ProService = z.infer<typeof proServiceSchema>;
export type ProServiceCreateInput = z.infer<typeof proServiceCreateInputSchema>;
export type ProServiceUpdateInput = z.infer<typeof proServiceUpdateInputSchema>;
export type ProStaffMember = z.infer<typeof proStaffMemberSchema>;
export type ProStaffCreateInput = z.infer<typeof proStaffCreateInputSchema>;
export type ProStaffUpdateInput = z.infer<typeof proStaffUpdateInputSchema>;
export type ProBlockedSlot = z.infer<typeof proBlockedSlotSchema>;
export type ProBlockedSlotCreateInput = z.infer<typeof proBlockedSlotCreateInputSchema>;
export type ProBookingDetail = z.infer<typeof proBookingDetailSchema>;
export type ProBookingFullDetail = z.infer<typeof proBookingFullDetailSchema>;
export type ProManualBookingInput = z.infer<typeof proManualBookingInputSchema>;
export type ProAnalytics = z.infer<typeof proAnalyticsSchema>;
export type ProSubscription = z.infer<typeof proSubscriptionSchema>;
export type AvailabilitySlot = z.infer<typeof availabilitySlotSchema>;
export type AvailabilityQuery = z.infer<typeof availabilityQuerySchema>;
export type ProDashboard = z.infer<typeof proDashboardSchema>;
