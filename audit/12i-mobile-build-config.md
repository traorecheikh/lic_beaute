# Audit Mobile — Configuration Build & CI/CD

> Généré le 17 juin 2026

## Score : **C+ (65/100)** 🟠

---

## 1. Configuration Flutter/Dart

### pubspec.yaml

| Métrique | Valeur | Évaluation |
|---|---|---|
| Version SDK | `>=3.8.0 <4.0.0` | ✅ Très récent (Dart 3.8) |
| Version app | `0.1.0+2` | ⚠️ Pré-release |
| Dépendances | **38** (33 runtime + 5 dev) | ✅ Modéré |
| Packages inutilisés | 0 détectés | ✅ |
| Packages en conflit | 0 détectés | ✅ |

### Dépendances à surveiller

| Package | Version actuelle | Risque |
|---|---|---|
| `flutter_riverpod` | ^3.1.0 | ✅ Stable |
| `go_router` | ^17.2.3 | ⚠️ Changements breaking fréquents (v17 → v18 récemment) |
| `dio` | ^5.7.0 | ✅ Stable |
| `hive_ce` | ^2.19.3 | ✅ Stable (fork de Hive) |
| `firebase_core` | ^4.7.0 | ✅ Stable |
| `firebase_messaging` | ^16.2.0 | ✅ Stable |
| `permission_handler` | ^12.0.1 | ⚠️ Migration breaking vers API 12 |
| `geolocator` | ^14.0.2 | ⚠️ Breaking changes récents |
| `connectivity_plus` | ^7.1.1 | ⚠️ Fragile (v7+) |
| `patrol` | ^4.6.0 | ✅ Stable |
| `shimmer` | ^3.0.0 | ⚠️ Pas de mise à jour depuis 2023 |
| `toastification` | ^3.2.0 | ✅ Stable |
| `cached_network_image` | ^3.4.1 | ✅ Stable |
| `flutter_svg` | ^2.2.4 | ✅ Stable |
| `phone_form_field` | ^10.0.17 | ⚠️ Changelog breaking fréquent |

### Dépendances manquantes

| Package | Utilité | Priorité |
|---|---|---|
| `sentry_flutter` / `firebase_crashlytics` | Crash reporting | 🔴 Haute |
| `firebase_performance` / `sentry_dart` | APM | 🟡 Moyenne |
| `freezed` (déjà en dev) | Code generation modèles | ✅ Présent |
| `json_serializable` (déjà en dev) | JSON serialization | ✅ Présent |

### Analysis Options

```
analysis_options.yaml :
  include: package:flutter_lints/flutter.yaml    ← Standard
  analyzer:
    exclude:
      - packages/beauteavenue_api/**              ← Généré, OK
```

⚠️ **Problème** : `riverpod_lint` et `custom_lint` sont en dev dependencies mais pas activés dans `analysis_options.yaml` :

```yaml
# Recommandé — manquant actuellement
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - riverpod_provider_missing_description
    - riverpod_public_provider_without_comment
```

---

## 2. Configuration Android

### build.gradle.kts (app)

| Paramètre | Valeur | Évaluation |
|---|---|---|
| `compileSdk` | `flutter.compileSdkVersion` (≈34) | ✅ Dynamique |
| `minSdk` | `flutter.minSdkVersion` (≈21) | ✅ Minimum suffisant |
| `targetSdk` | `flutter.targetSdkVersion` (≈34) | ✅ Dynamique |
| `namespace` | `sn.lic.beauteavenu` | ✅ Correct |
| Java | VERSION_17 | ✅ Moderne |
| `isCoreLibraryDesugaringEnabled` | `true` | ✅ Bonnes pratiques |
| `testInstrumentationRunner` | `PatrolJUnitRunner` | ✅ Patrol |
| **Release signing** | **Signé en debug** | ❌ **TO DO** |

### Problèmes détectés

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| B1 | **Release signing en debug** : le build release est signé avec la clé debug — l'app ne peut pas être publiée sur le Play Store | **Critical** |
| B2 | **`applicationId` commenté (TODO)** : `sn.lic.beauteavenu` — devrait être confirmé | **Minor** |
| B3 | **Pas de ProGuard/R8** : `minifyEnabled` pas configuré — APK non optimisé | **Major** |
| B4 | **`google-services.json` dans le git** : fichier sensible versionné | **Minor** (vérifier .gitignore) |

---

## 3. Configuration iOS

### Info.plist

| Paramètre | Valeur | Évaluation |
|---|---|---|
| `CFBundleDisplayName` | "Beauteavenue Mobile Client" | ⚠️ Nom technique — devrait être "Beauté Avenue" |
| `CFBundleName` | "beauteavenue_mobile_client" | ⚠️ Nom technique |
| `CADisableMinimumFrameDurationOnPhone` | `true` | ✅ Performance iOS 17+ |
| `UIBackgroundModes` | `remote-notification` (présumé) | ✅ Push |
| Minimum iOS | **15.0** (Podfile) | ✅ Moderne |

### Problèmes détectés

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| I1 | **Display name non final** : "Beauteavenue Mobile Client" au lieu de "Beauté Avenue" | **Major** |
| I2 | **Bundle name snake_case** : "beauteavenue_mobile_client" — devrait être "BeauteAvenue" | **Minor** |
| I3 | **Pas de configuration de signature** : `project.pbxproj` non audité | **Info** |
| I4 | **`GoogleService-Info.plist` dans le git** : fichier sensible versionné | **Minor** (vérifier .gitignore) |

---

## 4. Firebase & Push

| Service | Statut | Notes |
|---|---|---|
| **Firebase Core** | ✅ Initialisé | `firebase_options.dart` généré |
| **Firebase Messaging** | ✅ Intégré | Push notifications |
| **Firebase Crashlytics** | ❌ **Non intégré** | Pas de crash reporting |
| **Firebase Performance** | ❌ **Non intégré** | Pas d'APM |
| **Firebase App Check** | ❌ **Non intégré** | Pas de protection API |
| **Firebase Analytics** | ❌ **Non intégré** | Pas de tracking utilisateur (RGPD ?) |
| **Flutter Local Notifications** | ✅ Intégré | Notifications locales foreground |

### Problèmes

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| F1 | **Fichiers Firebase dans le git** : `google-services.json` et `GoogleService-Info.plist` — clés exposées | **Major** |
| F2 | **Pas de vérification `.gitignore`** : ces fichiers devraient être exclus et injectés via CI | **Major** |
| F3 | **Env `.env` dans assets Flutter** : `assets/.env` — lisible depuis l'APK  (décompilation) | **Major** |
| F4 | **URL de dev exposée** : `.env` contient `API_BASE_URL=http://10.0.2.2:3000` — OK pour dev mais à exclure des builds release | **Minor** |

---

## 5. Assets

| Asset | Emplacement | Usage |
|---|---|---|
| Logo | `assets/logo.png` | Splash, app icon |
| Logo foreground | `assets/logo_foreground.png` | Launcher icon |
| OM | `assets/om.png` | Orange Money logo |
| Wave | `assets/wave.png` | Wave logo |
| Icons SVG | `assets/icons/` | Icônes custom |
| Onboarding | `assets/onboarding/` | 3 slides onboarding |
| `.env` | Oui | API base URL |
| `shorebird.yaml` | Oui | Shorebird config |

### Analyse

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| A1 | **Assets non optimisés** : pas de WebP, pas de compression — les PNG sont bruts | **Minor** |
| A2 | **`assets/icons/` non audités** : format SVG — OK mais pas de fallback PNG | **Info** |
| A3 | **`shorebird.yaml` dans le git** : pas un secret (app_id est public), OK | **Info** |

---

## 6. CI/CD

### État actuel

| Élément | Statut | Détail |
|---|---|---|
| **CI GitHub Actions** | ❌ **Aucun** | Pas de workflow mobile |
| **Build Android** | ❌ Non automatisé | Manuel seulement |
| **Build iOS** | ❌ Non automatisé | Manuel seulement |
| **Tests** | ❌ Non automatisés | `flutter test` jamais exécuté en CI |
| **Lint** | ❌ Non automatisé | `dart analyze` jamais exécuté en CI |
| **Code Push (Shorebird)** | ❌ Non intégré CI | `shorebird.yaml` présent mais pas de pipeline |
| **Code Generation** | ❌ Non automatisé | `build_runner` manuel |
| **OpenAPI Generation** | ❌ Non automatisé | `generate-mobile-client.sh` manuel |
| **Patrol E2E** | ❌ Non automatisé | Pas de device farm |
| **APK/IPA livrables** | ❌ Pas d'artifact CI | |

### Analyse

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| C1 | **Absence totale de CI mobile** : aucune validation automatique sur les PRs | **Critical** |
| C2 | **Pas de build automatisé** : chaque build est manuel — risque d'erreur humaine | **Major** |
| C3 | **Pas de gestion des secrets** : fichiers Firebase et .env dans le git — pas d'injection CI | **Major** |
| C4 | **Pas de versioning automatique** : `version: 0.1.0+2` manuel — pas de `--build-name`/`--build-number` automatisé | **Minor** |
| C5 | **OpenAPI spec désynchronisé** : aucune vérification que le generated client est à jour avec l'API | **Major** |

---

## 7. Shorebird (Code Push)

### Statut

| Élément | Valeur |
|---|---|
| `app_id` | `5b1baed4-4dc2-495f-8661-f7929fe426ae` |
| `auto_update` | true (par défaut) |
| SDK installé | `shorebird.yaml` présent, package non listé dans pubspec |

**⚠️ Problème** : `shorebird_code_push` n'est pas dans les dépendances `pubspec.yaml`. La config `shorebird.yaml` est présente mais le package SDK n'est pas installé :

```yaml
# pubspec.yaml ne contient PAS :
dependencies:
  shorebird_code_push: ^x.y.z
```

Sans le package, Shorebird ne fonctionne pas — le fichier `shorebird.yaml` est juste décoratif.

---

## 8. OpenAPI & Code Generation

| Élément | Statut |
|---|---|
| Source | `apps/api/openapi/openapi.json` |
| Générateur | `@openapitools/openapi-generator-cli` v7.22.0 |
| Output | `packages/beauteavenue_api` |
| Script | `generate-mobile-client.sh` |
| Build Runner | `build_runner` pour `freezed`/`json_serializable` |

### Problèmes

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| G1 | **Génération manuelle** : aucune étape CI qui régénère le client | **Major** |
| G2 | **Pas de vérification de compatibilité** : la spec OpenAPI peut changer sans que le generated client soit mis à jour | **Major** |
| G3 | **`openapitools.json` dans mobile-client** : la config est dans le projet Flutter mais la spec est dans le projet API | **Info** |
| G4 | **Modèles non utilisés** : beaucoup de modèles générés pour l'admin/pro qui ne sont jamais utilisés par le client mobile | **Minor** |

---

## 9. Recommandations

### 🔴 Priorité haute — CI/CD

1. **Créer un workflow GitHub Actions mobile** :
   - `flutter analyze` sur chaque PR
   - `flutter test` sur chaque PR
   - Build Android + iOS sur merge vers `main`
   - Artefacts APK/IPA en artifacts
2. **Exclure les fichiers sensibles du git** : `google-services.json`, `GoogleService-Info.plist`, `.env`
3. **Signer le build release Android** avec une vraie clé (pas debug)

### 🟡 Priorité moyenne — Build

4. **Installer `shorebird_code_push`** dans les dépendances et configurer le pipeline de patches
5. **Ajouter `riverpod_lint`** à `analysis_options.yaml`
6. **Ajouter ProGuard/R8** pour le build Android release (`minifyEnabled = true`)
7. **Corriger le display name iOS** : "Beauté Avenue"

### 🟢 Priorité basse — Organisation

8. **Automatiser le versioning** : utiliser `--build-name` et `--build-number` en CI
9. **Ajouter une vérification de compatibilité OpenAPI** en CI (comparer hash du fichier openapi.json)
10. **Optimiser les assets** : PNG → WebP, compresser les images

---

## 10. Résumé

La configuration build est **utilisable mais immature pour la production** :

- 🔴 **Aucun CI/CD mobile** — builds et tests manuels
- 🔴 **Secrets exposés** (Firebase, .env) dans le git
- 🔴 **Release signing Android en debug** — pas publiable
- 🔴 **Shorebird non fonctionnel** (SDK manquant)
- 🟡 **Display name iOS incorrect**
- 🟡 **`riverpod_lint` non activé**
- 🟢 **Stack technique saine et moderne**

Score : **C+ (65/100)** — doit impérativement ajouter CI/CD + signer Android avant la mise en production.
