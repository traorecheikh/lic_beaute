import { z } from "zod";

import { paymentMethodSchema, paymentProviderSchema, paymentStatusSchema } from "./enums.js";

export const paymentChannelSchema = z.enum([
  "carte_bancaire",
  "wave_senegal",
  "orange_senegal",
  "free_senegal",
  "wizall_senegal",
  "expresso_sn",
  "om_ci",
  "mtn_ci",
  "moov_ci",
  "wave_ci",
  "om_bf",
  "moov_bf",
  "moov_bj",
  "mtn_bj",
  "t_money_tg",
  "moov_tg",
  "om_ml",
  "moov_ml",
  "mtn_cm",
  "djamo",
  "paydunya_wallet",
  "wave",
  "orange_money",
  "free_money",
  "paydunya_card",
  "paydunya_airtel",
  "paydunya_expresso",
  "paydunya_free",
  "paydunya_mpesa",
  "paydunya_ng_airtel",
  "paydunya_ng_mtn",
  "paydunya_ng_9mobile",
  "paydunya_ng_glo",
  "paydunya_sam_airtel",
  "paydunya_sam_mtn",
  "paydunya_sam_safaricom",
  "paydunya_tigo_rw",
  "paydunya_airtel_rw",
  "paydunya_mtn_rw",
  "paydunya_mtn_ug",
  "paydunya_airtel_ug",
  "paydunya_orange_ml",
  "paydunya_mtn_ci",
  "paydunya_mtn_gh",
  "paydunya_vodafone_gh",
  "paydunya_airteltigo_gh",
  "paydunya_tm_ci",
  "paydunya_moov_tg",
  "paydunya_togocel_tg",
  "paydunya_wari_sn",
  "paydunya_wave_sn",
  "paydunya_cb_ci",
  "paydunya_orange_sn",
  "paydunya_free_sn",
  "paydunya_yup_bj",
  "paydunya_mtn_bj",
  "paydunya_moov_ci",
  "paydunya_orange_cm",
  "paydunya_mtn_cm",
  "paydunya_nexttel_cm",
  "paydunya_camtel_cm"
]);

export const paymentInitiateInputSchema = z.object({
  bookingId: z.string(),
  provider: paymentProviderSchema,
  channel: paymentChannelSchema.optional()
});

export const paymentInitiateResponseSchema = z.object({
  paymentId: z.string(),
  redirectUrl: z.string().nullable(),
  expiresAt: z.string().datetime().nullable(),
  status: paymentStatusSchema.optional()
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

export const paymentWebhookBodySchema = z.object({
  idFromGu: z.string().optional(),
  idFromClient: z.string().optional(),
  code: z.string().optional(),
  status: z.string().optional(),
  amount: z.union([z.number().nonnegative(), z.string()]).optional(),
  amountWithoutFees: z.union([z.number().nonnegative(), z.string()]).optional(),
  serviceCode: z.string().optional(),
  infoHash: z.string().optional(),
  secureHash: z.string().optional()
}).passthrough();

export const paymentStatusRequestSchema = z.object({
  idFromClient: z.string().min(1)
});

export const paymentStatusResponseSchemaWithPassthrough = z.object({
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
export type PaymentWebhookBody = z.infer<typeof paymentWebhookBodySchema>;

// ── PayDunya ──────────────────────────────────────────────────────────────────

export const paydunyaMethodSchema = z.object({
  code: z.string(),
  country: z.string(),
  label: z.string(),
  enabled: z.boolean()
});

export const paydunyaMethodListResponseSchema = z.object({
  methods: z.array(paydunyaMethodSchema)
});

export const paydunyaTransactionExecuteInputSchema = z.object({
  paymentId: z.string(),
  method: z.string(),
  details: z.record(z.any()).optional()
});

export const paydunyaTransactionExecuteResponseSchema = z.object({
  success: z.boolean(),
  status: z.string(),
  providerTxId: z.string().nullable(),
  message: z.string().optional(),
  url: z.string().optional(),
  other_url: z.object({
    om_url: z.string().optional(),
    maxit_url: z.string().optional()
  }).optional(),
  data: z.record(z.any()).optional()
}).passthrough();

export const proSubscriptionExecuteInputSchema = z.object({
  method: z.string(),
  details: z.record(z.any()).optional()
});

export const proSubscriptionExecuteResponseSchema = paydunyaTransactionExecuteResponseSchema;

export const paydunyaRefundInputSchema = z.object({
  amountXof: z.number().int().positive(),
  phone: z.string(),
  method: z.string()
});

export const paydunyaRefundResponseSchema = z.object({
  success: z.boolean(),
  disburseInvoiceToken: z.string(),
  paydunyaRef: z.string()
});

export type PaydunyaMethod = z.infer<typeof paydunyaMethodSchema>;
export type PaydunyaTransactionExecuteInput = z.infer<typeof paydunyaTransactionExecuteInputSchema>;
export type PaydunyaTransactionExecuteResponse = z.infer<typeof paydunyaTransactionExecuteResponseSchema>;
export type PaydunyaRefundInput = z.infer<typeof paydunyaRefundInputSchema>;
export type PaydunyaRefundResponse = z.infer<typeof paydunyaRefundResponseSchema>;
export type ProSubscriptionExecuteInput = z.infer<typeof proSubscriptionExecuteInputSchema>;
export type ProSubscriptionExecuteResponse = z.infer<typeof proSubscriptionExecuteResponseSchema>;
