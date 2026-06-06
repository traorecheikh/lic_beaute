#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:3000}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@beauteavenue.local}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin1234}"
RUN_ID="$(date +%s)"
CLIENT_EMAIL="client.flow.${RUN_ID}@example.sn"
CLIENT_PHONE="+22179$(printf '%07d' "$((RUN_ID % 10000000))")"
CLIENT_PASSWORD="clientflow1234"
PRO_PASSWORD="proflow1234"
PRO_REJECT_EMAIL="pro.reject.${RUN_ID}@example.sn"
PRO_REJECT_NAME="Flow Reject Salon ${RUN_ID}"
PRO_REJECT_PHONE="+22175$(printf '%07d' "$((RUN_ID % 10000000))")"

urlencode() {
  node -e 'process.stdout.write(encodeURIComponent(process.argv[1]||""))' "$1"
}

echo "[1/8] Health"
curl -fsS "${BASE_URL}/health" >/dev/null

echo "[2/8] Admin login"
ADMIN_JSON="$(curl -fsS -X POST "${BASE_URL}/api/v1/auth/login" \
  -H 'Content-Type: application/json' \
  --data "{\"email\":\"${ADMIN_EMAIL}\",\"password\":\"${ADMIN_PASSWORD}\"}")"
ADMIN_TOKEN="$(printf '%s' "$ADMIN_JSON" | node -e 'const fs=require("fs"); const v=JSON.parse(fs.readFileSync(0,"utf8")); process.stdout.write(v.accessToken||"")')"
[ -n "$ADMIN_TOKEN" ]

echo "[3/8] Client registration"
curl -fsS -X POST "${BASE_URL}/api/v1/auth/register" \
  -H 'Content-Type: application/json' \
  --data "{\"type\":\"client\",\"fullName\":\"Flow Client\",\"email\":\"${CLIENT_EMAIL}\",\"phone\":\"${CLIENT_PHONE}\",\"password\":\"${CLIENT_PASSWORD}\"}" >/dev/null

echo "[4/8] Client login + /me"
CLIENT_JSON="$(curl -fsS -X POST "${BASE_URL}/api/v1/auth/login" \
  -H 'Content-Type: application/json' \
  --data "{\"email\":\"${CLIENT_EMAIL}\",\"password\":\"${CLIENT_PASSWORD}\"}")"
CLIENT_TOKEN="$(printf '%s' "$CLIENT_JSON" | node -e 'const fs=require("fs"); const v=JSON.parse(fs.readFileSync(0,"utf8")); process.stdout.write(v.accessToken||"")')"
[ -n "$CLIENT_TOKEN" ]
curl -fsS "${BASE_URL}/api/v1/me" -H "authorization: Bearer ${CLIENT_TOKEN}" >/dev/null

echo "[5/8] Register pro dossier"
register_owner() {
  local email="$1"
  local phone="$2"
  local owner_name="$3"
  local salon_name="$4"
  local address="$5"
  local service_name="$6"

  curl -fsS -X POST "${BASE_URL}/api/v1/auth/register" \
    -H 'Content-Type: application/json' \
    --data "{\"type\":\"salon_owner\",\"fullName\":\"${owner_name}\",\"email\":\"${email}\",\"phone\":\"${phone}\",\"password\":\"${PRO_PASSWORD}\",\"salon\":{\"name\":\"${salon_name}\",\"category\":\"Coiffure\",\"city\":\"Dakar\",\"address\":\"${address}\",\"description\":\"\"},\"services\":[{\"name\":\"${service_name}\",\"durationMinutes\":45,\"priceXof\":12000,\"depositMode\":\"none\"}],\"hours\":[{\"dayOfWeek\":1,\"isOpen\":true,\"opensAt\":\"09:00\",\"closesAt\":\"19:00\"},{\"dayOfWeek\":2,\"isOpen\":true,\"opensAt\":\"09:00\",\"closesAt\":\"19:00\"},{\"dayOfWeek\":3,\"isOpen\":true,\"opensAt\":\"09:00\",\"closesAt\":\"19:00\"},{\"dayOfWeek\":4,\"isOpen\":true,\"opensAt\":\"09:00\",\"closesAt\":\"19:00\"},{\"dayOfWeek\":5,\"isOpen\":true,\"opensAt\":\"09:00\",\"closesAt\":\"19:00\"},{\"dayOfWeek\":6,\"isOpen\":true,\"opensAt\":\"09:00\",\"closesAt\":\"19:00\"},{\"dayOfWeek\":0,\"isOpen\":true,\"opensAt\":\"09:00\",\"closesAt\":\"19:00\"}]}" >/dev/null
}

register_owner "$PRO_REJECT_EMAIL" "$PRO_REJECT_PHONE" "Flow Reject Owner" "$PRO_REJECT_NAME" "Mermoz" "Coupe"

echo "[6/8] Resolve dossier ID"
REJECT_SEARCH="$(urlencode "$PRO_REJECT_NAME")"

REJECT_ID="$(curl -fsS "${BASE_URL}/api/v1/admin/salons?search=${REJECT_SEARCH}" -H "authorization: Bearer ${ADMIN_TOKEN}" | node -e 'const fs=require("fs");const v=JSON.parse(fs.readFileSync(0,"utf8")); const found=(v.items||[]).find(i=>i.salonName===process.argv[1]); process.stdout.write(found?.id||"")' "$PRO_REJECT_NAME")"

[ -n "$REJECT_ID" ]

echo "[7/8] Request-info + reject endpoints"
curl -fsS -X POST "${BASE_URL}/api/v1/admin/salons/${REJECT_ID}/request-info" \
  -H "authorization: Bearer ${ADMIN_TOKEN}" \
  -H 'Content-Type: application/json' \
  --data '{"reason":"Automated smoke request info"}' >/dev/null
curl -fsS -X POST "${BASE_URL}/api/v1/admin/salons/${REJECT_ID}/reject" \
  -H "authorization: Bearer ${ADMIN_TOKEN}" \
  -H 'Content-Type: application/json' \
  --data '{"reason":"Automated smoke reject"}' >/dev/null

echo "[8/8] Final status verification"
REJECT_STATUS="$(curl -fsS "${BASE_URL}/api/v1/admin/salons/${REJECT_ID}" -H "authorization: Bearer ${ADMIN_TOKEN}" | node -e 'const fs=require("fs");const v=JSON.parse(fs.readFileSync(0,"utf8")); process.stdout.write(v.approvalStatus||"")')"

[ "$REJECT_STATUS" = "rejected" ]

echo "API smoke OK"
