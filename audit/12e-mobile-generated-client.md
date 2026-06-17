# Audit Mobile — Client API Généré

> Généré le 17 juin 2026

## Score : **B+ (82/100)** 🟢

---

## 1. Architecture du client API

### Génération
- **Outil :** OpenAPI Generator CLI (`dart-dio`)
- **Source :** `apps/api/openapi/openapi.json`
- **Output :** `apps/mobile-client/packages/beauteavenue_api`
- **Commande :** `generate-mobile-client.sh`

### Contenu généré
- ~200 modèles BuiltValue (avec `built_value`, `built_collection`, `one_of`)
- API classes (AuthApi, SalonsApi, BookingsApi, SearchApi, etc.)
- Serializers (`standardSerializers`)
- Client (`BeauteavenueApi`)

### Utilisation dans l'app

```
apiClientProvider (Provider<BeauteavenueApi>)
  ├─ getAuthApi() → AuthApi
  ├─ getSalonsApi() → SalonsApi
  ├─ getBookingsApi() → BookingsApi
  └─ getSearchApi() → SearchApi
  
+ dio direct pour :
  ├─ /api/v1/me (profile, update)
  ├─ /api/v1/favorites/*
  ├─ /api/v1/bookings/:id/cancel
  ├─ /api/v1/notifications/*
  ├─ /api/v1/payments/*
  ├─ /api/v1/push-tokens
  └─ /api/v1/media/*
```

---

## 2. ✅ Bonnes pratiques

| # | Pratique | Exemple |
|---|---|---|
| G1 | **Client typé pour les endpoints principaux** | `AuthApi`, `SalonsApi`, `BookingsApi`, `SearchApi` |
| G2 | **Serialisation BuiltValue** pour le cache | `AppModelCache.putModel<T>` avec `standardSerializers` |
| G3 | **Refresh token avec le generated client** | `AuthApi.apiV1AuthRefreshPost()` |
| G4 | **Barrel exports propres** | `beauteavenue_api.dart` exporte tout |
| G5 | **Génération reproduisible** | script shell dédié + spec OpenAPI versionnée |

---

## 3. ⚠️ Problèmes

### Pattern hybride : generated API + raw Dio

L'app utilise deux approches pour les appels API :

| # | Problème | Localisation | Sévérité |
|---|---|---|---|
| H1 | **Mélange generated client / Dio direct** : 50% des endpoints utilisent le generated client, 50% utilisent Dio directement | Multiple providers | **Major** |
| H2 | **Pas de raison claire pour le choix** : certains endpoints du même domaine sont appelés via l'API générée ET via Dio (ex : `/api/v1/me` dans `profileProvider` utilise Dio, mais `AuthProvider` utilise `currentUserProvider` via generated API) | `profile_provider.dart` vs `auth_provider.dart` | **Major** |
| H3 | **`fetchCachedItemList` utilise Dio direct** : ignore le generated client pour les appels cachés | `cached_fetch.dart` | **Minor** |
| H4 | **`searchResultsProvider` utilise le generated client, mais `searchSuggestionsProvider` aussi** : cohérent ici ✅ | `search_provider.dart` | **Info** |

### Problèmes spécifiques

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| P1 | **Modèles non utilisés** : `BeauteavenueApi` wrapper ajoute `interceptors: []` — les intercepteurs du generated client sont ignorés car Dio est déjà configuré séparément | `api_client_provider.dart:8` | **Minor** |
| P2 | **`BookingCreateInput` avec builder pattern** : verbosité BuiltValue — `BookingCreateInput((b) => b..salonId = ...)` au lieu d'un simple Map | `booking_create_provider.dart:29-35` | **Minor** |
| P3 | **`EmailLoginInput` : builder pattern 4 niveaux** : `EmailLoginInput((b) => b..email = email..password = password)` — très verbeux | `auth_provider.dart:28-33` | **Minor** |
| P4 | **`registerEmail` avec `AnyOf2`** : le type `AnyOf2<RegisterInputAnyOf, RegisterInputAnyOf1>` est complexe et difficile à manipuler | `auth_provider.dart:56-65` | **Minor** |
| P5 | **`ApiError` dupliqué** : l'app définit son propre `ApiError` (dio_exception_utils), les erreurs générées du client API ne sont pas utilisées directement | Multiples fichiers | **Minor** |
| P6 | **`beauteavenue_api` contient des modèles non utilisés** : ex : `Intech...` models | Modèles générés | **Info** |

---

## 4. Endpoints utilisés

| Domaine | Generated API | Dio direct |
|---|---|---|
| **Auth** | `login`, `register`, `otp/request`, `otp/verify`, `refresh` | `otp/email/*`, `logout` |
| **Salons** | `list`, `detail`, `reviews` | — |
| **Search** | `suggestions`, `salons`, `events` | — |
| **Bookings** | `list`, `create` | `cancel`, `reschedule`, `review` |
| **Profile** | `me` (lecture) | `me` (PATCH), upload avatar |
| **Favorites** | — | `favorites/*` (CRUD complet) |
| **Payments** | — | `payments/*`, `deposits/*` |
| **Notifications** | — | `notifications/*` (CRUD) |
| **Media** | upload-intent (partiellement) | `media/*` (upload multipart, complete) |
| **Push tokens** | — | `push-tokens` |
| **Config** | — | `metadata/*`, `platform/*` |

---

## 5. Recommandations

### 🔴 Haute priorité
1. **Uniformiser les appels API** : choisir generated client OU Dio direct, pas les deux
   - Soit : tout passer par le generated client (plus typé, maintenance automate)
   - Soit : supprimer le generated client et utiliser Dio + types manuels (plus simple, moins de génération)

### 🟡 Moyenne priorité
2. **Migrer les endpoints Dio → generated client** : `/api/v1/me`, `/api/v1/favorites/*`, `/api/v1/notifications/*`, `/api/v1/payments/*`
3. **Nettoyer les modèles inutilisés** du generated client (Intech, etc.)
4. **Versionner le spec OpenAPI** pour suivre les changements

### 🟢 Basse priorité
5. **Envisager de remplacer BuiltValue** par `freezed` (plus simple, moins verbeux, meilleure DX)
6. **Ajouter des tests d'intégration** qui valident que le generated client est synchro avec l'API réelle
