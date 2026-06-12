import { beforeEach, describe, expect, it, vi } from "vitest";

const refreshSession = vi.fn();

vi.mock("@/lib/generated", () => ({
  AuthApi: class {
    apiV1AuthRefreshPost = refreshSession;
  },
  Configuration: class {
    constructor(_config: unknown) {}
  },
  MediaApi: class {},
  NotificationsApi: class {},
  ProApi: class {}
}));

vi.mock("@/lib/generated/runtime", () => ({
  ResponseError: class ResponseError extends Error {
    response: Response;
    constructor(response: Response) {
      super("ResponseError");
      this.response = response;
    }
  }
}));

import { fetchPaymentMethods, registerProSessionController } from "./pro-api";

describe("pro api auth retry", () => {
  let accessToken = "stale-access";
  let refreshToken = "stale-refresh";
  let cleared = false;

  beforeEach(() => {
    accessToken = "stale-access";
    refreshToken = "stale-refresh";
    cleared = false;
    refreshSession.mockReset();
    vi.restoreAllMocks();
    registerProSessionController({
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

  it("retries raw fetch payment endpoints after a refresh", async () => {
    refreshSession.mockResolvedValue({
      accessToken: "fresh-access",
      refreshToken: "fresh-refresh",
      expiresInSeconds: 900
    });
    const fetchMock = vi.spyOn(globalThis, "fetch")
      .mockResolvedValueOnce(new Response(JSON.stringify({ code: "missing_auth", message: "Unauthorized" }), { status: 401 }))
      .mockResolvedValueOnce(new Response(JSON.stringify({ methods: [{ code: "wave_senegal" }] }), { status: 200 }));

    const result = await fetchPaymentMethods("stale-access");

    expect(result).toEqual({ methods: [{ code: "wave_senegal" }] });
    expect(refreshSession).toHaveBeenCalledWith({
      refreshInput: { refreshToken: "stale-refresh" }
    });
    const retryHeaders = fetchMock.mock.calls[1]?.[1]?.headers as Headers;
    expect(retryHeaders.get("Authorization")).toBe("Bearer fresh-access");
    expect(cleared).toBe(false);
  });
});
