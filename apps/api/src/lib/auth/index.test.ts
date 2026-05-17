import { describe, expect, it, vi } from "vitest";

vi.mock("./session.js", () => ({
  verifyAccessToken: vi.fn()
}));

import { verifyAccessToken } from "./session.js";
import { HttpAuthError, requireRole } from "./index.js";

describe("auth requireRole", () => {
  it("throws missing_auth when no header", () => {
    expect(() => requireRole({ headers: {} } as never, ["client"])).toThrowError(HttpAuthError);
    try {
      requireRole({ headers: {} } as never, ["client"]);
    } catch (e) {
      const err = e as HttpAuthError;
      expect(err.code).toBe("missing_auth");
    }
  });

  it("throws invalid scheme", () => {
    expect(() => requireRole({ headers: { authorization: "Basic a" } } as never, ["client"])).toThrowError(HttpAuthError);
  });

  it("throws forbidden role", () => {
    vi.mocked(verifyAccessToken).mockReturnValue({ sub: "u1", role: "client" });
    expect(() => requireRole({ headers: { authorization: "Bearer t" } } as never, ["platform_admin"])).toThrowError(HttpAuthError);
  });

  it("returns payload when role allowed", () => {
    vi.mocked(verifyAccessToken).mockReturnValue({ sub: "u1", role: "client" });
    const payload = requireRole({ headers: { authorization: "Bearer t" } } as never, ["client"]);
    expect(payload).toEqual({ sub: "u1", role: "client" });
  });

  it("maps session errors to invalid_token", () => {
    vi.mocked(verifyAccessToken).mockImplementation(() => {
      throw new Error("jwt");
    });
    expect(() => requireRole({ headers: { authorization: "Bearer t" } } as never, ["client"])).toThrowError(HttpAuthError);
    try {
      requireRole({ headers: { authorization: "Bearer t" } } as never, ["client"]);
    } catch (e) {
      const err = e as HttpAuthError;
      expect(err.code).toBe("invalid_token");
    }
  });
});

