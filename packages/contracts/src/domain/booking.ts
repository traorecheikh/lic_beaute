import { z } from "zod";

import { bookingStatusSchema, paymentProviderSchema, paymentStatusSchema } from "./enums.js";
import { paymentChannelSchema } from "./payment.js";

export const bookingCreateSchema = z.object({
  salonId: z.string(),
  serviceId: z.string(),
  employeeId: z.string().optional(),
  startsAt: z.string().datetime(),
  clientNote: z.string().max(500).optional(),
  provider: paymentProviderSchema.optional(),
  channel: paymentChannelSchema.optional()
});

export const bookingRescheduleSchema = z.object({
  startsAt: z.string().datetime()
});

export const bookingSummarySchema = z.object({
  id: z.string(),
  salonId: z.string(),
  salonName: z.string(),
  salonLogoUrl: z.string().nullable(),
  serviceId: z.string(),
  serviceName: z.string(),
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
  status: bookingStatusSchema,
  source: z.string(),
  depositAmountXof: z.number().nonnegative(),
  depositPaidXof: z.number().nonnegative().nullable(),
  depositPaymentStatus: paymentStatusSchema,
  paymentProvider: paymentProviderSchema.nullable(),
  paymentId: z.string().nullable(),
  reviewId: z.string().nullable()
});

export type BookingCreateInput = z.infer<typeof bookingCreateSchema>;
export type BookingRescheduleInput = z.infer<typeof bookingRescheduleSchema>;
export type BookingSummary = z.infer<typeof bookingSummarySchema>;
