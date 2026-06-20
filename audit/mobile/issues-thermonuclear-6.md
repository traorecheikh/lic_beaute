# 🔥 Thermo-Nuclear Code Quality Review — Part 6: Race Conditions, DB Constraints & Test Gaps

Scope: Booking creation race conditions, database-level gaps, test coverage blind spots, API startup safety.

---

## 🔴 #70: BOOKING CREATE — Serializable Transaction Failure Returns 500, Never Retries

**Fichier**: `apps/api/src/modules/bookings/index.ts` (line ~155)

```typescript
const result = await prisma.$transaction(async (tx) => { ... }, { isolationLevel: "Serializable" });
// ...                                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
} catch (error) {
  if (error instanceof HttpAuthError) { ... return; }
  fail(reply, 500, "internal_error", "Erreur interne.");  // ← catches P2034 serialization failure too
}
```

`Serializable` is correct — it's the only isolation level that prevents phantom reads and guarantees no double-booking. But PostgreSQL raises error `40001` / Prisma error code `P2034` when two concurrent Serializable transactions conflict:

- Request A reads available slots → no conflict → proceeds to insert
- Request B reads available slots → no conflict → proceeds to insert
- Request A commits first → success
- Request B tries to commit → **P2034: serialization failure** → caught as generic error → **500 response**

The catch block doesn't check for P2034 and doesn't retry. On Black Friday or any peak hour, concurrent booking attempts at the exact same millisecond produce a 500 for the unlucky user instead of a 409 with "this slot was just booked, try another" — which is the correct semantic.

### Code judo:
Wrap the Serializable transaction in retry logic:
```typescript
async function withSerializableRetry<T>(fn: (tx: PrismaTx) => Promise<T>, maxRetries = 3): Promise<T> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try { return await prisma.$transaction(fn, { isolationLevel: "Serializable" }); }
    catch (e) {
      if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2034') {
        if (attempt < maxRetries) continue;
      }
      throw e;
    }
  }
}
```

---

## 🔴 #71: BOOKING CREATE — No Idempotency Key

**Fichier**: `apps/api/src/modules/bookings/index.ts`

The `POST /api/v1/bookings` endpoint has no idempotency protection:

1. `bookingCreateSchema` has no `idempotencyKey` field
2. No duplicate booking check before creation
3. The `payment.idempotencyKey` (set to `booking-${booking.id}-deposit`) only protects the payment record, not the booking itself

**Real scenario**: Mobile client sends `POST /api/v1/bookings` → timeout → client retries → **two bookings created for the same slot**. Both are "pending" with no payment. Both block the slot. Neither has a mechanism to detect they're duplicates.

The inner `booking.count()` inside the Serializable transaction would catch this **most** of the time — the second transaction would see the first's inserted booking as a conflict. But only if the first transaction commits before the second's `booking.count()` runs. If both `booking.count()` calls run before either commits (both transactions start reading at the same time), both see 0 conflicts and both proceed to commit.

### Code judo:
Add `idempotencyKey` to `bookingCreateSchema`. Check `payment.idempotencyKey` or a new `BookingIdempotency` table before creating. This is the same pattern already used by payments — just apply it to bookings.

---

## 🔴 #72: RESCHEDULE TOCTOU — Availability Check Outside Transaction

**Fichier**: `apps/api/src/modules/bookings/index.ts` (lines 236-251)

```typescript
// Step 1: Check slot availability OUTSIDE transaction — TOCTOU window
const available = await fetchAndComputeAvailableSlots(prisma, { ... });

// Step 2: Update booking INSIDE transaction
const result = await prisma.$transaction(async (tx) => {
  const claimed = await tx.booking.updateMany({
    where: { id, status: { in: ["pending", "confirmed"] } },
    data: { startsAt: newStart, endsAt: newEnd }
  });
  // ...
});
```

Between step 1 and step 2, another booking could be placed in the new time slot. The transaction only does `updateMany` — it does **not** re-check for conflicts. Compare with `create` which does `booking.count()` inside the transaction.

**Consequence**: Two concurrent reschedule requests for the same new time slot both pass the availability check, both enter the transaction, and both succeed. The first commits, the second commits — now two bookings overlap.

### Fix:
Move the conflict re-check inside the transaction, same as `create` does:
```typescript
await prisma.$transaction(async (tx) => {
  const conflicts = await tx.booking.count({ where: { startsAt: { lt: endsAt }, endsAt: { gt: startsAt }, ... } });
  if (conflicts > 0) throw new HttpAuthError(409, "slot_taken", "...");
  const claimed = await tx.booking.updateMany({ ... });
});
```

---

## 🔴 #73: NO BOOKING EXPIRATION — Unpaid Bookings Block Slots Forever

**Fichier**: Missing — no job or cron for expired bookings

A booking is created with `status: "pending"` and `depositPaymentStatus: "pending"`. The payment is then initiated via `POST /api/v1/payments/deposits/initiate`. But:

1. If the user never calls `initiate`, the booking sits at `status: "pending"` forever
2. If `initiate` is called but `execute` is never called (app crash after initiate), the same
3. The payment record exists with `status: "pending"` but no actual charge was attempted
4. **No cleanup mechanism exists** in the worker (`pollJobs` processes: platform_settings_cleanup, payout_reconciliation, subscription_expiry_check, prestige_score_refresh — no expired booking cleanup)
5. The slot is permanently blocked because the `booking.count()` conflict check looks for `status: { in: ["pending", "confirmed", "in_progress"] }`

For a zero-deposit service (`depositAmountXof: 0`), no payment record is created at all. The booking goes directly to `pending` without any payment step. These bookings are immediately active and never expire.

### Fix:
Add a recurring job: `expire_pending_bookings` that cancels bookings with `status: "pending"` and `createdAt < now - N minutes` (configurable, e.g., 60 min). For bookings with pending payments, check if the payment's `status` is `"pending"` AND `payment.createdAt` is stale.

---

## 🔴 #74: `providerTxId` Has No Unique Constraint — Duplicates Possible at DB Level

**Fichier**: `apps/api/prisma/schema.prisma`

```prisma
model Payment {
  providerTxId     String?    // ← nullable, no @unique, no @@unique
}
```

The application prevents duplicates through `findFirst` + `if (existing)` checks, but there's **no DB-level enforcement**. Two payments could accidentally share the same `providerTxId` if:

1. The webhook dedup logic has a race (e.g., two concurrent webhook requests for the same providerTxId — both pass the `findFirst` check before either writes)
2. A bug in `_handleWebhook` bypasses the fallback lookup path
3. The provider sends two different events with the same transaction reference

Without `@unique`, this is only protected by application logic — which is one bug away from a double-credit scenario.

### Fix:
```prisma
providerTxId String? @unique
```

With a migration that handles the existing null/duplicate values (de-duplicate or set `@@unique([providerTxId, paymentId])`).

---

## 🛑 #75: Booking + Payment Cross-Race — Three Untested Concurrent Scenarios

**Fichier**: Test coverage gaps

Three critical race scenarios are **not tested**:

### 75a: Concurrent booking create for the same slot (create-vs-create)
`booking-race.test.ts` only tests cancel-vs-cancel. **No test fires two parallel `create()` calls** for the same slot at the same time. The Serializable transaction should prevent this, but the retry (#70) is missing — the test would show a 500, not a proper 409.

### 75b: Cancel-vs-confirm race
Client cancels while salon confirms the same booking. The `BookingController` has no test for this. The `cancel` endpoint uses `booking.update({ where: { id, status: { in: [...] } }, data: { status: "cancelled" } })` which is an atomic claim — but the `confirm` endpoint could have already changed the status between the cancel's read and write.

### 75c: Triple race — reconcile + webhook + refund simultaneously
`payment-concurrent.test.ts` tests pairwise races (reconcile+webhook, refund+webhook, double-refund). **No test fires all three concurrently.** Real-world scenario: reconcile triggers a status check, a late webhook arrives, and an admin requests a refund — all within milliseconds. The atomic `updateMany` should save each, but the combined interaction is untested.

---

## 🛑 #76: Out-of-Sequence Webhooks — Not Tested

The code handles same-status webhooks (short-circuit at line 641 in `_applyPaymentStatus`) but **there's no test for status regression**:

- Provider sends `succeeded` → `_applyPaymentStatus` transitions to `succeeded`
- Provider then sends `failed` for the same payment (out-of-order delivery or provider error)
- `_applyPaymentStatus` checks `payment.status === newStatus` → `"succeeded" !== "failed"` → proceeds to transition from `succeeded` → `failed`

This regresses a confirmed payment to failed. The `VALID_TRANSITIONS` map may protect against this (if `"succeeded" → "failed"` is not a valid transition), but there's no test verifying this for each status pair. A provider bug could reverse a payment status.

---

## 🛑 #77: No `unhandledRejection` / `uncaughtException` Handler — API Process Dies Silently

**Fichier**: `apps/api/src/index.ts`

```typescript
// Graceful shutdown — present
process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));

// Missing:
process.on("unhandledRejection", (reason) => { /* log + maybe exit */ });
process.on("uncaughtException", (err) => { /* log + graceful shutdown */ });
```

Any unhandled Promise rejection in any controller, adapter, or middleware will silently crash the process. During a payment webhook or reconciliation, this means:

1. A provider adapter throws from a rejected Promise
2. Node.js logs `UnhandledPromiseRejectionWarning` in v14, but in v16+ **it terminates the process**
3. The process exits
4. All in-flight payment operations are lost
5. The pending transactions never commit or rollback cleanly
6. If the process restart is slow (Docker restart policy, Coolify health check grace period), webhook retries fail

### Fix:
```typescript
process.on("unhandledRejection", (reason) => {
  console.error("UNHANDLED REJECTION:", reason);
});
process.on("uncaughtException", (err) => {
  console.error("UNCAUGHT EXCEPTION:", err);
  shutdown("uncaughtException");  // graceful shutdown
});
```

---

## 🛑 #78: `Booking.depositPaymentStatus` Has No Index — Full Table Scan for Queries

**Fichier**: `apps/api/prisma/schema.prisma`

```prisma
model Booking {
  depositPaymentStatus PaymentStatus @default(pending)  // ← unindexed
}
```

The `@@index` list for Booking:
```
@@index([salonId, createdAt])
@@index([salonId, status, createdAt])
@@index([clientId, startsAt])
@@index([employeeId, startsAt])
@@index([salonId, startsAt, endsAt])
```

No index exists on `depositPaymentStatus` alone or in combination with `createdAt`. Any query like "find all bookings where deposit payment is pending" does a sequential scan. As the booking table grows, this becomes a performance problem for:
- The pending expiration job (#73)
- The worker's cleanup tasks
- Admin dashboard queries
- Reconciliation queries

---

## 🛑 #79: Employee-Unassigned Bookings Not Checked Correctly in Inner Conflict

**Fichier**: `apps/api/src/modules/bookings/index.ts` (lines 91-97)

When `employeeId` is provided:
```typescript
conflicts = await tx.booking.count({
  where: {
    startsAt: { lt: endsAt },
    endsAt: { gt: startsAt },
    employeeId: body.employeeId  // ← only checks this specific employee
  }
});
```

This does NOT count bookings where `employeeId IS NULL` (unassigned bookings that occupy generic salon capacity). If an unassigned booking exists for the same time slot, the employee-specific check won't see it. Two different employees can both be double-booked against an unassigned booking.

When `employeeId` is NOT provided:
```typescript
// employeeId not in where clause — counts ALL salon bookings
```

This is correct — counts every overlapping booking regardless of employee. But it's the opposite scenario: if employee-specific bookings exist, they block the "no employee needed" request. This is conservative (correct by being too restrictive) but not optimal for capacity utilization.

---

## 🛑 #80: `reschedule` Doesn't Preserve Booking's Original `endsAt` Validation

When a booking is rescheduled, the new `startsAt` is accepted from the request body and a new `endsAt` is computed using the service's `durationMinutes`. But:

1. The request body could contain a `startsAt` that produces a different service duration than the original booking
2. No validation that the new `endsAt` doesn't violate salon operating hours
3. No validation that the new time doesn't conflict with the employee's blocked slots (breaks, vacations)
4. The `feeWaived` field from the original booking may be silently reset by the `update` — it's not in the `data` payload unless explicitly included

---

## 🛑 #81: Reward / Cancel — Compensation Enqueued Inside Transaction But Never Verified

```typescript
if (booking.payments.length > 0) {
  await enqueueJob({
    type: "refund_reconciliation",
    payload: { paymentId: booking.payments[0].id, bookingId: booking.id },
    bookingId: booking.id,
    dbClient: tx  // ← uses transaction-scoped client
  });
}
```

The job is enqueued inside the cancellation transaction using `dbClient: tx`. This means:
1. If the transaction commits, the job is persisted
2. If the worker fails to process the job (max retries exhausted), **the booking is already cancelled** but the refund never happened
3. No compensation mechanism exists for failed refund jobs
4. No monitoring alert for stuck refund jobs
5. The booking's `depositPaymentStatus` shows the pre-refund status — no indication that a refund was attempted and failed

---

## 🛑 #82: `calcDepositAmount` — No Minimum Deposit Floor

```typescript
function calcDepositAmount(service): number {
  if (service.depositMode === "fixed") return service.depositAmountXof ?? 0;
  if (service.depositMode === "percent") return Math.round(((service.depositPercent ?? 0) / 100) * service.priceXof);
  return 0;
}
```

Three configuration errors produce zero deposit:
1. `depositMode: "fixed"` + `depositAmountXof: null` → 0
2. `depositMode: "percent"` + `depositPercent: null` → 0% × price = 0
3. Any unset `depositMode` → default 0

A deposit of 1 XOF or 5 XOF would pass all validation but would cost more in payment processing fees than the deposit itself. No minimum deposit is enforced at the application level.

---

## 🛑 #83: Mobile Client — No Session Refresh Race Protection

**Fichier**: `apps/mobile-client/lib/src/core/network/dio_client.dart`

```dart
bool _isRefreshing = false;
final List<({RequestOptions options, ErrorInterceptorHandler handler})> _queue = [];
```

The `_isRefreshing` flag and `_queue` are instance fields on `_AuthInterceptor`. If two 401 responses arrive before `_isRefreshing` is set to `true`:

```dart
if (_isRefreshing) {
  _queue.add((options: err.requestOptions, handler: handler));
  return;
}
_isRefreshing = true;  // ← this runs AFTER the check, but both calls enter before
```

Two requests could both see `_isRefreshing == false` and both call `dio.post('/api/v1/auth/refresh')`. The first refresh succeeds, stores new tokens. The second refresh also succeeds — but now uses the first refresh's tokens as the basis for the second refresh. The API may reject the second refresh if it detected the first refresh rotated the tokens.

### Fix:
Make `_isRefreshing` assignment atomic: set it before the async check:
```dart
if (_isRefreshing) { _queue.add(...); return; }
_isRefreshing = true;  // move this BEFORE the await
// ... async refresh logic ...
```

---

## 🛑 #84: Mobile Client — `_pay()` Reads Widget State Across Async Gaps

The `_pay()` method in `payment_handoff_page.dart` reads `ref.read(profileProvider)`, `ref.read(paymentMethodsProvider)`, and `ref.read(paymentInitiateProvider)` at arbitrary points during execution, not at the start. Between the `initiate()` call and the `execute()` call, the providers' state can change:

1. `profileProvider` is `AsyncNotifier` — another part of the app could `refresh()` it
2. `paymentMethodsProvider` could be `refresh()` by the outbox flush
3. `sessionProvider` could be cleared by a refresh interceptor failure

Each of these reads could return stale or nil data, and the code falls through to the HTTP call with potentially wrong parameters. Credit card details are read from controllers (widget state) — those survive async gaps because they're `TextEditingController` instances — but `profileSnap?.email` etc. could change.

---

## 🛑 #85: Mobile Client — `PendingReviewProvider` Uses a Linear Scan of All Bookings

```dart
final resource = await ref.watch(bookingsListProvider.future);
final items = resource.data?.items.toList() ?? [];

for (final b in items) {
  final isCompleted = b.status == BookingSummaryListResponseItemsInnerStatusEnum.completed;
  if (!isCompleted) continue;
  if (!ReviewPromptManager.shouldPrompt(b.id)) continue;
  return PendingReviewBooking(...);
}
```

For a user with 50+ past bookings (which is realistic for an app like this), this scans every booking and calls `Hive.get()` twice per booking (`_box.get` for `dismissedPrefix` and `_box.get` for `prefix`). The `shouldPrompt` method does 2 Hive reads per booking ID. For 50 bookings, that's 100 Hive reads on every navigation that triggers this provider.

On a mid-range Android device, each Hive read takes ~0.5-2ms. 100 reads = 50-200ms of UI thread blocking. This provider runs every time the booking list screen is navigated to (auto-dispose means it re-runs).

---

## Summary: What Can Actually Fail With Money

| # | Issue | Worst-case outcome | Fix priority |
|---|---|---|---|
| #70 | P2034 returns 500 instead of retry | User gets error, slot stays free for double-booking | **HIGH** |
| #71 | No booking idempotency key | Duplicate bookings for same slot | **HIGH** |
| #72 | Reschedule TOCTOU | Two bookings overlap after reschedule | **HIGH** |
| #73 | No unpaid booking expiration | Slots permanently blocked by unpaid bookings | **MEDIUM** |
| #74 | `providerTxId` not unique | Two payments linked to same provider transaction | **HIGH** |
| #76 | Out-of-sequence webhook regression | `succeeded → failed` reversal, possible with VALID_TRANSITIONS gap | **MEDIUM** |
| #77 | No crash handler | Process dies during payment webhook, operations lost | **HIGH** |
| #78 | depositPaymentStatus unindexed | Slow queries at scale, cleanup job takes too long | **LOW** |
| #80 | Reschedule ignores blocked slots | Employee double-booked during break/vacation | **MEDIUM** |
| #81 | Failed refund has no compensation | User charged but refund never processes | **HIGH** |
| #82 | Zero/nominal deposit allowed | Booking with 0 payment but slot blocked | **LOW** |
| #83 | Session refresh race | Two concurrent refresh calls, second fails | **MEDIUM** |
