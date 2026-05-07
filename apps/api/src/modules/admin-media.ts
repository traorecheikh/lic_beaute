import type { FastifyReply, FastifyRequest } from "fastify";

import { adminMediaApproveInputSchema, adminMediaRejectInputSchema } from "@beauteavenue/contracts";

import { R2StorageAdapter } from "../adapters/storage-r2.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { prisma } from "../lib/prisma.js";
import { sendPushBatch } from "../lib/push.js";

function getR2Adapter(): R2StorageAdapter | null {
  if (config.storageDriver !== "r2") return null;
  return new R2StorageAdapter(
    config.r2AccountId,
    config.r2AccessKeyId,
    config.r2SecretAccessKey,
    config.r2Bucket,
    config.mediaPublicBaseUrl
  );
}

async function getSalonOwnerTokens(salonId: string): Promise<string[]> {
  const owners = await prisma.user.findMany({
    where: { salonId, role: "salon_owner" },
    include: { pushTokens: { where: { revokedAt: null } } }
  });
  return owners.flatMap((u) => u.pushTokens.map((t) => t.token));
}

export class AdminMediaController {
  async listPending(request: FastifyRequest, reply: FastifyReply) {
    try {
      requireRole(request, ["platform_admin"]);
      const q = request.query as { page?: string; pageSize?: string };
      const page = Math.max(0, parseInt(q.page ?? "0", 10));
      const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

      const [items, total] = await Promise.all([
        prisma.mediaAsset.findMany({
          where: { uploadStatus: "review_pending", deletedAt: null },
          orderBy: { createdAt: "asc" },
          take: pageSize,
          skip: page * pageSize
        }),
        prisma.mediaAsset.count({ where: { uploadStatus: "review_pending", deletedAt: null } })
      ]);

      ok(reply, {
        items: items.map((a) => ({
          id: a.id,
          salonId: a.salonId,
          uploadedBy: a.uploadedBy,
          objectKey: a.objectKey,
          mimeType: a.mimeType,
          sizeBytes: a.sizeBytes,
          purpose: a.purpose,
          uploadStatus: a.uploadStatus,
          reviewStatus: a.reviewStatus,
          originalFilename: a.originalFilename,
          createdAt: a.createdAt.toISOString()
        })),
        total,
        page,
        pageSize
      });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async signedViewUrl(request: FastifyRequest, reply: FastifyReply) {
    try {
      requireRole(request, ["platform_admin"]);
      const params = request.params as { mediaId: string };
      const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
      if (!asset || asset.deletedAt) { fail(reply, 404, "media_not_found", "Fichier introuvable."); return; }

      const r2 = getR2Adapter();
      if (!r2) { fail(reply, 503, "storage_unavailable", "Stockage non configuré."); return; }

      const signedUrl = await r2.presignGet(asset.objectKey, 300);
      const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

      ok(reply, { signedUrl, expiresAt: expiresAt.toISOString() });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async approve(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin"]);
      const params = request.params as { mediaId: string };
      const body = adminMediaApproveInputSchema.parse(request.body ?? {});

      const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
      if (!asset || asset.deletedAt) { fail(reply, 404, "media_not_found", "Fichier introuvable."); return; }
      if (asset.reviewStatus === "approved") { fail(reply, 409, "already_approved", "Déjà approuvé."); return; }

      const purpose = body.purpose ?? asset.purpose;
      const fileExt = asset.fileExt ?? ".jpg";
      const isPrivate = purpose === "kyc_document";
      const salonPrefix = asset.salonId ? `salons/${asset.salonId}` : `users/${asset.ownerId}`;
      const purposeDir = purpose ?? "gallery";
      const prefix = isPrivate ? "private_kyc" : "public";
      const finalObjectKey = `${prefix}/${salonPrefix}/${purposeDir}/${asset.id}${fileExt}`;
      const publicUrl = isPrivate ? null : `${config.mediaPublicBaseUrl}/${finalObjectKey}`;
      const visibility = isPrivate ? "private_kyc" : "public";

      const r2 = getR2Adapter();
      if (r2) {
        await r2.copyObject(asset.objectKey, finalObjectKey);
      }

      await prisma.mediaAsset.update({
        where: { id: asset.id },
        data: {
          finalObjectKey,
          publicUrl,
          purpose: purpose ?? asset.purpose,
          visibility,
          uploadStatus: "approved",
          reviewStatus: "approved",
          reviewedBy: session.sub,
          reviewedAt: new Date(),
          displayOrder: body.displayOrder ?? asset.displayOrder
        }
      });

      if (asset.salonId) {
        const tokens = await getSalonOwnerTokens(asset.salonId);
        if (tokens.length > 0) {
          await sendPushBatch(
            tokens,
            { title: "Photo approuvée", body: "Votre photo a été approuvée et est maintenant visible." },
            { type: "media_approved", mediaId: asset.id, salonId: asset.salonId }
          );
        }
      }

      logger.info("[ADMIN-MEDIA] approved", { mediaId: asset.id, adminId: session.sub });
      ok(reply, { approved: true, publicUrl });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Admin media approve error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async reject(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin"]);
      const params = request.params as { mediaId: string };
      const body = adminMediaRejectInputSchema.parse(request.body);

      const asset = await prisma.mediaAsset.findUnique({ where: { id: params.mediaId } });
      if (!asset || asset.deletedAt) { fail(reply, 404, "media_not_found", "Fichier introuvable."); return; }
      if (asset.reviewStatus === "rejected") { fail(reply, 409, "already_rejected", "Déjà rejeté."); return; }

      const r2 = getR2Adapter();
      if (r2) {
        const fileExt = asset.fileExt ?? ".bin";
        const rejectedKey = `rejected/${asset.salonId ?? asset.ownerId}/${asset.id}${fileExt}`;
        await r2.copyObject(asset.objectKey, rejectedKey).catch(() => {});
        await r2.deleteObject(asset.objectKey).catch(() => {});
      }

      await prisma.mediaAsset.update({
        where: { id: asset.id },
        data: {
          visibility: "rejected",
          uploadStatus: "rejected",
          reviewStatus: "rejected",
          rejectionReason: body.reason,
          reviewedBy: session.sub,
          reviewedAt: new Date()
        }
      });

      if (asset.salonId) {
        const tokens = await getSalonOwnerTokens(asset.salonId);
        if (tokens.length > 0) {
          await sendPushBatch(
            tokens,
            { title: "Photo refusée", body: `Votre photo a été refusée: ${body.reason}` },
            { type: "media_rejected", mediaId: asset.id, salonId: asset.salonId, reason: body.reason }
          );
        }
      }

      logger.info("[ADMIN-MEDIA] rejected", { mediaId: asset.id, adminId: session.sub, reason: body.reason });
      ok(reply, { rejected: true });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Admin media reject error", { error });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}
