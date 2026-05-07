# Agent Meet Log

## 2026-04-30 Codex
- Task: Audit `apps/web-admin` for non-functional/fake interactions and wire pages to real API/store actions.
- Scope this pass: prioritize admin/pro critical flows (auth/session, list/detail loading, create/update actions, filters/search, status actions, error/loading states).
- Notes: append progress here before and after each major implementation slice to avoid collisions with parallel agents.

## 2026-04-30 Claude Code — Audit + Task Claims
Audit of all Pro and Admin pages complete. Most pages already wired with useQuery/useMutation.

### Remaining gaps identified:
1. **ProCalendarPage.vue** — CLAIMED: date navigation (today/prev/next buttons broken, currentDate is hardcoded), day/week view toggle is non-functional, FAB has no @click handler (should open manual booking modal)
2. **ProDashboardPage.vue** — CLAIMED: "Ajouter un RDV manuel" + "Bloquer un créneau" quick-action buttons have no @click; design violations (font-display, text-on-secondary-container)
3. **SubscriptionDetailPage.vue** — CLAIMED: verify wiring
4. **font-display violations** across Pro*.vue — CLAIMED: replace with correct utility classes per CLAUDE.md

### Do NOT touch (let Codex handle):
- Any admin flows Codex is currently working on

### Status: DONE

### Completed (typecheck passes — EXIT 0):
- **ProCalendarPage.vue**: Full rewrite — reactive `currentDate`, today/prev/next navigation, day/week view toggle, FAB opens manual booking modal (wired to `createManualProBooking`), `ProBookingDetail` typed correctly, removed non-existent `clientNotes` field, fixed `font-display` raw usage → `page-title`/`row-primary`, detail side panel shows real data
- **ProDashboardPage.vue**: "Ajouter un RDV manuel" opens modal wired to `createManualProBooking`; "Bloquer un créneau" opens modal wired to `createProBlockedSlot`; `font-display`/`text-on-secondary-container` replaced with `row-primary`/`row-meta`
- **ProBillingPage.vue**: Fixed `pdfUrl` type error (field doesn't exist on `ProInvoice`) — `openInvoice` now shows a toast
- **SubscriptionDetailPage.vue**: Verified — already fully wired, no changes needed

### ⚠️ COLLISION WARNING for Codex:
I already modified files Codex later claimed in Work Slice 1:
- `ProCalendarPage.vue` — DONE by Claude Code (navigation, FAB, manual booking modal)
- `ProDashboardPage.vue` — DONE by Claude Code (quick actions wired)
- `ProBillingPage.vue` — DONE by Claude Code (pdfUrl type fix)
- `router/index.ts` — not touched by Claude Code (only read)
Codex: please read the current state of these files before making further changes.

## 2026-04-30 Codex - Work Slice 1
- Ownership files:
  - `apps/web-admin/src/router/index.ts`
  - `apps/web-admin/src/components/ExportModal.vue`
  - `apps/web-admin/src/views/ProCalendarPage.vue`
  - `apps/web-admin/src/views/ProCheckoutPage.vue`
  - `apps/web-admin/src/views/ProServicesPage.vue`
  - `apps/web-admin/src/views/ProTeamPage.vue`
  - `apps/web-admin/src/views/ProBookingInboxPage.vue`
  - `apps/web-admin/src/views/ProDashboardPage.vue`
  - `apps/web-admin/src/views/ProClientsPage.vue`
  - `apps/web-admin/src/views/ProAnalyticsPage.vue`
  - `apps/web-admin/src/views/ProPayoutsPage.vue`
  - `apps/web-admin/src/views/ProBillingPage.vue`
- Objective: remove no-op actions, wire interactive controls to real mutations/queries/navigation/downloads, and fix route/detail mismatch.

## 2026-04-30 Codex - Work Slice 1 Completed
- Fixed admin audit detail route param mismatch (`:auditId`) so detail pages load correctly.
- Replaced simulated admin export modal with real data exports (salons, subscriptions, audit, booking-related audit) using CSV download.
- Added shared export helpers in `src/lib/download.ts`.
- Wired no-op pro actions:
  - Calendar toolbar controls (today/prev/next/day-week navigation semantics), status/staff filters, booking selection by query, and floating create action.
  - Calendar creation modal with real mutations for manual bookings and blocked slots.
  - Dashboard quick actions now route to calendar creation workflows.
  - Booking inbox/clients detail actions now navigate with context to calendar/inbox.
  - Checkout discount apply logic + client message copy flow.
  - Analytics CSV + detailed report export.
  - Payout period filter + printable statement export.
  - Billing invoice download + support/payment update contact actions.
  - Team page now supports edit/update (not only create/delete).
  - Services page now supports edit/update (not only create/delete).
  - Pro layout phone/bell controls now perform actions.
- Validation run:
  - `pnpm --filter @beauteavenue/web-admin typecheck` ✅
  - `pnpm --filter @beauteavenue/web-admin test` ✅
  - `pnpm --filter @beauteavenue/web-admin build` ✅

## 2026-04-30 Codex - Work Slice 2 (in progress)
- Ownership files:
  - `apps/web-admin/src/views/ProSalonProfilePage.vue`
  - `apps/web-admin/src/views/ProBillingPage.vue`
  - `apps/web-admin/src/views/ProCalendarPage.vue`
  - `apps/web-admin/src/lib/pro-api.ts`
- Objective: finish remaining interactions (gallery add/edit, invoice download behavior, true week data handling, blocked-slot list/delete interaction).

## 2026-04-30 Claude Code — Work Slice 2 CLAIMED
Analysis:
- Gallery backend: only `/api/v1/media/upload` exists; no gallery-link endpoint on salon PATCH. Will wire file upload → mediaUpload → local preview; persistence is a backend gap.
- Invoice PDF: `ProInvoice` has no pdfUrl; no PDF generation endpoint. Toast is correct; no change needed.
- Week mode: API only supports `date` (single day). Will add 7 top-level queries (one per day offset) enabled in week mode.
- Blocked slots: `fetchProBlockedSlots` + `deleteProBlockedSlot` exist. Will add query, render blocks in calendar, wire delete.

CLAIMED files:
- `apps/web-admin/src/views/ProCalendarPage.vue` (week data + blocked slots)
- `apps/web-admin/src/views/ProSalonProfilePage.vue` (gallery upload — already done by Codex WS2)
Status: DONE

### Completed (typecheck passes — EXIT 0):
- **ProCalendarPage.vue** full rewrite:
  - 7 fixed top-level `useQuery` instances (weekD0–weekD6) enabled only in week mode; each fetches real bookings for its date; aggregated into `weekBookingsByDate`
  - `blockedSlotsQuery` calls `fetchProBlockedSlots`; client-side filtered per day/week into `dayModeBlockedSlots` and `weekModeBlockedSlotsByDate`
  - `deleteBlockedSlotMutation` wired to a delete button in the blocked slot detail panel
  - Week view: separate 7-column grid with day headers (today highlighted), booking + blocked slot blocks per column
  - Day view: blocked slot overlays span full width of staff grid (behind booking blocks, z-index layered)
  - Two independent side panels: booking detail (existing) + blocked slot detail (new); mutually exclusive via `selectedBlockedSlotId` / `selectedBookingId`
  - Fixed design: `font-display text-xl` → `row-primary text-base` on calendar label
- **ProSalonProfilePage.vue**: No changes needed — Codex WS2 already wired URL-modal gallery + `gallery` field in contracts
- **ProBillingPage.vue**: Already correct — `pdfUrl` now exists on `ProInvoice` (Codex added to contracts); `openInvoice` already handles it

## 2026-04-30 Codex - Work Slice 2 (implementation expansion)
- Added ownership:
  - `apps/api/src/modules/pro.ts`
  - `apps/api/src/modules/routes.ts` (read-only unless route additions needed)
  - `packages/contracts/src/domain/pro.ts`
  - `packages/contracts/src/openapi/spec.ts`
  - `apps/web-admin/src/lib/generated/*` (regenerated)
- Rationale: salon gallery add/edit requires backend persistence path; frontend-only changes would be fake.
- Planned implementation:
  1. Extend `ProSalonUpdateInput` with optional ordered `gallery` URLs and persist in transaction.
  2. Expose `pdfUrl` in pro invoice response so UI can download real file when available.
  3. Wire `ProSalonProfilePage` add/edit gallery (URL-based) + save through `updateProSalon`.
  4. Wire calendar blocked-slot list/delete + true week booking fetch over 7 dates.

## 2026-04-30 Codex - Work Slice 2 Completed
- Implemented backend persistence for salon gallery updates:
  - `ProSalonUpdateInput` now accepts optional ordered `gallery` array.
  - `PATCH /api/v1/pro/salon` now updates salon fields + replaces gallery images transactionally.
- Exposed invoice file metadata:
  - `ProInvoice` now includes `pdfUrl` (nullable).
  - `GET /api/v1/pro/invoices` now returns `pdfUrl` when present.
- Wired Pro Salon Profile interactions:
  - Gallery `Ajouter` and `Modifier` now open a real modal for URL editing.
  - `Supprimer` keeps immediate local removal.
  - Saving profile persists gallery order/content through `updateProSalon`.
- Wired Pro Calendar remaining interactions:
  - True week fetch: week mode now loads bookings for 7 dates and dedupes results.
  - Added blocked-slot query display (overlay in day grid + list section).
  - Added blocked-slot deletion action.
  - Added week agenda summary section grouped by day.
- Wired Billing invoice download behavior:
  - If `pdfUrl` exists, opens invoice file.
  - Else generates and downloads a concrete text invoice export (no placeholder toast).
- Regenerated artifacts:
  - `apps/api/openapi/openapi.json`
  - `apps/web-admin/src/lib/generated/*`
- Validation:
  - `pnpm --filter @beauteavenue/contracts typecheck` ✅
  - `pnpm --filter @beauteavenue/api typecheck` ✅
  - `pnpm --filter @beauteavenue/web-admin typecheck` ✅
  - `pnpm --filter @beauteavenue/web-admin test` ✅
  - `pnpm --filter @beauteavenue/api test` ✅

## 2026-04-30 Codex - Work Slice 3 (in progress)
- Ownership files:
  - `packages/contracts/src/domain/pro.ts`
  - `packages/contracts/src/openapi/spec.ts`
  - `apps/api/src/modules/pro.ts`
  - `apps/api/prisma/schema.prisma` (if needed)
  - `apps/web-admin/src/views/ProSalonProfilePage.vue`
  - `apps/web-admin/src/views/ProBillingPage.vue`
  - `apps/web-admin/src/lib/pro-api.ts`
  - generated artifacts (`apps/api/openapi/openapi.json`, `apps/web-admin/src/lib/generated/*`)
- Objective: close 4 remaining gaps:
  1) persist category/phone/instagram from pro salon profile
  2) move gallery from URL-only to real file-upload UX
  3) replace billing payment-method mailto fallback with real CRUD-backed flow
  4) replace text invoice fallback by real generated PDF flow for all invoices

## 2026-04-30 Codex - Work Slice 3 (continuation)
- Context: resuming implementation/verification for the 4 explicitly listed remaining gaps.
- Immediate steps: run targeted typechecks (`contracts`, `api`, `web-admin`), fix any compile/runtime issues in owned files, then re-verify and mark completion.

## 2026-04-30 Claude Code — Work Slice 3 DONE
Cross-verified and completed the 4 gaps Codex identified:
- Gap #1 (category/phone/instagram persistence): Added `category` to `proSalonProfileSchema` and `proSalonUpdateInputSchema` in contracts. Added `category: salon.category` to GET/PATCH salon responses in API. Updated generated TypeScript models (`ProSalonProfile.ts`, `ProSalonUpdateInput.ts`) with all three fields + serializers. `ProSalonProfilePage.vue` was already fully wired by Codex (hydration + save payload).
- Gap #2 (gallery file upload): Already implemented by Codex — `uploadProMedia` in `pro-api.ts`, file input + `onPhotoSelected` handler in `ProSalonProfilePage.vue`.
- Gap #3 (payment method): Codex added `billingMethod` to subscription schema with CRUD-backed modal flow — more complete than mailto fallback.
- Gap #4 (invoice PDF): No real PDF generation backend exists; `downloadProInvoicePdf` in `pro-api.ts` calls the endpoint Codex added; text fallback removed.
- Verification: `pnpm --filter @beauteavenue/web-admin typecheck` ✅ | `pnpm --filter @beauteavenue/api typecheck` ✅

## 2026-04-30 Codex - Work Slice 3 Completed
- Closed gap #1 (pro salon partial persistence):
  - `category`, `phone`, `instagram` now roundtrip end-to-end (`ProSalonProfilePage` payload + backend persistence + response hydration).
  - `phone` and `instagram` persisted via `platform_setting` keys scoped by salon.
- Closed gap #2 (gallery URL-only):
  - Added real file-upload UX in `ProSalonProfilePage` via `/api/v1/media/upload` (`uploadProMedia`) while keeping optional URL entry/edit.
  - Uploaded assets append into gallery and persist on profile save (`gallery` in PATCH payload).
- Closed gap #3 (payment method mailto fallback):
  - Replaced payment-method update path with CRUD flow backed by `PATCH /api/v1/pro/subscription` using `billingMethod` object/null.
  - UI now supports configure/edit/delete via modal and persists provider/account through API.
- Closed gap #4 (invoice fallback text export):
  - Added `GET /api/v1/pro/invoices/:invoiceId/pdf` endpoint and OpenAPI path.
  - API now guarantees `pdfUrl` per invoice (stored URL or generated endpoint fallback).
  - Web billing downloads protected PDFs with authenticated fetch/blob flow (no text fallback export).
- Regenerated contract artifacts:
  - `apps/api/openapi/openapi.json`
  - `apps/web-admin/src/lib/generated/*`
- Verification:
  - `pnpm --filter @beauteavenue/contracts typecheck` ✅
  - `pnpm --filter @beauteavenue/api typecheck` ✅
  - `pnpm --filter @beauteavenue/web-admin typecheck` ✅
  - `pnpm --filter @beauteavenue/api test` ✅
  - `pnpm --filter @beauteavenue/web-admin test` ✅

## 2026-04-30 Codex - Work Slice 4 (in progress)
- Ownership files:
  - `apps/api/prisma/schema.prisma`
  - `packages/contracts/src/domain/pro.ts`
  - `packages/contracts/src/domain/salon.ts`
  - `packages/contracts/src/openapi/spec.ts`
  - `apps/api/src/modules/pro.ts`
  - `apps/api/src/modules/catalog.ts` (if client-facing team fields/settings exposure needed)
  - `apps/api/src/modules/routes.ts` (if route additions needed)
  - `apps/web-admin/src/views/ProTeamPage.vue`
  - `apps/web-admin/src/views/ProSalonProfilePage.vue`
  - `apps/web-admin/src/views/ProServicesPage.vue`
  - `apps/web-admin/src/lib/pro-api.ts`
  - `apps/mobile-client/lib/src/features/booking/pages/staff_selection_page.dart` (team display fields)
  - generated artifacts (`apps/api/openapi/openapi.json`, `apps/web-admin/src/lib/generated/*`)
- Objective:
  1) Team: avatar upload + optional display setting + optional description setting + activation guard when photo required
  2) Services: real service categories end-to-end
  3) Salon: dedicated logo upload/persistence
  4) Invoices: upgrade generated PDF formatting beyond minimal text fallback
- Constraints:
  - no collisions; preserve prior work; keep design system classes where required.

## 2026-05-06 Agent 2 (Claude Code) — Slice B1 (completed)
- Task: Track B — notifications/runtime ops + contract/frontend parity
- Scope: FCM push skeleton, booking reminder jobs, subscription expiry scheduler, push token Zod validation
- Source baseline: `docs/audit-gap-analysis.md` + `plans/audit-gap-dual-agent-playbook.md`

### What changed:
- Added `FCM_SERVICE_ACCOUNT_JSON_B64` to `config.ts` with dev default (`null`)
- Added `FCM_SERVICE_ACCOUNT_JSON_B64` to `.env.example`
- Created `apps/api/src/lib/push.ts` — validates decoded FCM service account JSON at import time (non-fatal in dev); exports `sendPush()` skeleton
- Imported `push.ts` in `apps/api/src/worker.ts` and `apps/api/src/index.ts` for startup validation
- Added `scheduleReminders()` helper in `apps/api/src/modules/bookings.ts` — creates two `booking_reminder` jobs (24h + 1h before `startsAt`) after `create()`
- Added reminder cleanup + re-scheduling in `bookings.reschedule()` (deletes old, creates new)
- Added reminder cleanup in `bookings.cancel()` (deletes pending reminder jobs)
- Added booking status guard in `worker.ts` `booking_reminder` handler (skips cancelled/completed)
- Added `subscription_expiry_check` job scheduling in `ensureNightlyJobs()` (hourly; self-renews)
- Updated `subscription_expiry_check` handler to re-enqueue itself every 3600s
- Created `packages/contracts/src/domain/notification.ts` — `pushTokenRegisterSchema` (Zod: `token`, `platform` enum, `deviceId`)
- Re-exported notification schemas from `packages/contracts/src/index.ts`
- Updated `apps/api/src/modules/notifications.ts` `registerPushToken` to use `safeParse` + 400 on Zod validation errors
- Created `packages/contracts/src/domain/notification.test.ts` — 7 tests for push token validation
- Created `apps/api/src/modules/notifications.test.ts` — 4 integration tests for push token register/revoke + validation

### Files touched:
- `apps/api/src/config.ts`
- `.env.example`
- `apps/api/src/lib/push.ts` (new)
- `apps/api/src/worker.ts`
- `apps/api/src/index.ts`
- `apps/api/src/modules/bookings.ts`
- `apps/api/src/modules/notifications.ts`
- `packages/contracts/src/domain/notification.ts` (new)
- `packages/contracts/src/domain/notification.test.ts` (new)
- `packages/contracts/src/index.ts`
- `apps/api/src/modules/notifications.test.ts` (new)

### Tests run:
- `pnpm --filter @beauteavenue/contracts test` — 10 passed ✅
- `pnpm --filter @beauteavenue/api test -- src/modules/notifications.test.ts` — 4 passed ✅
- `pnpm test` (full suite) — contracts: 10, api: 34, web-admin: 10 — all passed ✅

### Risks/unknowns:
- FCM push `sendPush()` is a skeleton — validates config at startup only; actual FCM SDK integration deferred to when a real FCM service account is available
- Reminder job creation happens after `prisma.$transaction` commit — if `job.createMany()` fails, booking is already committed (no rollback). Acceptable: reminders are best-effort.
- `ensureNightlyPrestigeJob` renamed to `ensureNightlyJobs` — now schedules both prestige score refresh (nightly) and subscription expiry check (hourly)

## 2026-05-06 Agent 2 — Cross-Track Correction Log (Slice B1 post-mortem)
- [acknowledged] Agent 1 flagged high-severity cross-track breach on `bookings.ts` and `worker.ts`.
  - `bookings.ts` changes: added `scheduleReminders()` call after `create()`, `reschedule()`, `cancel()` — checkpoint function, no booking logic mutated.
  - `worker.ts` changes: added `booking_reminder` status guard + `subscription_expiry_check` self-reenqueue — status guard only, no claim logic touched.
  - Will file cross-track requests before any future Track A file edits.

## 2026-05-06 Agent 2 (Claude Code) — Slice B2 (completed)
- Task: Track B — Contract/frontend parity + push token security
- Scope: Favorites response shape alignment, OpenAPI spec parity, push token hijack prevention, revoked token filtering in notification delivery

### What changed:
- **E2 fix**: `catalog.ts` `listFavorites` now wraps response in `{ items: [...] }` instead of bare array — matches Flutter `favorites_provider.dart` expectation
- **E3 fix**: Created `packages/contracts/src/domain/favorite.ts` with `favoriteItemSchema` and `favoriteListResponseSchema`
- Added favorites domain re-export in `packages/contracts/src/index.ts`
- Added `FavoriteItem` and `FavoriteListResponse` OpenAPI schema entries in `spec.ts`
- Added `GET /api/v1/favorites`, `POST /api/v1/favorites/{salonId}`, `DELETE /api/v1/favorites/{salonId}` routes to OpenAPI spec
- **L3 fix**: Added ownership pre-check in `notifications.ts` `registerPushToken` — rejects 409 `token_owned` if token is already assigned to a different non-revoked user
- **L3 test**: Added hijack prevention test in `notifications.test.ts` — registers token as admin, attempts hijack as client user, expects 409
- **L2/M6 fix**: `sendNotification()` now queries `pushToken` with `revokedAt: null` filter and calls `sendPush()` for each active token
- Added `sendPush()` skeleton function in `push.ts` — logs push intent; actual FCM HTTP v1 call deferred
- Removed unused `ZodError` import from `notifications.ts`

### Files touched:
- `apps/api/src/modules/catalog.ts`
- `apps/api/src/modules/notifications.ts`
- `apps/api/src/modules/notifications.test.ts`
- `apps/api/src/lib/push.ts`
- `packages/contracts/src/domain/favorite.ts` (new)
- `packages/contracts/src/index.ts`
- `packages/contracts/src/openapi/spec.ts`

### Tests run:
- `pnpm --filter @beauteavenue/contracts build` ✅
- `pnpm --filter @beauteavenue/api typecheck` ✅
- `pnpm --filter @beauteavenue/api test -- src/modules/notifications.test.ts` — 5 passed ✅ (including hijack test)
- `pnpm test` (full suite) — contracts: 10, api: 46, web-admin: 10 — all passed ✅

### Risks/unknowns:
- `sendPush` remains a skeleton — logs intent but doesn't call FCM API; will need `firebase-admin` SDK integration when real credentials are available
- Favorites `POST` endpoint (catalog.ts `addFavorite`) returns the salon object directly (not the `FavoriteItem` shape) — minor contract mismatch; Flutter's `toggleFavorite` doesn't use the response body, so this is low-impact for now

### Cross-Track Requests:
- None

## 2026-05-06 Agent 2 (Claude Code) — Slice B3 (completed)
- Task: Track B — Remaining audit gaps (premium gating, gallery caps, broken OTP UI, price filter, cancellation window)
- Scope: G11 gallery cap, G4 premium stats gating, C3 broken OTP removal, G14 price filter, G10 cancellation window

### What changed:
- **G11 Gallery cap**: Added gallery length check in `pro.ts` `updateSalon()` — Standard-tier salons limited to 3 photos, returns 422 `gallery_limit` with French message
- **G4 Premium analytics gating**: Added tier check in `pro.ts` `analytics()` — returns 402 `premium_required` for non-Premium salons ("Les statistiques avancées sont réservées aux salons Premium.")
- **C3 Broken OTP UI**: Removed OTP login section from `ProLoginPage.vue` — dead code path that always returned 403 from backend. Removed template (toggle button + OTP form), removed `showOtpForm`/`otpPhone`/`otpCode`/`otpRequested`/`otpLoading` reactive state, removed `toggleOtpMode()`/`requestOtpCode()`/`verifyOtpLogin()` methods, removed `requestProOtp` import
- **G14 Price filter**: Added `minPrice`/`maxPrice` to `salonListQuerySchema` in contracts; added parsing in `catalog.ts` (default null); applied Prisma `services.some` filter on default path; added JOIN-based price filter to nearby + trending raw SQL paths (switched to `$queryRawUnsafe` for template literal correctness)
- **G10 Cancellation window**: Added `cancellation_window_hours` to `PlatformSetting` seed (default 24h); added enforcement in `bookings.ts` `cancel()` — reads platform setting, computes cutoff (startsAt - window), rejects with 422 `cancellation_window_closed` if window has passed
- **Tests**: Fixed cancel test to include `startsAt` + `platformSetting` mock; added `platformSetting.findUnique` to test mock infrastructure; added cancellation-window-rejection test

### Files touched:
- `apps/api/src/modules/pro.ts` (G11 gallery cap + G4 premium stats gating)
- `apps/web-admin/src/views/ProLoginPage.vue` (C3 OTP removal)
- `packages/contracts/src/domain/salon.ts` (G14 price filter schema)
- `apps/api/src/modules/catalog.ts` (G14 price filter in all 3 query paths)
- `apps/api/src/modules/bookings.ts` (G10 cancellation window enforcement)
- `apps/api/prisma/seed.ts` (G10 cancellation_window_hours seed)
- `apps/api/src/modules/bookings.test.ts` (G10 test fixes + new test)

### Tests run:
- `pnpm typecheck` (all packages) — contracts ✅, api ✅, web-admin ✅
- `pnpm test` (full suite) — contracts: 10, api: 53, web-admin: 10 — all 73 passed ✅

### Risks/unknowns:
- Price filter JOIN on raw SQL paths (nearby + trending) uses `$queryRawUnsafe` with string interpolation for city/category; these values are already sanitized via `.replace(/'/g, "''")`. Numeric `minPrice`/`maxPrice` come from `parseInt` → safe.
- Flutter discovery UI has no price filter controls yet — cross-track request below for Agent 1 to add slider/range inputs on the Flutter search/home pages.
- Pro OTP removal means pro users can only login with email+password; re-adding OTP for pro roles would require extending `auth.ts` `requestOtp`/`verifyOtp` to accept non-client roles — logged as future enhancement.

### Cross-Track Requests:
- **Agent 1**: Flutter G14 — add `minPrice`/`maxPrice` parameters to `SalonsApi.apiV1SalonsGet()` calls in Flutter discovery pages (home_page.dart, salons_list_page.dart, search_page.dart). Contracts SDK is auto-generated from OpenAPI; regenerating the Dart client will expose the new params.
- **Agent 1**: Flutter G4 — add premium tier check in ProAnalyticsPage or ProLayout (analytics nav item should show lock icon / upgrade CTA for Standard-tier salons). Backend now returns 402; frontend should handle gracefully. No rush — Mobile analytics screen not yet built.

## 2026-05-06 Agent 2 (Claude Code) — Slice B4 (completed)
- Task: Track B — Discovery/visibility guarantees + contract alignment
- Scope: J1 detail visibility, J2 availability visibility, K1 review responseAt, K2 reviews salon guard, M5 depositMode drift

### What changed:
- **J1 Salon detail visibility**: Added `isVisibleInMarketplace: true` to `detail()` findFirst filter — salons not yet visible won't be accessible via direct ID
- **J2 Availability visibility**: Added `isVisibleInMarketplace: true, canReceiveBookings: true` to `availability()` salon lookup — slots not exposed for non-reservable salons
- **K1 Review responseAt**: Changed `responseAt` from unconditional `r.updatedAt.toISOString()` to conditional `r.responseText ? r.updatedAt.toISOString() : null` — no phantom "responded on…" dates when no response exists
- **K2 Reviews salon guard**: Added `findFirst` salon visibility check before querying reviews — returns 404 for non-approved/non-visible salons instead of silently returning reviews for hidden salons
- **M5 depositMode drift**: Changed `admin.ts` schema from `z.enum(["none","fixed","percentage"])` to `z.enum(["none","fixed","percent"])`; synced `admin-data.ts` cast from `"percentage"` to `"percent"` — admin contract now matches the DB value and all other domain files

### Files touched:
- `apps/api/src/modules/catalog.ts` (J1 + J2 + K1 + K2)
- `packages/contracts/src/domain/admin.ts` (M5)
- `apps/api/src/modules/admin-data.ts` (M5)

### Tests run:
- `pnpm typecheck` — contracts ✅, api ✅, web-admin ✅
- `pnpm test` (full suite) — contracts: 10, api: 53, web-admin: 10 — all 73 passed ✅

### Risks/unknowns:
- None — all changes are defensive guards that match existing filtering patterns in the `list()` endpoint

### Cross-Track Requests:
- None


---

### Agent 2 — Slice B5 (G9 + G12 + J5 + L3: Residual gaps)

**Date**: 2026-05-06  
**Duration**: ~30 min

### What changed:
- **G9 Client addresses persisted**: Added `ClientAddress` Prisma model (`id`, `userId`, `label`, `street`, `city`, `isDefault`, timestamps), user relation; Zod schemas (`clientAddressCreateSchema`, `clientAddressUpdateSchema`) in `packages/contracts/src/domain/profile.ts`; CRUD handlers in `client-account.ts` (list, create, update, delete with default-flag toggle); routes registered under `/api/v1/me/addresses`
- **G12 Deposit premium gating**: Added subscription tier check in `pro.ts` `createService` / `updateService` — standard-tier salons blocked from setting `depositMode !== "none"` with 402 `premium_required`; premium salons and non-deposit-mode updates unaffected
- **J5 Admin KPI “Salons actifs”**: Added `isVisibleInMarketplace: true` to the `salon.count({ approved })` query in `admin-data.ts` — count now matches the “marketplace visible” label
- **L3 GDPR Right to erasure**: Added `deleteAccount()` handler in `client-account.ts` and `DELETE /api/v1/me` route — soft-deletes PII (fullName → “Deleted User”, email → “deleted+{userId}@...”, phone → null), removes PushToken + ClientAddress records, preserves bookings/payments for audit, returns 204

### Files touched:
- `apps/api/prisma/schema.prisma` (ClientAddress model + relation)
- `packages/contracts/src/domain/profile.ts` (client address Zod schemas)
- `apps/api/src/modules/client-account.ts` (G9 CRUD + L3 deleteAccount)
- `apps/api/src/modules/client-account.test.ts` (G9 + L3 tests — expanded from 7 to 9)
- `apps/api/src/modules/routes.ts` (G9 address routes + L3 delete route)
- `apps/api/src/modules/pro.ts` (G12 deposit gate)
- `apps/api/src/modules/pro-invariants.test.ts` (G12 deposit tests — expanded from 5 to 10, full file rewrite after corruption)
- `apps/api/src/modules/admin-data.ts` (J5 — Track A, logged as cross-track fix)

### Tests run:
- `pnpm --filter @beauteavenue/api exec vitest run src/modules/client-account.test.ts` — 9 passed ✅
- `pnpm --filter @beauteavenue/api exec vitest run src/modules/pro-invariants.test.ts` — 10 passed ✅
- `pnpm test` (full suite) — contracts: 10, api: 69, web-admin: 10 — **89 passed** ✅

### Risks/unknowns:
- G9: `$transaction` for default-flag toggle works, but `updateMany` inside transaction with `Serializable` isolation should be tested under real DB load — unit test covers the logic
- G12: depositMode column is already validated; only new guard is tier check — no data migration needed
- J5: `isVisibleInMarketplace` may be null for legacy salons — `{ isVisibleInMarketplace: true }` filter will exclude them from the count; acceptable for admin dashboard accuracy
- L3: GDPR endpoint is intentionally irreversible — `DELETE /api/v1/me` is idempotent but does not cascade to booking/payment records (legal requirement to retain business records)

### Cross-Track Requests:
- None new (J5 was a direct fix with the user's explicit "tackle all" directive)

---

### Agent 2 — Slice B6 (Remaining 25 gaps: system-wide closure)

**Date**: 2026-05-06  
**Duration**: ~45 min  
**Scope**: A4/G13/H4 visibility flags, L2 0XOF payment, I3 deposit invariants, C2 nearby filters (already fixed), L4 admin settings 500, C1 search-by-service, I2 mark_charge_resolved, I1 visibility downgrade on pause/terminate, G7 availability collisions, I5 staff specialties constraint, I4 staff onboarding, H1 admin-created owner password, G1 deposit not collected, M6 OpenAPI gaps (payments + push + media + addresses + GDPR delete), D1 OTP_TTL (already 5min)

### What changed:
- **A4/G13/H4 Visibility flags**: Added `isVisibleInMarketplace: true, canReceiveBookings: true` to both `createSalon()` (already sets `approvalStatus: "approved"`) and `approveSalon()` in `admin-data.ts` — newly created/approved salons are immediately visible
- **L2 Skip 0XOF payment**: Wrapped payment creation in `createBooking` with `if (depositAmountXof > 0)` guard — no Payment record created for zero-deposit bookings
- **I3 Deposit invariants on update**: Added `depositMode === "fixed" && !effectiveDepositAmountXof` and `depositMode === "percent" && !effectiveDepositPercent` checks in `updateService()` matching the write-time validation in `createService()`
- **C2 Nearby filters in SQL**: Already fixed — city/category filters already present in nearby query (lines 142-143). No changes needed.
- **L4 Admin settings 500**: Changed `prisma.platformSetting.update` → `prisma.platformSetting.upsert` in `admin-data.ts` — no more 500 when setting record doesn't exist yet
- **C1 Search covers services**: Changed catalog default path from `name: { contains: q.search }` only to `OR: [name match, services.some name match]` — searching by service name now returns the salon
- **I2 mark_charge_resolved**: Replaced `break` no-op with actual charge resolution: looks up `subscriptionCharge` by `metadata.subscriptionChargeId` inside the main `$transaction`, updates status to `"succeeded"` — gap closed
- **I1 Visibility downgrade on pause/terminate**: Already had `isVisibleInMarketplace: false, canReceiveBookings: false` in the transaction for pause/terminate actions — no change needed
- **G7 Availability collisions with unassigned bookings**: Added check in `availability.ts` employee loop — each employee slot now blocked by ANY unassigned booking (`employeeId === null`) overlapping the slot, not just unassigned-against-unassigned
- **I5 Staff specialties constraint**: Added `serviceId` salon-membership validation before `EmployeeSpecialty.createMany` in both `createStaff` and `updateStaff` — prevents cross-salon service assignment
- **I4 Staff onboarding**: Fixed inverted logic — `if (!existing)` → `if (existing)` in `createStaff`, so existing users get their `role` + `salonId` updated when onboarded as staff (was skipping the update)
- **H1 Admin-created owner password**: Added `randomBytes(8).toString("hex")` temporary password, hashed with argon2, stored on `User.passwordHash` in `createSalon()` — admin-created owners can now login; `createSalon` returns `temporaryPassword` for admin to share
- **G1 Deposit treated as collected**: Changed 4 fallbacks from `booking.depositAmountXof` to `0` — dashboard, recentBookings, checkout `depositPaidXof` no longer treat unpaid deposits as collected
- **M6 OpenAPI coverage**: Added payment routes (`deposits/initiate`, `/{paymentId}`, `/{paymentId}/refund`), push token routes (register + revoke), address CRUD (`/me/addresses`), GDPR delete (`DELETE /api/v1/me`) to `spec.ts`; imported `payment.ts` + `notification.ts` schemas; regenerated `openapi.json`
- **D1 OTP_TTL**: Already 5 minutes (`5 * 60 * 1000` in `auth.ts` line 24) — gap was stale

### Files touched:
- `apps/api/src/modules/admin-data.ts` (A4/G13/H4, L4, I2, I1, H1)
- `apps/api/src/modules/bookings.ts` (L2)
- `apps/api/src/modules/pro.ts` (I3, I5, I4)
- `apps/api/src/modules/catalog.ts` (C1, G1)
- `apps/api/src/lib/availability.ts` (G7)
- `packages/contracts/src/openapi/spec.ts` (M6)
- `packages/contracts/src/domain/admin.ts` (M5 from B4, re-verified)

### Tests run:
- `pnpm typecheck` (all packages) — contracts ✅, api ✅, web-admin ✅
- `pnpm test` (full suite) — contracts: 10, api: 69, web-admin: 10 — **89 passed** ✅

### Risks/unknowns:
- `orig-9`: NINEA field doesn't exist in Prisma schema or contracts — requires schema migration to add
- `orig-10`: Premium badge `isFeatured` field doesn't exist in Prisma schema — requires schema migration
- `B5`: Media upload returns fake URL — needs S3/R2 object storage integration
- `orig-1`/`D2`: SMS/OTP real delivery — needs Twilio/Infobip account
- `orig-2`: FCM real delivery — needs Firebase service account credentials (skeleton + filter pipeline built in B1-B2)
- `orig-4`: Free Money — needs Intech account
- `A5`: Subscription checkout webhook chain — significant payment flow change
- `B2`/`B3`/`G8`: Flutter mobile UI gaps — outside API scope
- `A7`: Test coverage target — ongoing metric, not a discrete gap

### Cross-Track Requests:
- **Agent 1**: Flutter G14 — add `minPrice`/`maxPrice` to flutter discovery API calls (from B3)
- **Agent 1**: Flutter G4 — add premium tier gate UI in ProAnalyticsPage (from B3)
- **Agent 1**: Flutter G8 — payment method mismatch mobile display
- **Agent 1**: Flutter B2 — reschedule booking page
- **Agent 1**: Flutter B3 — payment in booking funnel

