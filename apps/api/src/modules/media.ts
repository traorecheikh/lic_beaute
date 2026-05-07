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

import { uploadCompleteInputSchema, uploadIntentInputSchema } from "@beauteavenue/contracts";

import { getR2Adapter, getStorageAdapter } from "../adapters/index.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { prisma } from "../lib/prisma.js";

export class MediaController {
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
      const ownerType = user?.salonId ? "salon" : "user";
      const ownerId = user?.salonId ?? session.sub;

      const asset = await prisma.mediaAsset.create({
        data: {
          ownerType,
          ownerId,
          salonId: body.salonId ?? user?.salonId ?? null,
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

      await prisma.job.create({
        data: {
          queue: "notifications",
          type: "media_review_notify",
          payloadJson: JSON.stringify({ mediaId: asset.id, salonId: asset.salonId }),
          status: "pending"
        }
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

  async get(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { mediaId: string };
    const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
    if (!asset || asset.deletedAt) { fail(reply, 404, "media_not_found", "Fichier introuvable."); return; }
    ok(reply, { id: asset.id, publicUrl: asset.publicUrl, mimeType: asset.mimeType, createdAt: asset.createdAt.toISOString() });
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
        await tx.job.create({
          data: { queue: "storage", type: "media_cleanup", payloadJson: JSON.stringify({ objectKey: asset.objectKey }), status: "pending" }
        });
      });

      ok(reply, { deleted: true });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}
