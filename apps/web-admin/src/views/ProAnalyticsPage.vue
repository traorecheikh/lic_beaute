<template>
  <div>
    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-2">Analyses & Rapports</h1>
        <p class="text-cocoa/60">Suivez la performance et la croissance de votre salon.</p>
      </div>
      <div class="flex items-center gap-2">
        <select class="input-shell py-2 min-w-[150px]">
          <option>Derniers 30 jours</option>
          <option>Ce mois</option>
          <option>Mois dernier</option>
          <option>Année 2026</option>
        </select>
        <button class="btn-secondary px-4 py-2 ring-0 border flex items-center gap-2">
          <ArrowDownTrayIcon class="w-4 h-4" />
          Exporter CSV
        </button>
      </div>
    </div>

    <!-- Main KPIs -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
      <div v-for="kpi in kpis" :key="kpi.label" class="panel-clean p-6">
        <p class="metric-label mb-1">{{ kpi.label }}</p>
        <div class="flex items-end justify-between">
          <p class="metric-value">{{ kpi.value }}</p>
          <span :class="['text-[10px] font-bold px-2 py-0.5 rounded-full mb-1', kpi.trend === 'up' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700']">
            {{ kpi.delta }}
          </span>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-10">
      <!-- Revenue Chart Placeholder -->
      <div class="panel-clean p-8 min-h-[400px] flex flex-col">
        <div class="flex items-center justify-between mb-8">
          <h2 class="section-label">Chiffre d'affaires (FCFA)</h2>
          <div class="flex gap-1">
            <div class="w-3 h-3 rounded-full bg-primary"></div>
            <div class="w-3 h-3 rounded-full bg-secondary"></div>
          </div>
        </div>
        <div class="flex-1 flex items-end gap-2 px-2">
          <div v-for="(val, i) in revenueData" :key="i" class="flex-1 bg-primary/20 rounded-t-lg transition-all hover:bg-primary/40 relative group" :style="{ height: val + '%' }">
            <div class="absolute -top-8 left-1/2 -translate-x-1/2 bg-espresso text-white text-[10px] px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition whitespace-nowrap z-10">
              {{ (val * 1000).toLocaleString() }} FCFA
            </div>
          </div>
        </div>
        <div class="flex justify-between mt-4 px-2">
          <span v-for="day in ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim']" :key="day" class="text-[10px] font-bold text-cocoa/30 uppercase">{{ day }}</span>
        </div>
      </div>

      <!-- Services breakdown -->
      <div class="panel-clean p-8 flex flex-col">
        <h2 class="section-label mb-8">Services les plus populaires</h2>
        <div class="flex-1 space-y-6">
          <div v-for="service in topServices" :key="service.name">
            <div class="flex justify-between text-sm mb-2">
              <span class="font-bold text-espresso">{{ service.name }}</span>
              <span class="text-cocoa/60 font-medium">{{ service.count }} réservations</span>
            </div>
            <div class="w-full h-2 bg-neutral-bg rounded-full overflow-hidden">
              <div class="h-full bg-secondary transition-all duration-1000" :style="{ width: service.percent + '%' }"></div>
            </div>
          </div>
        </div>
        <button class="mt-8 text-xs font-bold text-primary uppercase tracking-widest hover:underline">Voir le rapport détaillé</button>
      </div>
    </div>

    <!-- Occupancy & Repeat Rate -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      <div class="panel-clean p-8">
        <h2 class="section-label mb-6">Taux d'occupation moyen</h2>
        <div class="flex items-center gap-8">
          <div class="relative w-32 h-32">
            <svg class="w-full h-full" viewBox="0 0 36 36">
              <path class="text-neutral-bg stroke-current" stroke-width="3" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
              <path class="text-primary stroke-current" stroke-width="3" stroke-dasharray="78, 100" stroke-linecap="round" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
            </svg>
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="text-2xl font-bold text-espresso">78%</span>
            </div>
          </div>
          <div class="flex-1 space-y-2">
            <p class="text-sm text-espresso font-semibold">Forte affluence</p>
            <p class="text-xs text-cocoa/60 leading-relaxed">Votre salon est particulièrement sollicité les Samedis après-midi.</p>
          </div>
        </div>
      </div>

      <div class="panel-clean p-8">
        <h2 class="section-label mb-6">Taux de fidélisation</h2>
        <div class="flex items-center gap-8">
          <div class="relative w-32 h-32">
            <svg class="w-full h-full" viewBox="0 0 36 36">
              <path class="text-neutral-bg stroke-current" stroke-width="3" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
              <path class="text-secondary stroke-current" stroke-width="3" stroke-dasharray="45, 100" stroke-linecap="round" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
            </svg>
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="text-2xl font-bold text-espresso">45%</span>
            </div>
          </div>
          <div class="flex-1 space-y-2">
            <p class="text-sm text-espresso font-semibold">Clients récurrents</p>
            <p class="text-xs text-cocoa/60 leading-relaxed">Presque la moitié de vos clients reviennent sous 30 jours.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowDownTrayIcon } from "@heroicons/vue/24/outline";

const kpis = [
  { label: "Ventes totales", value: "2.4M", delta: "+12%", trend: "up" },
  { label: "Réservations", value: "156", delta: "+8%", trend: "up" },
  { label: "Annulations", value: "4%", delta: "-2%", trend: "up" },
  { label: "Panier moyen", value: "15.4k", delta: "+3%", trend: "up" }
];

const revenueData = [45, 62, 58, 75, 92, 100, 88];

const topServices = [
  { name: "Brushing + Soin", count: 42, percent: 85 },
  { name: "Coupe Homme", count: 35, percent: 70 },
  { name: "Manucure", count: 28, percent: 55 },
  { name: "Pose vernis", count: 18, percent: 35 }
];
</script>
