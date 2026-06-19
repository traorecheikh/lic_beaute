<template>
  <div>
    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-2">Ventes & Versements</h1>
        <p class="text-cocoa/60">Suivez vos règlements marchands et configurez vos options de virement.</p>
      </div>
      <div class="flex items-center gap-2">
        <select v-model="period" class="input-shell py-2 min-w-[150px]">
          <option value="30d">Derniers 30 jours</option>
          <option value="last-month">Mois dernier</option>
          <option value="all">Tout</option>
        </select>
        <button @click="printStatement" class="btn-secondary px-4 py-2 ring-0 border flex items-center gap-2">
          <ArrowDownTrayIcon class="w-4 h-4" />
          Relevé PDF
        </button>
      </div>
    </div>

    <!-- Payout Settings (Owner only) -->
    <div v-if="auth.isOwner" class="panel-clean p-6 mb-10 border border-outline-variant/30">
      <h2 class="section-label mb-4">Coordonnées de Règlement (Propriétaire)</h2>
      
      <div v-if="settingsQuery.isLoading.value" class="text-sm text-cocoa/60">
        Chargement des paramètres de virement...
      </div>
      
      <div v-else-if="settingsQuery.isError.value" class="text-sm text-error">
        Impossible de charger vos coordonnées de règlement.
      </div>
      
      <div v-else>
        <!-- Read mode -->
        <div v-if="!isEditingSettings" class="grid grid-cols-1 md:grid-cols-4 gap-6 items-end">
          <div>
            <p class="section-label text-[10px] mb-1">Méthode de versement</p>
            <p class="row-primary">
              <span v-if="settings?.payoutMethod === 'wave_senegal'" class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-blue-500"></span> Wave Sénégal
              </span>
              <span v-else-if="settings?.payoutMethod === 'orange_money_senegal'" class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-orange-500"></span> Orange Money Sénégal
              </span>
              <span v-else class="text-cocoa/40 italic">Non configurée</span>
            </p>
          </div>
          <div>
            <p class="section-label text-[10px] mb-1">Téléphone bénéficiaire</p>
            <p class="row-primary">{{ settings?.payoutPhone || '—' }}</p>
          </div>
          <div>
            <p class="section-label text-[10px] mb-1">Nom bénéficiaire</p>
            <p class="row-primary">{{ settings?.payoutName || '—' }}</p>
          </div>
          <div>
            <p class="section-label text-[10px] mb-1">Statut du compte</p>
            <div class="space-y-2">
              <span :class="['inline-flex px-2.5 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest', verificationStatusClass]">
                {{ verificationStatusLabel }}
              </span>
              <p class="text-xs text-cocoa/60 leading-relaxed">
                {{ verificationStatusHelp }}
              </p>
              <p v-if="settings?.payoutVerifiedAt" class="text-[11px] text-cocoa/50">
                Validé le {{ dayjs(settings.payoutVerifiedAt).format("DD/MM/YYYY [à] HH:mm") }}.
              </p>
            </div>
          </div>
          <div class="md:col-span-4 flex justify-between items-center mt-4 pt-4 border-t border-outline-variant/30">
            <p class="text-xs text-cocoa/60 max-w-xl">
              Les fonds sont versés automatiquement sur votre portefeuille mobile après réalisation des prestations, expiration du délai de retenue réglementaire et validation manuelle de vos coordonnées par l'équipe Beauté Avenue.
            </p>
            <button @click="startEditingSettings" class="btn-secondary px-4 py-2 text-xs">
              Modifier
            </button>
          </div>
        </div>

        <!-- Edit mode -->
        <form v-else @submit.prevent="saveSettings" class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label class="section-label block mb-1">Méthode de versement</label>
              <select v-model="editForm.payoutMethod" class="input-shell w-full" required>
                <option value="wave_senegal">Wave Sénégal</option>
                <option value="orange_money_senegal">Orange Money Sénégal</option>
              </select>
            </div>
            <div>
              <label class="section-label block mb-1">Téléphone (9 chiffres, ex: 771234567)</label>
              <input v-model="editForm.payoutPhone" type="text" class="input-shell w-full" placeholder="771234567" required />
            </div>
            <div>
              <label class="section-label block mb-1">Nom complet (selon pièce d'identité)</label>
              <input v-model="editForm.payoutName" type="text" class="input-shell w-full" placeholder="Prénom Nom" required />
            </div>
          </div>

          <div class="bg-amber-50 border border-amber-200 rounded-lg p-4 text-xs text-amber-800 space-y-1">
            <p class="font-bold">⚠️ Attention</p>
            <p>La modification de vos coordonnées bancaires gèle immédiatement vos versements en attente. Les paiements ne reprendront qu'après validation de vos nouveaux détails par l'équipe administrative de Beauté Avenue.</p>
            <p>Cette validation est manuelle. Un administrateur Beauté Avenue vérifie le nom, le numéro et la méthode de versement avant de débloquer les règlements.</p>
          </div>

          <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 pt-4 border-t border-outline-variant/30">
            <div class="max-w-xs w-full">
              <label class="section-label block mb-1">Confirmez avec votre mot de passe</label>
              <input v-model="editForm.password" type="password" class="input-shell w-full" placeholder="Mot de passe propriétaire" required />
            </div>
            <div class="flex items-center gap-2 self-end">
              <button type="button" @click="cancelEditingSettings" class="btn-secondary px-4 py-2 text-xs" :disabled="savingSettings">
                Annuler
              </button>
              <button type="submit" class="btn-primary px-4 py-2 text-xs" :disabled="savingSettings">
                {{ savingSettings ? 'Enregistrement...' : 'Enregistrer' }}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <!-- Payout KPIs -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-secondary shadow-sm">
        <p class="metric-label mb-2">En attente de règlement</p>
        <p class="metric-value text-secondary">{{ pendingAmountLabel }}</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Versements planifiés ou suspendus</p>
      </div>
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-primary shadow-sm">
        <p class="metric-label mb-2">Déjà versé sur la période</p>
        <p class="metric-value text-espresso">{{ releasedAmountLabel }}</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Total {{ releasedCount }} virements réussis</p>
      </div>
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-cocoa/20 shadow-sm">
        <p class="metric-label mb-2">Frais & Commissions plateforme</p>
        <p class="metric-value text-cocoa/40">{{ commissionAmountLabel }}</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Total commission retenue</p>
      </div>
    </div>

    <div class="panel-clean overflow-hidden">
      <div class="p-8 border-b border-outline-variant/30 flex items-center justify-between">
        <h2 class="section-label">Historique des versements</h2>
        <div class="flex gap-2">
          <span class="flex items-center gap-1.5 text-[10px] font-bold text-cocoa/40">
            <div class="w-2 h-2 rounded-full bg-primary"></div> Versé
          </span>
          <span class="flex items-center gap-1.5 text-[10px] font-bold text-cocoa/40 ml-4">
            <div class="w-2 h-2 rounded-full bg-secondary"></div> En cours / Bloqué
          </span>
        </div>
      </div>
      
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-neutral-bg/50">
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Date Création</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Prestation</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Destinataire</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Calculs (XOF)</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Net Versé</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-[0.2em] text-cocoa/40">Statut</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/30">
          <tr v-if="payoutsQuery.isLoading.value">
            <td colspan="6" class="px-8 py-10 text-center text-sm text-cocoa/60">
              Chargement de l'historique...
            </td>
          </tr>
          <tr v-else-if="filteredTransactions.length === 0">
            <td colspan="6" class="px-8 py-10 text-center text-sm text-cocoa/60">
              Aucun versement enregistré sur cette période.
            </td>
          </tr>
          <tr v-for="tx in filteredTransactions" :key="tx.id" class="hover:bg-neutral-bg/30 transition-colors">
            <td class="px-8 py-5">
              <p class="text-xs font-semibold text-espresso">{{ tx.date }}</p>
              <p class="text-[9px] text-cocoa/40 uppercase font-mono">{{ tx.id }}</p>
            </td>
            <td class="px-8 py-5">
              <p class="row-primary">{{ tx.service }}</p>
              <p class="row-meta">RDV : {{ tx.bookingDate }}</p>
            </td>
            <td class="px-8 py-5">
              <p class="row-primary">{{ tx.beneficiaryName }}</p>
              <p class="row-meta">{{ tx.beneficiaryPhone }} ({{ tx.payoutMethodLabel }})</p>
            </td>
            <td class="px-8 py-5">
              <p class="text-xs text-espresso">Brut : {{ formatMoneyXof(tx.grossAmount) }}</p>
              <p class="text-[10px] text-cocoa/60">Com : -{{ formatMoneyXof(tx.platformCommission) }}</p>
            </td>
            <td class="px-8 py-5">
              <p class="text-sm font-bold text-espresso">{{ tx.payoutAmountLabel }}</p>
              <p class="text-[9px] text-cocoa/40 font-bold">Réf: {{ tx.bookingId }}</p>
            </td>
            <td class="px-8 py-5">
              <div>
                <span :class="['px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest', tx.statusClass]">
                  {{ tx.statusLabel }}
                </span>
                <p v-if="tx.safeFailureMessage" class="text-[10px] text-error mt-1 max-w-[200px] leading-tight">
                  {{ tx.safeFailureMessage }}
                </p>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, reactive } from "vue";
import { useQuery } from "@tanstack/vue-query";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { toast } from "vue-sonner";
import { ArrowDownTrayIcon } from "@heroicons/vue/24/outline";
import {
  fetchProBookings,
  fetchProMerchantPayouts,
  fetchProPayoutSettings,
  updateProPayoutSettings
} from "@/lib/pro-api";
import { openPrintableReport } from "@/lib/download";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();
const period = ref<"30d" | "last-month" | "all">("30d");

// Settings query
const settingsQuery = useQuery({
  queryKey: ["pro-payout-settings"],
  queryFn: () => fetchProPayoutSettings(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const settings = computed(() => settingsQuery.data.value);

// Payout status mapping
const statusLabels: Record<string, string> = {
  blocked: "Bloqué",
  scheduled: "Planifié",
  creating: "En cours",
  created: "Créé",
  submitting: "En cours",
  pending: "En cours",
  succeeded: "Versé",
  failed_retryable: "Échoué (À retenir)",
  failed_terminal: "Échoué (Vérifiez coordonnées)",
  cancelled: "Annulé",
  manual_review: "En révision administrative"
};

const getStatusClass = (status: string): string => {
  if (status === "succeeded") return "bg-primary/10 text-primary";
  if (status === "cancelled") return "bg-cocoa/10 text-cocoa/60";
  if (status.startsWith("failed")) return "bg-error/10 text-error";
  return "bg-secondary/10 text-secondary";
};

// Verification status mappings
const verificationStatusLabel = computed(() => {
  const stat = settings.value?.payoutVerificationStatus;
  if (stat === "verified") return "Vérifié";
  if (stat === "rejected") return "Rejeté (Versement gelé)";
  return "Non vérifié (Versement gelé)";
});

const verificationStatusClass = computed(() => {
  const stat = settings.value?.payoutVerificationStatus;
  if (stat === "verified") return "bg-primary/10 text-primary";
  if (stat === "rejected") return "bg-error/10 text-error";
  return "bg-secondary/10 text-secondary";
});

const verificationStatusHelp = computed(() => {
  const stat = settings.value?.payoutVerificationStatus;
  if (stat === "verified") {
    return "Vos coordonnées ont été validées manuellement par l'équipe Beauté Avenue. Les versements peuvent partir automatiquement quand les autres conditions sont remplies.";
  }
  if (stat === "rejected") {
    return "L'équipe Beauté Avenue a rejeté ces coordonnées. Les versements restent gelés jusqu'à mise à jour puis nouvelle validation.";
  }
  return "Vos coordonnées n'ont pas encore été validées par l'équipe Beauté Avenue. Les versements restent gelés tant qu'un administrateur ne les approuve pas.";
});

// Edit mode state
const isEditingSettings = ref(false);
const savingSettings = ref(false);
const editForm = reactive({
  payoutMethod: "wave_senegal" as "wave_senegal" | "orange_money_senegal",
  payoutPhone: "",
  payoutName: "",
  password: ""
});

function startEditingSettings() {
  if (!settings.value) return;
  editForm.payoutMethod = settings.value.payoutMethod || "wave_senegal";
  // The phone is masked in GET response. We require the user to input the full number again when saving.
  editForm.payoutPhone = "";
  editForm.payoutName = settings.value.payoutName || "";
  editForm.password = "";
  isEditingSettings.value = true;
}

function cancelEditingSettings() {
  isEditingSettings.value = false;
}

async function saveSettings() {
  savingSettings.value = true;
  try {
    const updated = await updateProPayoutSettings(auth.accessToken ?? "", {
      payoutMethod: editForm.payoutMethod,
      payoutPhone: editForm.payoutPhone,
      payoutName: editForm.payoutName,
      password: editForm.password
    });
    settingsQuery.refetch();
    isEditingSettings.value = false;
    toast.success("Vos coordonnées de versement ont été mises à jour. En attente de validation.");
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Erreur de validation des coordonnées.");
  } finally {
    savingSettings.value = false;
  }
}

// Merchant payouts list query
const payoutsQuery = useQuery({
  queryKey: ["pro-merchant-payouts"],
  queryFn: () => fetchProMerchantPayouts(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const transactions = computed(() => {
  return (payoutsQuery.data.value ?? []).map((p) => {
    return {
      id: p.id,
      bookingId: p.bookingId,
      createdAt: p.createdAt,
      date: dayjs(p.createdAt).format("DD MMM YYYY, HH:mm"),
      bookingDate: p.bookingStartsAt ? dayjs(p.bookingStartsAt).format("DD MMM, HH:mm") : "—",
      service: p.serviceName ?? "Prestation",
      payoutMethodLabel: p.payoutMethod === "wave_senegal" ? "Wave" : "Orange Money",
      beneficiaryPhone: p.beneficiaryPhoneMasked,
      beneficiaryName: p.beneficiaryName,
      grossAmount: p.grossAmount,
      platformCommission: p.platformCommission,
      payoutAmount: p.payoutAmount,
      payoutAmountLabel: formatMoneyXof(p.payoutAmount),
      status: p.status,
      statusLabel: statusLabels[p.status] || p.status,
      statusClass: getStatusClass(p.status),
      safeFailureMessage: p.safeFailureMessage
    };
  });
});

const filteredTransactions = computed(() => {
  if (period.value === "all") return transactions.value;

  if (period.value === "last-month") {
    const start = dayjs().subtract(1, "month").startOf("month");
    const end = dayjs().subtract(1, "month").endOf("month");
    return transactions.value.filter((tx) => {
      const date = dayjs(tx.createdAt);
      return date.isAfter(start) && date.isBefore(end);
    });
  }

  const start = dayjs().subtract(30, "day").startOf("day");
  return transactions.value.filter((tx) => {
    const date = dayjs(tx.createdAt);
    return date.isAfter(start);
  });
});

const pendingAmount = computed(() =>
  filteredTransactions.value
    .filter((tx) => ["blocked", "scheduled", "creating", "created", "submitting", "pending", "manual_review"].includes(tx.status))
    .reduce((sum, tx) => sum + tx.payoutAmount, 0)
);

const releasedAmount = computed(() =>
  filteredTransactions.value
    .filter((tx) => tx.status === "succeeded")
    .reduce((sum, tx) => sum + tx.payoutAmount, 0)
);

const commissionAmount = computed(() =>
  filteredTransactions.value
    .reduce((sum, tx) => sum + tx.platformCommission, 0)
);

const releasedCount = computed(() => filteredTransactions.value.filter((tx) => tx.status === "succeeded").length);
const pendingAmountLabel = computed(() => formatMoneyXof(pendingAmount.value));
const releasedAmountLabel = computed(() => formatMoneyXof(releasedAmount.value));
const commissionAmountLabel = computed(() => formatMoneyXof(commissionAmount.value));

function printStatement() {
  if (filteredTransactions.value.length === 0) {
    toast.error("Aucun versement à exporter pour la période sélectionnée.");
    return;
  }

  try {
    openPrintableReport(
      "Relevé des règlements marchands",
      ["Date", "Bénéficiaire", "Méthode", "Brut (XOF)", "Comm. (XOF)", "Net Versé (XOF)", "Statut", "Réf RDV"],
      filteredTransactions.value.map((tx) => [
        tx.date,
        `${tx.beneficiaryName} (${tx.beneficiaryPhone})`,
        tx.payoutMethodLabel,
        tx.grossAmount.toString(),
        tx.platformCommission.toString(),
        tx.payoutAmount.toString(),
        tx.statusLabel,
        tx.bookingId
      ])
    );
    toast.success("Relevé prêt à imprimer.");
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Impossible d'ouvrir le relevé.");
  }
}
</script>
