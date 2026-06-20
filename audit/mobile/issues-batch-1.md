# Audit Mobile Beauté Avenue — Batch 1

Date: 2026-06-20

## 🔴 App Store / Google Play — REJECTION RISK

### R1. iOS: NSCameraUsageDescription + NSPhotoLibraryUsageDescription absents
**Fichier**: `ios/Runner/Info.plist`
**Risque**: L'app utilise `image_picker` avec `ImageSource.gallery` et potentiellement `ImageSource.camera` (avatar upload, pages profil/édition). Apple **bloque le submission** sans ces clés.
**Impact**: L'app **crash** silencieusement sur iOS au moment du picker si ces permissions ne sont pas déclarées.
**Fix**: Ajouter dans `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Pour prendre une photo de profil ou envoyer une photo au support.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Pour choisir une photo de profil depuis votre galerie.</string>
```

### R2. Android: CAMERA permission manquante
**Fichier**: `android/app/src/main/AndroidManifest.xml`
**Risque**: `image_picker` nécessite `<uses-permission android:name="android.permission.CAMERA" />` pour la source caméra.
**Impact**: `ActivityNotFoundException` si `ImageSource.camera` est utilisé.
**Fix**: Ajouter dans `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### R3. Données bancaires loggées en debug
**Fichier**: `lib/src/core/network/dio_client.dart:44-51`
**Risque**: `PrettyDioLogger(requestBody: true)` imprime les données des requêtes POST dont les numéros de carte, CVV, mots de passe PayDunya.
**Impact**: Violation PCI-DSS si un build debug est inspecté/reviewé.
**Fix**: Filter les champs sensibles avant log, ou désactiver en mode release.


## 🔴 CRASH — NullPointerException / NoSuchMethodError

### C1. app_share.dart: force unwrap RepaintBoundary
**Fichier**: `lib/src/core/utils/app_share.dart:35`
**Problème**: `repaintKey.currentContext!` peut être null si le widget n'est pas encore accroché au render tree (ex: partage immédiat après build).
**Idem ligne 41**: `byteData!` — `image.toByteData()` peut retourner null.
**Impact**: Crash `Null check operator used on a null value`.

### C2. payment_handoff_page: profile!.email! crash
**Fichier**: `lib/src/features/booking/pages/payment_handoff_page.dart:223, 803, 807`
**Problème**: `profile!.email!` sur un utilisateur créé par téléphone (sans email) lance `NoSuchMethodError`.
**Exact lines**:
- L.223: `_emailController.text = profile!.email!.trim();`
- L.803: `if (profile?.email != null && profile!.email!.isNotEmpty)`
- L.807: `profile.email!,`
**Impact**: Tout utilisateur qui n'a pas d'email (compte phone-only) **ne peut pas ouvrir la page de paiement** — crash immédiat.

### C3. launchUrl sans canLaunchUrl — 8 fichiers
**Fichiers**:
- `lib/src/features/profile/pages/about_page.dart:145`
- `lib/src/features/profile/pages/support_page.dart:47,57,67`
- `lib/src/features/profile/pages/legal_page.dart:100`
- `lib/src/features/appointments/pages/booking_detail_page.dart:225`
- `lib/src/core/widgets/salon_map_card.dart:44`
- `lib/src/features/auth/pages/email_login_page.dart:150,163`
- `lib/src/features/auth/pages/auth_choice_page.dart:131,144`
- `lib/src/features/auth/pages/register_page.dart:152,165`
**Problème**: `launchUrl()` appelé sans `canLaunchUrl()` préalable.
**Impact**: `PlatformException` non catchée si aucune app ne gère le schéma d'URI (WhatsApp, tel:, mailto:, maps).


## 🟡 HIGH — UX CASSÉE / PERTE DE DONNÉES

### H1. engagement_notification_service: HiveError race condition
**Fichier**: `lib/src/core/services/engagement_notification_service.dart:340`
**Problème**: `_readProfile()` lit statiquement `AppModelCache.getMap()`. `AppModelCache` utilise Hive. Si la box `profileBox` n'est pas encore ouverte (lors du init parallèle), `HiveError` non catché.
**Impact**: L'app peut crash au lancement sur des devices lents.

### H2. Payment callback: pas de Universal/App Links
**Fichier**: `ios/Runner/Info.plist` + `android/app/src/main/AndroidManifest.xml`
**Problème**: Seul un custom scheme `beauteavenue://` existe. Pas d'Apple App Site Association (iOS) ni d'Asset Links (Android).
**Impact**: iOS 14+ peut bloquer les custom schemes si l'app n'est pas au premier plan. Le flux PayDunya → callback navigateur → retour app est fragile.

### H3. Onboarding → Location → Auth: pas de "skip"
**Fichier**: `lib/src/core/location/location_permission_page.dart`
**Problème**: Aucun bouton "Passer" ou "Plus tard". L'utilisateur qui refuse la géolocalisation est bloqué sur l'écran.
**Impact**: L'utilisateur ne peut pas continuer le flow d'inscription.

### H4. OTP Dialog: TextEditingController jamais disposed
**Fichier**: `lib/src/features/booking/pages/payment_handoff_page.dart:1264`
**Problème**: `final codeController = TextEditingController();` dans `_showOtpDialog()` n'est jamais disposed.
**Impact**: Mineur (GC collecte sur fermeture du dialog), mais pas idiomatique.


## 🟢 LOW — PROPRETÉ / MAINTENANCE

### L1. _isAuthPath incomplete
**Fichier**: `lib/src/core/network/dio_client.dart:118`
**Problème**: `/auth/check-availability` pas dans la liste. L'endpoint reçoit un Bearer token inutilement.
**Impact**: Aucun fonctionnement.

### L2. Background polling survit au dispose du widget
**Fichier**: `lib/src/features/booking/pages/payment_handoff_page.dart`
**Problème**: `_cancelBackgroundPolling()` commente que le provider continue après dispose. Si l'utilisateur revient sur la page, pas de réinitialisation propre.
**Impact**: Double polling possible dans certains scénarios.
