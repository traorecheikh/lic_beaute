import { z } from "zod";

export const platformSettingSchema = z.object({
  id: z.string(),
  group: z.string(),
  key: z.string(),
  value: z.string(),
  description: z.string().nullable(),
  updatedAt: z.string().datetime()
});

export const platformSalonCategorySchema = z.object({
  id: z.string(),
  name: z.string(),
  slug: z.string(),
  enabled: z.boolean(),
  createdAt: z.string().datetime()
});

export const platformRequiredDocumentSchema = z.object({
  id: z.string(),
  label: z.string(),
  slug: z.string(),
  type: z.string(),
  isRequired: z.boolean(),
  enabled: z.boolean(),
  createdAt: z.string().datetime()
});

export const updatePlatformSettingInputSchema = z.object({
  value: z.string()
});

export const upsertSalonCategoryInputSchema = z.object({
  name: z.string().min(1),
  slug: z.string().min(1),
  enabled: z.boolean().optional()
});

export const upsertRequiredDocumentInputSchema = z.object({
  label: z.string().min(1),
  slug: z.string().min(1),
  type: z.enum(["image", "pdf", "any"]),
  isRequired: z.boolean(),
  enabled: z.boolean().optional()
});

export const subscriptionFeaturesSchema = z.object({
  deposits: z.object({ enabled: z.boolean(), available: z.boolean() }),
  analytics: z.object({ enabled: z.boolean(), available: z.boolean() }),
  autoRenew: z.object({ enabled: z.boolean() }),
  billingProviders: z.object({
    paydunya: z.boolean(),
    manual: z.boolean(),
    card: z.boolean()
  }),
  planTiers: z.array(
    z.object({
      tier: z.enum(["standard", "premium"]),
      label: z.string(),
      priceLabel: z.string(),
      features: z.array(
        z.object({ label: z.string(), included: z.boolean() })
      )
    })
  )
});

export type PlatformSetting = z.infer<typeof platformSettingSchema>;
export type PlatformSalonCategory = z.infer<typeof platformSalonCategorySchema>;
export type PlatformRequiredDocument = z.infer<typeof platformRequiredDocumentSchema>;
export type UpdatePlatformSettingInput = z.infer<typeof updatePlatformSettingInputSchema>;
export type UpsertSalonCategoryInput = z.infer<typeof upsertSalonCategoryInputSchema>;
export type UpsertRequiredDocumentInput = z.infer<typeof upsertRequiredDocumentInputSchema>;
export type SubscriptionFeatures = z.infer<typeof subscriptionFeaturesSchema>;
