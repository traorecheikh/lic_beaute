<template>
  <div class="max-w-5xl mx-auto">
    <div class="mb-8 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-1">Abonnement & Facturation</h1>
        <p class="text-cocoa/60">Gérez votre plan, vos factures et votre mode de paiement.</p>
      </div>
      <div v-if="subscriptionQuery.data.value" class="shrink-0">
        <span :class="statusBadgeClass">{{ statusBadgeLabel }}</span>
      </div>
    </div>

    <!-- Current Plan Hero -->
    <div class="panel-clean mb-8 bg-gradient-to-br from-espresso to-[#1B1730] text-white border-none shadow-xl relative overflow-hidden">
      <div class="absolute top-0 right-0 w-64 h-64 bg-primary/20 rounded-full blur-3xl -mr-32 -mt-32 pointer-events-none"></div>
      <div class="relative z-10 p-8 flex flex-col md:flex-row md:items-start justify-between gap-6">
        <div class="flex-1">
          <span class="px-3 py-1 rounded-full bg-white/10 text-[10px] font-bold uppercase tracking-widest mb-4 inline-block">Plan actuel</span>
          <h2 class="metric-value text-white mb-1">{{ currentPlanLabel }}</h2>
          <p class="text-white/50 text-sm leading-relaxed mt-2">{{ subscriptionDescription }}</p>
          <div v-if="renewsInDays !== null" class="mt-4 flex items-center gap-2">
            <CalendarDaysIcon class="w-4 h-4 text-white/40 shrink-0" />
            <span class="text-[12px] text-white/50">
              <template v-if="renewsInDays > 0">Renouvellement dans <strong class="text-white/80">{{ renewsInDays }} jour{{ renewsInDays === 1 ? '' : 's' }}</strong></template>
              <template v-else>Renouvellement aujourd'hui</template>
            </span>
          </div>
        </div>
        <div class="flex flex-col sm:flex-row gap-3 shrink-0">
          <button :disabled="toggleMutation.isPending.value" @click="toggleAutoRenew" class="btn-secondary bg-white/10 text-white border-white/20 hover:bg-white/20 hover:text-white px-5 text-sm disabled:opacity-60">
            {{ subscriptionQuery.data.value?.autoRenew ? 'Désactiver auto-renew' : 'Activer auto-renew' }}
          </button>
          <button v-if="subscriptionQuery.data.value?.tier !== 'premium'" :disabled="checkoutMutation.isPending.value" @click="upgradePlan" class="btn-gold px-5 text-sm disabled:opacity-60">
            {{ checkoutMutation.isPending.value ? "Redirection..." : "Passer en Premium" }}
          </button>
          <button v-else :disabled="checkoutMutation.isPending.value" @click="upgradePlan" class="btn-secondary bg-white/10 text-white border-white/20 hover:bg-white/20 hover:text-white px-5 text-sm disabled:opacity-60">
            {{ checkoutMutation.isPending.value ? "..." : "Renouveler" }}
          </button>
        </div>
      </div>
    </div>

    <!-- Plan comparison -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
      <div
        v-for="plan in planTiers"
        :key="plan.tier"
        :class="[
          'panel-clean p-6 relative transition-all',
          plan.tier === currentTier ? 'ring-2 ring-primary' : 'opacity-70 hover:opacity-90'
        ]"
      >
        <div v-if="plan.tier === currentTier" class="absolute -top-2.5 left-6">
          <span class="px-3 py-0.5 rounded-full bg-primary text-white text-[10px] font-bold uppercase tracking-widest">Plan actuel</span>
        </div>
        <div class="flex items-start justify-between mb-4">
          <div>
            <p class="row-primary text-base">{{ plan.label }}</p>
            <p class="metric-value text-2xl mt-1">{{ plan.priceLabel }}</p>
            <p class="row-meta">par mois</p>
          </div>
          <component :is="plan.tier === 'premium' ? StarIcon : SparklesIcon" class="w-8 h-8" :class="plan.tier === 'premium' ? 'text-secondary' : 'text-primary/40'" />
        </div>
        <ul class="space-y-2 mt-4">
          <li v-for="feature in plan.features" :key="feature.label" class="flex items-center gap-2.5">
            <CheckCircleIcon v-if="feature.included" class="w-4 h-4 text-primary shrink-0" />
            <XCircleIcon v-else class="w-4 h-4 text-cocoa/20 shrink-0" />
            <span :class="['text-sm', feature.included ? 'text-espresso font-medium' : 'text-cocoa/40 line-through']">{{ feature.label }}</span>
          </li>
        </ul>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Billing History -->
      <div class="lg:col-span-2 space-y-8">
        <section class="panel-clean overflow-hidden">
          <div class="p-6 border-b border-outline-variant/30 flex items-center justify-between">
            <h2 class="section-label">Historique des factures</h2>
            <span class="text-xs text-cocoa/40">{{ invoices.length }} facture{{ invoices.length !== 1 ? 's' : '' }}</span>
          </div>
          <div v-if="invoicesQuery.isLoading.value" class="p-8 text-center text-cocoa/40 text-sm">Chargement...</div>
          <div v-else-if="invoices.length === 0" class="p-8 text-center">
            <p class="row-meta">Aucune facture pour le moment.</p>
            <p class="text-xs text-cocoa/40 mt-1">Vos prochaines factures apparaîtront ici.</p>
          </div>
          <table v-else class="w-full text-left border-collapse">
            <thead>
              <tr class="bg-neutral-bg/40">
                <th class="section-label px-6 py-3">Date</th>
                <th class="section-label px-6 py-3">N° Facture</th>
                <th class="section-label px-6 py-3">Statut</th>
                <th class="section-label px-6 py-3 text-right">Montant</th>
                <th class="px-6 py-3"></th>
              </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant/30">
              <tr v-for="invoice in invoices" :key="invoice.id" class="hover:bg-neutral-bg/30 transition-colors">
                <td class="px-6 py-4 row-meta whitespace-nowrap">{{ invoice.date }}</td>
                <td class="px-6 py-4 row-primary font-mono text-xs">{{ invoice.invoiceNumber }}</td>
                <td class="px-6 py-4">
                  <span :class="invoice.statusClass">{{ invoice.statusLabel }}</span>
                </td>
                <td class="px-6 py-4 text-sm font-bold text-espresso text-right">{{ invoice.amountLabel }}</td>
                <td class="px-6 py-4 text-right">
                  <button @click="openInvoice(invoice)" class="p-1.5 hover:bg-neutral-bg rounded-lg text-cocoa/40 hover:text-primary transition" title="Télécharger la facture">
                    <ArrowDownTrayIcon class="w-4 h-4" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </section>
      </div>

      <!-- Sidebar -->
      <div class="space-y-6">
        <!-- Payment Method -->
        <section class="panel-clean p-6">
          <h2 class="section-label mb-5">Mode de paiement</h2>
          <div v-if="billingMethod" class="flex items-center gap-3 mb-5 p-3 rounded-xl bg-neutral-bg/50">
            <div
              :class="[
                'w-10 h-10 rounded-xl flex items-center justify-center shrink-0 border',
                billingMethod.provider === 'intech'
                  ? 'bg-primary/10 border-primary/20 text-primary'
                  : 'bg-cocoa/10 border-cocoa/20 text-cocoa'
              ]"
            >
              <WalletIcon v-if="billingMethod.provider === 'intech'" class="w-5 h-5" />
              <BanknotesIcon v-else class="w-5 h-5" />
            </div>
            <div class="min-w-0">
              <p class="text-sm font-bold text-espresso leading-none mb-0.5">{{ providerLabelMap[billingMethod.provider] }}</p>
              <p class="text-xs text-cocoa/40 truncate">{{ billingMethod.accountNumberMasked }}</p>
            </div>
          </div>
          <div v-else class="mb-5 p-3 rounded-xl bg-amber-50 border border-amber-100">
            <p class="text-xs font-semibold text-amber-700">Aucun moyen de paiement configuré.</p>
            <p class="text-xs text-amber-600/70 mt-0.5">Requis pour le renouvellement automatique.</p>
          </div>
          <button @click="openPaymentMethodModal" class="btn-secondary w-full py-2.5 text-xs ring-0 border flex items-center justify-center gap-2">
            <CreditCardIcon class="w-4 h-4" />
            {{ billingMethod ? "Modifier" : "Configurer" }}
          </button>
        </section>

        <!-- Auto-renew status -->
        <section class="panel-clean p-6">
          <h2 class="section-label mb-4">Renouvellement automatique</h2>
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-semibold text-espresso">{{ subscriptionQuery.data.value?.autoRenew ? 'Activé' : 'Désactivé' }}</p>
              <p class="text-xs text-cocoa/40 mt-0.5 leading-relaxed">
                {{ subscriptionQuery.data.value?.autoRenew ? 'Votre abonnement se renouvelle automatiquement.' : 'Vous devrez renouveler manuellement.' }}
              </p>
            </div>
            <button
              :disabled="toggleMutation.isPending.value"
              @click="toggleAutoRenew"
              :class="[
                'w-11 h-6 rounded-full transition-colors relative shrink-0',
                subscriptionQuery.data.value?.autoRenew ? 'bg-primary' : 'bg-outline-variant',
                'disabled:opacity-50'
              ]"
            >
              <span :class="['absolute top-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform', subscriptionQuery.data.value?.autoRenew ? 'translate-x-5' : 'translate-x-0.5']"></span>
            </button>
          </div>
        </section>

        <!-- Support -->
        <section class="panel-clean p-6">
          <h2 class="section-label mb-3">Support</h2>
          <p class="text-xs text-cocoa/60 leading-relaxed mb-4">Une question sur votre abonnement ou une facture ?</p>
          <button @click="contactSupport" class="btn-secondary w-full py-2.5 text-xs ring-0 border flex items-center justify-center gap-2">
            <ChatBubbleLeftEllipsisIcon class="w-4 h-4" />
            Contacter le support
          </button>
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
            <option v-if="features?.billingProviders?.intech" value="intech">Intech (Mobile Money)</option>
            <option v-if="features?.billingProviders?.paydunya" value="paydunya">PayDunya (Carte ou Mobile Money)</option>
            <option v-if="features?.billingProviders?.manual" value="manual">Manuel (hors ligne)</option>
          </select>
        </div>
        <!-- PayDunya country + method sub-selection -->
        <template v-if="paymentMethodForm.provider === 'paydunya'">
          <div>
            <label class="section-label mb-2 block">Pays</label>
            <select v-model="paymentMethodForm.country" class="input-shell">
              <option value="sn">Sénégal</option>
              <option value="ci">Côte d'Ivoire</option>
              <option value="ml">Mali</option>
              <option value="bf">Burkina Faso</option>
              <option value="bj">Bénin</option>
              <option value="tg">Togo</option>
              <option value="cm">Cameroun</option>
            </select>
          </div>
          <div>
            <label class="section-label mb-2 block">Méthode</label>
            <select v-model="paymentMethodForm.method" class="input-shell">
              <option value="wave">Wave</option>
              <option value="orange_money">Orange Money</option>
              <option value="free_money">Free Money</option>
              <option v-if="features?.billingProviders?.card" value="paydunya_card">Carte bancaire</option>
            </select>
          </div>
        </template>
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
  XCircleIcon,
  ArrowDownTrayIcon,
  WalletIcon,
  BanknotesIcon,
  CalendarDaysIcon,
  StarIcon,
  SparklesIcon,
  CreditCardIcon,
  ChatBubbleLeftEllipsisIcon
} from "@heroicons/vue/24/outline";
import {
  checkoutProSubscription,
  downloadProInvoicePdf,
  fetchProInvoices,
  fetchProSubscription,
  fetchProSubscriptionFeatures,
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
  provider: "paydunya" as string,
  accountNumber: "",
  country: "sn",
  method: "wave"
});

const features = computed(() => featuresQuery.data.value);

const providerLabelMap: Record<string, string> = {
  paydunya: "PayDunya (Carte ou Mobile Money)",
  intech: "Intech (Mobile Money)",
  manual: "Manuel (hors ligne)"
};

const subscriptionQuery = useQuery({
  queryKey: ["pro-subscription"],
  queryFn: () => fetchProSubscription(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const featuresQuery = useQuery({
  queryKey: ["pro-subscription-features"],
  queryFn: () => fetchProSubscriptionFeatures(auth.accessToken ?? ""),
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
  mutationFn: (billingMethod: Record<string, unknown>) =>
    updateProSubscription(auth.accessToken ?? "", {
      billingMethod: billingMethod as { provider: string; accountNumber: string }
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

const currentTier = computed(() => subscriptionQuery.data.value?.tier ?? "standard");

const statusBadgeClass = computed(() => {
  const status = subscriptionQuery.data.value?.status;
  if (status === "active") return "px-3 py-1 rounded-full bg-primary/10 text-primary text-[11px] font-bold uppercase tracking-widest";
  if (status === "past_due") return "px-3 py-1 rounded-full bg-amber-100 text-amber-700 text-[11px] font-bold uppercase tracking-widest";
  if (status === "expired") return "px-3 py-1 rounded-full bg-red-100 text-red-600 text-[11px] font-bold uppercase tracking-widest";
  if (status === "paused") return "px-3 py-1 rounded-full bg-amber-100 text-amber-700 text-[11px] font-bold uppercase tracking-widest";
  return "px-3 py-1 rounded-full bg-outline-variant/30 text-cocoa/60 text-[11px] font-bold uppercase tracking-widest";
});

const statusBadgeLabel = computed(() => {
  const status = subscriptionQuery.data.value?.status;
  if (status === "active") return "Actif";
  if (status === "past_due") return "Échéance dépassée";
  if (status === "expired") return "Expiré";
  if (status === "paused") return "En pause";
  if (status === "cancelled") return "Annulé";
  if (status === "inactive") return "Inactif";
  return status ?? "—";
});

const renewsInDays = computed<number | null>(() => {
  const renewsAt = subscriptionQuery.data.value?.renewsAt;
  if (!renewsAt) return null;
  const diff = dayjs(renewsAt).startOf("day").diff(dayjs().startOf("day"), "day");
  return diff >= 0 ? diff : null;
});

const planTiers = computed(() => {
  const apiTiers = featuresQuery.data.value?.planTiers;
  if (apiTiers && apiTiers.length > 0) return apiTiers;

  // Fallback while loading
  return [
    {
      tier: "standard" as const,
      label: "Standard",
      priceLabel: "15 000 XOF",
      features: [
        { label: "Agenda illimité", included: true },
        { label: "Gestion de l'équipe", included: true },
        { label: "Acompte client", included: false },
        { label: "Rapports financiers", included: false },
        { label: "Export CSV", included: false },
        { label: "Badge « Vérifié »", included: false },
        { label: "Support prioritaire 24/7", included: false }
      ]
    },
    {
      tier: "premium" as const,
      label: "Premium",
      priceLabel: "30 000 XOF",
      features: [
        { label: "Agenda illimité", included: true },
        { label: "Gestion de l'équipe", included: true },
        { label: "Acompte client", included: true },
        { label: "Rapports financiers", included: true },
        { label: "Export CSV", included: true },
        { label: "Badge « Vérifié »", included: true },
        { label: "Support prioritaire 24/7", included: true }
      ]
    }
  ];
});

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
  const billingMethod: Record<string, unknown> = {
    provider: paymentMethodForm.provider,
    accountNumber: paymentMethodForm.accountNumber.trim()
  };
  if (paymentMethodForm.provider === "paydunya") {
    billingMethod.country = paymentMethodForm.country;
    billingMethod.method = paymentMethodForm.method;
  }
  paymentMethodMutation.mutate(billingMethod);
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
