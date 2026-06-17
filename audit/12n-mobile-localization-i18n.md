# Audit Mobile — Localisation & Internationalisation

> Généré le 17 juin 2026

## Score : **B (78/100)** 🟡

---

## 1. Architecture de localisation

### Stack

| Technologie | Usage | Statut |
|---|---|---|
| `flutter_localizations` (SDK) | Framework Material localisé | ✅ Intégré |
| `intl` | Formatage date, nombre, devise | ✅ Intégré |
| `AppStrings` (constantes) | Textes métier français | ✅ 80 strings |
| `AppContacts` | Coordonnées support | ✅ 5 constantes |
| `NumberFormat.currency` | Format XOF | ✅ Partout |
| `DateFormat` | Format français | ✅ Partout |

### Langues supportées

| Langue | Statut | Notes |
|---|---|---|
| **Français (fr)** | ✅ Seule langue | Toute l'UI est en français |
| **Anglais (en)** | ❌ Non supporté | Pas de fallback |
| **Wolof (wo)** | ❌ Non supporté | Pas de traduction |
| **Arabe (ar)** | ❌ Non supporté | Pas de RTL |

---

## 2. ✅ Points forts

### Textes français naturels

```dart
// ✅ Pas de jargon technique
"Votre session a expiré"  // pas "401 Unauthorized"
"Connexion indisponible"  // pas "Network error"
"Réservation confirmée !" // pas "Booking confirmed"

// ✅ Blâme système
"Le serveur met trop de temps à répondre."
"Notre service est momentanément indisponible."

// ✅ Messages clairs
"Annulation gratuite jusqu'à 24h avant"
"Complétez votre profil pour payer"
```

### Formatage

| # | Force | Détail |
|---|---|---|
| F1 | **`NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA')`** partout | ✅ |
| F2 | **`DateFormat('dd/MM/yyyy')`** français partout | ✅ |
| F3 | **Durées formatées** : "1h30" au lieu de "90 min" | ✅ |
| F4 | **Contacts sénégalais** : +221, support WhatsApp, email | ✅ |

### AppStrings

| Catégorie | Strings | Exemples |
|---|---|---|
| Auth | 18 | Bienvenue, email, OTP, password |
| Navigation | 3 | Découvrir, Mes RDV, Profil |
| Discovery | 6 | Recherche, filtres, favoris |
| Booking | 12 | Étapes, prestation, staff |
| Profile | 10 | Mon compte, éditer, paramètres |
| Errors | 12 | Session expirée, réseau, serveur |
| Statuses | 8 | En attente, confirmé, checké |
| Actions | 11 | Réessayer, annuler, confirmer |
| **Total** | **80** | |

---

## 3. ⚠️ Problèmes identifiés

### Architecture de localisation

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| L1 | **Pas d'ARB (App Resource Bundle)** : les strings sont dans une classe Dart statique (`AppStrings`), pas dans des fichiers `.arb` — pas de traduction possible sans modifier le code | **Critical** |
| L2 | **Pas de `Intl.message()`** : les strings ne sont pas wrapées dans `Intl.message()` — pas d'extraction automatique pour traduction | **Major** |
| L3 | **Pas de `flutter_localizations`** activé dans `MaterialApp` : le framework Material est en français par défaut, mais pas de `supportedLocales` ou `localizationsDelegates` explicites | **Major** |
| L4 | **Anglais non supporté** : si le téléphone de l'utilisateur est en anglais, l'app affichera du français partout — pas de `Localizations.localeOf(context)` | **Major** |

### Problèmes de contenu

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| L5 | **"N'importe qui" pour sélection staff** : devrait être "Sans préférence" (plus professionnel) | **Minor** |
| L6 | **"RÉCENTS" en CAPS** : dans la search page — caps lock agressif | **Minor** |
| L7 | **"Aucun résultat pour 'X'"** : pourrait être plus humain ("On n'a rien trouvé — essayez un autre terme") | **Minor** |
| L8 | **Format heures 24h vs 12h** : l'app utilise HH:mm (24h) — correct pour le Sénégal mais pas adaptable | **Info** |

### RTL (Right-to-Left)

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| R1 | **Pas de support RTL** : l'architecture (EdgeInsets.only(left), alignements `start` sans `Directionality`) ne supporterait pas l'arabe | **Major** |
| R2 | **Icônes non mirrorées** : `Icons.arrow_back` ne deviendrait pas `Icons.arrow_forward` en RTL | **Minor** |

### Formatage monétaire

```dart
// ✅ Actuel : Format correct
NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA')
// Affiche : "2 500 FCFA"

// ⚠️ Problème : Le symbole FCFA après le montant
// En français, certaines régions placent le symbole avant
// "2 500 FCFA" est correct pour le Sénégal
```

### Strings hardcodées dans les pages

```dart
// ❌ Strings inline dans les widgets (pas via AppStrings)
// Dans booking_detail_page.dart :
child: Text('Signaler un problème'),

// Dans profile_page.dart :
child: Text('Notifications'),
child: Text('Moyens de paiement'),
child: Text('Mes avantages'),
```

**Problème** : ~30-40% des strings UI sont hardcodés directement dans les pages, pas centralisés dans `AppStrings`. Une recherche rapide montre des textes comme "Signaler un problème", "Notifications", "Mes avantages", "Paramètres" qui ne passent pas par `AppStrings`.

---

## 4. Comparaison des patterns de strings

### Centralisé (AppStrings) ✅

```dart
// Dans text_styles ou directement
Text(AppStrings.discoverTab)
Text(AppStrings.searchHint)
Text(AppStrings.favoritesEmpty)
```

### Inline ❌

```dart
// Directement dans le widget — pas réutilisable, pas traduisible
const Text('Mes favoris')
const Text('Notifications')
const Text('Signaler un problème')
Text('Aucun résultat pour "$query"')  // string interpolée inline
```

### Estimation : couverture AppStrings

| Élément | Couverture estimée |
|---|---|
| **Navigation & labels** | ~80% ✅ |
| **Auth** | ~90% ✅ |
| **Booking funnel** | ~70% 🟡 |
| **Discovery** | ~30% ❌ |
| **Profile** | ~40% ❌ |
| **Notifications** | ~20% ❌ |
| **Global** | **~55-60%** 🟡 |

---

## 5. Recommandations

### 🔴 Priorité haute — Architecture i18n

1. **Migrer `AppStrings` vers le système `flutter_localizations` + ARB** :
   - Créer `lib/l10n/app_fr.arb` avec toutes les strings
   - Utiliser `Intl.message()` pour l'extraction automatique
   - Ajouter `supportedLocales` et `localizationsDelegates` dans `MaterialApp`
2. **Activer `flutter_localizations`** dans `MaterialApp` :
   ```dart
   MaterialApp(
     localizationsDelegates: [
       AppLocalizations.delegate,
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
     ],
     supportedLocales: [Locale('fr', 'FR')],
   )
   ```

### 🟡 Priorité moyenne — Contenu

3. **Centraliser toutes les strings UI dans `AppStrings`** : auditer les pages et remplacer les ~40% de strings inline
4. **Ajouter un fallback anglais de base** : `app_en.arb` avec les textes critiques (auth, booking, errors)
5. **Corriger les microcopies** : "N'importe qui" → "Sans préférence", "RÉCENTS" → "Récemment consultés"

### 🟢 Priorité basse — RTL & Format

6. **Préparer l'architecture RTL** : utiliser `Directionality`, `EdgeInsetsDirectional`, `AlignmentDirectional` partout
7. **Ajouter un test de localisation** : vérifier que `NumberFormat.currency` et `DateFormat` s'affichent correctement
8. **Envisager le support Wolof** à long terme (forte demande au Sénégal)

---

## 6. Résumé

La localisation est **correcte pour le marché sénégalais** (français naturel, format XOF, contacts +221) mais **non extensible** :

- 🔴 **Pas d'ARB / `Intl.message()`** — aucune traduction possible sans modifier le code
- 🔴 **~40% des strings inline** dans les pages, pas centralisées
- 🟡 **Anglais non supporté** : si le téléphone est en anglais, tout est en français
- 🟡 **Pas de support RTL** (arabe)
- 🟢 Microcopie globalement bonne, quelques améliorations possibles

Score : **B (78/100)** — excellent français naturel, mais architecture i18n immature pour l'internationalisation.
