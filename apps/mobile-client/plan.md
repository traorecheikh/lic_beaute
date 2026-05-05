# Mobile client deduplication and structure plan (jscpd + widget architecture)

## Problem
`jscpd` reports **77 clones** in `lib/`, with **805 duplicated lines (5.77%)** and **7266 duplicated tokens (6.58%)**.

Structure audit highlights:
- Overloaded page folders (example: `lib/src/features/profile/pages` has **11 files**).
- Multiple "god pages" (high complexity and high refactor value), including:
  - `discovery/home_page.dart` (**1118 lines**)
  - `discovery/salon_detail_page.dart` (**808 lines**)
  - `appointments/booking_detail_page.dart` (**497 lines**)
  - `booking/payment_handoff_page.dart` (**419 lines**)
  - `discovery/search_page.dart` (**408 lines**)
  - `profile/payment_methods_page.dart` (**386 lines**)
- Repeated hardcoded `Color(...)`, hex color literals, and ad-hoc `fontSize`/`SizedBox`/spacing values across pages.

## Approach
Address duplication with four coordinated tracks:
1. **Deduplicate logic** (providers/helpers).
2. **Decompose large pages** into reusable widgets.
3. **Tokenize styling** (sizes, spacing, typography, colors) to remove hardcoded UI values.
4. **Reorganize folders** so pages, feature widgets, and global widgets are clearly separated.

All phases preserve behavior, routes, and state semantics.

## Style token and de-hardcoding rules (added)

### What must be removed
- Raw hex and inline `Color(...)` literals in feature/page widgets unless mapped to theme tokens.
- Repeated magic numbers for spacing/radius/icon/text sizes (`EdgeInsets`, `SizedBox`, `fontSize`, etc.).
- Ad-hoc text styles duplicated across screens.

### Replacement strategy
- Centralize colors in theme/token layers under `lib/src/core/theme/...`.
- Introduce shared spacing/size/text-style constants/extensions for repeated values.
- Replace repeated style fragments with reusable styled widgets where appropriate.

### Scope boundary
- Feature-specific visual variants stay in feature widgets if not reused outside the feature.
- Only cross-feature style primitives move to core theme/widgets.

## Widget extraction and placement rules (added)

### When to split a page
- Split any page above ~250 lines or with multiple repeated sections.
- Keep route pages as composition shells; move heavy UI sections out.
- Prefer small widgets with clear input models over giant shared widgets.

### Where widgets should live
- `lib/src/features/<feature>/widgets/`: reused within one feature only.
- `lib/src/core/widgets/`: reused across two or more features.
- `lib/src/features/<feature>/pages/<page_name>/widgets/`: page-scoped parts used only by that page.

### Global vs feature widget rule
- If a widget has dependencies/semantics specific to one feature, keep it in that feature.
- Promote to `core/widgets` only when reused across feature boundaries and still generic.

## Folder organization target (added)

Current pain point: some `pages/` folders are catch-all bins with unrelated screens.

Target organization:
- Keep `pages/` for route entry files only.
- Group unrelated screens by domain subfolders where needed.
- Co-locate page-specific widgets next to the page.
- Avoid mixing long-form legal/info pages with transactional flows in one flat folder.

Example target pattern:
`lib/src/features/profile/pages/account/...`, `.../support/...`, `.../membership/...` with local widget subfolders.

## Phases

### Phase 0 — Audit clone and structure hotspots
Actions:
- Build a hotspot matrix from jscpd + file length + folder crowding.
- Rank extraction candidates by impact (clone count + line count + reuse potential).
- Lock in first-pass target files before code changes.

### Phase 1 — Provider/state deduplication
Target files:
- `lib/src/features/profile/providers/profile_provider.dart`
- `lib/src/features/profile/providers/payment_methods_provider.dart`
- `lib/src/features/profile/providers/vouchers_provider.dart`
- `lib/src/features/profile/providers/benefits_provider.dart`
- `lib/src/features/notifications/providers/notifications_provider.dart`
- `lib/src/features/discovery/providers/salon_detail_provider.dart`
- `lib/src/features/appointments/providers/bookings_list_provider.dart`

Actions:
- Extract common async loading/error/success transitions into shared helpers.
- Reuse shared mapping/filter helpers where provider transforms are duplicated.
## UI Primitives & Micro-Duplication Cleanup (added)

### 1. The Layout Primitives (Spacing & Padding)
- **Problem:** `SizedBox(height: ...)` and `SizedBox(width: ...)` are used hundreds of times with hardcoded values. `EdgeInsets` are also hardcoded.
- **Goal:** Replace with semantic gap widgets and standard padding tokens.
- **Action:** 
    - Introduce `Gap` extension or constants in `app_spacing.dart` (e.g., `16.gapH`, `8.gapW` or `AppSpacing.gapH16`).
    - Standardize padding via `AppPadding` constants.

### 2. The Button Library (`AppButton`)
- **Problem:** `ElevatedButton`, `TextButton`, and `OutlinedButton` are used raw, repeating styling logic.
- **Goal:** Centralize into a single `AppButton` widget with named constructors.
- **Action:** Create `lib/src/core/widgets/app_button.dart` supporting `.primary()`, `.secondary()`, `.outline()`, and `.text()`.

### 3. The Input Library (`AppTextField` enhancement)
- **Problem:** `TextField` and `TextFormField` are reinvented in multiple pages (e.g., `edit_profile_page.dart`).
- **Goal:** Standardize all text inputs through `AppTextField`.
- **Action:** Enhance `AppTextField` to support password toggles, search icons, and validation states; replace all raw inputs.

### 4. The Top Bar (`AppTopBar`)
- **Problem:** `AppBar` is used 24 times, usually repeating the same transparent background, elevation 0, and back button logic.
- **Goal:** Create a unified `AppTopBar` or standardize via `AppBarTheme`.

### 5. Color & Style De-hardcoding
- **Problem:** `Colors.white`, `Colors.transparent`, and `Colors.black` are used directly instead of semantic tokens.
- **Goal:** 100% theme-driven UI.

## Phases

### Phase 2 — Global reusable widget primitives
Target files:
- `lib/src/core/widgets/app_button.dart` (New)
- `lib/src/core/widgets/app_top_bar.dart` (New)
- `lib/src/core/widgets/app_empty_state.dart`
- `lib/src/core/widgets/app_error_state.dart`
- `lib/src/core/widgets/app_connectivity_banner.dart`
- `lib/src/core/widgets/app_connectivity_recovery.dart`
- `lib/src/router/shell_scaffold.dart`
- `lib/src/core/widgets/app_snackbar.dart`

Actions:
- Implement `AppButton` and `AppTopBar`.
- Consolidate repeated status layouts and action rows.
- Standardize scaffold/snackbar/action composition APIs.

### Phase 3 — Style tokenization and hardcoded value cleanup
Primary targets:
- `lib/src/core/theme/app_spacing.dart` (Add Gap extensions/constants)
- `lib/src/core/theme/app_padding.dart` (New)
- `lib/src/features/**/pages/*.dart` (high-duplication files first)
- `lib/src/features/**/widgets/*.dart`
- `lib/src/core/widgets/*.dart`

Actions:
- Replace `SizedBox` with `Gap` equivalents.
- Replace hardcoded colors with theme/token references.
- Replace repeated magic size/spacing/typography values with shared constants.
- Normalize repeated inline text styles to reusable style helpers.

### Phase 4 — Split god pages into reusable sections
Primary targets:
- `lib/src/features/discovery/pages/home_page.dart`
- `lib/src/features/discovery/pages/salon_detail_page.dart`
- `lib/src/features/discovery/pages/search_page.dart`
- `lib/src/features/booking/pages/payment_handoff_page.dart`
- `lib/src/features/appointments/pages/booking_detail_page.dart`
- `lib/src/features/profile/pages/payment_methods_page.dart`

Actions:
- Extract repeated blocks (headers, cards, lists, status/CTA rows) into feature widgets.
- Keep page files focused on orchestration, not deep rendering logic.

### Phase 5 — Feature folder reorganization
Target features:
- `profile`, `discovery`, `booking`, `appointments`, then `auth` and `notifications`.

Actions:
- Reorganize crowded page folders by domain.
- Introduce `pages/<page_group>/...` where flat page folders are overloaded.
- Co-locate page-only widgets under page-scoped widget directories.

### Phase 6 — Cross-feature UI deduplication
Actions:
- Deduplicate repeated blocks across discovery, booking, appointments, and profile/auth.
- Promote eligible widgets from feature scope to `core/widgets` only when cross-feature reuse is proven.

### Phase 7 — Verification and metric check
Actions:
- Run formatter/analyzer/tests and rerun `jscpd`.
- Compare against baseline (5.77% duplicated lines / 6.58% duplicated tokens).
- Produce a residual hotspot list for a second pass.

## Notes
- Reuse existing helpers/widgets before introducing new abstractions.
- Favor incremental moves to reduce merge conflicts while reorganizing folders.
- No hardcoded feature-specific assumptions in global widgets.
- Avoid introducing new hardcoded style values while refactoring.
