import type { FastifyReply, FastifyRequest } from "fastify";

import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { prisma } from "../lib/prisma.js";

export class NotificationController {
  async list(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const q = request.query as { page?: string; pageSize?: string };
      const page = Math.max(0, parseInt(q.page ?? "0", 10));
      const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

      const [items, total] = await Promise.all([
        prisma.notification.findMany({
          where: { userId: session.sub },
          orderBy: { createdAt: "desc" },
          take: pageSize,
          skip: page * pageSize
        }),
        prisma.notification.count({ where: { userId: session.sub } })
      ]);

      ok(reply, {
        items: items.map((n) => ({
          id: n.id,
          title: n.title,
          body: n.body,
          channel: n.channel,
          readAt: n.readAt?.toISOString() ?? null,
          createdAt: n.createdAt.toISOString()
        })),
        total,
        unreadCount: await prisma.notification.count({ where: { userId: session.sub, readAt: null } })
      });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async markRead(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const params = request.params as { id: string };
      const notification = await prisma.notification.findFirst({
        where: { id: params.id, userId: session.sub }
      });
      if (!notification) { fail(reply, 404, "notification_not_found", "Notification introuvable."); return; }
      await prisma.notification.update({ where: { id: params.id }, data: { readAt: new Date() } });
      ok(reply, { read: true });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async registerPushToken(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const body = request.body as { token: string; platform: "ios" | "android"; deviceId: string };

      await prisma.pushToken.upsert({
        where: { token: body.token },
        create: { userId: session.sub, token: body.token, platform: body.platform, deviceId: body.deviceId },
        update: { userId: session.sub, revokedAt: null }
      });

      ok(reply, { registered: true }, 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async revokePushToken(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["platform_admin", "client", "salon_owner", "salon_staff"]);
      const params = request.params as { tokenId: string };
      const token = await prisma.pushToken.findFirst({ where: { id: params.tokenId, userId: session.sub } });
      if (!token) { fail(reply, 404, "token_not_found", "Token introuvable."); return; }
      await prisma.pushToken.update({ where: { id: params.tokenId }, data: { revokedAt: new Date() } });
      ok(reply, { revoked: true });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}

export async function sendNotification(userId: string, title: string, body: string) {
  await prisma.notification.create({
    data: { userId, title, body, channel: "push" }
  });
}
