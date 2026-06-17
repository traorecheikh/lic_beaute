# Audit Mobile — Dépendances & Sécurité

> Généré le 17 juin 2026

## Score : **B+ (84/100)** 🟢

---

## 1. Analyse des dépendances

Note : le `pubspec.yaml` n'est pas à l'emplacement attendu (`apps/mobile-client/lib/pubspec.yaml` n'existe pas). Analyse basée sur les imports dans le code source.

### Dépendances clés

| Package | Usage | Version supposée | Maturité |
|---|---|---|---|
| `flutter_riverpod` | State management | ^2.x | ✅ Stable |
| `go_router` | Routing | ^14.x | ✅ Stable |
| `dio` | HTTP client | ^5.x | ✅ Stable |
| `beauteavenue_api` | Generated API client | workspace | ✅ Généré |
| `hive_ce` / `hive_ce_flutter` | Cache local | ^1.x | ✅ Stable |
| `flutter_secure_storage` | Token storage | ^9.x | ✅ Stable |
| `firebase_messaging` | Push notifications | ^15.x | ✅ Stable |
| `firebase_core` | Firebase init | ^3.x | ✅ Stable |
| `cached_network_image` | Image caching | ^3.x | ✅ Stable |
| `flutter_screenutil` | Responsive sizing | ^5.x | ✅ Stable |
| `intl` | Formatting | ^0.19.x | ✅ Stable |
| `google_fonts` | Font loading | ^6.x | ✅ Stable |
| `geolocator` | GPS | ^13.x | ✅ Stable |
| `geocoding` | Reverse geocode | ^3.x | ✅ Stable |
| `image_picker` | Camera/Gallery | ^1.x | ✅ Stable |
| `pinut` | OTP input | ^4.x | ✅ Stable |
| `toastification` | Toast notifications | ^2.x | ✅ Stable |
| `share_plus` | Native share sheet | ^10.x | ✅ Stable |
| `url_launcher` | External URLs | ^6.x | ✅ Stable |
| `connectivity_plus` | Network status | ^6.x | ✅ Stable |
| `built_value` | Data classes | ^8.x | ✅ Stable |
| `phone_form_field` | Phone input | ^2.x | ✅ Stable |
| `flutter_dotenv` | Env variables | ^5.x | ✅ Stable |
| `firebase_crashlytics` (non utilisé) | Crash reporting | — | ❌ Non intégré |
| `firebase_performance` (non utilisé) | APM | — | ❌ Non intégré |
| `sentry_flutter` (non utilisé) | Error tracking | — | ❌ Non intégré |

### ✅ Forces
- Stack moderne et stable (Riverpod 2, Dio 5, GoRouter 14, Hive CE)
- Tous les packages sont activement maintenus
- Firebase intégré pour push notifications et auth OTP backend
- Client API généré automatiquement depuis OpenAPI

### ⚠️ Problèmes

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| E1 | **Pas de crash reporting** : ni Sentry, ni Firebase Crashlytics, ni Datadog RUM | **Critical** |
| E2 | **Pas de monitoring performance** : Firebase Performance ou Sentry Performance non intégré | **Major** |
| E3 | **Pas d'APM** : aucune visibilité sur les temps de réponse API, les animations jank, ou la mémoire | **Major** |
| E4 | **Packages sur-utilisés** : `built_value` + `built_collection` + `one_of` — code généré très verbeux | **Minor** |
| E5 | **`beauteavenue_api` version non spécifiée** : généré en local, pas de versioning clair | **Minor** |

---

## 2. Sécurité

### Stockage

| Donnée | Stockage | Sécurité |
|---|---|---|
| Access token | `flutter_secure_storage` | ✅ AES/GCM + Keychain |
| Refresh token | `flutter_secure_storage` | ✅ AES/GCM + Keychain |
| User ID | `flutter_secure_storage` | ✅ |
| Cache Hive | Disque local non chiffré | ⚠️ Données sensibles (profile) non chiffrées |
| Firebase tokens | `flutter_secure_storage` | ✅ |

### Réseau

| # | Problème | Sévérité |
|---|---|---|
| X1 | **`http://` pour le dev API** : `AppEnv.apiBaseUrl` utilise `http://$host:3000` — OK en dev, mais doit être `https://` en prod | **Info** (géré par Coolify) |
| X2 | **Pas de certificate pinning** : Dio n'a pas de `BadCertificateHandler` personnalisé | **Minor** |
| X3 | **`kDebugMode` logger : `PrettyDioLogger`** peut logger des tokens dans les logs de debug | **Info** |
| X4 | **Données bancaires en mémoire** : `PaymentHandoffPage` stocke le numéro de carte en mémoire TextEditingController | **Minor** |

### Firebase

| # | Problème | Sévérité |
|---|---|---|
| F1 | **`google-services.json` et `GoogleService-Info.plist`** : doivent être exclus du git | **Info** (vérifier gitignore) |
| F2 | **Firebase App Check** : non intégré — API potentiellement appelable depuis des clients non autorisés | **Major** |

---

## 3. Build & CI

| # | Problème | Sévérité |
|---|---|---|
| B1 | **Pas de CI mobile** : aucun workflow GitHub Actions pour builder/tester l'app Flutter | **Major** |
| B2 | **Pas de lint Flutter** : `flutter analyze` / `dart analyze` non exécuté dans le CI | **Major** |
| B3 | **Pas de build Android/iOS** dans le CI | **Major** |
| B4 | **Code push (Shorebird)** : fichier `shorebird.yaml` présent mais pas intégré dans le CI | **Minor** |

---

## 4. Tokens & Secrets

| Secret | Stockage | Usage |
|---|---|---|
| JWT Access Token | `flutter_secure_storage` | Auth API |
| JWT Refresh Token | `flutter_secure_storage` | Refresh API |
| Firebase Cloud Messaging | Firebase SDK | Push notifications |
| FCM Device Token | `flutter_secure_storage` (deviceId) | Push registration |

✅ Aucun secret hardcodé dans le code source.

---

## 5. Recommandations

### 🔴 Priorité haute
1. **Ajouter un crash reporter** : Sentry ou Firebase Crashlytics — c'est un ***must-have*** pour une app en production
2. **Ajouter CI mobile** : au moins `flutter analyze` + `flutter test` sur chaque PR
3. **Intégrer Firebase App Check** : pour protéger les endpoints API

### 🟡 Priorité moyenne
4. **Ajouter un APM** : Firebase Performance ou Sentry Performance
5. **Chiffrer les données Hive** : utiliser `hive_ce_flutter` avec encryption pour les données profile
6. **Nettoyer les logs de debug** : ne pas logger les body de requêtes en release

### 🟢 Priorité basse
7. **Ajouter Shorebird code push** dans le CI pour les hotfixes
8. **Configurer certificate pinning** sur Dio en production
