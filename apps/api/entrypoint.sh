#!/bin/sh

# Run pending migrations before starting the server.
# Safe to run on every boot — migrate deploy is idempotent.
echo "[entrypoint] Running prisma migrate deploy..."
node_modules/.bin/prisma migrate deploy
MIGRATE_EXIT=$?
if [ $MIGRATE_EXIT -ne 0 ]; then
  echo "[entrypoint] prisma migrate deploy FAILED with exit code $MIGRATE_EXIT"
  exit $MIGRATE_EXIT
fi
echo "[entrypoint] Migrations OK. Starting application..."

exec "${@:-node dist/index.js}"
