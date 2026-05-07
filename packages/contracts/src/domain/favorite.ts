import { z } from "zod";

import { salonSummarySchema } from "./salon.js";

export const favoriteItemSchema = salonSummarySchema.extend({
  featured: z.boolean(),
  distanceKm: z.number().nullable()
});

export const favoriteListResponseSchema = z.object({
  items: z.array(favoriteItemSchema)
});

export type FavoriteItem = z.infer<typeof favoriteItemSchema>;
export type FavoriteListResponse = z.infer<typeof favoriteListResponseSchema>;
