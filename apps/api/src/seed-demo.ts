import "dotenv/config";

import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "./generated/prisma/client.js";
import argon2 from "argon2";

const adapter = new PrismaPg({
  connectionString:
    process.env.DATABASE_URL ??
    "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public"
});
const prisma = new PrismaClient({ adapter });

const SALON_PASSWORD = "salon1234";

type SalonDef = {
  name: string;
  category: string;
  description: string;
  city: string;
  address: string;
  latitude: number;
  longitude: number;
  tier: "standard" | "premium";
  owner: { fullName: string; email: string; phone: string };
  services: { name: string; durationMinutes: number; priceXof: number }[];
};

const DEMO_SALONS: SalonDef[] = [
  {
    name: "Dione Signature",
    category: "Coiffure",
    description: "Salon premium coiffure et coloration rapide. Spécialiste balayage et soins kératine.",
    city: "Dakar",
    address: "Mermoz, Dakar",
    latitude: 14.7189,
    longitude: -17.4795,
    tier: "premium",
    owner: { fullName: "Aïda Dione", email: "aida@dionesignature.sn", phone: "+221776667788" },
    services: [
      { name: "Brushing", durationMinutes: 45, priceXof: 12000 },
      { name: "Balayage", durationMinutes: 120, priceXof: 45000 },
      { name: "Soin kératine", durationMinutes: 90, priceXof: 35000 },
      { name: "Coupe & Coiffage", durationMinutes: 60, priceXof: 15000 }
    ]
  },
  {
    name: "Studio Kadija",
    category: "Ongles",
    description: "Studio manucure et pédicure haut de gamme. Pose gel, semi-permanent, nail art.",
    city: "Dakar",
    address: "Plateau, Dakar",
    latitude: 14.6931,
    longitude: -17.4467,
    tier: "standard",
    owner: { fullName: "Kadija Fall", email: "kadija@studiokadija.sn", phone: "+221771234567" },
    services: [
      { name: "Pose gel", durationMinutes: 75, priceXof: 18000 },
      { name: "Semi-permanent", durationMinutes: 60, priceXof: 12000 },
      { name: "Nail art", durationMinutes: 30, priceXof: 8000 }
    ]
  },
  {
    name: "Maison Lumière",
    category: "Spa & Bien-être",
    description: "Institut de beauté bien-être. Hammam, soins corps, massages relaxants.",
    city: "Dakar",
    address: "Almadies, Dakar",
    latitude: 14.7455,
    longitude: -17.5125,
    tier: "premium",
    owner: { fullName: "Binta Traoré", email: "binta@maisonlumiere.sn", phone: "+221772345678" },
    services: [
      { name: "Hammam express", durationMinutes: 60, priceXof: 20000 },
      { name: "Massage relaxant", durationMinutes: 90, priceXof: 30000 }
    ]
  },
  {
    name: "Éclat Visage",
    category: "Soins visage",
    description: "Institut spécialisé soins du visage. Hydratation, anti-âge, peeling professionnel.",
    city: "Saint-Louis",
    address: "Île de Saint-Louis",
    latitude: 16.0179,
    longitude: -16.4896,
    tier: "premium",
    owner: { fullName: "Aïssatou Niane", email: "aissatou@eclatvisage.sn", phone: "+221773456789" },
    services: [
      { name: "Soin hydratant", durationMinutes: 60, priceXof: 22000 },
      { name: "Peeling doux", durationMinutes: 45, priceXof: 18000 }
    ]
  },
  {
    name: "Épil Express",
    category: "Épilation",
    description: "Centre d'épilation rapide. Laser, cire, fils.",
    city: "Dakar",
    address: "Liberté 6, Dakar",
    latitude: 14.6978,
    longitude: -17.4543,
    tier: "standard",
    owner: { fullName: "Seynabou Diallo", email: "seynabou@epilexpress.sn", phone: "+221774567890" },
    services: [
      { name: "Épilation jambes", durationMinutes: 40, priceXof: 10000 }
    ]
  },
  {
    name: "Ndiambour Beauty",
    category: "Coiffure",
    description: "Salon de coiffure afro et lissages. Tresses, tissages, soins capillaires naturels.",
    city: "Pikine",
    address: "Pikine Nord, Dakar",
    latitude: 14.7650,
    longitude: -17.3958,
    tier: "premium",
    owner: { fullName: "Rokhaya Ndiaye", email: "rokhaya@ndiambourbeauty.sn", phone: "+221775110001" },
    services: [
      { name: "Tresses collées", durationMinutes: 120, priceXof: 15000 },
      { name: "Tissage brésilien", durationMinutes: 90, priceXof: 25000 },
      { name: "Soin capillaire", durationMinutes: 60, priceXof: 12000 },
      { name: "Lissage kératine", durationMinutes: 150, priceXof: 40000 }
    ]
  },
  {
    name: "Keur Beauté",
    category: "Esthétique",
    description: "Institut polyvalent épilation, soins visage et maquillage. Proche marché de Thiaroye.",
    city: "Pikine",
    address: "Thiaroye, Pikine",
    latitude: 14.7530,
    longitude: -17.3810,
    tier: "standard",
    owner: { fullName: "Fatou Mbaye", email: "fatou@keurbeaute.sn", phone: "+221776110002" },
    services: [
      { name: "Épilation sourcils", durationMinutes: 20, priceXof: 3000 },
      { name: "Soin visage express", durationMinutes: 45, priceXof: 10000 },
      { name: "Maquillage occasion", durationMinutes: 60, priceXof: 20000 }
    ]
  }
];

async function main() {
  const passwordHash = await argon2.hash(SALON_PASSWORD);

  for (const def of DEMO_SALONS) {
    const owner = await prisma.user.upsert({
      where: { email: def.owner.email },
      update: { passwordHash, role: "salon_owner" },
      create: { fullName: def.owner.fullName, email: def.owner.email, phone: def.owner.phone, passwordHash, role: "salon_owner" }
    });

    const existing = await prisma.salon.findFirst({ where: { name: def.name } });
    const salon = await prisma.salon.upsert({
      where: { id: existing?.id ?? "new-demo" },
      update: { approvalStatus: "approved", isVisibleInMarketplace: true, canReceiveBookings: true },
      create: {
        name: def.name,
        category: def.category,
        description: def.description,
        city: def.city,
        address: def.address,
        latitude: def.latitude,
        longitude: def.longitude,
        approvalStatus: "approved",
        subscriptionTier: def.tier,
        isVisibleInMarketplace: true,
        canReceiveBookings: true,
        staffMembers: { connect: { id: owner.id } }
      }
    });

    await prisma.user.update({
      where: { id: owner.id },
      data: { salonId: salon.id }
    });

    await prisma.employee.upsert({
      where: { salonId_userId: { salonId: salon.id, userId: owner.id } },
      update: {},
      create: { salonId: salon.id, userId: owner.id, displayName: def.owner.fullName }
    });

    await prisma.subscription.upsert({
      where: { salonId: salon.id },
      update: { tier: def.tier, status: "active" },
      create: { salonId: salon.id, tier: def.tier, status: "active" }
    });

    const existingServices = await prisma.service.findMany({ where: { salonId: salon.id } });
    for (const svc of def.services) {
      const exists = existingServices.find(e => e.name === svc.name);
      if (!exists) {
        await prisma.service.create({
          data: { name: svc.name, durationMinutes: svc.durationMinutes, priceXof: svc.priceXof, salonId: salon.id, depositMode: "fixed", depositAmountXof: 200 }
        });
      }
    }

    const existingHours = await prisma.salonHours.findMany({ where: { salonId: salon.id } });
    if (existingHours.length === 0) {
      await prisma.salonHours.createMany({
        data: [1, 2, 3, 4, 5, 6].map(day => ({
          salonId: salon.id, dayOfWeek: day, isOpen: true, opensAt: "09:00", closesAt: "18:00"
        }))
      });
    }

    console.log(`[seed-demo] ✓ ${def.name} (${def.tier})`);
  }

  console.log("[seed-demo] Demo salons seeded.");
}

main()
  .catch((e) => {
    console.error("[seed-demo] ERROR:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
