import { z } from "zod";

import { paymentProviderSchema, paymentStatusSchema } from "./enums.js";

export const paymentChannelSchema = z.enum([
  "wave",
  "orange_money",
  "free_money"
]);

export const paymentInitiateInputSchema = z.object({
  bookingId: z.string(),
  provider: paymentProviderSchema,
  channel: paymentChannelSchema.optional()
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

export const paymentReconcileResponseSchema = paymentStatusResponseSchema;

export const paymentIntechCallbackSchema = z.object({
  idFromGu: z.string().optional(),
  idFromClient: z.string().optional(),
  code: z.string().optional(),
  status: z.string().optional(),
  amount: z.union([z.number(), z.string()]).optional(),
  amountWithoutFees: z.union([z.number(), z.string()]).optional(),
  serviceCode: z.string().optional(),
  infoHash: z.string().optional(),
  secureHash: z.string().optional()
}).passthrough();

export const paymentIntechStatusRequestSchema = z.object({
  idFromClient: z.string().min(1)
});

export const paymentIntechStatusResponseSchema = z.object({
  status: z.string(),
  idFromClient: z.string().optional(),
  idFromGu: z.string().optional(),
  code: z.string().optional()
}).passthrough();

export type PaymentInitiateInput = z.infer<typeof paymentInitiateInputSchema>;
export type PaymentInitiateResponse = z.infer<typeof paymentInitiateResponseSchema>;
export type PaymentStatusResponse = z.infer<typeof paymentStatusResponseSchema>;
export type PaymentReconcileResponse = z.infer<typeof paymentReconcileResponseSchema>;
export type PaymentChannel = z.infer<typeof paymentChannelSchema>;
export type PaymentIntechCallback = z.infer<typeof paymentIntechCallbackSchema>;
export type PaymentIntechStatusRequest = z.infer<typeof paymentIntechStatusRequestSchema>;
export type PaymentIntechStatusResponse = z.infer<typeof paymentIntechStatusResponseSchema>;
