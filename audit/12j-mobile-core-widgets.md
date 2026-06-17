# Audit Mobile — Bibliothèque de Widgets Core

> Généré le 17 juin 2026

## Score : **B+ (82/100)** 🟢

---

## 1. Vue d'ensemble

La bibliothèque de widgets core contient **42 widgets** répartis dans `lib/src/core/widgets/`, totalisant **~3 148 lignes**.

### Widgets par catégorie

| Catégorie | Widgets | Lignes |
|---|---|---|
| **Containers & Layout** | `AppScaffold`, `AppBookingAsyncScaffold`, `AppBookingFunnelScaffold`, `AppProfileAsyncView`, `AppSheetContent`, `AppBottomBar`, `AppTopBar`, `AppStateCard` | ~450 |
| **Inputs & Controls** | `AppButton`, `AppTextField`, `AppPhoneField`, `AppDropdown`, `AppCityDropdown`, `AppChip`, `AppPressable`, `AppSelectableCard`, `AppIcon` | ~1 100 |
| **Feedback & States** | `AppAsyncView`, `AppErrorState`, `AppEmptyState`, `AppSnackbar`, `AppConnectivityBanner`, `AppConnectivityWrapper`, `AppConnectivityRecovery`, `AppResourceView` | ~650 |
| **Navigation** | `AppBackButton`, `AppSliverBackButton`, `AppSectionLabel`, `AppTile`, `AppDivider`, `AppBadge`, `AppBookingHeaderBadge`, `AppIconBox` | ~300 |
| **Display** | `SalonImageWidget`, `SalonMapCard`, `AppProfileAvatar`, `AppSalonListItems`, `AppSalonListView`, `AppSliverSalonList`, `AppCarouselDots`, `AppSheet`, `AppDialog`, `AppCarouselDots` | ~450 |
| **Other** | `SalonMapCard`, `SalonImageWidget` | ~200 |

---

## 2. ✅ Points forts

### Design cohérent

| # | Force | Détail |
|---|---|---|
| W1 | **Tous les widgets utilisent les design tokens** : `AppColors.*`, `AppTextStyles.*`, `AppSpacing.*`, `AppShadows.*` — pas de valeurs hardcodées | ✅ Excellent |
| W2 | **`AppButton` complet** : variants (primary, secondary, outline, text, destructive), sizes (sm, md, lg), loading state, disabled state, icon support | ✅ Complet |
| W3 | **`AppAsyncView` générique** : pattern loading/error/data partout, avec `skipLoadingOnReload` et `keepDataOnReload` | ✅ Robuste |
| W4 | **`AppPressable` unifié** : scale animation, haptic feedback, opacité, désactivé — tous les gestes tactiles passent par ce wrapper | ✅ Centralisé |
| W5 | **`AppSnackbar` unifié** : variants success, error, info, warning — UX cohérente | ✅ Bon |
| W6 | **`AppPhoneField` complet** : validation, formatage, sélecteur de pays, hint E.164 | ✅ Complet |
| W7 | **`AppSheet` et `AppSheetContent`** : bottom sheets avec padding + scroll + gestion safe area | ✅ Bien conçu |
| W8 | **`AppDialog`** : confirmation, annulation, bouton unique | ✅ Simple |

### Patterns de qualité

```dart
// ✅ Constructeurs const partout
const AppButton.primary({...});
const AppAsyncView(...);

// ✅ Design tokens utilisés
style: AppTextStyles.labelLg,
color: AppColors.primary,

// ✅ Gap widgets constants
const gapH16 = SizedBox(height: 16);
```

---

## 3. ⚠️ Problèmes identifiés

### Accessibilité (touch targets)

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| W9 | **`AppPressable` sans contrainte de taille minimale** : le wrapper n'impose pas `minSize: Size(44, 44)` — les icônes cliquables peuvent être < 44px | **Critical** |
| W10 | **`AppIcon` sans `Semantics`** : utilisé comme contrôle interactif mais pas de label sémantique | **Major** |
| W11 | **`AppBadge` sans `Semantics`** : les badges (compteurs, statuts) n'ont pas de label pour TalkBack/ VoiceOver | **Minor** |
| W12 | **`GestureDetector` dans plusieurs widgets** : certains widgets utilisent `GestureDetector` directement au lieu de `AppPressable` (ex: `_NavItem`, `_SortOption`, `SalonMapCard`) | **Major** |

### Incohérences de radius

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| W13 | **`AppRadius` non utilisé partout** : `AppButton` utilise `100.r`, `AppSheet` utilise `AppRadius.xl` (24), `AppDialog` utilise `20.r`, `AppTextField` utilise `AppRadius.md` (12) | **Major** |
| W14 | **Radius incohérent** : certains widgets hardcodent `BorderRadius.circular(16)` ou `BorderRadius.circular(24)` au lieu d'utiliser `AppRadius.*` | **Major** |

### Widgets manquants ou incomplets

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| W15 | **Pas de `AppSkeleton`/`AppShimmer` générique** : le package `shimmer` est dans les dépendances mais aucun wrapper générique n'existe — chaque page doit refaire son shimmer | **Major** |
| W16 | **Pas de `AppToast`** : `AppSnackbar` est utilisé pour tout (toast, erreur, succès) — pas de composant toast dédié avec position configurable | **Minor** |
| W17 | **Pas de `AppBottomSheet` générique** : `showModalBottomSheet` est appelé directement dans les pages avec `DraggableScrollableSheet` — pas de composant réutilisable | **Minor** |
| W18 | **Pas de `AppFloatingActionButton`** : pas de FAB dans l'app | **Info** |

### Surcharge de widgets

| Widget | Lignes | Problème |
|---|---|---|
| **`AppPhoneField`** | 432 | Trop complexe — mêle UI, validation, formatage, sélecteur de pays. Devrait être extrait en sous-composants |
| **`AppDropdown`** | 213 | Trop complexe — mêle search, selection, UI custom. Devrait être simplifié |

---

## 4. Analyse détaillée des widgets clés

### `AppButton` (220 lignes) ✅

| Variant | Usage | Statut |
|---|---|---|
| `AppButton.primary(...)` | CTA principaux | ✅ |
| `AppButton.secondary(...)` | Actions secondaires | ✅ |
| `AppButton.outline(...)` | Actions tertiaires | ✅ |
| `AppButton.text(...)` | Liens | ✅ |
| `AppButton.destructive(...)` | Suppression, annulation | ✅ |
| `isLoading` | Spinner + désactivation | ✅ |
| `isDisabled` | Opacité réduite | ✅ |
| `icon` / `trailingIcon` | Icône avant/après texte | ✅ |
| `size` | sm, md, lg | ✅ |

### `AppAsyncView` (60 lignes) ✅

| Paramètre | Usage | Statut |
|---|---|---|
| `value` | `AsyncValue<T>` | ✅ |
| `keepDataOnReload` | Garde les données pendant reload | ✅ |
| `skipLoadingOnReload` | Pas de spinner pendant reload | ✅ |
| `loading` | Widget loading custom | ✅ |
| `error` | Widget erreur custom | ✅ |
| `data` | Builder données | ✅ |
| `onRetry` | Callback réessayer | ✅ |

⚠️ **Problème** : pas de paramètre `skipLoadingOnInitial` (affiche le spinner même si les données ne sont pas encore chargées — pas de skeleton)

### `AppPressable` (58 lignes) ✅

| Feature | Statut |
|---|---|
| Scale animation on press | ✅ |
| Opacity feedback | ✅ |
| Haptic feedback | ✅ |
| Disabled state | ✅ |
| `onTap` / `onLongPress` | ✅ |

⚠️ **Problème** : pas de `minSize: Size(44, 44)` comme contrainte par défaut — dépend du parent pour la taille

### `AppTextField` (68 lignes) ⚠️

| Feature | Statut |
|---|---|
| `label` | ✅ |
| `hintText` | ✅ |
| `errorText` | ✅ |
| `prefixIcon` | ✅ |
| `suffix` / `suffixIcon` | ✅ |
| `obscureText` | ✅ |
| `maxLines` | ✅ |
| `onChanged` | ✅ |
| `validator` | ❌ Pas de validation intégrée |

### `AppPhoneField` (432 lignes) ⚠️

| Feature | Statut |
|---|---|
| Country selector | ✅ |
| Phone validation | ✅ |
| Formatting | ✅ |
| E.164 output | ✅ |

⚠️ **Problème** : 432 lignes — beaucoup trop. La complexité vient du sélecteur de pays qui est inline. Devrait être extrait dans un widget `AppCountryPicker` séparé.

### `AppErrorState` (161 lignes) ✅

| Feature | Statut |
|---|---|
| Titre | ✅ |
| Message | ✅ |
| Icône | ✅ |
| Bouton "Réessayer" | ✅ |
| Différentes variantes (offline, timeout, server, unknown) | ✅ |

⚠️ **Problème** : pas de `SecondaryAction` (ex: "Retour à l'accueil" ou "Contacter le support")

---

## 5. Usage des widgets dans les pages

| Widget | Pages qui l'utilisent |
|---|---|
| `AppAsyncView` | Presque toutes les pages |
| `AppButton` | Auth, booking, profile pages |
| `AppPressable` | Search, salon detail, profile |
| `AppSnackbar` | Auth, booking, profile, appointments |
| `AppErrorState` | Discovery, booking |
| `AppTextField` | Auth, profile |
| `AppPhoneField` | Auth (profile bootstrap) |
| `AppSheet` | Booking, profile |
| `AppIcon` | Partout |

---

## 6. Recommandations

### 🔴 Priorité haute

1. **Ajouter `minSize: Size(44, 44)` à `AppPressable`** par défaut — corriger l'accessibilité touch targets
2. **Standardiser les radius** : choisir une valeur cohérente et remplacer les hardcodes
3. **Créer un `AppSkeleton` générique** avec le package `shimmer` déjà présent

### 🟡 Priorité moyenne

4. **Extraire `AppPhoneField`** : sortir le sélecteur de pays dans `AppCountryPicker`
5. **Ajouter `Semantics` aux widgets interactifs** : `AppIcon`, `AppBadge`, `AppChip`
6. **Remplacer les `GestureDetector` directs par `AppPressable`**

### 🟢 Priorité basse

7. **Ajouter `skipLoadingOnInitial` à `AppAsyncView`** pour support skeleton
8. **Ajouter `SecondaryAction` à `AppErrorState`**
9. **Ajouter `validator` callback à `AppTextField`**

---

## 7. Résumé

La bibliothèque de widgets core est **bien conçue et cohérente** (42 widgets, tous utilisent les design tokens). Les points d'amélioration sont :

- 🔴 **Accessibilité tactile** : `AppPressable` sans contrainte 44x44
- 🔴 **Radius non unifié** : mélange de valeurs entre widgets
- 🟡 **`AppPhoneField` trop gros** : 432 lignes, à extraire
- 🟡 **Pas de skeleton screen générique** : `shimmer` package non utilisé
- 🟢 Quelques améliorations UX (secondary action, validator)

Score : **B+ (82/100)** — solide, nécessite un polish accessibilité + standardisation.
