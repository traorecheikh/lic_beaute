import { z } from "zod";

import { subscriptionTierSchema } from "./enums.js";

export const serviceSummarySchema = z.object({
  id: z.string(),
  name: z.string(),
  category: z.string(),
  durationMinutes: z.number().int().positive(),
  priceXof: z.number().nonnegative(),
  depositRequiredXof: z.number().nonnegative().nullable()
});

export const salonTeamDisplaySchema = z.object({
  showPhotos: z.boolean(),
  showDescriptions: z.boolean()
});

export const salonStaffSummarySchema = z.object({
  id: z.string(),
  displayName: z.string(),
  avatarUrl: z.string().nullable(),
  description: z.string().nullable(),
  serviceIds: z.array(z.string())
});

export const salonSummarySchema = z.object({
  id: z.string(),
  name: z.string(),
  category: z.string(),
  logoUrl: z.string().nullable(),
  city: z.string(),
  neighborhood: z.string().nullable(),
  averageRating: z.number().min(0).max(5),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
  subscriptionTier: subscriptionTierSchema,
  featured: z.boolean(),
  isPrestige: z.boolean(),
  prestigeScore: z.number().nullable(),
  distanceKm: z.number().nullable()
});

export const salonListQuerySchema = z.object({
  city: z.string().optional(),
  category: z.string().optional(),
  search: z.string().optional(),
  page: z.coerce.number().int().min(0).default(0),
  pageSize: z.coerce.number().int().min(1).max(50).default(20),
  lat: z.coerce.number().min(-90).max(90).optional(),
  lng: z.coerce.number().min(-180).max(180).optional(),
  sort: z.enum(["nearby", "rating", "trending"]).optional()
});

export const salonDetailSchema = salonSummarySchema.extend({
  description: z.string(),
  address: z.string(),
  gallery: z.array(z.string().url()),
  services: z.array(serviceSummarySchema),
  teamDisplay: salonTeamDisplaySchema,
  staff: z.array(salonStaffSummarySchema)
});
