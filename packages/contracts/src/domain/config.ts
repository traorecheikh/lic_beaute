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

export type PlatformSetting = z.infer<typeof platformSettingSchema>;
export type PlatformSalonCategory = z.infer<typeof platformSalonCategorySchema>;
export type PlatformRequiredDocument = z.infer<typeof platformRequiredDocumentSchema>;
export type UpdatePlatformSettingInput = z.infer<typeof updatePlatformSettingInputSchema>;
export type UpsertSalonCategoryInput = z.infer<typeof upsertSalonCategoryInputSchema>;
export type UpsertRequiredDocumentInput = z.infer<typeof upsertRequiredDocumentInputSchema>;
