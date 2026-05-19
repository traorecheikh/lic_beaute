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

import { getR2Adapter, getStorageAdapter } from "../../adapters/index.js";
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

export class MediaController {
  async upload(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        r2AccountId: config.r2AccountId,
        r2AccessKeyId: config.r2AccessKeyId,
        r2SecretAccessKey: config.r2SecretAccessKey,
        r2Bucket: config.r2Bucket,
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
      // Non-admin callers cannot assign a foreign salonId — always use their own.
      const resolvedSalonId = session.role === "platform_admin"
        ? (typeof salonIdValue === "string" && salonIdValue.length > 0 ? salonIdValue : owner?.salonId ?? null)
        : (owner?.salonId ?? null);
      const purpose = mediaPurposeSchema.parse(purposeValue);

      // Media limit check
      if (resolvedSalonId && purpose === "salon_gallery") {
        const salon = await prisma.salon.findUnique({
          where: { id: resolvedSalonId },
          select: { subscriptionTier: true }
        });
        const currentCount = await prisma.mediaAsset.count({
          where: { salonId: resolvedSalonId, purpose: "salon_gallery", deletedAt: null }
        });

        if (salon?.subscriptionTier === "standard" && currentCount >= 3) {
          fail(reply, 422, "gallery_limit_reached", "Limite de 3 photos atteinte pour le plan Standard.");
          return;
        }

        if (salon?.subscriptionTier === "premium" && currentCount >= 50) {
          fail(reply, 422, "gallery_limit_reached", "Limite de 50 photos atteinte.");
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
          publicUrl: config.storageDriver !== "r2" ? storage.publicUrl(objectKey) : null,
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

      ok(reply, { assetId: asset.id, uploadStatus: "review_pending", reviewStatus: "pending" }, 201);
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

      getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        r2AccountId: config.r2AccountId,
        r2AccessKeyId: config.r2AccessKeyId,
        r2SecretAccessKey: config.r2SecretAccessKey,
        r2Bucket: config.r2Bucket,
        mediaPublicBaseUrl: config.mediaPublicBaseUrl
      });

      const r2 = getR2Adapter();
      if (!r2) {
        fail(reply, 503, "storage_unavailable", "Service de stockage non configuré.");
        return;
      }

      const fileExt = mimeToExt(body.mimeType);
      const objectKey = `incoming/${randomUUID()}${fileExt}`;
      const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

      const user = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true } });
      // Non-admin callers cannot assign a foreign salonId — always use their own.
      const resolvedSalonId = session.role === "platform_admin"
        ? (body.salonId ?? user?.salonId ?? null)
        : (user?.salonId ?? null);

      // Media limit check
      if (resolvedSalonId && body.purpose === "salon_gallery") {
        const salon = await prisma.salon.findUnique({
          where: { id: resolvedSalonId },
          select: { subscriptionTier: true }
        });
        const currentCount = await prisma.mediaAsset.count({
          where: { salonId: resolvedSalonId, purpose: "salon_gallery", deletedAt: null }
        });

        if (salon?.subscriptionTier === "standard" && currentCount >= 3) {
          fail(reply, 422, "gallery_limit_reached", "Limite de 3 photos atteinte pour le plan Standard.");
          return;
        }

        if (salon?.subscriptionTier === "premium" && currentCount >= 50) {
          fail(reply, 422, "gallery_limit_reached", "Limite de 50 photos atteinte.");
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

      const uploadUrl = await r2.presignPut(objectKey, body.mimeType, 300);

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
      if (asset.uploadStatus !== "pending_upload") {
        fail(reply, 409, "already_completed", "Upload déjà confirmé."); return;
      }

      const r2 = getR2Adapter();
      if (r2) {
        const head = await r2.headObject(asset.objectKey);
        if (!head) { fail(reply, 422, "upload_not_found", "Fichier non trouvé dans le stockage. Veuillez réessayer."); return; }
        await prisma.mediaAsset.update({
          where: { id: asset.id },
          data: { sizeBytes: head.sizeBytes, uploadStatus: "review_pending" }
        });
      } else {
        await prisma.mediaAsset.update({
          where: { id: asset.id },
          data: { uploadStatus: "review_pending" }
        });
      }

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
      if (config.storageDriver === "r2" && objectKey) {
        // Allowlist: object keys are UUIDs + path segments, never contain protocol or domain chars.
        if (!/^[\w\-.\/]+$/.test(objectKey) || objectKey.includes("..")) {
          fail(reply, 400, "invalid_key", "Clé de ressource invalide.");
          return;
        }
        const base = new URL(config.mediaPublicBaseUrl);
        base.pathname = (base.pathname.replace(/\/$/, "") + "/" + objectKey.replace(/^\//, ""));
        reply.redirect(base.toString());
        return;
      }
      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        r2AccountId: config.r2AccountId,
        r2AccessKeyId: config.r2AccessKeyId,
        r2SecretAccessKey: config.r2SecretAccessKey,
        r2Bucket: config.r2Bucket,
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
      requireRole(request, ["salon_owner"]);
      const storage = getStorageAdapter(config.storageDriver, {
        storagePath: config.storagePath,
        r2AccountId: config.r2AccountId,
        r2AccessKeyId: config.r2AccessKeyId,
        r2SecretAccessKey: config.r2SecretAccessKey,
        r2Bucket: config.r2Bucket,
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
