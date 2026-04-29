import { z } from "zod";

export const reviewCreateInputSchema = z.object({
  rating: z.number().int().min(1).max(5),
  comment: z.string().max(1000).optional()
});

export const reviewSchema = z.object({
  id: z.string(),
  rating: z.number().int().min(1).max(5),
  comment: z.string().nullable(),
  createdAt: z.string().datetime(),
  responseText: z.string().nullable(),
  responseAt: z.string().datetime().nullable()
});

export type ReviewCreateInput = z.infer<typeof reviewCreateInputSchema>;
export type Review = z.infer<typeof reviewSchema>;
