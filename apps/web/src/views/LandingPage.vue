<template>
  <div class="min-h-screen bg-[#FDFDFD] text-espresso font-sans antialiased selection:bg-primary/20">
    
    <!-- Navigation -->
    <nav class="absolute top-0 inset-x-0 z-50 h-20 flex items-center bg-white/90 backdrop-blur-sm border-b border-outline-variant/40">
      <div class="max-w-7xl mx-auto w-full px-8 flex items-center justify-between">
        <div class="flex items-center gap-3.5">
          <img src="/logo.png" alt="Beauté Avenue" class="h-9 w-auto object-contain" />
          <span class="font-sans text-[18px] font-medium-bold tracking-tight text-espresso">Beauté Avenue</span>
        </div>

        <div class="flex items-center gap-6">
          <RouterLink to="/pro/login" class="font-sans text-[13px] font-medium text-cocoa hover:text-espresso transition-colors hidden sm:block">
            Espace Pro
          </RouterLink>
          <RouterLink to="/pro/register" class="btn-primary px-5 py-2 text-[12px] font-sans font-semibold tracking-wide">
            Inscrire mon salon
          </RouterLink>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <header class="relative pt-48 pb-32 px-8 overflow-hidden">
      <div class="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-16 items-center">

        <!-- Left: Copy & Actions -->
        <div class="lg:col-span-6 space-y-10 z-10">
          <div class="space-y-5">
            <p class="font-sans text-[11px] font-bold uppercase tracking-[0.4em] text-cocoa/40">Beauté · Dakar · Abidjan</p>
            <h1 class="text-[72px] md:text-[92px] text-espresso leading-[0.95] tracking-[-0.03em] font-medium-bold">
              L'excellence,<br />
              <em class="not-italic text-primary">au bout des doigts.</em>
            </h1>
            <p class="font-sans text-[18px] text-cocoa/70 leading-relaxed max-w-[480px]">
              Découvrez les salons d'exception en Afrique de l'Ouest. Réservez, payez l'acompte, vivez l'expérience.
            </p>
          </div>

          <div class="flex flex-wrap items-center gap-3">
            <a href="#client" class="btn-primary px-8 py-3.5 text-[13px] tracking-wide">
              Réserver maintenant
            </a>
            <RouterLink to="/pro/login" class="btn-secondary px-8 py-3.5 text-[13px]">
              Espace Professionnel
            </RouterLink>
          </div>

          <div class="flex flex-wrap items-start gap-10 pt-8 border-t border-outline-variant">
            <div class="space-y-0.5">
              <p class="font-sans text-2xl font-bold text-espresso tabular-nums">500+</p>
              <p class="font-sans text-[11px] text-cocoa/60 uppercase tracking-wider">Salons partenaires</p>
            </div>
            <div class="space-y-0.5">
              <p class="font-sans text-2xl font-bold text-espresso tabular-nums">12K+</p>
              <p class="font-sans text-[11px] text-cocoa/60 uppercase tracking-wider">Rendez-vous réussis</p>
            </div>
            <div class="space-y-0.5">
              <div class="flex items-baseline gap-1.5">
                <p class="font-sans text-2xl font-bold text-secondary tabular-nums">4.8</p>
                <StarIcon class="w-4 h-4 text-secondary" />
              </div>
              <p class="font-sans text-[11px] text-cocoa/60 uppercase tracking-wider">Note moyenne</p>
            </div>
          </div>
        </div>

        <!-- Right: Senegal Map -->
        <div class="lg:col-span-6 flex items-center justify-end">
          <SenegalMapHero />
        </div>

      </div>
    </header>

    <!-- Client Journey -->
    <section id="client" class="py-24 px-8 bg-white border-y border-outline-variant/40">
      <div class="max-w-7xl mx-auto">
        <div class="max-w-xl mb-14">
          <h2 class="text-4xl text-espresso mb-4">Fluidité & Simplicité.</h2>
          <p class="font-sans text-[15px] text-cocoa leading-relaxed">
            De la découverte au règlement, chaque étape a été allégée.
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
          <div v-for="(step, i) in steps" :key="step.title" class="p-7 rounded-xl border border-outline-variant bg-neutral-bg/30">
            <div class="flex items-center gap-3 mb-5">
              <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                <component :is="step.icon" class="w-5 h-5 text-primary" />
              </div>
              <p class="font-sans text-[11px] font-semibold text-cocoa/80 uppercase tracking-widest tabular-nums">0{{ i + 1 }}</p>
            </div>
            <h3 class="text-xl text-espresso mb-2">{{ step.title }}</h3>
            <p class="font-sans text-[13px] text-cocoa leading-relaxed">{{ step.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Professional Section -->
    <section class="py-28 px-8 bg-neutral-bg">
      <div class="max-w-7xl mx-auto grid lg:grid-cols-2 gap-20 items-center">

        <div class="space-y-10">
          <div class="space-y-4">
            <h2 class="text-4xl text-espresso">
              Digitalisez votre savoir-faire.
            </h2>
            <p class="font-sans text-[15px] text-cocoa leading-relaxed max-w-[440px]">
              Plus qu'une application — un partenaire de précision pour les artisans de la beauté en Afrique de l'Ouest.
            </p>
          </div>

          <div class="space-y-4">
            <div v-for="feat in proFeatures" :key="feat.title" class="flex gap-4 p-5 rounded-xl bg-surface border border-outline-variant">
              <div class="w-9 h-9 rounded-xl bg-secondary/10 flex items-center justify-center shrink-0 mt-0.5">
                <component :is="feat.icon" class="w-5 h-5 text-secondary" />
              </div>
              <div>
                <p class="font-sans text-[14px] font-semibold text-espresso mb-0.5">{{ feat.title }}</p>
                <p class="font-sans text-[13px] text-cocoa leading-relaxed">{{ feat.desc }}</p>
              </div>
            </div>
          </div>
        </div>

        <div class="space-y-4">
          <div class="panel-clean p-8 bg-white">
            <div class="flex items-start justify-between mb-6">
              <div>
                <h3 class="text-sm font-bold text-espresso uppercase tracking-wider">Standard</h3>
                <p class="text-2xl font-bold text-espresso tabular-nums mt-1">{{ standardPrice }}</p>
              </div>
              <span class="text-[9px] font-bold uppercase tracking-widest text-cocoa/60 bg-neutral-bg px-2 py-0.5 rounded mt-1">De base</span>
            </div>
            <ul class="space-y-3">
              <li
                v-for="item in ['Profil salon visible', 'Gestion des réservations', 'Calendrier et équipe', 'Application mobile Pro']"
                :key="item"
                class="flex items-center gap-3 text-[13px] text-cocoa/70 font-medium"
              >
                <CheckCircleIcon class="w-4 h-4 text-primary/50 shrink-0" />
                {{ item }}
              </li>
            </ul>
          </div>

          <div class="panel-clean p-8 bg-white border-l-4 border-l-secondary">
            <div class="flex items-start justify-between mb-6">
              <div>
                <h3 class="text-sm font-bold text-espresso uppercase tracking-wider">Premium</h3>
                <p class="text-2xl font-bold text-secondary tabular-nums mt-1">{{ premiumPrice }}</p>
              </div>
              <span class="text-[9px] font-bold uppercase tracking-widest text-secondary bg-secondary/10 px-2 py-0.5 rounded mt-1">Recommandé</span>
            </div>
            <ul class="space-y-3">
              <li
                v-for="item in ['Tout Standard inclus', 'Dépôts et acomptes activés', 'Analytics avancées', 'Positionnement prioritaire']"
                :key="item"
                class="flex items-center gap-3 text-[13px] font-bold text-espresso"
              >
                <StarIcon class="w-4 h-4 text-secondary shrink-0" />
                {{ item }}
              </li>
            </ul>
          </div>
        </div>

      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-white border-t border-outline-variant/30 px-8 py-20">
      <div class="max-w-7xl mx-auto">
        <div class="grid grid-cols-1 md:grid-cols-12 gap-16 mb-20">
          <div class="md:col-span-5 space-y-6">
            <div class="flex items-center gap-3">
              <img src="/logo.png" alt="Beauté Avenue" class="w-6 h-6 object-contain" />
              <span class="text-lg font-bold tracking-tighter text-espresso">Beauté Avenue</span>
            </div>
            <p class="text-[13px] text-cocoa/50 max-w-[320px] leading-relaxed font-medium">
              Système d'exploitation de référence pour l'excellence de la beauté.
            </p>
          </div>
          
          <div class="md:col-span-7 grid grid-cols-2 sm:grid-cols-3 gap-10">
            <div class="space-y-5">
              <p class="text-[10px] font-bold uppercase tracking-widest text-espresso">Plateforme</p>
              <ul class="space-y-2">
                <li><a href="#client" class="text-[12px] font-medium text-cocoa hover:text-primary transition-colors">Client</a></li>
                <li><RouterLink to="/pro/login" class="text-[12px] font-medium text-cocoa hover:text-primary transition-colors">Espace Pro</RouterLink></li>
              </ul>
            </div>
            <div class="space-y-5">
              <p class="text-[10px] font-bold uppercase tracking-widest text-espresso">Support</p>
              <ul class="space-y-2">
                <li><a href="mailto:support@beauteavenue.sn" class="text-[12px] font-medium text-cocoa hover:text-primary transition-colors">Contact</a></li>
              </ul>
            </div>
            <div class="space-y-5">
              <p class="text-[10px] font-bold uppercase tracking-widest text-espresso">Système</p>
              <ul class="space-y-2">
                <li><RouterLink to="/admin/login" class="text-[12px] font-bold text-primary hover:underline transition-colors">Administration</RouterLink></li>
              </ul>
            </div>
          </div>
        </div>
        
        <div class="pt-8 border-t border-outline-variant/20 flex justify-between items-center">
          <p class="text-[11px] font-bold text-cocoa/20 uppercase tracking-[0.2em]">© 2026 Beauté Avenue • Excellence Opérationnelle</p>
        </div>
      </div>
    </footer>

  </div>
</template>

<script setup lang="ts">
import SenegalMapHero from "@/components/SenegalMapHero.vue";
import { computed } from "vue";
import { useQuery } from "@tanstack/vue-query";
import {
  BanknotesIcon,
  CalendarDaysIcon,
  CheckCircleIcon,
  CurrencyDollarIcon,
  MagnifyingGlassIcon,
  StarIcon,
  UserGroupIcon
} from "@heroicons/vue/24/outline";
import { fetchPublicPricing } from "@/lib/api";

const pricingQuery = useQuery({
  queryKey: ["public-pricing"],
  queryFn: fetchPublicPricing,
  staleTime: 5 * 60 * 1000
});

function formatXof(amount: number) {
  return new Intl.NumberFormat("fr-FR").format(amount) + " XOF/mois";
}

const standardPrice = computed(() =>
  pricingQuery.data.value ? formatXof(pricingQuery.data.value.standard.priceXof) : "…"
);
const premiumPrice = computed(() =>
  pricingQuery.data.value ? formatXof(pricingQuery.data.value.premium.priceXof) : "…"
);

const steps = [
  {
    icon: MagnifyingGlassIcon,
    title: "Découvrez",
    desc: "Parcourez les salons près de chez vous. Filtrez par catégorie, note et disponibilité."
  },
  {
    icon: CalendarDaysIcon,
    title: "Réservez",
    desc: "Choisissez votre prestation et votre créneau. Confirmation instantanée en temps réel."
  },
  {
    icon: BanknotesIcon,
    title: "Payez",
    desc: "Réglez l'acompte via Wave ou Orange Money en quelques secondes. Simple et sécurisé."
  }
];

const proFeatures = [
  {
    icon: CalendarDaysIcon,
    title: "Agenda en temps réel",
    desc: "Visualisez toutes les réservations, bloquez des créneaux, gérez les absences."
  },
  {
    icon: CurrencyDollarIcon,
    title: "Acomptes automatisés",
    desc: "Sécurisez vos réservations avec des acomptes via Wave ou Orange Money. Zéro no-show."
  },
  {
    icon: UserGroupIcon,
    title: "Équipe et prestations",
    desc: "Créez les profils de vos praticiens et assignez les bonnes expertises."
  }
];
</script>
