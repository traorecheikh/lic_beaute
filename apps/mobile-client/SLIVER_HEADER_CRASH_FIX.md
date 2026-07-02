# Bookings sliver header crash fix

## Failure

Opening **Mes RDV** could throw:

- `SliverGeometry is not valid: layoutExtent exceeds paintExtent`
- followed by null-check and semantics assertions caused by the failed render pass

The failing widget was the pinned `SliverPersistentHeader` in
`lib/src/features/appointments/pages/bookings_list_page.dart`.

The header advertised a fixed ScreenUtil-scaled extent while its native/adaptive
segmented-control subtree painted to a slightly different height on the iPhone
viewport. `NestedScrollView` then received invalid sliver geometry.

## Fix

The appointments page does not require a nested outer scroll view because each
`TabBarView` child already owns its own scrolling list. The page now uses:

- a normal, intrinsically measured header containing the title and segmented control;
- an `Expanded` body containing the existing `AppAsyncView` and `TabBarView`;
- the existing per-tab `ListView`/`RefreshIndicator` behavior unchanged.

The fragile `_TabBarDelegate` and `SliverPersistentHeader` were removed.

## Regression coverage

Added:

`test/src/features/appointments/bookings_list_layout_test.dart`

The test renders the page at the reported 402-pixel viewport width, supplies an
empty bookings result, and verifies that the heading and both segments render
without a layout exception.

## Files changed

1. `lib/src/features/appointments/pages/bookings_list_page.dart`
2. `test/src/features/appointments/bookings_list_layout_test.dart`
3. `SLIVER_HEADER_CRASH_FIX.md`

## Local validation

Run from the mobile-client root:

```bash
flutter pub get
dart format lib/src/features/appointments/pages/bookings_list_page.dart \
  test/src/features/appointments/bookings_list_layout_test.dart
flutter analyze lib test
flutter test test/src/features/appointments/bookings_list_layout_test.dart
```

Then open **Mes RDV** on the same iPhone/simulator size and switch repeatedly
between **À venir** and **Passés**.
