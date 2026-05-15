#!/bin/sh

# Locate the Prisma CLI — pnpm deploy --prod does not inject .bin/ wrappers,
# so fall back to running the package entry point via node directly.
if [ -f "node_modules/.bin/prisma" ]; then
  PRISMA_CMD="node_modules/.bin/prisma"
elif [ -f "node_modules/prisma/build/index.js" ]; then
  PRISMA_CMD="node node_modules/prisma/build/index.js"
else
  echo "[entrypoint] ERROR: cannot locate prisma CLI in node_modules"
  exit 1
fi

echo "[entrypoint] Running prisma migrate deploy (via $PRISMA_CMD)..."
$PRISMA_CMD migrate deploy
MIGRATE_EXIT=$?
if [ $MIGRATE_EXIT -ne 0 ]; then
  echo "[entrypoint] prisma migrate deploy FAILED with exit code $MIGRATE_EXIT"
  exit $MIGRATE_EXIT
fi
echo "[entrypoint] Migrations OK. Starting application..."

exec "${@:-node dist/index.js}"
