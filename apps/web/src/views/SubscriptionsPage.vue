<template>
  <div class="space-y-8">
    <header class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <h2 class="page-title">Abonnements</h2>

      <div class="flex items-center gap-3">
        <div class="relative">
          <input
            v-model="search"
            class="input-shell min-w-[220px] bg-white h-10 pl-9 rounded-full text-[12px]"
            placeholder="Rechercher..."
          />
          <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/30 pointer-events-none" />
        </div>
        <select v-model="tier" class="input-shell bg-white min-w-[120px] h-10 text-[12px] py-0 px-4 rounded-full">
          <option value="">Tous tiers</option>
          <option value="standard">Standard</option>
          <option value="premium">Premium</option>
        </select>
        <select v-model="status" class="input-shell bg-white min-w-[120px] h-10 text-[12px] py-0 px-4 rounded-full">
          <option value="">Tous statuts</option>
          <option value="active">Actif</option>
          <option value="paused">En pause</option>
        </select>
      </div>
    </header>

    <SkeletonLoader v-if="subscriptionsQuery.isLoading.value" variant="subscription-list" />
    <StatePanel v-else-if="subscriptionsQuery.isError.value" title="Erreur" :message="errorMessage" action-label="Réessayer" @action="subscriptionsQuery.refetch" />

    <template v-else-if="subscriptionsData">
      <!-- Summary -->
      <section class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="panel-clean p-5 bg-white border-l-4 border-l-secondary">
          <p class="metric-label mb-1">Premium</p>
          <p class="metric-value">{{ subscriptionsData.summary.premiumCount }}</p>
        </div>
        <div class="panel-clean p-5 bg-white border-l-4 border-l-outline-variant">
          <p class="metric-label mb-1">Standard</p>
          <p class="metric-value">{{ subscriptionsData.summary.standardCount }}</p>
        </div>
        <div class="panel-clean p-5 bg-white border-l-4 border-l-error/30">
          <p class="metric-label mb-1 text-error/60">En pause</p>
          <p class="metric-value">{{ subscriptionsData.summary.pausedCount }}</p>
        </div>
      </section>

      <!-- Table -->
      <StatePanel
        v-if="subscriptionsData.items.length === 0"
        eyebrow="Vue vide"
        title="Aucun abonnement trouvé"
        :message="emptyMessage"
      />

      <div v-else class="bg-white rounded-2xl border border-outline-variant overflow-hidden shadow-sm">
        <div class="overflow-x-auto">
          <table class="min-w-full text-left">
            <thead>
              <tr class="border-b border-outline-variant/40 bg-neutral-bg/40">
                <th class="px-5 py-3 section-label">Salon</th>
                <th class="px-5 py-3 section-label">Tier</th>
                <th class="px-5 py-3 section-label">Statut</th>
                <th class="px-5 py-3 section-label">Fournisseur</th>
                <th class="px-5 py-3 section-label">Expiration</th>
                <th class="px-5 py-3"></th>
              </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant/20">
              <tr
                v-for="s in subscriptionsData.items"
                :key="s.id"
                class="hover:bg-neutral-bg/30 transition-colors"
              >
                <td class="px-5 py-4">
                  <div class="flex items-center gap-2">
                    <span class="row-primary">{{ s.salonName }}</span>
                    <span v-if="s.isComplimentary" class="font-sans text-[10px] font-semibold uppercase px-1.5 py-0.5 rounded bg-secondary/10 text-secondary tracking-widest">Offert</span>
                  </div>
                </td>
                <td class="px-5 py-4">
                  <StatusBadge :value="s.tier" class="scale-90 origin-left" />
                </td>
                <td class="px-5 py-4">
                  <StatusBadge :value="s.status" class="scale-90 origin-left" />
                </td>
                <td class="px-5 py-4">
                  <span class="row-meta uppercase tracking-tight">{{ s.billingProvider ?? "Admin" }}</span>
                </td>
                <td class="px-5 py-4">
                  <span class="row-meta tabular-nums">{{ s.expiresAt ? formatDate(s.expiresAt) : "Illimité" }}</span>
                </td>
                <td class="px-5 py-4 text-right">
                  <div class="relative" @click.stop>
                    <button @click="toggleDropdown(s.id)" class="btn-secondary px-2.5 py-1.5 rounded-full text-[11px] font-semibold uppercase tracking-tight inline-flex items-center gap-1">
                      <span>Détail</span>
                      <ChevronDownIcon class="w-3.5 h-3.5" :class="openDropdown === s.id ? 'rotate-180' : ''" />
                    </button>
                    <div
                      v-if="openDropdown === s.id"
                      class="absolute right-0 top-full mt-1 z-50 w-56 bg-white rounded-xl shadow-xl border border-outline-variant/60 py-1.5"
                    >
                      <RouterLink :to="`/admin/subscriptions/${s.id}`" class="flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors">
                        <ArrowRightIcon class="w-4 h-4 text-cocoa/40" />
                        Voir le détail
                      </RouterLink>
                      <button v-if="s.status === 'inactive'" @click="quickAction(s.id, 'downgrade_to_standard')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors text-left">
                        <PlayIcon class="w-4 h-4 text-cocoa/40" />
                        Activer l'abonnement
                      </button>
                      <button v-if="s.status !== 'inactive' && s.status !== 'paused'" @click="quickAction(s.id, 'pause_subscription')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors text-left">
                        <PauseIcon class="w-4 h-4 text-cocoa/40" />
                        Mettre en pause
                      </button>
                      <button v-if="s.status === 'paused'" @click="quickAction(s.id, 'resume_subscription')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors text-left">
                        <PlayIcon class="w-4 h-4 text-cocoa/40" />
                        Reprendre
                      </button>
                      <button v-if="s.status !== 'inactive' && s.tier === 'premium'" @click="quickAction(s.id, 'downgrade_to_standard')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors text-left">
                        <ArrowTrendingDownIcon class="w-4 h-4 text-cocoa/40" />
                        Rétrograder en Standard
                      </button>
                      <button v-if="s.status !== 'inactive'" @click="quickAction(s.id, 'terminate_subscription')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-error font-medium hover:bg-error/5 transition-colors text-left border-t border-outline-variant/30 mt-1 pt-2">
                        <XCircleIcon class="w-4 h-4" />
                        Résilier
                      </button>
                    </div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { refDebounced } from "@vueuse/core";
import {
  ArrowRightIcon,
  ArrowTrendingDownIcon,
  ChevronDownIcon,
  MagnifyingGlassIcon,
  PauseIcon,
  PlayIcon,
  XCircleIcon
} from "@heroicons/vue/24/outline";

import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import { ApiError, fetchSubscriptions, overrideSubscription } from "@/lib/api";
import { formatDate } from "@/lib/date";
import { useAdminAuthStore } from "@/stores/adminAuth";
import { toast } from "vue-sonner";

const auth = useAdminAuthStore();
const queryClient = useQueryClient();
const search = ref("");
const tier = ref("");
const status = ref("");
const openDropdown = ref<string | null>(null);

const overrideMutation = useMutation({
  mutationFn: ({ id, action }: { id: string; action: string }) =>
    overrideSubscription(auth.accessToken ?? "", id, { action, reason: `Action rapide: ${action}` } as any),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ["admin-subscriptions"] });
    toast.success("Abonnement mis à jour.");
  },
  onError: (e) => {
    toast.error(e instanceof ApiError ? e.message : "Erreur.");
  }
});

function toggleDropdown(id: string) {
  openDropdown.value = openDropdown.value === id ? null : id;
}

function quickAction(id: string, action: string) {
  openDropdown.value = null;
  if (action === "terminate_subscription" && !confirm("Confirmer la résiliation de cet abonnement ?")) return;
  overrideMutation.mutate({ id, action });
}

function onDocumentClick() {
  openDropdown.value = null;
}

onMounted(() => {
  document.addEventListener("click", onDocumentClick);
});
onUnmounted(() => {
  document.removeEventListener("click", onDocumentClick);
});
const debouncedSearch = refDebounced(search, 250);

const subscriptionsQuery = useQuery({
  queryKey: computed(() => ["admin-subscriptions", debouncedSearch.value, tier.value, status.value]),
  queryFn: () => fetchSubscriptions(auth.accessToken ?? "", {
    search: debouncedSearch.value || undefined,
    tier: tier.value || undefined,
    status: status.value || undefined
  }),
  enabled: computed(() => Boolean(auth.accessToken))
});

const subscriptionsData = computed(() => subscriptionsQuery.data.value ?? null);
const hasFilters = computed(() => Boolean(debouncedSearch.value || tier.value || status.value));

const errorMessage = computed(() => {
  const error = subscriptionsQuery.error.value;
  return error instanceof ApiError ? error.message : "Erreur de chargement.";
});

const emptyMessage = computed(() => (
  hasFilters.value
    ? "Aucun abonnement ne correspond aux filtres actuels."
    : "Cette base ne contient encore aucun abonnement. Si vous attendiez des données seedées, vérifiez que l'API utilise bien la base qui a été seedée."
));
</script>
