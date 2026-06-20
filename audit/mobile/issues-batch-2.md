# Audit Mobile Beauté Avenue — Batch 2

Date: 2026-06-20

## 🔴 CRASH

### C4. Auth provider: `response.data!` null crash
**Fichier**: `lib/src/features/auth/providers/auth_provider.dart:119`
**Problème**: `final user = meResponse.data!;` — si l'API `/api/v1/me` retourne 200 avec body null ou vide, le `!` crash.
**Impact**: L'utilisateur ne peut pas se connecter si l'API /me échoue silencieusement.

### C5. Auth provider: état corrompu si /me échoue
**Fichier**: `lib/src/features/auth/providers/auth_provider.dart:112-130`
**Problème**: `_hydrateSessionFromRaw` appelle d'abord `notifier.login(accessToken, refreshToken, userId: '')` avec un userId vide, puis fetch /me, puis `notifier.login()` à nouveau. Si `/me` échoue entre les deux, l'utilisateur est dans un état "connecté" (tokens stockés) avec userId='' et role=null. `isAuthenticated` retourne faux car `userId?.trim().isNotEmpty` est faux, donc l'utilisateur est orphelin : tokens stockés mais page d'accueil affiche "non connecté".
**Impact**: Après un refresh token perdu ou une session expirée au moment de la reconnexion, l'utilisateur reste bloqué avec des tokens invalides sans possibilité de récupération. Il doit supprimer manuellement les données de l'app.

### C6. Delete account: tokens push non désactivés côté serveur
**Fichier**: `lib/src/features/profile/pages/profile_page.dart:318`
**Problème**: `dio.delete<void>('/api/v1/me')` supprime le compte mais le FCM push token reste enregistré côté serveur. Aucune route de cleanup n'est appelée.
**Impact**: Le serveur accumule des push tokens orphelins et l'utilisateur recevra des notifications push fantômes s'il se réinscrit (nouveau token associé à l'ancien compte).

### C7. notification_preferences_page: `ref.read` without provider validation
**Fichier**: `lib/src/features/profile/pages/notification_preferences_page.dart`
**Impact**: Si la page est ouverte sans session active, `ref.read(sessionProvider)` peut retourner un état invalide. La page utilise `if (!session.isAuthenticated) return;` mais c'est une page protégée par `authGuardRedirect` donc OK en pratique.

## 🟡 HIGH — UX, PERFORMANCE, SÉCURITÉ

### H5. refreshAll() appelé sur chaque tab switch ET chaque app resume
**Fichiers**:
- `lib/src/reactivity/app_reactivity.dart:refreshAll()` — invalide 18 providers
- `lib/src/router/observers.dart:didPush/didPop` — appelé à chaque navigation
- `lib/src/app.dart:_AppLifecycleRefreshState.didChangeAppLifecycleState` — appelé à chaque resume
**Problème**: Chaque invalidation déclenche un refetch réseau. Navigation entre tabs = 18 requêtes API. Resume app = 18 requêtes API. Sur réseau lent, l'app est inutilisable pendant plusieurs secondes après chaque action simple.
**Impact**: UX dégradée + rate limiting possible côté serveur en production avec 1000+ utilisateurs.

### H6. AppRouteRefreshObserver toujours actif
**Fichier**: `lib/src/router/observers.dart`
**Problème**: Le code est présent et le debounce de 350ms est court. L'observer doit être enregistré quelque part dans le GoRouter. Si le shell_scaffold l'importe encore, les refreshAll sont doublés (observer + app lifecycle).
**Vérifier**: Si `routerProviders` utilise encore `observers: [AppRouteRefreshObserver(ref)]`.

### H7. Outbox: flush() non déclenché automatiquement au retour online
**Fichier**: `lib/src/core/sync/app_outbox.dart`
**Problème**: `flush()` n'est jamais appelé automatiquement quand la connectivité revient. Les modifications offline restent bloquées dans l'outbox jusqu'au prochain lancement de l'app.
**Impact**: Un utilisateur qui modifie son profil hors-ligne ne verra pas ses changements synchronisés tant qu'il ne rouvre pas l'app.

### H8. Hive favorites getter retourne la settings box
**Fichier**: `lib/src/core/storage/app_cache.dart:26`
**Problème**: `static Box<dynamic> get favorites => Hive.box<dynamic>(StorageKeys.settingsBox);` — devrait être un box dédié aux favoris. Les données des favoris et des settings sont mélangées dans la même box.
**Impact**: Les clés de favoris et de settings peuvent entrer en conflit, causant des lectures/écritures incorrectes.

### H9. Suivi de réservation: modal bottom sheet non dismissible
**Fichier**: `lib/src/features/booking/pages/payment_handoff_page.dart` (via `PaymentWaitingSheet`)
**Problème**: `showModalBottomSheet(isDismissible: false, enableDrag: false)`. La seule sortie est "Fermer" après timeout (5 min). Si l'utilisateur veut annuler avant 5 min, pas possible.
**Impact**: L'utilisateur est bloqué 5 minutes sur l'écran d'attente.

### H10. backgroundPollingProvider Timer non cancellé si provider dispose
**Fichier**: `lib/src/features/booking/providers/booking_create_provider.dart:151`
**Problème**: `_timer = Timer(_interval, _runCheck);` — Riverpod `Notifier` n'a pas de hook dispose automatique. Si le provider est recréé (hot reload, invalidation), le timer continue avec des refs périmées. Le cas nominal est géré (chaque `start()` cancel le timer précédent), mais l'invalidation externe n'est pas couverte.
**Impact**: Timer fantôme qui peut tenter de reconcilier avec des données périmées.

### H11. Delete account: message trompeur
**Fichier**: `lib/src/features/profile/pages/profile_page.dart:294-300`
**Problème**: Le dialog dit "Supprime votre compte **sur cet appareil**" — sous-entend que c'est local uniquement, mais `dio.delete('/api/v1/me')` supprime le compte côté serveur.
**Impact**: Un utilisateur pourrait penser que c'est safe parce que "c'est juste local".

## 🟢 LOW — PROPRETÉ

### L3. analysis_options.yaml minimal
**Fichier**: `analysis_options.yaml`
**Problème**: N'inclut que `flutter_lints` (le set de base). Manque `flutter_lints` étendu, `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `unnecessary_null_checks`.
**Impact**: Des bugs potentiels passent la CI.

### L4. AppEnv.apiBaseUrl: pas de HTTPS en production par défaut
**Fichier**: `lib/src/core/env/app_env.dart:17-18`
**Problème**: La valeur par défaut utilise `http://` (pas HTTPS). Si le `.env` n'est pas présent, l'app communique en clair.
**Impact**: iOS ATS bloque les requêtes HTTP en release (mais un export d'App Store peut le contourner). Sécurité des tokens compromise.

### L5. Image picker sans fichier: gestion d'erreur absente
**Fichier**: `lib/src/features/profile/pages/edit_profile_page.dart_avatar`, `profile_bootstrap_page.dart`
**Problème**: `final image = await picker.pickImage(...)` peut retourner null si l'utilisateur annule. Les pages gèrent déjà ce cas (return si null). OK.

## ⚠️ À VÉRIFIER

- `app_router.dart`: Vérifier si `AppRouteRefreshObserver` est toujours passé dans `observers: []` à la création du GoRouter.
- `lib/src/core/network/dio_client.dart:118`: Vérifier que `/auth/check-availability` est bien dans `_isAuthPath`.
- `notification_preferences_page.dart`: Vérifier qu'il y a un guard `session.isAuthenticated`.
