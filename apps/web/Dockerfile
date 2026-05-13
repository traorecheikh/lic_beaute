FROM node:22-alpine AS base
RUN corepack enable && corepack prepare pnpm@10 --activate
WORKDIR /app

# ── dependency manifests only (cache layer) ──────────────────────────────────
FROM base AS manifests
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY packages/contracts/package.json packages/contracts/
COPY packages/shared-ts/package.json packages/shared-ts/
COPY apps/web/package.json apps/web/

# ── install all workspace deps ────────────────────────────────────────────────
FROM manifests AS deps
RUN pnpm install --frozen-lockfile

# ── build: contracts → shared-ts → web ───────────────────────────────────────
FROM deps AS build
COPY packages/contracts packages/contracts
COPY packages/shared-ts packages/shared-ts
COPY apps/web apps/web
COPY tsconfig.base.json ./
# VITE_API_URL is injected at build time via --build-arg
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
RUN pnpm --filter @beauteavenue/contracts build && \
    pnpm --filter @beauteavenue/shared-ts build && \
    pnpm --filter @beauteavenue/web-admin build

# ── serve with nginx ──────────────────────────────────────────────────────────
FROM nginx:1.27-alpine AS runner
COPY --from=build /app/apps/web/dist /usr/share/nginx/html
COPY infra/nginx/spa.conf /etc/nginx/conf.d/default.conf

# run nginx as non-root (nginx image already has the 'nginx' user)
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && chown nginx:nginx /var/run/nginx.pid

USER nginx
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
