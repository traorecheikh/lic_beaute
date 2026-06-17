# Audit Mobile — Tests & Couverture

> Généré le 17 juin 2026

## Score : **C+ (68/100)** 🟠

---

## 1. Infrastructure de test

### Stack technique

| Technologie | Usage | Version |
|---|---|---|
| `flutter_test` | Tests unitaires & widgets | SDK |
| `patrol` | Tests E2E (+ integration) | ^4.6.0 |
| `mocktail` / `mockito` | Mocking | Non utilisés |
| `accessibility_radar` | WCAG live scan (DevTools) | ^0.3.0 |
| `custom_lint` / `riverpod_lint` | Analyse statique | ^0.8.1 / ^3.1.0 |

### Arborescence des tests

```
test/
├── test_harness.dart                          # ProviderScope wrapper + mocks
├── core/
│   ├── models/
│   │   └── account_models_test.dart
│   ├── network/
│   │   ├── app_network_error_test.dart
│   │   ├── dio_exception_utils_test.dart
│   │   └── retry_with_backoff_test.dart
│   ├── providers/
│   │   ├── profile_provider_test.dart
│   │   ├── provider_mock_dio_test.dart
│   │   └── supported_countries_provider_test.dart
│   ├── session/
│   │   └── session_state_test.dart
│   ├── theme/
│   │   └── app_theme_test.dart
│   ├── utils/
│   │   ├── app_list_utils_test.dart
│   │   └── status_labels_test.dart
│   └── widgets/
│       ├── app_button_test.dart
│       ├── app_chip_and_misc_widgets_test.dart
│       ├── app_phone_field_test.dart
│       └── app_pressable_test.dart
├── src/
│   ├── features/
│   │   ├── appointments/
│   │   │   └── booking_detail_widget_test.dart
│   │   ├── auth/
│   │   │   ├── auth_errors_test.dart
│   │   │   ├── auth_pages_widget_test.dart
│   │   │   └── auth_router_helper_test.dart
│   │   ├── booking/
│   │   │   ├── booking_actions_test.dart
│   │   │   ├── booking_create_error_test.dart
│   │   │   ├── booking_flow_integration_test.dart
│   │   │   ├── booking_format_test.dart
│   │   │   ├── booking_pages_render_test.dart
│   │   │   ├── booking_pages_widget_test.dart
│   │   │   ├── paydunya_launch_test.dart
│   │   │   ├── payment_handoff_navigation_test.dart
│   │   │   ├── payment_methods_record_test.dart
│   │   │   └── payment_utils_test.dart
│   │   └── profile/
│   │       ├── benefits_vouchers_test.dart
│   │       └── profile_page_widget_test.dart
│   └── router/
│       └── app_router_setup_test.dart
patrol_test/
├── auth_setup_flow_test.dart
├── debug_test.dart
├── minimal_test.dart
└── test_bundle.dart
```

### Statistiques

| Métrique | Valeur |
|---|---|
| Fichiers de test (unit/widget) | **32** (avec `void main`) |
| Fichiers E2E (Patrol) | **4** (1 réel + 3 boilerplate) |
| Fichiers source `lib/src/` | **156** |
| Ratio tests / source | **20,5 %** |
| SLOC total app | **~31 000** |
| Lignes de test estimées | ~4 500 |

---

## 2. ✅ Points forts

### Bonne couverture par feature

| Feature | Fichiers test | Qualité |
|---|---|---|
| **Booking** | 10 | ✅ La mieux couverte — flux critique |
| **Core** | 15 | ✅ Très bonne couverture utils + widgets |
| **Auth** | 3 | ✅ Couverture correcte |
| **Profile** | 2 | ⚠️ Partielle |
| **Appointments** | 1 | ⚠️ Minimale |
| **Router** | 1 | ✅ Test base |
| **Discovery** | 0 | ❌ **Aucun test** |
| **Notifications** | 0 | ❌ **Aucun test** |

### Patterns de test

- ✅ **Test harness partagé** : `test_harness.dart` factorise la config ProviderScope
- ✅ **Mock Dio** : `provider_mock_dio_test.dart` teste les appels API mockés
- ✅ **Tests de pages** : `booking_pages_widget_test.dart` teste le rendu UI
- ✅ **Tests d'intégration** : `booking_flow_integration_test.dart` teste le funnel booking complet
- ✅ **Tests de navigation** : `payment_handoff_navigation_test.dart` teste les transitions de pages
- ✅ **Patrol E2E** : présent pour les flows critiques (auth setup)

### Tests spécifiques notables

| Test | Ce qu'il couvre |
|---|---|
| `booking_create_error_test.dart` | 401, timeout, 500 → messages français |
| `payment_handoff_navigation_test.dart` | Redirections payment → succès, échec |
| `paydunya_launch_test.dart` | URL launching pour Wave/Orange Money |
| `booking_format_test.dart` | Formatage durée, prix XOF |
| `session_state_test.dart` | États de session (authenticated, loading, unauthenticated) |

---

## 3. ⚠️ Problèmes identifiés

### Couverture manquante

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| T1 | **Discovery feature non testée** : `SalonListPage`, `SearchPage`, `HomePage`, `FavoritesPage` — 0 test | **Critical** |
| T2 | **Notifications feature non testée** : provider, page, widget — 0 test | **Major** |
| T3 | **Aucun test des providers principaux** : `salonDetailProvider`, `searchProvider`, `favoritesProvider`, `bookingsListProvider` — non testés | **Major** |
| T4 | **Aucun test d'upload media** : `MediaUploadService`, parcours upload avatar/photo | **Major** |
| T5 | **Aucun test offline** : outbox, cache Hive, fallback offline — pas testé | **Major** |
| T6 | **Aucun test de thème dark mode** : `AppTheme.dark` non testé | **Minor** |
| T7 | **Aucun test de localisation** : format XOF, dates françaises, textes localisés | **Minor** |

### Qualité des tests

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| T8 | **Warnings dart analyze dans les tests** : 7 warnings (dead code, unused imports) | **Major** |
| T9 | **`test_harness.dart` non utilisé partout** : plusieurs tests refont leur propre ProviderScope — duplication | **Minor** |
| T10 | **Import patterns mixtes** : certains tests utilisent des imports relatifs (`../../../`) d'autres des imports package (`package:beauteavenue_mobile_client/...`) | **Minor** |
| T11 | **Pas de `mocktail`/`mockito`** : pas de bibliothèque de mocking explicite — les tests utilisent la vraie classe `Dio` avec un mock HTTP | **Minor** |
| T12 | **Aucun test de performance** : pas de test de temps de rendu, rebuild count, ou mémoire | **Info** |
| T13 | **Patrol E2E : 3 fichiers boilerplate** sur 4 — un seul test réel (`auth_setup_flow_test.dart`) | **Minor** |

### CI & Analyse

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| T14 | **Pas de CI mobile** : aucun workflow GitHub Actions pour exécuter `flutter test` ou `dart analyze` | **Critical** |
| T15 | **`dart analyze` trouve 71 issues** : 0 errors, 22 warnings, 49 infos — à nettoyer | **Major** |
| T16 | **Aucune métrique de couverture** : `flutter test --coverage` jamais exécuté dans le CI | **Major** |
| T17 | **`riverpod_lint` non activé** : présent dans `pubspec.yaml` (dev) mais pas dans `analysis_options.yaml` | **Minor** |
| T18 | **Pas de lint custom** : `custom_lint` présent mais `analysis_options.yaml` minimal (inclut seulement `flutter_lints`) | **Minor** |

### Analyse des 71 issues dart analyze

| Catégorie | Nombre | Exemples |
|---|---|---|
| **Errors** | 0 | ✅ Aucune erreur |
| **Warnings** | 22 | dead_code, unused_imports — principalement dans les tests |
| **Infos** | 49 | deprecated_member_use (salon_list_provider.dart), use_null_aware_elements, prefer_is_empty, avoid_relative_lib_imports, unnecessary_underscores, use_build_context_synchronously |

Top warnings à corriger :
- `deprecated_member_use` : `apiV1SalonsGet` déprécié (5 occurrences dans `salon_list_provider.dart`)
- `use_null_aware_elements` : pattern `if (x != null) ...[x]` → `?...[x]` (8 occurrences)
- `avoid_relative_lib_imports` : imports relatifs vers `lib/` depuis les tests (15 occurrences)
- `dead_code` : dans `booking_pages_widget_test.dart` après un `return`

---

## 4. Analyse détaillée par layer

### Core (15 tests)
✅ **Bien couvert** : réseau, erreurs, theme, widgets de base, utils, session

- `retry_with_backoff_test.dart` ✅ Teste le retry exponentiel
- `app_network_error_test.dart` ✅ Teste le mapping d'erreurs
- `app_button_test.dart` ✅ Teste les variants de boutons
- `app_pressable_test.dart` ✅ Teste les interactions tactiles

### Booking (10 tests)
✅ **Bien couvert** : flux critique le mieux testé

- Teste le funnel complet (intégration)
- Teste le lancement URL PayDunya
- Teste les erreurs de création
- Teste le formatage des données

### Auth (3 tests)
⚠️ **Couverture partielle** : pages + erreurs + helper router

- Manque : test du provider auth (refresh token, logout, restore session)
- Manque : test de l'intercepteur 401
- Manque : test du email OTP flow

### Profile (2 tests)
⚠️ **Minimal** : benefits/vouchers + widget page

- Manque : test edit profile, payment methods, support, faq
- Manque : test upload avatar

### Appointments (1 test)
❌ **Insuffisant** : un seul test widget booking detail

- Manque : bookings list, manage page, review new
- Manque : booking actions (cancel, reschedule)
- Manque : pending review prompt

### Discovery (0 test)
❌ **Aucun test** — la feature la plus utilisée

- Liste salons (home, search, categories)
- Salon detail (infos, avis, disponibilités)
- Search (suggestions, résultats, filtres)
- Favorites (add, remove, list)

---

## 5. Recommandations

### 🔴 Priorité haute — À faire immédiatement

1. **Configurer CI mobile** : au moins `flutter analyze` + `flutter test` sur chaque PR
2. **Corriger les 22 warnings dart analyze** : dead_code + unused_imports dans les tests
3. **Remplacer `apiV1SalonsGet` déprécié** dans `salon_list_provider.dart` par la méthode de remplacement
4. **Écrire des tests pour Discovery** : au moins `salonDetailProvider` et `searchProvider`

### 🟡 Priorité moyenne — Sprint en cours

5. **Ajouter `riverpod_lint` à `analysis_options.yaml`** : déjà en dépendance, pas activé
6. **Standardiser les imports** : choisir entre relatifs et package, les unifier
7. **Écrire des tests pour Notifications** : provider, page, unread count
8. **Écrire des tests pour les providers booking** : `bookingsListProvider`, `bookingDetailProvider`

### 🟢 Priorité basse — Amélioration continue

9. **Ajouter `mocktail`** pour des mocks plus propres que les faux `Dio` manuels
10. **Ajouter un test Patrol E2E pour le booking funnel** (le plus gros risque métier)
11. **Activer `flutter test --coverage`** avec un seuil minimum (30%+)
12. **Ajouter des tests de performance** pour `PaymentHandoffPage` (rebuilts excessifs)

---

## 6. Résumé

L'infrastructure de test est présente et bien structurée (**32 tests unitaires/widgets + 4 Patrol E2E**), mais avec des **lacunes critiques** :

- 🔴 **Discovery** (la feature cœur) n'a **aucun test**
- 🔴 **Pas de CI mobile** pour exécuter les tests automatiquement
- 🔴 **71 issues dart analyze** dont 22 warnings à corriger
- 🟡 La qualité des tests existants est bonne (intégration, fixtures, edge cases)

**Prochaine étape** : CI mobile + tests discovery + correction des warnings.
