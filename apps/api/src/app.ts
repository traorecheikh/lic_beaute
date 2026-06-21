import { fileURLToPath } from "node:url";
import { existsSync } from "node:fs";
import { join, dirname } from "node:path";
import cookie from "@fastify/cookie";
import cors from "@fastify/cors";
import helmet from "@fastify/helmet";
import multipart from "@fastify/multipart";
import rateLimit from "@fastify/rate-limit";
import sensible from "@fastify/sensible";
import staticFiles from "@fastify/static";
import swagger from "@fastify/swagger";
import swaggerUi from "@fastify/swagger-ui";
import Fastify, { type FastifyError } from "fastify";
import { serializerCompiler, validatorCompiler } from "fastify-type-provider-zod";
import { Redis } from "ioredis";

import { config } from "./config.js";
import type { DatabaseRuntime } from "./lib/db/runtime.js";
import { setPrisma } from "./lib/db/prisma.js";
import { registerRoutes } from "./modules/routes.js";
import type { PrismaClient } from "./generated/prisma/client.js";

declare module "fastify" {
  interface FastifyInstance {
    redisEnabled: boolean;
  }
}

type CreateAppOptions = {
  databaseRuntime: DatabaseRuntime;
  prisma?: PrismaClient;
};

export async function createApp({ databaseRuntime, prisma }: CreateAppOptions) {
  if (prisma) {
    setPrisma(prisma);
  }
  const app = Fastify({
    logger:
      config.nodeEnv === "development"
        ? {
            transport: {
              target: "pino-pretty",
              options: {
                translateTime: "SYS:standard",
                ignore: "pid,hostname"
              }
            }
          }
        : true
  });

  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);

  // Normalise Zod/Fastify validation errors to a human-readable single message.
  app.setErrorHandler((error: FastifyError, _request, reply) => {
    if (error.validation) {
      let msg = "Données invalides.";
      try {
        const issues = JSON.parse(error.message) as Array<{ message?: string }>;
        if (Array.isArray(issues) && issues[0]?.message) msg = issues[0].message;
      } catch {
        if (error.message && !error.message.startsWith("[")) msg = error.message;
      }
      reply.status(400).send({ statusCode: 400, code: "validation_error", error: "Bad Request", message: msg });
      return;
    }
    // Normalize non-validation errors — never leak raw error details to the client.
    const statusCode = error.statusCode ?? 500;
    const code = statusCode === 429 ? "rate_limited"
      : statusCode === 413 ? "payload_too_large"
      : statusCode === 404 ? "not_found"
      : "internal_error";
    const message = statusCode === 429 ? "Trop de requêtes. Réessayez dans quelques instants."
      : statusCode === 413 ? "Fichier trop volumineux."
      : statusCode === 404 ? "Ressource non trouvée."
      : "Erreur interne du serveur.";
    reply.status(statusCode).send({ statusCode, code, error: error.message ?? "Internal Server Error", message });
  });

  const allowedOrigins = new Set([config.webOrigin]);
  if (config.nodeEnv === "development") {
    allowedOrigins.add("http://localhost:5174");
    allowedOrigins.add("http://127.0.0.1:5174");
  }
  await app.register(cors, {
    origin(origin, cb) {
      if (!origin) {
        cb(null, true);
        return;
      }
      if (allowedOrigins.has(origin)) {
        cb(null, true);
        return;
      }
      if (config.nodeEnv === "development" && /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin)) {
        cb(null, true);
        return;
      }
      cb(null, false);
    },
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization", "X-Refresh-Token"],
    credentials: true
  });
  await app.register(cookie);
  await app.register(sensible);
  const httpsOrigin = config.webOrigin.startsWith("https://");
  const connectSrc = ["'self'", "https://nominatim.openstreetmap.org"];
  const imgSrc = ["'self'", "data:", "blob:"];

  if (config.mediaPublicBaseUrl) {
    try {
      const url = new URL(config.mediaPublicBaseUrl);
      const origin = url.origin;
      if (!connectSrc.includes(origin)) connectSrc.push(origin);
      if (!imgSrc.includes(origin)) imgSrc.push(origin);
    } catch {
      if (config.mediaPublicBaseUrl.startsWith("http://") || config.mediaPublicBaseUrl.startsWith("https://")) {
        if (!connectSrc.includes(config.mediaPublicBaseUrl)) connectSrc.push(config.mediaPublicBaseUrl);
        if (!imgSrc.includes(config.mediaPublicBaseUrl)) imgSrc.push(config.mediaPublicBaseUrl);
      }
    }
  }

  await app.register(helmet, {
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'none'"],
        connectSrc,
        imgSrc,
        frameAncestors: ["'none'"],
        // upgrade-insecure-requests forces the browser to load all assets over HTTPS.
        // On HTTP-only deployments this silently breaks every JS/CSS asset → white page.
        upgradeInsecureRequests: httpsOrigin ? [] : null
      }
    },
    crossOriginResourcePolicy: false,
    crossOriginEmbedderPolicy: false,
    strictTransportSecurity: httpsOrigin
  });
  let redisEnabled = false;
  if (config.redisUrl) {
    const redis = new Redis(config.redisUrl, {
      maxRetriesPerRequest: 1,
      enableOfflineQueue: true,
      lazyConnect: true
    });
    try {
      await redis.connect();
      await redis.ping();
      redisEnabled = true;
      await app.register(rateLimit, {
        global: true,
        max: 10_000,
        timeWindow: "1 minute",
        redis
      });
      app.addHook("onClose", async () => {
        await redis.quit();
      });
    } catch (err) {
      const level = config.nodeEnv === "production" ? "error" : "warn";
      app.log[level](
        { error: err instanceof Error ? err.message : String(err), redisUrl: config.redisUrl },
        "Redis unavailable — using in-memory rate limiter (reduced capacity, not distributed)"
      );
      redis.disconnect();
      // Tighter limits for in-memory fallback: not distributed, lower ceiling.
      await app.register(rateLimit, {
        global: true,
        max: config.nodeEnv === "production" ? 5_000 : 200_000,
        timeWindow: "1 minute"
      });
    }
  } else {
    await app.register(rateLimit, {
      global: true,
      max: config.nodeEnv === "production" ? 5_000 : 200_000,
      timeWindow: "1 minute"
    });
  }
  // Propagate Fastify's built-in request ID to every response for correlation.
  app.addHook("onSend", async (request, reply) => {
    reply.header("x-request-id", request.id);
  });
  app.decorate("redisEnabled", redisEnabled);

  const parseOptionalBody = (_req: unknown, body: string, done: (err: Error | null, value?: unknown) => void) => {
    const raw = body as string;
    if (!raw || raw.trim() === "") {
      done(null, undefined);
      return;
    }
    try {
      done(null, JSON.parse(raw));
    } catch {
      const err = Object.assign(new Error("Invalid JSON body"), { statusCode: 400 });
      done(err, undefined);
    }
  };

  // Allow DELETE (and other bodyless) requests that mistakenly carry
  // Content-Type: application/json with no body (FST_ERR_CTP_EMPTY_JSON_BODY).
  app.addContentTypeParser("application/json", { parseAs: "string" }, parseOptionalBody);

  // Payout callback validation probes may use non-JSON content types. Parse them
  // as raw strings so the webhook handler can acknowledge accessibility checks.
  app.addContentTypeParser("text/plain", { parseAs: "string" }, (_req, body, done) => {
    done(null, body);
  });
  app.addContentTypeParser("text/xml", { parseAs: "string" }, (_req, body, done) => {
    done(null, body);
  });
  app.addContentTypeParser("application/x-www-form-urlencoded", { parseAs: "string" }, (_req, body, done) => {
    done(null, body);
  });
  app.addContentTypeParser("*", { parseAs: "string" }, (_req, body, done) => {
    done(null, body);
  });

  await app.register(multipart, {
    limits: {
      fileSize: config.maxUploadBytes,
      files: 6,
      parts: 20
    }
  });
  await app.register(swagger, {
    mode: "static",
    specification: {
      path: fileURLToPath(new URL("../openapi/openapi.json", import.meta.url)),
      baseDir: fileURLToPath(new URL("../openapi", import.meta.url))
    }
  });
  await app.register(swaggerUi, {
    routePrefix: "/docs",
    uiConfig: {
      docExpansion: "list",
      deepLinking: false
    }
  });
  await registerRoutes(app, databaseRuntime);

  // Serve locally-stored uploads at /static/* so publicUrl() links resolve.
  if (config.storageDriver === "local" && config.storagePath) {
    await app.register(staticFiles, {
      root: config.storagePath,
      prefix: "/static/",
      decorateReply: false,
      serve: true,
    });
  }

  const webDistPath = join(dirname(fileURLToPath(import.meta.url)), "../public");
  if (existsSync(webDistPath)) {
    await app.register(staticFiles, {
      root: webDistPath,
      wildcard: false,
      decorateReply: true,
      serve: true,
    });
    app.get("/*", (_req, reply) => {
      return reply.sendFile("index.html");
    });
  }

  return app;
}
