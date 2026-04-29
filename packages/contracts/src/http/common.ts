import { z } from "zod";

export const apiErrorSchema = z.object({
  code: z.string(),
  message: z.string()
});

export function paginatedResponse<T extends z.ZodTypeAny>(itemSchema: T) {
  return z.object({
    items: z.array(itemSchema),
    total: z.number().int().nonnegative()
  });
}

