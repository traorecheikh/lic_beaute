# Payment and iOS UX fixes

## What changed

- Removed customer-facing `PayDunya` terminology. Internal provider identifiers remain unchanged because the API contract still uses them.
- Added Wave and Orange Money logos to payment method selectors and saved-method cards.
- Replaced the oversized payment-verification sheet with a compact, non-scrolling sheet containing only:
  - payment status,
  - **Vérifier maintenant**,
  - **Revenir au paiement** or **Relancer le paiement**,
  - **Continuer plus tard**.
- Persisted external payment launch URLs by payment ID so the same attempt can be reopened after returning from another app or after the route is rebuilt.
- Added **Suivre le paiement** on the payment page while background confirmation is active. It returns to the foreground sheet instead of trapping the customer in a loading-only state.
- If reopening an external payment URL fails, the flow now falls back to relaunching the payment operation.
- Replaced the giant “Fermer la vérification” confirmation dialog with direct background continuation.
- Made app dialogs adaptive: iOS uses `CupertinoAlertDialog`; Android and other platforms use the branded app dialog.
- Routed profile and other standard page back buttons through the existing native iOS glass icon button on supported iOS versions.
- Updated the shared `AppButton` so long labels wrap to two lines and grow vertically instead of rendering `…`.
- Updated the salon booking CTA to use shorter “Dès …” copy and to wrap instead of truncating.
- Sanitized payment and payment-method errors so technical provider/backend terms are not exposed to customers.

## Main files

- `lib/src/features/booking/pages/payment_handoff_page.dart`
- `lib/src/features/booking/widgets/payment_waiting_sheet.dart`
- `lib/src/features/booking/paydunya_launch.dart`
- `lib/src/core/widgets/app_dialog.dart`
- `lib/src/core/widgets/app_back_button.dart`
- `lib/src/core/widgets/app_button.dart`
- `lib/src/features/discovery/widgets/salon_detail_buttons.dart`
- `lib/src/features/profile/widgets/payment_tile.dart`
- `lib/src/features/profile/widgets/payment_method_sheet.dart`

## Validation performed here

- Checked balanced Dart delimiters across `lib/` and `test/`.
- Confirmed no customer-facing `PayDunya`-cased string remains under `lib/src/`.
- Confirmed there are no Material `AlertDialog` instances remaining; the shared iOS dialog path is Cupertino.
- Confirmed `assets/wave.png` and `assets/om.png` are registered in `pubspec.yaml`.

Flutter and Dart executables were not available in this environment, so analyzer, widget tests, and device builds still need to be run locally:

```bash
flutter pub get
dart format lib test
flutter analyze lib test
flutter test
flutter run --profile -d <iphone-device-id>
```

## Physical-device checks

1. Start Wave payment, return without completing, and verify **Revenir au paiement** reopens the same attempt.
2. Close the tracking sheet with **Continuer plus tard**, then use **Suivre le paiement**.
3. Test a missing/invalid launch URL and verify the flow offers or triggers **Relancer le paiement**.
4. Test cancellation alerts and profile back buttons on iOS 26 and an older iOS fallback.
5. Enable large text and verify payment, empty-state, and salon CTA labels wrap without ellipses.
