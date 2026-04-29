import { randomUUID } from "node:crypto";

import jwt from "jsonwebtoken";

import { config } from "../config.js";

export type AccessTokenRole = "platform_admin" | "client" | "salon_owner" | "salon_staff";

export type AccessTokenPayload = {
  sub: string;
  role: AccessTokenRole;
};

export function signSession(subject: string, role: AccessTokenRole) {
  const accessToken = jwt.sign({ sub: subject, role }, config.jwtAccessSecret, {
    expiresIn: config.jwtAccessTtlSeconds
  });
  const refreshToken = jwt.sign({ sub: subject, type: "refresh", jti: randomUUID() }, config.jwtRefreshSecret, {
    expiresIn: config.jwtRefreshTtlSeconds
  });

  return {
    accessToken,
    refreshToken,
    expiresInSeconds: config.jwtAccessTtlSeconds
  };
}

export function verifyRefreshToken(token: string): { sub: string } {
  const payload = jwt.verify(token, config.jwtRefreshSecret);
  if (typeof payload !== "object" || payload === null || typeof payload.sub !== "string") {
    throw new Error("invalid_refresh_token");
  }
  return { sub: payload.sub };
}

export function verifyAccessToken(token: string): AccessTokenPayload {
  const payload = jwt.verify(token, config.jwtAccessSecret);

  if (
    typeof payload !== "object" ||
    payload === null ||
    typeof payload.sub !== "string" ||
    typeof payload.role !== "string"
  ) {
    throw new Error("invalid_access_token");
  }

  return {
    sub: payload.sub,
    role: payload.role as AccessTokenRole
  };
}

