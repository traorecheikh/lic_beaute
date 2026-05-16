CREATE TABLE "client_addresses" (
    "id"         TEXT NOT NULL,
    "userId"     TEXT NOT NULL,
    "label"      TEXT NOT NULL,
    "street"     TEXT,
    "city"       TEXT,
    "isDefault"  BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "client_addresses_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "client_addresses_userId_label_key" ON "client_addresses"("userId", "label");

ALTER TABLE "client_addresses"
    ADD CONSTRAINT "client_addresses_userId_fkey"
    FOREIGN KEY ("userId") REFERENCES "User"("id")
    ON DELETE CASCADE ON UPDATE CASCADE;
