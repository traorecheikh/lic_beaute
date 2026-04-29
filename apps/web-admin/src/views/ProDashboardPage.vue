<template>
  <div>
    <div class="mb-8">
      <h1 class="page-title mb-2">Tableau de bord</h1>
      <p class="text-cocoa/60">Aperçu de votre activité pour aujourd'hui.</p>
    </div>

    <!-- KPI Strip -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
      <div v-for="kpi in kpis" :key="kpi.label" class="panel-clean p-6">
        <p class="metric-label mb-1">{{ kpi.label }}</p>
        <div class="flex items-end justify-between">
          <p class="metric-value">{{ kpi.value }}</p>
          <div :class="[
            'text-[10px] font-bold px-2 py-0.5 rounded-full mb-1',
            kpi.trend === 'up' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
          ]">
            {{ kpi.delta }}
          </div>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Pending Requests -->
      <div class="lg:col-span-2 space-y-6">
        <div class="flex items-center justify-between">
          <h2 class="section-label">Demandes en attente</h2>
          <RouterLink to="/pro/bookings/inbox" class="text-xs font-bold text-primary uppercase tracking-widest">Voir tout</RouterLink>
        </div>
        
        <div class="space-y-4">
          <div v-for="request in pendingRequests" :key="request.id" class="panel-clean p-4 flex items-center gap-4">
            <div class="w-12 h-12 rounded-full bg-sand flex items-center justify-center font-bold text-espresso">
              {{ request.clientInitials }}
            </div>
            <div class="flex-1">
              <p class="row-primary">{{ request.clientName }}</p>
              <p class="row-meta">{{ request.service }} • {{ request.time }}</p>
            </div>
            <div class="flex gap-2">
              <button @click="rejectRequest(request.id)" class="btn-secondary px-4 py-1.5 text-[10px] ring-0 border border-outline-variant hover:bg-error/5 hover:text-error hover:border-error/20">Refuser</button>
              <button @click="acceptRequest(request.id)" class="btn-primary px-4 py-1.5 text-[10px]">Accepter</button>
            </div>
          </div>

          <div v-if="pendingRequests.length === 0" class="panel-clean p-8 text-center border-dashed">
            <p class="text-sm text-cocoa/40 italic">Aucune demande en attente.</p>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="space-y-6">
        <h2 class="section-label">Actions rapides</h2>
        <div class="space-y-3">
          <button class="btn-secondary w-full justify-start gap-3 py-4 border-dashed border-2 ring-0">
            <PlusIcon class="w-5 h-5 text-primary" />
            <span class="text-sm">Ajouter un RDV manuel</span>
          </button>
          <button class="btn-secondary w-full justify-start gap-3 py-4 border-dashed border-2 ring-0">
            <NoSymbolIcon class="w-5 h-5 text-cocoa/40" />
            <span class="text-sm">Bloquer un créneau</span>
          </button>
        </div>

        <div class="panel-clean p-6 bg-secondary-container/30 border-secondary/20 mt-8">
          <h3 class="font-display text-lg text-on-secondary-container mb-2">Passez au Premium</h3>
          <p class="text-sm text-on-secondary-container/70 mb-4 leading-relaxed">Débloquez les statistiques avancées, le marketing SMS et la fidélisation client.</p>
          <RouterLink to="/pro/subscription" class="btn-gold w-full text-[10px]">Découvrir l'offre</RouterLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { toast } from "vue-sonner";
import { PlusIcon, NoSymbolIcon } from "@heroicons/vue/24/outline";

const kpis = [
  { label: "RDV Aujourd'hui", value: "12", delta: "+2", trend: "up" },
  { label: "Chiffre d'affaires", value: "145k", delta: "+15%", trend: "up" },
  { label: "Nouv. Clients", value: "4", delta: "-1", trend: "down" },
  { label: "Taux d'occupation", value: "85%", delta: "+5%", trend: "up" }
];

const pendingRequests = ref([
  { id: 1, clientName: "Awa Ndiaye", clientInitials: "AN", service: "Brushing + Soin", time: "14:30" },
  { id: 2, clientName: "Ibrahim Diallo", clientInitials: "ID", service: "Coupe Homme", time: "16:00" },
  { id: 3, clientName: "Fatou Sow", clientInitials: "FS", service: "Manucure", time: "Demain 10:00" }
]);

function acceptRequest(id: number) {
  pendingRequests.value = pendingRequests.value.filter(r => r.id !== id);
  toast.success("Réservation confirmée !");
}

function rejectRequest(id: number) {
  pendingRequests.value = pendingRequests.value.filter(r => r.id !== id);
  toast.info("Réservation refusée.");
}
</script>
