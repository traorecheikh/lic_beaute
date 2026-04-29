import { z } from "zod";

import { paymentProviderSchema, paymentStatusSchema } from "./enums.js";

export const paymentInitiateInputSchema = z.object({
  bookingId: z.string(),
  provider: paymentProviderSchema
});

export const paymentInitiateResponseSchema = z.object({
  paymentId: z.string(),
  redirectUrl: z.string(),
  expiresAt: z.string().datetime()
});

export const paymentStatusResponseSchema = z.object({
  id: z.string(),
  status: paymentStatusSchema,
  amountXof: z.number().nonnegative(),
  provider: paymentProviderSchema,
  providerTxId: z.string().nullable(),
  createdAt: z.string().datetime()
});

export type PaymentInitiateInput = z.infer<typeof paymentInitiateInputSchema>;
export type PaymentInitiateResponse = z.infer<typeof paymentInitiateResponseSchema>;
export type PaymentStatusResponse = z.infer<typeof paymentStatusResponseSchema>;
