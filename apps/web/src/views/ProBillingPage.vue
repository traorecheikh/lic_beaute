<template>
  <div class="max-w-4xl mx-auto">
    <div class="mb-8">
      <h1 class="page-title mb-2">Abonnement & Facturation</h1>
      <p class="text-cocoa/60">Gérez votre plan Beauté Avenue et vos factures.</p>
    </div>

    <!-- Current Plan -->
    <div class="panel-clean p-8 mb-10 bg-gradient-to-br from-espresso to-[#1B1730] text-white border-none shadow-xl relative overflow-hidden">
      <div class="absolute top-0 right-0 w-64 h-64 bg-primary/20 rounded-full blur-3xl -mr-32 -mt-32"></div>
      
      <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-8">
        <div>
          <span class="px-3 py-1 rounded-full bg-primary text-[10px] font-bold uppercase tracking-widest mb-4 inline-block">Plan Actuel</span>
          <h2 class="metric-value mb-2">{{ currentPlanLabel }}</h2>
          <p class="text-white/60 row-meta">{{ subscriptionDescription }}</p>
        </div>
        <div class="flex gap-3">
          <button :disabled="toggleMutation.isPending.value" @click="toggleAutoRenew" class="btn-secondary bg-white/10 text-white border-white/20 hover:bg-white/20 hover:text-white px-6 disabled:opacity-60">
            {{ toggleMutation.isPending.value ? "..." : "Gérer" }}
          </button>
          <button :disabled="checkoutMutation.isPending.value" @click="upgradePlan" class="btn-gold px-6 disabled:opacity-60">
            {{ checkoutMutation.isPending.value ? "..." : "Améliorer" }}
          </button>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <!-- Entitlements -->
      <div class="md:col-span-2 space-y-8">
        <section class="panel-clean p-8">
          <h2 class="section-label mb-6">Inclus dans votre plan</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div v-for="benefit in benefits" :key="benefit" class="flex items-center gap-3">
              <CheckCircleIcon class="w-5 h-5 text-primary shrink-0" />
              <span class="text-sm text-espresso font-medium">{{ benefit }}</span>
            </div>
          </div>
        </section>

        <!-- Billing History -->
        <section class="panel-clean overflow-hidden">
          <div class="p-8 border-b border-outline-variant/30">
            <h2 class="section-label">Historique des factures</h2>
          </div>
          <table class="w-full text-left border-collapse">
            <tbody class="divide-y divide-outline-variant/30">
              <tr v-for="invoice in invoices" :key="invoice.id" class="hover:bg-neutral-bg/30 transition-colors">
                <td class="px-8 py-4">
                  <p class="row-primary">{{ invoice.date }}</p>
                  <p class="row-meta">{{ invoice.invoiceNumber }}</p>
                </td>
                <td class="px-8 py-4">
                  <span :class="invoice.statusClass">{{ invoice.statusLabel }}</span>
                </td>
                <td class="px-8 py-4 text-sm font-bold text-espresso">{{ invoice.amountLabel }}</td>
                <td class="px-8 py-4 text-right">
                  <button @click="openInvoice(invoice)" class="p-2 hover:bg-white rounded-full text-cocoa/60 hover:text-primary transition shadow-sm">
                    <ArrowDownTrayIcon class="w-4 h-4" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </section>
      </div>

      <!-- Payment Method -->
      <div class="space-y-8">
        <section class="panel-clean p-6">
          <h2 class="section-label mb-6">Mode de paiement</h2>
          <div v-if="billingMethod" class="flex items-center gap-4 mb-6">
            <div
              :class="[
                'w-12 h-12 rounded-xl flex items-center justify-center p-2 border',
                billingMethod.provider === 'intech'
                  ? 'bg-primary/10 border-primary/20 text-primary'
                  : 'bg-cocoa/10 border-cocoa/20 text-cocoa'
              ]"
            >
              <WalletIcon v-if="billingMethod.provider === 'intech'" class="w-6 h-6" />
              <BanknotesIcon v-else class="w-6 h-6" />
            </div>
            <div>
              <p class="text-sm font-bold text-espresso">{{ providerLabelMap[billingMethod.provider] }}</p>
              <p class="text-xs text-cocoa/40">{{ billingMethod.accountNumberMasked }}</p>
            </div>
          </div>
          <p v-else class="row-meta mb-6">Aucun mode de paiement configuré.</p>
          <button @click="openPaymentMethodModal" class="btn-secondary w-full py-2 text-[10px] ring-0 border">
            {{ billingMethod ? "Modifier" : "Configurer" }}
          </button>
        </section>

        <section class="panel-clean p-6 bg-primary/5 border-primary/10">
          <h2 class="section-label mb-4 text-primary">Besoin d'aide ?</h2>
          <p class="text-xs text-cocoa/60 leading-relaxed mb-4">Une question sur votre facture ou votre abonnement ?</p>
          <button @click="contactSupport" class="text-xs font-bold text-primary uppercase tracking-widest hover:underline">Contacter le support</button>
        </section>
      </div>
    </div>

    <Modal
      :show="showPaymentMethodModal"
      title="Mode de paiement"
      subtitle="Ce mode sera utilisé pour vos flux d'abonnement."
      max-width="md"
      @close="closePaymentMethodModal"
    >
      <div class="space-y-4">
        <div>
          <label class="section-label mb-2 block">Fournisseur</label>
          <select v-model="paymentMethodForm.provider" class="input-shell">
            <option value="intech">Intech (Mobile Money)</option>
            <option value="manual">Manuel (hors ligne)</option>
          </select>
        </div>
        <div>
          <label class="section-label mb-2 block">Numéro de compte</label>
          <input
            v-model="paymentMethodForm.accountNumber"
            class="input-shell"
            placeholder="77 123 45 67"
          />
        </div>
      </div>
      <template #footer>
        <div class="flex items-center justify-between gap-2">
          <button
            v-if="billingMethod"
            type="button"
            class="btn-secondary"
            :disabled="clearPaymentMethodMutation.isPending.value"
            @click="clearPaymentMethod"
          >
            Supprimer
          </button>
          <span v-else></span>
          <div class="flex items-center gap-2">
            <button type="button" class="btn-secondary" @click="closePaymentMethodModal">Annuler</button>
            <button
              type="button"
              class="btn-primary"
              :disabled="paymentMethodMutation.isPending.value"
              @click="savePaymentMethod"
            >
              {{ paymentMethodMutation.isPending.value ? "Enregistrement..." : "Enregistrer" }}
            </button>
          </div>
        </div>
      </template>
    </Modal>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { 
  CheckCircleIcon, 
  ArrowDownTrayIcon,
  WalletIcon,
  BanknotesIcon
} from "@heroicons/vue/24/outline";
import {
  checkoutProSubscription,
  downloadProInvoicePdf,
  fetchProInvoices,
  fetchProSubscription,
  updateProSubscription
} from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";
import { toast } from "vue-sonner";
import Modal from "@/components/Modal.vue";

const auth = useProAuthStore();
const queryClient = useQueryClient();
const apiBaseUrl = (import.meta.env.VITE_API_URL as string | undefined) ?? "http://localhost:3000";
const showPaymentMethodModal = ref(false);
const paymentMethodForm = reactive({
  provider: "intech" as "intech" | "manual",
  accountNumber: ""
});

const providerLabelMap: Record<"intech" | "manual", string> = {
  intech: "Intech",
  manual: "Manuel"
};

const subscriptionQuery = useQuery({
  queryKey: ["pro-subscription"],
  queryFn: () => fetchProSubscription(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const invoicesQuery = useQuery({
  queryKey: ["pro-invoices"],
  queryFn: () => fetchProInvoices(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const toggleMutation = useMutation({
  mutationFn: (autoRenew: boolean) => updateProSubscription(auth.accessToken ?? "", { autoRenew }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
    toast.success("Paramètres d'abonnement mis à jour.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Mise à jour impossible pour le moment."));
  }
});

const paymentMethodMutation = useMutation({
  mutationFn: () =>
    updateProSubscription(auth.accessToken ?? "", {
      billingMethod: {
        provider: paymentMethodForm.provider,
        accountNumber: paymentMethodForm.accountNumber.trim()
      }
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
    toast.success("Mode de paiement mis à jour.");
    closePaymentMethodModal();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Mise à jour impossible pour le moment."));
  }
});

const clearPaymentMethodMutation = useMutation({
  mutationFn: () => updateProSubscription(auth.accessToken ?? "", { billingMethod: null }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
    toast.success("Mode de paiement supprimé.");
    closePaymentMethodModal();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Suppression impossible pour le moment."));
  }
});

const checkoutMutation = useMutation({
  mutationFn: () =>
    checkoutProSubscription(auth.accessToken ?? "", {
      action: subscriptionQuery.data.value?.tier === "premium" ? "renewal" : "upgrade",
      provider: "intech"
    }),
  onSuccess: (result) => {
    window.open(result.redirectUrl, "_blank", "noopener,noreferrer");
    toast.success("Redirection vers le paiement.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Paiement impossible pour le moment."));
  }
});

const benefits = [
  "Agenda illimité",
  "Paiements Mobile Money via Intech",
  "Rapports financiers complets",
  "Export CSV des données",
  "Marketing SMS (500/mois)",
  "Fidélisation client",
  "Support prioritaire 24/7",
  "Badge 'Vérifié' sur l'app"
];

const currentPlanLabel = computed(() => {
  const tier = subscriptionQuery.data.value?.tier ?? "standard";
  return tier === "premium" ? "Beauté Avenue Premium" : "Beauté Avenue Standard";
});

const subscriptionDescription = computed(() => {
  const sub = subscriptionQuery.data.value;
  if (!sub) return "Chargement de l'abonnement...";
  const renewDate = sub.renewsAt ? dayjs(sub.renewsAt).format("DD MMMM YYYY") : "date non définie";
  const autoRenewLabel = sub.autoRenew ? "renouvellement auto actif" : "renouvellement auto désactivé";
  return `Prochaine échéance le ${renewDate} • ${autoRenewLabel}`;
});

const billingMethod = computed(() => subscriptionQuery.data.value?.billingMethod ?? null);

const invoices = computed(() => {
  return (invoicesQuery.data.value ?? []).map((invoice) => ({
    id: invoice.id,
    invoiceNumber: invoice.invoiceNumber,
    pdfUrl: invoice.pdfUrl,
    amountXof: invoice.amountXof,
    createdAt: invoice.createdAt,
    date: dayjs(invoice.createdAt).format("DD MMMM YYYY"),
    amountLabel: formatMoneyXof(invoice.amountXof),
    statusLabel: invoice.status === "paid" ? "Payé" : invoice.status,
    statusClass: invoice.status === "paid"
      ? "px-2 py-0.5 rounded-full bg-primary/10 text-primary text-[10px] font-bold uppercase tracking-wider"
      : "px-2 py-0.5 rounded-full bg-secondary/10 text-secondary text-[10px] font-bold uppercase tracking-wider"
  }));
});

function toggleAutoRenew() {
  const current = subscriptionQuery.data.value?.autoRenew;
  if (current === undefined) return;
  toggleMutation.mutate(!current);
}

function upgradePlan() {
  checkoutMutation.mutate();
}

async function openInvoice(invoice: (typeof invoices.value)[number]) {
  if (!invoice.pdfUrl) {
    toast.error("Lien de facture indisponible.");
    return;
  }

  if (invoice.pdfUrl.startsWith("/api/v1/pro/invoices/")) {
    try {
      const blob = await downloadProInvoicePdf(auth.accessToken ?? "", invoice.id);
      const url = URL.createObjectURL(blob);
      const anchor = document.createElement("a");
      anchor.href = url;
      anchor.download = `${invoice.invoiceNumber}.pdf`;
      anchor.rel = "noopener";
      document.body.appendChild(anchor);
      anchor.click();
      document.body.removeChild(anchor);
      URL.revokeObjectURL(url);
      toast.success(`Facture ${invoice.invoiceNumber} téléchargée.`);
    } catch (error) {
      toast.error(getErrorMessage(error, "Téléchargement de facture impossible."));
    }
    return;
  }

  const target = invoice.pdfUrl.startsWith("http") ? invoice.pdfUrl : `${apiBaseUrl}${invoice.pdfUrl}`;
  window.open(target, "_blank", "noopener,noreferrer");
  toast.success(`Facture ${invoice.invoiceNumber} ouverte.`);
}

function openPaymentMethodModal() {
  paymentMethodForm.provider = billingMethod.value?.provider ?? "intech";
  paymentMethodForm.accountNumber = "";
  showPaymentMethodModal.value = true;
}

function closePaymentMethodModal() {
  showPaymentMethodModal.value = false;
}

function savePaymentMethod() {
  if (!paymentMethodForm.accountNumber.trim()) {
    toast.error("Le numéro de compte est requis.");
    return;
  }
  paymentMethodMutation.mutate();
}

function clearPaymentMethod() {
  clearPaymentMethodMutation.mutate();
}

function contactSupport() {
  const subject = encodeURIComponent("Support abonnement Beauté Avenue");
  const body = encodeURIComponent("Bonjour,\nJ'ai besoin d'aide concernant mon abonnement/facturation.\nMerci.");
  window.open(`mailto:support@beauteavenue.sn?subject=${subject}&body=${body}`, "_blank", "noopener,noreferrer");
}
</script>
