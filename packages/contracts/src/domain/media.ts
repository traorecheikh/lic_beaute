import { z } from "zod";

export const mediaPurposeSchema = z.enum([
  "salon_cover",
  "salon_logo",
  "salon_gallery",
  "kyc_document",
  "avatar"
]);

export const uploadIntentInputSchema = z.object({
  salonId: z.string().optional(),
  purpose: mediaPurposeSchema,
  mimeType: z.string().regex(/^image\//),
  originalFilename: z.string().max(255),
  sizeBytes: z.number().int().positive().max(15 * 1024 * 1024)
});

export const uploadIntentResponseSchema = z.object({
  assetId: z.string(),
  uploadUrl: z.string(),
  expiresAt: z.string().datetime()
});

export const uploadCompleteInputSchema = z.object({
  checksum: z.string().optional()
});

export const uploadCompleteResponseSchema = z.object({
  assetId: z.string(),
  uploadStatus: z.string(),
  reviewStatus: z.string()
});

export const publicMediaItemSchema = z.object({
  id: z.string(),
  publicUrl: z.string(),
  purpose: mediaPurposeSchema,
  mimeType: z.string(),
  displayOrder: z.number().int(),
  createdAt: z.string().datetime()
});

export const adminMediaItemSchema = z.object({
  id: z.string(),
  salonId: z.string().nullable(),
  uploadedBy: z.string().nullable(),
  objectKey: z.string(),
  mimeType: z.string(),
  sizeBytes: z.number().int(),
  purpose: mediaPurposeSchema.nullable(),
  uploadStatus: z.string(),
  reviewStatus: z.string(),
  originalFilename: z.string().nullable(),
  createdAt: z.string().datetime()
});

export const adminMediaApproveInputSchema = z.object({
  purpose: z.enum(["salon_cover", "salon_logo", "salon_gallery"]).optional(),
  displayOrder: z.number().int().min(0).optional()
});

export const adminMediaRejectInputSchema = z.object({
  reason: z.string().min(1).max(500)
});

export const adminSignedViewUrlResponseSchema = z.object({
  signedUrl: z.string(),
  expiresAt: z.string().datetime()
});

export const mediaUploadResponseSchema = z.object({
  id: z.string(),
  publicUrl: z.string(),
  filename: z.string(),
  mimeType: z.string(),
  sizeBytes: z.number().int().nonnegative(),
  createdAt: z.string().datetime()
});

export const mediaAssetSchema = mediaUploadResponseSchema.extend({
  ownerType: z.string(),
  ownerId: z.string(),
  deletedAt: z.string().datetime().nullable()
});

export type MediaUploadResponse = z.infer<typeof mediaUploadResponseSchema>;
export type MediaAsset = z.infer<typeof mediaAssetSchema>;
export type UploadIntentInput = z.infer<typeof uploadIntentInputSchema>;
export type UploadIntentResponse = z.infer<typeof uploadIntentResponseSchema>;
export type AdminMediaItem = z.infer<typeof adminMediaItemSchema>;
