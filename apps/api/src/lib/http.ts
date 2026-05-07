import type { FastifyReply } from "fastify";
import { HttpAuthError } from "./auth/index.js";
import { logger } from "./logger.js";

export function ok(reply: FastifyReply, data: unknown, statusCode = 200) {
  reply.code(statusCode).send(data);
}

export function fail(reply: FastifyReply, statusCode: number, code: string, message: string) {
  reply.code(statusCode).send({ code, message });
}

export function handleError(error: unknown, reply: FastifyReply) {
  if (error instanceof HttpAuthError) {
    fail(reply, error.statusCode, error.code, error.message);
    return;
  }
  logger.error("Handler error", { error });
  fail(reply, 500, "internal_error", "Erreur interne.");
}

