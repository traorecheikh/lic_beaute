# Beauté Avenue — Search, Navigation & Layout Consistency Fix

Date: 2026-07-01

This patch is based on `BeauteAvenue_merged_latest_payment_ios_ux.zip` and preserves the payment/iOS UX merge already present there.

## Problems addressed

1. The Home search launcher was still a custom Flutter surface on iOS instead of the native iOS search treatment already available in the project.
2. The full Search page forced a custom background onto the native search bar and displayed a Material horizontal progress line on iOS.
3. The Home search control disappeared while scrolling instead of remaining available as a compact pinned header.
4. The salon gallery counter could render as an oversized circle and was poorly aligned.
5. The booking CTA could briefly expand into a full-screen pink capsule while opening the next booking route.
6. Profile, appointments, and other root-tab pages could place content or footers behind the floating bottom navigation bar.
7. The appointments segmented control did not follow the same iOS-native treatment as the rest of the platform-adaptive chrome.
8. The quick-filter sheet still used an isolated raw Material button instead of the app's adaptive button component.

## Implementation

### Home search

- `SearchBarContent` is now platform adaptive:
  - iOS 26+ with native glass enabled: `IOSNativeSearchBar`
  - Android: Material 3 `SearchBar`
  - older iOS: existing Beauté Avenue fallback
- Removed the explicit flat background from `CNSearchBar`, allowing the native component to render its own material.
- The filter action has a fixed width and single-line label so it does not collapse or truncate.
- The Home search launcher now uses a pinned `SliverPersistentHeader`, so it remains accessible after the hero content scrolls away.

### Full Search page

- Removed the custom background override from the native `CNSearchBar`.
- Replaced the Material horizontal progress line on iOS with a compact `CupertinoActivityIndicator`.
- Android retains the Material linear progress indicator.
- The quick-filter confirmation action now uses `AppButton.primary` instead of a raw Material button.

### Appointments

- iOS 26+ uses native `CNSegmentedControl` for `À VENIR / PASSÉS`.
- Android retains Material 3 `SegmentedButton`.
- Older iOS retains the existing fallback.
- Removed duplicate bottom-navigation compensation from appointment lists and empty states.

### Bottom navigation clearance

- `ShellScaffold` now uses `extendBody: false`.
- The shell reserves the actual bottom-navigation footprint in one place rather than asking each root page to guess its own clearance.
- Reduced obsolete 92–120 px page-level padding in Home, Profile, and appointments.
- This prevents profile legal/footer content, empty states, booking details, favorites, forms, and final list rows from sitting underneath the native glass or Material navigation bar.

### Salon gallery counter

- Replaced the floating circular counter with a fixed-height compact pill.
- Added an image icon and a tighter `1/3` presentation.
- Applied the same treatment to the salon hero and full-screen gallery.

### Broken full-screen booking CTA

- `AppBottomBar` now shrink-wraps its child using `Align(heightFactor: 1)`.
- Service and staff selection CTAs now have an explicit 58 px logical height.
- This prevents a loose route-transition constraint from turning `Continuer` into a full-screen rounded rectangle.
- Removed a duplicate unreachable `SalonDetailPage` return in the route builder.
- The booking-route error action now uses the shared `AppButton` instead of a one-off raw Material button.

## Files changed

1. `lib/src/core/widgets/app_bottom_bar.dart`
2. `lib/src/core/widgets/ios_native_search_bar.dart`
3. `lib/src/features/appointments/pages/booking_detail_page.dart`
4. `lib/src/features/appointments/pages/booking_manage_page.dart`
5. `lib/src/features/appointments/pages/bookings_list_page.dart`
6. `lib/src/features/booking/pages/service_selection_page.dart`
7. `lib/src/features/booking/pages/staff_selection_page.dart`
8. `lib/src/features/discovery/pages/favorites_page.dart`
9. `lib/src/features/discovery/pages/home_page.dart`
10. `lib/src/features/discovery/pages/salon_detail_page.dart`
11. `lib/src/features/discovery/pages/search_page.dart`
12. `lib/src/features/discovery/widgets/home_sections/app_bar_sections.dart`
13. `lib/src/features/discovery/widgets/salon_gallery_viewer.dart`
14. `lib/src/features/discovery/widgets/search_sections/search_bar.dart`
15. `lib/src/features/profile/pages/edit_profile_page.dart`
16. `lib/src/features/profile/pages/legal_page.dart`
17. `lib/src/features/profile/pages/profile_page.dart`
18. `lib/src/router/app_router.dart`
19. `lib/src/router/shell_scaffold.dart`
20. `test/core/widgets/app_bottom_bar_test.dart`
21. `test/src/router/shell_scaffold_widget_test.dart`

## Regression tests added

- `AppBottomBar` must remain compact in a full-height Scaffold.
- `ShellScaffold` must reserve the bottom navigation footprint (`extendBody == false`).

## Static verification performed

- Compared patch against the merged input: exactly 21 code/test files changed.
- Checked all changed Dart files for balanced parentheses, brackets, and braces while ignoring strings and comments.
- Verified all relative Dart imports resolve to existing files.
- Checked for unresolved merge markers.
- Confirmed no direct Material `AlertDialog` remains under `lib/src`.
- Confirmed the app shell no longer uses `extendBody: true`.
- Confirmed the remaining search `LinearProgressIndicator` is only in the Android branch.
- Verified ZIP integrity after packaging.

## Required local validation

Flutter and Dart executables are not available in the patching environment, so run:

```bash
cd apps/mobile-client  # or the extracted project root
rm -rf ios/Flutter/ephemeral/Packages
flutter clean
flutter pub get
dart format lib test
flutter analyze lib test
flutter test
flutter run --profile
```

The `ios/Flutter/ephemeral/Packages` cleanup is included because the supplied project contained evidence of a previous `PathExistsException` around the generated `integration_test` package link.

## Physical-device checklist

### iOS 26+

- Home search is native and visually consistent with the native tab bar.
- Search remains pinned while scrolling, without covering the hero/header.
- Search typing displays a small iOS spinner, not a Material progress line.
- Filter button remains one line and does not truncate.
- `À VENIR / PASSÉS` uses the native segmented control.
- Salon photo counter remains a small aligned pill in portrait and landscape.
- Tapping `Réserver` never produces a full-screen pink `Continuer` capsule.
- Profile footer, legal links, empty appointment state, and final rows remain fully above the tab bar.
- Payment sheets, dialogs, and keyboard still cover/hide the native tab bar correctly.

### Android

- Home search uses Material 3 and remains pinned.
- Search activity remains a Material linear progress indicator.
- Appointments use Material 3 segmented buttons.
- Bottom navigation spacing is correct with gesture and three-button navigation.
- No visual regressions from the iOS-specific native controls.
