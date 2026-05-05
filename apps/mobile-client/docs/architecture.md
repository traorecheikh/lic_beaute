# Mobile Architecture — Layered & Reusable

This document outlines the architectural patterns and "building style" adopted for the Beauté Avenue mobile client. Future developers and AI agents **must** adhere to these patterns to prevent regression into duplicated, high-complexity code.

---

## 1. The Core Philosophy: "Boring is Better"
We aim for **minimal logic density** at the View (Page) layer. If a piece of logic (parsing, formatting, state handling) is needed in more than one place, it belongs in a **Provider**, an **Extension**, or a **Centralized Widget**.

---

## 2. Layered Data Handling (The DTO Pattern)
Never parse raw API Maps (`Map<String, dynamic>`) directly inside a `build` method. Use **Model Extensions**.

### Centralized Parsing via `CachedResource` Extensions
All common data transformations live in `lib/src/features/discovery/providers/cached_resource.dart`.
- **Extension:** `BookingMapExtension` on `CachedResource<Map<String, dynamic>>`.
- **Usage:** Instead of `(data['salonName'] as String?) ?? 'Salon'`, use `resource.salonName`.

---

## 3. Boilerplate Elimination: Async Scaffolds
Instead of writing 100+ lines of `AppAsyncView`, `CustomScrollView`, and `RefreshIndicator` in every page, use specialized **Async Scaffolds**.

### `AppBookingAsyncScaffold<T>`
Used for any page driven by a `bookingId` (Success, Detail, Review, Payment).
- **Benefit:** Handles loading, errors, stale data notices, and shared sliver layouts automatically.
- **Pattern:** Pass a `sliverBuilder` that receives the full `CachedResource`.

---

## 4. UI Primitives (The "No Raw Widget" Rule)
Every primitive UI element must be a centralized widget. **Direct use of Flutter material primitives is forbidden if a specialized version exists.**

| Forbidden Raw Widget | Required Centralized Widget |
|---|---|
| `TextFormField` | `AppTextField` |
| `DropdownButtonFormField` | `AppDropdown` |
| `ElevatedButton`, `TextButton` | `AppButton` (e.g. `AppButton.primary`) |
| `SizedBox(height: ...)` | Semantic Gaps (`gapH12`, `gapW16`) |
| `EdgeInsets.all(...)` | `AppPadding` (e.g. `AppPadding.allMd`) |
| `BoxShadow(...)` | `AppShadows` (e.g. `AppShadows.nav`) |

---

## 5. Summary Mapping (The "Generic Card" Rule)
When displaying list items (Salons, Bookings), use **Generic Cards** that accept high-level model types.
- **Example:** `SalonListCard` accepts a `SalonSummary` object. It uses the `SalonSummaryExtension` (`formattedLocation`) to handle display logic internally.

---

## 6. Shared Feature Dependencies
For complex funnels (like Booking), use a **Shared Dependency File**.
- **Example:** `lib/src/features/booking/widgets/booking_funnel_shared.dart` exports all common imports for the funnel steps to maintain consistency and reduce import bloat.

---

## 7. Error Handling Strategy
Never write manual `catch (e) { AppSnackbar.error(...) }` blocks in pages.
- **Extension:** Use `context.handleHttpError(error, fallback)` from `app_http_error_handler.dart`.
- **Benefit:** Standardizes API message extraction and snackbar presentation.
