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
        <div class="lg:col-span-6 space-y-8 z-10">
          <div class="space-y-4">
            <p class="font-sans text-[11px] font-bold uppercase tracking-[0.4em] text-cocoa/40">Beauté · Dakar · Abidjan</p>
            <h1 class="text-[72px] md:text-[92px] text-espresso leading-[0.95] tracking-[-0.03em] font-medium-bold">
              L'excellence,<br />
              <em class="not-italic text-primary">au bout des doigts.</em>
            </h1>
            <p class="font-sans text-[18px] text-cocoa/70 leading-relaxed max-w-[480px]">
              Découvrez les salons d'exception en Afrique de l'Ouest. Réservez, payez l'acompte, vivez l'expérience.
            </p>
          </div>

          <div class="space-y-6">
            <div class="flex flex-wrap items-center gap-3">
              <button @click="isDownloadModalOpen = true" class="btn-primary px-8 py-3.5 text-[13px] tracking-wide cursor-pointer">
                Réserver via l'Application
              </button>
              <RouterLink to="/pro/login" class="btn-secondary px-8 py-3.5 text-[13px]">
                Espace Professionnel
              </RouterLink>
            </div>

            <div class="flex flex-wrap items-start gap-10 pt-6 border-t border-outline-variant">
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
              Plus qu'une application, un partenaire de précision pour les artisans de la beauté en Afrique de l'Ouest.
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
                <li><button @click="isDownloadModalOpen = true" class="text-[12px] font-medium text-cocoa hover:text-primary transition-colors text-left cursor-pointer">Client</button></li>
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

    <!-- Download Modal -->
    <Transition name="modal-fade">
      <div v-if="isDownloadModalOpen" class="fixed inset-0 z-[100] flex items-center justify-center overflow-y-auto bg-espresso/45 backdrop-blur-md p-4 md:p-8" @click.self="isDownloadModalOpen = false">
        <div class="relative w-full max-w-5xl bg-gradient-to-br from-[#FCF9F7] via-[#FFFBF9] to-[#FFF5F7] rounded-3xl overflow-hidden shadow-[0_30px_70px_rgba(45,26,18,0.15)] border border-outline-variant/80 p-8 md:p-12 animate-modal-in animate-duration-300">
          
          <!-- Close Button -->
          <button @click="isDownloadModalOpen = false" class="absolute top-6 right-6 p-2 rounded-full hover:bg-espresso/5 text-cocoa/60 hover:text-espresso transition-colors duration-200 cursor-pointer focus:outline-none focus:ring-2 focus:ring-primary/20" aria-label="Fermer">
            <XMarkIcon class="w-6 h-6" />
          </button>

          <!-- Split-screen Content -->
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-center">
            
            <!-- Left Column: Pitch & Links -->
            <div class="lg:col-span-7 space-y-8 text-center lg:text-left">
              <div class="space-y-4">
                <span class="inline-block px-3.5 py-1 rounded-full bg-primary/10 text-primary text-[10px] font-bold uppercase tracking-wider">
                  Application Clientèle
                </span>
                <h2 class="text-4xl md:text-5xl text-espresso tracking-tight leading-tight">
                  Votre prochain rendez-vous <br class="hidden sm:inline" />
                  <span class="text-primary not-italic">vous attend.</span>
                </h2>
                <p class="font-sans text-[15px] text-cocoa leading-relaxed max-w-[480px] mx-auto lg:mx-0">
                  Téléchargez l'application gratuite Beauté Avenue pour réserver votre salon d'exception à Dakar et Abidjan en quelques clics.
                </p>
              </div>

              <!-- CTA Zone -->
              <div class="space-y-6">
                
                <!-- Desktop View: QR Code -->
                <div class="hidden md:flex flex-col items-center lg:items-start gap-4">
                  <div class="flex items-center gap-6 p-5 rounded-2xl bg-white border border-outline-variant/40 shadow-sm">
                    <!-- Stylized QR Code SVG -->
                    <div class="relative w-36 h-36 flex items-center justify-center">
                      <svg viewBox="0 0 100 100" class="w-full h-full text-primary" fill="currentColor">
                        <!-- Finder Pattern Top-Left -->
                        <rect x="0" y="0" width="28" height="28" rx="5" />
                        <rect x="4" y="4" width="20" height="20" rx="3" fill="white" />
                        <rect x="8" y="8" width="12" height="12" rx="1.5" />
                        
                        <!-- Finder Pattern Top-Right -->
                        <rect x="72" y="0" width="28" height="28" rx="5" />
                        <rect x="76" y="4" width="20" height="20" rx="3" fill="white" />
                        <rect x="80" y="8" width="12" height="12" rx="1.5" />
                        
                        <!-- Finder Pattern Bottom-Left -->
                        <rect x="0" y="72" width="28" height="28" rx="5" />
                        <rect x="4" y="76" width="20" height="20" rx="3" fill="white" />
                        <rect x="8" y="80" width="12" height="12" rx="1.5" />
                        
                        <!-- Alignment block bottom-right -->
                        <rect x="52" y="52" width="8" height="8" rx="2" />
                        
                        <!-- Dots grid -->
                        <rect x="34" y="2" width="6" height="6" rx="1.5" />
                        <rect x="44" y="0" width="6" height="6" rx="1.5" />
                        <rect x="54" y="4" width="6" height="6" rx="1.5" />
                        <rect x="64" y="0" width="6" height="6" rx="1.5" />
                        
                        <rect x="34" y="12" width="6" height="6" rx="1.5" />
                        <rect x="46" y="10" width="6" height="6" rx="1.5" />
                        <rect x="56" y="14" width="6" height="6" rx="1.5" />
                        <rect x="64" y="10" width="6" height="6" rx="1.5" />
                        
                        <rect x="2" y="34" width="6" height="6" rx="1.5" />
                        <rect x="12" y="38" width="6" height="6" rx="1.5" />
                        <rect x="22" y="34" width="6" height="6" rx="1.5" />
                        
                        <rect x="74" y="34" width="6" height="6" rx="1.5" />
                        <rect x="84" y="38" width="6" height="6" rx="1.5" />
                        <rect x="94" y="34" width="6" height="6" rx="1.5" />
                        
                        <rect x="2" y="44" width="6" height="6" rx="1.5" />
                        <rect x="10" y="48" width="6" height="6" rx="1.5" />
                        <rect x="20" y="46" width="6" height="6" rx="1.5" />
                        
                        <rect x="74" y="46" width="6" height="6" rx="1.5" />
                        <rect x="82" y="44" width="6" height="6" rx="1.5" />
                        <rect x="92" y="48" width="6" height="6" rx="1.5" />
                        
                        <rect x="2" y="54" width="6" height="6" rx="1.5" />
                        <rect x="12" y="56" width="6" height="6" rx="1.5" />
                        <rect x="22" y="54" width="6" height="6" rx="1.5" />
                        
                        <rect x="74" y="54" width="6" height="6" rx="1.5" />
                        <rect x="84" y="56" width="6" height="6" rx="1.5" />
                        <rect x="94" y="54" width="6" height="6" rx="1.5" />
                        
                        <!-- Alignment bottom right area -->
                        <rect x="72" y="72" width="6" height="6" rx="1.5" />
                        <rect x="82" y="74" width="6" height="6" rx="1.5" />
                        <rect x="92" y="72" width="6" height="6" rx="1.5" />
                        
                        <rect x="74" y="82" width="6" height="6" rx="1.5" />
                        <rect x="84" y="84" width="6" height="6" rx="1.5" />
                        <rect x="94" y="82" width="6" height="6" rx="1.5" />
                        
                        <rect x="72" y="92" width="6" height="6" rx="1.5" />
                        <rect x="82" y="94" width="6" height="6" rx="1.5" />
                        <rect x="94" y="92" width="6" height="6" rx="1.5" />
                        
                        <rect x="34" y="74" width="6" height="6" rx="1.5" />
                        <rect x="44" y="72" width="6" height="6" rx="1.5" />
                        <rect x="36" y="84" width="6" height="6" rx="1.5" />
                        <rect x="46" y="86" width="6" height="6" rx="1.5" />
                        <rect x="34" y="94" width="6" height="6" rx="1.5" />
                        <rect x="44" y="92" width="6" height="6" rx="1.5" />
                        
                        <rect x="54" y="94" width="6" height="6" rx="1.5" />
                        <rect x="64" y="92" width="6" height="6" rx="1.5" />
                        <rect x="62" y="82" width="6" height="6" rx="1.5" />
                        <rect x="64" y="72" width="6" height="6" rx="1.5" />
                        
                        <!-- Center white circle wrapper for logo -->
                        <circle cx="50" cy="50" r="16" fill="white" />
                      </svg>
                      <!-- Center Logo -->
                      <div class="absolute inset-0 m-auto w-8 h-8 rounded-full bg-white flex items-center justify-center overflow-hidden border border-outline-variant/30">
                        <img src="/logo.png" alt="Logo" class="w-6 h-6 object-contain" />
                      </div>
                    </div>
                    
                    <div class="text-left space-y-1">
                      <p class="font-sans text-[13px] font-bold text-espresso">Scannez avec votre téléphone</p>
                      <p class="font-sans text-[11px] text-cocoa/60">Ouvrez l'appareil photo pour flasher le code</p>
                    </div>
                  </div>
                </div>

                <!-- Mobile & Fallback Badge View -->
                <div class="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4">
                  <!-- App Store Badge -->
                  <a href="https://apps.apple.com/app/beaute-avenue" target="_blank" class="flex items-center gap-3 bg-espresso hover:bg-cocoa text-white px-5 py-3.5 rounded-xl transition-all duration-300 shadow-md hover:shadow-lg w-full sm:w-auto justify-center select-none cursor-pointer">
                    <svg class="w-6 h-6 text-white fill-current shrink-0" viewBox="0 0 24 24">
                      <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.82M15.97 4.17c.66-.81 1.11-1.93.99-3.06-1 .04-2.21.67-2.93 1.49-.62.69-1.16 1.84-1.01 2.96 1.12.09 2.27-.58 2.95-1.39z"/>
                    </svg>
                    <div class="text-left leading-tight">
                      <p class="text-[8px] uppercase tracking-wider text-[#E8E2DA] opacity-75 font-sans">Télécharger sur l'</p>
                      <p class="text-sm font-semibold tracking-tight">App Store</p>
                    </div>
                  </a>
                  
                  <!-- Google Play Badge -->
                  <a href="https://play.google.com/store/apps/details?id=com.beauteavenue.client" target="_blank" class="flex items-center gap-3 bg-espresso hover:bg-cocoa text-white px-5 py-3.5 rounded-xl transition-all duration-300 shadow-md hover:shadow-lg w-full sm:w-auto justify-center select-none cursor-pointer">
                    <svg class="w-6 h-6 text-white fill-current shrink-0" viewBox="0 0 24 24">
                      <path d="M3 5.27v13.46c0 .82.68 1.43 1.47 1.26l11.66-6.52c.6-.33.6-.97 0-1.3L4.47 4.01C3.68 3.84 3 4.45 3 5.27zm13.6 5.86l-4.14 2.31 4.14 2.31c.42.23.94-.07.94-.55v-3.52c0-.48-.52-.78-.94-.55z"/>
                    </svg>
                    <div class="text-left leading-tight">
                      <p class="text-[8px] uppercase tracking-wider text-[#E8E2DA] opacity-75 font-sans">DISPONIBLE SUR</p>
                      <p class="text-sm font-semibold tracking-tight">Google Play</p>
                    </div>
                  </a>
                </div>

              </div>
            </div>

            <!-- Right Column: Visual smartphone mockup (with Notch) -->
            <div class="lg:col-span-5 flex items-center justify-center">
              <div class="relative w-full max-w-[280px] aspect-[9/19] rounded-[40px] border-[8px] border-espresso/95 shadow-2xl overflow-hidden bg-neutral-bg animate-float select-none">
                <!-- Notch representation -->
                <div class="absolute top-0 inset-x-0 mx-auto w-28 h-4 bg-espresso/95 rounded-b-xl z-20"></div>
                
                <img 
                  src="/phone_app_mockup-2.jpg" 
                  alt="Beauté Avenue App Interface" 
                  class="w-full h-full object-cover"
                />
              </div>
            </div>

          </div>

        </div>
      </div>
    </Transition>

  </div>
</template>

<script setup lang="ts">
import SenegalMapHero from "@/components/SenegalMapHero.vue";
import { computed, ref } from "vue";
import { useQuery } from "@tanstack/vue-query";
import {
  BanknotesIcon,
  CalendarDaysIcon,
  CheckCircleIcon,
  CurrencyDollarIcon,
  MagnifyingGlassIcon,
  StarIcon,
  UserGroupIcon,
  XMarkIcon
} from "@heroicons/vue/24/outline";
import { fetchPublicPricing } from "@/lib/api";

const isDownloadModalOpen = ref(false);

const pricingQuery = useQuery({
  queryKey: ["public-pricing"],
  queryFn: fetchPublicPricing,
  staleTime: 5 * 60 * 1000
});

function formatXof(amount: number) {
  if (amount === 0) return "Gratuit";
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

<style scoped>
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.35s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-active .animate-modal-in {
  animation: modal-in 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

.modal-fade-leave-active .animate-modal-in {
  animation: modal-out 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes modal-in {
  from {
    opacity: 0;
    transform: scale(0.95) translateY(15px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

@keyframes modal-out {
  from {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
  to {
    opacity: 0;
    transform: scale(0.95) translateY(15px);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-8px);
  }
}

.animate-float {
  animation: float 4s ease-in-out infinite;
}
</style>
