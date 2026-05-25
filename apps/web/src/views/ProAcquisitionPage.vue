<template>
  <div class="min-h-screen bg-neutral-bg">
    <!-- Hero Section -->
    <section class="relative bg-espresso py-24 overflow-hidden">
      <div class="absolute inset-0 opacity-10">
        <div class="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(255,255,255,0.25),transparent_40%),radial-gradient(circle_at_80%_80%,rgba(255,255,255,0.2),transparent_45%)]"></div>
      </div>
      
      <div class="relative mx-auto max-w-[1480px] px-4 sm:px-6 lg:px-8 text-center">
        <h1 class="text-5xl md:text-7xl font-sans font-bold text-white mb-6">Votre salon, vu par des milliers de clients à Dakar</h1>
        <p class="mx-auto max-w-2xl text-xl text-white/70 mb-10">Rejoignez la première marketplace de beauté au Sénégal. Gérez votre agenda, vos paiements et votre croissance depuis une plateforme unique.</p>
        
        <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
          <RouterLink to="/pro/register" class="btn-primary w-full sm:w-auto text-base px-10 py-4">Inscrivez votre salon</RouterLink>
          <RouterLink to="/pro/login" class="btn-secondary w-full sm:w-auto text-base px-10 py-4 bg-white/10 text-white border-white/20 hover:bg-white/20 hover:text-white">Se connecter</RouterLink>
        </div>
      </div>
    </section>

    <!-- Benefits Grid -->
    <section class="py-24 mx-auto max-w-[1480px] px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-16">
        <h2 class="text-4xl font-sans font-bold text-espresso mb-4">Pourquoi Beauté Avenue ?</h2>
        <p class="text-cocoa/60">L'outil tout-en-un conçu pour les professionnels de la beauté.</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        <div v-for="benefit in benefits" :key="benefit.title" class="panel-clean p-8 text-center">
          <div class="mx-auto w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mb-6 text-primary">
            <component :is="benefit.icon" class="w-8 h-8" />
          </div>
          <h3 class="text-xl font-sans font-bold text-espresso mb-3">{{ benefit.title }}</h3>
          <p class="text-sm text-cocoa/60 leading-relaxed">{{ benefit.description }}</p>
        </div>
      </div>
    </section>

    <!-- Comparison Table -->
    <section class="py-24 bg-sand">
      <div class="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-4xl font-sans font-bold text-espresso mb-4">Choisissez votre plan</h2>
          <p class="text-cocoa/60">Standard pour commencer, Premium pour dominer.</p>
        </div>

        <div class="panel-clean overflow-hidden">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="bg-espresso text-white">
                <th class="px-6 py-4 text-sm font-bold uppercase tracking-widest">Fonctionnalité</th>
                <th class="px-6 py-4 text-sm font-bold uppercase tracking-widest text-center">Standard</th>
                <th class="px-6 py-4 text-sm font-bold uppercase tracking-widest text-center">Premium</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant">
              <tr v-for="feature in features" :key="feature.name" class="hover:bg-neutral-bg/50">
                <td class="px-6 py-4 text-sm font-semibold text-espresso">{{ feature.name }}</td>
                <td class="px-6 py-4 text-center">
                  <CheckCircleIcon v-if="feature.standard" class="w-5 h-5 text-secondary mx-auto" />
                  <span v-else class="text-cocoa/20">—</span>
                </td>
                <td class="px-6 py-4 text-center">
                  <CheckCircleIcon v-if="feature.premium" class="w-5 h-5 text-primary mx-auto" />
                  <span v-else class="text-cocoa/20">—</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </section>

    <!-- CTA Footer -->
    <section class="py-24 text-center">
      <h2 class="text-4xl font-sans font-bold text-espresso mb-8">Prêt à transformer votre business ?</h2>
      <RouterLink to="/pro/register" class="btn-primary text-base px-12 py-4">Démarrer gratuitement</RouterLink>
    </section>
  </div>
</template>

<script setup lang="ts">
import { 
  CalendarDaysIcon, 
  UserGroupIcon, 
  ChartBarSquareIcon, 
  ShieldCheckIcon,
  CheckCircleIcon
} from "@heroicons/vue/24/outline";

const benefits = [
  {
    title: "Visibilité accrue",
    description: "Apparaissez devant des milliers de clients potentiels chaque jour à Dakar.",
    icon: UserGroupIcon
  },
  {
    title: "Agenda digital",
    description: "Finissez-en avec les cahiers. Gérez vos RDV 24h/24, 7j/7 sur tous vos appareils.",
    icon: CalendarDaysIcon
  },
  {
    title: "Acomptes sécurisés",
    description: "Réduisez les no-shows en demandant un acompte via Wave ou Orange Money.",
    icon: ShieldCheckIcon
  },
  {
    title: "Analyses précises",
    description: "Suivez vos ventes, vos meilleurs employés et la fidélité de vos clients.",
    icon: ChartBarSquareIcon
  }
];

const features = [
  { name: "Inscription gratuite", standard: true, premium: true },
  { name: "Agenda de base", standard: true, premium: true },
  { name: "Paiements Wave/OM", standard: true, premium: true },
  { name: "Statistiques avancées", standard: false, premium: true },
  { name: "Fidélisation client", standard: false, premium: true },
  { name: "Support prioritaire", standard: false, premium: true }
];
</script>
