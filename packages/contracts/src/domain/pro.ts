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

export const proSalonProfileSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string(),
  city: z.string(),
  address: z.string(),
  neighborhood: z.string().nullable(),
  averageRating: z.number(),
  subscriptionTier: subscriptionTierSchema,
  isVisibleInMarketplace: z.boolean(),
  canReceiveBookings: z.boolean(),
  gallery: z.array(z.string()),
  hours: z.array(proSalonHourSchema)
});

export const proSalonUpdateInputSchema = z.object({
  description: z.string().optional(),
  city: z.string().optional(),
  address: z.string().optional(),
  neighborhood: z.string().optional()
});

// ─── Services ─────────────────────────────────────────────────────────────────

export const proServiceSchema = z.object({
  id: z.string(),
  name: z.string(),
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
  isActive: z.boolean(),
  schedulingEnabled: z.boolean(),
  serviceIds: z.array(z.string())
});

export const proStaffCreateInputSchema = z.object({
  phone: z.string().min(8).max(20),
  fullName: z.string().min(2),
  serviceIds: z.array(z.string()).optional().default([])
});

export const proStaffUpdateInputSchema = z.object({
  displayName: z.string().optional(),
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

export const proManualBookingInputSchema = z.object({
  serviceId: z.string(),
  employeeId: z.string().optional(),
  startsAt: z.string().datetime(),
  clientName: z.string().optional(),
  clientPhone: z.string().optional()
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
  autoRenew: z.boolean()
});

export const proSubscriptionUpdateInputSchema = z.object({
  autoRenew: z.boolean()
});

export const proSubscriptionCheckoutInputSchema = z.object({
  action: z.enum(["upgrade", "renewal"]),
  provider: z.enum(["wave", "orange_money"]).default("wave")
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

// ─── Exports ─────────────────────────────────────────────────────────────────

export type ProSalonProfile = z.infer<typeof proSalonProfileSchema>;
export type ProSalonUpdateInput = z.infer<typeof proSalonUpdateInputSchema>;
export type ProService = z.infer<typeof proServiceSchema>;
export type ProServiceCreateInput = z.infer<typeof proServiceCreateInputSchema>;
export type ProServiceUpdateInput = z.infer<typeof proServiceUpdateInputSchema>;
export type ProStaffMember = z.infer<typeof proStaffMemberSchema>;
export type ProStaffCreateInput = z.infer<typeof proStaffCreateInputSchema>;
export type ProBlockedSlot = z.infer<typeof proBlockedSlotSchema>;
export type ProBlockedSlotCreateInput = z.infer<typeof proBlockedSlotCreateInputSchema>;
export type ProBookingDetail = z.infer<typeof proBookingDetailSchema>;
export type ProManualBookingInput = z.infer<typeof proManualBookingInputSchema>;
export type ProAnalytics = z.infer<typeof proAnalyticsSchema>;
export type ProSubscription = z.infer<typeof proSubscriptionSchema>;
export type AvailabilitySlot = z.infer<typeof availabilitySlotSchema>;
export type AvailabilityQuery = z.infer<typeof availabilityQuerySchema>;
export type ProDashboard = z.infer<typeof proDashboardSchema>;
