import { z } from "zod";

import {
  clientBenefitKindSchema,
  clientBenefitStatusSchema,
  clientContactChannelSchema,
  paymentProviderSchema,
  voucherRedemptionStatusSchema
} from "./enums.js";
import { paymentChannelSchema } from "./payment.js";

export const profileOptionsSchema = z.object({
  cities: z.array(z.string()),
  languages: z.array(z.enum(["fr", "en"])),
  contactChannels: z.array(clientContactChannelSchema),
  paymentProviders: z.array(paymentProviderSchema)
});

export const clientPaymentMethodSchema = z.object({
  id: z.string(),
  provider: paymentProviderSchema,
  phoneNumber: z.string(),
  label: z.string().nullable(),
  method: paymentChannelSchema.nullable().optional(),
  country: z.string().nullable().optional(),
  isDefault: z.boolean(),
  lastUsedAt: z.string().nullable(),
  createdAt: z.string(),
  updatedAt: z.string()
});

export const clientPaymentMethodCreateSchema = z.object({
  provider: paymentProviderSchema,
  phoneNumber: z.string().min(8).max(20),
  label: z.string().min(1).max(60).nullable().optional(),
  method: paymentChannelSchema.optional(),
  country: z.string().trim().min(2).max(8).optional()
});

export const clientPaymentMethodUpdateSchema = z.object({
  phoneNumber: z.string().min(8).max(20).optional(),
  label: z.string().min(1).max(60).nullable().optional(),
  method: paymentChannelSchema.nullable().optional(),
  country: z.string().trim().min(2).max(8).nullable().optional()
});

export const clientBenefitSchema = z.object({
  id: z.string(),
  kind: clientBenefitKindSchema,
  name: z.string(),
  status: clientBenefitStatusSchema,
  remainingUses: z.number().int().nullable(),
  expiresAt: z.string().nullable(),
  billingDate: z.string().nullable(),
  salonId: z.string(),
  salonName: z.string(),
  createdAt: z.string()
});

export const clientVoucherSchema = z.object({
  id: z.string(),
  code: z.string(),
  title: z.string(),
  description: z.string().nullable(),
  discountLabel: z.string(),
  status: voucherRedemptionStatusSchema,
  expiresAt: z.string().nullable(),
  redeemedAt: z.string(),
  usedAt: z.string().nullable(),
  salonId: z.string().nullable(),
  salonName: z.string().nullable()
});

export const redeemVoucherInputSchema = z.object({
  code: z.string().trim().min(3).max(64)
});

export const proClientBenefitCreateSchema = z.object({
  clientId: z.string(),
  kind: clientBenefitKindSchema,
  name: z.string().min(2).max(120),
  remainingUses: z.number().int().nonnegative().nullable().optional(),
  expiresAt: z.string().datetime().nullable().optional(),
  billingDate: z.string().datetime().nullable().optional()
});

export const clientAddressSchema = z.object({
  id: z.string(),
  label: z.string(),
  street: z.string().nullable(),
  city: z.string().nullable(),
  isDefault: z.boolean(),
  createdAt: z.string(),
  updatedAt: z.string()
});

export const clientAddressCreateSchema = z.object({
  label: z.string().min(1).max(60),
  street: z.string().max(240).nullable().optional(),
  city: z.string().max(120).nullable().optional()
});

export const clientAddressUpdateSchema = z.object({
  label: z.string().min(1).max(60).optional(),
  street: z.string().max(240).nullable().optional(),
  city: z.string().max(120).nullable().optional(),
  isDefault: z.boolean().optional()
});

export const clientAddressListResponseSchema = z.object({
  items: z.array(clientAddressSchema)
});

export const proVoucherCreateSchema = z.object({
  code: z.string().trim().min(3).max(64),
  title: z.string().min(2).max(120),
  description: z.string().max(240).nullable().optional(),
  discountLabel: z.string().min(1).max(80),
  expiresAt: z.string().datetime().nullable().optional(),
  maxRedemptions: z.number().int().positive().nullable().optional()
});

export type ProfileOptions = z.infer<typeof profileOptionsSchema>;
export type ClientPaymentMethod = z.infer<typeof clientPaymentMethodSchema>;
export type ClientPaymentMethodCreateInput = z.infer<typeof clientPaymentMethodCreateSchema>;
export type ClientPaymentMethodUpdateInput = z.infer<typeof clientPaymentMethodUpdateSchema>;
export type ClientBenefit = z.infer<typeof clientBenefitSchema>;
export type ClientVoucher = z.infer<typeof clientVoucherSchema>;
export type RedeemVoucherInput = z.infer<typeof redeemVoucherInputSchema>;
export type ProClientBenefitCreateInput = z.infer<typeof proClientBenefitCreateSchema>;
export type ProVoucherCreateInput = z.infer<typeof proVoucherCreateSchema>;
export type ClientAddress = z.infer<typeof clientAddressSchema>;
export type ClientAddressCreateInput = z.infer<typeof clientAddressCreateSchema>;
export type ClientAddressUpdateInput = z.infer<typeof clientAddressUpdateSchema>;
export type ClientAddressListResponse = z.infer<typeof clientAddressListResponseSchema>;
