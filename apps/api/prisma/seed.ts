import { PrismaClient, Role, SalonApprovalStatus, SubscriptionTier, SubscriptionStatus, PaymentProvider, PaymentStatus, BlockedSlotScope } from "@prisma/client";
import argon2 from "argon2";
import dotenv from "dotenv";
import path from "node:path";
import { fileURLToPath } from "node:url";

const prisma = new PrismaClient();

const seedDir = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(seedDir, "../../../.env") });

// Set DEV_TEST_PHONE in .env to seed full demo data for your OTP dev account.
const DEV_TEST_PHONE = process.env.DEV_TEST_PHONE ?? null;

async function hash(password: string) {
  return argon2.hash(password);
}

function daysAgo(n: number) {
  return new Date(Date.now() - n * 24 * 60 * 60 * 1000);
}

function daysFromNow(n: number) {
  return new Date(Date.now() + n * 24 * 60 * 60 * 1000);
}

type SeedBenefitTemplate = {
  salonId: string;
  kind: "membership" | "package";
  name: string;
  remainingUses: number;
  daysUntilExpiry: number;
  billingDays: number | null;
};

type SeedVoucherAssignment = {
  voucherId: string;
  expiresAt: Date | null;
  status: "active" | "used";
};

const FIRST_NAMES = ["Aminata", "Fatou", "Rokhaya", "Mariama", "Sokhna", "Ndèye", "Coumba", "Aïssatou", "Khady", "Binta", "Penda", "Astou", "Mame", "Seynabou", "Awa", "Oumy", "Ramata", "Adama", "Fama", "Isseu"];
const LAST_NAMES = ["Sow", "Ba", "Ndiaye", "Diallo", "Mbaye", "Diop", "Sarr", "Camara", "Fall", "Traoré", "Koné", "Niane", "Gueye", "Faye", "Sy", "Kane", "Thiam", "Diagne", "Seck", "Mbacké"];

function getRandomName() {
  return `${FIRST_NAMES[Math.floor(Math.random() * FIRST_NAMES.length)]} ${LAST_NAMES[Math.floor(Math.random() * LAST_NAMES.length)]}`;
}

async function main() {
  console.log("🌱 Seeding database with fully expanded platform data...");
  let devTestUserId: string | null = null;

  // ── Admin ──────────────────────────────────────────────────────────────────
  const adminPassword = await hash("admin1234");
  await prisma.user.upsert({
    where: { email: "admin@beauteavenue.local" },
    update: { passwordHash: adminPassword },
    create: {
      fullName: "Cheikh Platform",
      email: "admin@beauteavenue.local",
      passwordHash: adminPassword,
      role: Role.platform_admin
    }
  });

  // ── Clients (30 profiles) ──────────────────────────────────────────────────
  const clientPassword = await hash("client1234");
  const clients = [];
  for (let i = 0; i < 30; i++) {
    const email = `client${i + 1}@example.sn`;
    const user = await prisma.user.upsert({
      where: { email },
      update: {},
      create: {
        fullName: getRandomName(),
        email,
        phone: `+22177${(1000000 + i).toString().slice(1)}`,
        passwordHash: clientPassword,
        role: Role.client
      }
    });
    clients.push(user);
  }
  console.log(`  ✓ Clients: ${clients.length}`);

  for (const [index, client] of clients.entries()) {
    await prisma.clientProfile.upsert({
      where: { userId: client.id },
      update: {
        city: index % 3 == 0 ? "Dakar" : index % 3 == 1 ? "Pikine" : "Thiès",
        preferredContactChannel: index % 2 == 0 ? "phone" : "whatsapp",
        pushOptIn: true,
        marketingOptIn: index % 4 == 0,
        preferredLanguage: "fr"
      },
      create: {
        userId: client.id,
        city: index % 3 == 0 ? "Dakar" : index % 3 == 1 ? "Pikine" : "Thiès",
        preferredContactChannel: index % 2 == 0 ? "phone" : "whatsapp",
        pushOptIn: true,
        marketingOptIn: index % 4 == 0,
        preferredLanguage: "fr"
      }
    });
  }

  // ── Salons ─────────────────────────────────────────────────────────────────
  const salonPassword = await hash("salon1234");

  const salonsData = [
    {
      salon: {
        name: "Dione Signature",
        category: "Coiffure",
        description: "Salon premium coiffure et coloration rapide. Spécialiste balayage et soins kératine.",
        city: "Dakar",
        address: "Mermoz, Dakar",
        latitude: 14.7189,
        longitude: -17.4795,
        approvalStatus: SalonApprovalStatus.approved,
        subscriptionTier: SubscriptionTier.premium,
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      },
      owner: { fullName: "Aïda Dione", email: "aida@dionesignature.sn", phone: "+221776667788" },
      staffCount: 4,
      services: [
        { name: "Brushing", durationMinutes: 45, priceXof: 12000, depositMode: "fixed", depositAmountXof: 3000 },
        { name: "Balayage", durationMinutes: 120, priceXof: 45000, depositMode: "fixed", depositAmountXof: 10000 },
        { name: "Soin kératine", durationMinutes: 90, priceXof: 35000, depositMode: "percentage", depositPercent: 30 },
        { name: "Coupe & Coiffage", durationMinutes: 60, priceXof: 15000, depositMode: "none" }
      ],
      subscription: { tier: SubscriptionTier.premium, status: SubscriptionStatus.active }
    },
    {
      salon: {
        name: "Studio Kadija",
        category: "Ongles",
        description: "Studio manucure et pédicure haut de gamme. Pose gel, semi-permanent, nail art.",
        city: "Dakar",
        address: "Plateau, Dakar",
        latitude: 14.6931,
        longitude: -17.4467,
        approvalStatus: SalonApprovalStatus.approved,
        subscriptionTier: SubscriptionTier.standard,
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      },
      owner: { fullName: "Kadija Fall", email: "kadija@studiokadija.sn", phone: "+221771234567" },
      staffCount: 3,
      services: [
        { name: "Pose gel", durationMinutes: 75, priceXof: 18000, depositMode: "none" },
        { name: "Semi-permanent", durationMinutes: 60, priceXof: 12000, depositMode: "none" },
        { name: "Nail art", durationMinutes: 30, priceXof: 8000, depositMode: "none" }
      ],
      subscription: { tier: SubscriptionTier.standard, status: SubscriptionStatus.active }
    },
    {
      salon: {
        name: "Maison Lumière",
        category: "Spa & Bien-être",
        description: "Institut de beauté bien-être. Hammam, soins corps, massages relaxants.",
        city: "Dakar",
        address: "Almadies, Dakar",
        latitude: 14.7455,
        longitude: -17.5125,
        approvalStatus: SalonApprovalStatus.approved,
        subscriptionTier: SubscriptionTier.premium,
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      },
      owner: { fullName: "Binta Traoré", email: "binta@maisonlumiere.sn", phone: "+221772345678" },
      staffCount: 5,
      services: [
        { name: "Hammam express", durationMinutes: 60, priceXof: 20000, depositMode: "fixed", depositAmountXof: 5000 },
        { name: "Massage relaxant", durationMinutes: 90, priceXof: 30000, depositMode: "fixed", depositAmountXof: 8000 }
      ],
      subscription: { tier: SubscriptionTier.premium, status: SubscriptionStatus.active, isComplimentary: true }
    },
    {
      salon: {
        name: "Éclat Visage",
        category: "Soins visage",
        description: "Institut spécialisé soins du visage. Hydratation, anti-âge, peeling professionnel.",
        city: "Saint-Louis",
        address: "Île de Saint-Louis",
        latitude: 16.0179,
        longitude: -16.4896,
        approvalStatus: SalonApprovalStatus.approved,
        subscriptionTier: SubscriptionTier.premium,
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      },
      owner: { fullName: "Aïssatou Niane", email: "aissatou@eclatvisage.sn", phone: "+221773456789" },
      staffCount: 2,
      services: [
        { name: "Soin hydratant", durationMinutes: 60, priceXof: 22000, depositMode: "fixed", depositAmountXof: 5000 },
        { name: "Peeling doux", durationMinutes: 45, priceXof: 18000, depositMode: "none" }
      ],
      subscription: { tier: SubscriptionTier.premium, status: SubscriptionStatus.active }
    },
    {
      salon: {
        name: "Épil Express",
        category: "Épilation",
        description: "Centre d'épilation rapide. Laser, cire, fils.",
        city: "Dakar",
        address: "Liberté 6, Dakar",
        latitude: 14.6978,
        longitude: -17.4543,
        approvalStatus: SalonApprovalStatus.approved,
        subscriptionTier: SubscriptionTier.standard,
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      },
      owner: { fullName: "Seynabou Diallo", email: "seynabou@epilexpress.sn", phone: "+221774567890" },
      staffCount: 3,
      services: [
        { name: "Épilation jambes", durationMinutes: 40, priceXof: 10000, depositMode: "none" }
      ],
      subscription: { tier: SubscriptionTier.standard, status: SubscriptionStatus.past_due }
    },
    {
      salon: {
        name: "Ndiambour Beauty",
        category: "Coiffure",
        description: "Salon de coiffure afro et lissages. Tresses, tissages, soins capillaires naturels.",
        city: "Pikine",
        address: "Pikine Nord, Dakar",
        latitude: 14.7650,
        longitude: -17.3958,
        approvalStatus: SalonApprovalStatus.approved,
        subscriptionTier: SubscriptionTier.premium,
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      },
      owner: { fullName: "Rokhaya Ndiaye", email: "rokhaya@ndiambourbeauty.sn", phone: "+221775110001" },
      staffCount: 3,
      services: [
        { name: "Tresses collées", durationMinutes: 120, priceXof: 15000, depositMode: "fixed", depositAmountXof: 4000 },
        { name: "Tissage brésilien", durationMinutes: 90, priceXof: 25000, depositMode: "fixed", depositAmountXof: 6000 },
        { name: "Soin capillaire", durationMinutes: 60, priceXof: 12000, depositMode: "none" },
        { name: "Lissage kératine", durationMinutes: 150, priceXof: 40000, depositMode: "percentage", depositPercent: 30 }
      ],
      subscription: { tier: SubscriptionTier.premium, status: SubscriptionStatus.active }
    },
    {
      salon: {
        name: "Keur Beauté",
        category: "Esthétique",
        description: "Institut polyvalent épilation, soins visage et maquillage. Proche marché de Thiaroye.",
        city: "Pikine",
        address: "Thiaroye, Pikine",
        latitude: 14.7530,
        longitude: -17.3810,
        approvalStatus: SalonApprovalStatus.approved,
        subscriptionTier: SubscriptionTier.standard,
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      },
      owner: { fullName: "Fatou Mbaye", email: "fatou@keurbeaute.sn", phone: "+221776110002" },
      staffCount: 2,
      services: [
        { name: "Épilation sourcils", durationMinutes: 20, priceXof: 3000, depositMode: "none" },
        { name: "Soin visage express", durationMinutes: 45, priceXof: 10000, depositMode: "none" },
        { name: "Maquillage occasion", durationMinutes: 60, priceXof: 20000, depositMode: "fixed", depositAmountXof: 5000 }
      ],
      subscription: { tier: SubscriptionTier.standard, status: SubscriptionStatus.active }
    }
  ];

  const createdSalons = [];

  for (const data of salonsData) {
    const owner = await prisma.user.upsert({
      where: { email: data.owner.email },
      update: { role: Role.salon_owner },
      create: { ...data.owner, passwordHash: salonPassword, role: Role.salon_owner }
    });

    const salon = await prisma.salon.upsert({
      where: { id: (await prisma.salon.findFirst({ where: { name: data.salon.name } }))?.id ?? "new" },
      update: data.salon,
      create: { ...data.salon, staffMembers: { connect: { id: owner.id } } }
    });

    await prisma.user.update({ where: { id: owner.id }, data: { salonId: salon.id } });

    // Employee record for owner
    const ownerEmployee = await prisma.employee.upsert({
      where: { salonId_userId: { salonId: salon.id, userId: owner.id } },
      update: { isActive: true, schedulingEnabled: true },
      create: { salonId: salon.id, userId: owner.id, displayName: owner.fullName }
    });

    const employees = [ownerEmployee];
    for (let i = 0; i < data.staffCount; i++) {
      const staffEmail = `${salon.name.toLowerCase().replace(/ /g, ".")}@staff${i}.sn`;
      const staffUser = await prisma.user.upsert({
        where: { email: staffEmail },
        update: { salonId: salon.id, role: Role.salon_staff },
        create: {
          fullName: getRandomName(),
          email: staffEmail,
          passwordHash: salonPassword,
          role: Role.salon_staff,
          salonId: salon.id
        }
      });
      const emp = await prisma.employee.upsert({
        where: { salonId_userId: { salonId: salon.id, userId: staffUser.id } },
        update: { isActive: true, schedulingEnabled: true },
        create: { salonId: salon.id, userId: staffUser.id, displayName: staffUser.fullName }
      });
      employees.push(emp);
    }

    // Services
    await prisma.service.deleteMany({ where: { salonId: salon.id } });
    const services = [];
    for (const sData of data.services) {
      const svc = await prisma.service.create({ data: { ...sData, salonId: salon.id } });
      services.push(svc);
    }

    // Specialties
    for (const emp of employees) {
      for (const svc of services) {
        if (Math.random() > 0.2) {
          await prisma.employeeSpecialty.upsert({
            where: { employeeId_serviceId: { employeeId: emp.id, serviceId: svc.id } },
            update: {},
            create: { employeeId: emp.id, serviceId: svc.id }
          });
        }
      }
    }

    // Hours
    await prisma.salonHours.deleteMany({ where: { salonId: salon.id } });
    await prisma.salonHours.createMany({
      data: [1, 2, 3, 4, 5, 6].map(day => ({
        salonId: salon.id, dayOfWeek: day, isOpen: true, opensAt: "08:30", closesAt: "19:30"
      }))
    });

    // Sub
    if (data.subscription) {
      await prisma.subscription.upsert({
        where: { salonId: salon.id },
        update: data.subscription,
        create: { ...data.subscription, salonId: salon.id }
      });
    }

    // Gallery photos for premium salons
    if (data.salon.subscriptionTier === SubscriptionTier.premium) {
      await prisma.salonGalleryImage.deleteMany({ where: { salonId: salon.id } });
      const galleryUrls = [
        `https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=800`,
        `https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=800`,
        `https://images.unsplash.com/photo-1580618672591-eb180b1a973f?q=80&w=800`,
        `https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=800`,
        `https://images.unsplash.com/photo-1559599101-f09722fb4948?q=80&w=800`,
        `https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=800`,
      ];
      await prisma.salonGalleryImage.createMany({
        data: galleryUrls.map((url, i) => ({ salonId: salon.id, url, position: i }))
      });
    }

    createdSalons.push({ salon, employees, services, owner });
    console.log(`  ✓ Salon: ${salon.name} (Team: ${employees.length})`);
  }

  for (const [index, client] of clients.entries()) {
    await prisma.clientPaymentMethod.deleteMany({ where: { userId: client.id } });
    await prisma.clientPaymentMethod.create({
      data: {
        userId: client.id,
        provider: PaymentProvider.paytech,
        phoneNumber: client.phone ?? `+221770000${index.toString().padLeft(2, "0")}`,
        label: "Personnel",
        isDefault: true
      }
    });
  }

  // Test credentials: client1@example.sn … client5@example.sn / client1234
  const demoClients = clients.slice(0, 5).filter(Boolean);
  if (demoClients.length > 0) {
    await prisma.clientBenefit.deleteMany({
      where: { userId: { in: demoClients.map((c) => c.id) } }
    });

    const maisonLumiere = createdSalons.find((entry) => entry.salon.name === "Maison Lumière")?.salon;
    const ndiambourBeauty = createdSalons.find((entry) => entry.salon.name === "Ndiambour Beauty")?.salon;
    const dioneSignature = createdSalons.find((entry) => entry.salon.name === "Dione Signature")?.salon;

    const benefitTemplates = [
      maisonLumiere && { salonId: maisonLumiere.id, kind: "membership", name: "Pass Bien-être", remainingUses: 4, daysUntilExpiry: 45, billingDays: 30 },
      ndiambourBeauty && { salonId: ndiambourBeauty.id, kind: "package", name: "Pack Tresses 3 séances", remainingUses: 2, daysUntilExpiry: 60, billingDays: null },
      dioneSignature && { salonId: dioneSignature.id, kind: "membership", name: "Abonnement Éclat", remainingUses: 6, daysUntilExpiry: 90, billingDays: 30 },
      maisonLumiere && { salonId: maisonLumiere.id, kind: "package", name: "Forfait Soin Visage", remainingUses: 3, daysUntilExpiry: 30, billingDays: null },
      ndiambourBeauty && { salonId: ndiambourBeauty.id, kind: "membership", name: "Pass VIP Manucure", remainingUses: 8, daysUntilExpiry: 120, billingDays: 30 },
    ].filter(Boolean) as SeedBenefitTemplate[];

    for (const [idx, client] of demoClients.entries()) {
      const template = benefitTemplates[idx % benefitTemplates.length];
      if (!template) continue;
      await prisma.clientBenefit.create({
        data: {
          userId: client.id,
          salonId: template.salonId,
          kind: template.kind,
          name: template.name,
          status: "active",
          remainingUses: template.remainingUses,
          expiresAt: daysFromNow(template.daysUntilExpiry),
          billingDate: template.billingDays ? daysFromNow(template.billingDays) : null
        }
      });
    }

    await prisma.voucherDefinition.deleteMany({
      where: { code: { in: ["WELCOME10", "SUMMER25", "MAISONVIP"] } }
    });

    const welcomeVoucher = await prisma.voucherDefinition.create({
      data: {
        code: "WELCOME10",
        title: "Réduction de bienvenue",
        description: "Valable sur votre prochaine réservation",
        discountLabel: "-10%",
        isActive: true,
        maxRedemptions: 500
      }
    });

    const summerVoucher = await prisma.voucherDefinition.create({
      data: {
        code: "SUMMER25",
        title: "Fidélité été",
        description: "Réduction fixe sur les soins sélectionnés",
        discountLabel: "2 500 XOF",
        isActive: true,
        expiresAt: daysFromNow(90),
        maxRedemptions: 250
      }
    });

    let maisonVoucher: { id: string; expiresAt: Date | null } | null = null;
    if (maisonLumiere) {
      maisonVoucher = await prisma.voucherDefinition.create({
        data: {
          salonId: maisonLumiere.id,
          code: "MAISONVIP",
          title: "Invité Maison Lumière",
          description: "Accès privilégié aux soins premium",
          discountLabel: "-15%",
          isActive: true,
          expiresAt: daysFromNow(40),
          maxRedemptions: 50
        }
      });
    }

    await prisma.clientVoucherRedemption.deleteMany({
      where: { userId: { in: demoClients.map((c) => c.id) } }
    });

    const voucherAssignments = [
      { voucherId: welcomeVoucher.id, expiresAt: welcomeVoucher.expiresAt, status: "active" as const },
      { voucherId: summerVoucher.id, expiresAt: summerVoucher.expiresAt, status: "active" as const },
      maisonVoucher && { voucherId: maisonVoucher.id, expiresAt: maisonVoucher.expiresAt, status: "active" as const },
      { voucherId: welcomeVoucher.id, expiresAt: welcomeVoucher.expiresAt, status: "used" as const },
      { voucherId: summerVoucher.id, expiresAt: summerVoucher.expiresAt, status: "active" as const },
    ].filter(Boolean) as SeedVoucherAssignment[];

    for (const [idx, client] of demoClients.entries()) {
      const assignment = voucherAssignments[idx % voucherAssignments.length];
      if (!assignment) continue;
      await prisma.clientVoucherRedemption.create({
        data: {
          userId: client.id,
          voucherId: assignment.voucherId,
          status: assignment.status,
          usedAt: assignment.status === "used" ? daysAgo(2) : null,
          expiresAt: assignment.expiresAt
        }
      });
    }

    await prisma.notification.deleteMany({
      where: { userId: { in: demoClients.map((c) => c.id) } }
    });
    for (const client of demoClients) {
      await prisma.notification.createMany({
        data: [
          {
            userId: client.id,
            title: "Rappel de rendez-vous",
            body: "Votre rendez-vous commence demain à 10h chez Maison Lumière.",
            channel: "push"
          },
          {
            userId: client.id,
            title: "Code disponible",
            body: "Votre code WELCOME10 est prêt à être utilisé.",
            channel: "push",
            readAt: daysAgo(1)
          }
        ]
      });
    }
  }

  // ── Dev test account (set DEV_TEST_PHONE in .env) ─────────────────────────
  if (DEV_TEST_PHONE) {
    const maisonLumiere = createdSalons.find((e) => e.salon.name === "Maison Lumière")?.salon;
    const ndiambourBeauty = createdSalons.find((entry) => entry.salon.name === "Ndiambour Beauty")?.salon;
    const dioneSignature = createdSalons.find((entry) => entry.salon.name === "Dione Signature")?.salon;
    let devUser = await prisma.user.findUnique({ where: { phone: DEV_TEST_PHONE } });
    if (!devUser) {
      devUser = await prisma.user.create({
        data: { fullName: "Dev Testeur", phone: DEV_TEST_PHONE, role: "client" }
      });
    }
    await prisma.clientProfile.upsert({
      where: { userId: devUser.id },
      update: { city: "Dakar", pushOptIn: true, marketingOptIn: true, preferredLanguage: "fr" },
      create: { userId: devUser.id, city: "Dakar", pushOptIn: true, marketingOptIn: true, preferredLanguage: "fr", preferredContactChannel: "phone" }
    });
    await prisma.clientBenefit.deleteMany({ where: { userId: devUser.id } });

    const devBenefitTemplates = [
      maisonLumiere && { salonId: maisonLumiere.id, kind: "membership", name: "Pass Bien-être", remainingUses: 4, daysUntilExpiry: 45, billingDays: 30 },
      ndiambourBeauty && { salonId: ndiambourBeauty.id, kind: "package", name: "Pack Tresses 3 séances", remainingUses: 2, daysUntilExpiry: 60, billingDays: null },
      dioneSignature && { salonId: dioneSignature.id, kind: "membership", name: "Abonnement Éclat", remainingUses: 6, daysUntilExpiry: 90, billingDays: 30 },
    ].filter(Boolean) as SeedBenefitTemplate[];

    for (const template of devBenefitTemplates) {
      await prisma.clientBenefit.create({
        data: {
          userId: devUser.id,
          salonId: template.salonId,
          kind: template.kind,
          name: template.name,
          status: "active",
          remainingUses: template.remainingUses,
          expiresAt: daysFromNow(template.daysUntilExpiry),
          billingDate: template.billingDays ? daysFromNow(template.billingDays) : null
        }
      });
    }

    await prisma.clientVoucherRedemption.deleteMany({ where: { userId: devUser.id } });
    const devVouchers = await prisma.voucherDefinition.findMany({
      where: { code: { in: ["WELCOME10", "SUMMER25", "MAISONVIP"] } },
      orderBy: { code: "asc" }
    });
    const devVoucherByCode = new Map(devVouchers.map((voucher) => [voucher.code, voucher]));
    const devVoucherAssignments = [
      devVoucherByCode.get("WELCOME10") && {
        voucherId: devVoucherByCode.get("WELCOME10")!.id,
        expiresAt: devVoucherByCode.get("WELCOME10")!.expiresAt,
        status: "active" as const
      },
      devVoucherByCode.get("SUMMER25") && {
        voucherId: devVoucherByCode.get("SUMMER25")!.id,
        expiresAt: devVoucherByCode.get("SUMMER25")!.expiresAt,
        status: "active" as const
      },
      devVoucherByCode.get("MAISONVIP") && {
        voucherId: devVoucherByCode.get("MAISONVIP")!.id,
        expiresAt: devVoucherByCode.get("MAISONVIP")!.expiresAt,
        status: "active" as const
      }
    ].filter(Boolean) as SeedVoucherAssignment[];

    for (const assignment of devVoucherAssignments) {
      await prisma.clientVoucherRedemption.upsert({
        where: { userId_voucherId: { userId: devUser.id, voucherId: assignment.voucherId } },
        update: {},
        create: {
          userId: devUser.id,
          voucherId: assignment.voucherId,
          status: assignment.status,
          expiresAt: assignment.expiresAt
        }
      });
    }
    devTestUserId = devUser.id;
    console.log(`  ✓ Dev test account seeded for ${DEV_TEST_PHONE}`);
  }

  // Bookings & Activity
  console.log("  ⌛ Generating deep activity (bookings, reviews, blocks)...");
  for (const entry of createdSalons) {
    const { salon, employees, services, owner } = entry;
    
    // Cleanup existing to avoid clutter on repeat runs
    await prisma.booking.deleteMany({ where: { salonId: salon.id } });
    await prisma.blockedSlot.deleteMany({ where: { salonId: salon.id } });

    // Historical
    for (let d = 45; d >= 1; d--) {
      const count = Math.floor(Math.random() * 4) + 1;
      for (let i = 0; i < count; i++) {
        const client = clients[Math.floor(Math.random() * clients.length)];
        const employee = employees[Math.floor(Math.random() * employees.length)];
        const service = services[Math.floor(Math.random() * services.length)];
        const startsAt = new Date(daysAgo(d).setHours(9 + Math.floor(Math.random() * 8), 0, 0, 0));
        const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);

        const booking = await prisma.booking.create({
          data: {
            clientId: client.id,
            salonId: salon.id,
            serviceId: service.id,
            employeeId: employee.id,
            startsAt,
            endsAt,
            status: "completed",
            depositAmountXof: service.depositAmountXof ?? 0,
            depositPaymentStatus: "succeeded",
            paymentProvider: PaymentProvider.paytech,
            createdAt: daysAgo(d + 1)
          }
        });

        if (Math.random() > 0.6) {
          await prisma.review.upsert({
            where: { bookingId: booking.id },
            update: {},
            create: {
              bookingId: booking.id,
              salonId: salon.id,
              clientId: client.id,
              rating: 4 + Math.floor(Math.random() * 2),
              comment: "Excellent service.",
              createdAt: new Date(startsAt.getTime() + 2 * 60 * 60 * 1000)
            }
          });
        }
      }

      // Breaks
      for (const emp of employees) {
        await prisma.blockedSlot.create({
          data: {
            salonId: salon.id,
            employeeId: emp.id,
            startsAt: new Date(daysAgo(d).setHours(13, 0, 0, 0)),
            endsAt: new Date(daysAgo(d).setHours(14, 0, 0, 0)),
            reason: "Pause",
            scope: BlockedSlotScope.employee,
            createdByUserId: owner.id
          }
        });
      }
    }

    // Future
    for (let d = 0; d < 14; d++) {
      const count = Math.floor(Math.random() * 3);
      for (let i = 0; i < count; i++) {
        const client = clients[Math.floor(Math.random() * clients.length)];
        const employee = employees[Math.floor(Math.random() * employees.length)];
        const service = services[Math.floor(Math.random() * services.length)];
        const startsAt = new Date(daysFromNow(d).setHours(10 + Math.floor(Math.random() * 6), 0, 0, 0));
        const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);

        await prisma.booking.create({
          data: {
            clientId: client.id,
            salonId: salon.id,
            serviceId: service.id,
            employeeId: employee.id,
            startsAt,
            endsAt,
            status: "confirmed",
            depositAmountXof: service.depositAmountXof ?? 0,
            depositPaymentStatus: "succeeded",
            paymentProvider: PaymentProvider.paytech
          }
        });
      }
    }
  }

  if (devTestUserId) {
    await prisma.booking.deleteMany({
      where: {
        clientId: devTestUserId,
        source: "dev_seed",
      }
    });

    const devBookingTargets = [
      {
        salonName: "Maison Lumière",
        serviceName: "Massage relaxant",
        startsAt: new Date(daysAgo(7).setHours(11, 0, 0, 0)),
        status: "completed" as const,
      },
      {
        salonName: "Dione Signature",
        serviceName: "Brushing",
        startsAt: new Date(daysFromNow(1).setHours(10, 0, 0, 0)),
        status: "confirmed" as const,
      },
      {
        salonName: "Ndiambour Beauty",
        serviceName: "Soin capillaire",
        startsAt: new Date(daysFromNow(5).setHours(15, 0, 0, 0)),
        status: "confirmed" as const,
      },
    ];

    for (const target of devBookingTargets) {
      const salonEntry = createdSalons.find((entry) => entry.salon.name === target.salonName);
      const service = salonEntry?.services.find((item) => item.name === target.serviceName);
      const employee = salonEntry?.employees[0] ?? null;

      if (!salonEntry || !service) continue;

      const endsAt = new Date(target.startsAt.getTime() + service.durationMinutes * 60 * 1000);

      await prisma.booking.create({
        data: {
          clientId: devTestUserId,
          salonId: salonEntry.salon.id,
          serviceId: service.id,
          employeeId: employee?.id ?? null,
          startsAt: target.startsAt,
          endsAt,
          status: target.status,
          source: "dev_seed",
          depositAmountXof: service.depositAmountXof ?? 0,
          depositPaymentStatus: "succeeded",
          paymentProvider: PaymentProvider.paytech,
          createdAt: target.status === "completed" ? daysAgo(8) : new Date(),
        }
      });
    }
  }

  // ── Post-seed: average ratings + prestige scores ──────────────────────────
  for (const { salon } of createdSalons) {
    const reviews = await prisma.review.findMany({ where: { salonId: salon.id }, select: { rating: true } });
    const averageRating = reviews.length > 0
      ? reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length
      : 0;

    await prisma.salon.update({ where: { id: salon.id }, data: { averageRating } });

    const fresh = await prisma.salon.findUniqueOrThrow({
      where: { id: salon.id },
      select: { subscriptionTier: true, canReceiveBookings: true, _count: { select: { reviews: true, gallery: true } } }
    });

    const THRESHOLD = 0.3;
    const ratingScore = (averageRating * Math.log(fresh._count.reviews + 1)) / 15;
    const availScore = fresh.canReceiveBookings ? 1 : 0;
    const photoScore = Math.min(fresh._count.gallery, 10) / 10;
    const premiumBonus = fresh.subscriptionTier === "premium" ? 1 : 0;
    const prestigeScore = 0.45 * ratingScore + 0.25 * availScore + 0.15 * photoScore + 0.15 * premiumBonus;

    await prisma.salon.update({
      where: { id: salon.id },
      data: {
        prestigeScore: Math.round(prestigeScore * 1000) / 1000,
        isPrestige: fresh.subscriptionTier === "premium" && prestigeScore >= THRESHOLD
      }
    });
  }
  console.log("  ✓ Prestige scores computed");

  // ── Platform Settings ──────────────────────────────────────────────────────
  const platformSettings = [
    { group: "pricing", key: "commission_rate_percent", value: "5", description: "Commission" },
    { group: "pricing", key: "subscription_standard_price_xof", value: "15000", description: "Standard Price" },
    { group: "pricing", key: "subscription_premium_price_xof", value: "25000", description: "Premium Price" },
  ];
  for (const s of platformSettings) {
    await prisma.platformSetting.upsert({ where: { key: s.key }, update: s, create: s });
  }

  const salonCategories = [
    { name: "Coiffure", slug: "coiffure" },
    { name: "Ongles", slug: "ongles" },
    { name: "Spa & Bien-être", slug: "spa" },
    { name: "Esthétique", slug: "esthetique" },
    { name: "Maquillage", slug: "maquillage" },
  ];
  for (const c of salonCategories) {
    await prisma.platformSalonCategory.upsert({ where: { slug: c.slug }, update: c, create: { ...c, enabled: true } });
  }

  // ── Test fixtures — predictable IDs ────────────────────────────────────────
  // Avoid pins that conflict with existing data or just check existence
  const maisonLumiere = await prisma.salon.findFirst({ where: { name: "Maison Lumière" } });
  if (maisonLumiere) {
    const existing = await prisma.salon.findUnique({ where: { id: "salon-maison-kinka" } });
    if (!existing) {
       await prisma.$executeRaw`UPDATE "Salon" SET id = 'salon-maison-kinka' WHERE id = ${maisonLumiere.id}`;
    }
  }
  
  console.log("\n✅ Fully expanded platform seed complete.\n");
}

main().catch(e => { console.error(e); process.exit(1); }).finally(() => prisma.$disconnect());
