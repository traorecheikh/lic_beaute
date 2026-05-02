import { randomUUID } from "node:crypto";
import { extname } from "node:path";

import type { FastifyReply, FastifyRequest } from "fastify";

import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { prisma } from "../lib/prisma.js";

export class MediaController {
  async upload(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const data = await request.file();
      if (!data) { fail(reply, 400, "no_file", "Aucun fichier reçu."); return; }
      if (!data.mimetype.startsWith("image/")) {
        fail(reply, 422, "invalid_media_type", "Seules les images sont acceptées.");
        return;
      }

      const ext = extname(data.filename) || ".bin";
      const objectKey = `uploads/${randomUUID()}${ext}`;
      const publicUrl = `/static/${objectKey}`;

      // Noop: consume stream without writing anywhere
      await data.toBuffer();

      const user = await prisma.user.findUnique({ where: { id: session.sub }, select: { salonId: true } });
      const ownerType = user?.salonId ? "salon" : "user";
      const ownerId = user?.salonId ?? session.sub;

      const asset = await prisma.mediaAsset.create({
        data: { ownerType, ownerId, objectKey, publicUrl, mimeType: data.mimetype, sizeBytes: 0 }
      });

      ok(reply, { id: asset.id, publicUrl: asset.publicUrl, objectKey: asset.objectKey }, 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("Media error", { error: String(error) });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
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
