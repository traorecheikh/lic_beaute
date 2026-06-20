# Verified Mobile Audit Checklist

> Scope: `apps/mobile-client` plus the API/contracts boundaries it depends on.
> Status rule: every entry below has been re-checked against the current tree before being listed.
> This checklist replaces the older inflated backlog; counts below are authoritative for the current audit corpus.

---

## Security / Session / Compliance

| # | Finding | Area | Fixed? |
|---|---------|------|--------|
| S1 | Fastify error handler still falls back to `reply.send(error)` for non-validation failures | `apps/api/src/app.ts` | `[ ]` |
| S2 | Play-review OTP bypass is enabled by default and not blocked by prod config validation | `apps/api/src/config.ts` | `[ ]` |
| S3 | Refresh token rotation does not increment `tokenVersion`, so old access tokens remain valid until expiry | `apps/api/src/modules/auth/index.ts` | `[ ]` |
| S4 | FCM registration uses raw `FlutterSecureStorage()` instead of the app’s `first_unlock` wrapper | `apps/mobile-client/lib/src/core/services/fcm_registration_service.dart` | `[ ]` |
| S5 | Mobile logout clears local auth but never revokes the server-side push token registration | `apps/mobile-client/lib/src/features/auth/providers/auth_provider.dart` + `apps/api/src/modules/routes.ts` | `[ ]` |
| S6 | iOS still declares `ITSAppUsesNonExemptEncryption = false` | `apps/mobile-client/ios/Runner/Info.plist` | `[ ]` |

---

## Contract / Mobile-API Drift

| # | Finding | Area | Fixed? |
|---|---------|------|--------|
| A1 | `BookingDetail` still parses fields the booking API never returns: `employeeName`, `totalAmountXof`, `salonAddress`, `durationMinutes` | `apps/mobile-client/lib/src/features/appointments/models/booking_detail.dart` + `apps/api/src/modules/bookings/index.ts` | `[ ]` |
| A2 | Backend returns `depositPaidXof`, but the Zod booking contract still omits it | `apps/api/src/modules/bookings/index.ts` + `packages/contracts/src/domain/booking.ts` | `[ ]` |
| A3 | Booking detail still bypasses the generated API client and parses raw Dio maps manually | `apps/mobile-client/lib/src/features/appointments/providers/bookings_list_provider.dart` | `[ ]` |
| A4 | The booking detail contract carries no review state, so completed-booking surfaces always expose review actions and only discover duplicate reviews after the backend returns `review_exists` | `apps/mobile-client/lib/src/features/appointments/pages/booking_detail_page.dart` + `apps/mobile-client/lib/src/features/appointments/pages/review_new_page.dart` + `apps/api/src/modules/bookings/index.ts` + `packages/contracts/src/domain/booking.ts` | `[ ]` |

---

## Offline / Sync / Runtime Integrity

| # | Finding | Area | Fixed? |
|---|---------|------|--------|
| R1 | `AppCache.favorites` is an alias to the settings box, so favorites and settings share one Hive key-space | `apps/mobile-client/lib/src/core/storage/app_cache.dart` | `[ ]` |
| R2 | Outbox `flush()` stops on the first transient failure, so one bad head entry blocks every later syncable action | `apps/mobile-client/lib/src/core/sync/app_outbox.dart` | `[ ]` |
| R3 | Avatar uploads go through `uploadSalonImage()` with `salonId: ''`, leaking profile behavior through a salon-specific API path | `apps/mobile-client/lib/src/core/sync/app_outbox.dart` + `apps/mobile-client/lib/src/features/profile/providers/profile_provider.dart` + `apps/mobile-client/lib/src/core/services/media_upload_service.dart` | `[ ]` |
| R4 | Background payment polling owns a long-lived `Timer` inside a global notifier with no provider-level disposal hook | `apps/mobile-client/lib/src/features/booking/providers/booking_create_provider.dart` | `[ ]` |
| R5 | Search event tracking owns a timer and in-memory buffer, but the provider never disposes the tracker | `apps/mobile-client/lib/src/features/discovery/providers/search_provider.dart` | `[ ]` |
| R6 | App resume and connectivity recovery still invalidate 17 providers at once via `refreshAll()` | `apps/mobile-client/lib/src/core/reactivity/app_reactivity.dart` + `apps/mobile-client/lib/src/app.dart` | `[ ]` |
| R7 | Current static analysis still reports `use_build_context_synchronously` violations in booking handoff and edit profile flows | `apps/mobile-client/lib/src/features/booking/pages/payment_handoff_page.dart` + `apps/mobile-client/lib/src/features/profile/pages/edit_profile_page.dart` | `[ ]` |
| R8 | Multiple current auth/profile screens still launch external URLs directly without `canLaunchUrl()` or a user-facing fallback | `apps/mobile-client/lib/src/features/auth/pages/auth_choice_page.dart` + `apps/mobile-client/lib/src/features/auth/pages/email_login_page.dart` + `apps/mobile-client/lib/src/features/auth/pages/register_page.dart` + `apps/mobile-client/lib/src/features/profile/pages/about_page.dart` | `[ ]` |
| R9 | `AppPhoneField` default validation is off by one and accepts numbers that are one digit too short | `apps/mobile-client/lib/src/core/widgets/app_phone_field.dart` + its default-validator callers | `[ ]` |
| R10 | Profile bootstrap always routes to home after the payment nudge closes, even if the user chose the payment-setup CTA inside the sheet | `apps/mobile-client/lib/src/features/auth/pages/profile_bootstrap_page.dart` | `[ ]` |
| R11 | Proactive review dismissals consume prompt budget twice because the sheet is pre-counted before display and counted again on dismiss | `apps/mobile-client/lib/src/features/discovery/pages/home_page.dart` + `apps/mobile-client/lib/src/features/appointments/widgets/review_sheet.dart` + `apps/mobile-client/lib/src/features/appointments/utils/review_prompt_manager.dart` | `[ ]` |
| R12 | Profile bootstrap checks phone availability without excluding the current authenticated user, so an existing phone can self-conflict as “already used” | `apps/mobile-client/lib/src/features/auth/pages/profile_bootstrap_page.dart` | `[ ]` |
| R13 | The Dio refresh interceptor clears queued 401 requests on refresh failure without resolving or rejecting their handlers, so concurrent callers can hang indefinitely | `apps/mobile-client/lib/src/core/network/dio_client.dart` | `[ ]` |
| R14 | Authenticated fallback caches use global keys and logout only clears part of them, so notifications, benefits, vouchers, and favorite hearts can bleed across account switches during offline/error fallback | `apps/mobile-client/lib/src/core/constants/storage_keys.dart` + `apps/mobile-client/lib/src/core/session/session_store.dart` + `apps/mobile-client/lib/src/features/notifications/providers/notifications_provider.dart` + `apps/mobile-client/lib/src/features/profile/providers/benefits_provider.dart` + `apps/mobile-client/lib/src/features/profile/providers/vouchers_provider.dart` + `apps/mobile-client/lib/src/features/discovery/providers/favorites_provider.dart` | `[ ]` |
| R15 | Future cancelled bookings are filtered out of both the upcoming and past tabs, so they disappear from the booking history UI | `apps/mobile-client/lib/src/features/appointments/pages/bookings_list_page.dart` | `[ ]` |
| R16 | Offline notification read actions enqueue outbox work but never update local notification state, so the UI can report success while unread badges and tiles stay stale until a later sync | `apps/mobile-client/lib/src/features/notifications/providers/notifications_provider.dart` + `apps/mobile-client/lib/src/features/notifications/pages/notifications_page.dart` | `[ ]` |
| R17 | Post-auth routing treats any payment-method fetch failure as “zero methods”, so transient API errors can force fully onboarded users back into payment setup after login | `apps/mobile-client/lib/src/features/auth/utils/auth_router_helper.dart` | `[ ]` |
| R18 | Payment waiting timeout is tracked in a timer without a rebuild on the timeout branch, so the “timed out / close” state may never appear until some unrelated state change happens | `apps/mobile-client/lib/src/features/booking/widgets/payment_waiting_sheet.dart` | `[ ]` |
| R19 | The offline outbox survives logout and flushes globally on app start/reconnect, so queued profile, payment-method, avatar, or notification mutations from one account can execute inside the next authenticated session | `apps/mobile-client/lib/src/core/session/session_store.dart` + `apps/mobile-client/lib/src/core/sync/app_outbox.dart` + `apps/mobile-client/lib/src/core/widgets/app_connectivity_recovery.dart` | `[ ]` |
| R20 | The booking review route has no funnel-state guard, so direct navigation or state loss can open a broken confirmation screen that only fails late when create-booking returns `null` | `apps/mobile-client/lib/src/router/app_router.dart` + `apps/mobile-client/lib/src/features/booking/pages/booking_review_page.dart` + `apps/mobile-client/lib/src/features/booking/providers/booking_create_provider.dart` | `[ ]` |
| R21 | Zero-deposit bookings are routed to the success page, but that page hardcodes “deposit received” copy, so the confirmation message is factually wrong for pay-on-site bookings | `apps/mobile-client/lib/src/features/booking/pages/booking_review_page.dart` + `apps/mobile-client/lib/src/features/booking/pages/booking_success_page.dart` + `apps/mobile-client/lib/src/core/constants/app_strings.dart` | `[ ]` |
| R22 | Logout never clears scheduled local engagement reminders or global engagement state keys, so one user’s reminder notifications can survive into the next account session on the same device | `apps/mobile-client/lib/src/core/services/engagement_notification_service.dart` + `apps/mobile-client/lib/src/core/session/session_store.dart` + `apps/mobile-client/lib/src/app.dart` | `[ ]` |

---

## Thermonuclear Maintainability

| # | Finding | Area | Fixed? |
|---|---------|------|--------|
| T1 | `payment_handoff_page.dart` is 1663 lines and mixes form state, callback resume, payment execution, background polling, link launching, and UI composition in one page | `apps/mobile-client/lib/src/features/booking/pages/payment_handoff_page.dart` | `[ ]` |
| T2 | `booking_funnel_sheet.dart` is 1363 lines and performs cross-day availability fanout plus step orchestration directly in the widget | `apps/mobile-client/lib/src/features/booking/widgets/booking_funnel_sheet.dart` | `[ ]` |
| T3 | `slot_variants.dart` is 1007 lines of ten slot-presentation experiments behind a single production switch | `apps/mobile-client/lib/src/features/booking/widgets/slot_variants.dart` | `[ ]` |
| T4 | `salon_detail_page.dart` is 874 lines and mixes fetch state, booking kickoff, gallery viewer, sharing, favorites, and large UI sections in one stateful page | `apps/mobile-client/lib/src/features/discovery/pages/salon_detail_page.dart` | `[ ]` |
| T5 | `payment_methods_page.dart` is 617 lines and duplicates large add/edit bottom-sheet flows instead of sharing one form workflow | `apps/mobile-client/lib/src/features/profile/pages/payment_methods_page.dart` | `[ ]` |
| T6 | `search_page.dart` is a manual state machine for debounce, pagination, filters, correction text, analytics, and result caching instead of delegating more of that state to providers | `apps/mobile-client/lib/src/features/discovery/pages/search_page.dart` | `[ ]` |
| T7 | “Best staff for any” scoring logic is duplicated across the booking funnel sheet and the standalone staff selection page | `apps/mobile-client/lib/src/features/booking/widgets/booking_funnel_sheet.dart` + `apps/mobile-client/lib/src/features/booking/pages/staff_selection_page.dart` | `[ ]` |
| T8 | OTP resend countdown logic is duplicated nearly verbatim across email login, register, and OTP login pages | `apps/mobile-client/lib/src/features/auth/pages/email_login_page.dart` + `apps/mobile-client/lib/src/features/auth/pages/register_page.dart` + `apps/mobile-client/lib/src/features/auth/pages/otp_login_page.dart` | `[ ]` |
| T9 | Phone seeding/normalization from stored profile values is duplicated across edit profile and payment methods flows instead of living in one phone utility | `apps/mobile-client/lib/src/features/profile/pages/edit_profile_page.dart` + `apps/mobile-client/lib/src/features/profile/pages/payment_methods_page.dart` | `[ ]` |
| T10 | `AppBookingAsyncScaffold` uses a dynamic provider contract plus a runtime cast instead of a typed provider boundary | `apps/mobile-client/lib/src/core/widgets/app_booking_async_scaffold.dart` | `[ ]` |

---

## Summary

| Category | Total | Fixed | Remaining |
|----------|-------|-------|-----------|
| Security / Session / Compliance | 6 | 0 | 6 |
| Contract / Mobile-API Drift | 4 | 0 | 4 |
| Offline / Sync / Runtime Integrity | 22 | 0 | 22 |
| Thermonuclear Maintainability | 10 | 0 | 10 |
| **TOTAL** | **42** | **0** | **42** |
