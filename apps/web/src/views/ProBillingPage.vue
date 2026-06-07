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

    <!-- Current Plan -->
    <div class="panel-clean mb-6 p-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <p class="section-label mb-1">Plan actuel</p>
        <p class="row-primary text-base">{{ currentPlanLabel }}</p>
        <p class="row-meta mt-1">{{ subscriptionDescription }}</p>
        <div v-if="subscriptionQuery.data.value?.pendingTier === 'standard'" class="mt-2 flex items-center gap-2">
          <span class="px-2 py-0.5 rounded-full bg-amber-100 text-amber-700 text-[11px] font-semibold">Rétrogradation au Standard programmée</span>
          <button @click="cancelDowngrade" :disabled="cancelDowngradeMutation.isPending.value" class="text-[11px] text-cocoa/50 underline hover:text-espresso">Annuler</button>
        </div>
        <div v-if="renewsInDays !== null" class="mt-2 flex items-center gap-1.5">
          <CalendarDaysIcon class="w-3.5 h-3.5 text-cocoa/40 shrink-0" />
          <span class="text-[12px] text-cocoa/50">
            <template v-if="renewsInDays > 0">Renouvellement dans {{ renewsInDays }} jour{{ renewsInDays === 1 ? '' : 's' }}</template>
            <template v-else>Renouvellement aujourd'hui</template>
          </span>
        </div>
      </div>
      <div class="flex flex-wrap gap-2 shrink-0">
        <!-- Inactive / expired / cancelled: let the salon pick their starting tier -->
        <template v-if="subscriptionQuery.data.value?.status !== 'active'">
          <button :disabled="isSubmitting" @click="openCheckoutModal('activate', 'standard')" class="btn-secondary text-sm">
            Activer Standard
          </button>
          <button :disabled="isSubmitting" @click="openCheckoutModal('activate', 'premium')" class="btn-gold text-sm">
            Activer Premium
          </button>
        </template>
        <!-- Active: show contextual actions -->
        <template v-else>
          <button v-if="subscriptionQuery.data.value?.tier !== 'premium'" :disabled="isSubmitting" @click="openCheckoutModal('upgrade')" class="btn-gold text-sm">Passer en Premium</button>
          <button :disabled="isSubmitting" @click="openCheckoutModal('renewal')" class="btn-secondary text-sm">Renouveler</button>
          <button v-if="subscriptionQuery.data.value?.tier === 'premium' && !subscriptionQuery.data.value?.pendingTier" :disabled="downgradeMutation.isPending.value" @click="scheduleDowngrade" class="btn-secondary text-sm">Rétrograder au Standard</button>
          <button v-if="!subscriptionQuery.data.value?.isComplimentary" :disabled="cancelSubscriptionMutation.isPending.value" @click="cancelSubscriptionMutation.mutate()" class="text-[12px] text-red-500 hover:text-red-700 underline">Résilier</button>
        </template>
      </div>
    </div>

    <!-- Plan comparison -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
      <div v-for="plan in planTiers" :key="plan.tier" :class="['panel-clean p-5 relative', plan.tier === currentTier ? 'ring-2 ring-primary' : '']">
        <div v-if="plan.tier === currentTier" class="absolute -top-2.5 left-5">
          <span class="px-2.5 py-0.5 rounded-full bg-primary text-white text-[10px] font-bold uppercase tracking-widest">Plan actuel</span>
        </div>
        <div class="flex items-start justify-between mb-4">
          <div>
            <p class="text-[14px] font-semibold text-espresso capitalize">{{ plan.tier === 'premium' ? 'Premium' : 'Standard' }}</p>
            <p class="metric-value text-xl mt-0.5">{{ plan.priceLabel }}</p>
            <p class="text-[11px] text-cocoa/40">/ mois</p>
          </div>
        </div>
        <ul class="space-y-2">
          <li v-for="feature in plan.features ?? []" :key="feature.label" class="flex items-center gap-2">
            <CheckCircleIcon v-if="feature.included" class="w-4 h-4 text-primary shrink-0" />
            <XCircleIcon v-else class="w-4 h-4 text-cocoa/20 shrink-0" />
            <span :class="['text-[13px]', feature.included ? 'text-espresso' : 'text-cocoa/30 line-through']">{{ feature.label }}</span>
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
              <option
                v-for="country in checkoutCountryOptions"
                :key="country.code"
                :value="country.code"
              >
                {{ country.flag }} {{ country.code.toUpperCase() }}
              </option>
            </select>
          </div>
          <div>
            <label class="section-label mb-2 block">Méthode</label>
            <select v-model="paymentMethodForm.method" class="input-shell">
              <option
                v-for="method in billingMethodOptions.filter((item) => isPaydunyaMethodAvailableForCountry(item.country, paymentMethodForm.country))"
                :key="method.code"
                :value="method.code"
              >
                {{ method.label }}
              </option>
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
        <div class="flex items-center gap-2" :class="billingMethod ? 'justify-between' : 'justify-end'">
          <button
            v-if="billingMethod"
            type="button"
            class="btn-secondary"
            :disabled="clearPaymentMethodMutation.isPending.value"
            @click="clearPaymentMethod"
          >
            Supprimer
          </button>
          <div class="flex items-center gap-2 ml-auto">
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
      :title="checkoutAction === 'activate' ? (checkoutTier === 'premium' ? 'Activer — Plan Premium' : 'Activer — Plan Standard') : checkoutAction === 'upgrade' ? 'Passer en Premium' : 'Renouveler mon abonnement'"
      subtitle="Choisissez votre moyen de paiement et finalisez."
      max-width="lg"
      @close="closeCheckoutModal"
    >
      <div class="space-y-4">
        <!-- Step 1: Select Country and Method -->
        <div v-if="checkoutStep === 'select_method'" class="space-y-4">
          <div>
            <label class="section-label mb-2 block">Cycle de facturation</label>
            <div class="grid grid-cols-2 gap-2">
              <button
                type="button"
                class="btn-secondary !py-2 !px-3 text-xs"
                :class="billingCycle === 'monthly' ? '!bg-primary !text-white !border-primary' : ''"
                @click="billingCycle = 'monthly'"
              >
                Mensuel
              </button>
              <button
                type="button"
                class="btn-secondary !py-2 !px-3 text-xs"
                :class="billingCycle === 'annual' ? '!bg-primary !text-white !border-primary' : ''"
                @click="billingCycle = 'annual'"
              >
                Annuel
              </button>
            </div>
          </div>
          <div>
            <label class="section-label mb-2 block">Pays de facturation</label>
            <select v-model="selectedCountry" class="input-shell">
              <option
                v-for="country in checkoutCountryOptions"
                :key="country.code"
                :value="country.code"
              >
                {{ country.flag }} {{ country.code.toUpperCase() }}
              </option>
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
                <div class="w-10 h-10 rounded-lg overflow-hidden shrink-0 flex items-center justify-center bg-neutral-bg">
                  <img v-if="method.icon" :src="method.icon" :alt="method.label" class="w-8 h-8 object-contain" />
                  <WalletIcon v-else class="w-5 h-5 text-cocoa/60" />
                </div>
                <p class="text-xs font-bold text-espresso">{{ method.label }}</p>
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
              <div class="flex items-center rounded-2xl border border-outline-variant bg-white px-3">
                <select
                  v-model="selectedMobileMoneyCountryCode"
                  :disabled="mobileMoneyCountryOptions.length === 1"
                  class="h-[52px] w-[122px] bg-transparent border-0 pr-2 text-sm focus:outline-none"
                  aria-label="Indicatif pays"
                >
                  <option v-for="option in mobileMoneyCountryOptions" :key="option.code" :value="option.code">
                    {{ option.flag }} {{ option.dialCode }}
                  </option>
                </select>
                <input
                  v-model="mobileMoneyForm.phone"
                  type="tel"
                  inputmode="numeric"
                  class="h-[52px] w-full border-0 bg-transparent pl-3 text-base focus:outline-none"
                  :placeholder="selectedMobileMoneyCountry.placeholder"
                  @input="formatMobileMoneyPhoneInput"
                />
              </div>
              <p class="mt-1 text-[11px] text-cocoa/50">
                Format attendu : {{ selectedMobileMoneyCountry.dialCode }} {{ selectedMobileMoneyCountry.placeholder }}
              </p>
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

        <!-- Step 3: Wizall SMS OTP validation -->
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

        <div v-if="checkoutStep === 'waiting'" class="space-y-4">
          <div class="rounded-3xl border border-outline-variant/40 bg-neutral-bg/40 px-5 py-6 text-center">
            <div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-primary/10">
              <svg v-if="!waitingTimedOut" class="h-6 w-6 text-primary animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              <ArrowTrendingUpIcon v-else class="h-6 w-6 text-primary" />
            </div>
            <h4 class="text-sm font-bold text-espresso">
              {{ waitingTimedOut ? "En attente de confirmation" : "Confirmation du paiement en cours" }}
            </h4>
            <p class="mt-2 text-xs leading-relaxed text-cocoa/60 max-w-sm mx-auto">
              <template v-if="waitingTimedOut">
                PayDunya finalise encore la confirmation. Vous pouvez fermer cette fenêtre et revenir plus tard, ou vérifier manuellement.
              </template>
              <template v-else>
                Finalisez le paiement dans l'application ou la page ouverte, puis revenez ici. L'abonnement sera activé dès réception de la confirmation PayDunya.
              </template>
            </p>
            <button
              v-if="waitingLaunchUrl"
              type="button"
              class="btn-secondary mt-4 text-xs"
              @click="reopenWaitingLink"
            >
              {{ `Ouvrir ${waitingLaunchLabel}` }}
            </button>
            <button
              v-if="waitingAlternateLaunchUrl"
              type="button"
              class="btn-secondary mt-2 text-xs"
              @click="openAlternateWaitingLink"
            >
              {{ `Ouvrir ${waitingAlternateLaunchLabel}` }}
            </button>
            <button
              v-if="waitingHostedLaunchUrl && waitingHostedLaunchUrl !== waitingLaunchUrl"
              type="button"
              class="btn-secondary mt-2 text-xs"
              @click="openHostedWaitingLink"
            >
              {{ `Ouvrir ${waitingHostedLaunchLabel}` }}
            </button>
          </div>
        </div>
      </div>

      <template #footer>
        <div class="flex items-center justify-end gap-2">
          <button type="button" class="btn-secondary text-xs" @click="closeCheckoutModal">
            {{ checkoutStep === 'waiting' && !waitingTimedOut ? 'Fermer' : 'Annuler' }}
          </button>
          
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
            v-if="checkoutStep === 'waiting'"
            type="button"
            class="btn-primary text-xs"
            :disabled="waitingManualCheck"
            @click="verifyWaitingCharge(true)"
          >
            {{ waitingManualCheck ? 'Vérification...' : 'Vérifier maintenant' }}
          </button>
        </div>
      </template>
    </Modal>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, reactive, ref, watch } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import dayjs from "dayjs";
import { formatMoneyXof, validateForm } from "@beauteavenue/shared-ts";
import { proBillingMethodSchema } from "@beauteavenue/contracts";
import { useRoute, useRouter } from "vue-router";
import {
  CheckCircleIcon,
  XCircleIcon,
  ArrowDownTrayIcon,
  ArrowTrendingUpIcon,
  WalletIcon,
  BanknotesIcon,
  CalendarDaysIcon,
  CreditCardIcon,
  ChatBubbleLeftEllipsisIcon,
  ArrowLeftIcon
} from "@heroicons/vue/24/outline";
import {
  checkoutProSubscription,
  executeProSubscription,
  downloadProInvoicePdf,
  fetchPaymentMethods,
  fetchProInvoices,
  fetchProSubscriptionChargeStatus,
  fetchProSubscription,
  fetchProSubscriptionFeatures,
  updateProSubscription,
  cancelProSubscription
} from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";
import {
  getPaydunyaLaunchLabel,
  isPaydunyaMethodAvailableForCountry,
  isSuccessfulSubscriptionCharge,
  requiresAsyncSubscriptionConfirmation,
  resolvePaydunyaLaunchTargets,
  shouldOpenPaydunyaLinkInSameTab
} from "@/lib/pro-billing";
import { toast } from "vue-sonner";
import Modal from "@/components/Modal.vue";
import type {
  ProSubscriptionCheckoutInput,
  ProSubscriptionUpdateInputBillingMethod
} from "@/lib/generated";
import { resolveApiBaseUrl } from "@/lib/api-base";

const auth = useProAuthStore();
const queryClient = useQueryClient();
const route = useRoute();
const router = useRouter();
const apiBaseUrl = resolveApiBaseUrl();
const showPaymentMethodModal = ref(false);
const paymentMethodForm = reactive({
  provider: "paydunya" as string,
  accountNumber: "",
  country: "sn",
  method: "wave_senegal"
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

const paymentMethodsQuery = useQuery({
  queryKey: ["paydunya-methods"],
  queryFn: () => fetchPaymentMethods(auth.accessToken ?? ""),
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
      billingMethod: billingMethod as unknown as ProSubscriptionUpdateInputBillingMethod
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

const downgradeMutation = useMutation({
  mutationFn: () => checkoutProSubscription(auth.accessToken ?? "", { action: "downgrade", provider: "paydunya" } as unknown as ProSubscriptionCheckoutInput),
  onSuccess: async (result) => {
    await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
    if ((result as any).downgradeScheduled) {
      toast.success("Rétrogradation programmée. Elle prendra effet à la fin de votre période de grâce.");
    }
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Impossible de programmer la rétrogradation."));
  }
});

const cancelDowngradeMutation = useMutation({
  mutationFn: async () => {
    const response = await fetch("/api/v1/pro/subscription/cancel-downgrade", {
      method: "POST",
      headers: { Authorization: `Bearer ${auth.accessToken ?? ""}` }
    });
    if (!response.ok) throw new Error("Annulation impossible.");
    return response.json();
  },
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
    toast.success("Rétrogradation annulée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Impossible d'annuler la rétrogradation."));
  }
});

const cancelSubscriptionMutation = useMutation({
  mutationFn: () => cancelProSubscription(auth.accessToken ?? ""),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
    toast.success("Abonnement résilié.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Impossible de résilier l'abonnement."));
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
  const autoRenewLabel = sub.autoRenew ? "renouvellement auto actif" : "renouvellement auto désactivé";
  if (!sub.renewsAt) {
    return `Prochaine échéance à définir • ${autoRenewLabel}`;
  }

  const renewDate = dayjs(sub.renewsAt).format("DD MMMM YYYY");
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

const CHECKOUT_WAITING_TIMEOUT_MS = 5 * 60 * 1000;
const CHECKOUT_WAITING_POLL_INTERVAL_MS = 6 * 1000;

const showCheckoutModal = ref(false);
const checkoutAction = ref<"activate" | "upgrade" | "renewal">("activate");
const checkoutTier = ref<"standard" | "premium">("standard");
const checkoutStep = ref<'select_method' | 'enter_details' | 'wizall_otp' | 'waiting'>('select_method');
const billingCycle = ref<'monthly' | 'annual'>('monthly');
const selectedCountry = ref('sn');
const selectedMethod = ref('');
const isSubmitting = ref(false);
const chargeId = ref('');
const wizallOtpCode = ref('');
const wizallCid = ref('');
const waitingChargeId = ref('');
const waitingLaunchUrl = ref<string | null>(null);
const waitingAlternateLaunchUrl = ref<string | null>(null);
const waitingHostedLaunchUrl = ref<string | null>(null);
const waitingLaunchLabel = ref("le moyen de paiement");
const waitingAlternateLaunchLabel = ref("l’autre application");
const waitingHostedLaunchLabel = ref("la page PayDunya");
const waitingTimedOut = ref(false);
const waitingManualCheck = ref(false);
let waitingPollTimer: number | null = null;
let waitingStartedAt = 0;

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

type PhoneCountry = {
  code: string;
  flag: string;
  dialCode: string;
  placeholder: string;
  nationalDigits: number;
  groupPattern: number[];
};

const PHONE_COUNTRY_MAP: Record<string, PhoneCountry> = {
  sn: { code: "sn", flag: "🇸🇳", dialCode: "+221", placeholder: "78 170 61 84", nationalDigits: 9, groupPattern: [2, 3, 2, 2] },
  ci: { code: "ci", flag: "🇨🇮", dialCode: "+225", placeholder: "01 23 45 67 89", nationalDigits: 10, groupPattern: [2, 2, 2, 2, 2] },
  bf: { code: "bf", flag: "🇧🇫", dialCode: "+226", placeholder: "70 12 34 56", nationalDigits: 8, groupPattern: [2, 2, 2, 2] },
  bj: { code: "bj", flag: "🇧🇯", dialCode: "+229", placeholder: "01 95 12 34 56", nationalDigits: 10, groupPattern: [2, 2, 2, 2, 2] },
  tg: { code: "tg", flag: "🇹🇬", dialCode: "+228", placeholder: "90 12 34 56", nationalDigits: 8, groupPattern: [2, 2, 2, 2] },
  ml: { code: "ml", flag: "🇲🇱", dialCode: "+223", placeholder: "70 12 34 56", nationalDigits: 8, groupPattern: [2, 2, 2, 2] },
  cm: { code: "cm", flag: "🇨🇲", dialCode: "+237", placeholder: "6 12 34 56 78", nationalDigits: 9, groupPattern: [1, 2, 2, 2, 2] }
};

const configuredPhoneCountries = ((import.meta.env.VITE_ALLOWED_PHONE_COUNTRIES as string | undefined) ?? "sn")
  .split(",")
  .map((item) => item.trim().toLowerCase())
  .filter((code) => code in PHONE_COUNTRY_MAP);

const fallbackPhoneCountries = (configuredPhoneCountries.length > 0 ? configuredPhoneCountries : ["sn"])
  .map((code) => PHONE_COUNTRY_MAP[code]);

const selectedMobileMoneyCountryCode = ref(fallbackPhoneCountries[0]?.code ?? "sn");
const selectedMobileMoneyCountry = computed(
  () => PHONE_COUNTRY_MAP[selectedMobileMoneyCountryCode.value] ?? PHONE_COUNTRY_MAP.sn
);

function normalizePhoneNumber(value: string, country: PhoneCountry) {
  const digits = value.replace(/\D/g, "");
  const countryDigits = country.dialCode.replace(/\D/g, "");
  const withoutCountryCode = digits.startsWith(countryDigits) ? digits.slice(countryDigits.length) : digits;
  return withoutCountryCode.slice(0, country.nationalDigits);
}

function applyPhoneMask(digits: string, country: PhoneCountry) {
  const normalized = digits.slice(0, country.nationalDigits);
  const groups: string[] = [];
  let index = 0;

  for (const size of country.groupPattern) {
    if (index >= normalized.length) break;
    groups.push(normalized.slice(index, index + size));
    index += size;
  }

  if (index < normalized.length) {
    groups.push(normalized.slice(index));
  }

  return groups.join(" ");
}

function formatMobileMoneyPhoneInput(event: Event) {
  const target = event.target as HTMLInputElement;
  const digits = normalizePhoneNumber(target.value, selectedMobileMoneyCountry.value);
  mobileMoneyForm.phone = applyPhoneMask(digits, selectedMobileMoneyCountry.value);
}

type SubscriptionMethodCode = "orange_senegal" | "wave_senegal";
type SubscriptionCheckoutMethod = {
  code: SubscriptionMethodCode;
  label: string;
  country: string;
  icon: string;
};

const subscriptionMethodMeta: Record<SubscriptionMethodCode, SubscriptionCheckoutMethod> = {
  orange_senegal: { code: "orange_senegal", label: "Orange Money", country: "sn", icon: "/om.png" },
  wave_senegal: { code: "wave_senegal", label: "Wave", country: "sn", icon: "/wave.png" }
};

const supportedSubscriptionMethodCodes = new Set<SubscriptionMethodCode>([
  "orange_senegal",
  "wave_senegal"
]);

const fallbackCheckoutMethods = Object.values(subscriptionMethodMeta);

const checkoutMethods = computed(() => {
  const backendMethods = ((paymentMethodsQuery.data.value as { methods?: Array<{ code: string; label: string; country: string; enabled?: boolean }> } | undefined)?.methods ?? [])
    .filter((method) => method.enabled !== false)
    .filter((method): method is { code: SubscriptionMethodCode; label: string; country: string; enabled?: boolean } =>
      method.code in subscriptionMethodMeta && supportedSubscriptionMethodCodes.has(method.code as SubscriptionMethodCode)
    )
    .map((method) => ({
      code: method.code,
      label: subscriptionMethodMeta[method.code].label,
      country: subscriptionMethodMeta[method.code].country,
      icon: subscriptionMethodMeta[method.code].icon
    }));
  return backendMethods.length > 0 ? backendMethods : fallbackCheckoutMethods;
});

const checkoutCountryOptions = computed(() => {
  const availableCountryCodes = new Set(
    checkoutMethods.value
      .map((method) => method.country)
      .filter((country) => country && country !== "intl")
  );
  const options = Object.values(PHONE_COUNTRY_MAP).filter((country) => availableCountryCodes.has(country.code));
  return options.length > 0 ? options : fallbackPhoneCountries;
});

const filteredMethods = computed(() => {
  return checkoutMethods.value.filter((m) =>
    isPaydunyaMethodAvailableForCountry(m.country, selectedCountry.value)
  );
});

const mobileMoneyCountryOptions = computed(() => {
  const currentMethod = checkoutMethods.value.find((method) => method.code === selectedMethod.value);
  if (!currentMethod || currentMethod.country === "intl") {
    return checkoutCountryOptions.value;
  }

  const matchedCountry = checkoutCountryOptions.value.find((country) => country.code === currentMethod.country);
  return matchedCountry ? [matchedCountry] : checkoutCountryOptions.value;
});

const selectedMethodLabel = computed(() => {
  const method = checkoutMethods.value.find((m) => m.code === selectedMethod.value);
  return method ? method.label : "";
});

function selectCheckoutMethod(code: string) {
  selectedMethod.value = code;
  const method = checkoutMethods.value.find((item) => item.code === code);
  if (method && method.country !== "intl") {
    selectedCountry.value = method.country;
  }
}

const billingMethodOptions = computed(() => checkoutMethods.value);

watch(mobileMoneyCountryOptions, (options) => {
  if (!options.some((option) => option.code === selectedMobileMoneyCountryCode.value)) {
    selectedMobileMoneyCountryCode.value = options[0]?.code ?? "sn";
  }
}, { immediate: true });

watch(selectedMobileMoneyCountryCode, () => {
  const digits = normalizePhoneNumber(mobileMoneyForm.phone, selectedMobileMoneyCountry.value);
  mobileMoneyForm.phone = applyPhoneMask(digits, selectedMobileMoneyCountry.value);
});

watch(() => paymentMethodForm.country, (country) => {
  const availableMethod = billingMethodOptions.value.find((item) =>
    isPaydunyaMethodAvailableForCountry(item.country, country)
  );
  if (availableMethod && !billingMethodOptions.value.some((item) =>
    item.code === paymentMethodForm.method &&
    isPaydunyaMethodAvailableForCountry(item.country, country)
  )) {
    paymentMethodForm.method = availableMethod.code;
  }
});

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

function clearWaitingPoll() {
  if (waitingPollTimer !== null) {
    window.clearTimeout(waitingPollTimer);
    waitingPollTimer = null;
  }
}

function closeCheckoutModal() {
  clearWaitingPoll();
  showCheckoutModal.value = false;
}

function requiresAsyncConfirmation(result: { status?: string; message?: string; url?: string; other_url?: unknown; data?: Record<string, unknown> | undefined; pendingProviderConfirmation?: boolean }) {
  return requiresAsyncSubscriptionConfirmation(result);
}

function openExternalPaymentLink(url: string | null) {
  if (!url) return;
  const device = {
    userAgent: window.navigator.userAgent,
    maxTouchPoints: window.navigator.maxTouchPoints
  };

  if (shouldOpenPaydunyaLinkInSameTab(url, device)) {
    window.location.assign(url);
    return;
  }

  if (url.startsWith("http://") || url.startsWith("https://")) {
    window.open(url, "_blank", "noopener,noreferrer");
    return;
  }
  window.location.assign(url);
}

async function finalizeSuccessfulCharge() {
  clearWaitingPoll();
  await queryClient.invalidateQueries({ queryKey: ["pro-subscription"] });
  await queryClient.invalidateQueries({ queryKey: ["pro-invoices"] });
  showCheckoutModal.value = false;
  toast.success("Paiement confirmé.");
}

function scheduleWaitingPoll() {
  clearWaitingPoll();
  waitingPollTimer = window.setTimeout(() => {
    void verifyWaitingCharge(false);
  }, CHECKOUT_WAITING_POLL_INTERVAL_MS);
}

async function verifyWaitingCharge(manual: boolean) {
  if (!auth.accessToken || !waitingChargeId.value) return;
  if (manual) waitingManualCheck.value = true;
  try {
    const result = await fetchProSubscriptionChargeStatus(auth.accessToken, waitingChargeId.value) as {
      status?: string;
    };
    if (isSuccessfulSubscriptionCharge(result)) {
      await finalizeSuccessfulCharge();
      return;
    }
    if (result.status === "failed" || result.status === "refunded") {
      clearWaitingPoll();
      waitingTimedOut.value = true;
      toast.error("Le paiement n'a pas été confirmé. Veuillez réessayer.");
      return;
    }
    if (Date.now() - waitingStartedAt >= CHECKOUT_WAITING_TIMEOUT_MS) {
      waitingTimedOut.value = true;
      clearWaitingPoll();
      return;
    }
    if (checkoutStep.value === "waiting") {
      scheduleWaitingPoll();
    }
  } catch (error) {
    if (manual) {
      toast.error(getErrorMessage(error, "La vérification du paiement a échoué."));
    } else if (checkoutStep.value === "waiting") {
      scheduleWaitingPoll();
    }
  } finally {
    if (manual) waitingManualCheck.value = false;
  }
}

function enterWaitingStepWithFallback(
  nextChargeId: string,
  launchTargets: { preferredUrl: string | null; hostedUrl: string | null; deeplinkUrls?: string[] }
) {
  waitingChargeId.value = nextChargeId;
  waitingLaunchUrl.value = launchTargets.preferredUrl;
  waitingLaunchLabel.value = getPaydunyaLaunchLabel(launchTargets.preferredUrl);
  waitingAlternateLaunchUrl.value = (launchTargets.deeplinkUrls ?? []).find((url) => url !== launchTargets.preferredUrl) ?? null;
  waitingAlternateLaunchLabel.value = getPaydunyaLaunchLabel(waitingAlternateLaunchUrl.value);
  waitingHostedLaunchUrl.value = launchTargets.hostedUrl;
  waitingHostedLaunchLabel.value = getPaydunyaLaunchLabel(launchTargets.hostedUrl);
  waitingTimedOut.value = false;
  waitingStartedAt = Date.now();
  checkoutStep.value = "waiting";
  openExternalPaymentLink(launchTargets.preferredUrl);
  // Delay the first poll so the user has time to interact with the payment link
  // before we check PayDunya status (prevents false-positive immediate confirms).
  scheduleWaitingPoll();
}

function reopenWaitingLink() {
  openExternalPaymentLink(waitingLaunchUrl.value);
}

function openAlternateWaitingLink() {
  openExternalPaymentLink(waitingAlternateLaunchUrl.value);
}

function openHostedWaitingLink() {
  openExternalPaymentLink(waitingHostedLaunchUrl.value);
}

function openCheckoutModal(action: "activate" | "upgrade" | "renewal" = "activate", tier: "standard" | "premium" = "standard") {
  clearWaitingPoll();
  checkoutAction.value = action;
  checkoutTier.value = action === "activate" ? tier : action === "upgrade" ? "premium" : (subscriptionQuery.data.value?.tier ?? "standard") as "standard" | "premium";
  checkoutStep.value = "select_method";
  billingCycle.value = "monthly";
  selectedCountry.value = billingMethod.value?.country ?? "sn";
  selectedMethod.value = billingMethod.value?.method ?? "";
  wizallOtpCode.value = "";
  wizallCid.value = "";
  waitingChargeId.value = "";
  waitingLaunchUrl.value = null;
  waitingAlternateLaunchUrl.value = null;
  waitingHostedLaunchUrl.value = null;
  waitingLaunchLabel.value = "le moyen de paiement";
  waitingAlternateLaunchLabel.value = "l’autre application";
  waitingHostedLaunchLabel.value = "la page PayDunya";
  waitingTimedOut.value = false;
  waitingManualCheck.value = false;
  isSubmitting.value = false;

  const user = auth.currentUser;
  if (user) {
    cardForm.fullName = user.fullName;
    cardForm.email = user.email ?? "";
    mobileMoneyForm.fullName = user.fullName;
    mobileMoneyForm.phone = applyPhoneMask(
      normalizePhoneNumber(user.phone ?? "", selectedMobileMoneyCountry.value),
      selectedMobileMoneyCountry.value
    );
    mobileMoneyForm.email = user.email ?? "";
    walletForm.phone = user.phone ?? user.email ?? "";
  }

  showCheckoutModal.value = true;
}

onMounted(() => {
  if (route.query.upgrade === "gallery_limit") {
    openCheckoutModal("upgrade");
    void router.replace({ path: route.path, query: {} });
  }
  window.addEventListener("focus", handleWindowFocus);
  document.addEventListener("visibilitychange", handleVisibilityChange);
});

watch(checkoutCountryOptions, (options) => {
  if (!options.some((option) => option.code === selectedCountry.value)) {
    selectedCountry.value = options[0]?.code ?? "sn";
  }
}, { immediate: true });

onUnmounted(() => {
  clearWaitingPoll();
  window.removeEventListener("focus", handleWindowFocus);
  document.removeEventListener("visibilitychange", handleVisibilityChange);
});

function handleWindowFocus() {
  if (checkoutStep.value === "waiting") {
    void verifyWaitingCharge(false);
  }
}

function handleVisibilityChange() {
  if (document.visibilityState === "visible" && checkoutStep.value === "waiting") {
    void verifyWaitingCharge(false);
  }
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
    const normalizedPhone = normalizePhoneNumber(mobileMoneyForm.phone, selectedMobileMoneyCountry.value);
    if (!normalizedPhone || normalizedPhone.length !== selectedMobileMoneyCountry.value.nationalDigits) {
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
    const initResult = await checkoutProSubscription(auth.accessToken ?? "", {
      action: checkoutAction.value,
      tier: checkoutTier.value,
      provider: "paydunya",
      billingCycle: billingCycle.value,
      channel: selectedMethod.value
    } as any);

    const nextChargeId = initResult.chargeId;
    if (!nextChargeId) {
      throw new Error("Référence de paiement PayDunya manquante.");
    }

    chargeId.value = nextChargeId;

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
      details.phone = normalizePhoneNumber(mobileMoneyForm.phone, selectedMobileMoneyCountry.value);
      details.customer_name = mobileMoneyForm.fullName.trim();
      details.customer_email = mobileMoneyForm.email.trim();
      if (selectedMethod.value === "djamo") {
        details.code_country = selectedCountry.value;
      }
      if (selectedMethod.value === 'om_ci' || selectedMethod.value === 'om_bf') {
        details.otp = mobileMoneyForm.otp.trim();
      }
    }

    const execResult = await executeProSubscription(auth.accessToken ?? "", nextChargeId, {
      method: selectedMethod.value,
      details
    });

    if (execResult.success) {
      const detailsData = (execResult.data as any)?.details;
      const cid = (execResult.data as any)?.cid || detailsData?.cid;
      if (cid) {
        wizallCid.value = cid;
        checkoutStep.value = "wizall_otp";
        isSubmitting.value = false;
        return;
      }

      if (requiresAsyncConfirmation(execResult)) {
        enterWaitingStepWithFallback(
          nextChargeId,
          resolvePaydunyaLaunchTargets(execResult, {
            userAgent: window.navigator.userAgent,
            maxTouchPoints: window.navigator.maxTouchPoints
          })
        );
        return;
      }

      await finalizeSuccessfulCharge();
    } else {
      const providerMessage = execResult.message || "Échec du paiement.";
      if (providerMessage.toLowerCase().includes("déjà été initié")) {
        toast.error("Ce paiement a déjà été lancé côté PayDunya. Finalisez-le dans l'application Wave, ou relancez un nouveau checkout si nécessaire.");
      } else {
        toast.error(providerMessage);
      }
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
        phone_number: normalizePhoneNumber(mobileMoneyForm.phone, selectedMobileMoneyCountry.value),
        authorization_code: wizallOtpCode.value.trim(),
        transaction_id: wizallCid.value
      }
    });

    if (execResult.success) {
      if (requiresAsyncConfirmation(execResult)) {
        enterWaitingStepWithFallback(
          chargeId.value,
          resolvePaydunyaLaunchTargets(execResult, {
            userAgent: window.navigator.userAgent,
            maxTouchPoints: window.navigator.maxTouchPoints
          })
        );
        return;
      }
      await finalizeSuccessfulCharge();
    } else {
      toast.error(execResult.message || "Échec du paiement Wizall.");
    }
  } catch (error) {
    toast.error(getErrorMessage(error, "Erreur lors de la validation Wizall."));
  } finally {
    isSubmitting.value = false;
  }
}

function scheduleDowngrade() {
  downgradeMutation.mutate();
}

function cancelDowngrade() {
  cancelDowngradeMutation.mutate();
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
  paymentMethodForm.country = billingMethod.value?.country ?? checkoutCountryOptions.value[0]?.code ?? "sn";
  paymentMethodForm.method = billingMethod.value?.method ?? billingMethodOptions.value.find((item) =>
    isPaydunyaMethodAvailableForCountry(item.country, paymentMethodForm.country)
  )?.code ?? "wave_senegal";
  showPaymentMethodModal.value = true;
}

function closePaymentMethodModal() {
  showPaymentMethodModal.value = false;
}

function savePaymentMethod() {
  const billingData = {
    provider: paymentMethodForm.provider as "paydunya" | "manual",
    accountNumber: paymentMethodForm.accountNumber.trim(),
    country: paymentMethodForm.provider === "paydunya" ? paymentMethodForm.country : undefined,
    method: paymentMethodForm.provider === "paydunya" ? paymentMethodForm.method : undefined,
  };
  const result = validateForm(proBillingMethodSchema, billingData);
  if (!result.success) {
    const firstError = Object.values(result.errors)[0];
    toast.error(firstError ?? "Vérifiez les champs.");
    return;
  }
  paymentMethodMutation.mutate(result.data as unknown as Record<string, unknown>);
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
