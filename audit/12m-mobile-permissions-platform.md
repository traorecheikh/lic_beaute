# Audit Mobile — Permissions & Intégration Platforme

> Généré le 17 juin 2026

## Score : **B- (72/100)** 🟡

---

## 1. Permissions utilisées

| Permission | Package | Usage | Pages |
|---|---|---|---|
| **Location** | `geolocator` | Proximité salons, tri par distance | HomePage, SearchPage, SalonDetail |
| **Notifications** | `firebase_messaging` | Push notifications | ForegroundNotificationService |
| **Camera** | `image_picker` | Photo de profil, avatar | EditProfilePage, ProfileBootstrapPage |
| **Gallery** | `image_picker` | Upload photo | EditProfilePage |
| **Biometric** | non utilisé | — | — |
| **Storage** | non utilisé | — | — |

---

## 2. ✅ Points forts

| # | Force | Détail |
|---|---|---|
| P1 | **Location permission avec page dédiée** : `LocationPermissionPage` avec explication + 2 tentatives (request + settings) | ✅ Bien conçu |
| P2 | **Permission notifications déléguée à FCM** : `FirebaseMessaging.requestPermission()` est appelé une fois au démarrage, gère alert/badge/sound | ✅ Bon |
| P3 | **`LocationService` séparé** : `checkPermission()`, `requestLocationPermission()`, `openAppSettings()`, `getCurrentPosition()` dans un fichier dédié | ✅ Bon |
| P4 | **Permission status enum** : `LocationStatus` (granted, denied, deniedForever, restricted) avec mapping clair | ✅ Bon |
| P5 | **`LocationBannerDismissedNotifier`** : bannière "Activez la localisation" dismissable | ✅ Bon |

---

## 3. ⚠️ Problèmes identifiés

### Location

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| L1 | **Pas de fallback si location refusée** : HomePage montre les sections nearby/trending vides si l'utilisateur refuse la location — pas de message "Activez la localisation pour voir les salons près de chez vous" | **Major** |
| L2 | **`LocationPermissionPage` sans timeout** : si l'utilisateur est lent à répondre, la page reste bloquée | **Minor** |
| L3 | **Pas de `requestTemporaryFullAccuracy` (iOS 14+)** : iOS demande l'accès précis — l'app utilise le mode standard (précision iOS par défaut) | **Minor** |
| L4 | **Géolocalisation au démarrage** : HomePage appelle `Geolocator.getCurrentPosition()` dès l'ouverture — pas de lazy loading | **Minor** |

### Camera & Gallery

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| C1 | **Pas de permission check explicite** : `image_picker` gère lui-même les permissions — pas de contrôle custom | **Major** |
| C2 | **Pas de fallback si caméra refusée** : l'utilisateur tape "Prendre une photo" → rien ne se passe (silent failure) | **Major** |
| C3 | **Pas de compression d'image** : les photos uploadées depuis la caméra/gallery ne sont pas compressées — images en pleine résolution | **Major** |
| C4 | **Pas de crop/recadrage** : l'avatar peut être uploadé en 3000×4000px — pas de resize | **Minor** |

### Notifications

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| N1 | **Pas de permission check badge iOS** : `requestBadgePermission: false` dans `DarwinInitializationSettings` — pas de badge number | **Major** |
| N2 | **Pas de notification schedule** : `FlutterLocalNotificationsPlugin` utilisé seulement pour les notifications foreground — pas d'action programmée | **Minor** |
| N3 | **Pas de notification categories** : pas de boutons d'action sur les notifications (ex: "Marquer comme lu", "Voir la réservation") | **Minor** |

### FCM Registration Service

```dart
class FcmRegistrationService {
  final Dio _dio;
  bool _registered = false;

  Future<void> register() async {
    if (_registered) return;
    _registered = true;

    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    final token = await messaging.getToken();
    if (token == null) return;
    await _sendToken(token);
    messaging.onTokenRefresh.listen(_sendToken); // ← pas de gestion d'erreur
  }
}
```

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| F1 | **Pas de retry si envoi token échoue** : `_sendToken` lance une exception silencieuse si le POST échoue | **Major** |
| F2 | **Pas de token refresh après login** : `register()` est appelé une fois au démarrage — si l'utilisateur n'est pas connecté, le token n'est jamais envoyé | **Major** |
| F3 | **`_registered = true` avant la fin** : si `register()` échoue, `_registered` reste `true` — la prochaine tentative est ignorée | **Minor** |
| F4 | **Pas de re-register après logout/login** : `reset()` existe mais n'est pas appelé dans le logout flow | **Minor** |

---

## 4. Analyse des scénarios permission

### Location Permission Flow

```
HomePage.build()
  ├─ checkPermission() → granted ✅ → fetch nearby
  ├─ checkPermission() → denied ⚠️ → show LocationPermissionPage
  │   ├─ User grants ✅ → refresh + fetch
  │   ├─ User denies ⚠️ → show banner "Activez la localisation"
  │   └─ User deniesForever ❌ → show link to Settings
  └─ Banner dismissed → LocationBannerDismissedNotifier → pas de rappel
```

**Problème** : Après "denied" initial, la bannière s'affiche. Si l'utilisateur la dismiss, plus jamais de rappel. L'utilisateur peut oublier qu'il a désactivé la localisation.

### Notification Permission Flow

```
App.start()
  └─ FcmRegistrationService.register()
      ├─ messaging.requestPermission(alert, badge, sound)
      │   ├─ granted ✅ → getToken() → _sendToken()
      │   ├─ denied ❌ → return (silent)
      │   └─ notDetermined → attendre (pas géré)
      └─ onTokenRefresh.listen(_sendToken)
```

**Problème** : Pas de réessai si l'utilisateur a refusé les notifications puis change d'avis. La permission est requêtée une seule fois.

---

## 5. Recommandations

### 🔴 Priorité haute

1. **Ajouter le fallback location** : si l'utilisateur refuse la location, montrer "Tous les salons" ou "Salons populaires" au lieu de sections vides
2. **Corriger `FcmRegistrationService`** : retry sur `_sendToken`, appeler `register()` après login, retirer le `_registered = true` précoce
3. **Compresser les images uploadées** : resize à 1024×1024 max avant upload

### 🟡 Priorité moyenne

4. **Ajouter la permission badge iOS** : `requestBadgePermission: true` dans `DarwinInitializationSettings`
5. **Ajouter un fallback si caméra/gallery refusée** : message "Accès à la caméra refusé. Activez-la dans les paramètres."
6. **Ajouter `requestTemporaryFullAccuracy` pour iOS 14+**

### 🟢 Priorité basse

7. **Ajouter notification categories** : boutons "Marquer comme lu", "Voir la réservation"
8. **Lazy loader la location** : ne pas appeler `getCurrentPosition()` au démarrage de HomePage
9. **Ajouter un timeout à `LocationPermissionPage`** : auto-dismiss après 30s

---

## 6. Résumé

Les permissions sont **correctement gérées dans l'ensemble** avec des pages dédiées (location) mais présentent des **faiblesses notables** :

- 🔴 **Pas de fallback si location refusée** — sections vides sur HomePage
- 🔴 **FCM registration fragile** — pas de retry, pas de re-register après login
- 🔴 **Upload d'images sans compression** — photos en pleine résolution
- 🟡 **Caméra sans fallback si permission refusée**
- 🟡 **Badge iOS désactivé**

Score : **B- (72/100)** — fonctionnel mais nécessite des correctifs de robustesse.
