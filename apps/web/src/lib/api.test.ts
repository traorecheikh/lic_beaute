import { beforeEach, describe, expect, it, vi } from "vitest";

import { ApiError, fetchAdminDashboard, registerAdminSessionController } from "./api";

describe("admin api auth retry", () => {
  let accessToken = "stale-access";
  let refreshToken = "stale-refresh";
  let cleared = false;

  beforeEach(() => {
    accessToken = "stale-access";
    refreshToken = "stale-refresh";
    cleared = false;
    vi.restoreAllMocks();
    registerAdminSessionController({
      getAccessToken: () => accessToken,
      getRefreshToken: () => refreshToken,
      applySession: (session) => {
        accessToken = session.accessToken;
        refreshToken = session.refreshToken;
      },
      clearSessionIfRefreshTokenMatches: (attemptedRefreshToken) => {
        if (refreshToken === attemptedRefreshToken) {
          cleared = true;
        }
      }
    });
  });

  it("refreshes once and retries an authenticated request", async () => {
    const fetchMock = vi.spyOn(globalThis, "fetch")
      .mockResolvedValueOnce(new Response(JSON.stringify({ code: "missing_auth", message: "Unauthorized" }), { status: 401 }))
      .mockResolvedValueOnce(new Response(JSON.stringify({
        accessToken: "fresh-access",
        refreshToken: "fresh-refresh",
        expiresInSeconds: 900
      }), { status: 200 }))
      .mockResolvedValueOnce(new Response(JSON.stringify({ ok: true }), { status: 200 }));

    const result = await fetchAdminDashboard("stale-access");

    expect(result).toEqual({ ok: true });
    expect(fetchMock).toHaveBeenCalledTimes(3);
    expect(fetchMock.mock.calls[2]?.[1]).toMatchObject({
      headers: expect.objectContaining({
        authorization: "Bearer fresh-access"
      })
    });
    expect(cleared).toBe(false);
  });

  it("does not clear a newer session when an older refresh attempt fails", async () => {
    vi.spyOn(globalThis, "fetch")
      .mockResolvedValueOnce(new Response(JSON.stringify({ code: "missing_auth", message: "Unauthorized" }), { status: 401 }))
      .mockImplementationOnce(async () => {
        refreshToken = "new-refresh";
        return new Response(JSON.stringify({ code: "session_expired", message: "Expired" }), { status: 401 });
      });

    await expect(fetchAdminDashboard("stale-access")).rejects.toBeInstanceOf(ApiError);
    expect(cleared).toBe(false);
  });
});
