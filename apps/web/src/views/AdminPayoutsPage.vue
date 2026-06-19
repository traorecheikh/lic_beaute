<template>
  <div class="space-y-8">
    <header class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <div>
        <h2 class="page-title mb-1">Règlements Marchands</h2>
        <p class="text-xs text-cocoa/60">Gérez les transferts vers les portefeuilles mobiles des salons.</p>
      </div>

      <div class="flex flex-col sm:flex-row flex-wrap gap-3">
        <!-- Status Filter -->
        <select v-model="statusFilter" class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4">
          <option value="">Tous les statuts</option>
          <option value="blocked">Bloqué</option>
          <option value="scheduled">Planifié</option>
          <option value="creating">Création</option>
          <option value="created">Créé</option>
          <option value="submitting">Soumission</option>
          <option value="pending">En cours</option>
          <option value="succeeded">Versé (Réussi)</option>
          <option value="failed_retryable">Échec Temporaire</option>
          <option value="failed_terminal">Échec Définitif</option>
          <option value="cancelled">Annulé</option>
          <option value="manual_review">Revue Manuelle</option>
        </select>

        <!-- Salon search -->
        <input
          v-model="salonSearch"
          class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4 min-w-[200px]"
          placeholder="Filtrer par ID Salon..."
        />
      </div>
    </header>

    <section class="panel-clean p-6 md:p-8 space-y-6 border border-outline-variant/30">
      <div class="flex flex-col gap-4 xl:flex-row xl:items-end xl:justify-between">
        <div class="space-y-2 max-w-3xl">
          <h3 class="section-label">Validation des Coordonnées de Versement</h3>
          <p class="row-primary">File de contrôle propriétaire</p>
          <p class="row-meta">
            Cette file regroupe tous les salons dont le portefeuille de versement doit être approuvé ou revu.
            L'approbation ou le rejet envoie maintenant une notification in-app et un email au propriétaire.
          </p>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 xl:min-w-[420px]">
          <input
            v-model="verificationSearch"
            class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4"
            placeholder="Salon, gérant ou téléphone..."
          />
          <select v-model="verificationStatusFilter" class="input-shell bg-white h-10 border-outline-variant/60 rounded-full text-[12px] px-4 sm:w-[180px]">
            <option value="all">Tous les statuts</option>
            <option value="unverified">À approuver</option>
            <option value="rejected">Rejetés</option>
          </select>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="panel-clean p-5 bg-surface border-l-4 border-l-secondary">
          <p class="metric-label mb-2">À approuver</p>
          <p class="metric-value">{{ verificationPendingCount }}</p>
          <p class="row-meta mt-2">Salons configurés mais non validés.</p>
        </div>
        <div class="panel-clean p-5 bg-surface border-l-4 border-l-error">
          <p class="metric-label mb-2">Rejetés</p>
          <p class="metric-value">{{ verificationRejectedCount }}</p>
          <p class="row-meta mt-2">Coordonnées renvoyées au propriétaire.</p>
        </div>
        <div class="panel-clean p-5 bg-surface border-l-4 border-l-primary">
          <p class="metric-label mb-2">Versements impactés</p>
          <p class="metric-value">{{ verificationBlockedPayoutCount }}</p>
          <p class="row-meta mt-2">Règlements bloqués par absence de validation.</p>
        </div>
      </div>

      <div v-if="verificationQueueQuery.isLoading.value" class="py-8 text-center text-sm text-cocoa/60">
        Chargement des portefeuilles à valider...
      </div>

      <StatePanel
        v-else-if="verificationQueueQuery.isError.value"
        eyebrow="Validation indisponible"
        title="Impossible de charger la file de contrôle"
        message="La file de validation des coordonnées n'a pas pu être récupérée."
        action-label="Réessayer"
        @action="verificationQueueQuery.refetch"
      />

      <StatePanel
        v-else-if="filteredVerificationQueue.length === 0"
        eyebrow="Aucune attente"
        title="Aucune coordonnée à vérifier"
        message="Aucun salon ne correspond aux filtres de validation sélectionnés."
      />

      <div v-else class="space-y-3">
        <article
          v-for="item in filteredVerificationQueue"
          :key="item.salonId"
          class="panel-clean p-5 hover:bg-neutral-bg/20 transition-colors"
        >
          <div class="flex flex-col gap-4 xl:flex-row xl:items-start xl:justify-between">
            <div class="space-y-4">
              <div class="flex flex-wrap items-center gap-2">
                <p class="row-primary">{{ item.salonName }}</p>
                <StatusBadge :value="item.payoutVerificationStatus" />
                <span class="row-meta">{{ item.city }}</span>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4 text-xs">
                <div>
                  <p class="section-label mb-1">Propriétaire</p>
                  <p class="row-primary">{{ item.ownerName }}</p>
                  <p class="row-meta">{{ item.ownerEmail || "Email non renseigné" }}</p>
                </div>
                <div>
                  <p class="section-label mb-1">Portefeuille</p>
                  <p class="row-primary">{{ payoutMethodLabel(item.payoutMethod) }}</p>
                  <p class="row-meta">{{ item.payoutPhoneMasked || "—" }}</p>
                </div>
                <div>
                  <p class="section-label mb-1">Bénéficiaire</p>
                  <p class="row-primary">{{ item.payoutName || "—" }}</p>
                  <p class="row-meta">Mis à jour le {{ formatDate(item.updatedAt) }}</p>
                </div>
                <div>
                  <p class="section-label mb-1">Impact</p>
                  <p class="row-primary">{{ item.blockedForVerificationCount }} bloqué(s) pour validation</p>
                  <p class="row-meta">{{ item.blockedPayoutCount }} blocage(s) total, {{ item.totalPayoutCount }} versement(s) liés</p>
                </div>
              </div>

              <p class="text-xs text-cocoa/60 leading-relaxed max-w-3xl">
                <span v-if="item.payoutVerificationStatus === 'rejected'">
                  Le propriétaire doit corriger ses coordonnées avant reprise des versements.
                </span>
                <span v-else>
                  Une approbation débloque automatiquement les règlements gelés pour absence de validation.
                </span>
                <span v-if="item.payoutVerifiedAt">
                  Dernière validation le {{ formatDate(item.payoutVerifiedAt) }}.
                </span>
              </p>
            </div>

            <div class="flex flex-col sm:flex-row xl:flex-col gap-2 xl:min-w-[210px]">
              <button
                class="btn-primary px-4 py-2 text-[11px]"
                :disabled="actionExecuting"
                @click="verifyWallet(item.salonId, 'verified')"
              >
                Approuver et notifier
              </button>
              <button
                class="btn-secondary px-4 py-2 text-[11px] border-rose-200 hover:bg-rose-50 text-rose-700"
                :disabled="actionExecuting"
                @click="verifyWallet(item.salonId, 'rejected')"
              >
                Rejeter et notifier
              </button>
              <button
                class="btn-secondary px-4 py-2 text-[11px]"
                @click="openSalon(item.salonId)"
              >
                Ouvrir le dossier salon
              </button>
            </div>
          </div>
        </article>
      </div>
    </section>

    <div v-if="payoutsQuery.isLoading.value" class="py-10 text-center text-sm text-cocoa/60">
      Chargement des règlements...
    </div>

    <StatePanel
      v-else-if="payoutsQuery.isError.value"
      title="Erreur"
      message="Impossible de récupérer la liste des règlements marchands."
      action-label="Réessayer"
      @action="payoutsQuery.refetch"
    />

    <StatePanel
      v-else-if="filteredPayouts.length === 0"
      eyebrow="Aucun règlement"
      title="Aucun règlement trouvé"
      message="Aucun virement ne correspond aux filtres de recherche sélectionnés."
    />

    <div v-else class="panel-clean overflow-hidden border border-outline-variant/30">
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-neutral-bg/50">
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Date</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Salon</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Destinataire</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Brut (XOF)</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Commission</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Net Versé</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Statut</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40 text-right">Action</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/30 text-xs">
          <tr v-for="p in filteredPayouts" :key="p.id" class="hover:bg-neutral-bg/30 transition-colors cursor-pointer" @click="openDetails(p.id)">
            <td class="px-6 py-4">
              <p class="font-semibold text-espresso">{{ formatDate(p.createdAt) }}</p>
              <p class="text-[9px] text-cocoa/40 uppercase font-mono">{{ p.id }}</p>
            </td>
            <td class="px-6 py-4">
              <p class="font-semibold text-espresso">{{ p.salonName }}</p>
              <p class="text-[9px] text-cocoa/40 uppercase font-mono">{{ p.salonId }}</p>
            </td>
            <td class="px-6 py-4">
              <p class="font-semibold text-espresso">{{ p.beneficiaryName }}</p>
              <p class="text-cocoa/60">{{ p.beneficiaryPhoneMasked }} ({{ p.payoutMethod === 'wave_senegal' ? 'Wave' : 'Orange Money' }})</p>
            </td>
            <td class="px-6 py-4 font-mono font-semibold text-espresso">
              {{ formatMoneyXof(p.grossAmount) }}
            </td>
            <td class="px-6 py-4 font-mono text-cocoa/60">
              -{{ formatMoneyXof(p.platformCommission) }}
            </td>
            <td class="px-6 py-4 font-mono font-bold text-espresso">
              {{ formatMoneyXof(p.payoutAmount) }}
            </td>
            <td class="px-6 py-4">
              <StatusBadge :value="p.status" />
            </td>
            <td class="px-6 py-4 text-right">
              <button
                @click="openDetails(p.id)"
                class="btn-secondary px-4 py-1.5 rounded-full text-[11px]"
              >
                Inspecter
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Payout Detail Side Drawer -->
    <Transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="translate-x-full"
      enter-to-class="translate-x-0"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="translate-x-0"
      leave-to-class="translate-x-full"
    >
      <div v-if="selectedPayoutId" class="fixed inset-y-0 right-0 w-full max-w-2xl bg-white shadow-2xl z-[200] border-l border-outline-variant/40 flex flex-col">
        <!-- Drawer Header -->
        <div class="p-6 border-b border-outline-variant/30 flex items-center justify-between bg-neutral-bg/30">
          <div>
            <h3 class="text-base font-bold text-espresso">Détail du Règlement</h3>
            <p class="text-[10px] text-cocoa/40 font-mono uppercase">{{ selectedPayoutId }}</p>
          </div>
          <button @click="closeDetails" class="p-2 text-cocoa/60 hover:text-espresso transition">
            <XMarkIcon class="w-6 h-6" />
          </button>
        </div>

        <!-- Drawer Content -->
        <div v-if="loadingDetail" class="p-6 text-center text-sm text-cocoa/60 flex-1 overflow-y-auto">
          Chargement des détails...
        </div>
        <div v-else-if="detailError" class="p-6 text-center text-sm text-error flex-1 overflow-y-auto">
          Impossible de charger les détails de ce règlement.
        </div>
        <div v-else-if="detailData" class="flex-1 overflow-y-auto p-6 space-y-6">
          <!-- Overview Cards -->
          <div class="grid grid-cols-2 gap-4">
            <div class="panel-clean p-4 border border-outline-variant/30 bg-surface">
              <p class="section-label text-[9px] mb-1">Statut Règlement</p>
              <StatusBadge :value="detailData.payout.status" />
              <p v-if="detailData.payout.safeFailureMessage" class="text-[11px] text-error mt-2 leading-tight">
                {{ detailData.payout.safeFailureMessage }}
              </p>
            </div>
            <div class="panel-clean p-4 border border-outline-variant/30 bg-surface">
              <p class="section-label text-[9px] mb-1">Délai de Retenue</p>
              <p class="row-primary">Hold : {{ detailData.payout.commissionSnapshot.feeResponsibilityPolicy || '0h' }}</p>
              <p class="row-meta mt-1">Éligible le : {{ formatDate(detailData.payout.eligibleAt) }}</p>
            </div>
          </div>

          <!-- Financial summary -->
          <div class="panel-clean p-5 border border-outline-variant/30">
            <h4 class="section-label mb-3">Synthèse Financière</h4>
            <div class="space-y-2 text-xs">
              <div class="flex justify-between">
                <span class="text-cocoa/60">Montant Brut Client :</span>
                <span class="font-mono font-semibold text-espresso">{{ formatMoneyXof(detailData.payout.grossAmount) }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-cocoa/60">Commission Plateforme ({{ detailData.payout.commissionSnapshot.configuredValue }}% / version {{ detailData.payout.commissionSnapshot.policyVersion }}) :</span>
                <span class="font-mono text-error font-semibold">-{{ formatMoneyXof(detailData.payout.platformCommission) }}</span>
              </div>
              <div class="flex justify-between border-t border-outline-variant/30 pt-2 font-bold">
                <span class="text-espresso">Part Salons (Net Versé) :</span>
                <span class="font-mono text-espresso text-sm">{{ formatMoneyXof(detailData.payout.payoutAmount) }}</span>
              </div>
              <div class="flex justify-between text-[11px] text-cocoa/40 border-t border-outline-variant/30 pt-2">
                <span>Frais d'encaissement (supportés par NumuConnect) :</span>
                <span class="font-mono">{{ formatMoneyXof(detailData.payout.collectionFee) }}</span>
              </div>
              <div class="flex justify-between text-[11px] text-cocoa/40">
                <span>Frais de virement (supportés par NumuConnect) :</span>
                <span class="font-mono">{{ formatMoneyXof(detailData.payout.payoutFee) }}</span>
              </div>
            </div>
          </div>

          <!-- Wallet / Beneficiary details -->
          <div class="panel-clean p-5 border border-outline-variant/30">
            <div class="flex justify-between items-start mb-3">
              <h4 class="section-label">Coordonnées du Destinataire</h4>
              <div class="flex items-center gap-1.5">
                <span class="text-[10px] text-cocoa/50 font-bold uppercase">Validation :</span>
                <StatusBadge :value="detailData.payout.salon.payoutVerificationStatus" />
              </div>
            </div>
            
            <div class="grid grid-cols-2 gap-4 text-xs">
              <div>
                <p class="text-cocoa/60">Bénéficiaire :</p>
                <p class="font-semibold text-espresso mt-0.5">{{ detailData.payout.beneficiaryName }}</p>
              </div>
              <div>
                <p class="text-cocoa/60">Méthode & Mobile :</p>
                <p class="font-semibold text-espresso mt-0.5">
                  {{ detailData.payout.payoutMethod === 'wave_senegal' ? 'Wave Sénégal' : 'Orange Money Sénégal' }}
                  <span class="text-cocoa/60 font-mono block mt-0.5">{{ detailData.payout.beneficiaryPhoneMasked }}</span>
                </p>
              </div>
            </div>

            <!-- Salon verification CTA -->
            <div v-if="detailData.payout.salon.payoutVerificationStatus === 'unverified' || detailData.payout.salon.payoutVerificationStatus === 'rejected'" class="mt-4 p-3 bg-amber-50 border border-amber-200 rounded-lg flex items-center justify-between gap-4">
              <div class="text-[11px] text-amber-800 leading-tight">
                <strong>Attention:</strong> Le portefeuille de ce salon n'a pas été vérifié par l'administration. Les virements vers ce salon sont actuellement bloqués.
              </div>
              <div class="flex gap-2 shrink-0">
                <button @click="verifyWallet(detailData.payout.salonId, 'verified')" class="btn-primary bg-emerald-600 hover:bg-emerald-700 px-3 py-1.5 text-[10px] rounded-full text-white">
                  Approuver
                </button>
                <button @click="verifyWallet(detailData.payout.salonId, 'rejected')" class="btn-secondary border-rose-300 hover:bg-rose-50 px-3 py-1.5 text-[10px] rounded-full text-rose-700">
                  Rejeter
                </button>
              </div>
            </div>
          </div>

          <!-- Outbound Integration details -->
          <div class="panel-clean p-5 border border-outline-variant/30 space-y-3">
            <h4 class="section-label">Intégration Passerelle Mobile</h4>
            <div class="grid grid-cols-2 gap-3 text-[11px] font-mono">
              <div>
                <p class="text-cocoa/50">Disburse ID (Interne) :</p>
                <p class="text-espresso select-all">{{ detailData.payout.disburseId || '—' }}</p>
              </div>
              <div>
                <p class="text-cocoa/50">Token Disbursement :</p>
                <p class="text-espresso select-all">{{ detailData.payout.disburseToken || '—' }}</p>
              </div>
              <div>
                <p class="text-cocoa/50">ID Transaction (Provider) :</p>
                <p class="text-espresso select-all">{{ detailData.payout.transactionId || '—' }}</p>
              </div>
              <div>
                <p class="text-cocoa/50">Provider Ref / Tx ID :</p>
                <p class="text-espresso select-all">{{ detailData.payout.providerRef || '—' }}</p>
              </div>
            </div>
            <div class="grid grid-cols-2 gap-4 text-xs pt-2 border-t border-outline-variant/30">
              <div>
                <span class="text-cocoa/60">Tentatives :</span>
                <span class="font-semibold text-espresso ml-2">{{ detailData.payout.attemptCount }}</span>
              </div>
              <div v-if="detailData.payout.lastReconciledAt">
                <span class="text-cocoa/60">Dernière Réconciliation :</span>
                <span class="font-semibold text-espresso ml-2">{{ formatDate(detailData.payout.lastReconciledAt) }}</span>
              </div>
            </div>
          </div>

          <!-- Audit Log History -->
          <div class="space-y-2">
            <h4 class="section-label">Historique d'audit</h4>
            <div v-if="detailData.auditLogs.length === 0" class="text-xs text-cocoa/40 italic">
              Aucune action admin enregistrée sur ce règlement.
            </div>
            <div v-else class="space-y-2 max-h-[200px] overflow-y-auto pr-1">
              <div v-for="log in detailData.auditLogs" :key="log.id" class="p-3 bg-neutral-bg/30 rounded-lg border border-outline-variant/20 text-xs">
                <div class="flex justify-between items-start mb-1">
                  <span class="font-semibold text-espresso">{{ log.summary }}</span>
                  <span class="text-[9px] text-cocoa/40">{{ formatDate(log.createdAt) }}</span>
                </div>
                <div class="flex justify-between text-[10px] text-cocoa/60">
                  <span>Acteur: {{ log.actorName }}</span>
                  <span class="uppercase tracking-wider text-[8px] font-bold">{{ log.action }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Drawer Footer / Admin actions -->
        <div v-if="detailData" class="p-6 border-t border-outline-variant/30 bg-neutral-bg/10 flex flex-wrap gap-2 justify-end">
          <!-- Reconcile Action -->
          <button
            v-if="detailData.payout.disburseToken && detailData.payout.status !== 'succeeded' && detailData.payout.status !== 'cancelled'"
            @click="triggerReconcile"
            :disabled="actionExecuting"
            class="btn-secondary border-blue-200 hover:bg-blue-50 text-blue-700 px-4 py-2 text-xs rounded-full flex items-center gap-1"
          >
            Réconcilier
          </button>

          <!-- Retry Action -->
          <button
            v-if="detailData.payout.status !== 'succeeded' && detailData.payout.status !== 'cancelled' && detailData.payout.status !== 'scheduled'"
            @click="promptAction('retry')"
            :disabled="actionExecuting"
            class="btn-secondary border-amber-300 hover:bg-amber-50 text-amber-700 px-4 py-2 text-xs rounded-full"
          >
            Relancer Manuellement
          </button>

          <!-- Approve Action (blocked/manual_review) -->
          <button
            v-if="detailData.payout.status === 'blocked' || detailData.payout.status === 'manual_review'"
            @click="promptAction('approve')"
            :disabled="actionExecuting"
            class="btn-gold px-4 py-2 text-xs rounded-full text-white bg-secondary hover:bg-secondary-container"
          >
            Forcer l'Approbation
          </button>

          <!-- Cancel Action -->
          <button
            v-if="detailData.payout.status !== 'succeeded' && detailData.payout.status !== 'cancelled'"
            @click="promptAction('cancel')"
            :disabled="actionExecuting"
            class="btn-secondary border-rose-200 hover:bg-rose-50 text-rose-700 px-4 py-2 text-xs rounded-full"
          >
            Annuler Versement
          </button>
        </div>
      </div>
    </Transition>

    <!-- Overlay backdrop for detail drawer -->
    <div v-if="selectedPayoutId" @click="closeDetails" class="fixed inset-0 bg-black/40 z-[100] backdrop-blur-sm"></div>

    <!-- Reason Prompt Modal -->
    <Modal :show="!!actionPrompt" @close="cancelPrompt">
      <div class="space-y-4">
        <h3 class="text-base font-bold text-espresso">Justificatif requis</h3>
        <p class="text-xs text-cocoa/60">
          Veuillez saisir le motif de cette action de validation financière. Un motif de 5 caractères minimum est obligatoire pour l'audit.
        </p>
        <textarea
          v-model="actionReason"
          rows="3"
          class="input-shell w-full text-xs"
          placeholder="Ex: Validation manuelle après vérification du numéro Orange Money..."
        ></textarea>
        <div class="flex justify-end gap-2 pt-2">
          <button @click="cancelPrompt" class="btn-secondary px-4 py-2 text-xs" :disabled="actionExecuting">
            Annuler
          </button>
          <button @click="confirmAction" class="btn-primary px-4 py-2 text-xs" :disabled="actionExecuting || actionReason.trim().length < 5">
            {{ actionExecuting ? 'Exécution...' : 'Confirmer' }}
          </button>
        </div>
      </div>
    </Modal>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useQuery } from "@tanstack/vue-query";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { toast } from "vue-sonner";
import { XMarkIcon } from "@heroicons/vue/24/outline";
import { useRouter } from "vue-router";

import { useAdminAuthStore } from "@/stores/adminAuth";
import StatusBadge from "@/components/StatusBadge.vue";
import Modal from "@/components/Modal.vue";
import StatePanel from "@/components/StatePanel.vue";
import {
  fetchAdminPayoutVerificationQueue,
  fetchAdminMerchantPayouts,
  fetchAdminMerchantPayoutDetail,
  reconcileAdminPayout,
  retryAdminPayout,
  approveAdminPayout,
  cancelAdminPayout,
  verifySalonPayoutSettings
} from "@/lib/api";

const router = useRouter();
const auth = useAdminAuthStore();

// Filters state
const statusFilter = ref<string>("");
const salonSearch = ref<string>("");
const verificationSearch = ref("");
const verificationStatusFilter = ref<"all" | "unverified" | "rejected">("all");

const verificationQueueQuery = useQuery({
  queryKey: ["admin-payout-verification-queue"],
  queryFn: () => fetchAdminPayoutVerificationQueue(auth.accessToken ?? "", { status: "all" }),
  enabled: computed(() => Boolean(auth.accessToken))
});

const filteredVerificationQueue = computed(() => {
  let list = verificationQueueQuery.data.value ?? [];
  if (verificationStatusFilter.value !== "all") {
    list = list.filter((item) => item.payoutVerificationStatus === verificationStatusFilter.value);
  }
  if (verificationSearch.value.trim()) {
    const search = verificationSearch.value.trim().toLowerCase();
    list = list.filter((item) =>
      [
        item.salonName,
        item.ownerName,
        item.ownerEmail ?? "",
        item.payoutPhoneMasked ?? "",
        item.payoutName ?? ""
      ].some((value) => value.toLowerCase().includes(search))
    );
  }
  return list;
});

const verificationPendingCount = computed(
  () => (verificationQueueQuery.data.value ?? []).filter((item) => item.payoutVerificationStatus === "unverified").length
);
const verificationRejectedCount = computed(
  () => (verificationQueueQuery.data.value ?? []).filter((item) => item.payoutVerificationStatus === "rejected").length
);
const verificationBlockedPayoutCount = computed(() =>
  (verificationQueueQuery.data.value ?? []).reduce((sum, item) => sum + item.blockedForVerificationCount, 0)
);

// Main payouts query
const payoutsQuery = useQuery({
  queryKey: ["admin-merchant-payouts"],
  queryFn: () => fetchAdminMerchantPayouts(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const filteredPayouts = computed(() => {
  let list = payoutsQuery.data.value ?? [];
  if (statusFilter.value) {
    list = list.filter((p) => p.status === statusFilter.value);
  }
  if (salonSearch.value.trim()) {
    const s = salonSearch.value.trim().toLowerCase();
    list = list.filter((p) => p.salonId.toLowerCase().includes(s));
  }
  return list;
});

// Payout detail query
const selectedPayoutId = ref<string | null>(null);

const detailQuery = useQuery({
  queryKey: ["admin-merchant-payout-detail", selectedPayoutId],
  queryFn: () => fetchAdminMerchantPayoutDetail(auth.accessToken ?? "", selectedPayoutId.value ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && selectedPayoutId.value))
});

const detailData = computed(() => detailQuery.data.value);
const loadingDetail = computed(() => detailQuery.isLoading.value);
const detailError = computed(() => detailQuery.isError.value);

function openDetails(id: string) {
  selectedPayoutId.value = id;
}

function closeDetails() {
  selectedPayoutId.value = null;
}

// Action execution state
const actionExecuting = ref(false);
const actionPrompt = ref<"retry" | "approve" | "cancel" | null>(null);
const actionReason = ref("");

function promptAction(type: "retry" | "approve" | "cancel") {
  actionReason.value = "";
  actionPrompt.value = type;
}

function cancelPrompt() {
  actionPrompt.value = null;
}

async function confirmAction() {
  if (!selectedPayoutId.value || !actionPrompt.value) return;
  
  actionExecuting.value = true;
  const reason = actionReason.value.trim();
  const token = auth.accessToken ?? "";
  const payoutId = selectedPayoutId.value;

  try {
    if (actionPrompt.value === "retry") {
      await retryAdminPayout(token, payoutId, reason);
      toast.success("Demande de relance manuelle envoyée.");
    } else if (actionPrompt.value === "approve") {
      await approveAdminPayout(token, payoutId, reason);
      toast.success("Approbation manuelle effectuée, versement planifié.");
    } else if (actionPrompt.value === "cancel") {
      await cancelAdminPayout(token, payoutId, reason);
      toast.success("Versement annulé avec succès.");
    }
    
    // Refresh queries
    detailQuery.refetch();
    payoutsQuery.refetch();
    verificationQueueQuery.refetch();
    actionPrompt.value = null;
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Échec de l'action administrative.");
  } finally {
    actionExecuting.value = false;
  }
}

async function triggerReconcile() {
  if (!selectedPayoutId.value) return;
  actionExecuting.value = true;
  try {
    const res = await reconcileAdminPayout(auth.accessToken ?? "", selectedPayoutId.value);
    toast.success(`Réconciliation complétée. Statut actuel: ${res.status}`);
    detailQuery.refetch();
    payoutsQuery.refetch();
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Erreur de réconciliation.");
  } finally {
    actionExecuting.value = false;
  }
}

async function verifyWallet(salonId: string, status: "verified" | "rejected") {
  actionExecuting.value = true;
  try {
    await verifySalonPayoutSettings(auth.accessToken ?? "", salonId, status);
    toast.success(
      status === "verified"
        ? "Coordonnées approuvées. Le propriétaire a été notifié."
        : "Coordonnées rejetées. Le propriétaire a été notifié."
    );
    detailQuery.refetch();
    payoutsQuery.refetch();
    verificationQueueQuery.refetch();
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Échec de validation des coordonnées.");
  } finally {
    actionExecuting.value = false;
  }
}

// Helpers
function payoutMethodLabel(method: "wave_senegal" | "orange_money_senegal" | null | undefined): string {
  if (method === "wave_senegal") return "Wave Sénégal";
  if (method === "orange_money_senegal") return "Orange Money Sénégal";
  return "Méthode non configurée";
}

function openSalon(salonId: string) {
  void router.push(`/admin/salons/${salonId}`);
}

function formatDate(d: string | null | undefined): string {
  if (!d) return "—";
  return dayjs(d).format("DD/MM/YYYY [à] HH:mm");
}
</script>
