FROM node:22-alpine AS base
RUN corepack enable && corepack prepare pnpm@10 --activate
WORKDIR /app

# ── dependency manifests only (cache layer) ──────────────────────────────────
FROM base AS manifests
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY packages/contracts/package.json packages/contracts/
COPY packages/shared-ts/package.json packages/shared-ts/
COPY apps/api/package.json apps/api/

# ── install all workspace deps ────────────────────────────────────────────────
FROM manifests AS deps
RUN pnpm install --frozen-lockfile

# ── build: contracts → shared-ts → api ───────────────────────────────────────
# prebuild script runs prisma:generate; tsc compiles generated client into dist/
FROM deps AS build
COPY packages/contracts packages/contracts
COPY packages/shared-ts packages/shared-ts
COPY apps/api apps/api
COPY tsconfig.base.json ./
RUN pnpm --filter @beauteavenue/contracts build && \
    pnpm --filter @beauteavenue/shared-ts build && \
    pnpm --filter @beauteavenue/api build

# ── produce a self-contained node_modules for prod ───────────────────────────
FROM build AS deploy-prep
RUN pnpm --filter @beauteavenue/api --prod deploy /deploy/api

# ── final runtime image ───────────────────────────────────────────────────────
FROM node:22-alpine AS runner
ENV NODE_ENV=production
WORKDIR /app

COPY --from=build /app/apps/api/dist ./dist
COPY --from=deploy-prep /deploy/api/node_modules ./node_modules
COPY --from=build /app/apps/api/package.json ./
# schema needed for `prisma migrate deploy` at startup
COPY --from=build /app/apps/api/prisma ./prisma
COPY apps/api/entrypoint.sh ./entrypoint.sh

RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app && \
    chmod +x /app/entrypoint.sh

USER appuser

EXPOSE 3000
ENTRYPOINT ["/app/entrypoint.sh"]
