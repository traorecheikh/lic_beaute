#!/bin/sh

echo "[entrypoint] Node: $(node --version)"
echo "[entrypoint] CWD: $(pwd)"
echo "[entrypoint] NODE_ENV: ${NODE_ENV}"
echo "[entrypoint] DATABASE_URL scheme: ${DATABASE_URL%%:*}"
echo "[entrypoint] dist/ contents: $(ls dist/ 2>/dev/null | tr '\n' ' ')"
echo "[entrypoint] openapi/: $(ls openapi/ 2>/dev/null | tr '\n' ' ' || echo 'MISSING')"
echo "[entrypoint] node_modules/prisma: $(ls node_modules/prisma/build/index.js 2>/dev/null && echo 'found' || echo 'MISSING')"

# Locate the Prisma CLI — pnpm deploy --prod does not inject .bin/ wrappers,
# so fall back to running the package entry point via node directly.
if [ -f "node_modules/.bin/prisma" ]; then
  PRISMA_CMD="node_modules/.bin/prisma"
  echo "[entrypoint] prisma source: .bin/prisma"
elif [ -f "node_modules/prisma/build/index.js" ]; then
  PRISMA_CMD="node node_modules/prisma/build/index.js"
  echo "[entrypoint] prisma source: node_modules/prisma/build/index.js"
else
  echo "[entrypoint] ERROR: prisma CLI not found"
  sleep 300
  exit 1
fi

echo "[entrypoint] Migration status:"
$PRISMA_CMD migrate status 2>&1 || true

echo "[entrypoint] Running prisma migrate deploy (attempt 1)..."
$PRISMA_CMD migrate deploy 2>&1
MIGRATE_EXIT=$?
echo "[entrypoint] migrate deploy exit=$MIGRATE_EXIT"

if [ $MIGRATE_EXIT -ne 0 ]; then
  echo "[entrypoint] First attempt failed — resolving known failed migration and retrying..."
  $PRISMA_CMD migrate resolve --rolled-back 20260508124500_remove_paytech_provider 2>&1 || true
  echo "[entrypoint] Running prisma migrate deploy (attempt 2)..."
  $PRISMA_CMD migrate deploy 2>&1
  MIGRATE_EXIT=$?
  echo "[entrypoint] migrate deploy attempt 2 exit=$MIGRATE_EXIT"
fi

if [ $MIGRATE_EXIT -ne 0 ]; then
  echo "[entrypoint] migrations FAILED — sleeping 300s to allow log capture"
  sleep 300
  exit $MIGRATE_EXIT
fi

echo "[entrypoint] Migrations OK. Starting node dist/index.js..."
if [ "$#" -eq 0 ]; then
  node dist/index.js
  APP_EXIT=$?
else
  "$@"
  APP_EXIT=$?
fi
echo "[entrypoint] app exited with code $APP_EXIT — sleeping 300s to allow log capture"
sleep 300
exit $APP_EXIT
