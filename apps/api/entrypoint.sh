#!/bin/sh

echo "[entrypoint] Node version: $(node --version)"
echo "[entrypoint] Working directory: $(pwd)"
echo "[entrypoint] Files in /app: $(ls /app)"
echo "[entrypoint] DATABASE_URL prefix: ${DATABASE_URL%%:*}"
echo "[entrypoint] NODE_ENV: ${NODE_ENV}"

# Locate the Prisma CLI — pnpm deploy --prod does not inject .bin/ wrappers,
# so fall back to running the package entry point via node directly.
if [ -f "node_modules/.bin/prisma" ]; then
  PRISMA_CMD="node_modules/.bin/prisma"
  echo "[entrypoint] Using prisma via .bin/ wrapper"
elif [ -f "node_modules/prisma/build/index.js" ]; then
  PRISMA_CMD="node node_modules/prisma/build/index.js"
  echo "[entrypoint] Using prisma via node node_modules/prisma/build/index.js"
else
  echo "[entrypoint] ERROR: cannot locate prisma CLI in node_modules"
  ls node_modules | grep prisma || true
  exit 1
fi

echo "[entrypoint] Running prisma migrate deploy..."
$PRISMA_CMD migrate deploy 2>&1
MIGRATE_EXIT=$?
echo "[entrypoint] prisma migrate deploy exited with code $MIGRATE_EXIT"
if [ $MIGRATE_EXIT -ne 0 ]; then
  echo "[entrypoint] prisma migrate deploy FAILED — aborting"
  exit $MIGRATE_EXIT
fi

echo "[entrypoint] Migrations OK. Files in dist/: $(ls dist/)"
echo "[entrypoint] openapi dir: $(ls openapi/ 2>/dev/null || echo 'missing')"
echo "[entrypoint] Starting application..."

exec "${@:-node dist/index.js}"
