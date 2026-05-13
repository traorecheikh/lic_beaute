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

import { config } from "./config.js";
import type { DatabaseRuntime } from "./lib/db/runtime.js";
import { setPrisma } from "./lib/db/prisma.js";
import { registerRoutes } from "./modules/routes.js";
import type { PrismaClient } from "./generated/prisma/client.js";

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

  await app.register(cors, {
    origin: config.webOrigin,
    credentials: true
  });
  await app.register(cookie);
  await app.register(sensible);
  await app.register(helmet, {
    contentSecurityPolicy: false,
    crossOriginEmbedderPolicy: false
  });
  await app.register(rateLimit, {
    global: true,
    max: 100,
    timeWindow: "1 minute"
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
