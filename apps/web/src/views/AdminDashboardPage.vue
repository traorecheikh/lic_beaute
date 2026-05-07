<template>
  <div class="space-y-10">
    <!-- Clean Header -->
    <header class="flex flex-col gap-6 md:flex-row md:items-end md:justify-between">
      <div>
        <h2 class="page-title">Pilotage</h2>
      </div>
      
      <div class="flex items-center gap-3">
        <button class="btn-secondary gap-2" @click="showExportModal = true">
          <ArrowDownTrayIcon class="w-3.5 h-3.5" />
          Exporter
        </button>
        <RouterLink to="/admin/salons" class="btn-primary">
          Files d'attente
        </RouterLink>
      </div>
    </header>

    <ExportModal :show="showExportModal" @close="showExportModal = false" />

    <SkeletonLoader v-if="dashboardQuery.isLoading.value" variant="dashboard" />

    <StatePanel
      v-else-if="dashboardQuery.isError.value"
      title="Erreur"
      :message="errorMessage"
      action-label="Réessayer"
      @action="dashboardQuery.refetch"
    />

    <template v-else-if="dashboardQuery.data.value">
      <!-- KPIs -->
      <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <MetricCard
          v-for="metric in dashboardQuery.data.value.kpis" 
          :key="metric.label"
          :label="metric.label"
          :value="metric.displayValue"
          :note="metric.note"
        />
      </section>

      <div class="grid grid-cols-12 gap-8">
        <!-- Alerts -->
        <div v-if="dashboardQuery.data.value.inactivityAlerts.length > 0" class="col-span-12">
          <div class="bg-blush/40 border border-primary/10 rounded-3xl p-6 flex flex-col md:flex-row items-center gap-6">
            <div class="h-12 w-12 rounded-2xl bg-white flex items-center justify-center shrink-0 shadow-sm">
              <ExclamationTriangleIcon class="w-6 h-6 text-primary" />
            </div>
            <div class="flex-1 text-center md:text-left">
              <p class="row-primary">{{ dashboardQuery.data.value.inactivityAlerts.length }} alertes d'inactivité</p>
              <p class="text-[12px] text-cocoa/60">Salons n'ayant enregistré aucune activité récente.</p>
            </div>
            <RouterLink to="/admin/salons" class="btn-primary !bg-white !text-primary ring-1 ring-primary/20">
              Voir les salons
            </RouterLink>
          </div>
        </div>

        <!-- Main Insights -->
        <section class="col-span-12 lg:col-span-8 space-y-6">
          <div class="flex items-center justify-between px-2">
            <h3 class="text-[11px] font-bold text-cocoa/70 uppercase tracking-[0.3em]">Top croissance</h3>
            <RouterLink class="text-[11px] font-bold text-primary hover:underline" to="/admin/subscriptions">
              Analyse complète
            </RouterLink>
          </div>

          <div class="bg-white rounded-3xl border border-outline-variant shadow-sm overflow-hidden divide-y divide-outline-variant/30">
            <article
              v-for="salon in dashboardQuery.data.value.topGrowthSalons"
              :key="salon.salonId"
              class="flex items-center justify-between p-6 hover:bg-sand/30 transition-all group"
            >
              <div class="flex items-center gap-4">
                <div class="w-12 h-12 rounded-2xl bg-sand flex items-center justify-center font-bold text-cocoa/20 text-xs">
                  {{ salon.salonName.substring(0, 2).toUpperCase() }}
                </div>
                <div>
                  <p class="row-primary group-hover:text-primary transition-colors">
                    {{ salon.salonName }}
                  </p>
                  <p class="text-[12px] text-cocoa/60">
                    {{ salon.city }} • <span class="font-semibold text-espresso/70">{{ salon.bookingsThisWeek }}</span> réservations
                  </p>
                </div>
              </div>
              <div class="flex items-center gap-6">
                <div class="flex items-center gap-1">
                  <ArrowTrendingUpIcon class="w-3.5 h-3.5 text-secondary" />
                  <p class="text-[13px] font-semibold text-secondary tabular-nums">+{{ salon.bookingDeltaPercent }}%</p>
                </div>
                <div class="hidden sm:block">
                  <StatusBadge :value="salon.bookingDeltaPercent > 0 ? 'premium' : 'standard'" class="scale-90" />
                </div>
              </div>
            </article>
          </div>
        </section>

        <!-- Right Side -->
        <aside class="col-span-12 lg:col-span-4 space-y-8">
          <div class="space-y-4">
            <h3 class="text-[11px] font-bold text-cocoa/70 uppercase tracking-[0.3em] px-2">Raccourcis</h3>
            <div class="grid grid-cols-1 gap-3">
              <RouterLink 
                to="/admin/salons" 
                class="flex items-center justify-between p-6 rounded-3xl bg-white border border-outline-variant hover:border-primary/30 transition-all"
              >
                <div>
                  <p class="row-primary">Approbations</p>
                  <p class="text-[11px] font-semibold text-primary uppercase tracking-widest">{{ dashboardQuery.data.value.quickLinks.pendingSalonApprovals }} dossiers</p>
                </div>
                <ChevronRightIcon class="w-5 h-5 text-cocoa/20" />
              </RouterLink>

              <RouterLink 
                to="/admin/subscriptions" 
                class="flex items-center justify-between p-6 rounded-3xl bg-white border border-outline-variant hover:border-secondary/30 transition-all"
              >
                <div>
                  <p class="row-primary">Abonnements</p>
                  <p class="text-[11px] font-semibold text-secondary uppercase tracking-widest">{{ dashboardQuery.data.value.quickLinks.subscriptionsNeedingAction }} actions</p>
                </div>
                <ChevronRightIcon class="w-5 h-5 text-cocoa/20" />
              </RouterLink>
            </div>
          </div>

          <!-- Audit Summary Card -->
          <div class="bg-sand rounded-3xl p-8 border border-outline-variant/60 relative overflow-hidden group">
            <div class="absolute -right-4 -top-4 w-24 h-24 bg-white/20 rounded-full transition-transform group-hover:scale-150"></div>
            <div class="relative z-10 space-y-6">
              <h3 class="section-label">Registre Audit</h3>
              <div class="space-y-1">
                <p class="metric-value">{{ dashboardQuery.data.value.quickLinks.auditEventsToday }}</p>
                <p class="metric-label">Événements aujourd'hui</p>
              </div>
              <RouterLink to="/admin/audit" class="btn-secondary !w-full !px-0 text-[11px]">
                Consulter le journal
              </RouterLink>
            </div>
          </div>
        </aside>
      </div>

      <!-- Footer -->
      <footer class="pt-16 pb-12 border-t border-outline-variant/30 mt-10">
        <div class="flex flex-col md:flex-row items-center justify-between gap-6">
          <div class="flex items-center gap-3">
            <span class="w-2 h-2 rounded-full bg-green-500 shadow-[0_0_10px_rgba(34,197,94,0.3)]"></span>
            <p class="text-[11px] text-cocoa/80 font-bold uppercase tracking-[0.3em]">Système opérationnel</p>
          </div>
          <p class="text-[10px] text-cocoa/20 font-bold uppercase tracking-[0.5em]">Beauté Avenue Ops</p>
        </div>
      </footer>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useQuery } from "@tanstack/vue-query";
import {
  ArrowTrendingUpIcon,
  ArrowUpRightIcon,
  ChevronRightIcon,
  ExclamationTriangleIcon,
  ArrowDownTrayIcon
} from "@heroicons/vue/24/outline";

import ExportModal from "@/components/ExportModal.vue";
import MetricCard from "@/components/MetricCard.vue";
import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import { ApiError, fetchAdminDashboard } from "@/lib/api";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();
const showExportModal = ref(false);

const dashboardQuery = useQuery({
  queryKey: ["admin-dashboard"],
  queryFn: () => fetchAdminDashboard(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const errorMessage = computed(() => {
  const error = dashboardQuery.error.value;
  return error instanceof ApiError ? error.message : "Données indisponibles.";
});
</script>
