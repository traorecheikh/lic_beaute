import { randomUUID } from "node:crypto";

import type { FastifyReply, FastifyRequest } from "fastify";

const MIME_TO_EXT: Record<string, string> = {
  "image/jpeg": ".jpg",
  "image/png": ".png",
  "image/webp": ".webp",
  "image/gif": ".gif",
  "image/heic": ".heic",
  "image/heif": ".heif",
  "application/pdf": ".pdf"
};

function mimeToExt(mimeType: string): string {
  return MIME_TO_EXT[mimeType] ?? ".bin";
}

import { mediaPurposeSchema, uploadCompleteInputSchema, uploadIntentInputSchema } from "@beauteavenue/contracts";

import { getStorageAdapter } from "../../adapters/index.js";
import { config } from "../../config.js";
import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { invalidateCacheTags } from "../../lib/cache.js";
import { fail, ok } from "../../lib/http.js";
import { enqueueJob } from "../../lib/jobs.js";
import { logger } from "../../lib/logger.js";
import { prisma } from "../../lib/db/prisma.js";

const ALLOWED_UPLOAD_MIME_TYPES = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/gif",
  "image/heic",
  "image/heif",
  "application/pdf"
]);

function readMultipartFieldValue(fields: Record<string, unknown>, key: string): string | undefined {
  const raw = fields[key];
  if (!raw) return undefined;
  const part = Array.isArray(raw) ? raw[0] : raw;
  if (!part || typeof part !== "object") return undefined;
  const value = (part as { value?: unknown }).value;
  return typeof value === "string" ? value : undefined;
}

const LOCKED_SUBSCRIPTION_STATUSES = new Set(["inactive", "paused", "cancelled", "expired"]);

async function ensureSalonWriteAccessIfNeeded(
  params: { role: string; salonId: string | null | undefined },
  reply: FastifyReply
): Promise<boolean> {
  if (!["salon_owner", "salon_staff", "salon_manager"].includes(params.role)) return true;
  if (!params.salonId) {
    fail(reply, 403, "not_in_salon", "Vous n'êtes associé à aucun salon.");
    return false;
  }
  const salon = await prisma.salon.findUnique({
    where: { id: params.salonId },
    select: { subscription: { select: { status: true } } }
  });
  const status = salon?.subscription?.status;
  if (!status || LOCKED_SUBSCRIPTION_STATUSES.has(status)) {
    fail(reply, 402, "subscription_required", "Abonnement requis pour effectuer cette action. Activez votre abonnement.");
    return false;
  }
  return true;
}

export class MediaController {
  async upload(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        mediaPublicBaseUrl: config.mediaPublicBaseUrl
      });

      const file = await request.file({ limits: { files: 1, fileSize: config.maxUploadBytes } });
      if (!file) {
        fail(reply, 400, "file_required", "Aucun fichier reçu.");
        return;
      }

      const fields = file.fields as Record<string, unknown>;
      const purposeValue = readMultipartFieldValue(fields, "purpose");
      const salonIdValue = readMultipartFieldValue(fields, "salonId");
      const originalFilename = file.filename;
      const mimeType = file.mimetype;

      if (typeof purposeValue !== "string" || purposeValue.length === 0) {
        fail(reply, 422, "invalid_purpose", "Le champ purpose est requis.");
        return;
      }

      if (typeof originalFilename !== "string" || originalFilename.length === 0) {
        fail(reply, 422, "invalid_filename", "Nom de fichier invalide.");
        return;
      }

      if (!ALLOWED_UPLOAD_MIME_TYPES.has(mimeType)) {
        fail(reply, 415, "unsupported_media_type", "Type de fichier non supporté.");
        return;
      }

      const owner = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true } });
      if (!(await ensureSalonWriteAccessIfNeeded({ role: session.role, salonId: owner?.salonId }, reply))) return;
      // Non-admin callers cannot assign a foreign salonId — always use their own.
      const resolvedSalonId = session.role === "platform_admin"
        ? (typeof salonIdValue === "string" && salonIdValue.length > 0 ? salonIdValue : owner?.salonId ?? null)
        : (owner?.salonId ?? null);
      const purpose = mediaPurposeSchema.parse(purposeValue);

      // Gallery limit check — count only SAVED gallery photos (SalonGalleryImage),
      // not temporary uploads (MediaAsset). Uploaded but unsaved photos are ephemeral
      // and must not permanently consume quota (e.g. page reload discards them).
      if (resolvedSalonId && purpose === "salon_gallery") {
        const salon = await prisma.salon.findUnique({
          where: { id: resolvedSalonId },
          select: { subscriptionTier: true }
        });
        const savedCount = await prisma.salonGalleryImage.count({
          where: { salonId: resolvedSalonId }
        });

        const limit = salon?.subscriptionTier === "premium" ? 50 : 3;

        if (savedCount >= limit) {
          fail(reply, 422, "gallery_limit_reached", `Limite de ${limit} photos atteinte pour le plan ${salon?.subscriptionTier ?? "Standard"}.`);
          return;
        }
      }

      const fileExt = mimeToExt(mimeType);
      const objectKey = `incoming/${randomUUID()}${fileExt}`;
      const ownerType = owner?.salonId ? "salon" : "user";
      const ownerId = owner?.salonId ?? session.sub;

      const sizeBytes = await storage.store(objectKey, file.file, mimeType);
      if (sizeBytes <= 0 || sizeBytes > config.maxUploadBytes) {
        await storage.delete(objectKey).catch(() => {});
        fail(reply, 422, "invalid_upload_size", "Fichier invalide ou vide.");
        return;
      }

      const asset = await prisma.mediaAsset.create({
        data: {
          ownerType,
          ownerId,
          salonId: resolvedSalonId,
          uploadedBy: session.sub,
          objectKey,
          publicUrl: storage.publicUrl(objectKey),
          mimeType,
          sizeBytes,
          purpose,
          originalFilename,
          fileExt,
          uploadStatus: "review_pending",
          reviewStatus: "pending",
          visibility: "incoming"
        }
      });

      await enqueueJob({
        type: "media_review_notify",
        payload: { mediaId: asset.id, salonId: asset.salonId ?? "" }
      });

      ok(reply, { assetId: asset.id, publicUrl: asset.publicUrl, uploadStatus: "review_pending", reviewStatus: "pending" }, 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Media upload error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async uploadIntent(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const body = uploadIntentInputSchema.parse(request.body);

      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        mediaPublicBaseUrl: config.mediaPublicBaseUrl
      });

      const fileExt = mimeToExt(body.mimeType);
      const objectKey = `incoming/${randomUUID()}${fileExt}`;
      const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

      const user = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true } });
      if (!(await ensureSalonWriteAccessIfNeeded({ role: session.role, salonId: user?.salonId }, reply))) return;
      // Non-admin callers cannot assign a foreign salonId — always use their own.
      const resolvedSalonId = session.role === "platform_admin"
        ? (body.salonId ?? user?.salonId ?? null)
        : (user?.salonId ?? null);

      // Gallery limit check — count only SAVED gallery photos (SalonGalleryImage).
      if (resolvedSalonId && body.purpose === "salon_gallery") {
        const salon = await prisma.salon.findUnique({
          where: { id: resolvedSalonId },
          select: { subscriptionTier: true }
        });
        const savedCount = await prisma.salonGalleryImage.count({
          where: { salonId: resolvedSalonId }
        });

        const limit = salon?.subscriptionTier === "premium" ? 50 : 3;

        if (savedCount >= limit) {
          fail(reply, 422, "gallery_limit_reached", `Limite de ${limit} photos atteinte pour le plan ${salon?.subscriptionTier ?? "Standard"}.`);
          return;
        }
      }

      const ownerType = user?.salonId ? "salon" : "user";
      const ownerId = user?.salonId ?? session.sub;

      const asset = await prisma.mediaAsset.create({
        data: {
          ownerType,
          ownerId,
          salonId: resolvedSalonId,
          uploadedBy: session.sub,
          objectKey,
          mimeType: body.mimeType,
          sizeBytes: body.sizeBytes,
          purpose: body.purpose,
          originalFilename: body.originalFilename,
          fileExt,
          uploadStatus: "pending_upload",
          reviewStatus: "pending",
          visibility: "incoming"
        }
      });

      // Presigned URL flow is only available with storage adapters that support it
      const uploadUrl = storage.presignPut(objectKey, body.mimeType, 300);

      ok(reply, { assetId: asset.id, uploadUrl, expiresAt: expiresAt.toISOString() }, 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Media uploadIntent error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async completeUpload(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const params = request.params as { mediaId: string };
      uploadCompleteInputSchema.parse(request.body);

      const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
      if (!asset || asset.deletedAt) { fail(reply, 404, "media_not_found", "Fichier introuvable."); return; }
      if (asset.uploadedBy !== session.sub && session.role !== "platform_admin") {
        fail(reply, 403, "forbidden", "Accès interdit."); return;
      }
      const user = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true } });
      if (!(await ensureSalonWriteAccessIfNeeded({ role: session.role, salonId: user?.salonId }, reply))) return;
      if (asset.uploadStatus !== "pending_upload") {
        fail(reply, 409, "already_completed", "Upload déjà confirmé."); return;
      }

      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        mediaPublicBaseUrl: config.mediaPublicBaseUrl
      });

      const head = await storage.headObject(asset.objectKey);
      if (!head) { fail(reply, 422, "upload_not_found", "Fichier non trouvé dans le stockage. Veuillez réessayer."); return; }
      await prisma.mediaAsset.update({
        where: { id: asset.id },
        data: { sizeBytes: head.sizeBytes, uploadStatus: "review_pending" }
      });

      await enqueueJob({
        type: "media_review_notify",
        payload: { mediaId: asset.id, salonId: asset.salonId ?? "" }
      });

      ok(reply, { assetId: asset.id, uploadStatus: "review_pending", reviewStatus: "pending" });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Media completeUpload error", { error });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async getPublicMedia(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { salonId: string };
    const assets = await prisma.mediaAsset.findMany({
      where: {
        salonId: params.salonId,
        reviewStatus: "approved",
        visibility: "public",
        deletedAt: null
      },
      orderBy: [{ displayOrder: "asc" }, { createdAt: "asc" }]
    });

    ok(reply, {
      items: assets.map((a) => ({
        id: a.id,
        publicUrl: a.publicUrl,
        purpose: a.purpose,
        mimeType: a.mimeType,
        displayOrder: a.displayOrder,
        createdAt: a.createdAt.toISOString()
      }))
    });
  }

  async getPublicFile(request: FastifyRequest, reply: FastifyReply) {
    try {
      const params = request.params as { mediaId: string };
      const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
      if (!asset || asset.deletedAt || asset.reviewStatus !== "approved" || asset.visibility !== "public") {
        fail(reply, 404, "media_not_found", "Fichier introuvable.");
        return;
      }

      const objectKey = asset.finalObjectKey ?? asset.objectKey;
      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        mediaPublicBaseUrl: config.mediaPublicBaseUrl
      });

      const data = await storage.retrieve(objectKey);
      if (!data) {
        fail(reply, 404, "media_not_found", "Fichier introuvable.");
        return;
      }

      reply.type(asset.mimeType).header("Cache-Control", "public, max-age=300").send(data);
    } catch (error) {
      logger.error("Media getPublicFile error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async get(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const params = request.params as { mediaId: string };
      const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
      if (!asset || asset.deletedAt) { fail(reply, 404, "media_not_found", "Fichier introuvable."); return; }

      const user = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true, role: true } });
      if (!(await ensureSalonWriteAccessIfNeeded({ role: session.role, salonId: user?.salonId }, reply))) return;
      const isOwner =
        (asset.ownerType === "user" && asset.ownerId === session.sub) ||
        (asset.ownerType === "salon" && user?.salonId === asset.ownerId) ||
        user?.role === "platform_admin";
      if (!isOwner) { fail(reply, 403, "forbidden", "Accès interdit."); return; }

      ok(reply, { id: asset.id, publicUrl: asset.publicUrl, mimeType: asset.mimeType, createdAt: asset.createdAt.toISOString() });
    } catch (err) {
      if (err instanceof HttpAuthError) { fail(reply, err.statusCode, err.code, err.message); return; }
      throw err;
    }
  }

  async delete(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const params = request.params as { mediaId: string };
      const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
      if (!asset || asset.deletedAt) { fail(reply, 404, "media_not_found", "Fichier introuvable."); return; }

      const user = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true, role: true } });
      const isOwner =
        (asset.ownerType === "user" && asset.ownerId === session.sub) ||
        (asset.ownerType === "salon" && user?.salonId === asset.ownerId) ||
        user?.role === "platform_admin";

      if (!isOwner) { fail(reply, 403, "forbidden", "Accès interdit."); return; }

      await prisma.$transaction(async (tx) => {
        await tx.mediaAsset.update({ where: { id: params.mediaId }, data: { deletedAt: new Date() } });
        await enqueueJob({
          type: "media_cleanup",
          payload: { objectKey: asset.objectKey },
          dbClient: tx
        });
      });
      if (asset.salonId) await invalidateCacheTags([`catalog:salon:${asset.salonId}`]);

      ok(reply, { deleted: true });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async uploadRegistrationDoc(request: FastifyRequest, reply: FastifyReply) {
    try {
      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        mediaPublicBaseUrl: config.mediaPublicBaseUrl
      });
      const file = await request.file({ limits: { files: 1, fileSize: 5 * 1024 * 1024 } });
      if (!file) { fail(reply, 400, "file_required", "Aucun fichier reçu."); return; }
      if (!ALLOWED_UPLOAD_MIME_TYPES.has(file.mimetype)) {
        fail(reply, 415, "unsupported_media_type", "Type de fichier non supporté.");
        return;
      }
      const objectKey = `registration/${randomUUID()}${mimeToExt(file.mimetype)}`;
      const sizeBytes = await storage.store(objectKey, file.file, file.mimetype);
      if (sizeBytes <= 0) { fail(reply, 422, "invalid_upload_size", "Fichier invalide ou vide."); return; }
      const url = storage.publicUrl(objectKey);
      ok(reply, { url }, 201);
    } catch (error) {
      logger.error("Registration doc upload error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}