# Payment/iOS UX merge report

## Inputs

- **Current project:** `Archive.zip`
- **Payment/iOS UX implementation:** `BeauteAvenue_payment_ios_ux_fix.zip`
- **Common base used for the three-way comparison:** `BeauteAvenue_platform_adaptive_glass_search.zip`

The current project was used as the destination. The payment changes were applied surgically rather than replacing the whole project, so later work in `Archive.zip` remains intact.

## Merge decisions

### Custom three-way merge

- `lib/src/core/constants/app_strings.dart`
  - Kept all newer strings and formatting from the current project.
  - Replaced only the payment-facing copy changed by the UX fix.
  - Added the new actions: **Revenir au paiement**, **Relancer le paiement**, **Continuer plus tard**, and **Suivre le paiement**.
  - Removed customer-facing PayDunya references while retaining internal API identifiers elsewhere.

### Payment UX files applied from the fix

- `lib/src/features/booking/pages/payment_handoff_page.dart`
  - Restores/reopens the same external payment attempt.
  - Exposes payment status and retry/relaunch actions.
  - Removes the oversized close-verification confirmation flow.

- `lib/src/features/booking/widgets/payment_waiting_sheet.dart`
  - Uses a compact payment status sheet.
  - Adds verify, reopen/restart, and continue-later actions.
  - Avoids the long scrolling debug-like presentation.

- `lib/src/features/booking/paydunya_launch.dart`
  - Persists external launch targets by payment ID.
  - Uses customer-safe launch labels.

- `lib/src/features/booking/utils/payment_error_handler.dart`
  - Sanitizes technical provider/backend errors before display.

- `lib/src/features/booking/widgets/method_tile.dart`
- `lib/src/features/booking/widgets/payment_card_form.dart`
  - Updates payment method presentation and customer-facing wording.

- `lib/src/features/profile/pages/payment_methods_page.dart`
- `lib/src/features/profile/widgets/payment_method_sheet.dart`
- `lib/src/features/profile/widgets/payment_tile.dart`
  - Adds consistent Wave/Orange Money branding and sanitized errors.

### Shared iOS/adaptive UI files applied from the fix

- `lib/src/core/widgets/app_dialog.dart`
  - Uses `CupertinoAlertDialog` on iOS and the branded dialog elsewhere.

- `lib/src/core/widgets/app_back_button.dart`
  - Uses the supported native iOS glass back control where available, with the existing fallback elsewhere.

- `lib/src/core/widgets/app_button.dart`
  - Allows long labels to wrap to two lines and expand vertically instead of rendering an ellipsis.

- `lib/src/features/discovery/widgets/salon_detail_buttons.dart`
  - Uses shorter CTA wording and permits wrapping instead of truncation.

- `lib/src/features/profile/pages/profile_page.dart`
  - Keeps profile navigation/actions consistent with the adaptive controls.

### Tests applied from the fix

- `test/core/widgets/app_button_test.dart`
- `test/src/features/booking/paydunya_launch_test.dart`

### Current-project versions deliberately preserved

- `pubspec.yaml`
  - Kept current version `0.5.7+4` rather than reverting to the fix archive's older build number.
  - Kept the current Swift Package Manager configuration and registered assets.

- `lib/src/core/widgets/android_material_nav_bar.dart`
  - Kept the current project's later Android navigation styling because the differences were unrelated to the payment fix.

- `ios/Runner.xcodeproj/project.pbxproj` and all other iOS project/build files
  - Kept the current project's Privacy Manifest and later Xcode changes.
  - Did not import stale generated CocoaPods/SPM differences from the older fix archive.

- `lib/src/core/theme/app_theme.dart`
- `lib/src/router/shell_scaffold.dart`
  - The current project already contained the same adaptive-navigation changes, so no replacement was needed.

## Files changed relative to `Archive.zip`

1. `lib/src/core/constants/app_strings.dart`
2. `lib/src/core/widgets/app_back_button.dart`
3. `lib/src/core/widgets/app_button.dart`
4. `lib/src/core/widgets/app_dialog.dart`
5. `lib/src/features/booking/pages/payment_handoff_page.dart`
6. `lib/src/features/booking/paydunya_launch.dart`
7. `lib/src/features/booking/utils/payment_error_handler.dart`
8. `lib/src/features/booking/widgets/method_tile.dart`
9. `lib/src/features/booking/widgets/payment_card_form.dart`
10. `lib/src/features/booking/widgets/payment_waiting_sheet.dart`
11. `lib/src/features/discovery/widgets/salon_detail_buttons.dart`
12. `lib/src/features/profile/pages/payment_methods_page.dart`
13. `lib/src/features/profile/pages/profile_page.dart`
14. `lib/src/features/profile/widgets/payment_method_sheet.dart`
15. `lib/src/features/profile/widgets/payment_tile.dart`
16. `test/core/widgets/app_button_test.dart`
17. `test/src/features/booking/paydunya_launch_test.dart`

Documentation added:

- `PAYMENT_UX_IOS_FIX_NOTES.md`
- `MERGE_REPORT.md`
- `MERGE_MANIFEST.json`

Every other project file is preserved from `Archive.zip`. macOS ZIP metadata (`__MACOSX` and `._*`) was removed from the deliverable.

## Static validation performed

- No unresolved merge markers.
- Balanced Dart braces, brackets, parentheses, comments, and strings in all modified Dart files.
- No duplicate `AppStrings` constants.
- No missing relative Dart imports.
- No customer-visible `PayDunya`-cased strings under `lib/src`.
- No direct Material `AlertDialog` remains under `lib/src`.
- `assets/wave.png` and `assets/om.png` remain registered.
- Current app version remains `0.5.7+4`.

Flutter/Dart executables are not available in this environment. Run before release:

```bash
flutter pub get
dart format lib test
flutter analyze lib test
flutter test
flutter run --profile -d <iphone-device-id>
```

## Required device checks

1. Begin a payment, return without completing it, and confirm **Revenir au paiement** reopens the same attempt.
2. Use **Continuer plus tard**, then reopen the foreground status using **Suivre le paiement**.
3. Force an invalid/missing launch URL and verify **Relancer le paiement** remains available.
4. Confirm cancellation and destructive dialogs use the Cupertino presentation on iOS.
5. Test large Dynamic Type on payment, empty-state, salon-detail, and navigation labels.
6. Verify profile and nested-page back buttons use the same iOS treatment.
7. Repeat the rapid tab-switch performance test after the merge.
