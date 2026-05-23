import type { FastifyReply } from "fastify";
import { HttpAuthError } from "./auth/index.js";
import { logger } from "./logger.js";

/**
 * Map of Prisma unique-constraint field names → user-facing field names
 * used by the admin salon-creation form.  Add entries as needed for other
 * endpoints.
 */
const UNIQUE_FIELD_MAP: Record<string, string> = {
  User_phone_key: "ownerPhone",
  User_email_key: "ownerEmail",
  phone: "ownerPhone",
  email: "ownerEmail"
};

const UNIQUE_MESSAGE_MAP: Record<string, string> = {
  ownerPhone: "Ce numéro de téléphone est déjà associé à un autre salon.",
  ownerEmail: "Cette adresse email est déjà associée à un autre salon."
};

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

  // Prisma known request errors (P2002 = unique constraint)
  if (
    error &&
    typeof error === "object" &&
    "code" in error &&
    (error as any).code === "P2002"
  ) {
    const meta = (error as any).meta as { target?: string[] } | undefined;
    const target = meta?.target ?? [];
    const field = target
      .map((f: string) => UNIQUE_FIELD_MAP[f] ?? f)
      .find((f: string) => UNIQUE_MESSAGE_MAP[f]);

    if (field) {
      reply.code(409).send({ code: "unique_constraint", message: UNIQUE_MESSAGE_MAP[field], field });
      return;
    }

    // Fallback if no field mapping exists
    fail(reply, 409, "unique_constraint", "Cette valeur est déjà utilisée.");
    return;
  }

  logger.error("Handler error", { error });
  fail(reply, 500, "internal_error", "Erreur interne.");
}

