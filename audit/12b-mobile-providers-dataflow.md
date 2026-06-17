# Audit Mobile — Providers & Data Flow

> Généré le 17 juin 2026

## 1. Architecture des providers

### Topologie

```
┌─────────────────────────────────────────────────────────────────────┐
│  SESSION LAYER                                                      │
│  sessionProvider (Notifier<SessionState>)                           │
│    ├─ dioProvider (Dio) ──── intercepteurs : Auth + Reachability   │
│    ├─ secureStorageProvider (SecureStorage)                         │
│    └─ fcmRegistrationServiceProvider (FcmRegistrationService)       │
├─────────────────────────────────────────────────────────────────────┤
│  API LAYER                                                          │
│  apiClientProvider (BeauteavenueApi)                                │
│    └─ wrapped generated client avec interceptors = []               │
├─────────────────────────────────────────────────────────────────────┤
│  CACHE LAYER                                                        │
│  AppCache (Hive) ── 6 boxes : salons, bookings, notifications,     │
│                    profile, settings, outbox                        │
│  AppModelCache (BuiltValue serialization)                           │
│  fetchCachedItemList (generic cached fetch utility)                 │
├─────────────────────────────────────────────────────────────────────┤
│  DOMAIN PROVIDERS                                                   │
│  Discovery : salonList, nearby, topRated, trending, prestige,       │
│              searchResults, searchSuggestions, salonDetail,         │
│              salonAvailability, salonReviews, favorites, categories │
│  Booking : bookingFunnel (stateful), bookingCreate, paymentInitiate │
│  Appointments : bookingsList, bookingDetail, bookingActions        │
│  Auth : currentUser, authActions                                    │
│  Profile : profile, profileOptions, vouchers, benefits, payments   │
│  Notifications : notifications (list + unread count)                │
│  Search : recentSearches, searchSuggestions, searchResults,         │
│           searchEventTracker                                        │
│  General : connectivity, networkReachability, location, locationStatus│
├─────────────────────────────────────────────────────────────────────┤
│  SYNC LAYER                                                         │
│  outboxProvider ── file d'attente offline avec flush automatique    │
│  appReactivityProvider ── refreshAll() centralisé                  │
└─────────────────────────────────────────────────────────────────────┘
```

### ✅ Forces identifiées

| # | Force | Détail |
|---|---|---|
| P1 | **Singleton Dio** centralisé avec intercepteurs | `dioProvider` créé une fois, partagé par tous les providers |
| P2 | **Offline-first robuste** | `fetchCachedItemList`, `AppModelCache`, `retryWithBackoff`, outbox — chaque provider a fallback cache |
| P3 | **Optimistic updates** | `FavoritesNotifier` : mise à jour UI immédiate avec rollback sur erreur |
| P4 | **Single-flight refresh** | Auth interceptor + outbox : pas de requêtes concurrentes en refresh |
| P5 | **Cohérence de navigation** | `appReactivityProvider.refreshAll()` rafraîchit tous les providers au changement de route |
| P6 | **Séparation claire** | Providers isolés, pas de logique métier dans les widgets |

### ⚠️ Problèmes de pattern

| # | Problème | Localisation | Sévérité |
|---|---|---|---|
| D1 | **`_hydrateSession` dupliqué x2** : 60+ lignes identiques entre `_hydrateSession` et `_hydrateSessionFromRaw` | `auth_provider.dart:136-198` | **Major** |
| D2 | **Booking detail = `Map<String, dynamic>`** : aucun typage, parsing manuel via extension `BookingMapExtension` | `bookings_list_provider.dart`, `cached_resource.dart` | **Major** |
| D3 | **`salonReviewsProvider` retourne `List<dynamic>`** : pas de typage | `salon_detail_provider.dart:71` | **Minor** |
| D4 | **`_primeSetupCache()` fait 2 appels API séquentiels** : pourrait être parallélisé avec `Future.wait` | `auth_provider.dart:206-218` | **Minor** |
| D5 | **`outbox._dispatch()` = 7 cas switch** : pourrait être factorisé avec une map de handlers | `app_outbox.dart:131-175` | **Minor** |
| D6 | **`pendingReviewProvider` lit `bookingsListProvider` puis filtre** : coût inutile si pas de booking complété | `pending_review_provider.dart` | **Minor** |

---

## 2. Offline & Sync

### Architecture Offline

```
[Action utilisateur] → [Online?]
                          ├─ Oui → API call directe
                          └─ Non  → outbox.enqueue()
                                    
[outboxProvider.flush()] → [Online?]
                            ├─ Oui → Dispatch tous les items
                            └─ Non  → Retry plus tard
```

### Types d'opérations offline supportées

| Type | Endpoint | Priorité |
|---|---|---|
| `profile_patch` | PATCH /api/v1/me | Haute |
| `profile_avatar_upload` | upload → PATCH /api/v1/me | Haute |
| `payment_method_create` | POST /me/payment-methods (idempotent) | Haute |
| `payment_method_update` | PATCH /me/payment-methods/:id | Haute |
| `payment_method_delete` | DELETE /me/payment-methods/:id | Haute |
| `payment_method_default` | POST /me/payment-methods/:id/default | Haute |
| `notification_read` | POST /notifications/:id/read | Basse |
| `notifications_read_all` | POST /notifications/read-all | Basse |

### ✅ Forces
- Outbox persistant dans Hive (`ba_outbox` box)
- `clearByTypePrefix` pour éviter les doublons
- Idempotency key pour les mutations sensibles

### ⚠️ Points faibles

| # | Problème | Sévérité |
|---|---|---|
| O1 | **Outbox jamais flushé automatiquement** : pas de `Timer.periodic` ou de listener de connectivité | **Major** |
| O2 | **`profile_patch` hors-ligne : pas de cache mis à jour** : la mise à jour locale est perdue si l'utilisateur quitte l'app | **Minor** |
| O3 | **`_dispatch` ne gère pas les conflits** : si 2 mutations offline entrent en conflit, la dernière gagne | **Minor** |

---

## 3. État de session & Auth

### Cycle de vie complet

```
App Launch → SplashPage → session.restore()
                              ├─ Token valide → /me → roles check → navigate
                              └─ Pas de token → Onboarding → Location → Auth Choice
                              
Login Flow : Email → OTP Request → OTP Verify → /me → roles check → navigate
                                                              ├─ client OK → bootstrap?
                                                              └─ pro REJECT → logout avec message
                                                              
Logout : POST /logout → clear secure storage → invalidate cache → redirect
```

### ✅ Forces
- **Roles guard** : vérifie que seul un `role == client` peut utiliser l'app
- **Restore session** : tokens chargés depuis `flutter_secure_storage`
- **Logout complet** : nettoie tokens + cache Hive

### ⚠️ Problèmes

| # | Problème | Sévérité |
|---|---|---|
| S1 | **`restore()` ne vérifie pas la validité du token** : pas de call à `/me` au restore — si token expiré, l'erreur 401 n'apparaît qu'à la première requête réelle | **Major** |
| S2 | **Pas de silent refresh au restore** : l'intercepteur 401 gère le refresh, mais pas de vérification proactive | **Minor** |
| S3 | **`ClientOnlyAuthException` catchée dans `handleAuthAction`** : affiche un snackbar, mais l'utilisateur reste sur l'app — session pas nettoyée | **Minor** |

---

## 4. Réseau & Cache

### Cache Hive — 6 boxes

| Box | Contenu | TTL implicite |
|---|---|---|
| `ba_salons` | Liste salons + détails | Jusqu'au prochain fetch |
| `ba_bookings` | Liste + détails réservations | Jusqu'au prochain fetch |
| `ba_notifications` | Notifications | Jusqu'au prochain fetch |
| `ba_profile` | Profil + méthodes paiement | Jusqu'au prochain fetch |
| `ba_settings` | Préférences utilisateur | Permanent |
| `ba_outbox` | Opérations offline | Jusqu'à synchronisation |

### Retry pattern

```
retryWithBackoff(run, maxAttempts=3, initialDelay=900ms)
  ├─ Attempt 1 → 0.9s
  ├─ Attempt 2 → 1.8s
  └─ Attempt 3 → 3.6s

Conditions de retry : connectionError, connectionTimeout, sendTimeout, receiveTimeout
```

### ✅ Forces
- Retry avec backoff exponentiel
- Cache stale avec indicateur visuel (`StaleDataNotice`)
- `keepDataOnReload` pour éviter le flash de loading

### ⚠️ Problèmes

| # | Problème | Sévérité |
|---|---|---|
| N1 | **Pas de TTL configurable** : le cache est "stale" seulement si le fetch échoue | **Minor** |
| N2 | **`retryWithBackoff` ne retry pas les 5xx** : seules les erreurs de connexion sont retryées | **Minor** |
| N3 | **Hive boxes ouverts séquentiellement** : `Future.wait` parallélise 6 boxes, mais sans fallback individuel | **Minor** |

---

## 5. Data Flow Critique : Booking Funnel

```
[SalonDetailPage] → "Réserver" → bookingFunnel.startFunnel(salonId)
                                        ↓
[ServiceSelectionPage] → selectService(id, name, price, duration)
                                        ↓
[StaffSelectionPage]  → selectEmployee(id?, name?)
                        ├─ "Sans préférence" → resolveBestStaffId()
                        └─ Staff spécifique
                                        ↓
[SlotSelectionPage]    → selectSlot(startsAtIso, employeeId?)
                                        ↓
[BookingReviewPage]    → bookingCreateProvider.create()
                          ├─ Échec 401 → logout + redirect
                          ├─ Échec 5xx → snackbar erreur
                          └─ Succès  → deposit > 0 ?
                                        ├─ Oui → PaymentHandoffPage
                                        └─ Non  → BookingSuccessPage
```

### Problèmes du funnel

| # | Problème | Sévérité |
|---|---|---|
| F1 | **Pas de bouton "Retour" vers l'étape précédente** : le funnel est linéaire, pas de modification de service après avoir choisi le staff | **Major** |
| F2 | **`resolveBestStaffId()` fait 2 × N appels API** : pour N employés, 2 jours → 2N appels API séquentiels | **Major** |
| F3 | **Aucune persistance du funnel** : si l'app est tuée, tout l'état est perdu | **Minor** |
| F4 | **`bookingCreateProvider` crée la booking avant le paiement** : si le paiement échoue, une booking "pending" orpheline reste en base | **Minor** |
| F5 | **PaymentHandoffPage : 800+ lignes** : tout le flow de paiement est dans un seul widget — devrait être extrait en services | **Critical** |

---

## 6. Recommandations

### 🔴 Priorité haute
1. **Fusionner `_hydrateSession` / `_hydrateSessionFromRaw`** — 60 lignes dupliquées
2. **Typer les modèles booking** avec BuiltValue au lieu de `Map<String, dynamic>`
3. **Extraire PaymentHandoffPage** — diviser en composants plus petits
4. **Ajouter flush automatique de l'outbox** via listener de connectivité

### 🟡 Priorité moyenne
5. **Paralléliser `_primeSetupCache()`** avec `Future.wait`
6. **Optimiser `resolveBestStaffId()`** — appels API parallèles avec `Future.wait`
7. **Valider le token au restore** — vérifier `/me` au lancement

### 🟢 Priorité basse
8. **Ajouter TTL au cache** pour les données catalog (45s comme config serveur)
9. **Factoriser `_dispatch`** avec une map de handlers au lieu d'un switch
10. **Persister le funnel booking** dans Hive pour résister au kill
