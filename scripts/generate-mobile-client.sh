#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC="$REPO_ROOT/apps/api/openapi/openapi.json"
OUT="$REPO_ROOT/apps/mobile-client/packages/beauteavenue_api"

echo "→ Regenerating openapi.json from contracts..."
pnpm --filter @beauteavenue/contracts openapi:generate

echo "→ Generating Dart client from $SPEC..."
cd "$REPO_ROOT/apps/mobile-client"
npx @openapitools/openapi-generator-cli generate \
  -i "$SPEC" \
  -g dart-dio \
  -o "$OUT" \
  --additional-properties=pubName=beauteavenue_api,pubAuthor=beauteavenue,browserClient=false,nullSafe=true \
  --skip-validate-spec

echo "✓ Dart client generated at $OUT"
