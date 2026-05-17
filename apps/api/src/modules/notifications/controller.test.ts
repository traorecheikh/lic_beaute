import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const prisma = {
    notification: {
      findMany: vi.fn(),
      count: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn(),
      create: vi.fn()
    },
    pushToken: {
      findUnique: vi.fn(),
      upsert: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn(),
      findMany: vi.fn()
    }
  };
  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const sendPush = vi.fn();
  return { prisma, requireRole, ok, fail, sendPush };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/push.js", () => ({ sendPush: mocks.sendPush }));
vi.mock("../../lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));

import { HttpAuthError } from "../../lib/auth/index.js";
import { pushTokenRegisterSchema } from "@beauteavenue/contracts";
import { NotificationController, sendNotification } from "./index.js";

describe("NotificationController", () => {
  const controller = new NotificationController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
  });

  it("lists notifications with unread count", async () => {
    mocks.prisma.notification.findMany.mockResolvedValue([
      { id: "n1", title: "t", body: "b", channel: "push", readAt: null, createdAt: new Date() }
    ]);
    mocks.prisma.notification.count.mockResolvedValueOnce(1).mockResolvedValueOnce(1);

    await controller.list({ query: {} } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalled();
  });

  it("registers push token", async () => {
    mocks.prisma.pushToken.findUnique.mockResolvedValue(null);
    mocks.prisma.pushToken.upsert.mockResolvedValue({});

    await controller.registerPushToken({
      body: { token: "tok_1", platform: "ios", deviceId: "dev1" }
    } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { registered: true }, 201);
  });

  it("rejects push token already owned by another user", async () => {
    mocks.prisma.pushToken.findUnique.mockResolvedValue({
      token: "tok_1",
      revokedAt: null,
      userId: "other"
    });

    await controller.registerPushToken({
      body: { token: "tok_1", platform: "ios", deviceId: "dev1" }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "token_owned", expect.any(String));
  });

  it("marks one notification as read", async () => {
    mocks.prisma.notification.findFirst.mockResolvedValue({ id: "n1" });
    mocks.prisma.notification.update.mockResolvedValue({});
    await controller.markRead({ params: { id: "n1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { read: true });
  });

  it("returns 404 when marking unknown notification", async () => {
    mocks.prisma.notification.findFirst.mockResolvedValue(null);
    await controller.markRead({ params: { id: "n1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "notification_not_found", expect.any(String));
  });

  it("marks all as read", async () => {
    mocks.prisma.notification.updateMany.mockResolvedValue({ count: 2 });
    await controller.markAllRead({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { updated: true });
  });

  it("revokes push token", async () => {
    mocks.prisma.pushToken.findFirst.mockResolvedValue({ id: "t1" });
    mocks.prisma.pushToken.update.mockResolvedValue({});
    await controller.revokePushToken({ params: { tokenId: "t1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { revoked: true });
  });

  it("returns auth error on list", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(401, "missing_auth", "missing");
    });
    await controller.list({ query: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "missing_auth", "missing");
  });

  it("returns validation error for bad push token body", async () => {
    await controller.registerPushToken({ body: { token: "short" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 400, "validation_error", expect.any(String));
  });

  it("uses default validation message when zod issues list is empty", async () => {
    const spy = vi.spyOn(pushTokenRegisterSchema, "safeParse").mockReturnValueOnce({
      success: false,
      error: { issues: [] }
    } as any);
    await controller.registerPushToken({ body: { token: "short" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 400, "validation_error", "Données invalides.");
    spy.mockRestore();
  });

  it("returns 404 when token to revoke is missing", async () => {
    mocks.prisma.pushToken.findFirst.mockResolvedValue(null);
    await controller.revokePushToken({ params: { tokenId: "missing" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "token_not_found", expect.any(String));
  });

  it("sendNotification persists notification and pushes to active tokens", async () => {
    mocks.prisma.notification.create.mockResolvedValue({});
    mocks.prisma.pushToken.findMany.mockResolvedValue([{ token: "t1" }, { token: "t2" }]);
    await sendNotification("u1", "title", "body");
    expect(mocks.prisma.notification.create).toHaveBeenCalled();
    expect(mocks.sendPush).toHaveBeenCalledTimes(2);
  });

  it("registerPushToken allows reassignment from revoked token and logs warning path", async () => {
    mocks.prisma.pushToken.findUnique.mockResolvedValue({
      token: "tok_2",
      revokedAt: new Date(),
      userId: "old_user"
    });
    mocks.prisma.pushToken.upsert.mockResolvedValue({});
    await controller.registerPushToken({
      body: { token: "tok_2", platform: "android", deviceId: "dev2" }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { registered: true }, 201);
  });

  it("maps internal errors across notification endpoints", async () => {
    mocks.prisma.notification.findMany.mockRejectedValueOnce(new Error("db-list"));
    await controller.list({ query: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));

    mocks.prisma.notification.findFirst.mockResolvedValueOnce({ id: "n1" });
    mocks.prisma.notification.update.mockRejectedValueOnce(new Error("db-update"));
    await controller.markRead({ params: { id: "n1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));

    mocks.prisma.notification.updateMany.mockRejectedValueOnce(new Error("db-bulk"));
    await controller.markAllRead({} as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));

    mocks.prisma.pushToken.findUnique.mockResolvedValueOnce(null);
    mocks.prisma.pushToken.upsert.mockRejectedValueOnce(new Error("db-push"));
    await controller.registerPushToken({
      body: { token: "tok_3", platform: "ios", deviceId: "dev3" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));

    mocks.prisma.pushToken.findFirst.mockResolvedValueOnce({ id: "t2" });
    mocks.prisma.pushToken.update.mockRejectedValueOnce(new Error("db-revoke"));
    await controller.revokePushToken({ params: { tokenId: "t2" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });
});
