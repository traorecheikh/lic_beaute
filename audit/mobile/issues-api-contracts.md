# Audit API Contracts — Mobile ↔ Backend

Current status: only verified contract drift is listed here.

## A1 — `BookingDetail` still expects fields the backend never returns

**Mobile**
- `apps/mobile-client/lib/src/features/appointments/models/booking_detail.dart`

**Backend**
- `apps/api/src/modules/bookings/index.ts` → `bookingSummary()`

**Verified mismatch**
- Mobile still parses `employeeName`
- Mobile still parses `totalAmountXof`
- Mobile still parses `salonAddress`
- Mobile still parses `durationMinutes`

The booking API response currently returns none of those fields. The mobile model is silently papering over the mismatch with fallbacks instead of sharing a real contract.

**Recommended fix**
- Either add the fields to the backend + Zod contract, or delete them from the mobile model and downstream UI assumptions.

## A2 — `depositPaidXof` is returned by the backend but missing from the contract

**Backend**
- `apps/api/src/modules/bookings/index.ts`

**Contract**
- `packages/contracts/src/domain/booking.ts`

`bookingSummary()` includes `depositPaidXof`, but `bookingSummarySchema` still omits it. That means the generated/shared contract is behind the actual runtime payload.

**Recommended fix**
- Add `depositPaidXof` to `bookingSummarySchema` and regenerate downstream clients.

## A3 — Booking detail still bypasses the generated API client

**Mobile**
- `apps/mobile-client/lib/src/features/appointments/providers/bookings_list_provider.dart`

The booking detail fetch still uses raw `dio.get<Map<String, dynamic>>()` and manual `BookingDetail.fromJson()` parsing instead of the generated API client. That keeps this endpoint outside the normal contract regeneration path and makes drift easier to miss.

**Recommended fix**
- Move booking detail onto the generated client or shared typed boundary.

## A4 — Booking detail has no review-state contract, so review CTAs can be dead actions

**Mobile**
- `apps/mobile-client/lib/src/features/appointments/pages/booking_detail_page.dart`
- `apps/mobile-client/lib/src/features/appointments/pages/review_new_page.dart`

**Backend**
- `apps/api/src/modules/bookings/index.ts`
- `packages/contracts/src/domain/booking.ts`

**Verified mismatch**
- Completed booking surfaces always offer review actions
- The booking detail payload carries no `reviewId`, `hasReview`, or equivalent review-state field
- The backend rejects duplicate submissions with `409 review_exists`

That means the client cannot distinguish “eligible to review” from “already reviewed” before the user taps through and submits. The current UX learns duplicate-review state only by failing late on submit.

**Recommended fix**
- Add explicit review state to the booking detail contract, or provide a dedicated eligibility field the mobile client can trust before rendering review CTAs.
