<template>
  <div class="space-y-8">
    <!-- Breadcrumbs -->
    <div class="flex items-center justify-between">
      <RouterLink 
        to="/admin/salons" 
        class="group flex items-center gap-2 text-[11px] font-bold uppercase tracking-widest text-cocoa/70 hover:text-primary transition-colors"
      >
        <svg class="w-4 h-4 transition-transform group-hover:-translate-x-1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        Retour à la file
      </RouterLink>

      <div class="flex items-center gap-2">
      <p class="text-[10px] font-bold text-cocoa/70 uppercase tracking-[0.2em]">Dossier:</p>
      <p class="text-[10px] font-mono font-bold text-espresso/40 bg-white px-2 py-0.5 rounded border border-outline-variant">{{ salonId.substring(0, 8) }}</p>
      <RouterLink
        v-if="salonQuery.data.value?.subscriptionId"
        :to="`/admin/subscriptions/${salonQuery.data.value.subscriptionId}`"
        class="ml-4 text-[10px] font-bold uppercase tracking-widest text-primary hover:text-primary/80 transition-colors"
      >
        Voir l'abonnement →
      </RouterLink>

      </div>

    </div>

    <SkeletonLoader v-if="salonQuery.isLoading.value" variant="salon-detail" />

    <StatePanel
      v-else-if="salonQuery.isError.value"
      title="Dossier introuvable"
      :message="errorMessage"
      action-label="Retour"
      @action="router.push('/admin/salons')"
    />

    <template v-else-if="salonQuery.data.value">
      <!-- Main Profile Card -->
      <article class="bg-white rounded-3xl border border-outline-variant shadow-sm overflow-hidden">
        <div class="p-8 md:p-10 border-b border-outline-variant/30 flex flex-col md:flex-row md:items-center justify-between gap-8">
          <div class="space-y-4">
            <div class="flex flex-wrap items-center gap-3">
              <h2 class="entity-title">
                {{ salonQuery.data.value.salonName }}
              </h2>
              <StatusBadge :value="salonQuery.data.value.approvalStatus" />
              <StatusBadge :value="salonQuery.data.value.subscriptionIntentTier" />
            </div>
            
            <div class="flex flex-wrap items-center gap-6 text-[12px] text-cocoa/60">
              <div class="flex items-center gap-2">
                <svg class="w-4 h-4 text-cocoa/60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                <span>{{ salonQuery.data.value.address }}, {{ salonQuery.data.value.city }}</span>
              </div>
              <div class="flex items-center gap-2">
                <svg class="w-4 h-4 text-cocoa/60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7" y2="7"/></svg>
                <span>{{ salonQuery.data.value.category }}</span>
              </div>
            </div>
          </div>

          <div class="flex items-center gap-4">
            <div class="hidden sm:block text-right">
              <p class="text-[10px] font-bold text-cocoa/60 uppercase tracking-widest">Inscrit le</p>
              <p class="text-[13px] font-semibold text-espresso">{{ formatDate(salonQuery.data.value.submittedAt) }}</p>
            </div>
          </div>
        </div>
        
        <div class="p-8 md:p-10 bg-sand/30">
           <p class="text-[13px] leading-relaxed text-cocoa/80 max-w-4xl">
              {{ salonQuery.data.value.description }}
           </p>
        </div>

        <!-- Integrated Summary -->
        <div class="px-8 md:px-10 py-5 bg-neutral-bg/30 border-t border-outline-variant/30 grid grid-cols-2 md:grid-cols-4 gap-8">
          <div class="space-y-1">
            <p class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest">Identité Gérant</p>
            <p class="text-[13px] font-semibold text-espresso">{{ salonQuery.data.value.owner.fullName }}</p>
          </div>
          <div class="space-y-1">
            <p class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest">Téléphone</p>
            <p class="text-[13px] font-semibold text-espresso">{{ salonQuery.data.value.owner.phone }}</p>
          </div>
          <div class="space-y-1">
            <p class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest">E-mail</p>
            <p class="text-[13px] font-semibold text-espresso">{{ salonQuery.data.value.owner.email }}</p>
          </div>
          <div class="space-y-1">
            <p class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest">Date Soumission</p>
            <p class="text-[13px] font-semibold text-espresso">{{ formatDate(salonQuery.data.value.submittedAt) }}</p>
          </div>
        </div>
      </article>

      <div class="grid grid-cols-12 gap-8">
        <!-- Details & Documents (7 cols) -->
        <div class="col-span-12 lg:col-span-7 space-y-8">
          <section class="space-y-6">
            <div class="flex items-center justify-between px-2">
              <h3 class="text-[11px] font-bold text-cocoa/40 uppercase tracking-[0.3em]">Pièces Justificatives</h3>
              <span class="text-[10px] font-bold text-cocoa/30 uppercase tracking-widest">{{ salonQuery.data.value.documents.length }} documents</span>
            </div>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <article
                v-for="document in salonQuery.data.value.documents"
                :key="document.label"
                class="bg-white rounded-3xl border border-outline-variant p-2 flex flex-col group hover:border-primary/30 transition-all hover:shadow-xl hover:shadow-espresso/5"
              >
                <div 
                  class="aspect-[4/3] rounded-2xl bg-neutral-bg overflow-hidden relative mb-4 cursor-pointer"
                  @click="selectedDoc = document"
                >
                  <img 
                    v-if="document.fileUrl" 
                    :src="document.fileUrl" 
                    class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" 
                  />
                  <div v-else class="absolute inset-0 flex items-center justify-center text-cocoa/20">
                    <DocumentIcon class="w-12 h-12" />
                  </div>
                  <div class="absolute inset-0 bg-espresso/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                    <div class="bg-white/90 backdrop-blur px-4 py-2 rounded-full text-[10px] font-bold uppercase tracking-widest text-espresso shadow-lg">
                      Agrandir le document
                    </div>
                  </div>
                </div>

                <div class="px-4 pb-4 space-y-3">
                  <div class="flex items-start justify-between gap-2">
                    <p class="text-[14px] font-medium-bold text-espresso leading-tight">{{ document.label }}</p>
                    <StatusBadge :value="document.status" class="scale-90 origin-right shrink-0" />
                  </div>
                  <p v-if="document.note" class="text-[12px] text-cocoa/60 italic leading-relaxed">{{ document.note }}</p>
                </div>
              </article>
            </div>
          </section>

          <!-- Modal for Document Preview -->
          <Modal
            :show="!!selectedDoc"
            :title="selectedDoc?.label"
            subtitle="Visualisation du justificatif officiel"
            max-width="4xl"
            @close="selectedDoc = null"
          >
            <div class="flex flex-col items-center gap-6">
              <div class="w-full bg-neutral-bg/50 rounded-2xl overflow-hidden border border-outline-variant flex items-center justify-center min-h-[400px]">
                <img 
                  v-if="selectedDoc?.fileUrl" 
                  :src="selectedDoc.fileUrl" 
                  class="max-w-full h-auto shadow-sm" 
                  alt="Aperçu du document"
                />
                <div v-else class="text-cocoa/80 italic">
                  Aucun visuel disponible pour ce document.
                </div>
              </div>
            </div>
            <template #footer>
              <div class="flex items-center justify-end gap-3">
                <button class="btn-secondary" @click="selectedDoc = null">Fermer</button>
                <a 
                  v-if="selectedDoc?.fileUrl" 
                  :href="selectedDoc.fileUrl" 
                  target="_blank" 
                  class="btn-primary"
                  download
                >
                  Télécharger l'original
                </a>
              </div>
            </template>
          </Modal>
        </div>

        <!-- Catalog & Media (5 cols) -->
        <div class="col-span-12 lg:col-span-5 space-y-8">
          <section class="space-y-4">
            <h3 class="text-[11px] font-bold text-cocoa/60 uppercase tracking-[0.3em] px-2">Visuels Salon</h3>
            <div class="grid grid-cols-2 gap-3">
              <a
                v-for="image in salonQuery.data.value.gallery"
                :key="image"
                :href="image"
                target="_blank"
                rel="noreferrer"
                class="group relative aspect-[4/3] rounded-2xl overflow-hidden bg-sand border border-outline-variant shadow-sm"
              >
                <img :src="image" alt="" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110" />
                <div class="absolute inset-0 bg-espresso/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                  <span class="text-[10px] font-bold text-white uppercase tracking-widest bg-espresso/40 backdrop-blur-md px-4 py-2 rounded-full">
                    Agrandir
                  </span>
                </div>
              </a>
            </div>
          </section>

          <section class="space-y-4">
            <h3 class="text-[11px] font-bold text-cocoa/60 uppercase tracking-[0.3em] px-2">Catalogue Services</h3>
            <div class="space-y-2">
              <article
                v-for="service in salonQuery.data.value.services"
                :key="service.id"
                class="bg-white rounded-xl border border-outline-variant p-4 flex items-center justify-between"
              >
                <div class="space-y-0.5">
                  <p class="text-[13px] font-semibold text-espresso">{{ service.name }}</p>
                  <p class="text-[12px] text-cocoa/80">
                    {{ service.durationMinutes }} min • {{ formatMoneyXof(service.priceXof) }}
                  </p>
                </div>
                <StatusBadge :value="service.depositMode" class="scale-75 origin-right" />
              </article>
            </div>
          </section>
        </div>
      </div>

      <!-- Decision Center -->
      <section v-if="salonQuery.data.value.approvalStatus !== 'approved'" id="decision-center" class="mt-12 panel-clean p-8 md:p-12 relative overflow-hidden">
        <div class="absolute right-0 top-0 w-64 h-64 bg-primary/5 rounded-full -mr-20 -mt-20 blur-3xl"></div>
        
        <div class="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-10 items-start">
          <div class="lg:col-span-4 space-y-4">
            <h3 class="text-[10px] font-bold uppercase tracking-[0.4em] text-cocoa/60">Verdict Final</h3>
            <h4 class="text-2xl font-sans text-espresso leading-tight">Enregistrer une décision système</h4>
            <p class="text-[12px] text-cocoa/80 leading-relaxed">
              Action irréversible notifiée au gérant.
            </p>
          </div>

          <div class="lg:col-span-8 grid grid-cols-1 gap-8">
            <div class="space-y-4">
              <span class="text-[10px] font-bold uppercase tracking-widest text-cocoa/70 px-1">Action</span>
              <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <label 
                  class="cursor-pointer flex items-center justify-center py-3.5 px-4 rounded-xl border-2 transition-all"
                  :class="action === 'approve' ? 'border-primary bg-primary/5 text-espresso font-bold' : 'border-outline-variant bg-white text-cocoa/80 hover:border-primary/30'"
                >
                  <input type="radio" v-model="action" value="approve" class="sr-only" />
                  <CheckIcon class="w-4 h-4 inline mr-1" /><span class="text-[13px]">Approuver</span>
                </label>
                
                <label 
                  class="cursor-pointer flex items-center justify-center py-3.5 px-4 rounded-xl border-2 transition-all"
                  :class="action === 'request-info' ? 'border-secondary bg-secondary/5 text-espresso font-bold' : 'border-outline-variant bg-white text-cocoa/80 hover:border-secondary/30'"
                >
                  <input type="radio" v-model="action" value="request-info" class="sr-only" />
                  <QuestionMarkCircleIcon class="w-4 h-4 inline mr-1" /><span class="text-[13px]">Compléments</span>
                </label>
                
                <label 
                  class="cursor-pointer flex items-center justify-center py-3.5 px-4 rounded-xl border-2 transition-all"
                  :class="action === 'reject' ? 'border-error bg-error/5 text-espresso font-bold' : 'border-outline-variant bg-white text-cocoa/80 hover:border-error/30'"
                >
                  <input type="radio" v-model="action" value="reject" class="sr-only" />
                  <XMarkIcon class="w-4 h-4 inline mr-1" /><span class="text-[13px]">Rejeter</span>
                </label>
              </div>
            </div>

            <div v-if="action === 'request-info' && (requiredDocsQuery.data.value ?? []).length > 0" class="space-y-2">
              <span class="text-[10px] font-bold uppercase tracking-widest text-cocoa/70 px-1">Documents requis</span>
              <div class="space-y-2 mt-1">
                <label
                  v-for="doc in requiredDocsQuery.data.value ?? []"
                  :key="doc.id"
                  class="flex items-center gap-3 cursor-pointer rounded-xl border border-outline-variant/40 px-4 py-3 hover:border-secondary/40 transition"
                  :class="selectedDocTypes.includes(doc.id) ? 'border-secondary bg-secondary/5' : ''"
                >
                  <input type="checkbox" :value="doc.id" v-model="selectedDocTypes" class="accent-secondary w-4 h-4" />
                  <span class="text-sm text-espresso font-semibold">{{ doc.label }}</span>
                </label>
              </div>
            </div>

            <label v-if="action !== 'approve'" class="block space-y-3">
              <span class="text-[10px] font-bold uppercase tracking-widest text-cocoa/70 px-1">Motif prédéfini</span>
              <div class="flex flex-wrap gap-2 mt-1">
                <button
                  v-for="motif in predefinedMotifs[action]"
                  :key="motif"
                  type="button"
                  @click="reason = motif"
                  :class="[
                    'px-3 py-1.5 rounded-full border text-[11px] font-semibold transition-all',
                    reason === motif
                      ? (action === 'reject' ? 'border-error bg-error/10 text-error' : 'border-secondary bg-secondary/10 text-secondary')
                      : 'border-outline-variant bg-white text-cocoa/60 hover:border-primary/30'
                  ]"
                >
                  {{ motif }}
                </button>
              </div>
            </label>

            <label class="block space-y-3">
              <span class="text-[10px] font-bold uppercase tracking-widest text-cocoa/70 px-1">Motif {{ action !== 'approve' ? 'personnalisé' : '' }}</span>
              <textarea
                v-model="reason"
                class="w-full bg-white border border-outline-variant rounded-2xl px-5 py-3.5 text-sm text-espresso focus:outline-none focus:ring-2 focus:ring-primary/40 min-h-[52px]"
                :placeholder="action === 'approve' ? 'Optionnel...' : 'Requis...'"
              />
            </label>

            <div class="flex items-center justify-between gap-6 pt-4 border-t border-outline-variant/30">
              <p v-if="mutationError" class="text-[12px] font-bold text-error">
                {{ mutationError }}
              </p>
              <div v-else class="flex items-center gap-2 text-cocoa/60 italic text-[11px]">
                Validation par {{ auth.currentUser?.fullName }}
              </div>
              
              <div class="flex items-center gap-3">
                <button type="button" class="btn-secondary" @click="resetForm">
                  Réinitialiser
                </button>
                <button type="button" class="btn-primary" :disabled="decisionMutation.isPending.value" @click="submitDecision">
                   Confirmer
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>
      
      <!-- Approved Status Read-Only Notice -->
      <section v-else class="mt-12 panel-clean p-8 bg-primary/5 flex items-center gap-4">
        <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
          <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
        </div>
        <div>
          <h4 class="text-sm font-bold text-espresso">Salon approuvé</h4>
          <p class="text-[12px] text-cocoa/80">Ce dossier est en production. Toute modification opérationnelle doit passer par le menu d'abonnement ou les outils de sanction.</p>
        </div>
      </section>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { CheckIcon, QuestionMarkCircleIcon, XMarkIcon, DocumentIcon } from "@heroicons/vue/24/outline";

import Modal from "@/components/Modal.vue";
import SkeletonLoader from "@/components/SkeletonLoader.vue";
import StatePanel from "@/components/StatePanel.vue";
import StatusBadge from "@/components/StatusBadge.vue";
import {
  ApiError,
  approveSalonRequest,
  fetchPlatformRequiredDocuments,
  fetchSalonDetail,
  rejectSalonRequest,
  requestSalonInfo
} from "@/lib/api";
import { formatDateTime } from "@/lib/date";
import { getErrorMessage } from "@/lib/errors";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();
const route = useRoute();
const router = useRouter();
const queryClient = useQueryClient();

const salonId = computed(() => String(route.params.salonId));
const action = ref<"approve" | "reject" | "request-info">("approve");
const reason = ref("");
const mutationError = ref("");
const selectedDoc = ref<any>(null);

const predefinedMotifs: Record<"reject" | "request-info", string[]> = {
  "reject": [
    "Documents non conformes ou illisibles",
    "Établissement non enregistré légalement",
    "Activité non éligible à la plateforme",
    "Adresse introuvable ou incorrecte",
    "Identité du gérant non vérifiable"
  ],
  "request-info": [
    "RCCM manquant ou expiré",
    "Photo de la pièce d'identité floue",
    "Adresse précise du salon requise",
    "Numéro de téléphone professionnel requis",
    "Description du salon insuffisante"
  ]
};

const salonQuery = useQuery({
  queryKey: computed(() => ["admin-salon-detail", salonId.value]),
  queryFn: () => fetchSalonDetail(auth.accessToken ?? "", salonId.value),
  enabled: computed(() => Boolean(auth.accessToken))
});

const requiredDocsQuery = useQuery({
  queryKey: ["admin-config-documents"],
  queryFn: () => fetchPlatformRequiredDocuments(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const selectedDocTypes = ref<string[]>([]);

const decisionMutation = useMutation({
  mutationFn: async () => {
    if (action.value === "approve") {
      return approveSalonRequest(auth.accessToken ?? "", salonId.value);
    }

    let fullReason = reason.value.trim();
    if (action.value === "request-info" && selectedDocTypes.value.length > 0) {
      const docs = requiredDocsQuery.data.value ?? [];
      const labels = selectedDocTypes.value.map((id) => docs.find((d) => d.id === id)?.label).filter(Boolean);
      if (labels.length > 0) {
        fullReason = `${fullReason ? fullReason + "\n\n" : ""}Documents requis :\n${labels.map((l) => `• ${l}`).join("\n")}`;
      }
    }
    if (!fullReason) {
      throw new Error("Le motif est requis pour cette action.");
    }
    const payload = { reason: fullReason };

    return action.value === "reject"
      ? rejectSalonRequest(auth.accessToken ?? "", salonId.value, payload)
      : requestSalonInfo(auth.accessToken ?? "", salonId.value, payload);
  },
  onSuccess: async () => {
    mutationError.value = "";
    await queryClient.invalidateQueries({ queryKey: ["admin-salons"] });
    await queryClient.invalidateQueries({ queryKey: ["admin-dashboard"] });
    await queryClient.invalidateQueries({ queryKey: ["admin-salon-detail", salonId.value] });
    toast.success("Décision enregistrée.");
    resetForm();
  },
  onError: (error) => {
    mutationError.value = getErrorMessage(error, "Action impossible.");
    toast.error(mutationError.value);
  }
});

const errorMessage = computed(() => {
  const error = salonQuery.error.value;
  return error instanceof ApiError ? error.message : "Le dossier demandé est introuvable.";
});

function resetForm() {
  action.value = "approve";
  reason.value = "";
  mutationError.value = "";
}

function submitDecision() {
  decisionMutation.mutate();
}

const formatDate = formatDateTime;
</script>
