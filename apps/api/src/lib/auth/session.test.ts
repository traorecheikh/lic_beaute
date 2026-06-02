import { describe, expect, it } from "vitest";
import jwt from "jsonwebtoken";

import { signSession, verifyAccessToken, verifyRefreshToken } from "./session.js";
import { config } from "../../config.js";

describe("auth/session", () => {
  it("signSession returns both tokens and expiry", () => {
    const session = signSession("u1", "client");
    expect(typeof session.accessToken).toBe("string");
    expect(typeof session.refreshToken).toBe("string");
    expect(session.expiresInSeconds).toBeGreaterThan(0);
  });

  it("verifyAccessToken accepts signed token", () => {
    const session = signSession("u2", "platform_admin");
    const payload = verifyAccessToken(session.accessToken);
    expect(payload).toEqual({ sub: "u2", role: "platform_admin", tv: 0 });
  });

  it("verifyRefreshToken accepts refresh token", () => {
    const session = signSession("u3", "salon_owner");
    const payload = verifyRefreshToken(session.refreshToken);
    expect(payload).toEqual({ sub: "u3" });
  });

  it("rejects malformed refresh token payload", () => {
    expect(() => verifyRefreshToken("not-a-jwt")).toThrow();
  });

  it("rejects malformed access token payload", () => {
    expect(() => verifyAccessToken("not-a-jwt")).toThrow();
  });

  it("rejects signed refresh payload missing sub", () => {
    const token = jwt.sign({ type: "refresh" }, config.jwtRefreshSecret, { expiresIn: 60 });
    expect(() => verifyRefreshToken(token)).toThrowError("invalid_refresh_token");
  });

  it("rejects signed access payload with unsupported role", () => {
    const token = jwt.sign({ sub: "u1", role: "bad_role" }, config.jwtAccessSecret, { expiresIn: 60 });
    expect(() => verifyAccessToken(token)).toThrowError("invalid_access_token");
  });
});
