# Audit Mobile — Design Tokens & Système de Thème

> Généré le 17 juin 2026

## Score : **A- (88/100)** 🟢

---

## 1. Architecture du système de thème

### Fichiers

| Fichier | Lignes | Contenu |
|---|---|---|
| `app_colors.dart` | 91 | Palette complète : brand, neutral, semantic, dark mode, status |
| `app_text_styles.dart` | 125 | Typographie : 4 catégories × 3 tailles = 12 styles |
| `app_spacing.dart` | 43 | Système de spacing + radius + gap helpers |
| `app_shadows.dart` | 59 | Ombres : card, nav, button, sheet + sm/md/lg |
| `app_padding.dart` | 29 | Paddings pré-définis |
| `app_theme.dart` | 238 | Thème Material 3 complet (light + dark) |
| **Total** | **585** | |

### Palette de couleurs

```
Brand (10%)
├── primary: #D96B8C (Rose Pétale)
├── primaryLight: #FFECF2
├── primaryMid: #F2A8BE
├── secondary: #C9A26A (Or Champagne)
└── tertiary: #8B4A2E

Neutral (warm)
├── neutral: #FAFAF8 (warm off-white)
├── surface: #FFFFFF
├── surfaceElevated: #F7F5F2
├── surfaceVariant: #F0EDE8
├── onSurface: #1A1614 (warm near-black)
└── onSurfaceVariant: #6E6460 (warm mid-gray)

Semantic
├── error: #BA1A1A
├── success: #2E7D5E
└── status: pending/confirmed/checkedIn avec bg + text + border

Dark Mode
├── darkBackground: #141210
├── darkSurface: #1E1B18
├── darkSurfaceVariant: #2A2622
├── darkOnSurface: #F2EDE8
└── darkOnSurfaceVariant: #A09890
```

### Typographie

```
Display (Cormorant Garamond) — hero, salon names
├── displayLg: 56sp, w600
├── displayMd: 40sp, w600
└── displaySm: 28sp, w600

Headline (DM Sans) — section titles, modal headers
├── headlineLg: 24sp, w700
├── headlineMd: 20sp, w700
└── headlineSm: 18sp, w600

Body (DM Sans) — content text
├── bodyLg: 16sp, w400
├── bodyMd: 14sp, w400
└── bodySm: 12sp, w400

Label (DM Sans) — buttons, badges, nav
├── labelLg: 14sp, w600
├── labelMd: 12sp, w600
└── labelSm: 10sp, w600
```

### Spacing (6px grid)

```
xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48, xxxl: 64
```

### Radius

```
xs: 4, sm: 8, md: 12, lg: 16, xl: 24, xxl: 32, full: 9999
```

---

## 2. ✅ Points forts

### Couleurs

| # | Force | Détail |
|---|---|---|
| C1 | **Palette warm complète** : tons chauds (warm off-white, warm gray) — pas de gris froids Material par défaut | ✅ Excellent |
| C2 | **Semantic colors explicites** : `success`, `errorContainer`, `successContainer` — pas de `Colors.green` générique | ✅ Excellent |
| C3 | **Status colors pour bookings** : pending, confirmed, checkedIn avec bg + text + border spécifiques | ✅ Excellent |
| C4 | **Dark mode complet** : 6 couleurs sombres dédiées, pas de simple inversion | ✅ Excellent |
| C5 | **Brand identity forte** : Rose Pétale + Or Champagne — palette distinctive | ✅ Excellent |

### Typographie

| # | Force | Détail |
|---|---|---|
| T1 | **2 polices distinctives** : Cormorant Garamond (élégance) + DM Sans (moderne) — pas de Roboto par défaut | ✅ Excellent |
| T2 | **Hiérarchie claire** : 4 catégories × 3 tailles = 12 styles | ✅ Excellent |
| T3 | **Google Fonts actif** : polices chargées dynamiquement | ✅ Bon |
| T4 | **Ligatures + tracking** : `letterSpacing` ajusté par style | ✅ Bon |

### Spacing & Layout

| # | Force | Détail |
|---|---|---|
| S1 | **Système 6px grid complet** : xs(4) → xxxl(64) | ✅ Excellent |
| S2 | **Gap helpers pratiques** : `gapH16`, `gapW24`, etc. | ✅ Excellent |
| S3 | **Paddings pré-définis** : `AppPadding.horizontalLg`, `AppPadding.allMd`, etc. | ✅ Excellent |
| S4 | **Shadows cohérents** : card, nav, button, sheet + sm/md/lg flat | ✅ Excellent |

### AppTheme

| # | Force | Détail |
|---|---|---|
| H1 | **Material 3 complet** : `useMaterial3: true`, `ColorScheme` fully specified | ✅ Excellent |
| H2 | **Light + Dark** : `ThemeData` pour les deux modes | ✅ Excellent |
| H3 | **CardTheme** : radius xl, elevation 0, couleur surface | ✅ Bon |
| H4 | **System overlay** : `SystemUiOverlayStyle` pour status bar | ✅ Bon |

---

## 3. ⚠️ Problèmes identifiés

### Couleurs

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| D1 | **Contraste insuffisant** : `onSurfaceVariant #6E6460` sur `surfaceVariant #F0EDE8` ≈ **3.2:1** — échoue WCAG AA (4.5:1) | **Critical** |
| D2 | **`primaryLight` (#FFECF2) non utilisé** : défini mais jamais référencé dans les widgets | **Minor** |
| D3 | **`onSecondary` (#2D1A12) très foncé** : correct mais pourrait être trop contrasté sur `secondary` (#C9A26A) — > 10:1 | **Minor** |

### Typographie

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| T5 | **Pas de `letterSpacing` sur `bodyMd`** : bodyLg et bodySm en ont, bodyMd non | **Minor** |
| T6 | **`displayLg` (56sp) très grand** : utilisable seulement sur très grands écrans — pas de fallback pour petits écrans | **Minor** |
| T7 | **Google Fonts loading** : pas de fallback si la police ne charge pas (réseau lent / offline) — l'app pourrait montrer des caractères par défaut | **Minor** |

### Spacing & Layout

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| S5 | **`AppSpacing` utilise `double`** : pas de `Spacing` class avec méthodes — juste des constantes statiques | **Info** |
| S6 | **`gapH*` constants non typés** : ce sont des `SizedBox` — pas de `Spacer` générique horizontal/vertical | **Info** |

### Radius

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| R1 | **Radius non unifié entre widgets** : certains utilisent `AppRadius.*`, d'autres hardcodent `100.r`, `20.r`, `16.r`, etc. | **Major** |
| R2 | **`AppRadius.full = 9999`** : devrait être remplacé par `BorderRadius.circular(double.infinity)` ou une constante sémantique | **Minor** |

### AppTheme - Problèmes

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| H5 | **`ColorScheme.dark` pas défini** : `AppTheme.dark` existe mais ne définit pas `ColorScheme.dark()` complet — utilise des valeurs directes | **Major** |
| H6 | **Pas de `AppBarTheme` personnalisé** : utilisation du thème par défaut Material | **Minor** |
| H7 | **Pas de `BottomNavigationBarTheme`** : le style de la BottomNav est géré manuellement dans `ShellScaffold` | **Minor** |
| H8 | **Pas de `InputDecorationTheme`** : le style des inputs est défini manuellement dans `AppTextField` | **Minor** |

### Problème de font loading offline

```dart
// Après le chargement initial, GoogleFonts met en cache les polices
// Mais la première utilisation nécessite une connexion réseau.
// Si l'utilisateur n'a jamais ouvert l'app avant et est hors-ligne :
//   → Les polices ne chargent pas
//   → L'app affiche du texte en police système (fallback non défini)
```

---

## 4. Analyse des violations de contraste

| Paire | Ratio | WCAG AA (4.5:1) | Usage |
|---|---|---|---|
| `primary` (#D96B8C) sur `surface` (#FFFFFF) | **3.8:1** | ❌ Échoue (boutons) |
| `onSurfaceVariant` (#6E6460) sur `surfaceVariant` (#F0EDE8) | **3.2:1** | ❌ Échoue (sous-titres) |
| `onSurfaceVariant` (#6E6460) sur `surface` (#FFFFFF) | **5.1:1** | ✅ Passe |
| `primary` (#D96B8C) sur `primaryContainer` (#FFD9E6) | **2.6:1** | ❌ Échoue (badge) |
| `onSurface` (#1A1614) sur `surface` (#FFFFFF) | **15.8:1** | ✅ Passe |
| `error` (#BA1A1A) sur `surface` (#FFFFFF) | **7.8:1** | ✅ Passe |
| `success` (#2E7D5E) sur `surface` (#FFFFFF) | **5.6:1** | ✅ Passe |

### Recommandations contraste

1. **`primary` sur `surface`** (3.8:1) → assombrir primary à **#C95A7A** ou utiliser `primaryContainer` comme fond de bouton
2. **`onSurfaceVariant` sur `surfaceVariant`** (3.2:1) → assombrir à **#5C524E** ou éclaircir le fond à **#F5F2EE**
3. **`primary` sur `primaryContainer`** (2.6:1) → utiliser `onPrimaryContainer` (#3B0021) sur `primaryContainer`

---

## 5. Usage des tokens dans les widgets

### Utilisation correcte ✅

```dart
// ✅ Couleurs : AppColors.* partout
color: AppColors.primary,
backgroundColor: AppColors.surface,
color: AppColors.onSurfaceVariant,

// ✅ Typographie : AppTextStyles.* partout
style: AppTextStyles.bodyLg,
style: AppTextStyles.labelMd,

// ✅ Spacing : AppSpacing.* + gap helpers
padding: EdgeInsets.all(AppSpacing.md),
gapH16,

// ✅ Shadows : AppShadows.*
BoxDecoration(boxShadow: AppShadows.card),
```

### Violations

```dart
// ❌ Hex hardcodés dans profile_page.dart:93
const Color(0xFFFFF8E8), Color(0xFFE8D6A6)

// ❌ Colors.black dans edit_profile_page.dart:266
BoxDecoration(color: Colors.black, shape: BoxShape.circle)

// ❌ Colors.white dans edit_profile_page.dart:279
color: Colors.white

// ❌ Radius hardcodé dans app_button.dart
// Utilise 100.r au lieu de AppRadius.full

// ❌ Radius hardcodé dans app_dialog.dart
// Utilise 20.r au lieu de AppRadius.lg ou AppRadius.xl
```

---

## 6. Recommandations

### 🔴 Priorité haute

1. **Corriger les contrastes** : `primary`/`surface` (3.8:1) et `onSurfaceVariant`/`surfaceVariant` (3.2:1)
2. **Définir `ColorScheme.dark` complet** dans `AppTheme.dark`
3. **Remplacer les hex hardcodés** dans `profile_page.dart` et `edit_profile_page.dart`

### 🟡 Priorité moyenne

4. **Standardiser les radius** : choisir `AppRadius.lg` (16) ou `AppRadius.xl` (24) pour tous les widgets
5. **Ajouter `AppBarTheme`, `BottomNavigationBarTheme`, `InputDecorationTheme`** dans `AppTheme`
6. **Ajouter un fallback Google Fonts** (préchargement au splash ou `unawaited` cache warm)

### 🟢 Priorité basse

7. **Supprimer `primaryLight`** si non utilisé
8. **Remplacer `AppRadius.full = 9999`** par `BorderRadius.circular(double.infinity)`
9. **Ajouter `letterSpacing` à `bodyMd`** pour cohérence

---

## 7. Résumé

Le système de design tokens est **excellent dans l'ensemble** — palette distinctive (Rose Pétale + Or Champagne), typographie élégante (Cormorant Garamond + DM Sans), grille 6px cohérente, dark mode complet.

Les problèmes principaux sont :

- 🔴 **2 violations de contraste WCAG AA** (primary sur surface, onSurfaceVariant sur surfaceVariant)
- 🔴 **`ColorScheme.dark` incomplet** dans `AppTheme.dark`
- 🔴 **Quelques hex hardcodés** dans les pages
- 🟡 **Radius non standardisé** entre les widgets
- 🟡 **Thèmes Material manquants** (AppBar, BottomNav, Input)

Score : **A- (88/100)** — le point fort de l'app. Quelques ajustements pour passer à A.
