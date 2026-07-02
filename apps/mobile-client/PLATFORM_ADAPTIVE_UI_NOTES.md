# Platform-adaptive navigation and search pass

## What changed

### iOS 26+

- Native Liquid Glass `CNTabBar` remains the bottom-navigation surface.
- Home search now uses a native `CNSearchBar` and a native glass Filter button.
- Full search uses a functional native `CNSearchBar`, synchronized with the existing search providers and debounce logic.
- Appointment tabs use a native `CNSegmentedControl`.
- Profile edit uses a native glass icon button.
- Salon detail back, share, and favorite controls use native glass icon buttons.
- Salon booking uses a native prominent-glass call-to-action.
- Native controls are coordinated with dialogs and sheets through `CNTabBarRouteObserver` and `CNSheetGeometryProbe`.
- Native glass is enabled by default in iOS release builds, with `--dart-define=BA_IOS_NATIVE_GLASS=false` available as a kill switch.

### Android

- Bottom navigation uses Material 3 `NavigationBar`.
- Home and full-page search use Material 3 `SearchBar` controls.
- Appointment tabs use Material 3 `SegmentedButton`.
- Profile edit and salon-detail actions use Material filled-tonal icon buttons.
- Salon booking uses a Material `FilledButton`.
- Existing edge-to-edge configuration remains in place.

### Intentionally unchanged

Content is not platform chrome, so the following remain shared and branded:

- Hero imagery, logo, greeting, and location text
- Appointment empty state and primary branded CTA
- Profile menu cards and account content
- Salon details, photos, labels, and service content
- Typography, colors, spacing, and information architecture

This avoids turning every white rectangle into translucent decoration and keeps native platform views out of scrolling lists.

## Search behavior

- Home search is a launcher; `SearchPage` remains the single owner of query state.
- Native iOS search text is synchronized with the existing Flutter controller and Riverpod search flow.
- The Filter action now opens an actual quick-filter sheet.
- Query parameters support `q` and `openFilters=1`.
- Opening filters directly does not unnecessarily raise the keyboard first.

## Required verification

The container used for this edit did not contain Flutter or Dart executables, so run these locally before release:

```bash
flutter pub get
dart format lib test integration_test
flutter analyze
flutter test
flutter run --profile -d <ios-device-id>
flutter run --profile -d <android-device-id>
```

On iOS 26, verify every native control with dialogs, payment sheets, the search keyboard, and rapid tab switching. On older iOS, verify the Flutter fallback. On Android, verify gesture navigation and three-button navigation.
