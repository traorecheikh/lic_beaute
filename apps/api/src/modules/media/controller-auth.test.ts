import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const prisma = {
    mediaAsset: {
      findMany: vi.fn(),
      findFirst: vi.fn()
    }
  };
  return { requireRole, fail, ok, handleError, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
});
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../adapters/index.js", () => ({ getStorageAdapter: vi.fn(() => ({ store: vi.fn(), retrieve: vi.fn(), delete: vi.fn() })) }));

import { HttpAuthError } from "../../lib/auth/index.js";
import { MediaController } from "./index.js";

describe("MediaController auth failures", () => {
  const c = new MediaController();
  const rep = {} as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(401, "missing_auth", "No auth");
    });
  });

  it("blocks protected media endpoints", async () => {
    await c.upload({ body: {} } as never, rep);
    await c.uploadIntent({ body: {} } as never, rep);
    await c.completeUpload({ params: { mediaId: "m1" }, body: {} } as never, rep);
    await c.get({ params: { mediaId: "m1" } } as never, rep);
    await c.delete({ params: { mediaId: "m1" } } as never, rep);
    expect(mocks.fail.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });

  it("keeps registration-doc upload public for pre-registration flow", async () => {
    await c.uploadRegistrationDoc({ file: vi.fn().mockResolvedValue(null) } as never, rep);
    expect(mocks.requireRole).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 400, "file_required", expect.any(String));
  });
});
