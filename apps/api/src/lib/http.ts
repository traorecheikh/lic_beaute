import type { FastifyReply } from "fastify";

export function ok(reply: FastifyReply, data: unknown, statusCode = 200) {
  reply.code(statusCode).send(data);
}

export function fail(reply: FastifyReply, statusCode: number, code: string, message: string) {
  reply.code(statusCode).send({ code, message });
}

