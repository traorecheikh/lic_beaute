import { z } from "zod";

import { clientContactChannelSchema, roleSchema } from "./enums.js";

// Phone country map for registration validation
// dialCode -> { expectedDigits (excluding dial code) }
const PHONE_COUNTRY_DIGITS: Record<string, number> = {
  "+221": 9, // Senegal
  "+225": 10, // Côte d'Ivoire
  "+226": 8,  // Burkina Faso
  "+229": 10, // Benin
  "+228": 8,  // Togo
  "+223": 8,  // Mali
  "+237": 9,  // Cameroon
  "+33": 9,   // France
  "+212": 9,  // Morocco
  "+216": 8,  // Tunisia
  "+222": 8,  // Mauritania
};

function validatePhoneDigits(phone: string): boolean {
  const knownDialCodes = Object.keys(PHONE_COUNTRY_DIGITS).sort((a, b) => b.length - a.length);
  for (const dialCode of knownDialCodes) {
    if (phone.startsWith(dialCode)) {
      const nationalDigits = phone.replace(/\D+/g, "").slice(dialCode.replace(/\D+/g, "").length);
      return nationalDigits.length === PHONE_COUNTRY_DIGITS[dialCode];
    }
  }
  return false;
}

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
  phone: z.string().min(8).max(20).refine(validatePhoneDigits, "Le numéro de téléphone ne correspond pas à l'indicatif pays sélectionné."),
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
  services: z.array(serviceCreateInputSchema),
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

export const setupAccountInputSchema = z
  .object({
    token: z.string().min(1),
    email: z.string().email(),
    password: z.string().min(8, "Le mot de passe doit contenir au moins 8 caractères."),
    confirm: z.string()
  })
  .superRefine((data, ctx) => {
    if (data.password !== data.confirm) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Les mots de passe ne correspondent pas.",
        path: ["confirm"]
      });
    }
  });

export const resetPasswordInputSchema = z
  .object({
    token: z.string().min(1),
    email: z.string().email(),
    password: z.string().min(8, "Le mot de passe doit contenir au moins 8 caractères."),
    confirm: z.string()
  })
  .superRefine((data, ctx) => {
    if (data.password !== data.confirm) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Les mots de passe ne correspondent pas.",
        path: ["confirm"]
      });
    }
  });

export const magicLoginInputSchema = z.object({
  token: z.string().min(1),
  email: z.string().email()
});

export type EmailLoginInput = z.infer<typeof emailLoginSchema>;
export type OtpRequestInput = z.infer<typeof otpRequestSchema>;
export type OtpVerifyInput = z.infer<typeof otpVerifySchema>;
export type AuthSession = z.infer<typeof authSessionSchema>;
export type CurrentUser = z.infer<typeof currentUserSchema>;
export type RefreshInput = z.infer<typeof refreshInputSchema>;
export type UpdateMeInput = z.infer<typeof updateMeInputSchema>;
export type RegisterInput = z.infer<typeof registerInputSchema>;
export type SetupAccountInput = z.infer<typeof setupAccountInputSchema>;
export type ResetPasswordInput = z.infer<typeof resetPasswordInputSchema>;
export type MagicLoginInput = z.infer<typeof magicLoginInputSchema>;
