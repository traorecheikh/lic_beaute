<template>
  <div class="space-y-8">
    <header class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <h2 class="page-title">Journal d'audit</h2>

      <div class="flex flex-col sm:flex-row gap-3">
        <div class="relative">
          <input
            v-model="actor"
            class="input-shell min-w-[200px] bg-white h-10 border-outline-variant/60 rounded-full text-[12px] pl-9 pr-4"
            placeholder="Acteur..."
          />
          <UserIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40 pointer-events-none" />
        </div>
        <div class="relative">
          <input
            v-model="entityType"
            class="input-shell min-w-[200px] bg-white h-10 border-outline-variant/60 rounded-full text-[12px] pl-9 pr-4"
            placeholder="Entité..."
          />
          <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40 pointer-events-none" />
        </div>
      </div>
    </header>

    <SkeletonLoader v-if="auditQuery.isLoading.value" variant="audit-list" />
    <StatePanel v-else-if="auditQuery.isError.value" title="Erreur" :message="errorMessage" action-label="Réessayer" @action="auditQuery.refetch" />

    <template v-else-if="auditQuery.data.value">
      <StatePanel
        v-if="auditQuery.data.value.items.length === 0"
        eyebrow="Journal vide"
        title="Aucun événement trouvé"
        message="Aucune action admin n'a encore été enregistrée, ou les filtres actuels ne correspondent à rien."
      />

      <div v-else class="space-y-3">
        <div
          v-for="event in auditQuery.data.value.items"
          :key="event.id"
          class="bg-white hover:bg-neutral-bg/30 p-5 rounded-2xl border border-outline-variant/40 shadow-sm transition-all"
        >
          <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div class="space-y-2 flex-1">
              <div class="flex flex-wrap items-center gap-3">
                <p class="row-primary">{{ event.summary }}</p>
                <StatusBadge :value="event.severity" />
              </div>
              <div class="flex flex-wrap items-center gap-5">
                <span class="row-meta">Acteur: <span class="text-espresso/70 font-semibold">{{ event.actorName }}</span></span>
                <span class="row-meta">Cible: <span class="text-espresso/70 font-semibold">{{ event.entityType }}</span></span>
                <span class="row-meta tabular-nums">{{ formatDateTime(event.createdAt) }}</span>
              </div>
            </div>
            <div class="shrink-0">
              <RouterLink
                :to="`/admin/audit/${event.id}`"
                class="btn-secondary px-6 py-2 rounded-full text-[11px]"
              >
                Inspecter
              </RouterLink>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useQuery } from "@tanstack/vue-query";
import { refDebounced } from "@vueuse/core";
import { MagnifyingGlassIcon, UserIcon } from "@heroicons/vue/24/outline";

import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import { ApiError, fetchAuditEvents } from "@/lib/api";
import { formatDateTime } from "@/lib/date";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();
const actor = ref("");
const entityType = ref("");
const action = ref("");
const debouncedActor = refDebounced(actor, 250);
const debouncedEntityType = refDebounced(entityType, 250);
const debouncedAction = refDebounced(action, 250);

const auditQuery = useQuery({
  queryKey: computed(() => ["admin-audit", debouncedActor.value, debouncedEntityType.value, debouncedAction.value]),
  queryFn: () =>
    fetchAuditEvents(auth.accessToken ?? "", {
      actor: debouncedActor.value || undefined,
      entityType: debouncedEntityType.value || undefined,
      action: debouncedAction.value || undefined
    }),
  enabled: computed(() => Boolean(auth.accessToken))
});

const errorMessage = computed(() => {
  const error = auditQuery.error.value;
  return error instanceof ApiError ? error.message : "Erreur de chargement.";
});
</script>
