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
import Fastify from "fastify";
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
    credentials: true
  });
  await app.register(cookie);
  await app.register(sensible);
  const httpsOrigin = config.webOrigin.startsWith("https://");
  await app.register(helmet, {
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'none'"],
        connectSrc: ["'self'"],
        frameAncestors: ["'none'"],
        // upgrade-insecure-requests forces the browser to load all assets over HTTPS.
        // On HTTP-only deployments this silently breaks every JS/CSS asset → white page.
        upgradeInsecureRequests: httpsOrigin ? [] : null
      }
    },
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
        max: 100,
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
        max: config.nodeEnv === "production" ? 50 : 2000,
        timeWindow: "1 minute"
      });
    }
  } else {
    await app.register(rateLimit, {
      global: true,
      max: config.nodeEnv === "production" ? 50 : 2000,
      timeWindow: "1 minute"
    });
  }
  // Propagate Fastify's built-in request ID to every response for correlation.
  app.addHook("onSend", async (request, reply) => {
    reply.header("x-request-id", request.id);
  });
  app.decorate("redisEnabled", redisEnabled);

  // Allow DELETE (and other bodyless) requests that mistakenly carry
  // Content-Type: application/json with no body (FST_ERR_CTP_EMPTY_JSON_BODY).
  app.addContentTypeParser("application/json", { parseAs: "string" }, (_req, body, done) => {
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

  const webDistPath = join(dirname(fileURLToPath(import.meta.url)), "../public");
  if (existsSync(webDistPath)) {
    await app.register(staticFiles, {
      root: webDistPath,
      wildcard: false,
      serve: true,
    });
    app.get("/*", (_req, reply) => {
      return reply.sendFile("index.html", webDistPath);
    });
  }

  return app;
}
