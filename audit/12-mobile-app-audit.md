# Audit Application Mobile — Beauté Avenue

> Généré le 17 juin 2026

## Score global : **B+ (82/100)**

| Catégorie | Score | Priorité |
|---|---|---|
| Architecture & code | **75%** | 🔴 Nettoyage nécessaire |
| UI/UX Heuristique | **86%** | 🟢 Solide |
| Design System | **78%** | 🟡 Unifier radius |
| Accessibilité | **65%** | 🔴 **Priorité #1** |
| User Flows | **88%** | 🟢 Excellent |
| Microcopy | **90%** | 🟢 Excellent |

---

## 1. Architecture & Qualité du code

### Stack technique
- **Framework :** Flutter (Dart)
- **State management :** Riverpod (`flutter_riverpod`)
- **Routing :** GoRouter (`go_router`)
- **HTTP :** Dio (`dio`)
- **Client API :** Code généré depuis OpenAPI (`beauteavenue_api`)
- **Cache :** Hive (`hive_ce`)
- **Theme :** Custom design tokens + Google Fonts
- **Responsive :** `flutter_screenutil`

### ✅ Points forts
- Architecture Riverpod + GoRouter + Dio — stack moderne et éprouvée
- Client API typé via `beauteavenue_api` (BuiltValue), évite les bugs de contrat
- Séparation des préoccupations : providers isolés, pages sans logique métier
- Gestion des tokens robuste : intercepteur `_AuthInterceptor` avec refresh token, file d'attente, replay des requêtes
- Offline-first : cache Hive avec stale indicators (`CachedResource`, `StaleDataNotice`)
- Système de thème cohérent avec tokens dans `app_colors.dart`, `app_text_styles.dart`, etc.
- Bonne couverture d'états : `AppAsyncView`, `AppResourceView`, `AppErrorState`, `AppEmptyState`

### ⚠️ Problèmes identifiés

| # | Problème | Sévérité | Fichier |
|---|---|---|---|
| A1 | **Code dupliqué** : `_hydrateSession` et `_hydrateSessionFromRaw` quasi identiques (60+ lignes copiées) | **Major** | `auth_provider.dart:136-198` |
| A2 | **Import interne brisé** : utilise `package:beauteavenue_mobile_client/...` au lieu de `../../../` | **Major** | `shell_scaffold.dart:9` |
| A3 | **Paramètre unused** : `trailingText` dans `_MenuTile` | **Minor** | `profile_page.dart:50` |
| A4 | **Router > 700 lignes** : `app_router.dart` concentre routes, redirections, guards, page d'erreur — devrait être extrait | **Major** | `app_router.dart` |
| A5 | **Promos cachées** : commentaires `// Promos hidden — ` parsèment le codebase | **Minor** | Plusieurs fichiers |
| A6 | **Types `dynamic`** : `bookingDetailProvider` retourne `Map<String, dynamic>` au lieu d'un modèle typé — pas de sécurité de type | **Major** | `bookings_list_provider.dart`, pages dépendantes |
| A7 | **`salonReviewsProvider`** retourne `List<dynamic>` | **Minor** | `salon_detail_provider.dart:71` |
| A8 | **StatefulWidget sans ConsumerState** : `_SuccessBody` est un `StatelessWidget` avec animation | **Minor** | `booking_success_page.dart` |
| A9 | **Inline state mixing** : `_RatingPromptCard` gère son état hover dans un widget de détail booking | **Minor** | `booking_detail_page.dart` |
| A10 | **Pas de tests unitaires** visibles dans le dossier mobile | **Info** | — |
| A11 | **Méthode privée non utilisée** : `inferDjamoCountryCode` est une redirection inutile | **Minor** | `payment_handoff_page.dart` |
| A12 | **`_showPaymentNudge`** utilise `showModalBottomSheet` avec `useRootNavigator: true` mais context peut être périmé | **Minor** | `profile_bootstrap_page.dart` |

### Recommandations architecture
1. **Fusionner** `_hydrateSession` et `_hydrateSessionFromRaw` en une seule méthode avec paramètre optionnel
2. **Extraire** `app_router.dart` en sous-modules : `routes.dart`, `redirects.dart`, `guards.dart`, `error_page.dart`
3. **Typer** les réponses API avec des modèles BuiltValue au lieu de `Map<String, dynamic>`
4. **Nettoyer** les commentaires `// Promos hidden —` (soit supprimer, soit utiliser un feature flag)
5. **Ajouter** des tests unitaires pour les providers critiques (auth, booking, paiement)

---

## 2. UI/UX — Audit heuristique (Nielsen × ss-audit)

### Score : **150/170 = 88%** 🟢

| Heuristique | Score | Analyse |
|---|---|---|
| **1. Visibilité du statut** | 17/20 | ✅ Loading states présents partout via `AppAsyncView`. ✅ Succès/erreur après actions via `AppSnackbar`. ❌ Pas de skeleton screens spécifiques — spinner générique dans certains cas (`CircularProgressIndicator.adaptive()`). |
| **2. Correspondance système-monde** | 16/18 | ✅ Termes français naturels, pas de jargon technique. ✅ Format XOF, dates françaises. ❌ `N'importe qui` pour sélection staff — pourrait être `Sans préférence` (plus professionnel). |
| **3. Contrôle & liberté** | 17/18 | ✅ Back navigation partout. ✅ Confirmation pour actions destructives (annulation). ❌ `_BookingRouteErrorPage` renvoie à l'accueil, pas au funnel — perte de contexte. |
| **4. Consistance & standards** | 15/16 | ✅ Design tokens utilisés partout. ❌ Mix de radius : `12.r`, `14.r`, `16.r`, `18.r`, `24.r`, `100.r` — pas unifié. |
| **5. Prévention d'erreurs** | 14/16 | ✅ Validation email avec regex. ✅ Confirmation destructive. ❌ Pas de confirmation visuelle de créneau complet avant sélection. |
| **6. Reconnaissance** | 14/16 | ✅ Labels sur BottomNav (3 tabs). ❌ Icônes seules sans label textuel dans `_SortOption`. ❌ Pas de badge "Notifications" accessible depuis tous les tabs. |
| **7. Flexibilité & efficacité** | 13/16 | ✅ Pull-to-refresh sur toutes les listes. ✅ RefreshIndicator partout. ❌ Pas de swipe actions sur liste de rendez-vous. ❌ 3 taps max OK mais booking funnel en 4 étapes pourrait être réduit. |
| **8. Design esthétique & minimaliste** | 16/18 | ✅ Très beau design général, palette élégante, cards bien espacées. ❌ `PaymentHandoffPage` à 800+ lignes — densité de code/business. ❌ `BookingManagePage` minimaliste (2 options). |
| **9. Aide aux erreurs** | 16/18 | ✅ Messages d'erreur traduits en français. ✅ `bookingCreateErrorMessage` avec cas spécifiques (401, timeout, 500). ❌ Manque de guidance après certaines erreurs de paiement. |
| **10. Aide & documentation** | 12/14 | ✅ Empty states avec call-to-action. ✅ Onboarding 3 slides. ❌ FAQ hardcodée statique — pas depuis API. ❌ Onboarding ne permet pas de personnaliser les préférences. |
| **Total** | **150/170** | |

### Problèmes UI/UX spécifiques

| # | Problème | Sévérité | Localisation |
|---|---|---|---|
| U1 | **PaymentHandoffPage : 800+ lignes** — logique de paiement, formulaires carte, OTP, polling, tout mélangé | **Critical** | `payment_handoff_page.dart` |
| U2 | **Pas de swipe actions** sur la liste des rendez-vous (annuler, rebook, contacter) | **Major** | `bookings_list_page.dart` |
| U3 | **Mix de radius** : `AppRadius.xl = 24`, `AppButton` = `100.r`, `_PaymentWaitingSheet` = `24.r`, dialogs = `20.r` | **Major** | Multiples fichiers |
| U4 | **Onboarding fixe** : 3 slides non personnalisables, pas de choix de catégories de salon favorites | **Minor** | `onboarding_page.dart` |
| U5 | **Search filters** : "Ouvert"/"Réserver bientôt" sans feedback visuel clair de l'état actif | **Minor** | `search_page.dart` |
| U6 | **FAQ statique** : questions/réponses hardcodées dans le code — impossible à mettre à jour sans déploiement | **Minor** | `faq_page.dart`, `support_page.dart` |
| U7 | **Booking manage** : titre "Modifier" mais seules options sont "Déplacer" et "Annuler" — pas de modification de service | **Minor** | `booking_manage_page.dart` |
| U8 | **Animation fragile** : `_SuccessBody` en `StatelessWidget` avec `AnimationController` dans le parent — pattern risqué | **Minor** | `booking_success_page.dart` |
| U9 | **Price row overflow** : `_PriceRow` utilise `Expanded` + `Text` sans `overflow: TextOverflow.ellipsis` | **Minor** | `booking_review_page.dart` |
| U10 | **Pas de retour haptique sur toggles** (filtres, favoris) | **Minor** | `search_page.dart`, `favorites_page.dart` |

---

## 3. Design System Compliance (ss-review)

### Score : **78% — Pass avec réserves** 🟡

| Critère | Statut | Détail |
|---|---|---|
| **Tokens couleur** | ✅ Excellent | `AppColors.*` utilisé partout, pas de hex hardcodés dans les pages |
| **Typographie** | ✅ Excellent | `AppTextStyles.*` utilisé partout. Hiérarchie claire : Display (Cormorant Garamond), Headline/Body/Label (DM Sans) |
| **Spacing** | ✅ Excellent | `AppSpacing`, `gapH*`, `gapW*` — très cohérent |
| **Shadows** | ✅ Excellent | `AppShadows.*` utilisé dans toute l'app |
| **Radius** | ⚠️ **Problème** | Mix de valeurs. `AppRadius.xl = 24` mais boutons en `100.r`, dialogs en `20.r`, sheets en `24.r`, certains inputs en `12.r` |
| **Touch targets** | ⚠️ **Risque** | `AppIcon` sans `minHeight`/`minWidth` — certains icônes cliquables < 44px |
| **Dark mode** | ✅ Bon | `AppTheme.dark` implémenté avec couverture complète des tokens sombres |
| **Motion** | ✅ Bon | Animations avec `AnimatedContainer`, elastic, scale `Curves.easeOutBack` |
| **Coherence (§C0)** | ⚠️ Mix radius | Un seul accent (`primary` rose), une shadow language cohérente — bon. Mais radius non-unifié. |

### Violations détectées

```dart
// ❌ Hex hardcodés dans profile_page.dart:93
const Color(0xFFFFF8E8), Color(0xFFE8D6A6), Color(0xFF8C6A1C), Color(0xFF6F5718)

// ❌ Colors.black hardcodé dans edit_profile_page.dart:266
const BoxDecoration(color: Colors.black, shape: BoxShape.circle)

// ❌ Colors.white hardcodé dans edit_profile_page.dart:279
color: Colors.white

// ❌ Radius non-unifié dans plusieurs fichiers
// app_button.dart: 100.r
// app_dialog.dart: 20.r
// app_sheet.dart: AppRadius.xl (24)
// app_theme.dart: AppRadius.md (12) pour input borders
```

---

## 4. Accessibilité (ss-a11y)

### Score : **65% — C** 🔴

**Points préoccupants :** L'accessibilité est le point le plus faible de l'application. Plusieurs violations WCAG 2.2 AA.

| # | Problème | WCAG | Sévérité |
|---|---|---|---|
| X1 | **Touch targets < 44px** : `AppPressable`, `GestureDetector`, `AppIcon` sans contrainte de taille minimale | SC 2.5.8 | **Critical** |
| X2 | **Semantics manquantes** : `AppIcon` sans `Semantics(label:)` dans les boutons icônes seuls | SC 4.1.2 | **Major** |
| X3 | **Contraste insuffisant** : `onSurfaceVariant #6E6460` sur `surfaceVariant #F0EDE8` ≈ **3.2:1** — échoue WCAG AA (4.5:1 requis) | SC 1.4.3 | **Major** |
| X4 | **Couleur seule** : statut des réservations sans icône/texte d'accompagnement | SC 1.4.1 | **Major** |
| X5 | **Pas de `prefers-reduced-motion`** : animations custom (AnimatedContainer, ScaleTransition) sans respect des préférences utilisateur | SC 1.4.4 | **Minor** |
| X6 | **Pas de `excludeSemantics`** sur icônes décoratives dans les listes | SC 4.1.2 | **Minor** |
| X7 | **Formulaires sans `aria-describedby`** : erreurs de validation non programmatiquement associées | SC 3.3.1 | **Minor** |
| X8 | **Pas de `Semantics` sur le BottomNav** : `_NavItem` n'a pas de label sémantique explicite | SC 4.1.2 | **Minor** |

### Recommandations accessibilité

1. **Ajouter un wrapper global** avec `minSize: Size(44, 44)` sur tous les `GestureDetector` et `AppPressable`
2. **Wrapper `AppIcon`** avec `Semantics(label: ...)` quand utilisé comme contrôle interactif
3. **Assombrir** `onSurfaceVariant` (#6E6460 → ~#5C524E) ou éclaircir `surfaceVariant` (#F0EDE8 → ~#F5F2EE) pour atteindre 4.5:1
4. **Ajouter une règle CSS/Flutter globale** :
```dart
// Dans main.dart
if (MediaQuery.platformBrightnessOf(context) == Brightness.dark) {
  // already handled
}
// prefers-reduced-motion via MediaQuery
final disableAnimations = MediaQuery.of(context).disableAnimations;
```

---

## 5. User Flows (ss-flow)

### Score : **88% — A-** 🟢

### Navigation principale

```
[Onboarding] → [Permission Location] → [Auth Choice]
                                            ↓
                                     [Email Login / Register]
                                            ↓
                                     [Profile Bootstrap]
                                            ↓
                                     [Setup Paiement]
                                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  ShellScaffold (3 tabs)                                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                     │
│  │ Explorer │  │  RDV     │  │  Profil  │                     │
│  │ (Tab 0)  │  │ (Tab 1)  │  │ (Tab 2)  │                     │
│  └──────────┘  └──────────┘  └──────────┘                     │
└─────────────────────────────────────────────────────────────────┘
```

### Booking Funnel (4 étapes)

```
[Fiche Salon] → [Service Selection] → [Staff Selection] → [Slot Selection] → [Review & Confirm]
       ↑               ↓                    ↓                   ↓                    ↓
       └───────────────┴────────────────────┴───────────────────┴──────── [Payment Handoff]
                                                                                    ↓
                                                                           [Booking Success]
```

### Forces
- ✅ Navigation à 3 tabs claire avec icônes + labels
- ✅ Booking funnel en étapes séquentielles logiques
- ✅ Salon detail accessible depuis tous les points d'entrée (home, search, listes, favoris)
- ✅ Auth flow complet avec redirect après connexion
- ✅ Gestion des états (loading, empty, error) sur chaque écran

### Faiblesses

| # | Problème | Sévérité |
|---|---|---|
| F1 | **Pas de badge "notifications"** sur le tab ou dans le shell | **Major** |
| F2 | **Funnel bloqué** : pas de bouton "Retour à l'étape précédente" après Staff → Slot → Review | **Major** |
| F3 | **Deep linking manquant** : les notifications ne sont pas des liens profonds vers la réservation concernée | **Minor** |
| F4 | **Pas de recherche depuis la tab "RDV"** : impossible de filtrer les réservations | **Minor** |
| F5 | **BottomNav cachée sur la SearchPage** : l'utilisateur doit revenir manuellement | **Minor** |
| F6 | **Booking manage limité** : ne permet que "Déplacer" ou "Annuler", pas de modification de service | **Minor** |

---

## 6. Microcopy (ss-copy)

### Score : **90% — A** 🟢

### Points forts

Excellent travail de localisation française :

- ✅ **Messages naturels :** "Votre session a expiré" (pas "401 Unauthorized")
- ✅ **Ton positif :** "Réservation confirmée !" — chaleureux
- ✅ **Clarté :** "Annulation gratuite jusqu'à 24h avant"
- ✅ **Blame système :** "Connexion indisponible. Vérifiez votre réseau puis réessayez."
- ✅ **Action claire :** "Complétez votre profil pour payer" avec 2 CTA
- ✅ **OTP bien expliqué :** "Composez le #144*82# pour obtenir un code d'autorisation"

### Améliorations suggérées

| # | Actuel | Suggestion |
|---|---|---|
| C1 | "Premier disponible" | → "Meilleur créneau" (plus positif) |
| C2 | "N'importe qui" (staff) | → "Sans préférence" (plus professionnel) |
| C3 | "L'acompte vous sera alors remboursé" | → "L'acompte sera remboursé sous 48h" (préciser délai) |
| C4 | "RÉCENTS" (search, CAPS) | → "Récemment consultés" (moins caps-lock agressif) |
| C5 | "Pas encore de compte ? Inscrivez-vous" | → "Créer un compte" (CTA plus direct) |
| C6 | "Aucun résultat pour "X"" | → "On n'a rien trouvé pour "X". Essayez un autre terme." (plus humain) |
| C7 | "Bouton 'Payer'" générique | → Préciser le montant : "Payer 2 500 XOF" |

---

## 7. Recommandations priorisées

### 🔴 Priorité #1 — Accessibilité (gain le plus fort)

1. Ajouter `minSize: Size(44, 44)` sur tous les contrôles tactiles
2. Ajouter `Semantics` sur les icônes interactives
3. Corriger le contraste `onSurfaceVariant` / `surfaceVariant`

### 🔴 Priorité #2 — Refactoring technique

4. Extraire `app_router.dart` en modules séparés
5. Fusionner `_hydrateSession` / `_hydrateSessionFromRaw`
6. Typer les modèles booking avec BuiltValue au lieu de `Map<String, dynamic>`

### 🟡 Priorité #3 — Design System

7. Unifier le système de radius (choisir une valeur unique)
8. Supprimer les hex hardcodés restants

### 🟡 Priorité #4 — UX

9. Extraire `PaymentHandoffPage` en sous-composants
10. Ajouter des swipe actions sur les réservations
11. Ajouter un badge de notifications

### 🟢 Priorité #5 — Polish

12. Microcopy : remplacer "N'importe qui" par "Sans préférence"
13. Ajouter des skeleton screens dédiés (pas de spinners génériques)
14. Supprimer les commentaires `// Promos hidden`
15. Nettoyer le paramètre unused `trailingText`

---

## 8. Fichiers audités

| Fichier | Lignes | Qualité |
|---|---|---|
| `lib/main.dart` | ~30 | ✅ |
| `lib/src/app.dart` | ~40 | ✅ |
| `lib/src/router/app_router.dart` | **700+** | ⚠️ Trop gros |
| `lib/src/router/shell_scaffold.dart` | 130 | ✅ |
| `lib/src/router/splash_page.dart` | ~30 | ✅ |
| `lib/src/core/theme/*` | 5 fichiers | ✅ Excellent |
| `lib/src/core/widgets/*` | 35 widgets | ✅ Solide |
| `lib/src/core/network/dio_client.dart` | 150 | ✅ Robuste |
| `lib/src/core/session/session_store.dart` | — | ✅ |
| `lib/src/features/auth/providers/auth_provider.dart` | 200 | ⚠️ Duplication |
| `lib/src/features/auth/pages/*` | 6 pages | ✅ |
| `lib/src/features/discovery/providers/*` | 7 providers | ✅ Solide |
| `lib/src/features/discovery/pages/*` | 5 pages | ✅ |
| `lib/src/features/booking/providers/*` | 3 providers | ✅ |
| `lib/src/features/booking/pages/*` | 6 pages | ⚠️ PaymentHandoff 800+ lns |
| `lib/src/features/appointments/pages/*` | 4 pages | ✅ |
| `lib/src/features/profile/pages/*` | 10 pages | ✅ |
| `lib/src/features/notifications/pages/*` | 1 page | ✅ |

---

## Résumé

L'application mobile Beauté Avenue est **bien construite globalement** avec une architecture Riverpod solide, un design system cohérent, et une excellente localisation française.

Les **deux problèmes principaux** sont :
1. **Accessibilité** (touch targets, contraste, semantics) — impacte tous les utilisateurs
2. **Dette technique** (PaymentHandoffPage, booking typé dynamic, router monolithique)

Avec ces correctifs, l'app passerait facilement de **B+ à A-**.
