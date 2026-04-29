# Beauté Avenue

Monorepo produit pour Beauté Avenue, reconstruit comme **modular monolith** au lieu d'une constellation de microservices.

## Surfaces

- `apps/api` : API Fastify + worker + Prisma
- `apps/web-admin` : back-office et site léger Vue 3
- `apps/mobile-client` : application Flutter pour les clientes (seule app mobile — l'espace pro est web uniquement)
- `packages/contracts` : schémas métier et contrat OpenAPI
- `packages/shared-ts` : constantes et helpers TypeScript partagés

## Principes

- une seule base PostgreSQL
- un seul backend métier
- tâches asynchrones dans le même codebase
- paiements derrière des adaptateurs fournisseurs
- SMS optionnel et piloté par le coût
- géolocalisation simple sans PostGIS en v1

## Démarrage

```bash
cp .env.example .env
pnpm install
pnpm db:generate
pnpm dev
```

En développement, l'API essaie PostgreSQL local sur `localhost:5432` jusqu'à `3` fois. Si la connexion échoue et que `NODE_ENV=development`, elle démarre quand même et bascule en mode SQLite local annoncé dans les logs et dans `/health`.

## Commandes utiles

```bash
pnpm dev
pnpm build
pnpm test
pnpm openapi:generate
pnpm docker:up
pnpm docker:down
```

## Notes produit

- Wave est le fournisseur de paiement prioritaire.
- Orange Money est prévu comme deuxième adaptateur.
- Free Money reste hors du MVP.
- Le web public reste volontairement léger. Le cœur de la découverte et de la réservation vit dans les apps mobiles.
