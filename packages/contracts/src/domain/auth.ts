import { z } from "zod";

import { clientContactChannelSchema, roleSchema } from "./enums.js";

export const emailLoginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
});

export const otpRequestSchema = z.object({
  phone: z.string().min(8).max(20)
});

export const otpVerifySchema = z.object({
  phone: z.string().min(8).max(20),
  code: z.string().length(6)
});

export const authSessionSchema = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  expiresInSeconds: z.number().int().positive()
});

export const currentUserSchema = z.object({
  id: z.string(),
  fullName: z.string(),
  email: z.string().email().nullable(),
  phone: z.string().nullable(),
  role: roleSchema,
  salonId: z.string().nullable(),
  city: z.string().nullable(),
  avatarUrl: z.string().nullable(),
  preferredContactChannel: clientContactChannelSchema,
  pushOptIn: z.boolean(),
  marketingOptIn: z.boolean(),
  preferredLanguage: z.enum(["fr", "en"])
});

export const refreshInputSchema = z.object({
  refreshToken: z.string()
});

export const updateMeInputSchema = z.object({
  fullName: z.string().min(2).optional(),
  city: z.string().min(2).max(120).nullable().optional(),
  avatarMediaId: z.string().nullable().optional(),
  preferredContactChannel: clientContactChannelSchema.optional(),
  pushOptIn: z.boolean().optional(),
  marketingOptIn: z.boolean().optional(),
  preferredLanguage: z.enum(["fr", "en"]).optional(),
  currentPassword: z.string().optional(),
  newPassword: z.string().min(8).optional()
});

const serviceCreateInputSchema = z.object({
  name: z.string().min(1),
  durationMinutes: z.number().int().positive(),
  priceXof: z.number().int().nonnegative(),
  depositMode: z.enum(["none", "fixed", "percent"]),
  depositAmountXof: z.number().int().nonnegative().optional(),
  depositPercent: z.number().int().min(1).max(100).optional()
});

const hourInputSchema = z.object({
  dayOfWeek: z.number().int().min(0).max(6),
  isOpen: z.boolean(),
  opensAt: z.string().optional(),
  closesAt: z.string().optional()
});

export const clientRegisterInputSchema = z.object({
  type: z.literal("client"),
  fullName: z.string().min(2),
  email: z.string().email().optional(),
  phone: z.string().min(8).max(20).optional(),
  password: z.string().min(8)
});

export const salonOwnerRegisterInputSchema = z.object({
  type: z.literal("salon_owner"),
  fullName: z.string().min(2),
  email: z.string().email(),
  phone: z.string().min(8).max(20),
  password: z.string().min(8),
  subscriptionIntentTier: z.enum(["standard", "premium"]).optional(),
  salon: z.object({
    name: z.string().min(2),
    category: z.string(),
    city: z.string(),
    address: z.string(),
    neighborhood: z.string().optional(),
    description: z.string().optional()
  }),
  services: z.array(serviceCreateInputSchema).min(1),
  hours: z.array(hourInputSchema).length(7),
  documents: z.array(z.object({
    label: z.string(),
    fileUrl: z.string().url()
  })).optional()
});

export const registerInputSchema = z.discriminatedUnion("type", [
  clientRegisterInputSchema,
  salonOwnerRegisterInputSchema
]);

export type EmailLoginInput = z.infer<typeof emailLoginSchema>;
export type OtpRequestInput = z.infer<typeof otpRequestSchema>;
export type OtpVerifyInput = z.infer<typeof otpVerifySchema>;
export type AuthSession = z.infer<typeof authSessionSchema>;
export type CurrentUser = z.infer<typeof currentUserSchema>;
export type RefreshInput = z.infer<typeof refreshInputSchema>;
export type UpdateMeInput = z.infer<typeof updateMeInputSchema>;
export type RegisterInput = z.infer<typeof registerInputSchema>;
