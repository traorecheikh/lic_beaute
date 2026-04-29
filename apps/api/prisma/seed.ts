import { PrismaClient } from "@prisma/client";
import argon2 from "argon2";

const prisma = new PrismaClient();

async function hash(password: string) {
  return argon2.hash(password);
}

function daysAgo(n: number) {
  return new Date(Date.now() - n * 24 * 60 * 60 * 1000);
}

function daysFromNow(n: number) {
  return new Date(Date.now() + n * 24 * 60 * 60 * 1000);
}

function hoursAgo(n: number) {
  return new Date(Date.now() - n * 60 * 60 * 1000);
}

async function main() {
  console.log("🌱 Seeding database...");

  // ── Admin ──────────────────────────────────────────────────────────────────
  const adminPassword = await hash("admin1234");
  const admin = await prisma.user.upsert({
    where: { email: "admin@beauteavenue.local" },
    update: { passwordHash: adminPassword },
    create: {
      fullName: "Cheikh Platform",
      email: "admin@beauteavenue.local",
      passwordHash: adminPassword,
      role: "platform_admin"
    }
  });
  console.log(`  ✓ Admin: ${admin.email}`);

  // ── Clients (8 varied profiles) ────────────────────────────────────────────
  const clientPassword = await hash("client1234");
  const clients = await Promise.all(
    [
      { fullName: "Aminata Sow",      email: "aminata@example.sn",   phone: "+221770001111" },
      { fullName: "Fatou Ba",         email: "fatou@example.sn",     phone: "+221770002222" },
      { fullName: "Rokhaya Ndiaye",   email: "rokhaya@example.sn",   phone: "+221770003333" },
      { fullName: "Mariama Diallo",   email: "mariama@example.sn",   phone: "+221770004444" },
      { fullName: "Sokhna Mbaye",     email: "sokhna@example.sn",    phone: "+221770005555" },
      { fullName: "Ndèye Diop",       email: "ndeye@example.sn",     phone: "+221770006666" },
      { fullName: "Coumba Sarr",      email: "coumba@example.sn",    phone: "+221770007777" },
      { fullName: "Aïssatou Camara",  email: "aissatou@example.sn",  phone: "+221770008888" }
    ].map((c) =>
      prisma.user.upsert({
        where: { email: c.email },
        update: {},
        create: { ...c, passwordHash: clientPassword, role: "client" }
      })
    )
  );
  console.log(`  ✓ Clients: ${clients.length}`);

  // ── Salons (10 salons across all categories and cities) ────────────────────
  const salonPassword = await hash("salon1234");

  const salonsData = [
    // 0 ── APPROVED PREMIUM ──────────────────────────────────────────────────
    {
      salon: {
        name: "Dione Signature",
        category: "Coiffure",
        description: "Salon premium coiffure et coloration rapide. Spécialiste balayage et soins kératine.",
        city: "Dakar",
        address: "Mermoz, Dakar",
        approvalStatus: "approved" as const,
        subscriptionTier: "premium" as const,
        subscriptionIntentTier: "premium" as const,
        latestAdminNote: "Salon validé et en ligne.",
        submittedAt: new Date("2026-03-10T10:00:00Z")
      },
      owner: { fullName: "Aïda Dione", email: "aida@dionesignature.sn", phone: "+221776667788" },
      staff: [],
      services: [
        { name: "Brushing", durationMinutes: 45, priceXof: 12000, depositMode: "fixed", depositAmountXof: 3000 },
        { name: "Balayage", durationMinutes: 120, priceXof: 45000, depositMode: "fixed", depositAmountXof: 10000 },
        { name: "Soin kératine", durationMinutes: 90, priceXof: 35000, depositMode: "percentage", depositPercent: 30 }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "received" },
        { label: "Coordonnées de versement (RIB / Wave)", status: "received" }
      ],
      gallery: [
        "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800",
        "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800",
        "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=800"
      ],
      subscription: {
        tier: "premium" as const,
        status: "active" as const,
        billingProvider: "wave" as const,
        autoRenew: true,
        isComplimentary: false,
        startedAt: new Date("2026-03-15T00:00:00Z"),
        renewedAt: new Date("2026-04-15T00:00:00Z"),
        expiresAt: new Date("2026-06-15T00:00:00Z")
      }
    },
    // 1 ── APPROVED STANDARD ──────────────────────────────────────────────────
    {
      salon: {
        name: "Studio Kadija",
        category: "Ongles",
        description: "Studio manucure et pédicure haut de gamme. Pose gel, semi-permanent, nail art.",
        city: "Dakar",
        address: "Plateau, Dakar",
        approvalStatus: "approved" as const,
        subscriptionTier: "standard" as const,
        subscriptionIntentTier: "standard" as const,
        latestAdminNote: "Approuvé. Standard actif.",
        submittedAt: new Date("2026-03-20T09:00:00Z")
      },
      owner: { fullName: "Kadija Fall", email: "kadija@studiokadija.sn", phone: "+221771234567" },
      staff: [
        { fullName: "Rouba Diallo", email: "rouba@studiokadija.sn", phone: "+221771234568" }
      ],
      services: [
        { name: "Pose gel", durationMinutes: 75, priceXof: 18000, depositMode: "none" },
        { name: "Semi-permanent", durationMinutes: 60, priceXof: 12000, depositMode: "none" },
        { name: "Nail art", durationMinutes: 30, priceXof: 8000, depositMode: "none" }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "received" },
        { label: "Coordonnées de versement (RIB / Wave)", status: "received" }
      ],
      gallery: [
        "https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800",
        "https://images.unsplash.com/photo-1604654894610-df63bc536372?w=800"
      ],
      subscription: {
        tier: "standard" as const,
        status: "active" as const,
        billingProvider: null,
        autoRenew: false,
        isComplimentary: false,
        startedAt: new Date("2026-03-25T00:00:00Z"),
        renewedAt: null,
        expiresAt: null
      }
    },
    // 2 ── APPROVED COMPLIMENTARY PREMIUM ─────────────────────────────────────
    {
      salon: {
        name: "Maison Lumière",
        category: "Spa & Bien-être",
        description: "Institut de beauté bien-être. Hammam, soins corps, massages relaxants.",
        city: "Dakar",
        address: "Almadies, Dakar",
        approvalStatus: "approved" as const,
        subscriptionTier: "premium" as const,
        subscriptionIntentTier: "premium" as const,
        latestAdminNote: "Premium offert suite à partenariat presse.",
        submittedAt: new Date("2026-04-01T08:00:00Z")
      },
      owner: { fullName: "Binta Traoré", email: "binta@maisonlumiere.sn", phone: "+221772345678" },
      staff: [
        { fullName: "Marième Koné", email: "marieme@maisonlumiere.sn", phone: "+221772345679" }
      ],
      services: [
        { name: "Hammam express", durationMinutes: 60, priceXof: 20000, depositMode: "fixed", depositAmountXof: 5000 },
        { name: "Massage relaxant", durationMinutes: 90, priceXof: 30000, depositMode: "fixed", depositAmountXof: 8000 },
        { name: "Gommage corps", durationMinutes: 45, priceXof: 15000, depositMode: "none" }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "received" },
        { label: "Coordonnées de versement (RIB / Wave)", status: "received" }
      ],
      gallery: [
        "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800",
        "https://images.unsplash.com/photo-1519823551278-64ac92734fb1?w=800"
      ],
      subscription: {
        tier: "premium" as const,
        status: "active" as const,
        billingProvider: null,
        autoRenew: false,
        isComplimentary: true,
        startedAt: new Date("2026-04-05T00:00:00Z"),
        renewedAt: null,
        expiresAt: new Date("2026-10-05T00:00:00Z")
      }
    },
    // 3 ── APPROVED PREMIUM - Saint-Louis ─────────────────────────────────────
    {
      salon: {
        name: "Éclat Visage",
        category: "Soins visage",
        description: "Institut spécialisé soins du visage. Hydratation, anti-âge, peeling professionnel.",
        city: "Saint-Louis",
        address: "Île de Saint-Louis",
        approvalStatus: "approved" as const,
        subscriptionTier: "premium" as const,
        subscriptionIntentTier: "premium" as const,
        latestAdminNote: "Dossier complet, approuvé en 48h.",
        submittedAt: new Date("2026-02-15T11:00:00Z")
      },
      owner: { fullName: "Aïssatou Niane", email: "aissatou@eclatvisage.sn", phone: "+221773456789" },
      staff: [],
      services: [
        { name: "Soin hydratant", durationMinutes: 60, priceXof: 22000, depositMode: "fixed", depositAmountXof: 5000 },
        { name: "Peeling doux", durationMinutes: 45, priceXof: 18000, depositMode: "none" },
        { name: "Masque anti-âge", durationMinutes: 75, priceXof: 28000, depositMode: "fixed", depositAmountXof: 7000 }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "received" },
        { label: "Coordonnées de versement (RIB / Wave)", status: "received" },
        { label: "Extrait RCCM", status: "received" }
      ],
      gallery: [
        "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800",
        "https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=800"
      ],
      subscription: {
        tier: "premium" as const,
        status: "active" as const,
        billingProvider: "wave" as const,
        autoRenew: true,
        isComplimentary: false,
        startedAt: new Date("2026-02-20T00:00:00Z"),
        renewedAt: new Date("2026-04-20T00:00:00Z"),
        expiresAt: new Date("2026-06-20T00:00:00Z")
      }
    },
    // 4 ── APPROVED STANDARD PAST_DUE - Épilation - Dakar ────────────────────
    {
      salon: {
        name: "Épil Express",
        category: "Épilation",
        description: "Centre d'épilation rapide. Laser, cire, fils. Sans rendez-vous bienvenu.",
        city: "Dakar",
        address: "Liberté 6, Dakar",
        approvalStatus: "approved" as const,
        subscriptionTier: "standard" as const,
        subscriptionIntentTier: "standard" as const,
        latestAdminNote: "Approuvé. Renouvellement en attente.",
        submittedAt: new Date("2026-01-12T09:00:00Z")
      },
      owner: { fullName: "Seynabou Diallo", email: "seynabou@epilexpress.sn", phone: "+221774567890" },
      staff: [],
      services: [
        { name: "Épilation jambes complètes", durationMinutes: 40, priceXof: 10000, depositMode: "none" },
        { name: "Épilation aisselles", durationMinutes: 15, priceXof: 4000, depositMode: "none" },
        { name: "Épilation sourcils", durationMinutes: 10, priceXof: 2500, depositMode: "none" }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "received" },
        { label: "Coordonnées de versement (RIB / Wave)", status: "received" }
      ],
      gallery: [],
      subscription: {
        tier: "standard" as const,
        status: "past_due" as const,
        billingProvider: "orange_money" as const,
        autoRenew: true,
        isComplimentary: false,
        startedAt: new Date("2026-01-20T00:00:00Z"),
        renewedAt: null,
        expiresAt: new Date("2026-04-20T00:00:00Z")
      }
    },
    // 5 ── APPROVED STANDARD - Maquillage - Dakar ─────────────────────────────
    {
      salon: {
        name: "Dya Beauty Studio",
        category: "Maquillage",
        description: "Studio maquillage professionnel. Mariages, événements, shooting photo.",
        city: "Dakar",
        address: "Sacré-Cœur 3, Dakar",
        approvalStatus: "approved" as const,
        subscriptionTier: "standard" as const,
        subscriptionIntentTier: "premium" as const,
        latestAdminNote: "Approuvé standard. Souhaite upgrade premium.",
        submittedAt: new Date("2026-03-05T13:00:00Z")
      },
      owner: { fullName: "Dya Sarr", email: "dya@dyabeauty.sn", phone: "+221775678901" },
      staff: [],
      services: [
        { name: "Maquillage mariée", durationMinutes: 120, priceXof: 60000, depositMode: "fixed", depositAmountXof: 15000 },
        { name: "Maquillage soirée", durationMinutes: 60, priceXof: 25000, depositMode: "fixed", depositAmountXof: 5000 },
        { name: "Maquillage naturel", durationMinutes: 45, priceXof: 15000, depositMode: "none" }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "received" },
        { label: "Coordonnées de versement (RIB / Wave)", status: "received" }
      ],
      gallery: [
        "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=800"
      ],
      subscription: {
        tier: "standard" as const,
        status: "active" as const,
        billingProvider: "wave" as const,
        autoRenew: true,
        isComplimentary: false,
        startedAt: new Date("2026-03-10T00:00:00Z"),
        renewedAt: null,
        expiresAt: null
      }
    },
    // 6 ── PENDING REVIEW - Spa - Thiès ───────────────────────────────────────
    {
      salon: {
        name: "Hammam Oasis",
        category: "Spa & Bien-être",
        description: "Hammam traditionnel et massages thérapeutiques. Cadre zen au cœur de Thiès.",
        city: "Thiès",
        address: "Thiès Centre",
        approvalStatus: "pending_review" as const,
        subscriptionTier: "standard" as const,
        subscriptionIntentTier: "premium" as const,
        latestAdminNote: null,
        submittedAt: new Date("2026-04-25T10:00:00Z")
      },
      owner: { fullName: "Ibou Ndiaye", email: "ibou@hammamoasis.sn", phone: "+221776789012" },
      staff: [],
      services: [
        { name: "Hammam 45min", durationMinutes: 45, priceXof: 12000, depositMode: "none" },
        { name: "Massage suédois", durationMinutes: 60, priceXof: 20000, depositMode: "fixed", depositAmountXof: 5000 }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "missing", note: "En attente de transmission." },
        { label: "Coordonnées de versement (RIB / Wave)", status: "missing", note: "RIB ou numéro marchand requis." }
      ],
      gallery: [],
      subscription: null
    },
    // 7 ── PENDING REVIEW - Massage - Mbour ───────────────────────────────────
    {
      salon: {
        name: "Maison Kinka",
        category: "Spa & Bien-être",
        description: "Salon axé soins visage, spa express et rituels premium.",
        city: "Dakar",
        address: "Route des Almadies, Dakar",
        approvalStatus: "pending_review" as const,
        subscriptionTier: "standard" as const,
        subscriptionIntentTier: "premium" as const,
        latestAdminNote: null,
        submittedAt: new Date("2026-04-24T09:30:00Z")
      },
      owner: { fullName: "Mame Diop", email: "mame@maisonkinka.sn", phone: "+221771112233" },
      staff: [],
      services: [
        { name: "Soin visage", durationMinutes: 60, priceXof: 25000, depositMode: "fixed", depositAmountXof: 5000 },
        { name: "Massage express", durationMinutes: 30, priceXof: 15000, depositMode: "none" }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "missing", note: "Document demandé le 24 avril." },
        { label: "Coordonnées de versement (RIB / Wave)", status: "missing", note: "RIB ou numéro marchand requis." }
      ],
      gallery: [],
      subscription: null
    },
    // 8 ── NEEDS INFO - Ongles ─────────────────────────────────────────────────
    {
      salon: {
        name: "Atelier Nafi",
        category: "Ongles",
        description: "Studio manucure avec demande forte sur forfaits mariage.",
        city: "Dakar",
        address: "Ngor, Dakar",
        approvalStatus: "needs_info" as const,
        subscriptionTier: "standard" as const,
        subscriptionIntentTier: "standard" as const,
        latestAdminNote: "Document flou — nouvelle version requise.",
        submittedAt: new Date("2026-04-22T14:00:00Z")
      },
      owner: { fullName: "Nafissatou Faye", email: "nafi@ateliernafi.sn", phone: "+221772224455" },
      staff: [],
      services: [
        { name: "Pose gel", durationMinutes: 75, priceXof: 18000, depositMode: "none" },
        { name: "Nail art mariage", durationMinutes: 90, priceXof: 25000, depositMode: "fixed", depositAmountXof: 6000 }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "invalid", note: "Document flou ou illisible." }
      ],
      gallery: ["https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800"],
      subscription: null
    },
    // 9 ── REJECTED - Coiffure - Thiès ────────────────────────────────────────
    {
      salon: {
        name: "Beauty Flash",
        category: "Coiffure",
        description: "Salon mobile sans adresse fixe.",
        city: "Thiès",
        address: "Thiès Centre",
        approvalStatus: "rejected" as const,
        subscriptionTier: "standard" as const,
        subscriptionIntentTier: "standard" as const,
        latestAdminNote: "Adresse non vérifiable. Salon mobile non éligible.",
        submittedAt: new Date("2026-04-10T11:00:00Z")
      },
      owner: { fullName: "Omar Gueye", email: "omar@beautyflash.sn", phone: "+221773334455" },
      staff: [],
      services: [
        { name: "Coupe homme", durationMinutes: 30, priceXof: 3000, depositMode: "none" }
      ],
      documents: [
        { label: "Pièce d'identité gérante", status: "received" },
        { label: "Contrat de bail / Titre de propriété", status: "invalid", note: "Adresse non vérifiable." }
      ],
      gallery: [],
      subscription: null
    }
  ];

  const createdSalons: Array<{ id: string; name: string; subscriptionId: string | null }> = [];

  for (const data of salonsData) {
    const owner = await prisma.user.upsert({
      where: { email: data.owner.email },
      update: {},
      create: { ...data.owner, passwordHash: salonPassword, role: "salon_owner" }
    });

    const salon = await prisma.salon.upsert({
      where: { id: (await prisma.salon.findFirst({ where: { name: data.salon.name } }))?.id ?? "new" },
      update: data.salon,
      create: { ...data.salon, staffMembers: { connect: { id: owner.id } } }
    });

    await prisma.user.update({ where: { id: owner.id }, data: { salonId: salon.id } });

    // Staff members
    for (const s of data.staff) {
      const staffUser = await prisma.user.upsert({
        where: { email: s.email },
        update: {},
        create: { ...s, passwordHash: salonPassword, role: "salon_staff", salonId: salon.id }
      });
      await prisma.salon.update({
        where: { id: salon.id },
        data: { staffMembers: { connect: { id: staffUser.id } } }
      });
    }

    // Services
    await prisma.service.deleteMany({ where: { salonId: salon.id } });
    await prisma.service.createMany({ data: data.services.map((s) => ({ salonId: salon.id, ...s })) });

    // Documents
    await prisma.salonDocument.deleteMany({ where: { salonId: salon.id } });
    await prisma.salonDocument.createMany({ data: data.documents.map((d) => ({ salonId: salon.id, ...d })) });

    // Gallery
    await prisma.salonGalleryImage.deleteMany({ where: { salonId: salon.id } });
    if (data.gallery.length > 0) {
      await prisma.salonGalleryImage.createMany({
        data: data.gallery.map((url, i) => ({ salonId: salon.id, url, position: i }))
      });
    }

    // Subscription
    let subscriptionId: string | null = null;

    if (data.subscription) {
      const existing = await prisma.subscription.findUnique({ where: { salonId: salon.id } });
      const subscription = existing
        ? await prisma.subscription.update({ where: { id: existing.id }, data: data.subscription })
        : await prisma.subscription.create({ data: { salonId: salon.id, ...data.subscription } });

      subscriptionId = subscription.id;

      if (!existing) {
        if (data.subscription.tier === "premium" && !data.subscription.isComplimentary) {
          await prisma.subscriptionEvent.create({
            data: {
              subscriptionId: subscription.id,
              eventType: "subscription_created",
              summary: "Abonnement Premium activé.",
              actorName: owner.fullName,
              source: "owner",
              payloadPreview: null
            }
          });
          await prisma.subscriptionEvent.create({
            data: {
              subscriptionId: subscription.id,
              eventType: "renewal_paid",
              summary: "Renouvellement Wave confirmé.",
              actorName: "Wave webhook",
              source: "provider",
              payloadPreview: "provider_tx=wave_sub_001"
            }
          });
          await prisma.billingInvoice.create({
            data: {
              subscriptionId: subscription.id,
              invoiceNumber: `BA-${new Date().getFullYear()}-${Math.floor(Math.random() * 9000 + 1000)}`,
              amountXof: 25000,
              status: "paid",
              pdfUrl: ""
            }
          });
        }

        if (data.subscription.tier === "standard" && data.subscription.status === "active") {
          await prisma.subscriptionEvent.create({
            data: {
              subscriptionId: subscription.id,
              eventType: "subscription_created",
              summary: "Abonnement Standard activé.",
              actorName: owner.fullName,
              source: "owner",
              payloadPreview: null
            }
          });
          await prisma.billingInvoice.create({
            data: {
              subscriptionId: subscription.id,
              invoiceNumber: `BA-${new Date().getFullYear()}-${Math.floor(Math.random() * 9000 + 1000)}`,
              amountXof: 15000,
              status: "paid",
              pdfUrl: ""
            }
          });
        }

        if (data.subscription.status === "past_due") {
          await prisma.subscriptionEvent.create({
            data: {
              subscriptionId: subscription.id,
              eventType: "payment_failed",
              summary: "Échec de renouvellement Orange Money — solde insuffisant.",
              actorName: "Orange Money webhook",
              source: "provider",
              payloadPreview: "error_code=insufficient_funds"
            }
          });
          await prisma.billingInvoice.create({
            data: {
              subscriptionId: subscription.id,
              invoiceNumber: `BA-${new Date().getFullYear()}-${Math.floor(Math.random() * 9000 + 1000)}`,
              amountXof: 15000,
              status: "failed",
              pdfUrl: ""
            }
          });
        }

        if (data.subscription.isComplimentary) {
          await prisma.subscriptionEvent.create({
            data: {
              subscriptionId: subscription.id,
              eventType: "grant_complimentary_premium",
              summary: "Premium offert — geste commercial partenariat presse.",
              actorName: "Cheikh Platform",
              source: "admin",
              payloadPreview: null
            }
          });
          await prisma.billingInvoice.create({
            data: {
              subscriptionId: subscription.id,
              invoiceNumber: `BA-${new Date().getFullYear()}-COMP-001`,
              amountXof: 0,
              status: "comped",
              pdfUrl: ""
            }
          });
        }
      }
    }

    createdSalons.push({ id: salon.id, name: salon.name, subscriptionId });
    console.log(`  ✓ Salon: ${salon.name} (${data.salon.approvalStatus})`);
  }

  // ── Bookings: 30-day history + future bookings, varied statuses ────────────
  const approvedSalonIndices = [0, 1, 2, 3, 4, 5]; // first 6 are approved
  const approvedSalons = approvedSalonIndices.map(i => createdSalons[i]).filter(Boolean);

  // Delete existing bookings to avoid duplicates on re-seed
  for (const s of approvedSalons) {
    await prisma.booking.deleteMany({ where: { salonId: s.id } });
  }

  let bookingCount = 0;
  const bookingsForPayment: Array<{ id: string; amountXof: number; provider: "wave" | "orange_money"; createdAt: Date }> = [];

  // Historical bookings (30 days ago → yesterday) — completed + cancelled
  const historicalSlots = [
    { daysBack: 29, clientIdx: 0, salonIdx: 0, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 28, clientIdx: 1, salonIdx: 1, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 27, clientIdx: 2, salonIdx: 2, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "orange_money" as const },
    { daysBack: 26, clientIdx: 3, salonIdx: 3, status: "cancelled" as const, paymentStatus: "refunded" as const, provider: "wave" as const },
    { daysBack: 25, clientIdx: 4, salonIdx: 0, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 24, clientIdx: 5, salonIdx: 1, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 23, clientIdx: 6, salonIdx: 2, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 22, clientIdx: 7, salonIdx: 3, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "orange_money" as const },
    { daysBack: 21, clientIdx: 0, salonIdx: 4, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 20, clientIdx: 1, salonIdx: 5, status: "cancelled" as const, paymentStatus: "failed" as const, provider: "wave" as const },
    { daysBack: 18, clientIdx: 2, salonIdx: 0, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 17, clientIdx: 3, salonIdx: 1, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "orange_money" as const },
    { daysBack: 16, clientIdx: 4, salonIdx: 2, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 15, clientIdx: 5, salonIdx: 3, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 14, clientIdx: 6, salonIdx: 0, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 13, clientIdx: 7, salonIdx: 1, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 12, clientIdx: 0, salonIdx: 2, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "orange_money" as const },
    { daysBack: 11, clientIdx: 1, salonIdx: 3, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 10, clientIdx: 2, salonIdx: 4, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 9,  clientIdx: 3, salonIdx: 5, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 8,  clientIdx: 4, salonIdx: 0, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 7,  clientIdx: 5, salonIdx: 1, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "orange_money" as const },
    { daysBack: 6,  clientIdx: 6, salonIdx: 2, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 5,  clientIdx: 7, salonIdx: 3, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 4,  clientIdx: 0, salonIdx: 0, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 3,  clientIdx: 1, salonIdx: 1, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 2,  clientIdx: 2, salonIdx: 2, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const },
    { daysBack: 1,  clientIdx: 3, salonIdx: 3, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "orange_money" as const },
  ];

  for (const slot of historicalSlots) {
    const salon = approvedSalons[slot.salonIdx];
    if (!salon) continue;
    const service = await prisma.service.findFirst({ where: { salonId: salon.id } });
    if (!service) continue;
    const client = clients[slot.clientIdx];
    const startsAt = new Date(daysAgo(slot.daysBack).setHours(10, 0, 0, 0));
    const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);
    const booking = await prisma.booking.create({
      data: {
        clientId: client.id,
        salonId: salon.id,
        serviceId: service.id,
        startsAt,
        endsAt,
        status: slot.status,
        depositAmountXof: service.depositAmountXof ?? 2000,
        depositPaymentStatus: slot.paymentStatus,
        paymentProvider: slot.provider,
        createdAt: daysAgo(slot.daysBack)
      }
    });
    if (slot.paymentStatus === "succeeded") {
      bookingsForPayment.push({
        id: booking.id,
        amountXof: service.depositAmountXof ?? 2000,
        provider: slot.provider,
        createdAt: daysAgo(slot.daysBack)
      });
    }
    bookingCount++;
  }

  // Today's bookings — mix of in_progress and completed
  const todaySlots = [
    { clientIdx: 0, salonIdx: 0, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const, hoursBack: 6 },
    { clientIdx: 1, salonIdx: 1, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const, hoursBack: 5 },
    { clientIdx: 4, salonIdx: 2, status: "in_progress" as const, paymentStatus: "succeeded" as const, provider: "orange_money" as const, hoursBack: 1 },
    { clientIdx: 5, salonIdx: 3, status: "completed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const, hoursBack: 4 },
  ];

  for (const slot of todaySlots) {
    const salon = approvedSalons[slot.salonIdx];
    if (!salon) continue;
    const service = await prisma.service.findFirst({ where: { salonId: salon.id } });
    if (!service) continue;
    const client = clients[slot.clientIdx];
    const startsAt = hoursAgo(slot.hoursBack);
    const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);
    const booking = await prisma.booking.create({
      data: {
        clientId: client.id,
        salonId: salon.id,
        serviceId: service.id,
        startsAt,
        endsAt,
        status: slot.status,
        depositAmountXof: service.depositAmountXof ?? 2000,
        depositPaymentStatus: slot.paymentStatus,
        paymentProvider: slot.provider
      }
    });
    if (slot.paymentStatus === "succeeded") {
      bookingsForPayment.push({ id: booking.id, amountXof: service.depositAmountXof ?? 2000, provider: slot.provider, createdAt: new Date() });
    }
    bookingCount++;
  }

  // Future bookings — confirmed and pending
  const futureSlots = [
    { clientIdx: 2, salonIdx: 0, status: "confirmed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const, daysForward: 1 },
    { clientIdx: 3, salonIdx: 1, status: "confirmed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const, daysForward: 2 },
    { clientIdx: 6, salonIdx: 2, status: "pending" as const, paymentStatus: "pending" as const, provider: "wave" as const, daysForward: 3 },
    { clientIdx: 7, salonIdx: 3, status: "pending" as const, paymentStatus: "pending" as const, provider: "orange_money" as const, daysForward: 4 },
    { clientIdx: 0, salonIdx: 4, status: "confirmed" as const, paymentStatus: "succeeded" as const, provider: "wave" as const, daysForward: 5 },
    { clientIdx: 1, salonIdx: 5, status: "pending" as const, paymentStatus: "pending" as const, provider: "wave" as const, daysForward: 7 },
  ];

  for (const slot of futureSlots) {
    const salon = approvedSalons[slot.salonIdx];
    if (!salon) continue;
    const service = await prisma.service.findFirst({ where: { salonId: salon.id } });
    if (!service) continue;
    const client = clients[slot.clientIdx];
    const startsAt = new Date(daysFromNow(slot.daysForward).setHours(10, 0, 0, 0));
    const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);
    await prisma.booking.create({
      data: {
        clientId: client.id,
        salonId: salon.id,
        serviceId: service.id,
        startsAt,
        endsAt,
        status: slot.status,
        depositAmountXof: service.depositAmountXof ?? 2000,
        depositPaymentStatus: slot.paymentStatus,
        paymentProvider: slot.provider
      }
    });
    bookingCount++;
  }

  console.log(`  ✓ Bookings: ${bookingCount}`);

  // ── Payments (linked to succeeded bookings) ────────────────────────────────
  await prisma.payment.deleteMany({
    where: { bookingId: { in: bookingsForPayment.map(b => b.id) } }
  });

  for (const b of bookingsForPayment) {
    await prisma.payment.create({
      data: {
        bookingId: b.id,
        provider: b.provider,
        status: "succeeded",
        amountXof: b.amountXof,
        providerTxId: `tx_${Math.random().toString(36).slice(2, 10)}`,
        idempotencyKey: `idem_${b.id}`,
        createdAt: b.createdAt
      }
    });
  }
  console.log(`  ✓ Payments: ${bookingsForPayment.length}`);

  // ── Notifications ──────────────────────────────────────────────────────────
  const notifData = [
    { userId: clients[0].id, title: "Réservation confirmée", body: "Votre réservation chez Dione Signature est confirmée pour demain à 10h.", channel: "push" },
    { userId: clients[1].id, title: "Rappel — dans 24h", body: "Rappel : votre rendez-vous chez Studio Kadija est demain.", channel: "push" },
    { userId: clients[2].id, title: "Acompte reçu", body: "Votre acompte de 5 000 F CFA a été confirmé.", channel: "push" },
    { userId: clients[3].id, title: "Avis post-visite", body: "Comment s'est passée votre visite chez Maison Lumière ?", channel: "push" },
    { userId: clients[4].id, title: "Réservation annulée", body: "Votre réservation a été annulée. Remboursement en cours.", channel: "push" },
  ];

  for (const n of notifData) {
    await prisma.notification.create({ data: n });
  }
  console.log(`  ✓ Notifications: ${notifData.length}`);

  // ── Audit log ──────────────────────────────────────────────────────────────
  const dioneId = createdSalons[0].id;
  const studioKadijaId = createdSalons[1].id;
  const maisonLumiereId = createdSalons[2].id;
  const eclatVisageId = createdSalons[3].id;
  const epilExpressId = createdSalons[4].id;
  const atelierNafiId = createdSalons[8].id;
  const beautyFlashId = createdSalons[9].id;

  const dioneSubId = createdSalons[0].subscriptionId!;
  const maisonLumiereSubId = createdSalons[2].subscriptionId!;
  const epilExpressSubId = createdSalons[4].subscriptionId!;
  const eclatVisageSubId = createdSalons[3].subscriptionId!;

  const auditEntries = [
    // Salon approvals
    { id: `${dioneId}-salon.approved`, action: "salon.approved", summary: "Salon Dione Signature approuvé.", entityType: "salon", entityId: dioneId, actorName: "Cheikh Platform", severity: "info", payloadJson: JSON.stringify({ approvalStatus: "approved" }), relatedLinksJson: JSON.stringify([{ label: "Dione Signature", href: `/admin/salons/${dioneId}` }]), createdAt: new Date("2026-03-10T10:30:00Z") },
    { id: `${studioKadijaId}-salon.approved`, action: "salon.approved", summary: "Studio Kadija approuvé.", entityType: "salon", entityId: studioKadijaId, actorName: "Cheikh Platform", severity: "info", payloadJson: JSON.stringify({ approvalStatus: "approved" }), relatedLinksJson: JSON.stringify([{ label: "Studio Kadija", href: `/admin/salons/${studioKadijaId}` }]), createdAt: new Date("2026-03-20T14:00:00Z") },
    { id: `${eclatVisageId}-salon.approved`, action: "salon.approved", summary: "Éclat Visage approuvé — dossier complet.", entityType: "salon", entityId: eclatVisageId, actorName: "Cheikh Platform", severity: "info", payloadJson: JSON.stringify({ approvalStatus: "approved" }), relatedLinksJson: JSON.stringify([{ label: "Éclat Visage", href: `/admin/salons/${eclatVisageId}` }]), createdAt: new Date("2026-02-17T09:00:00Z") },
    // Needs info
    { id: `${atelierNafiId}-salon.request_info`, action: "salon.request_info", summary: "Informations complémentaires demandées à Atelier Nafi.", entityType: "salon", entityId: atelierNafiId, actorName: "Cheikh Platform", severity: "warning", payloadJson: JSON.stringify({ reason: "Document de bail flou — nouvelle version requise." }), relatedLinksJson: JSON.stringify([{ label: "Atelier Nafi", href: `/admin/salons/${atelierNafiId}` }]), createdAt: new Date("2026-04-22T14:30:00Z") },
    // Rejection
    { id: `${beautyFlashId}-salon.rejected`, action: "salon.rejected", summary: "Salon Beauty Flash rejeté — adresse non vérifiable.", entityType: "salon", entityId: beautyFlashId, actorName: "Cheikh Platform", severity: "warning", payloadJson: JSON.stringify({ reason: "Adresse non vérifiable. Salon mobile non éligible." }), relatedLinksJson: JSON.stringify([{ label: "Beauty Flash", href: `/admin/salons/${beautyFlashId}` }]), createdAt: new Date("2026-04-10T11:45:00Z") },
    // Subscription events
    { id: `${maisonLumiereSubId}-subscription.grant_complimentary_premium`, action: "subscription.grant_complimentary_premium", summary: "Premium offert — geste commercial Maison Lumière.", entityType: "subscription", entityId: maisonLumiereSubId, actorName: "Cheikh Platform", severity: "warning", payloadJson: JSON.stringify({ action: "grant_complimentary_premium", reason: "Partenariat presse" }), relatedLinksJson: JSON.stringify([{ label: "Maison Lumière", href: `/admin/subscriptions/${maisonLumiereSubId}` }]), createdAt: new Date("2026-04-05T09:00:00Z") },
    { id: `${dioneSubId}-subscription.renewal_paid`, action: "subscription.renewal_paid", summary: "Renouvellement premium confirmé pour Dione Signature.", entityType: "subscription", entityId: dioneSubId, actorName: "Wave webhook", severity: "info", payloadJson: JSON.stringify({ invoice: "BA-2026-0001" }), relatedLinksJson: JSON.stringify([{ label: "Dione Signature", href: `/admin/subscriptions/${dioneSubId}` }]), createdAt: new Date("2026-04-15T08:16:00Z") },
    { id: `${eclatVisageSubId}-subscription.renewal_paid`, action: "subscription.renewal_paid", summary: "Renouvellement premium confirmé pour Éclat Visage.", entityType: "subscription", entityId: eclatVisageSubId, actorName: "Wave webhook", severity: "info", payloadJson: JSON.stringify({ invoice: "BA-2026-0042" }), relatedLinksJson: JSON.stringify([{ label: "Éclat Visage", href: `/admin/subscriptions/${eclatVisageSubId}` }]), createdAt: new Date("2026-04-20T07:44:00Z") },
    { id: `${epilExpressSubId}-subscription.payment_failed`, action: "subscription.payment_failed", summary: "Échec renouvellement Épil Express — solde insuffisant.", entityType: "subscription", entityId: epilExpressSubId, actorName: "Orange Money webhook", severity: "critical", payloadJson: JSON.stringify({ error: "insufficient_funds", provider: "orange_money" }), relatedLinksJson: JSON.stringify([{ label: "Épil Express", href: `/admin/subscriptions/${epilExpressSubId}` }]), createdAt: new Date("2026-04-20T10:00:00Z") },
    // Config changes
    { id: "config.commission_rate-2026-03", action: "config.setting_updated", summary: "Taux de commission mis à jour : 4% → 5%.", entityType: "config", entityId: "commission_rate_percent", actorName: "Cheikh Platform", severity: "warning", payloadJson: JSON.stringify({ key: "commission_rate_percent", old: "4", new: "5" }), relatedLinksJson: JSON.stringify([]), createdAt: new Date("2026-03-01T09:00:00Z") },
    { id: "config.categories-esthetique-2026-04", action: "config.category_upserted", summary: "Catégorie Esthétique ajoutée à la plateforme.", entityType: "config", entityId: "esthetique", actorName: "Cheikh Platform", severity: "info", payloadJson: JSON.stringify({ name: "Esthétique", slug: "esthetique" }), relatedLinksJson: JSON.stringify([]), createdAt: new Date("2026-04-01T10:00:00Z") },
  ];

  await prisma.auditLog.deleteMany({
    where: { id: { in: auditEntries.map(e => e.id) } }
  });

  for (const entry of auditEntries) {
    const { id, ...data } = entry;
    await prisma.auditLog.upsert({
      where: { id },
      update: data,
      create: entry
    });
  }
  console.log(`  ✓ Audit log: ${auditEntries.length} entries`);

  // ── Platform Configuration ─────────────────────────────────────────────────
  const platformSettings = [
    { group: "pricing", key: "commission_rate_percent", value: "5", description: "Commission plateforme par transaction (%)" },
    { group: "pricing", key: "subscription_standard_price_xof", value: "15000", description: "Prix abonnement Standard (F CFA / mois)" },
    { group: "pricing", key: "subscription_premium_price_xof", value: "25000", description: "Prix abonnement Premium (F CFA / mois)" },
    { group: "pricing", key: "deposit_minimum_xof", value: "2000", description: "Acompte minimum par réservation (F CFA)" },
    { group: "pricing", key: "cancellation_window_hours", value: "24", description: "Délai d'annulation sans frais (heures)" },
    { group: "general", key: "support_email", value: "support@beauteavenue.sn", description: "Email support client" },
    { group: "general", key: "support_phone", value: "+221338001234", description: "Téléphone support" },
    { group: "general", key: "booking_advance_days_max", value: "30", description: "Délai max de réservation à l'avance (jours)" },
    { group: "general", key: "salon_approval_sla_days", value: "3", description: "SLA validation dossier (jours ouvrés)" },
  ];

  for (const s of platformSettings) {
    await prisma.platformSetting.upsert({
      where: { key: s.key },
      update: { group: s.group, description: s.description },
      create: s
    });
  }
  console.log(`  ✓ Platform settings: ${platformSettings.length}`);

  const salonCategories = [
    { name: "Coiffure", slug: "coiffure" },
    { name: "Ongles", slug: "ongles" },
    { name: "Spa & Bien-être", slug: "spa" },
    { name: "Esthétique", slug: "esthetique" },
    { name: "Maquillage", slug: "maquillage" },
    { name: "Soins visage", slug: "soins-visage" },
    { name: "Épilation", slug: "epilation" },
    { name: "Massage", slug: "massage" },
  ];

  for (const c of salonCategories) {
    await prisma.platformSalonCategory.upsert({
      where: { slug: c.slug },
      update: { name: c.name },
      create: { ...c, enabled: true }
    });
  }
  console.log(`  ✓ Salon categories: ${salonCategories.length}`);

  const requiredDocuments = [
    { label: "Pièce d'identité gérante", slug: "piece-identite", type: "any", isRequired: true },
    { label: "Contrat de bail / Titre de propriété", slug: "contrat-bail", type: "pdf", isRequired: true },
    { label: "Coordonnées de versement (RIB / Wave)", slug: "coordonnees-versement", type: "any", isRequired: true },
    { label: "Extrait RCCM", slug: "rccm", type: "pdf", isRequired: false },
    { label: "Numéro NINEA", slug: "ninea", type: "any", isRequired: false },
  ];

  for (const d of requiredDocuments) {
    await prisma.platformRequiredDocument.upsert({
      where: { slug: d.slug },
      update: { label: d.label, type: d.type, isRequired: d.isRequired },
      create: { ...d, enabled: true }
    });
  }
  console.log(`  ✓ Required documents: ${requiredDocuments.length}`);

  // ── Test fixtures — predictable IDs required by app.test.ts ──────────────
  // ON UPDATE CASCADE propagates the PK change to all FK columns automatically.

  // 1. Maison Kinka → id used by the "approves a salon" test
  await prisma.$executeRaw`
    UPDATE "Salon" SET id = 'salon-maison-kinka'
    WHERE name = 'Maison Kinka' AND id != 'salon-maison-kinka'
  `;

  // 2. Dione Signature subscription → id used by subscription detail test
  await prisma.$executeRaw`
    UPDATE "Subscription" SET id = 'sub-dione-signature'
    WHERE "salonId" = (SELECT id FROM "Salon" WHERE name = 'Dione Signature')
      AND id != 'sub-dione-signature'
  `;

  // 3. Atelier Nafi subscription → id used by the grant_complimentary_premium test
  //    Atelier Nafi has no subscription in its seed block — create or pin it here.
  const atelierNafiSalon = await prisma.salon.findFirst({ where: { name: "Atelier Nafi" } });
  if (atelierNafiSalon) {
    const existingSub = await prisma.subscription.findUnique({ where: { salonId: atelierNafiSalon.id } });
    if (!existingSub) {
      await prisma.subscription.create({
        data: {
          id: "sub-atelier-nafi",
          salonId: atelierNafiSalon.id,
          tier: "standard",
          status: "active",
          autoRenew: false,
          isComplimentary: false
        }
      });
    } else if (existingSub.id !== "sub-atelier-nafi") {
      await prisma.$executeRaw`
        UPDATE "Subscription" SET id = 'sub-atelier-nafi'
        WHERE id = ${existingSub.id}
      `;
    }
  }
  console.log("  ✓ Test fixtures pinned (salon-maison-kinka, sub-dione-signature, sub-atelier-nafi)");

  console.log("\n✅ Seed complete.\n");
  console.log("  Admin:        admin@beauteavenue.local / admin1234");
  console.log("  Salon owner:  aida@dionesignature.sn / salon1234");
  console.log("  Client:       aminata@example.sn / client1234\n");
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
