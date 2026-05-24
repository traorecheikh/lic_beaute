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
          <button v-if="subscriptionQuery.data.value?.tier !== 'premium'" :disabled="isSubmitting" @click="openCheckoutModal" class="btn-gold px-5 text-sm disabled:opacity-60">
            Passer en Premium
          </button>
          <button v-else :disabled="isSubmitting" @click="openCheckoutModal" class="btn-secondary bg-white/10 text-white border-white/20 hover:bg-white/20 hover:text-white px-5 text-sm disabled:opacity-60">
            Renouveler
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
              class="w-10 h-10 rounded-xl flex items-center justify-center shrink-0 border bg-primary/10 border-primary/20 text-primary"
            >
              <BanknotesIcon class="w-5 h-5" />
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

    <!-- Native Inline Subscription Checkout Modal -->
    <Modal
      :show="showCheckoutModal"
      title="Abonnement Beauté Avenue"
      subtitle="Finalisez votre paiement sécurisé sans redirection."
      max-width="lg"
      @close="showCheckoutModal = false"
    >
      <div class="space-y-4">
        <!-- Step 1: Select Country and Method -->
        <div v-if="checkoutStep === 'select_method'" class="space-y-4">
          <div>
            <label class="section-label mb-2 block">Pays de facturation</label>
            <select v-model="selectedCountry" class="input-shell">
              <option value="sn">Sénégal</option>
              <option value="ci">Côte d'Ivoire</option>
              <option value="bf">Burkina Faso</option>
              <option value="bj">Bénin</option>
              <option value="tg">Togo</option>
              <option value="ml">Mali</option>
              <option value="cm">Cameroun</option>
              <option value="intl">International / Autre</option>
            </select>
          </div>

          <div>
            <label class="section-label mb-2 block font-semibold text-espresso">Moyen de paiement</label>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 mt-1.5">
              <button
                v-for="method in filteredMethods"
                :key="method.code"
                type="button"
                @click="selectCheckoutMethod(method.code)"
                class="flex items-center gap-3 p-4 rounded-xl border transition-all text-left bg-white"
                :class="selectedMethod === method.code ? 'border-primary ring-2 ring-primary bg-primary/5' : 'border-outline-variant/60 hover:border-cocoa/40'"
              >
                <div class="w-10 h-10 rounded-full bg-neutral-bg flex items-center justify-center shrink-0">
                  <CreditCardIcon v-if="method.code === 'carte_bancaire'" class="w-5 h-5 text-cocoa/60" />
                  <WalletIcon v-else class="w-5 h-5 text-cocoa/60" />
                </div>
                <div>
                  <p class="text-xs font-bold text-espresso">{{ method.label }}</p>
                  <p class="text-[10px] text-cocoa/40 uppercase font-mono">{{ method.code.replace('_', ' ') }}</p>
                </div>
              </button>
            </div>
          </div>
        </div>

        <!-- Step 2: Enter credentials -->
        <div v-if="checkoutStep === 'enter_details'" class="space-y-4">
          <button type="button" @click="checkoutStep = 'select_method'" class="btn-secondary py-1 px-3 text-xs flex items-center gap-1.5 border mb-2">
            <ArrowLeftIcon class="w-3.5 h-3.5" />
            Retour aux options
          </button>

          <h4 class="text-sm font-bold text-espresso">Détails de paiement - {{ selectedMethodLabel }}</h4>

          <!-- Card Form -->
          <div v-if="selectedMethod === 'carte_bancaire'" class="space-y-3">
            <div>
              <label class="section-label mb-1 block">Nom complet sur la carte</label>
              <input v-model="cardForm.fullName" type="text" class="input-shell" placeholder="John Doe" />
            </div>
            <div>
              <label class="section-label mb-1 block">Email</label>
              <input v-model="cardForm.email" type="email" class="input-shell" placeholder="john.doe@example.com" />
            </div>
            <div>
              <label class="section-label mb-1 block">Numéro de carte</label>
              <input v-model="cardForm.cardNumber" type="text" class="input-shell" placeholder="4111 1111 1111 1111" @input="formatCardNumber" />
            </div>
            <div class="grid grid-cols-3 gap-2">
              <div>
                <label class="section-label mb-1 block">Mois exp. (MM)</label>
                <input v-model="cardForm.expiryMonth" type="text" maxlength="2" class="input-shell" placeholder="12" />
              </div>
              <div>
                <label class="section-label mb-1 block">Année exp. (YY)</label>
                <input v-model="cardForm.expiryYear" type="text" maxlength="2" class="input-shell" placeholder="28" />
              </div>
              <div>
                <label class="section-label mb-1 block">CVV</label>
                <input v-model="cardForm.cvv" type="password" maxlength="4" class="input-shell" placeholder="123" />
              </div>
            </div>
            <div class="flex items-start gap-2.5 p-3 rounded-xl bg-red-50 border border-red-100 mt-2">
              <input v-model="cardForm.pciAccepted" type="checkbox" id="pci-check" class="mt-1" />
              <label for="pci-check" class="text-xs text-red-700 leading-normal select-none">
                Je reconnais que la transaction est soumise aux règles de sécurité PCI-DSS et j'accepte de soumettre mes informations de carte bancaire.
              </label>
            </div>
          </div>

          <!-- PayDunya Wallet Form -->
          <div v-else-if="selectedMethod === 'paydunya_wallet'" class="space-y-3">
            <div>
              <label class="section-label mb-1 block">Numéro de téléphone / Email PayDunya</label>
              <input v-model="walletForm.phone" type="text" class="input-shell" placeholder="john.doe@example.com ou 77XXXXXXX" />
            </div>
            <div>
              <label class="section-label mb-1 block">Mot de passe PayDunya</label>
              <input v-model="walletForm.password" type="password" class="input-shell" placeholder="••••••••" />
            </div>
          </div>

          <!-- Mobile Money / Generic Wallet Form -->
          <div v-else class="space-y-3">
            <div>
              <label class="section-label mb-1 block">Numéro de téléphone mobile money</label>
              <input v-model="mobileMoneyForm.phone" type="text" class="input-shell" placeholder="77XXXXXXX" />
            </div>
            <div>
              <label class="section-label mb-1 block">Nom complet</label>
              <input v-model="mobileMoneyForm.fullName" type="text" class="input-shell" placeholder="John Doe" />
            </div>
            <div>
              <label class="section-label mb-1 block">Email</label>
              <input v-model="mobileMoneyForm.email" type="email" class="input-shell" placeholder="john.doe@example.com" />
            </div>

            <!-- OTP prompt for OM CI / OM BF -->
            <div v-if="selectedMethod === 'om_ci' || selectedMethod === 'om_bf'" class="space-y-3 pt-2">
              <div class="p-3 rounded-xl bg-primary/5 text-primary text-xs leading-relaxed">
                <span class="font-bold block mb-1">Instruction OTP obligatoire :</span>
                <template v-if="selectedMethod === 'om_ci'">
                  Composez le <strong>#144*82#</strong> pour obtenir un code d'autorisation Orange Money.
                </template>
                <template v-else-if="selectedMethod === 'om_bf'">
                  Générez un code OTP Orange Money en composant le <strong>*144*4*6*montant#</strong>.
                </template>
              </div>
              <div>
                <label class="section-label mb-1 block">Code d'autorisation OTP</label>
                <input v-model="mobileMoneyForm.otp" type="text" class="input-shell" placeholder="1234" />
              </div>
            </div>
          </div>
        </div>

        <!-- Step 3: QR Code rendering -->
        <div v-if="checkoutStep === 'qr_code'" class="space-y-4 text-center">
          <h4 class="text-sm font-bold text-espresso">Scannez le QR Code Orange Money</h4>
          <p class="text-xs text-cocoa/60 max-w-sm mx-auto">
            Ouvrez votre application Orange Money et scannez ce QR Code pour valider votre paiement.
          </p>
          <div class="inline-block p-4 bg-white rounded-2xl border border-outline-variant/60 mx-auto mt-2">
            <img :src="`data:image/png;base64,${qrCodeBase64}`" class="w-48 h-48 block" alt="Orange Money QR Code" />
          </div>
        </div>

        <!-- Step 4: 3DS Redirect container -->
        <div v-if="checkoutStep === 'three_ds'" class="space-y-4">
          <h4 class="text-sm font-bold text-espresso text-center">Authentification 3D Secure</h4>
          <p class="text-xs text-cocoa/60 text-center max-w-sm mx-auto">
            Veuillez compléter l'authentification 3D Secure ci-dessous auprès de votre banque pour valider la transaction.
          </p>
          <div class="w-full border border-outline-variant/40 rounded-2xl overflow-hidden bg-neutral-bg mt-2">
            <iframe :src="threeDsUrl" class="w-full h-[450px]" frameborder="0"></iframe>
          </div>
        </div>

        <!-- Step 5: Wizall SMS OTP validation -->
        <div v-if="checkoutStep === 'wizall_otp'" class="space-y-4">
          <h4 class="text-sm font-bold text-espresso">Validation OTP Wizall</h4>
          <p class="text-xs text-cocoa/60">
            Saisissez le code de validation reçu par SMS pour finaliser le paiement Wizall.
          </p>
          <div>
            <label class="section-label mb-1 block">Code de validation (OTP)</label>
            <input v-model="wizallOtpCode" type="text" class="input-shell" placeholder="12345" />
          </div>
        </div>
      </div>

      <template #footer>
        <div class="flex items-center justify-end gap-2">
          <button type="button" class="btn-secondary text-xs" @click="showCheckoutModal = false">Fermer</button>
          
          <button
            v-if="checkoutStep === 'select_method'"
            type="button"
            class="btn-primary text-xs"
            :disabled="!selectedMethod"
            @click="checkoutStep = 'enter_details'"
          >
            Continuer
          </button>
          
          <button
            v-if="checkoutStep === 'enter_details'"
            type="button"
            class="btn-primary text-xs"
            :disabled="isSubmitting"
            @click="handleCheckoutSubmit"
          >
            {{ isSubmitting ? 'Paiement...' : 'Confirmer et Payer' }}
          </button>

          <button
            v-if="checkoutStep === 'wizall_otp'"
            type="button"
            class="btn-primary text-xs"
            :disabled="isSubmitting"
            @click="handleWizallOtpSubmit"
          >
            {{ isSubmitting ? 'Validation...' : 'Valider le code' }}
          </button>

          <button
            v-if="checkoutStep === 'qr_code' || checkoutStep === 'three_ds'"
            type="button"
            class="btn-primary text-xs"
            @click="finalizeCheckoutReconciliation"
          >
            J'ai finalisé le paiement
          </button>
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
  ChatBubbleLeftEllipsisIcon,
  ArrowLeftIcon
} from "@heroicons/vue/24/outline";
import {
  checkoutProSubscription,
  executeProSubscription,
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
      provider: "paydunya"
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

const showCheckoutModal = ref(false);
const checkoutStep = ref<'select_method' | 'enter_details' | 'qr_code' | 'three_ds' | 'wizall_otp'>('select_method');
const selectedCountry = ref('sn');
const selectedMethod = ref('');
const isSubmitting = ref(false);
const chargeId = ref('');
const qrCodeBase64 = ref('');
const threeDsUrl = ref('');
const wizallOtpCode = ref('');
const wizallCid = ref('');

const cardForm = reactive({
  fullName: "",
  email: "",
  cardNumber: "",
  expiryMonth: "",
  expiryYear: "",
  cvv: "",
  pciAccepted: false
});

const walletForm = reactive({
  phone: "",
  password: ""
});

const mobileMoneyForm = reactive({
  phone: "",
  fullName: "",
  email: "",
  otp: ""
});

const checkoutMethods = [
  { code: "carte_bancaire", label: "Carte Bancaire", country: "intl" },
  { code: "djamo", label: "Djamo", country: "intl" },
  { code: "paydunya_wallet", label: "Portefeuille PayDunya", country: "intl" },
  { code: "wave_senegal", label: "Wave Sénégal", country: "sn" },
  { code: "orange_senegal", label: "Orange Money Sénégal", country: "sn" },
  { code: "free_senegal", label: "Free Money Sénégal", country: "sn" },
  { code: "wizall_senegal", label: "Wizall Sénégal", country: "sn" },
  { code: "expresso_sn", label: "Expresso Sénégal", country: "sn" },
  { code: "om_ci", label: "Orange Money Côte d'Ivoire", country: "ci" },
  { code: "mtn_ci", label: "MTN Money Côte d'Ivoire", country: "ci" },
  { code: "moov_ci", label: "Moov Côte d'Ivoire", country: "ci" },
  { code: "wave_ci", label: "Wave Côte d'Ivoire", country: "ci" },
  { code: "om_bf", label: "Orange Money Burkina Faso", country: "bf" },
  { code: "moov_bf", label: "Moov Burkina Faso", country: "bf" },
  { code: "moov_bj", label: "Moov Bénin", country: "bj" },
  { code: "mtn_bj", label: "MTN Bénin", country: "bj" },
  { code: "t_money_tg", label: "T-Money Togo", country: "tg" },
  { code: "moov_tg", label: "Moov Togo", country: "tg" },
  { code: "om_ml", label: "Orange Money Mali", country: "ml" },
  { code: "moov_ml", label: "Moov Mali", country: "ml" },
  { code: "mtn_cm", label: "MTN Cameroun", country: "cm" }
];

const filteredMethods = computed(() => {
  return checkoutMethods.filter(m => m.country === selectedCountry.value || m.code === "carte_bancaire");
});

const selectedMethodLabel = computed(() => {
  const method = checkoutMethods.find(m => m.code === selectedMethod.value);
  return method ? method.label : "";
});

function selectCheckoutMethod(code: string) {
  selectedMethod.value = code;
}

function formatCardNumber(e: Event) {
  const target = e.target as HTMLInputElement;
  const digits = target.value.replace(/\s+/g, '');
  let formatted = '';
  for (let i = 0; i < digits.length; i++) {
    if (i > 0 && i % 4 === 0) formatted += ' ';
    formatted += digits[i];
  }
  cardForm.cardNumber = formatted;
}

function openCheckoutModal() {
  checkoutStep.value = "select_method";
  selectedMethod.value = "";
  qrCodeBase64.value = "";
  threeDsUrl.value = "";
  wizallOtpCode.value = "";
  wizallCid.value = "";
  isSubmitting.value = false;

  const user = auth.currentUser;
  if (user) {
    cardForm.fullName = user.fullName;
    cardForm.email = user.email ?? "";
    mobileMoneyForm.fullName = user.fullName;
    mobileMoneyForm.phone = user.phone ?? "";
    mobileMoneyForm.email = user.email ?? "";
    walletForm.phone = user.phone ?? user.email ?? "";
  }

  showCheckoutModal.value = true;
}

async function handleCheckoutSubmit() {
  if (!selectedMethod.value) return;

  if (selectedMethod.value === 'carte_bancaire') {
    if (!cardForm.pciAccepted) {
      toast.error("Vous devez accepter les conditions PCI-DSS.");
      return;
    }
    if (!cardForm.fullName || !cardForm.email || !cardForm.cardNumber || !cardForm.cvv || !cardForm.expiryMonth || !cardForm.expiryYear) {
      toast.error("Veuillez remplir tous les champs de la carte.");
      return;
    }
  } else if (selectedMethod.value === 'paydunya_wallet') {
    if (!walletForm.phone || !walletForm.password) {
      toast.error("Veuillez remplir les identifiants du portefeuille PayDunya.");
      return;
    }
  } else {
    if (!mobileMoneyForm.phone) {
      toast.error("Le numéro de téléphone est requis.");
      return;
    }
    if ((selectedMethod.value === 'om_ci' || selectedMethod.value === 'om_bf') && !mobileMoneyForm.otp) {
      toast.error("Le code d'autorisation OTP est requis.");
      return;
    }
  }

  isSubmitting.value = true;
  try {
    const action = subscriptionQuery.data.value?.tier === "premium" ? "renewal" : "upgrade";
    const initResult = await checkoutProSubscription(auth.accessToken ?? "", {
      action,
      provider: "paydunya",
      channel: selectedMethod.value
    });

    chargeId.value = initResult.chargeId;

    const details: Record<string, any> = {};
    if (selectedMethod.value === 'carte_bancaire') {
      details.fullName = cardForm.fullName.trim();
      details.email = cardForm.email.trim();
      details.cardNumber = cardForm.cardNumber.replace(/\s/g, '');
      details.cardCvv = cardForm.cvv.trim();
      details.cardExpiredDateMonth = cardForm.expiryMonth.trim();
      details.cardExpiredDateYear = cardForm.expiryYear.trim();
    } else if (selectedMethod.value === 'paydunya_wallet') {
      details.phone = walletForm.phone.trim();
      details.password = walletForm.password.trim();
    } else {
      details.phone = mobileMoneyForm.phone.trim();
      details.customer_name = mobileMoneyForm.fullName.trim();
      details.customer_email = mobileMoneyForm.email.trim();
      if (selectedMethod.value === 'om_ci' || selectedMethod.value === 'om_bf') {
        details.otp = mobileMoneyForm.otp.trim();
      }
    }

    const execResult = await executeProSubscription(auth.accessToken ?? "", initResult.chargeId, {
      method: selectedMethod.value,
      details
    });

    if (execResult.success) {
      const url = execResult.url;

      if (url && (url.includes("data[qrcode]") || url.includes("data%5Bqrcode%5D"))) {
        const parsedUrl = new URL(url);
        const qr = parsedUrl.searchParams.get("data[qrcode]") || parsedUrl.searchParams.get("data%5Bqrcode%5D");
        if (qr) {
          qrCodeBase64.value = decodeURIComponent(qr);
          checkoutStep.value = "qr_code";
          isSubmitting.value = false;
          return;
        }
      }

      const detailsData = (execResult.data as any)?.details;
      const cid = (execResult.data as any)?.cid || detailsData?.cid;
      if (cid) {
        wizallCid.value = cid;
        checkoutStep.value = "wizall_otp";
        isSubmitting.value = false;
        return;
      }

      if (selectedMethod.value === 'carte_bancaire' && url) {
        threeDsUrl.value = url;
        checkoutStep.value = "three_ds";
        isSubmitting.value = false;
        return;
      }

      toast.success("Paiement effectué avec succès !");
      await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
      await queryClient.invalidateQueries({ queryKey: ["pro-invoices"] });
      showCheckoutModal.value = false;
    } else {
      toast.error(execResult.message || "Échec du paiement.");
    }
  } catch (error) {
    toast.error(getErrorMessage(error, "Erreur lors de l'exécution du paiement."));
  } finally {
    isSubmitting.value = false;
  }
}

async function handleWizallOtpSubmit() {
  if (!wizallOtpCode.value.trim()) {
    toast.error("Le code OTP est requis.");
    return;
  }
  isSubmitting.value = true;
  try {
    const execResult = await executeProSubscription(auth.accessToken ?? "", chargeId.value, {
      method: "wizall_senegal",
      details: {
        phone_number: mobileMoneyForm.phone.trim(),
        authorization_code: wizallOtpCode.value.trim(),
        transaction_id: wizallCid.value
      }
    });

    if (execResult.success) {
      toast.success("Paiement effectué avec succès !");
      await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
      await queryClient.invalidateQueries({ queryKey: ["pro-invoices"] });
      showCheckoutModal.value = false;
    } else {
      toast.error(execResult.message || "Échec du paiement Wizall.");
    }
  } catch (error) {
    toast.error(getErrorMessage(error, "Erreur lors de la validation Wizall."));
  } finally {
    isSubmitting.value = false;
  }
}

async function finalizeCheckoutReconciliation() {
  await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
  await queryClient.invalidateQueries({ queryKey: ["pro-invoices"] });
  showCheckoutModal.value = false;
  toast.success("Statut d'abonnement actualisé.");
}

function upgradePlan() {
  openCheckoutModal();
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
  paymentMethodForm.provider = billingMethod.value?.provider ?? "paydunya";
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
