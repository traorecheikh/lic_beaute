#!/bin/sh
set -e

# Run pending migrations before starting the server.
# Safe to run on every boot — migrate deploy is idempotent.
node_modules/.bin/prisma migrate deploy

exec node dist/index.js
