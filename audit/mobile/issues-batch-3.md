# Audit Mobile Beauté Avenue — Batch 3

Date: 2026-06-20

## 🟡 HIGH

### H12. Race condition: toggles rapides multiplient les PATCH /me
**Fichier**: `lib/src/features/profile/pages/notification_preferences_page.dart:86`
**Problème**: Chaque toggle de Switch appelle immédiatement `updateProfile()`. Si l'utilisateur toggle rapidement push notifications, les requêtes PATCH /me se chevauchent. Le backend peut recevoir des valeurs contradictoires (pushOptIn: true puis pushOptIn: false).
**Impact**: État du compte utilisateur indéterministe après toggles rapides.

### H13. AppRouteRefreshObserver est du dead code
**Fichier**: `lib/src/router/observers.dart`
**Problème**: `AppRouteRefreshObserver` n'est importé nulle part. Le fichier peut être supprimé. Mais s'il est réactivé accidentellement, il double les `refreshAll()` déjà appelés depuis `_AppLifecycleRefreshState`.

### H14. routerProvider reconstruit à chaque session change
**Fichier**: `lib/src/router/app_router.dart:113`
**Problème**: `final router = ref.watch(routerProvider);` — À chaque changement de session (login/logout), le router est recréé car `routerProvider` écoute `sessionProvider`. Mais le `redirect` callback lit aussi `sessionProvider` directement (lignes 114-126). Le router est donc recréé ET son redirect est déclenché, ce qui peut causer des doubles navigations ou des boucles.
**Impact**: Rarement visible, mais peut causer des comportements inattendus de navigation.

### H15. Aucune gestion des Universal Links / App Links (deeplinks)
**Fichiers**:
- `ios/Runner/Info.plist`: Only custom scheme `beauteavenue://` 
- `android/app/src/main/AndroidManifest.xml`: Only custom scheme
**Problème**: Pas de fichier `apple-app-site-association` (iOS) ni `assetlinks.json` (Android). iOS 14+ bloque souvent les custom schemes si l'app n'est pas au premier plan. Les callback PayDunya vers l'app sont instables.
**Fix**: Configurer Universal Links (iOS) + App Links (Android) pour les URLs de callback PayDunya.

## 🟢 LOW

### L5. notification_preferences_page: pas de debounce sur les toggles
**Fichier**: `lib/src/features/profile/pages/notification_preferences_page.dart`
**Problème**: Chaque toggle envoie immédiatement une requête API. Devrait avoir un debounce de ~300ms.

### L6. observers.dart fichier orphelin
**Fichier**: `lib/src/router/observers.dart`
**Problème**: Plus importé nulle part, devrait être supprimé pour éviter la confusion.

## 📊 RÉSUMÉ PAR SÉVÉRITÉ

| Sévérité | Nombre | Détails |
|----------|--------|---------|
| 🔴 App Store Reject | 3 | R1 (iOS camera), R2 (Android CAMERA), R3 (PCI-DSS) |
| 🔴 Crash | 6 | C1 (share), C2 (email!), C3 (launchUrl), C4 (data!), C5 (auth state), C6 (push tokens) |
| 🟡 High | 15 | H1-H15 |
| 🟢 Low | 6 | L1-L6 |

## POINTS PRIORITAIRES À FIXER

1. 🔴 **R1 + R2**: Ajouter NSCameraUsageDescription + CAMERA permission (App Store reject)
2. 🔴 **C2**: `profile.email!` crash dans payment_handoff_page (phone-only users)
3. 🔴 **C3**: Wrapper tous les `launchUrl` avec `canLaunchUrl` (8 fichiers)
4. 🔴 **R3**: Filtrer les données bancaires du PrettyDioLogger
5. 🔴 **C5**: Réparer l'état corrompu dans `_hydrateSessionFromRaw`
6. 🟡 **H5**: Réduire le nombre de providers invalidés par `refreshAll()`
7. 🟡 **H9**: Ajouter un bouton "Fermer" immédiat sur PaymentWaitingSheet
8. 🟡 **H15**: Configurer Universal Links / App Links
