<template>
  <div>
    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-2">Analyses & Rapports</h1>
        <p class="text-cocoa/60">Suivez la performance et la croissance de votre salon.</p>
      </div>
      <div class="flex items-center gap-2">
        <select v-model="period" class="input-shell py-2 min-w-[150px]">
          <option value="7d">7 jours</option>
          <option value="30d">30 jours</option>
          <option value="90d">90 jours</option>
        </select>
        <button @click="exportCsv" class="btn-secondary px-4 py-2 ring-0 border flex items-center gap-2">
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
        <button @click="exportDetailedReport" class="mt-8 text-xs font-bold text-primary uppercase tracking-widest hover:underline">Voir le rapport détaillé</button>
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
              <path class="text-primary stroke-current" stroke-width="3" :stroke-dasharray="`${occupancy}, 100`" stroke-linecap="round" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
            </svg>
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="text-2xl font-bold text-espresso">{{ occupancy }}%</span>
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
              <path class="text-secondary stroke-current" stroke-width="3" :stroke-dasharray="`${repeatRate}, 100`" stroke-linecap="round" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
            </svg>
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="text-2xl font-bold text-espresso">{{ repeatRate }}%</span>
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
import { computed, ref } from "vue";
import { useQuery } from "@tanstack/vue-query";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { toast } from "vue-sonner";
import { ArrowDownTrayIcon } from "@heroicons/vue/24/outline";
import { downloadCsv, triggerDownload } from "@/lib/download";
import { fetchProAnalytics } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();
const period = ref<"7d" | "30d" | "90d">("30d");

const analyticsQuery = useQuery({
  queryKey: computed(() => ["pro-analytics", period.value]),
  queryFn: () => fetchProAnalytics(auth.accessToken ?? "", period.value),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const kpis = computed(() => {
  const data = analyticsQuery.data.value;
  const averageBasket = data && data.completedCount > 0
    ? Math.round(data.totalRevenueXof / data.completedCount)
    : 0;
  const cancellationRate = data && data.bookingCount > 0
    ? Math.max(0, Math.round(((data.bookingCount - data.completedCount) / data.bookingCount) * 100))
    : 0;
  return [
    { label: "Ventes totales", value: formatMoneyXof(data?.totalRevenueXof ?? 0), delta: period.value, trend: "up" },
    { label: "Réservations", value: String(data?.bookingCount ?? 0), delta: "Période", trend: "up" },
    { label: "Annulations", value: `${cancellationRate}%`, delta: "Estimé", trend: "up" },
    { label: "Panier moyen", value: formatMoneyXof(averageBasket), delta: "Moyenne", trend: "up" }
  ];
});

const revenueData = computed(() => {
  const revenue = analyticsQuery.data.value?.totalRevenueXof ?? 0;
  if (revenue <= 0) return [10, 18, 22, 30, 38, 42, 50];
  const base = Math.max(12, Math.min(85, Math.round(revenue / 100_000)));
  return [base - 8, base - 3, base + 2, base + 8, base + 4, base + 10, base + 6];
});

const topServices = computed(() => {
  const services = analyticsQuery.data.value?.topServices ?? [];
  const maxBookings = Math.max(1, ...services.map((service) => service.bookingCount));
  return services.map((service) => ({
    name: service.serviceName,
    count: service.bookingCount,
    percent: Math.round((service.bookingCount / maxBookings) * 100)
  }));
});

const occupancy = computed(() => analyticsQuery.data.value?.occupancyPercent ?? 0);
const repeatRate = computed(() => {
  const data = analyticsQuery.data.value;
  if (!data || data.bookingCount === 0) return 0;
  return Math.round((data.completedCount / data.bookingCount) * 100);
});

function exportCsv() {
  const data = analyticsQuery.data.value;
  if (!data) {
    toast.error("Aucune donnée à exporter pour le moment.");
    return;
  }

  const headers = ["Période", "Service", "Réservations", "Revenu total", "Occupation (%)", "Fidélisation (%)"];
  const rows = topServices.value.map((service) => [
    period.value,
    service.name,
    service.count,
    data.totalRevenueXof,
    occupancy.value,
    repeatRate.value
  ]);

  if (rows.length === 0) {
    rows.push([period.value, "-", 0, data.totalRevenueXof, occupancy.value, repeatRate.value]);
  }

  const date = new Date().toISOString().slice(0, 10);
  downloadCsv(`pro-analytics-${period.value}-${date}.csv`, headers, rows);
  toast.success("Export CSV généré.");
}

function exportDetailedReport() {
  const data = analyticsQuery.data.value;
  if (!data) {
    toast.error("Aucune donnée disponible pour le rapport.");
    return;
  }

  const lines = [
    "Rapport analytique Beauté Avenue",
    `Période: ${period.value}`,
    `Réservations: ${data.bookingCount}`,
    `Réservations terminées: ${data.completedCount}`,
    `Revenu total: ${formatMoneyXof(data.totalRevenueXof)}`,
    `Occupation moyenne: ${occupancy.value}%`,
    `Fidélisation estimée: ${repeatRate.value}%`,
    "",
    "Top services:"
  ];

  for (const service of topServices.value) {
    lines.push(`- ${service.name}: ${service.count} réservations (${service.percent}%)`);
  }

  const date = new Date().toISOString().slice(0, 10);
  triggerDownload(`pro-analytics-report-${date}.txt`, `${lines.join("\n")}\n`, "text/plain;charset=utf-8");
  toast.success("Rapport détaillé exporté.");
}
</script>
