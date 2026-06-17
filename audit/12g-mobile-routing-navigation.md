# Audit Mobile — Routage & Navigation

> Généré le 17 juin 2026

## Score : **B (78/100)** 🟡

---

## 1. Architecture du routage

### Stack

| Technologie | Usage | Version |
|---|---|---|
| `go_router` | Routing déclaratif | ^17.2.3 |
| `ShellRoute` | Scaffold à 3 tabs (BottomNav) | Intégré |
| Provider GoRouter | State-driven routing | `riverpod` |
| Guards | Redirections conditionnelles | Implémenté |

### Structure du routeur

```
app_router.dart (549 lignes)
├── RouterProvider (Provider<GoRouter>)
├── Config
│   ├── initialLocation          → /splash
│   ├── debugLogDiagnostics      → true
│   └── redirect                 → guard function
├── Routes racine
│   ├── /splash                  → SplashPage
│   ├── /onboarding              → OnboardingPage
│   ├── /auth                    → AuthChoicePage
│   │   └── /auth/email-login    → EmailLoginPage
│   │   └── /auth/register       → RegisterPage
│   ├── /profile/bootstrap       → ProfileBootstrapPage
│   ├── ShellRoute (3 tabs)
│   │   ├── / (home)
│   │   │   └── /search
│   │   │   └── /favorites
│   │   ├── /bookings
│   │   │   └── /bookings/:id
│   │   │       └── /bookings/:id/manage
│   │   └── /profile
│   │       ├── /profile/edit
│   │       ├── /profile/notification-preferences
│   │       ├── /profile/payment-methods
│   │       ├── // profile/vouchers (commenté)
│   │       ├── /profile/memberships
│   │       ├── /profile/support
│   │       ├── /profile/legal
│   │       ├── /profile/about
│   │       └── /profile/faq
│   ├── /salons/:salonId
│   │   └── Sous-routes booking funnel
│   │       ├── /salons/:salonId/services
│   │       ├── /salons/:salonId/staff
│   │       ├── /salons/:salonId/slots
│   │       └── /salons/:salonId/review
│   ├── /booking/payment-handoff/:bookingId
│   ├── /booking/success/:bookingId
│   ├── /reviews/new/:bookingId
│   ├── /notifications
│   ├── /notification-preferences  (hors-shell)
│   ├── /permissions/location
│   └── /payments/callback
└── Pages d'erreur
    ├── _BookingRouteErrorPage    → "/bookings/:id" erreur
    └── Page 404                  → NotFoundPage
```

### Routes définies (`AppRoutes`)

```
static const splash = '/splash';
static const onboarding = '/onboarding';
static const auth = '/auth';
static const emailLogin = '/auth/email-login';
static const register = '/auth/register';
static const profileBootstrap = '/profile/bootstrap';
static const home = '/';
static const search = '/search';
static const favorites = '/favorites';
static const bookingsList = '/bookings';
static const bookingDetail = '/bookings/:bookingId';
static const bookingManage = '/bookings/:bookingId/manage';
static const profile = '/profile';
static const editProfile = '/profile/edit';
static const notificationPreferences = '/profile/notification-preferences';
static const paymentMethods = '/profile/payment-methods';
static const memberships = '/profile/memberships';
static const support = '/profile/support';
static const legal = '/profile/legal';
static const about = '/profile/about';
static const faq = '/profile/faq';
static const salonDetail = '/salons/:salonId';
static const bookingServices = '/salons/:salonId/services';
static const bookingStaff = '/salons/:salonId/staff';
static const bookingSlots = '/salons/:salonId/slots';
static const bookingReview = '/salons/:salonId/review';
static const bookingPayment = '/booking/payment-handoff/:bookingId';
static const bookingSuccess = '/booking/success/:bookingId';
static const notifications = '/notifications';
static const locationPermission = '/permissions/location';
static const paymentCallback = '/payments/callback';
static const reviewNew = '/reviews/new/:bookingId';
```

---

## 2. ✅ Points forts

### Architecture

- ✅ **ShellRoute bien conçu** : 3 tabs (Explorer, RDV, Profil) avec BottomNav cohérente
- ✅ **Guards centralisés** : 1 fonction `redirect` unique dans le GoRouter, pas de guards dispersés
- ✅ **Routes typées** : `AppRoutes` constants — évite les strings magiques
- ✅ **404 personnalisée** : `NotFoundPage` avec navigation de retour
- ✅ **Paramètres d'URL** : `:bookingId`, `:salonId` — RESTful, support deep linking
- ✅ **RouterProvider Riverpod** : `ref.watch(sessionProvider)` pour les redirects réactifs

### Navigation

- ✅ **Splash → Onboarding → Auth → Bootstrap → App** : flow d'entrée clair
- ✅ **Auth guard** : redirection vers `/auth` si session expirée
- ✅ **Pro guard** : déconnexion si rôle `pro` détecté
- ✅ **Funnel booking en sous-routes** : `salons/:salonId/services → staff → slots → review`
- ✅ **Pages de callback** : `PaymentCallbackPage` pour les webhooks de paiement

### ShellScaffold

- ✅ **BottomNav cachée sur SearchPage** : meilleure UX pour la recherche plein écran
- ✅ **AuthRequiredSheet** : demande de connexion avant accès aux tabs protégés
- ✅ **Tab index calculé** : `_currentIndex` basé sur `matchedLocation`

---

## 3. ⚠️ Problèmes identifiés

### Architecture

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| R1 | **Routeur monolithique (549 lignes)** : toute la config GoRouter + routes + guards dans un seul fichier | **Major** |
| R2 | **Route commentée** : `vouchers` route commentée — feature désactivée sans feature flag | **Minor** |
| R3 | **Routes booking hors-shell** : `payment-handoff/:bookingId` et `success/:bookingId` sont hors du ShellRoute — pas de BottomNav pendant ces écrans | **Major** |
| R4 | **Pas de nom de route (GoRouter `name:`)** : les `GoRoute` n'ont pas de paramètre `name` — pas de `context.goNamed()` possible | **Major** |
| R5 | **Redirection complexe** : la fonction `redirect` mêle auth guard + onboarding guard + bootstrap guard — difficile à maintenir | **Minor** |
| R6 | **`debugLogDiagnostics: true` en release** : pas de condition `kDebugMode` autour | **Minor** |

### Redirect guard

```dart
// Extrait — logique actuelle du guard
redirect: (context, state) {
  final session = ref.read(sessionProvider);
  final location = state.uri.toString();
  final isLoggedIn = session.isAuthenticated;
  // ...
  // Mélange : auth guard + rôle guard + onboarding guard + bootstrap guard
  // Tout est dans une seule fonction
}
```

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| R7 | **`ref.read()` synchrone dans le redirect** : utilise `ref.read()` au lieu de `ref.watch()` — pas de réactivité | **Major** |
| R8 | **Pas de vérification token au redirect** : le guard vérifie `session.isAuthenticated` mais ne valide pas l'expiration du token | **Major** |
| R9 | **Routes publiques non isolées** : la liste des routes exemptées du guard n'a pas de regex/pattern — les nouvelles routes doivent être ajoutées manuellement | **Minor** |

### Funnel booking

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| R10 | **Pas de retour arrière dans le funnel** : une fois sur `/staff`, impossible de revenir à `/services` — les étapes sont linéaires | **Major** |
| R11 | **États non persistés** : si l'app est killée pendant le funnel, l'état (`BookingFunnelState`) est perdu | **Minor** |
| R12 | **Pas de vérification d'appartenance** : n'importe quel salonId peut être mis dans l'URL | **Info** |

### Deep linking

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| R13 | **Pas de deep linking configuré** : les notifications push ne sont pas des liens profonds → pas de navigation directe vers la réservation | **Major** |
| R14 | **`ForegroundNotificationService._handlePayload`** : parse les données FCM mais n'utilise que `go()` sans logique de pile de navigation | **Major** |
| R15 | **Pas de Universal Links / App Links** : iOS et Android configurés avec des schémas personnalisés mais pas de vérification | **Minor** |

### ShellScaffold

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| R16 | **Import absolu brisé** : `package:beauteavenue_mobile_client/...` au lieu du relatif (déjà noté A2 dans audit principal) | **Major** |
| R17 | **BottomNav sans badge de notifications** : pas d'indicateur de notifications non lues (déjà noté F1) | **Major** |
| R18 | **BottomNav réapparaît sur les sous-routes booking** : le ShellRoute englobe les routes booking — incohérent | **Minor** |

---

## 4. Analyse des guards

### Guard actuel — Logique

```
redirect(state) :
  1. location == /splash → null (allow)
  2. location in [prohibitedForLoggedIn] && isLoggedIn → / (redirect to home)
  3. !isLoggedIn && location not in [publicRoutes] → /auth
  4. isOnboardingCompleted == false → /onboarding
  5. profileBootstrapRequired == true → /profile/bootstrap
  6. role == pro → logout action
  7. null (allow)
```

### Problèmes du guard

| # | Problème | Impact |
|---|---|---|
| G1 | **Ordre fragile** : les conditions s'enchaînent et une modification peut casser un use case | Tous les guards |
| G2 | **Pas de test unitaire du guard** : aucune validation automatisée des cas de redirection | ⚠️ Risque humain |
| G3 | **`ref.read()` synchrone** : si `sessionProvider` n'est pas encore construit, crash potentiel | Crash au démarrage |
| G4 | **Route `/` (home) gérée comme logged-in seulement** : mais l'utilisateur doit voir la home sans auth | UX cassée |

---

## 5. Map des transitions

```
→ = GoRouter.push() ou .go()
⇢ = Navigation programmatique

[SplashPage]
    ↓ (restore session)
    ├─ Token valide → [App] (/ ou /bookings ou /profile selon dernier état)
    └─ Pas de token → [Onboarding] (/onboarding)
                            ↓ (swipe 3 slides)
                        [Auth Choice] (/auth)
                            ↓
                        ├─ [EmailLogin] (/auth/email-login)
                        │       ↓ (OTP request → OTP verify)
                        ├─ [Register] (/auth/register)
                        │       ↓ (form → OTP verify)
                        └─ ... → [ProfileBootstrap] (/profile/bootstrap)
                                      ↓ (setup phone + payment)
                                  [App Shell] (3 tabs)
                                  
[App Shell]
├─ Tab 0 (/) → [HomePage] → [SearchPage] (/search)
│                            [FavoritesPage] (/favorites)
│                            [SalonDetailPage] (/salons/:id)
│                              → Funnel → [PaymentHandoff] (/booking/payment-handoff/:id)
│                                          [BookingSuccess] (/booking/success/:id)
│                                          [ReviewNew] (/reviews/new/:id)
├─ Tab 1 (/bookings) → [BookingsListPage]
│                        → [BookingDetailPage] (/bookings/:id)
│                           → [BookingManagePage] (/bookings/:id/manage)
└─ Tab 2 (/profile) → [ProfilePage]
                        → [EditProfile] (/profile/edit)
                          [PaymentMethods] (/profile/payment-methods)
                          [Memberships] (/profile/memberships)
                          [Vouchers] (commenté)
                          [Support] (/profile/support)
                          [Faq] (/profile/faq)
                          [Legal] (/profile/legal)
                          [About] (/profile/about)
                          [Notifications] (/notifications)
                          [NotificationPreferences] (/profile/notification-preferences)
```

---

## 6. Recommandations

### 🔴 Priorité haute

1. **Extraire le routeur en sous-modules** :
   - `routes/booking_routes.dart` — Funnel booking + payment
   - `routes/profile_routes.dart` — Routes profil
   - `routes/guards.dart` — Logique de redirection
   - `routes/app_routes_config.dart` — Configuration GoRouter
2. **Ajouter `name:` sur chaque `GoRoute`** : pour utiliser `context.goNamed()` au lieu de construire des paths
3. **Remplacer `ref.read()` par un état réactif dans le guard** : utiliser `ref.watch()` ou passer par un provider

### 🟡 Priorité moyenne

4. **Implémenter le deep linking** : configurer Universal Links (iOS) + App Links (Android)
5. **Ajouter un badge de notifications** sur la BottomNav
6. **Ajouter une navigation arrière dans le funnel booking** : bouton "Retour" à chaque étape
7. **Corriger l'import absolu dans `shell_scaffold.dart`** : remplacer par un import relatif

### 🟢 Priorité basse

8. **Ajouter des tests pour le guard** : couvrir tous les cas de redirection
9. **Conditionner `debugLogDiagnostics`** : `kDebugMode ? true : false`
10. **Décommenter ou supprimer la route `vouchers`** : pas de feature flag
11. **Persister l'état du funnel booking** dans le cache Hive

---

## 7. Résumé

Le routage est **bien conçu dans l'ensemble** (ShellRoute, guards centralisés, paramètres RESTful) mais présente des **problèmes de maintenabilité** :

- 🔴 **Routeur monolithique** de 549 lignes (extraire en modules)
- 🔴 **Pas de `name:` sur les routes** (pas de `goNamed()`)
- 🔴 **Pas de deep linking** pour les notifications push
- 🔴 **Guard non testé** (critique pour la sécurité)
- 🟡 **BottomNav sans badge notifications**
- 🟡 **Funnel booking sans retour arrière**

Passer de **B → A-** en refactorant le routeur + ajoutant deep linking + tests.
