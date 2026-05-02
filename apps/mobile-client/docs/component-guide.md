# Mobile Client — Component Guide

The goal is **< 1% raw-widget duplication**: every UI primitive used more than once lives in
`lib/src/core/widgets/` and is imported from there. No ad-hoc `TextFormField`, `DropdownButton`,
or inline containers that duplicate styling logic.

---

## Current centralized primitives

| Widget | File | Replaces |
|---|---|---|
| `AppTextField` | `app_text_field.dart` | Raw `TextFormField` with manual `InputDecoration` |
| `AppDropdown<T>` | `app_dropdown.dart` | `DropdownButtonFormField`, `CupertinoActionSheet`, `ListTile` bottom sheets |
| `AppPhoneField` | `app_phone_field.dart` | Ad-hoc phone + country composite fields |
| `AppEmptyState` | `app_empty_state.dart` | Inline `Column(Icon, Text, Text)` empty blocks |
| `AppErrorState` | `app_error_state.dart` | Inline error containers |
| `AppSnackbar` | `app_snackbar.dart` | Raw `ScaffoldMessenger.showSnackBar` |
| `AppIcon` | `app_icon.dart` | Direct `SvgPicture.asset` calls |

---

## Rules

### TextFormField
Always use `AppTextField`. Never write `TextFormField(decoration: InputDecoration(...))` inline.
The theme in `app_theme.dart` → `inputDecorationTheme` is the single source of truth for borders,
fill color, focus ring, and error style. `AppTextField` exposes every safe parameter but hides
`decoration` so no ad-hoc overrides can creep in.

```dart
// ✅
AppTextField(
  controller: _ctrl,
  labelText: 'Ville',
  keyboardType: TextInputType.text,
  validator: (v) => v!.isEmpty ? 'Requis' : null,
)

// ❌ — bypasses centralized style
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,
    labelText: 'Ville',
  ),
)
```

### Dropdowns
Always use `AppDropdown<T>`. Never use `DropdownButtonFormField`, `CupertinoPicker`,
`CupertinoActionSheet`, or a raw `showModalBottomSheet` that renders a list picker.

```dart
// ✅
AppDropdown<String>(
  label: 'Opérateur',
  items: const ['wave', 'orange_money'],
  value: _provider,
  itemLabel: (p) => p == 'wave' ? 'Wave' : 'Orange Money',
  onChanged: (p) => setState(() => _provider = p),
)

// ❌ — platform-specific, not centralized
Platform.isIOS
  ? CupertinoActionSheet(...)
  : DropdownButtonFormField(...)
```

### Phone numbers
Use `AppPhoneField` for any phone number input that needs a country code.
It defaults to 🇸🇳 +221 (Sénégal). The full international number
(`dialCode + localDigits`) is what you store and send to the API.

```dart
AppPhoneField(
  controller: _phoneCtrl,
  onCountryChanged: (c) => setState(() => _country = c),
)
// Stored value: '${_country.dialCode}${_phoneCtrl.text}'
```

### Country list
`kPhoneCountries` (exported from `app_phone_field.dart`) is the single authoritative list.
Add countries there; never define a local list.

### Empty / error states
| Situation | Widget |
|---|---|
| No data yet (first load, zero items) | `AppEmptyState` |
| API / network error with retry | `AppErrorState` |

---

## How to add a new primitive

1. Create `lib/src/core/widgets/app_<name>.dart`
2. Export only what callers need — keep helpers private
3. Update this table above
4. Search for raw usages of the widget you're replacing: `grep -rn "TextFormField\|DropdownButton" lib/` and migrate them

---

## Pending migrations (next step)

These files still use raw primitives and should be migrated to `AppTextField` / `AppDropdown`:

| File | Raw usage |
|---|---|
| `features/auth/pages/email_login_page.dart` | `TextFormField` |
| `features/auth/pages/otp_login_page.dart` | `TextFormField` (if any) |
| `features/profile/pages/edit_profile_page.dart` | `TextFormField` × 4 |
| `features/booking/pages/booking_review_page.dart` | check for inline fields |

Run this to find remaining raw usages:

```bash
grep -rn "TextFormField\|DropdownButtonFormField\|CupertinoActionSheet" \
  lib/src/features/ --include="*.dart"
```

---

## Theme tokens (single source of truth)

| Token | File | Controls |
|---|---|---|
| Colors | `core/theme/app_colors.dart` | All named colors — never use `Color(0x...)` inline |
| Text styles | `core/theme/app_text_styles.dart` | Typography — never use `TextStyle(...)` inline |
| Shadows | `core/theme/app_shadows.dart` | Card / modal shadows |
| Spacing | `core/theme/app_spacing.dart` | Named radius and spacing constants |
| Input fields | `core/theme/app_theme.dart` → `inputDecorationTheme` | Fill, borders, focus ring |
