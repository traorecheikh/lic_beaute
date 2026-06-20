# Thermonuclear Mobile Audit

Scope: `apps/mobile-client` and the immediate API integration seams it owns.

This pass follows the repo’s thermonuclear audit rule: prioritize structural simplification, file-size explosions, ad-hoc branching, and boundary drift over cosmetic cleanup.

## T1 — `payment_handoff_page.dart` is a 1663-line multi-system god object

**File**
- `apps/mobile-client/lib/src/features/booking/pages/payment_handoff_page.dart`

**Why this is a blocker**
- One page owns payment method form state
- PayDunya callback resumption
- deep/external link launching
- background polling state bridging
- manual credential prefilling
- retry/status messaging
- multiple bottom sheets and CTA modes

This is exactly the kind of file the thermonuclear audit should reject: too many unrelated responsibilities, too much mutable state, and too many places to bolt on one more branch.

**Code-judo direction**
- Extract a payment session controller for resume/reconcile/execute state
- isolate payment identity/contact form logic from transport/status logic
- move launch/retry/poll orchestration behind a dedicated service or notifier
- split the page into focused sections instead of one monolith

## T2 — `booking_funnel_sheet.dart` mixes UI flow control with cross-day availability orchestration

**File**
- `apps/mobile-client/lib/src/features/booking/widgets/booking_funnel_sheet.dart`

**Why this is a blocker**
- 1363-line widget
- the widget itself runs the “best staff” availability fanout
- step state, booking creation, and heavy selection UI all live in one object

The `_resolveBestStaffId()` fanout is business logic hiding inside a giant sheet rather than a canonical booking selection layer.

**Code-judo direction**
- move staff scoring/fanout into a provider or domain service
- split each funnel step into its own focused widget
- keep the sheet as orchestration, not policy + transport + rendering

## T3 — `slot_variants.dart` ships ten product experiments inside one 1007-line production file

**File**
- `apps/mobile-client/lib/src/features/booking/widgets/slot_variants.dart`

**Why this is a blocker**
- one switch dispatches ten large implementations
- the file has its own helper ecosystem and multiple stateful subtrees
- this is design-lab code living as a permanent production dependency

This is complexity preservation, not simplification.

**Code-judo direction**
- pick the winning slot presentation and delete the rest
- if experimentation must continue, move variants behind a separate internal/demo surface

## T4 — `salon_detail_page.dart` is still a catch-all page instead of a composition root

**File**
- `apps/mobile-client/lib/src/features/discovery/pages/salon_detail_page.dart`

**Why this is a blocker**
- booking kickoff
- gallery viewer bootstrapping
- share-card rendering
- favorite toggling
- stale-cache messaging
- large sliver UI composition

The page keeps accumulating product behaviors rather than delegating them.

**Code-judo direction**
- split hero/gallery/actions/details/booking CTA into separate components
- move prefetch/share/favorite orchestration out of the page widget

## T5 — `payment_methods_page.dart` duplicates add/edit workflows instead of owning one form model

**File**
- `apps/mobile-client/lib/src/features/profile/pages/payment_methods_page.dart`

**Why this is a blocker**
- two large modal sheet flows
- overlapping field wiring
- duplicated save/error/sheet lifecycle handling

This is textbook “same complexity twice.”

**Code-judo direction**
- one reusable payment-method form sheet
- mode-specific config instead of separate handwritten add/edit flows

## T6 — `search_page.dart` is a manual UI state machine that bypasses provider ownership

**File**
- `apps/mobile-client/lib/src/features/discovery/pages/search_page.dart`

**Why this is a blocker**
- debounce timer in widget state
- result buffers in widget state
- page info, corrected query, errors, loading, loading-more all in widget state
- analytics/session tracking calls directly from the page

The page is manually coordinating too many state axes that should be pushed downward.

**Code-judo direction**
- move search session state into a dedicated controller/provider
- let the page render state instead of owning search orchestration

## T7 — “Best staff for any” scoring logic is duplicated in two booking surfaces

**Files**
- `apps/mobile-client/lib/src/features/booking/widgets/booking_funnel_sheet.dart`
- `apps/mobile-client/lib/src/features/booking/pages/staff_selection_page.dart`

Both surfaces implement their own `_resolveBestStaffId()` fanout, scoring, and ranking logic. The heuristics are similar but not identical, which means the same user intent can resolve differently depending on which booking entry path they took.

**Code-judo direction**
- move staff scoring into one canonical provider/service
- make both UI surfaces consume the same selection policy instead of re-implementing it

## T8 — OTP resend countdown logic is duplicated in three auth pages

**Files**
- `apps/mobile-client/lib/src/features/auth/pages/email_login_page.dart`
- `apps/mobile-client/lib/src/features/auth/pages/register_page.dart`
- `apps/mobile-client/lib/src/features/auth/pages/otp_login_page.dart`

Each page owns the same timer fields, the same `_startTimer()` implementation, the same resend gating state, and the same disposal pattern. This is small code, but it is exactly the kind of repeated state machine that drifts silently once one flow gets adjusted.

**Code-judo direction**
- extract a shared resend-countdown controller/widget
- keep auth pages focused on auth mode differences, not timer bookkeeping

## T9 — Stored-phone seeding logic is duplicated across profile payment surfaces

**Files**
- `apps/mobile-client/lib/src/features/profile/pages/edit_profile_page.dart`
- `apps/mobile-client/lib/src/features/profile/pages/payment_methods_page.dart`

Both flows reimplement the same “take a stored phone number, detect the country dial code, strip it, and seed local digits” logic. The app already has a dedicated phone-input surface, but the seeding/parsing half still lives in page-local code.

**Code-judo direction**
- move stored-phone parsing/serialization into one shared phone utility
- keep phone-entry pages focused on UI, not dial-code parsing rules

## T10 — `AppBookingAsyncScaffold` erases its provider type boundary

**File**
- `apps/mobile-client/lib/src/core/widgets/app_booking_async_scaffold.dart`

The scaffold accepts `dynamic provider`, invokes it like a callable family, then casts the watched value back to `AsyncValue<CachedResource<T>>` at runtime. That works only as long as every caller stays perfectly disciplined; the abstraction itself does not protect the contract it claims to own.

**Code-judo direction**
- type the provider parameter explicitly as the right provider family shape
- let the compiler enforce the detail-resource contract instead of relying on a cast

## R1 — `AppCache.favorites` points at the settings box

**File**
- `apps/mobile-client/lib/src/core/storage/app_cache.dart`

`favorites` is just an alias for `settingsBox`. That couples two unrelated storage domains and makes key collisions/data mixing easier over time.

## R2 — Outbox head-of-line blocking

**File**
- `apps/mobile-client/lib/src/core/sync/app_outbox.dart`

`flush()` breaks on the first transient failure. One bad queue head blocks unrelated later work indefinitely.

## R3 — Profile avatar upload leaks through a salon-specific upload abstraction

**Files**
- `apps/mobile-client/lib/src/core/sync/app_outbox.dart`
- `apps/mobile-client/lib/src/features/profile/providers/profile_provider.dart`
- `apps/mobile-client/lib/src/core/services/media_upload_service.dart`

The client reuses `uploadSalonImage()` with `salonId: ''` for profile avatars. This works only because the helper is permissive, not because the boundary is clean.

## R4 — Background payment polling owns a long-lived timer without provider disposal

**File**
- `apps/mobile-client/lib/src/features/booking/providers/booking_create_provider.dart`

The background polling notifier stores a `Timer` in a global notifier and never registers cleanup with a provider disposal path. That means polling lifecycle is detached from the provider graph and relies on ad-hoc manual cancellation instead of a canonical ownership boundary.

## R5 — Search event tracking owns a timer and buffer without provider disposal

**File**
- `apps/mobile-client/lib/src/features/discovery/providers/search_provider.dart`

The search event tracker keeps both an in-memory event buffer and a delayed flush timer, but the provider returns it without wiring `dispose()` through `ref.onDispose()`. The abstraction has cleanup logic, but the provider does not own it.

## R6 — Resume/connectivity recovery is too blunt

**Files**
- `apps/mobile-client/lib/src/core/reactivity/app_reactivity.dart`
- `apps/mobile-client/lib/src/app.dart`

`refreshAll()` invalidates the world on app resume and recovery. That is easy to write and hard to reason about, and it creates avoidable churn across unrelated screens.

## R7 — Current analyzer still reports async-context hazards

**Files**
- `apps/mobile-client/lib/src/features/booking/pages/payment_handoff_page.dart`
- `apps/mobile-client/lib/src/features/profile/pages/edit_profile_page.dart`

`dart analyze lib test patrol_test` currently reports `use_build_context_synchronously` in both flows. These are not style nits; they are current evidence that the UI lifecycle handling is still brittle around async work.

## R8 — External legal/help links are still inconsistently guarded

**Files**
- `apps/mobile-client/lib/src/features/auth/pages/auth_choice_page.dart`
- `apps/mobile-client/lib/src/features/auth/pages/email_login_page.dart`
- `apps/mobile-client/lib/src/features/auth/pages/register_page.dart`
- `apps/mobile-client/lib/src/features/profile/pages/about_page.dart`

Some screens correctly use `canLaunchUrl()` and fallback messaging, but these screens still call `launchUrl()` directly for external/legal links. The behavior is inconsistent across the app and still assumes the launcher path always exists.

**Code-judo direction**
- one shared external-link helper with capability check + fallback snackbar
- use it everywhere instead of mixing raw `launchUrl()` calls with guarded wrappers

## R9 — `AppPhoneField` default validation is off by one

**Files**
- `apps/mobile-client/lib/src/core/widgets/app_phone_field.dart`
- callers relying on the default validator such as:
  - `apps/mobile-client/lib/src/features/profile/pages/payment_methods_page.dart`
  - `apps/mobile-client/lib/src/features/auth/pages/profile_bootstrap_page.dart`
  - `apps/mobile-client/lib/src/features/booking/pages/payment_handoff_page.dart`

The built-in validator currently rejects only values shorter than `countryDigits - 1`, which means a number that is exactly one digit short still passes. Any screen that relies on the default validator inherits that bug.

**Code-judo direction**
- make the shared field own the correct exact-length validation
- avoid page-level ad-hoc compensations for a broken default

## R10 — Profile bootstrap overrides its own payment-setup navigation

**File**
- `apps/mobile-client/lib/src/features/auth/pages/profile_bootstrap_page.dart`

After a successful bootstrap, the optional flow awaits `_showPaymentNudge()`, then unconditionally calls `context.go(AppRoutes.home)`. But the sheet’s primary CTA already does `context.go(AppRoutes.profilePaymentsSetup(...))` before dismissing. That means the caller can route to payment setup and then immediately get redirected back home when the awaited sheet returns.

**Code-judo direction**
- make the payment nudge return an explicit outcome
- navigate once based on that outcome instead of firing competing `go()` calls from two layers

## R11 — Review prompt budget is double-counted on dismiss

**Files**
- `apps/mobile-client/lib/src/features/discovery/pages/home_page.dart`
- `apps/mobile-client/lib/src/features/appointments/widgets/review_sheet.dart`
- `apps/mobile-client/lib/src/features/appointments/utils/review_prompt_manager.dart`

The home page calls `ReviewPromptManager.recordShown()` before displaying the proactive sheet. If the user dismisses with “Plus tard”, `_dismiss()` then calls `recordDismissed()`, which itself calls `recordShown()` again. One visible prompt therefore burns two units of the three-prompt budget.

**Code-judo direction**
- separate “shown” from “dismissed” accounting
- let one orchestration point own prompt-budget mutation for a given display event

## R12 — Bootstrap phone availability check can self-conflict

**File**
- `apps/mobile-client/lib/src/features/auth/pages/profile_bootstrap_page.dart`

The bootstrap availability request does not pass the current authenticated user as `excludeUserId`, so a user who already has their own stored phone can be told that the number is already in use.

**Code-judo direction**
- use the same authenticated-user exclusion logic already present in the edit-profile flow
- keep “is this phone used by someone else?” checks consistent across account surfaces

## R13 — Refresh-failure handling can strand queued authenticated requests

**File**
- `apps/mobile-client/lib/src/core/network/dio_client.dart`

When one request hits a 401, the interceptor refreshes the session and queues later 401s behind it. But if refresh fails, the catch path clears `_queue` and only forwards the original error handler. The queued handlers are never resolved or rejected. The same risk exists if one queued retry throws inside the success loop before later handlers are reached.

This means concurrent authenticated requests can hang indefinitely during refresh failure or partial retry failure instead of completing with an auth error and allowing the UI to recover.

**Code-judo direction**
- always resolve or reject every queued handler before clearing the queue
- isolate queued retry failures so one bad replay cannot strand the rest

## R14 — Authenticated fallback caches bleed across account switches

**Files**
- `apps/mobile-client/lib/src/core/constants/storage_keys.dart`
- `apps/mobile-client/lib/src/core/session/session_store.dart`
- `apps/mobile-client/lib/src/features/notifications/providers/notifications_provider.dart`
- `apps/mobile-client/lib/src/features/profile/providers/benefits_provider.dart`
- `apps/mobile-client/lib/src/features/profile/providers/vouchers_provider.dart`
- `apps/mobile-client/lib/src/features/discovery/providers/favorites_provider.dart`

Several authenticated caches are stored under global keys such as `notifications_list`, `benefits_list`, `vouchers_list`, and `favorite_ids`. Logout only clears `current_user` and `payment_methods`. That means offline/error fallback can show one user another user’s notifications, benefits, vouchers, or favorite-heart state after an account switch on the same device.

This is not just a cache neatness problem; it breaks account isolation in the exact paths the app uses when the network is weak or unavailable.

**Code-judo direction**
- namespace authenticated cache keys by user id
- clear all authenticated caches on logout, not just profile basics
- keep anonymous/public cache domains separate from user-owned data

## R15 — Future cancelled bookings disappear from both tabs

**File**
- `apps/mobile-client/lib/src/features/appointments/pages/bookings_list_page.dart`

The bookings page excludes cancelled future bookings from the “upcoming” tab, but the “past” tab only includes bookings whose start time is already past or whose status is `completed`. A booking cancelled before its scheduled time therefore lands in neither tab and effectively vanishes from the history UI.

**Code-judo direction**
- classify cancelled bookings explicitly instead of relying on time-only partitioning
- make the booking-list grouping policy a shared helper so status handling stays consistent

## R16 — Offline notification read actions do not update local state

**Files**
- `apps/mobile-client/lib/src/features/notifications/providers/notifications_provider.dart`
- `apps/mobile-client/lib/src/features/notifications/pages/notifications_page.dart`

When the app is offline, `markRead()` and `markAllRead()` enqueue outbox entries and invalidate the provider, but the provider does not merge those pending actions back into the local list. The notifications page can therefore show a success path while unread tiles and badge counts remain unchanged until a later network sync.

**Code-judo direction**
- apply optimistic read-state updates locally when enqueueing notification actions
- merge pending notification mutations the same way payment methods and profile sync already do

## R17 — Post-auth routing collapses fetch failures into “no payment methods”

**File**
- `apps/mobile-client/lib/src/features/auth/utils/auth_router_helper.dart`

After login or registration, `navigateAfterAuth()` tries to load payment methods to decide whether setup is required. But any exception in that fetch path is swallowed and converted into `const []`. A transient API failure therefore becomes indistinguishable from a real “user has no payment methods” state, which can send an already-configured account back to the setup flow immediately after auth.

**Code-judo direction**
- distinguish “could not verify setup state” from “verified zero methods”
- prefer cached setup state or fail-open to the intended destination instead of forcing setup on transport errors

## R18 — Payment timeout can expire without ever surfacing the timeout UI

**File**
- `apps/mobile-client/lib/src/features/booking/widgets/payment_waiting_sheet.dart`

The waiting sheet increments `_elapsed` inside its periodic timer and stops polling when `_elapsed >= _timeout.inSeconds`, but that timeout branch cancels the timer and returns without triggering `setState()`. The rendered timeout state and close CTA depend on `timedOut`, which is computed from `_elapsed` during build. If no other state change happens after the final tick, the sheet can remain stuck in the “checking” UI even though polling has already timed out.

**Code-judo direction**
- make timeout a first-class state transition instead of deriving it from a counter that may not rebuild
- ensure the terminal timeout branch updates widget state synchronously when polling stops

## R19 — Global outbox can replay one account’s offline mutations into the next session

**Files**
- `apps/mobile-client/lib/src/core/session/session_store.dart`
- `apps/mobile-client/lib/src/core/sync/app_outbox.dart`
- `apps/mobile-client/lib/src/core/widgets/app_connectivity_recovery.dart`

Offline mutations are persisted in one global outbox and restored unscoped from `StorageKeys.outboxItems`. Logout clears secure storage and a couple of profile cache keys, but it does not clear the outbox. The app then flushes that outbox automatically on startup and whenever connectivity returns.

That means queued actions such as `profile_patch`, `payment_method_create`, `payment_method_update`, `payment_method_delete`, `payment_method_default`, `notification_read`, `notifications_read_all`, and `profile_avatar_upload` can be generated under user A while offline and later execute under user B after an account switch.

This is a true cross-account mutation bug, not just stale local display state.

**Code-judo direction**
- scope outbox entries to the authenticated user that created them
- clear or quarantine user-owned outbox entries on logout
- never auto-flush account-owned offline mutations without verifying session ownership first

## R20 — Booking review has no route-state guard and degrades into a late failure

**Files**
- `apps/mobile-client/lib/src/router/app_router.dart`
- `apps/mobile-client/lib/src/features/booking/pages/booking_review_page.dart`
- `apps/mobile-client/lib/src/features/booking/providers/booking_create_provider.dart`

The booking funnel validates missing `salonId`/`serviceId` for service, staff, and slot routes, but `/booking/review` is always opened without checking whether the in-memory `bookingFunnelProvider` still contains a salon, service, and slot. If the user deep-links there or the app loses funnel state, the review page renders with empty/default summary values and only fails later when `bookingCreateProvider.create()` returns `null` because `funnel.canReview` is false.

This leaves the last booking step uniquely dependent on volatile in-memory state without the protective route error handling used earlier in the flow.

**Code-judo direction**
- validate funnel state before building the review page, just like earlier booking steps
- route invalid funnel states to a recovery/error page instead of letting the confirm action fail late

## R21 — Success copy is wrong for bookings that never required a deposit

**Files**
- `apps/mobile-client/lib/src/features/booking/pages/booking_review_page.dart`
- `apps/mobile-client/lib/src/features/booking/pages/booking_success_page.dart`
- `apps/mobile-client/lib/src/core/constants/app_strings.dart`

The review-confirm step routes bookings with `depositAmountXof <= 0` directly to the success page. But the success page subtitle is hardcoded to `Votre acompte a bien été reçu...`. For pay-on-site bookings with no deposit, the primary confirmation message is simply false.

**Code-judo direction**
- pass explicit success-state context into the success page instead of assuming every booking came through a deposit flow
- separate “booking confirmed” copy from “deposit confirmed” copy at the route boundary

## R22 — Logout does not clear scheduled engagement reminders

**Files**
- `apps/mobile-client/lib/src/core/services/engagement_notification_service.dart`
- `apps/mobile-client/lib/src/core/session/session_store.dart`
- `apps/mobile-client/lib/src/app.dart`

Local engagement reminders are scheduled through `ForegroundNotificationService.plugin.zonedSchedule(...)` and their metadata is persisted under global `AppCache.settings` keys such as `_welcomeDueAtKey`, `_reengagementDueAtKey`, `_prestigeDueAtKey`, and `_prestigeCandidateKey`. But `SessionNotifier.logout()` only deletes secure storage, resets the FCM registration helper, and removes two profile cache keys. It never calls `EngagementNotificationService.cancelAll()` and never clears the `engagement_*` settings keys.

App lifecycle hooks then keep calling `handleAppResumed()`, `syncPrestigeCandidate(ref)`, and `handleAppBackgrounded()` regardless of whether the previous user has logged out and another user has since signed in.

That leaves user-targeted local reminders and prestige-candidate state alive across account transitions on the same device. This is distinct from the outbox/cache bleed issues because the leaked artifact is a scheduled OS-level notification job.

**Code-judo direction**
- clear or cancel all user-targeted engagement reminders on logout
- scope stored engagement metadata to the authenticated user instead of device-global keys
- treat local reminder scheduling as session-owned state, not app-global state
