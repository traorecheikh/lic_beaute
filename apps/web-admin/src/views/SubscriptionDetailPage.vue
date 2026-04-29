<template>
  <div class="space-y-8">
    <!-- Breadcrumb -->
    <div class="flex items-center justify-between">
      <RouterLink
        to="/admin/subscriptions"
        class="group flex items-center gap-2 text-[11px] font-bold uppercase tracking-widest text-cocoa/40 hover:text-secondary transition-colors"
      >
        <svg class="w-4 h-4 transition-transform group-hover:-translate-x-1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        Retour aux abonnements
      </RouterLink>

      <div class="flex items-center gap-2">
        <p class="text-[10px] font-bold text-cocoa/30 uppercase tracking-[0.2em]">ID:</p>
        <p class="text-[10px] font-mono font-bold text-espresso/40 bg-white px-2 py-0.5 rounded border border-outline-variant">{{ subscriptionId.substring(0, 8) }}</p>
      </div>
    </div>

    <SkeletonLoader v-if="subscriptionQuery.isLoading.value" variant="subscription-detail" />
    <StatePanel
      v-else-if="subscriptionQuery.isError.value"
      :title="errorTitle"
      :message="errorMessage"
      action-label="Retour"
      @action="router.push('/admin/subscriptions')"
    />

    <template v-else-if="subscriptionQuery.data.value">
      <!-- Main Banner -->
      <article class="bg-white rounded-3xl border border-outline-variant shadow-sm overflow-hidden">
        <div class="p-8 md:p-10 border-b border-outline-variant/30 flex flex-col lg:flex-row lg:items-center justify-between gap-8">
          <div class="space-y-4">
            <div class="flex flex-wrap items-center gap-3">
              <h2 class="entity-title">{{ subscriptionQuery.data.value.salonName }}</h2>
              <StatusBadge :value="subscriptionQuery.data.value.tier" />
              <StatusBadge :value="subscriptionQuery.data.value.status" />
            </div>
            <div class="flex flex-wrap items-center gap-6">
              <span class="row-meta">
                <span class="text-[10px] font-bold uppercase tracking-widest text-cocoa/40 mr-1.5">Fournisseur:</span>
                {{ subscriptionQuery.data.value.billingProvider ?? "Manuel" }}
              </span>
              <span class="row-meta">
                <span class="text-[10px] font-bold uppercase tracking-widest text-cocoa/40 mr-1.5">Renouv. auto:</span>
                {{ subscriptionQuery.data.value.autoRenew ? "Actif" : "Inactif" }}
              </span>
            </div>
          </div>

          <!-- Timeline -->
          <div class="grid grid-cols-2 sm:grid-cols-3 gap-8 bg-sand/30 p-6 rounded-2xl border border-outline-variant/60">
            <div class="space-y-1">
              <p class="section-label">Début</p>
              <p class="row-primary tabular-nums">{{ formatDateShort(subscriptionQuery.data.value.startedAt) }}</p>
            </div>
            <div class="space-y-1">
              <p class="section-label">Échéance</p>
              <p class="row-primary tabular-nums">{{ subscriptionQuery.data.value.expiresAt ? formatDateShort(subscriptionQuery.data.value.expiresAt) : "Illimité" }}</p>
            </div>
            <div class="space-y-1">
              <p class="section-label">Dernier Renouv.</p>
              <p class="row-primary tabular-nums">{{ subscriptionQuery.data.value.renewedAt ? formatDateShort(subscriptionQuery.data.value.renewedAt) : "Jamais" }}</p>
            </div>
          </div>
        </div>
      </article>

      <div class="grid grid-cols-12 gap-8">
        <div class="col-span-12 lg:col-span-7 space-y-8">
          <!-- Entitlements -->
          <section class="space-y-4">
            <h3 class="section-label px-2">Services Inclus</h3>
            <div class="grid gap-3">
              <article
                v-for="entitlement in subscriptionQuery.data.value.entitlements"
                :key="entitlement.label"
                class="bg-white rounded-2xl border border-outline-variant p-5 flex items-center justify-between group hover:border-secondary/30 transition-colors"
              >
                <div class="space-y-1">
                  <p class="row-primary">{{ entitlement.label }}</p>
                  <p v-if="entitlement.note" class="row-meta italic">{{ entitlement.note }}</p>
                </div>
                <StatusBadge :value="entitlement.enabled ? 'verified' : 'pending'" />
              </article>
            </div>
          </section>

          <!-- History -->
          <section class="space-y-4">
            <h3 class="section-label px-2">Historique</h3>
            <div class="bg-white rounded-2xl border border-outline-variant overflow-hidden divide-y divide-outline-variant/30">
              <article
                v-for="event in subscriptionQuery.data.value.events"
                :key="event.id"
                class="p-5 hover:bg-sand/20 transition-colors"
              >
                <div class="flex items-center justify-between mb-1.5">
                  <p class="row-primary">{{ event.summary }}</p>
                  <span class="row-meta tabular-nums">{{ formatDateShort(event.createdAt) }}</span>
                </div>
                <p class="row-meta">Par <span class="font-semibold text-espresso/70">{{ event.actorName }}</span> • {{ event.payloadPreview }}</p>
              </article>
            </div>
          </section>
        </div>

        <div class="col-span-12 lg:col-span-5 space-y-8">
          <!-- Support Console -->
          <section class="bg-white rounded-3xl border border-outline-variant p-8 space-y-6 shadow-sm">
            <div class="space-y-1">
              <h3 class="section-label">Support & Régularisation</h3>
              <h4 class="entity-title">Ajustement exceptionnel</h4>
            </div>

            <!-- Context Snapshot -->
            <div class="p-5 rounded-2xl bg-sand/40 border border-outline-variant/60 space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <p class="section-label mb-1">Mode</p>
                  <p class="row-primary capitalize">{{ subscriptionQuery.data.value.billingProvider ?? 'Local / Manuel' }}</p>
                </div>
                <div>
                  <p class="section-label mb-1">Restant</p>
                  <p class="row-primary">{{ remainingDaysLabel }}</p>
                </div>
              </div>
            </div>

            <form class="space-y-5" @submit.prevent="submitOverride">
              <div class="space-y-2">
                <span class="section-label px-1">Action souhaitée</span>
                <select v-model="overrideAction" class="input-shell text-[13px] rounded-xl h-12">
                  <option value="grant_complimentary_premium">Offrir Premium (Geste Commercial)</option>
                  <option value="extend_expiry">Prolonger l'accès manuellement</option>
                  <option value="pause_subscription">Suspendre l'abonnement</option>
                  <option value="resume_subscription">Rétablir l'accès</option>
                  <option value="downgrade_to_standard">Rétrograder vers Standard</option>
                  <option value="terminate_subscription">Résilier le contrat</option>
                  <option value="mark_charge_resolved">Régulariser un paiement (Cash/Virement)</option>
                </select>
                <p class="row-meta px-1 leading-tight italic">{{ actionEffectDescription }}</p>
              </div>

              <div class="space-y-4">
                <div class="space-y-2">
                  <span class="section-label px-1">Motif de l'ajustement</span>
                  <select v-model="selectedReasonKey" class="input-shell text-[13px] rounded-xl h-12">
                    <option v-for="reason in reasons" :key="reason.id" :value="reason.id">
                      {{ reason.label }} {{ reason.requiresFile ? '📎' : '' }}
                    </option>
                    <option value="custom">Autre motif (Saisie manuelle)...</option>
                  </select>
                </div>

                <div v-if="requiresFile" class="space-y-2 animate-in fade-in slide-in-from-top-1 duration-200">
                  <span class="section-label px-1">Pièce justificative (Requise)</span>
                  <label class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-outline-variant rounded-2xl cursor-pointer hover:bg-sand/20 transition-all group overflow-hidden relative">
                    <div v-if="!selectedFile" class="flex flex-col items-center justify-center pt-5 pb-6">
                      <svg class="w-8 h-8 mb-2 text-cocoa/20 group-hover:text-primary transition-colors" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                      <p class="section-label">Choisir un fichier</p>
                    </div>
                    <div v-else class="flex items-center gap-3 px-4">
                      <div class="w-10 h-10 rounded-lg bg-green-50 flex items-center justify-center text-green-600">
                        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/></svg>
                      </div>
                      <div class="min-w-0">
                        <p class="row-primary truncate max-w-[200px]">{{ selectedFile.name }}</p>
                        <p class="section-label">{{ (selectedFile.size / 1024).toFixed(1) }} KB</p>
                      </div>
                      <button type="button" class="ml-auto text-error hover:scale-110 transition-transform" @click.stop.prevent="selectedFile = null">
                        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 6L6 18M6 6l12 12"/></svg>
                      </button>
                    </div>
                    <input type="file" class="hidden" @change="handleFileChange" accept="image/*,.pdf" />
                  </label>
                </div>

                <div v-if="selectedReasonKey === 'custom'" class="space-y-2 animate-in fade-in slide-in-from-top-1 duration-200">
                  <span class="section-label px-1">Précisez le motif</span>
                  <textarea v-model="customReason" class="input-shell min-h-[80px] text-[13px] rounded-xl py-3" placeholder="Détaillez la raison ici..." />
                </div>
              </div>

              <div v-if="['grant_complimentary_premium', 'extend_expiry'].includes(overrideAction)" class="grid grid-cols-2 gap-4">
                <div class="space-y-2">
                  <span class="section-label px-1">Date d'effet</span>
                  <input v-model="effectiveAt" class="input-shell text-[12px] rounded-xl h-11" type="datetime-local" />
                </div>
                <div class="space-y-2">
                  <span class="section-label px-1">Nouvelle Expiration</span>
                  <input v-model="expiresAt" class="input-shell text-[12px] rounded-xl h-11" type="datetime-local" />
                </div>
              </div>

              <div class="pt-4 border-t border-outline-variant/40">
                <button
                  type="submit"
                  class="w-full btn-gold h-12 font-bold shadow-lg shadow-secondary/10 disabled:opacity-50"
                  :disabled="overrideMutation.isPending.value"
                >
                  {{ overrideMutation.isPending.value ? "Application..." : "Appliquer l'ajustement" }}
                </button>
              </div>
            </form>
          </section>

          <!-- Invoices -->
          <section class="space-y-4">
            <h3 class="section-label px-2">Facturation</h3>
            <div class="space-y-3">
              <article
                v-for="invoice in subscriptionQuery.data.value.invoices"
                :key="invoice.id"
                class="bg-white rounded-2xl border border-outline-variant p-5 flex items-center justify-between group hover:border-secondary/30 transition-colors"
              >
                <div>
                  <p class="row-primary">{{ invoice.invoiceNumber }}</p>
                  <p class="row-meta tabular-nums">{{ formatMoneyXof(invoice.amountXof) }}</p>
                </div>
                <div class="flex items-center gap-4">
                  <StatusBadge :value="invoice.status" />
                  <a :href="invoice.pdfUrl" target="_blank" rel="noreferrer" class="w-8 h-8 rounded-full bg-sand flex items-center justify-center text-cocoa/40 hover:bg-secondary/10 hover:text-secondary transition-all">
                    <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                  </a>
                </div>
              </article>
            </div>
          </section>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";

import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import { ApiError, fetchSubscriptionDetail, overrideSubscription } from "@/lib/api";
import { getErrorMessage } from "@/lib/errors";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();
const route = useRoute();
const router = useRouter();
const queryClient = useQueryClient();

const subscriptionId = computed(() => String(route.params.subscriptionId));
const overrideAction = ref<
  | "grant_complimentary_premium"
  | "extend_expiry"
  | "downgrade_to_standard"
  | "pause_subscription"
  | "resume_subscription"
  | "terminate_subscription"
  | "mark_charge_resolved"
>("grant_complimentary_premium");

const reasons = [
  { id: "commercial_gesture", label: "Geste commercial / Fidélisation", requiresFile: false },
  { id: "technical_incident", label: "Compensation incident technique", requiresFile: false },
  { id: "manual_payment", label: "Paiement reçu (Virement/Chèque/Espèces)", requiresFile: true },
  { id: "partnership", label: "Partenariat / Influenceur", requiresFile: true },
  { id: "migration_old_system", label: "Migration ancien système", requiresFile: true },
  { id: "fraud_check", label: "Suspension pour vérification (Fraude)", requiresFile: true },
  { id: "admin_regularization", label: "Régularisation administrative", requiresFile: true },
  { id: "sponsorship", label: "Parrainage (Sponsoring)", requiresFile: false },
  { id: "test_account", label: "Compte de test / Démonstration", requiresFile: false }
] as const;

const selectedReasonKey = ref<string>("commercial_gesture");
const customReason = ref("");
const effectiveAt = ref("");
const expiresAt = ref("");
const internalTicket = ref("");
const selectedFile = ref<File | null>(null);
const mutationError = ref("");

const requiresFile = computed(() => {
  const reason = reasons.find(r => r.id === selectedReasonKey.value);
  return reason?.requiresFile ?? false;
});

const subscriptionQuery = useQuery({
  queryKey: computed(() => ["admin-subscription-detail", subscriptionId.value]),
  queryFn: () => fetchSubscriptionDetail(auth.accessToken ?? "", subscriptionId.value),
  enabled: computed(() => Boolean(auth.accessToken))
});

const remainingDaysLabel = computed(() => {
  if (!subscriptionQuery.data.value?.expiresAt) return "Indéfini";
  const diff = new Date(subscriptionQuery.data.value.expiresAt).getTime() - Date.now();
  const days = Math.ceil(diff / (1000 * 60 * 60 * 24));
  return days > 0 ? `${days} jours` : "Expiré";
});

const actionEffectDescription = computed(() => {
  const map: Record<string, string> = {
    grant_complimentary_premium: "Active les droits Premium sans transaction monétaire externe.",
    extend_expiry: "Repousse la date d'échéance du contrat actuel.",
    pause_subscription: "Désactive l'accès aux services immédiatement.",
    resume_subscription: "Rétablit l'accès après une suspension.",
    downgrade_to_standard: "Retire les avantages Premium (Mise en avant, etc).",
    terminate_subscription: "Fermeture définitive du compte abonné.",
    mark_charge_resolved: "Valide manuellement une facture en attente."
  };
  return map[overrideAction.value] ?? "";
});

function handleFileChange(e: Event) {
  const target = e.target as HTMLInputElement;
  if (target.files?.length) {
    selectedFile.value = target.files[0];
  }
}

const overrideMutation = useMutation({
  mutationFn: async () => {
    const reasonObj = reasons.find(r => r.id === selectedReasonKey.value);
    const finalReason = selectedReasonKey.value === 'custom'
      ? customReason.value.trim()
      : (reasonObj?.label ?? "Ajustement support");

    return overrideSubscription(auth.accessToken ?? "", subscriptionId.value, {
      action: overrideAction.value,
      reason: finalReason,
      effectiveAt: effectiveAt.value ? new Date(effectiveAt.value).toISOString() : undefined,
      expiresAt: expiresAt.value ? new Date(expiresAt.value).toISOString() : undefined,
      metadata: {
        internalTicket: internalTicket.value || undefined
      }
    });
  },
  onSuccess: async () => {
    mutationError.value = "";
    await queryClient.invalidateQueries({ queryKey: ["admin-subscription-detail", subscriptionId.value] });
    await queryClient.invalidateQueries({ queryKey: ["admin-subscriptions"] });
    toast.success("Ajustement appliqué.");
    selectedFile.value = null;
    customReason.value = "";
  },
  onError: (error) => {
    mutationError.value = getErrorMessage(error, "Erreur lors de l'ajustement.");
    toast.error(mutationError.value);
  }
});

const errorMessage = computed(() => {
  const error = subscriptionQuery.error.value;

  if (error instanceof ApiError && error.code === "subscription_not_found") {
    return `Aucun abonnement ne correspond à l'identifiant ${subscriptionId.value}. Vérifiez le lien ouvert ou revenez à la liste.`;
  }

  return error instanceof ApiError ? error.message : "Détail indisponible.";
});

const errorTitle = computed(() => {
  const error = subscriptionQuery.error.value;
  return error instanceof ApiError && error.code === "subscription_not_found"
    ? "Abonnement introuvable"
    : "Détail indisponible";
});

function submitOverride() {
  if (selectedReasonKey.value === 'custom' && !customReason.value.trim()) {
    toast.error("Veuillez préciser le motif manuellement.");
    return;
  }
  if (requiresFile.value && !selectedFile.value) {
    toast.error("Une pièce justificative est obligatoire pour ce motif.");
    return;
  }
  overrideMutation.mutate();
}

const formatDateShort = (d: string) => {
  const date = new Date(d);
  return date.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric' });
};
</script>
