<template>
  <div class="space-y-8">
    <header class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <h2 class="page-title">Journal d'audit</h2>

      <div class="flex flex-col gap-3">
        <div class="inline-flex rounded-full border border-outline-variant/60 bg-white p-1 w-fit">
          <button
            type="button"
            class="rounded-full px-4 py-1.5 text-[11px] font-semibold transition"
            :class="auditMode === 'system' ? 'bg-espresso text-white' : 'text-cocoa/70 hover:text-espresso'"
            @click="auditMode = 'system'"
          >
            Système
          </button>
          <button
            type="button"
            class="rounded-full px-4 py-1.5 text-[11px] font-semibold transition"
            :class="auditMode === 'email' ? 'bg-espresso text-white' : 'text-cocoa/70 hover:text-espresso'"
            @click="auditMode = 'email'"
          >
            Emails
          </button>
        </div>

        <div v-if="auditMode === 'system'" class="flex flex-col sm:flex-row flex-wrap gap-3">
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
          <select v-model="actionFilter" class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4">
            <option value="">Toutes actions</option>
            <option value="create">Création</option>
            <option value="update">Modification</option>
            <option value="delete">Suppression</option>
            <option value="approve">Approbation</option>
            <option value="reject">Refus</option>
          </select>
          <input
            v-model="fromDate"
            type="date"
            class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4"
          />
          <input
            v-model="toDate"
            type="date"
            class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4"
          />
        </div>

        <div v-else class="flex flex-col sm:flex-row flex-wrap gap-3">
          <div class="relative">
            <input
              v-model="emailTo"
              class="input-shell min-w-[240px] bg-white h-10 border-outline-variant/60 rounded-full text-[12px] pl-9 pr-4"
              placeholder="Destinataire..."
            />
            <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40 pointer-events-none" />
          </div>
          <select v-model="emailDriver" class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4">
            <option value="">Tous drivers</option>
            <option value="smtp">SMTP</option>
            <option value="brevo">Brevo API</option>
            <option value="resend">Resend</option>
            <option value="noop">Noop</option>
          </select>
          <select v-model="emailStatus" class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4">
            <option value="">Tous statuts</option>
            <option value="sent">Envoyé</option>
            <option value="failed">Échec</option>
            <option value="skipped">Ignoré</option>
          </select>
        </div>
      </div>
    </header>

    <SkeletonLoader v-if="activeQuery.isLoading.value" variant="audit-list" />
    <StatePanel v-else-if="activeQuery.isError.value" title="Erreur" :message="errorMessage" action-label="Réessayer" @action="activeQuery.refetch" />

    <template v-else-if="activeQuery.data.value">
      <StatePanel
        v-if="activeQuery.data.value.items.length === 0"
        eyebrow="Journal vide"
        title="Aucun événement trouvé"
        :message="auditMode === 'system'
          ? `Aucune action admin n'a encore été enregistrée, ou les filtres actuels ne correspondent à rien.`
          : `Aucun log email ne correspond aux filtres actuels.`"
      />

      <div v-else-if="auditMode === 'system'" class="space-y-3">
        <div
          v-for="event in auditQuery.data.value?.items"
          :key="event.id"
          class="bg-white hover:bg-neutral-bg/30 p-5 rounded-2xl border border-outline-variant/40 shadow-sm transition-all cursor-pointer"
          @click="router.push(`/admin/audit/${event.id}`)"
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

      <div v-else class="space-y-3">
        <div
          v-for="event in emailAuditQuery.data.value?.items ?? []"
          :key="event.id"
          class="bg-white p-5 rounded-2xl border border-outline-variant/40 shadow-sm"
        >
          <div class="flex flex-col gap-3">
            <div class="flex flex-wrap items-center gap-3">
              <p class="row-primary truncate max-w-[400px]">{{ event.subject || '(sans objet)' }}</p>
              <StatusBadge :value="event.status === 'failed' ? 'critical' : event.status === 'sent' ? 'info' : 'warning'" />
            </div>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-[12px]">
              <div>
                <p class="font-bold text-cocoa/50 uppercase tracking-wider text-[10px] mb-0.5">Destinataire</p>
                <p class="text-espresso font-semibold">{{ event.to }}</p>
              </div>
              <div>
                <p class="font-bold text-cocoa/50 uppercase tracking-wider text-[10px] mb-0.5">Driver</p>
                <p class="row-meta">{{ event.driver }}</p>
              </div>
              <div>
                <p class="font-bold text-cocoa/50 uppercase tracking-wider text-[10px] mb-0.5">Statut</p>
                <p class="row-meta">{{ { sent: 'Envoyé', failed: 'Échec', skipped: 'Ignoré' }[event.status] ?? event.status }}</p>
              </div>
              <div>
                <p class="font-bold text-cocoa/50 uppercase tracking-wider text-[10px] mb-0.5">Date</p>
                <p class="row-meta tabular-nums">{{ formatDateTime(event.createdAt) }}</p>
              </div>
            </div>
            <p v-if="event.errorMessage" class="text-[12px] font-bold text-error bg-error/5 px-3 py-2 rounded-lg flex items-center gap-2">
              <InformationCircleIcon class="w-4 h-4 shrink-0" />
              {{ event.errorMessage }}
            </p>
          </div>
        </div>
      </div>
    </template>

    <!-- Pagination -->
    <div v-if="totalPages > 1" class="flex items-center justify-between pt-4">
      <p class="row-meta">
        Page {{ page + 1 }} sur {{ totalPages }} · {{ activeQuery.data.value?.total ?? 0 }} événements
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

<script setup lang="ts">
import { computed, ref, watch } from "vue";
import { useQuery } from "@tanstack/vue-query";
import { refDebounced } from "@vueuse/core";
import { InformationCircleIcon, MagnifyingGlassIcon, UserIcon } from "@heroicons/vue/24/outline";

import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import { ApiError, fetchAuditEvents, fetchEmailAuditEvents } from "@/lib/api";
import { formatDateTime } from "@/lib/date";
import { useAdminAuthStore } from "@/stores/adminAuth";
import { useRouter } from "vue-router";

const router = useRouter();
const auth = useAdminAuthStore();
const auditMode = ref<"system" | "email">("system");
const actor = ref("");
const entityType = ref("");
const actionFilter = ref("");
const fromDate = ref("");
const toDate = ref("");
const emailTo = ref("");
const emailDriver = ref("");
const emailStatus = ref("");
const debouncedActor = refDebounced(actor, 250);
const debouncedEntityType = refDebounced(entityType, 250);
const debouncedEmailTo = refDebounced(emailTo, 250);
const page = ref(0);
const pageSize = 50;

watch([debouncedActor, debouncedEntityType, actionFilter, fromDate, toDate, auditMode], () => { page.value = 0; });

const auditQuery = useQuery({
  queryKey: computed(() => ["admin-audit", debouncedActor.value, debouncedEntityType.value, actionFilter.value, fromDate.value, toDate.value, page.value]),
  queryFn: () =>
    fetchAuditEvents(auth.accessToken ?? "", {
      actor: debouncedActor.value || undefined,
      entityType: debouncedEntityType.value || undefined,
      action: actionFilter.value || undefined,
      from: fromDate.value || undefined,
      to: toDate.value || undefined,
      page: String(page.value),
      pageSize: String(pageSize)
    }),
  enabled: computed(() => Boolean(auth.accessToken) && auditMode.value === "system")
});

const emailAuditQuery = useQuery({
  queryKey: computed(() => ["admin-email-audit", debouncedEmailTo.value, emailDriver.value, emailStatus.value, page.value]),
  queryFn: () =>
    fetchEmailAuditEvents(auth.accessToken ?? "", {
      to: debouncedEmailTo.value || undefined,
      driver: emailDriver.value || undefined,
      status: emailStatus.value || undefined,
      page: String(page.value),
      pageSize: String(pageSize)
    }),
  enabled: computed(() => Boolean(auth.accessToken) && auditMode.value === "email")
});

const activeQuery = computed(() => (auditMode.value === "system" ? auditQuery : emailAuditQuery));

const totalPages = computed(() => {
  const total = activeQuery.value.data.value?.total ?? 0;
  return Math.ceil(total / pageSize);
});

const errorMessage = computed(() => {
  const error = activeQuery.value.error.value;
  return error instanceof ApiError ? error.message : "Erreur de chargement.";
});
</script>
