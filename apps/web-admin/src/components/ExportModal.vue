<template>
  <Modal
    :show="show"
    title="Exporter les données"
    subtitle="Générez un rapport détaillé au format Excel"
    max-width="2xl"
    @close="$emit('close')"
  >
    <div class="space-y-6">
      <div class="grid grid-cols-2 gap-4">
        <button
          v-for="type in exportTypes"
          :key="type.id"
          class="p-4 rounded-2xl border-2 text-left transition-all"
          :class="selectedType === type.id ? 'border-primary bg-primary/5' : 'border-outline-variant hover:border-primary/20 bg-white'"
          @click="selectedType = type.id"
        >
          <p class="row-primary">{{ type.label }}</p>
          <p class="row-meta mt-1">{{ type.desc }}</p>
        </button>
      </div>

      <div class="space-y-3">
        <h4 class="section-label px-1">Prévisualisation (10 premières lignes)</h4>
        <div class="bg-neutral-bg/50 rounded-2xl border border-outline-variant overflow-hidden">
          <table class="min-w-full text-[10px] text-left">
            <thead class="bg-white/50 border-b border-outline-variant/40">
              <tr>
                <th v-for="h in previewHeaders" :key="h" class="px-4 py-2 font-bold uppercase tracking-wider text-cocoa/40">{{ h }}</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant/20">
              <tr v-if="isLoadingPreview">
                <td :colspan="previewHeaders.length || 1" class="px-4 py-3 text-cocoa/50 italic">Chargement...</td>
              </tr>
              <tr v-else-if="previewData.length === 0">
                <td :colspan="previewHeaders.length || 1" class="px-4 py-3 text-cocoa/50 italic">Aucune donnée à exporter.</td>
              </tr>
              <tr v-for="(row, i) in previewData" :key="i">
                <td v-for="(cell, j) in row" :key="`${i}-${j}`" class="px-4 py-2 text-espresso/70 truncate max-w-[120px]">{{ cell }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <template #footer>
      <div class="flex items-center justify-between">
        <p class="text-[11px] text-cocoa/40 italic">Total estimé: {{ totalRows }} lignes</p>
        <div class="flex items-center gap-3">
          <button class="btn-secondary" @click="$emit('close')">Annuler</button>
          <button class="btn-primary flex items-center gap-2" :disabled="isExporting" @click="handleExport">
            <svg v-if="isExporting" class="animate-spin w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>
            {{ isExporting ? 'Génération...' : 'Télécharger .xlsx' }}
          </button>
        </div>
      </div>
    </template>
  </Modal>
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import { toast } from "vue-sonner";

import { fetchAuditEvents, fetchSalons, fetchSubscriptions } from "@/lib/api";
import { downloadCsv } from "@/lib/download";
import { useAdminAuthStore } from "@/stores/adminAuth";

import Modal from "./Modal.vue";

defineProps<{ show: boolean }>();
const emit = defineEmits(["close"]);

const auth = useAdminAuthStore();

type ExportType = "salons" | "bookings" | "subscriptions" | "audit";

const selectedType = ref<ExportType>("salons");
const isExporting = ref(false);
const isLoadingPreview = ref(false);
const previewHeaders = ref<string[]>([]);
const previewData = ref<Array<Array<string | number>>>([]);
const totalRows = ref(0);

const exportTypes: Array<{ id: ExportType; label: string; desc: string }> = [
  { id: "salons", label: "Salons", desc: "Liste complète, statuts et contacts." },
  { id: "bookings", label: "Réservations", desc: "Événements liés aux réservations." },
  { id: "subscriptions", label: "Abonnements", desc: "Tiers, expirations et facturation." },
  { id: "audit", label: "Logs Audit", desc: "Actions système et sécurité." }
];

function ensureToken() {
  const token = auth.accessToken ?? "";
  if (!token) {
    throw new Error("Session expirée. Reconnectez-vous.");
  }
  return token;
}

async function getRows(type: ExportType) {
  const token = ensureToken();

  if (type === "salons") {
    const response = await fetchSalons(token, {});
    return {
      headers: ["ID", "Nom", "Catégorie", "Ville", "Statut", "Propriétaire", "Date de soumission"],
      rows: response.items.map((salon) => [
        salon.id,
        salon.salonName,
        salon.category,
        salon.city,
        salon.approvalStatus,
        salon.ownerName,
        salon.submittedAt
      ])
    };
  }

  if (type === "subscriptions") {
    const response = await fetchSubscriptions(token, {});
    return {
      headers: ["ID", "Salon", "Tier", "Statut", "Auto-renouvellement", "Expiration"],
      rows: response.items.map((subscription) => [
        subscription.id,
        subscription.salonName,
        subscription.tier,
        subscription.status,
        subscription.autoRenew ? "Oui" : "Non",
        subscription.expiresAt ?? ""
      ])
    };
  }

  if (type === "bookings") {
    const byEntityType = await fetchAuditEvents(token, { entityType: "booking" });
    const source = byEntityType.items.length > 0 ? byEntityType : await fetchAuditEvents(token, { action: "booking" });

    return {
      headers: ["ID événement", "Action", "Résumé", "Réservation", "Acteur", "Date"],
      rows: source.items.map((event) => [
        event.id,
        event.action,
        event.summary,
        event.entityId,
        event.actorName,
        event.createdAt
      ])
    };
  }

  const response = await fetchAuditEvents(token, {});
  return {
    headers: ["ID", "Action", "Résumé", "Entité", "Acteur", "Date"],
    rows: response.items.map((event) => [
      event.id,
      event.action,
      event.summary,
      `${event.entityType}:${event.entityId}`,
      event.actorName,
      event.createdAt
    ])
  };
}

async function refreshPreview() {
  isLoadingPreview.value = true;
  try {
    const result = await getRows(selectedType.value);
    previewHeaders.value = result.headers;
    previewData.value = result.rows.slice(0, 10);
    totalRows.value = result.rows.length;
  } catch (error) {
    previewHeaders.value = ["Erreur"];
    previewData.value = [[error instanceof Error ? error.message : "Erreur lors du chargement."]];
    totalRows.value = 0;
  } finally {
    isLoadingPreview.value = false;
  }
}

async function handleExport() {
  isExporting.value = true;
  try {
    const result = await getRows(selectedType.value);
    const date = new Date().toISOString().slice(0, 10);
    downloadCsv(`beauteavenue-${selectedType.value}-${date}.csv`, result.headers, result.rows);
    toast.success("Rapport exporté avec succès.");
    emit("close");
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Export impossible.");
  } finally {
    isExporting.value = false;
  }
}

watch(selectedType, () => {
  void refreshPreview();
}, { immediate: true });
</script>
