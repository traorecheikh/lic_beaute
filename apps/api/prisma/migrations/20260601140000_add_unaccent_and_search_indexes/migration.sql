CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE OR REPLACE FUNCTION immutable_unaccent(text)
RETURNS text AS $$
  SELECT unaccent($1);
$$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;

CREATE INDEX IF NOT EXISTS salon_fts_idx ON "Salon" USING GIN (
  (
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(name, ''))), 'A') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(category, ''))), 'B') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(description, ''))), 'C') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(neighborhood, '') || ' ' || COALESCE(city, ''))), 'D')
  )
);

CREATE INDEX IF NOT EXISTS salon_name_trgm_idx ON "Salon" USING GIN (
  immutable_unaccent(name) gin_trgm_ops
);

CREATE INDEX IF NOT EXISTS service_fts_idx ON "Service" USING GIN (
  to_tsvector('french', immutable_unaccent(COALESCE(name, '')))
);
