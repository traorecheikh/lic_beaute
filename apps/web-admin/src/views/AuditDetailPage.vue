<template>
  <div class="space-y-8">
    <!-- Breadcrumb -->
    <div class="flex items-center justify-between">
      <RouterLink
        to="/admin/audit"
        class="group flex items-center gap-2 text-[11px] font-bold uppercase tracking-widest text-cocoa/40 hover:text-primary transition-colors"
      >
        <svg class="w-4 h-4 transition-transform group-hover:-translate-x-1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        Retour au journal
      </RouterLink>
    </div>

    <SkeletonLoader v-if="auditQuery.isLoading.value" variant="audit-detail" />
    <StatePanel v-else-if="auditQuery.isError.value" title="Événement introuvable" :message="errorMessage" action-label="Retour" @action="router.push('/admin/audit')" />

    <template v-else-if="auditQuery.data.value">
      <!-- Event Header Card -->
      <article class="bg-white rounded-3xl border border-outline-variant shadow-sm overflow-hidden">
        <div class="p-8 md:p-10">
          <div class="flex flex-wrap items-center gap-3 mb-4">
            <h2 class="entity-title">{{ auditQuery.data.value.summary }}</h2>
            <StatusBadge :value="auditQuery.data.value.severity" />
          </div>
          <div class="flex flex-wrap gap-5">
            <span class="row-meta">
              Acteur: <span class="text-espresso/70 font-semibold">{{ auditQuery.data.value.actorName }}</span>
            </span>
            <span class="row-meta">
              Cible: <span class="text-espresso/70 font-semibold">{{ auditQuery.data.value.entityType }} / {{ auditQuery.data.value.entityId }}</span>
            </span>
            <span class="row-meta tabular-nums">{{ formatDateTime(auditQuery.data.value.createdAt) }}</span>
            <span class="row-meta">
              Action: <span class="text-espresso/70 font-semibold font-mono text-[11px]">{{ auditQuery.data.value.action }}</span>
            </span>
          </div>
        </div>
      </article>

      <div class="grid gap-6 xl:grid-cols-[0.7fr_1.3fr]">
        <!-- Related Links -->
        <article class="panel-clean p-6">
          <h3 class="section-label mb-4">Liens corrélés</h3>
          <div class="grid gap-3">
            <RouterLink
              v-for="link in auditQuery.data.value.relatedLinks"
              :key="link.href"
              class="btn-secondary justify-start"
              :to="link.href"
            >
              {{ link.label }}
            </RouterLink>
          </div>
        </article>

        <!-- Payload -->
        <article class="panel-clean p-6">
          <h3 class="section-label mb-4">Payload</h3>
          <pre class="overflow-x-auto rounded-2xl bg-espresso p-5 text-[11px] leading-6 text-sand/80 font-mono">{{ auditQuery.data.value.payloadJson }}</pre>
        </article>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { useQuery } from "@tanstack/vue-query";
import { useRoute, useRouter } from "vue-router";

import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import { ApiError, fetchAuditDetail } from "@/lib/api";
import { formatDateTime } from "@/lib/date";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();
const route = useRoute();
const router = useRouter();

const auditId = computed(() => String(route.params.auditId));

const auditQuery = useQuery({
  queryKey: computed(() => ["admin-audit-detail", auditId.value]),
  queryFn: () => fetchAuditDetail(auth.accessToken ?? "", auditId.value),
  enabled: computed(() => Boolean(auth.accessToken))
});

const errorMessage = computed(() => {
  const error = auditQuery.error.value;
  return error instanceof ApiError ? error.message : "L'événement est indisponible.";
});
</script>
