import { z } from "zod";

import { subscriptionTierSchema } from "./enums.js";

export const serviceSummarySchema = z.object({
  id: z.string(),
  name: z.string(),
  durationMinutes: z.number().int().positive(),
  priceXof: z.number().nonnegative(),
  depositRequiredXof: z.number().nonnegative().nullable()
});

export const salonSummarySchema = z.object({
  id: z.string(),
  name: z.string(),
  category: z.string(),
  city: z.string(),
  neighborhood: z.string().nullable(),
  averageRating: z.number().min(0).max(5),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
  subscriptionTier: subscriptionTierSchema,
  featured: z.boolean()
});

export const salonDetailSchema = salonSummarySchema.extend({
  description: z.string(),
  address: z.string(),
  gallery: z.array(z.string().url()),
  services: z.array(serviceSummarySchema)
});
