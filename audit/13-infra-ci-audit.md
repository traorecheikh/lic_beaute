# Audit Infrastructure & CI/CD — Beauté Avenue

> Généré le 17 juin 2026

## Score global : **B+ (82/100)** 🟢

---

## 1. Infrastructure Docker

### Topologie

```
┌─────────────────────────────────────────────────────┐
│  Production (178.105.224.117 via Coolify)            │
│                                                       │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐        │
│  │  API     │    │  Worker  │    │  Web     │        │
│  │ :3000    │    │  (jobs)  │    │  :8080   │        │
│  └──────────┘    └──────────┘    └──────────┘        │
│       │                │                              │
│       └────────┬───────┘                              │
│                ▼                                      │
│  ┌──────────────────┐    ┌──────────────────┐        │
│  │  PostgreSQL 16   │    │  Redis 7         │        │
│  │  :5432           │    │  :6379           │        │
│  └──────────────────┘    └──────────────────┘        │
└─────────────────────────────────────────────────────┘
```

### ✅ Points forts
- **Images légères** : Alpine pour tous les services (Postgres, Redis, Nginx, API)
- **Healthchecks** : `pg_isready`, `redis-cli ping` sur tous les services
- **Volumes persistants** : `postgres_data`, `redis_data` nommés
- **Redeploy automatique** : Coolify déclenché via webhook à chaque push sur `main`
- **Nginx serveur statique** : configuration SPA avec `try_files`, cache long `immutable` pour assets hashés
- **Multi-stage Dockerfile** : `base → manifests → deps → build → runner` — 5 stages, cache efficace
- **Non-root** : Nginx configuré avec `USER nginx`

### ⚠️ Problèmes

| # | Problème | Sévérité |
|---|---|---|
| I1 | **Redis `noeviction`** : la politique `noeviction` bloque les écritures quand la mémoire est pleine — risque de panne applicative | **Major** |
| I2 | **Postgres `latest` en prod** : `docker-compose.prod.yml` utilise `postgres:latest` — changeant et non reproductible | **Major** |
| I3 | **Prod compose = duplication massive** : API et Worker ont 30+ lignes d'env vars en commun, non factorisées | **Major** |
| I4 | **Pas de `:${TAG}` sur les builds** : `docker-compose.prod.yml` build api + worker sans tag — versioning implicite | **Minor** |
| I5 | **Pas de réseau dédié** : utilisation du réseau par défaut, pas de segmentation entre services | **Minor** |
| I6 | **Pas de backup DB automatisé** : pas de cron/sidecar pour dumps PostgreSQL | **Major** |
| I7 | **Pas de `.env.prod` template** : les vars d'env sont passées directement dans `docker-compose.prod.yml` | **Minor** |
| I8 | **Intech vars résiduelles** : `INTECH_API_KEY`, `INTECH_API_SECRET` encore présentes dans le compose bien que R2/Intech aient été retirées | **Minor** |

### Recommandations infra
1. Passer Redis à `allkeys-lru` au lieu de `noeviction`
2. Piner la version Postgres : `postgres:16-alpine` au lieu de `postgres:latest`
3. Utiliser des `&env-common` YAML anchors pour factoriser les vars API + Worker
4. Ajouter un sidecar Postgres pour backups automatisés (pg_dump + upload S3)
5. Nettoyer les vars résiduelles `INTECH_*`

---

## 2. Nginx

### Configuration SPA (`spa.conf`)

```
listen: 8080
root: /usr/share/nginx/html
index: index.html

✅ gzip on
✅ gzip_static on (pre-compressed)
✅ try_files $uri $uri/ /index.html (SPA fallback)
✅ Cache 1 an + public, immutable pour .js/.css/.png/.jpg/.svg/.woff2
```

**Note :** Le `/api` n'est pas proxy-passé via Nginx — l'API est directement sur `:3000`. C'est correct avec le setup actuel (Coolify gère le reverse proxy).

---

## 3. CI/CD (GitHub Actions)

### Workflow Docker (`docker.yml`)

| Étape | Détail |
|---|---|
| **Trigger** | Push sur `main` + paths filtrés (api, web, packages, etc.) |
| **Registry** | GHCR (`ghcr.io/beauteavenue`) |
| **Tags** | `sha-XXXXX` + `latest` sur `main` |
| **Cache** | GitHub Actions cache (`type=gha`, mode=max) |
| **Dockerfile** | `apps/api/Dockerfile` — build l'image API (utilisée pour API + Worker) |
| **Post-deploy** | Webhook GET vers Coolify avec `COOLIFY_TOKEN` secret |

### Problèmes

| # | Problème | Sévérité |
|---|---|---|
| C1 | **Seulement l'image API buildée** : la web app (Vue.js) n'est pas buildée/pushée via CI — déploiement manuel Coolify | **Major** |
| C2 | **COOLIFY_TOKEN en secret** : exposé dans l'URL de déclenchement GET — pourrait être loggé | **Minor** |
| C3 | **Pas de tests dans le CI** : `pnpm test` / `vitest run` ne sont pas lancés avant le build | **Major** |
| C4 | **Pas de lint/typecheck** : `vue-tsc --noEmit` et `tsc --noEmit` non exécutés | **Major** |
| C5 | **Pas de matrix/tag version** : pas de tagging sémantique (v1.2.3) | **Minor** |
| C6 | **Workflow_dispatch uniquement** : pas de déclenchement sur PR | **Minor** |

### Recommandations CI
1. Ajouter un job `test` avant `build-and-push` qui lance `pnpm install --frozen-lockfile && pnpm test`
2. Ajouter un job `lint` avec `vue-tsc --noEmit` et `tsc --noEmit` pour chaque package
3. Séparer les builds API et Web en deux jobs parallèles
4. Envisager de builder l'image Web également dans le CI
5. Éviter de passer le token dans l'URL GET — utiliser soit un POST, soit un webhook sécurisé

---

## 4. Scripts

### `generate-mobile-client.sh`
✅ Génère le client Dart OpenAPI depuis le spec — propre, bien commenté
⚠️ Utilise `@openapitools/openapi-generator-cli` global via `npx` — devrait être dans `devDependencies`
⚠️ `--skip-validate-spec` — désactive la validation du spec, pourrait cacher des erreurs

### `qa/live-api-smoke.sh`
✅ Test de bout en bout complet : health → admin login → client register/login → register pro → reject workflow → vérification finale
✅ URLs encodées proprement, IDs extraits via `node -e`
✅ Variables `RUN_ID` pour éviter les collisions sur les emails
⚠️ Ne vérifie pas les réponses API intermédiaires (seulement le statut final)
⚠️ Pas de nettoyage des ressources créées

### Recommandations scripts
1. Ajouter `openapi-generator-cli` comme dépendance du workspace
2. Ajouter des `assert` sur les status HTTP intermédiaires dans le smoke test
3. Ajouter un cleanup des ressources à la fin du smoke test

---

## 5. Docker Compose Dev

| Service | Image | Ports | Notes |
|---|---|---|---|
| postgres | `16-alpine` | 5434:5432 | Healthcheck 5s |
| redis | `7-alpine` | 6379:6379 | AOF + 128mb max, noeviction |

✅ Simple, efficace pour le développement
✅ Healthchecks présents
✅ Volumes nommés pour persistance

---

## Résumé

### 🔴 Priorités Infrastructure
1. **Piner Postgres** (`postgres:16-alpine` au lieu de `latest`)
2. **Changer Redis à `allkeys-lru`** (évite les pannes mémoire)
3. **Ajouter des backups DB automatisés**
4. **Ajouter lint + test au CI** avant build

### 🟡 Améliorations
5. Factoriser les vars d'env dupliquées dans le compose prod
6. Nettoyer `INTECH_*` vars résiduelles
7. Builder l'image web dans le CI
8. Améliorer le smoke test avec vérifications intermédiaires
