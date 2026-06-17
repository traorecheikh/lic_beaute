<template>
  <div class="space-y-8">
    <!-- Clean Header -->
    <header class="flex flex-col gap-6 md:flex-row md:items-center md:justify-between">
      <div>
        <h2 class="page-title">Salons</h2>
      </div>

      <div class="flex items-center gap-3">
        <RouterLink to="/admin/salons/new" class="btn-primary px-5 py-2.5 flex items-center gap-2">
          <PlusIcon class="w-4 h-4" /> Créer un salon
        </RouterLink>
        <div class="relative">
          <input
            v-model="search"
            class="input-shell min-w-[200px] bg-white text-[12px] h-10 border-outline-variant/60 pl-9 rounded-full"
            placeholder="Enseigne..."
          />
          <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40 pointer-events-none" />
        </div>

        <div class="relative">
          <input
            v-model="city"
            class="input-shell min-w-[160px] bg-white text-[12px] h-10 border-outline-variant/60 pl-9 rounded-full"
            placeholder="Ville..."
          />
          <MapPinIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40 pointer-events-none" />
        </div>
        <div class="relative">
          <select v-model="status" class="input-shell bg-white border-outline-variant/60 min-w-[160px] h-10 text-[12px] py-0 pl-9 pr-4 rounded-full appearance-none">
            <option value="">Tous statuts</option>
            <option value="pending_review">À traiter</option>
            <option value="needs_info">Besoin d'infos</option>
            <option value="approved">Approuvé</option>
            <option value="rejected">Rejeté</option>
          </select>
          <FunnelIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40 pointer-events-none" />
        </div>
        </div>
    </header>

    <SkeletonLoader v-if="salonsQuery.isLoading.value" variant="salon-list" />

    <StatePanel
      v-else-if="salonsQuery.isError.value"
      title="Erreur"
      :message="errorMessage"
      action-label="Réessayer"
      @action="salonsQuery.refetch"
    />

    <template v-else-if="salonsQuery.data.value">
      <div class="space-y-4">
        <p class="text-[11px] font-bold text-cocoa/30 uppercase tracking-widest px-1">
          {{ salonsQuery.data.value.total }} dossiers
        </p>

        <StatePanel
          v-if="salonsQuery.data.value.items.length === 0"
          eyebrow="File vide"
          title="Aucun dossier en attente"
          message="Tous les dossiers ont été traités ou aucun salon ne correspond aux filtres."
        />

        <div v-else class="bg-white rounded-2xl border border-outline-variant/40 divide-y divide-outline-variant/20 shadow-sm">
          <article
            v-for="salon in salonsQuery.data.value.items"
            :key="salon.id"
            class="p-5 hover:bg-neutral-bg/30 transition-all group flex items-center justify-between gap-8 first:rounded-t-2xl last:rounded-b-2xl relative cursor-pointer"
            :class="openDropdown === salon.id ? 'z-40' : 'z-10'"
            @click="router.push(`/admin/salons/${salon.id}`)"
          >
            <div class="flex-1 space-y-3">
              <div class="flex items-center gap-3">
                <h3 class="row-primary group-hover:text-primary transition-colors">
                  {{ salon.salonName }}
                </h3>
                <div class="flex gap-1.5">
                  <StatusBadge :value="salon.approvalStatus" class="scale-75 origin-left" />
                  <StatusBadge :value="salon.subscriptionIntentTier" class="scale-75 origin-left" />
                </div>
              </div>
              
              <div class="flex items-center gap-6 text-[12px] text-cocoa/60">
                <div class="flex items-center gap-1.5">
                  <span>{{ salon.city }}</span>
                </div>
                <div class="flex items-center gap-1.5">
                  <span>{{ salon.category }}</span>
                </div>
                <div class="flex items-center gap-1.5">
                  <span>Gérant: <span class="text-espresso/80">{{ salon.ownerName }}</span></span>
                </div>
              </div>

              <div v-if="salon.missingEvidence.length" class="inline-flex items-center gap-2 px-3 py-1.5 rounded bg-error/5 border border-error/10">
                <span class="text-[9px] font-bold uppercase text-error tracking-wider">Manquant:</span>
                <span class="text-[11px] text-error/80 font-medium">{{ salon.missingEvidence.join(", ") }}</span>
              </div>
            </div>

            <div class="shrink-0">
              <div class="relative" @click.stop>
                <button @click="toggleDropdown(salon.id)" class="btn-secondary px-4 py-2 rounded-full text-[12px] inline-flex items-center gap-1">
                  Dossier
                  <ChevronDownIcon class="w-3.5 h-3.5" :class="openDropdown === salon.id ? 'rotate-180' : ''" />
                </button>
                <div
                  v-if="openDropdown === salon.id"
                  class="absolute right-0 top-full mt-1 z-50 w-56 bg-white rounded-xl shadow-xl border border-outline-variant/60 py-1.5"
                >
                  <RouterLink :to="`/admin/salons/${salon.id}`" class="flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors">
                    <ArrowRightIcon class="w-4 h-4 text-cocoa/40" />
                    Voir le dossier
                  </RouterLink>
                  <button @click="quickAction(salon.id, 'approve')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors text-left">
                    <CheckCircleIcon class="w-4 h-4 text-primary" />
                    Approuver
                  </button>
                  <button @click="quickAction(salon.id, 'approve_premium')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-espresso font-medium hover:bg-neutral-bg/60 transition-colors text-left">
                    <StarIcon class="w-4 h-4 text-secondary" />
                    Approuver Premium
                  </button>
                  <button @click="quickAction(salon.id, 'reject')" class="w-full flex items-center gap-2.5 px-4 py-2.5 text-[13px] text-error font-medium hover:bg-error/5 transition-colors text-left border-t border-outline-variant/30 mt-1 pt-2">
                    <XCircleIcon class="w-4 h-4" />
                    Rejeter
                  </button>
                </div>
              </div>
            </div>
          </article>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="flex items-center justify-between pt-4">
          <p class="row-meta">
            Page {{ page + 1 }} sur {{ totalPages }} · {{ salonsQuery.data.value?.total ?? 0 }} dossiers
          </p>
          <div class="flex gap-2">
            <button
              :disabled="page === 0"
              class="btn-secondary px-4 py-2 rounded-full text-[11px] disabled:opacity-40"
              @click="page--"
            >
              Précédent
            </button>
            <button
              :disabled="page >= totalPages - 1"
              class="btn-secondary px-4 py-2 rounded-full text-[11px] disabled:opacity-40"
              @click="page++"
            >
              Suivant
            </button>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { refDebounced, useEventListener } from "@vueuse/core";
import {
  ArrowRightIcon,
  CheckCircleIcon,
  ChevronDownIcon,
  FunnelIcon,
  MagnifyingGlassIcon,
  MapPinIcon,
  PlusIcon,
  StarIcon,
  XCircleIcon
} from "@heroicons/vue/24/outline";

import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import { ApiError, approveSalonRequest, fetchSalons, rejectSalonRequest } from "@/lib/api";
import { toast } from "vue-sonner";
import { useAdminAuthStore } from "@/stores/adminAuth";
import { useRouter } from "vue-router";

const router = useRouter();

const auth = useAdminAuthStore();
const queryClient = useQueryClient();
const search = ref("");
const status = ref("pending_review");
const city = ref("");
const openDropdown = ref<string | null>(null);
const debouncedSearch = refDebounced(search, 250);
const debouncedCity = refDebounced(city, 250);
const page = ref(0);
const pageSize = 20;

const approveMutation = useMutation({
  mutationFn: ({ id, tier }: { id: string; tier: string }) =>
    tier === "premium"
      ? approveSalonRequest(auth.accessToken ?? "", id)
      : approveSalonRequest(auth.accessToken ?? "", id),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ["admin-salons"] });
    toast.success("Salon approuvé.");
  },
  onError: (e) => toast.error(e instanceof ApiError ? e.message : "Erreur.")
});

const rejectMutation = useMutation({
  mutationFn: (id: string) =>
    rejectSalonRequest(auth.accessToken ?? "", id, { reason: "Rejet depuis l'interface" }),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ["admin-salons"] });
    toast.success("Salon rejeté.");
  },
  onError: (e) => toast.error(e instanceof ApiError ? e.message : "Erreur.")
});

function toggleDropdown(id: string) {
  openDropdown.value = openDropdown.value === id ? null : id;
}

function quickAction(id: string, action: string) {
  openDropdown.value = null;
  if (action === "approve" || action === "approve_premium") {
    approveMutation.mutate({ id, tier: action === "approve_premium" ? "premium" : "standard" });
  } else if (action === "reject") {
    if (!confirm("Confirmer le rejet de ce salon ?")) return;
    rejectMutation.mutate(id);
  }
}

useEventListener(document, "click", () => { openDropdown.value = null; });

const salonsQuery = useQuery({
  queryKey: computed(() => ["admin-salons", debouncedSearch.value, status.value, debouncedCity.value, page.value]),
  queryFn: () =>
    fetchSalons(auth.accessToken ?? "", {
      search: debouncedSearch.value || undefined,
      status: status.value || undefined,
      city: debouncedCity.value || undefined,
      page: String(page.value),
      pageSize: String(pageSize)
    }),
  enabled: computed(() => Boolean(auth.accessToken))
});

watch([debouncedSearch, status, debouncedCity], () => { page.value = 0; });

const totalPages = computed(() => {
  const total = salonsQuery.data.value?.total ?? 0;
  return Math.ceil(total / pageSize);
});

const errorMessage = computed(() => {
  const error = salonsQuery.error.value;
  return error instanceof ApiError ? error.message : "Erreur de chargement.";
});
</script>
