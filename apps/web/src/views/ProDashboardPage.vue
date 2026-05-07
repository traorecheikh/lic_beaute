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
              <button :disabled="actionLoading" @click="rejectRequest(request.id)" class="btn-secondary px-4 py-1.5 text-[10px] ring-0 border border-outline-variant hover:bg-error/5 hover:text-error hover:border-error/20 disabled:opacity-60">Refuser</button>
              <button :disabled="actionLoading" @click="acceptRequest(request.id)" class="btn-primary px-4 py-1.5 text-[10px] disabled:opacity-60">Accepter</button>
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
          <button @click="openManualModal" class="btn-secondary w-full justify-start gap-3 py-4 border-dashed border-2 ring-0">
            <PlusIcon class="w-5 h-5 text-primary" />
            <span class="text-sm">Ajouter un RDV manuel</span>
          </button>
          <button @click="openBlockModal" class="btn-secondary w-full justify-start gap-3 py-4 border-dashed border-2 ring-0">
            <NoSymbolIcon class="w-5 h-5 text-cocoa/40" />
            <span class="text-sm">Bloquer un créneau</span>
          </button>
        </div>

        <div class="panel-clean p-6 bg-secondary-container/30 border-secondary/20 mt-8">
          <h3 class="row-primary mb-2">Passez au Premium</h3>
          <p class="row-meta mb-4 leading-relaxed">Débloquez les statistiques avancées, le marketing SMS et la fidélisation client.</p>
          <RouterLink to="/pro/subscription" class="btn-gold w-full text-[10px]">Découvrir l'offre</RouterLink>
        </div>
      </div>
    </div>

    <!-- Manual Booking Modal -->
    <Teleport to="body">
      <div
        v-if="showManualModal"
        class="fixed inset-0 z-[200] flex items-center justify-center p-4"
        @click.self="showManualModal = false"
      >
        <div class="absolute inset-0 bg-espresso/40 backdrop-blur-sm"></div>
        <div class="relative w-full max-w-md bg-surface rounded-3xl shadow-2xl overflow-hidden">
          <div class="p-6 border-b border-outline-variant flex items-center justify-between">
            <h3 class="row-primary text-base">Nouveau RDV Manuel</h3>
            <button @click="showManualModal = false" class="p-2 hover:bg-neutral-bg rounded-full transition">
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <form @submit.prevent="submitManualBooking" class="p-6 space-y-5">
            <div>
              <label class="section-label mb-2 block">Prestation *</label>
              <select v-model="manualForm.serviceId" class="input-shell" required>
                <option value="">Sélectionner une prestation</option>
                <option v-for="svc in servicesQuery.data.value ?? []" :key="svc.id" :value="svc.id">
                  {{ svc.name }} — {{ svc.durationMinutes }} min
                </option>
              </select>
            </div>

            <div>
              <label class="section-label mb-2 block">Date et heure *</label>
              <input type="datetime-local" v-model="manualForm.startsAt" class="input-shell" required />
            </div>

            <div>
              <label class="section-label mb-2 block">Client</label>
              
              <div v-if="manualForm.clientId" class="flex items-center justify-between p-3 bg-neutral-bg/50 border border-outline-variant/50 rounded-xl mb-3">
                <div>
                  <div class="font-bold text-espresso text-sm">{{ manualForm.clientName }}</div>
                  <div class="text-xs text-cocoa/60">{{ manualForm.clientPhone }}</div>
                </div>
                <button @click="clearClientSelection" type="button" class="p-1 text-cocoa/60 hover:text-red-500 hover:bg-red-50 rounded-full transition-colors">
                  <XMarkIcon class="w-5 h-5" />
                </button>
              </div>

              <div v-else class="relative mb-3">
                <div class="relative">
                  <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40" />
                  <input 
                    v-model="clientSearchText" 
                    @focus="isClientDropdownOpen = true"
                    @blur="isClientDropdownOpen = false"
                    class="input-shell pl-9" 
                    placeholder="Rechercher un client (nom ou téléphone)..." 
                  />
                </div>
                
                <div v-if="isClientDropdownOpen" class="absolute z-50 w-full mt-1 bg-white border border-outline-variant shadow-xl rounded-xl max-h-60 overflow-y-auto py-1">
                  <div v-if="filteredDropdownClients.length === 0" class="px-4 py-3 text-sm text-cocoa/60 text-center">
                    Aucun client trouvé pour "{{ clientSearchText }}"
                  </div>
                  <button 
                    v-for="client in filteredDropdownClients" 
                    :key="client.id" 
                    @mousedown.prevent="selectClientDropdown(client)"
                    type="button" 
                    class="w-full text-left px-4 py-2 hover:bg-neutral-bg/50 focus:bg-neutral-bg/50 transition-colors flex flex-col"
                  >
                    <span class="font-bold text-espresso text-sm">{{ client.fullName }}</span>
                    <span class="text-xs text-cocoa/60">{{ client.phone ?? "Pas de téléphone" }}</span>
                  </button>
                  <div class="border-t border-outline-variant/30 mt-1 pt-1">
                    <button @mousedown.prevent="isClientDropdownOpen = false" type="button" class="w-full text-left px-4 py-2 text-primary font-semibold text-sm hover:bg-primary/5 transition-colors">
                      + Nouveau client manuellement
                    </button>
                  </div>
                </div>
              </div>

              <div v-if="!manualForm.clientId" class="grid grid-cols-1 gap-4 bg-neutral-bg/30 p-4 rounded-xl border border-dashed border-cocoa/10">
                <div>
                  <label class="text-[10px] font-bold uppercase text-cocoa/40 mb-1 block">Nom complet</label>
                  <input v-model="manualForm.clientName" class="input-shell bg-white" placeholder="Marie Diop" />
                </div>
                <div>
                  <label class="text-[10px] font-bold uppercase text-cocoa/40 mb-1 block">Téléphone client</label>
                  <input type="tel" v-model="manualForm.clientPhone" class="input-shell bg-white" placeholder="77 123 45 67" />
                </div>
              </div>
            </div>

            <div class="flex gap-3 pt-2">
              <button type="button" @click="showManualModal = false" class="btn-secondary flex-1">Annuler</button>
              <button type="submit" :disabled="manualMutation.isPending.value" class="btn-primary flex-1 disabled:opacity-60">
                {{ manualMutation.isPending.value ? "Création..." : "Créer le RDV" }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>

    <!-- Block Slot Modal -->
    <Teleport to="body">
      <div
        v-if="showBlockModal"
        class="fixed inset-0 z-[200] flex items-center justify-center p-4"
        @click.self="showBlockModal = false"
      >
        <div class="absolute inset-0 bg-espresso/40 backdrop-blur-sm"></div>
        <div class="relative w-full max-w-md bg-surface rounded-3xl shadow-2xl overflow-hidden">
          <div class="p-6 border-b border-outline-variant flex items-center justify-between">
            <h3 class="row-primary text-base">Bloquer un créneau</h3>
            <button @click="showBlockModal = false" class="p-2 hover:bg-neutral-bg rounded-full transition">
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <form @submit.prevent="submitBlockSlot" class="p-6 space-y-5">
            <div>
              <label class="section-label mb-2 block">Début *</label>
              <input type="datetime-local" v-model="blockForm.startsAt" class="input-shell" required />
            </div>

            <div>
              <label class="section-label mb-2 block">Fin *</label>
              <input type="datetime-local" v-model="blockForm.endsAt" class="input-shell" required />
            </div>

            <div>
              <label class="section-label mb-2 block">Motif</label>
              <input type="text" v-model="blockForm.reason" class="input-shell" placeholder="Réunion, formation..." />
            </div>

            <div class="flex gap-3 pt-2">
              <button type="button" @click="showBlockModal = false" class="btn-secondary flex-1">Annuler</button>
              <button type="submit" :disabled="blockMutation.isPending.value" class="btn-primary flex-1 disabled:opacity-60">
                {{ blockMutation.isPending.value ? "Blocage..." : "Bloquer" }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { refDebounced } from "@vueuse/core";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { toast } from "vue-sonner";
import { PlusIcon, NoSymbolIcon, XMarkIcon, MagnifyingGlassIcon } from "@heroicons/vue/24/outline";
import {
  acceptProBooking,
  createManualProBooking,
  createProBlockedSlot,
  fetchProBookings,
  fetchProClients,
  fetchProDashboard,
  fetchProServices,
  rejectProBooking
} from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";

const auth = useProAuthStore();
const queryClient = useQueryClient();

const showManualModal = ref(false);
const showBlockModal = ref(false);

const manualForm = reactive({
  serviceId: "",
  startsAt: dayjs().format("YYYY-MM-DDTHH:mm"),
  clientId: "",
  clientName: "",
  clientPhone: ""
});

const blockForm = reactive({
  startsAt: dayjs().format("YYYY-MM-DDTHH:mm"),
  endsAt: dayjs().add(1, "hour").format("YYYY-MM-DDTHH:mm"),
  reason: ""
});

const clientSearchText = ref("");
const debouncedClientSearch = refDebounced(clientSearchText, 300);
const isClientDropdownOpen = ref(false);

const dashboardQuery = useQuery({
  queryKey: ["pro-dashboard"],
  queryFn: () => fetchProDashboard(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const pendingQuery = useQuery({
  queryKey: ["pro-bookings", "pending"],
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { status: "pending", page: 0, pageSize: 20 }),
  enabled: computed(() => Boolean(auth.accessToken))
});

const servicesQuery = useQuery({
  queryKey: ["pro-services"],
  queryFn: () => fetchProServices(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken) && showManualModal.value)
});

const clientsQuery = useQuery({
  queryKey: computed(() => ["pro-clients", "selector", debouncedClientSearch.value.trim()]),
  queryFn: () => fetchProClients(auth.accessToken ?? "", debouncedClientSearch.value.trim() || undefined),
  enabled: computed(() => Boolean(auth.accessToken) && showManualModal.value)
});

const filteredDropdownClients = computed(() => {
  return (clientsQuery.data.value ?? []).slice(0, 10);
});

function selectClientDropdown(client: any) {
  manualForm.clientId = client.id;
  manualForm.clientName = client.fullName;
  manualForm.clientPhone = client.phone ?? "";
  clientSearchText.value = "";
  isClientDropdownOpen.value = false;
}

function clearClientSelection() {
  manualForm.clientId = "";
  manualForm.clientName = "";
  manualForm.clientPhone = "";
  clientSearchText.value = "";
}

const acceptMutation = useMutation({
  mutationFn: (bookingId: string) => acceptProBooking(auth.accessToken ?? "", bookingId),
  onSuccess: async () => {
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ["pro-dashboard"] }),
      queryClient.invalidateQueries({ queryKey: ["pro-bookings"] })
    ]);
    toast.success("Réservation confirmée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Action impossible pour le moment."));
  }
});

const rejectMutation = useMutation({
  mutationFn: (bookingId: string) => rejectProBooking(auth.accessToken ?? "", bookingId),
  onSuccess: async () => {
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ["pro-dashboard"] }),
      queryClient.invalidateQueries({ queryKey: ["pro-bookings"] })
    ]);
    toast.info("Réservation refusée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Action impossible pour le moment."));
  }
});

const manualMutation = useMutation({
  mutationFn: () =>
    createManualProBooking(auth.accessToken ?? "", {
      clientId: manualForm.clientId || undefined,
      serviceId: manualForm.serviceId,
      startsAt: new Date(manualForm.startsAt),
      clientName: manualForm.clientId ? undefined : (manualForm.clientName.trim() || undefined),
      clientPhone: manualForm.clientId ? undefined : (manualForm.clientPhone.trim() || undefined)
    }),
  onSuccess: async () => {
    showManualModal.value = false;
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ["pro-dashboard"] }),
      queryClient.invalidateQueries({ queryKey: ["pro-bookings"] }),
      queryClient.invalidateQueries({ queryKey: ["pro-clients"] })
    ]);
    toast.success("RDV créé.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Impossible de créer le RDV."));
  }
});

const blockMutation = useMutation({
  mutationFn: () =>
    createProBlockedSlot(auth.accessToken ?? "", {
      startsAt: new Date(blockForm.startsAt),
      endsAt: new Date(blockForm.endsAt),
      reason: blockForm.reason || undefined,
      scope: "salon"
    }),
  onSuccess: async () => {
    showBlockModal.value = false;
    await queryClient.invalidateQueries({ queryKey: ["pro-bookings"] });
    toast.success("Créneau bloqué.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Impossible de bloquer ce créneau."));
  }
});

const actionLoading = computed(() => acceptMutation.isPending.value || rejectMutation.isPending.value);

const kpis = computed(() => {
  const data = dashboardQuery.data.value;
  return [
    {
      label: "RDV Aujourd'hui",
      value: String(data?.todayBookingCount ?? 0),
      delta: "Journée",
      trend: "up"
    },
    {
      label: "Demandes en attente",
      value: String(data?.pendingBookingCount ?? 0),
      delta: "Inbox",
      trend: "up"
    },
    {
      label: "Chiffre d'affaires",
      value: data?.totalRevenueXof != null ? formatMoneyXof(data.totalRevenueXof) : "N/A",
      delta: data?.totalRevenueXof != null ? "Cumulé" : "Propriétaire",
      trend: "up"
    },
    {
      label: "Rôle actif",
      value: auth.isOwner ? "Owner" : "Staff",
      delta: "Session",
      trend: "up"
    }
  ];
});

const pendingRequests = computed(() => {
  return (pendingQuery.data.value ?? []).map((booking) => {
    const clientName = booking.clientName ?? "Client";
    return {
      id: booking.id,
      clientName,
      clientInitials: clientName
        .split(" ")
        .slice(0, 2)
        .map((name) => name[0]?.toUpperCase() ?? "")
        .join(""),
      service: booking.serviceName,
      time: dayjs(booking.startsAt).format("DD MMM • HH:mm")
    };
  });
});

function openManualModal() {
  manualForm.serviceId = "";
  manualForm.startsAt = dayjs().format("YYYY-MM-DDTHH:mm");
  manualForm.clientName = "";
  manualForm.clientPhone = "";
  showManualModal.value = true;
}

function openBlockModal() {
  blockForm.startsAt = dayjs().format("YYYY-MM-DDTHH:mm");
  blockForm.endsAt = dayjs().add(1, "hour").format("YYYY-MM-DDTHH:mm");
  blockForm.reason = "";
  showBlockModal.value = true;
}

function acceptRequest(id: string) {
  acceptMutation.mutate(id);
}

function rejectRequest(id: string) {
  rejectMutation.mutate(id);
}

function submitManualBooking() {
  if (!manualForm.serviceId) {
    toast.error("Veuillez sélectionner une prestation.");
    return;
  }
  manualMutation.mutate();
}

function submitBlockSlot() {
  if (new Date(blockForm.endsAt) <= new Date(blockForm.startsAt)) {
    toast.error("La fin doit être après le début.");
    return;
  }
  blockMutation.mutate();
}
</script>
