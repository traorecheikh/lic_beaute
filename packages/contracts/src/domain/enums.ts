import { z } from "zod";

export const roleSchema = z.enum(["client", "salon_staff", "salon_manager", "salon_owner", "platform_admin"]);
export const salonApprovalStatusSchema = z.enum([
  "pending_review",
  "needs_info",
  "approved",
  "rejected"
]);
export const bookingStatusSchema = z.enum([
  "pending",
  "confirmed",
  "in_progress",
  "completed",
  "cancelled"
]);
export const depositSettlementStatusSchema = z.enum([
  "none",
  "held",
  "no_show_pending",
  "payout_scheduled",
  "paid_out",
  "refund_scheduled",
  "refunded",
  "blocked"
]);
export const depositResolutionSchema = z.enum([
  "pending",
  "completed",
  "client_no_show",
  "salon_no_show",
  "client_cancelled",
  "salon_cancelled",
  "disputed",
  "fraud_review"
]);
export const paymentStatusSchema = z.enum([
  "pending",
  "authorized",
  "succeeded",
  "failed",
  "refunded"
]);
export const subscriptionTierSchema = z.enum(["standard", "premium"]);
export const subscriptionStatusSchema = z.enum([
  "inactive",
  "active",
  "past_due",
  "cancelled",
  "expired",
  "paused"
]);
export const notificationTypeSchema = z.enum([
  "booking_created",
  "booking_reminder",
  "booking_cancelled",
  "payment_received",
  "salon_approved"
]);
export const paymentProviderSchema = z.enum(["paydunya", "manual"]);
export const paymentMethodSchema = z.enum([
  "wave_senegal",
  "orange_senegal",
  "free_senegal",
  "wizall_senegal"
]);
export const clientContactChannelSchema = z.enum(["phone", "sms"]);
export const clientBenefitKindSchema = z.enum(["membership", "package"]);
export const clientBenefitStatusSchema = z.enum([
  "active",
  "paused",
  "expired",
  "exhausted",
  "cancelled"
]);
export const voucherRedemptionStatusSchema = z.enum(["active", "used", "expired"]);
export const cancellationReasonSchema = z.enum([
  "too_expensive",
  "missing_features",
  "low_traffic",
  "technical_issues",
  "poor_support",
  "seasonal_closure",
  "switching_competitor",
  "business_closure",
  "payment_issues",
  "other"
]);

export type Role = z.infer<typeof roleSchema>;
export type SalonApprovalStatus = z.infer<typeof salonApprovalStatusSchema>;
export type BookingStatus = z.infer<typeof bookingStatusSchema>;
export type DepositSettlementStatus = z.infer<typeof depositSettlementStatusSchema>;
export type DepositResolution = z.infer<typeof depositResolutionSchema>;
export type PaymentStatus = z.infer<typeof paymentStatusSchema>;
export type SubscriptionTier = z.infer<typeof subscriptionTierSchema>;
export type SubscriptionStatus = z.infer<typeof subscriptionStatusSchema>;
export type NotificationType = z.infer<typeof notificationTypeSchema>;
export type PaymentProvider = z.infer<typeof paymentProviderSchema>;
export type ClientContactChannel = z.infer<typeof clientContactChannelSchema>;
export type ClientBenefitKind = z.infer<typeof clientBenefitKindSchema>;
export type ClientBenefitStatus = z.infer<typeof clientBenefitStatusSchema>;
export type VoucherRedemptionStatus = z.infer<typeof voucherRedemptionStatusSchema>;
export type CancellationReason = z.infer<typeof cancellationReasonSchema>;
