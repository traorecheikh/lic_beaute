<template>
  <div class="max-w-xl mx-auto py-16 px-4 text-center">
    <template v-if="salonQuery.isLoading.value">
      <div class="animate-pulse h-6 w-48 bg-outline-variant rounded mx-auto mb-4"></div>
      <div class="animate-pulse h-4 w-64 bg-outline-variant/50 rounded mx-auto"></div>
    </template>
    <template v-else-if="salon">
      <div class="panel-clean p-10">
        <template v-if="salon.approvalStatus === 'approved'">
          <div class="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-6">
            <CheckCircleIcon class="w-8 h-8 text-primary" />
          </div>
          <h2 class="entity-title mb-2">Salon approuvé !</h2>
          <p class="row-meta mb-6">Votre salon est actif. Vous serez redirigé vers le calendrier…</p>
        </template>
        <template v-else-if="salon.approvalStatus === 'needs_info'">
          <div class="w-16 h-16 rounded-full bg-amber-100 flex items-center justify-center mx-auto mb-6">
            <ExclamationTriangleIcon class="w-8 h-8 text-amber-600" />
          </div>
          <h2 class="entity-title mb-2">Informations requises</h2>
          <p class="row-meta mb-4">L'équipe BeautéAvenue a besoin de documents supplémentaires pour valider votre salon.</p>
          <p v-if="salon.latestAdminNote" class="text-sm text-espresso bg-amber-50 rounded-xl p-4 text-left mb-6">{{ salon.latestAdminNote }}</p>
        </template>
        <template v-else-if="salon.approvalStatus === 'rejected'">
          <div class="w-16 h-16 rounded-full bg-error/10 flex items-center justify-center mx-auto mb-6">
            <XCircleIcon class="w-8 h-8 text-error" />
          </div>
          <h2 class="entity-title mb-2">Demande refusée</h2>
          <p v-if="salon.latestAdminNote" class="row-meta mb-4">{{ salon.latestAdminNote }}</p>
          <p class="row-meta">Pour toute question, contactez notre support.</p>
        </template>
        <template v-else>
          <div class="w-16 h-16 rounded-full bg-outline-variant/30 flex items-center justify-center mx-auto mb-6">
            <ClockIcon class="w-8 h-8 text-cocoa/40" />
          </div>
          <h2 class="entity-title mb-2">Demande en cours d'examen</h2>
          <p class="row-meta">Notre équipe examine votre dossier. Vous recevrez un email dès validation.</p>
        </template>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, watch } from "vue";
import { useRouter } from "vue-router";
import { useQuery } from "@tanstack/vue-query";
import { CheckCircleIcon, ExclamationTriangleIcon, XCircleIcon, ClockIcon } from "@heroicons/vue/24/outline";

import { fetchProSalon } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();
const router = useRouter();

const salonQuery = useQuery({
  queryKey: ["pro-salon", "approval"],
  queryFn: () => fetchProSalon(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken)),
  refetchInterval: 30_000
});

const salon = computed(() => salonQuery.data.value as (typeof salonQuery.data.value & { approvalStatus?: string; latestAdminNote?: string | null }) | undefined);

watch(
  () => salon.value?.approvalStatus,
  (status) => {
    if (status === "approved") {
      setTimeout(() => router.replace("/pro/calendar"), 3000);
    }
  },
  { immediate: true }
);
</script>
