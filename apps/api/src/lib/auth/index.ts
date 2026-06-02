import type { FastifyRequest } from "fastify";

import { verifyAccessToken, type AccessTokenPayload, type AccessTokenRole } from "./session.js";
import { prisma } from "../db/prisma.js";

export class HttpAuthError extends Error {
  constructor(
    readonly statusCode: number,
    readonly code: string,
    message: string
  ) {
    super(message);
  }
}

function extractBearerToken(request: FastifyRequest) {
  const authorization = request.headers.authorization;

  if (!authorization) {
    throw new HttpAuthError(401, "missing_auth", "Authentification requise.");
  }

  const [scheme, token] = authorization.split(" ");

  if (scheme !== "Bearer" || !token) {
    throw new HttpAuthError(401, "invalid_auth_scheme", "Jeton d'accès invalide.");
  }

  return token;
}

export function requireRole(request: FastifyRequest, allowedRoles: AccessTokenRole[]): AccessTokenPayload {
  try {
    const payload = verifyAccessToken(extractBearerToken(request));

    if (!allowedRoles.includes(payload.role)) {
      throw new HttpAuthError(403, "forbidden", "Accès interdit.");
    }

    return payload;
  } catch (error) {
    if (error instanceof HttpAuthError) {
      throw error;
    }

    throw new HttpAuthError(401, "invalid_token", "Session invalide ou expirée.");
  }
}

export async function requireRoleWithTokenCheck(request: FastifyRequest, allowedRoles: AccessTokenRole[]): Promise<AccessTokenPayload> {
  const payload = requireRole(request, allowedRoles);
  const user = await prisma.user.findUnique({
    where: { id: payload.sub },
    select: { tokenVersion: true }
  });
  if (user && user.tokenVersion !== payload.tv) {
    throw new HttpAuthError(401, "token_revoked", "Token révoqué. Veuillez vous reconnecter.");
  }
  return payload;
}

