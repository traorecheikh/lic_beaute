<template>
  <div class="space-y-8">
    <header>
      <h2 class="page-title">Configuration</h2>
      <p class="row-meta mt-1">Paramètres de la plateforme</p>
    </header>

    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      <!-- Sidebar -->
      <nav class="lg:col-span-3 panel-clean p-2 space-y-0.5">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          class="w-full text-left px-4 py-3 rounded-xl text-[13px] font-semibold transition-all flex items-center gap-3"
          :class="
            activeTab === tab.id
              ? 'bg-primary/10 text-primary'
              : 'text-cocoa/80 hover:bg-neutral-bg hover:text-espresso'
          "
          @click="activeTab = tab.id"
        >
          <component :is="tab.icon" class="w-4 h-4 shrink-0" />
          {{ tab.label }}
        </button>
      </nav>

      <!-- Panels -->
      <div class="lg:col-span-9 space-y-0">

        <!-- ── Pièces Justificatives ───────────────────── -->
        <article v-if="activeTab === 'documents'" class="panel-clean p-8 space-y-6">
          <div class="flex items-start justify-between pb-4 border-b border-outline-variant/50">
            <div>
              <h3 class="text-base font-bold text-espresso">Pièces Justificatives</h3>
              <p class="row-meta mt-0.5">Documents demandés lors de l'inscription d'un partenaire salon.</p>
            </div>
            <button class="btn-secondary text-[11px] px-4 py-2 gap-1.5 inline-flex items-center" @click="showAddDocModal = true">
              <PlusIcon class="w-3.5 h-3.5" /> Ajouter
            </button>
          </div>

          <div v-if="documentsQuery.isLoading.value" class="py-8 text-center row-meta">Chargement…</div>
          <div v-else-if="documentsQuery.isError.value" class="py-8 text-center text-error text-sm">Erreur de chargement.</div>
          <div v-else class="space-y-3">
            <div
              v-for="doc in documentsQuery.data.value"
              :key="doc.id"
              class="flex items-center justify-between p-4 rounded-xl border border-outline-variant/50 bg-neutral-bg/40"
            >
              <div class="flex items-center gap-3 min-w-0">
                <DocumentTextIcon class="w-4 h-4 text-cocoa/40 shrink-0" />
                <div class="space-y-0.5 min-w-0">
                  <p class="row-primary truncate">{{ doc.label }}</p>
                  <p class="row-meta">
                    {{ doc.type.toUpperCase() }} ·
                    <span :class="doc.isRequired ? 'text-error font-semibold' : 'text-cocoa/60'">
                      {{ doc.isRequired ? 'Obligatoire' : 'Optionnel' }}
                    </span>
                    ·
                    <span :class="doc.enabled ? 'text-primary font-semibold' : 'text-cocoa/40'">
                      {{ doc.enabled ? 'Actif' : 'Désactivé' }}
                    </span>
                  </p>
                </div>
              </div>
              <button
                class="p-2 text-cocoa/30 hover:text-error transition-colors rounded-lg hover:bg-error/5 ml-3 shrink-0"
                :disabled="deleteDocMutation.isPending.value"
                @click="deleteDocMutation.mutate(doc.id)"
              >
                <TrashIcon class="w-4 h-4" />
              </button>
            </div>
            <p v-if="!documentsQuery.data.value?.length" class="py-6 text-center row-meta italic">
              Aucun document configuré.
            </p>
          </div>
        </article>

        <!-- ── PayDunya Sandbox Tester (dev only) ─────────── -->
        <article v-if="activeTab === 'paydunya_sandbox'" class="panel-clean p-8 space-y-6 max-w-2xl">
          <div class="pb-4 border-b border-outline-variant/50">
            <h3 class="text-base font-bold text-espresso">Test PayDunya Sandbox</h3>
            <p class="row-meta mt-0.5">Crée une facture et exécute un paiement de test via l'API sandbox PayDunya.</p>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="section-label">Montant (XOF)</label>
              <input v-model.number="sandboxForm.amountXof" type="number" min="100" class="input-shell" />
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Méthode</label>
              <select v-model="sandboxForm.method" class="input-shell">
                <option value="sandbox_direct">Compte test (direct)</option>
                <option value="wave_senegal">Wave Sénégal</option>
                <option value="orange_senegal">Orange Money Sénégal</option>
              </select>
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Téléphone</label>
              <input v-model="sandboxForm.phone" class="input-shell" placeholder="97403627" />
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Email</label>
              <input v-model="sandboxForm.email" class="input-shell" placeholder="marnel.gnacadja@paydunya.com" />
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Mot de passe compte test</label>
              <input v-model="sandboxForm.password" type="password" class="input-shell" placeholder="Miliey@2121" />
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Description</label>
              <input v-model="sandboxForm.description" class="input-shell" placeholder="Test réservation" />
            </div>
          </div>

          <button
            type="button"
            class="btn-primary px-6 py-2.5 inline-flex items-center gap-2 text-sm"
            :disabled="sandboxRunning"
            @click="runSandboxTest"
          >
            <span v-if="sandboxRunning" class="w-4 h-4 animate-spin border-2 border-white/30 border-t-white rounded-full"></span>
            {{ sandboxRunning ? 'Test en cours...' : 'Lancer le test' }}
          </button>

          <div v-if="sandboxResult" class="space-y-4 pt-2 border-t border-outline-variant/30">
            <div :class="['flex items-center gap-3 px-4 py-3 rounded-xl', sandboxResult.success ? 'bg-primary/5 border border-primary/20' : 'bg-error/5 border border-error/20']">
              <CheckCircleIcon v-if="sandboxResult.success" class="w-5 h-5 text-primary shrink-0" />
              <XCircleIcon v-else class="w-5 h-5 text-error shrink-0" />
              <div>
                <p class="text-[13px] font-bold" :class="sandboxResult.success ? 'text-primary' : 'text-error'">
                  {{ sandboxResult.success ? 'Paiement réussi' : 'Paiement échoué' }}
                </p>
                <p class="text-[11px] text-cocoa/60">{{ sandboxResult.payment?.message }}</p>
              </div>
            </div>
            <div>
              <p class="section-label mb-2">Réponse invoice</p>
              <pre class="bg-espresso text-sand/80 text-[11px] p-4 rounded-xl overflow-x-auto">{{ JSON.stringify(sandboxResult.invoice, null, 2) }}</pre>
            </div>
            <div>
              <p class="section-label mb-2">Réponse paiement</p>
              <pre class="bg-espresso text-sand/80 text-[11px] p-4 rounded-xl overflow-x-auto">{{ JSON.stringify(sandboxResult.payment, null, 2) }}</pre>
            </div>
            <a :href="sandboxResult.checkoutUrl" target="_blank" rel="noopener" class="btn-secondary text-[12px] inline-flex items-center gap-2">
              <ArrowTopRightOnSquareIcon class="w-4 h-4" />
              Voir la page de paiement
            </a>
          </div>
        </article>

        <!-- ── Catégories Salons ───────────────────────── -->
        <article v-if="activeTab === 'categories'" class="panel-clean p-8 space-y-6">
          <div class="flex items-start justify-between pb-4 border-b border-outline-variant/50">
            <div>
              <h3 class="text-base font-bold text-espresso">Catégories de Salons</h3>
              <p class="row-meta mt-0.5">Catégories disponibles lors de l'inscription d'un partenaire.</p>
            </div>
            <button class="btn-secondary text-[11px] px-4 py-2 gap-1.5 inline-flex items-center" @click="showAddCatModal = true">
              <PlusIcon class="w-3.5 h-3.5" /> Ajouter
            </button>
          </div>

          <div v-if="categoriesQuery.isLoading.value" class="py-8 text-center row-meta">Chargement…</div>
          <div v-else-if="categoriesQuery.isError.value" class="py-8 text-center text-error text-sm">Erreur de chargement.</div>
          <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div
              v-for="cat in categoriesQuery.data.value"
              :key="cat.id"
              class="flex items-center justify-between p-4 rounded-xl border border-outline-variant/50 bg-neutral-bg/40"
            >
              <div class="flex items-center gap-3 min-w-0">
                <TagIcon class="w-4 h-4 text-cocoa/40 shrink-0" />
                <div class="min-w-0">
                  <p class="row-primary truncate">{{ cat.name }}</p>
                  <p class="row-meta">{{ cat.slug }}</p>
                </div>
              </div>
              <button
                class="p-2 text-cocoa/30 hover:text-error transition-colors rounded-lg hover:bg-error/5 ml-3 shrink-0"
                :disabled="deleteCatMutation.isPending.value"
                @click="deleteCatMutation.mutate(cat.id)"
              >
                <TrashIcon class="w-4 h-4" />
              </button>
            </div>
            <p v-if="!categoriesQuery.data.value?.length" class="col-span-2 py-6 text-center row-meta italic">
              Aucune catégorie configurée.
            </p>
          </div>
        </article>

        <!-- ── Settings panels ────────────────────────── -->
        <article v-if="isSettingsTab" class="panel-clean p-8 space-y-6">
          <div class="pb-4 border-b border-outline-variant/50 flex items-start gap-3">
            <component :is="currentTab!.icon" class="w-5 h-5 text-cocoa/50 mt-0.5 shrink-0" />
            <div>
              <h3 class="text-base font-bold text-espresso">{{ currentTab!.label }}</h3>
              <p class="row-meta mt-0.5">{{ currentTab!.description }}</p>
            </div>
          </div>

          <!-- Notifications SMS note -->
          <div
            v-if="activeTab === 'notifications'"
            class="flex items-start gap-3 p-4 rounded-xl bg-primary/[0.04] border border-primary/10"
          >
            <InformationCircleIcon class="w-4 h-4 text-primary/60 shrink-0 mt-0.5" />
            <p class="text-[11px] text-cocoa/70 leading-relaxed">
              La granularité des SMS (templates, plages d'envoi, opt-out) se configure directement dans le tableau de bord de votre opérateur OTP. Seuls le pilote actif et le nom expéditeur sont gérés ici.
            </p>
          </div>

          <div v-if="settingsQuery.isLoading.value" class="py-8 text-center row-meta">Chargement…</div>
          <div v-else-if="settingsQuery.isError.value" class="py-8 text-center text-error text-sm">Erreur de chargement.</div>

          <!-- Subscription features: card layout with Switch/SegmentedControls -->
          <div v-else-if="activeTab === 'subscription_features'" class="grid grid-cols-1 sm:grid-cols-2 auto-rows-1fr gap-4 items-stretch">
            <!-- Acomptes -->
            <div class="rounded-2xl border border-outline-variant/40 p-5 flex flex-col gap-4">
              <div class="flex items-center gap-2.5">
                <div class="w-8 h-8 rounded-lg bg-primary/10 flex items-center justify-center text-primary shrink-0">
                  <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div>
                  <p class="text-[13px] font-bold text-espresso">Acomptes</p>
                  <p class="text-[11px] text-cocoa/50">Dépôts en ligne des clients</p>
                </div>
              </div>
              <div class="mt-auto space-y-3">
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Activé</span>
                  <div
                    role="switch"
                    :aria-checked="boolVal('feature_deposits_enabled')"
                    tabindex="0"
                    class="relative w-11 h-6 rounded-full cursor-pointer transition-colors shrink-0"
                    :class="boolVal('feature_deposits_enabled') ? 'bg-primary' : 'bg-outline-variant'"
                    @click="toggleBool('feature_deposits_enabled')"
                    @keydown.enter="toggleBool('feature_deposits_enabled')"
                    @keydown.space.prevent="toggleBool('feature_deposits_enabled')"
                  >
                    <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform" :class="boolVal('feature_deposits_enabled') ? 'translate-x-5' : 'translate-x-0'"></span>
                  </div>
                </div>
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Niveau requis</span>
                  <div class="inline-flex rounded-lg border border-outline-variant/50 p-0.5 gap-0.5">
                    <button
                      type="button"
                      class="px-3 py-1.5 text-[11px] font-bold rounded-md transition-all"
                      :class="tierVal('feature_deposits_tier_required') === 'premium' ? 'bg-espresso text-white shadow-sm' : 'text-cocoa/50 hover:text-espresso'"
                      @click="onInput('feature_deposits_tier_required', 'premium')"
                    >Premium</button>
                    <button
                      type="button"
                      class="px-3 py-1.5 text-[11px] font-bold rounded-md transition-all"
                      :class="tierVal('feature_deposits_tier_required') === 'standard' ? 'bg-espresso text-white shadow-sm' : 'text-cocoa/50 hover:text-espresso'"
                      @click="onInput('feature_deposits_tier_required', 'standard')"
                    >Standard</button>
                  </div>
                </div>
              </div>
            </div>
            <!-- Rapports -->
            <div class="rounded-2xl border border-outline-variant/40 p-5 flex flex-col gap-4">
              <div class="flex items-center gap-2.5">
                <div class="w-8 h-8 rounded-lg bg-secondary/10 flex items-center justify-center text-secondary shrink-0">
                  <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
                </div>
                <div>
                  <p class="text-[13px] font-bold text-espresso">Rapports</p>
                  <p class="text-[11px] text-cocoa/50">Statistiques avancées</p>
                </div>
              </div>
              <div class="mt-auto space-y-3">
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Activé</span>
                  <div
                    role="switch"
                    :aria-checked="boolVal('feature_analytics_enabled')"
                    tabindex="0"
                    class="relative w-11 h-6 rounded-full cursor-pointer transition-colors shrink-0"
                    :class="boolVal('feature_analytics_enabled') ? 'bg-primary' : 'bg-outline-variant'"
                    @click="toggleBool('feature_analytics_enabled')"
                    @keydown.enter="toggleBool('feature_analytics_enabled')"
                    @keydown.space.prevent="toggleBool('feature_analytics_enabled')"
                  >
                    <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform" :class="boolVal('feature_analytics_enabled') ? 'translate-x-5' : 'translate-x-0'"></span>
                  </div>
                </div>
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Niveau requis</span>
                  <div class="inline-flex rounded-lg border border-outline-variant/50 p-0.5 gap-0.5">
                    <button
                      type="button"
                      class="px-3 py-1.5 text-[11px] font-bold rounded-md transition-all"
                      :class="tierVal('feature_analytics_tier_required') === 'premium' ? 'bg-espresso text-white shadow-sm' : 'text-cocoa/50 hover:text-espresso'"
                      @click="onInput('feature_analytics_tier_required', 'premium')"
                    >Premium</button>
                    <button
                      type="button"
                      class="px-3 py-1.5 text-[11px] font-bold rounded-md transition-all"
                      :class="tierVal('feature_analytics_tier_required') === 'standard' ? 'bg-espresso text-white shadow-sm' : 'text-cocoa/50 hover:text-espresso'"
                      @click="onInput('feature_analytics_tier_required', 'standard')"
                    >Standard</button>
                  </div>
                </div>
              </div>
            </div>
            <!-- Abonnement -->
            <div class="rounded-2xl border border-outline-variant/40 p-5 flex flex-col gap-4">
              <div class="flex items-center gap-2.5">
                <div class="w-8 h-8 rounded-lg bg-neutral-bg flex items-center justify-center text-cocoa/50 shrink-0">
                  <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
                </div>
                <div>
                  <p class="text-[13px] font-bold text-espresso">Abonnement</p>
                  <p class="text-[11px] text-cocoa/50">Renouvellement automatique</p>
                </div>
              </div>
              <div class="mt-auto space-y-3">
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Activé</span>
                  <div
                    role="switch"
                    :aria-checked="boolVal('feature_auto_renew_enabled')"
                    tabindex="0"
                    class="relative w-11 h-6 rounded-full cursor-pointer transition-colors shrink-0"
                    :class="boolVal('feature_auto_renew_enabled') ? 'bg-primary' : 'bg-outline-variant'"
                    @click="toggleBool('feature_auto_renew_enabled')"
                    @keydown.enter="toggleBool('feature_auto_renew_enabled')"
                    @keydown.space.prevent="toggleBool('feature_auto_renew_enabled')"
                  >
                    <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform" :class="boolVal('feature_auto_renew_enabled') ? 'translate-x-5' : 'translate-x-0'"></span>
                  </div>
                </div>
              </div>
            </div>
            <!-- Modes de facturation -->
            <div class="rounded-2xl border border-outline-variant/40 p-5 flex flex-col gap-4">
              <div class="flex items-center gap-2.5">
                <div class="w-8 h-8 rounded-lg bg-primary/10 flex items-center justify-center text-primary shrink-0">
                  <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                </div>
                <div>
                  <p class="text-[13px] font-bold text-espresso">Modes de facturation</p>
                  <p class="text-[11px] text-cocoa/50">Fournisseurs affichés aux salons</p>
                </div>
              </div>
              <div class="mt-auto space-y-3">
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">PayDunya</span>
                  <div
                    role="switch"
                    :aria-checked="boolVal('feature_billing_paydunya')"
                    tabindex="0"
                    class="relative w-11 h-6 rounded-full cursor-pointer transition-colors shrink-0"
                    :class="boolVal('feature_billing_paydunya') ? 'bg-primary' : 'bg-outline-variant'"
                    @click="toggleBool('feature_billing_paydunya')"
                    @keydown.enter="toggleBool('feature_billing_paydunya')"
                    @keydown.space.prevent="toggleBool('feature_billing_paydunya')"
                  >
                    <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform" :class="boolVal('feature_billing_paydunya') ? 'translate-x-5' : 'translate-x-0'"></span>
                  </div>
                </div>
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Intech</span>
                  <div
                    role="switch"
                    :aria-checked="boolVal('feature_billing_intech')"
                    tabindex="0"
                    class="relative w-11 h-6 rounded-full cursor-pointer transition-colors shrink-0"
                    :class="boolVal('feature_billing_intech') ? 'bg-primary' : 'bg-outline-variant'"
                    @click="toggleBool('feature_billing_intech')"
                    @keydown.enter="toggleBool('feature_billing_intech')"
                    @keydown.space.prevent="toggleBool('feature_billing_intech')"
                  >
                    <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform" :class="boolVal('feature_billing_intech') ? 'translate-x-5' : 'translate-x-0'"></span>
                  </div>
                </div>
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Manuel</span>
                  <div
                    role="switch"
                    :aria-checked="boolVal('feature_billing_manual')"
                    tabindex="0"
                    class="relative w-11 h-6 rounded-full cursor-pointer transition-colors shrink-0"
                    :class="boolVal('feature_billing_manual') ? 'bg-primary' : 'bg-outline-variant'"
                    @click="toggleBool('feature_billing_manual')"
                    @keydown.enter="toggleBool('feature_billing_manual')"
                    @keydown.space.prevent="toggleBool('feature_billing_manual')"
                  >
                    <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform" :class="boolVal('feature_billing_manual') ? 'translate-x-5' : 'translate-x-0'"></span>
                  </div>
                </div>
                <div class="flex items-center justify-between min-h-[36px]">
                  <span class="text-[12px] font-semibold text-cocoa/70">Carte bancaire</span>
                  <div
                    role="switch"
                    :aria-checked="boolVal('feature_card_payments')"
                    tabindex="0"
                    class="relative w-11 h-6 rounded-full cursor-pointer transition-colors shrink-0"
                    :class="boolVal('feature_card_payments') ? 'bg-primary' : 'bg-outline-variant'"
                    @click="toggleBool('feature_card_payments')"
                    @keydown.enter="toggleBool('feature_card_payments')"
                    @keydown.space.prevent="toggleBool('feature_card_payments')"
                  >
                    <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform" :class="boolVal('feature_card_payments') ? 'translate-x-5' : 'translate-x-0'"></span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div v-else class="space-y-0">
            <div
              v-for="s in settingsByGroup(activeTab)"
              :key="s.key"
              class="grid grid-cols-1 sm:grid-cols-2 gap-x-8 gap-y-3 items-start py-5 border-b border-outline-variant/30 last:border-0"
            >
              <!-- Label + tooltip -->
              <div class="flex items-start gap-2">
                <div class="flex-1 min-w-0 space-y-0.5">
                  <div class="flex items-center gap-2">
                    <p class="row-primary">{{ metaFor(s.key).label }}</p>
                    <span
                      v-if="pendingChanges[s.key] !== undefined"
                      class="w-1.5 h-1.5 rounded-full bg-primary shrink-0"
                      title="Modification non enregistrée"
                    ></span>
                  </div>
                </div>
                <!-- Tooltip trigger -->
                <div class="relative group/tip shrink-0 mt-0.5">
                  <button
                    type="button"
                    class="w-5 h-5 rounded-full border border-cocoa/20 text-cocoa/40 text-[9px] font-bold flex items-center justify-center hover:border-primary/40 hover:text-primary hover:bg-primary/5 transition-colors"
                  >i</button>
                  <div class="absolute z-30 bottom-full mb-2 left-1/2 -translate-x-1/2 hidden group-hover/tip:flex flex-col gap-1.5 w-72 p-3.5 bg-espresso rounded-xl shadow-2xl pointer-events-none">
                    <div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-espresso"></div>
                    <p class="text-[11px] text-sand/90 leading-relaxed">{{ metaFor(s.key).description }}</p>
                    <p v-if="metaFor(s.key).example" class="text-[10px] text-sand/50 italic">Ex : {{ metaFor(s.key).example }}</p>
                  </div>
                </div>
              </div>

              <!-- Input area -->
              <div :ref="(el) => setFieldRef(s.key, el)" class="space-y-1">
                <!-- percentage: slider + number -->
                <div v-if="metaFor(s.key).type === 'percentage'" class="flex items-center gap-3">
                  <input
                    type="range"
                    :min="metaFor(s.key).min ?? 0"
                    :max="metaFor(s.key).max ?? 100"
                    step="0.5"
                    class="flex-1 accent-primary cursor-pointer h-2"
                    :value="currentValue(s)"
                    @input="onInput(s.key, ($event.target as HTMLInputElement).value)"
                  />
                  <div class="flex items-center gap-1.5 shrink-0">
                    <input
                      type="number"
                      :min="metaFor(s.key).min ?? 0"
                      :max="metaFor(s.key).max ?? 100"
                      step="0.5"
                      class="input-shell !py-2 !px-3 text-center text-[13px] w-20"
                      :class="{
                        'input-dirty': pendingChanges[s.key] !== undefined,
                        'input-error': validationErrors[s.key]
                      }"
                      :value="currentValue(s)"
                      @input="onInput(s.key, ($event.target as HTMLInputElement).value)"
                    />
                    <span class="text-[13px] font-bold text-cocoa/50">%</span>
                  </div>
                </div>

                <!-- number + unit -->
                <div v-else-if="metaFor(s.key).type === 'number'" class="flex items-center gap-2">
                  <input
                    type="number"
                    :min="metaFor(s.key).min"
                    :max="metaFor(s.key).max"
                    class="input-shell !py-2 !px-3 text-[13px]"
                    :class="{
                      'input-dirty': pendingChanges[s.key] !== undefined,
                      'input-error': validationErrors[s.key]
                    }"
                    :value="currentValue(s)"
                    @input="onInput(s.key, ($event.target as HTMLInputElement).value)"
                  />
                  <span v-if="metaFor(s.key).unit" class="text-[12px] font-bold text-cocoa/50 shrink-0">
                    {{ metaFor(s.key).unit }}
                  </span>
                </div>

                <!-- select -->
                <select
                  v-else-if="metaFor(s.key).type === 'select'"
                  class="input-shell !py-2 text-[13px]"
                  :class="{ 'input-dirty': pendingChanges[s.key] !== undefined }"
                  :value="currentValue(s)"
                  @change="onInput(s.key, ($event.target as HTMLSelectElement).value)"
                >
                  <option
                    v-for="opt in metaFor(s.key).options"
                    :key="opt.value"
                    :value="opt.value"
                  >{{ opt.label }}</option>
                </select>

                <!-- email / tel / text -->
                <div v-else-if="['email', 'tel', 'text'].includes(metaFor(s.key).type)" class="flex items-center gap-2">
                  <input
                    :type="metaFor(s.key).type"
                    :maxlength="metaFor(s.key).maxLength"
                    class="input-shell !py-2 text-[13px]"
                    :class="{
                      'input-dirty': pendingChanges[s.key] !== undefined,
                      'input-error': validationErrors[s.key]
                    }"
                    :value="currentValue(s)"
                    @input="onInput(s.key, ($event.target as HTMLInputElement).value)"
                  />
                  <span v-if="metaFor(s.key).maxLength" class="text-[10px] text-cocoa/40 shrink-0 tabular-nums whitespace-nowrap">
                    {{ String(currentValue(s)).length }}/{{ metaFor(s.key).maxLength }}
                  </span>
                </div>

                <!-- readonly -->
                <div
                  v-else-if="metaFor(s.key).type === 'readonly'"
                  class="py-2 px-3 rounded-xl bg-neutral-bg border border-outline-variant/40 flex items-center gap-2"
                >
                  <LockClosedIcon class="w-3 h-3 text-cocoa/30 shrink-0" />
                  <p class="text-[13px] text-cocoa/60 italic truncate">{{ s.value }}</p>
                </div>

                <!-- validation error -->
                <p v-if="validationErrors[s.key]" class="text-[10px] font-bold text-error uppercase tracking-wide">
                  {{ validationErrors[s.key] }}
                </p>
              </div>
            </div>

            <div v-if="!settingsByGroup(activeTab).length" class="py-6 text-center row-meta italic">
              Aucun paramètre dans ce groupe.
            </div>

            <!-- Save bar -->
            <div class="flex items-center justify-between pt-5">
              <p v-if="pendingCount > 0" class="text-[11px] font-semibold text-primary">
                {{ pendingCount }} modification{{ pendingCount > 1 ? 's' : '' }} non enregistrée{{ pendingCount > 1 ? 's' : '' }}
              </p>
              <p v-else class="text-[11px] text-cocoa/30">Aucune modification en attente</p>
              <button
                class="btn-primary px-6 py-2.5 text-[11px] inline-flex items-center gap-2"
                :disabled="savingSettings || pendingCount === 0"
                @click="saveSettings"
              >
                <span v-if="savingSettings" class="w-3.5 h-3.5 animate-spin border-2 border-white/30 border-t-white rounded-full"></span>
                <CheckIcon v-else class="w-3.5 h-3.5" />
                {{ savingSettings ? 'Enregistrement…' : 'Enregistrer' }}
              </button>
            </div>
          </div>
        </article>

      </div>
    </div>

    <!-- Add Document Modal -->
    <Teleport to="body">
      <div
        v-if="showAddDocModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-espresso/40 backdrop-blur-sm"
        @click.self="showAddDocModal = false"
      >
        <div class="panel-clean p-8 w-full max-w-md space-y-6 mx-4">
          <div class="flex items-center justify-between">
            <h3 class="text-base font-bold text-espresso">Nouveau document requis</h3>
            <button class="text-cocoa/30 hover:text-cocoa transition-colors" @click="showAddDocModal = false">
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <!-- Preset templates -->
          <div>
            <p class="section-label mb-2 block">Suggestions</p>
            <div class="flex flex-wrap gap-1.5">
              <button
                v-for="preset in DOCUMENT_PRESETS"
                :key="preset.label"
                type="button"
                class="px-2.5 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-wider transition-all"
                :class="newDoc.label === preset.label ? 'bg-primary text-white' : 'bg-neutral-bg text-cocoa/60 hover:bg-primary/10 hover:text-primary border border-outline-variant/40'"
                @click="newDoc.label = preset.label; newDoc.slug = preset.slug; newDoc.type = preset.type; newDoc.isRequired = preset.isRequired"
              >
                {{ preset.label }}
              </button>
            </div>
          </div>

          <div class="space-y-4">
            <div class="space-y-1.5">
              <label class="section-label">Libellé</label>
              <input v-model="newDoc.label" class="input-shell" placeholder="ex: Extrait Kbis" />
              <p v-if="docDuplicate" class="text-[10px] font-bold text-error uppercase tracking-wide mt-1">
                ⚠ Ce document existe déjà ({{ docDuplicate }})
              </p>
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Slug (identifiant unique)</label>
              <input v-model="newDoc.slug" class="input-shell" placeholder="ex: extrait-kbis" />
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Type de fichier accepté</label>
              <select v-model="newDoc.type" class="input-shell">
                <option value="any">Tout type</option>
                <option value="pdf">PDF uniquement</option>
                <option value="image">Image uniquement</option>
              </select>
            </div>
            <label class="flex items-center gap-3 cursor-pointer">
              <input type="checkbox" v-model="newDoc.isRequired" class="w-4 h-4 accent-primary" />
              <span class="text-[13px] font-semibold text-espresso">Document obligatoire</span>
            </label>
          </div>
          <div class="flex items-center justify-end gap-3 pt-2">
            <button class="btn-secondary px-5 py-2.5" @click="showAddDocModal = false">Annuler</button>
            <button class="btn-primary px-5 py-2.5" :disabled="addDocMutation.isPending.value" @click="submitNewDoc">
              Ajouter
            </button>
          </div>
        </div>
      </div>
    </Teleport>

    <!-- Add Category Modal -->
    <Teleport to="body">
      <div
        v-if="showAddCatModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-espresso/40 backdrop-blur-sm"
        @click.self="showAddCatModal = false"
      >
        <div class="panel-clean p-8 w-full max-w-md space-y-6 mx-4">
          <div class="flex items-center justify-between">
            <h3 class="text-base font-bold text-espresso">Nouvelle catégorie</h3>
            <button class="text-cocoa/30 hover:text-cocoa transition-colors" @click="showAddCatModal = false">
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <!-- Preset templates -->
          <div>
            <p class="section-label mb-2 block">Suggestions</p>
            <div class="flex flex-wrap gap-1.5">
              <button
                v-for="preset in CATEGORY_PRESETS"
                :key="preset.name"
                type="button"
                class="px-2.5 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-wider transition-all"
                :class="newCat.name === preset.name ? 'bg-primary text-white' : 'bg-neutral-bg text-cocoa/60 hover:bg-primary/10 hover:text-primary border border-outline-variant/40'"
                @click="newCat.name = preset.name; newCat.slug = preset.slug"
              >
                {{ preset.label }}
              </button>
            </div>
          </div>

          <div class="space-y-4">
            <div class="space-y-1.5">
              <label class="section-label">Nom de la catégorie</label>
              <input v-model="newCat.name" class="input-shell" placeholder="ex: Barbier" @input="autoSlugCat" />
            </div>
            <div class="space-y-1.5">
              <label class="section-label">Slug (identifiant unique)</label>
              <input v-model="newCat.slug" class="input-shell" placeholder="ex: barbier" />
              <p v-if="catDuplicate" class="text-[10px] font-bold text-error uppercase tracking-wide mt-1">
                ⚠ Cette catégorie existe déjà ({{ catDuplicate }})
              </p>
            </div>
          </div>
          <div class="flex items-center justify-end gap-3 pt-2">
            <button class="btn-secondary px-5 py-2.5" @click="showAddCatModal = false">Annuler</button>
            <button class="btn-primary px-5 py-2.5" :disabled="addCatMutation.isPending.value" @click="submitNewCat">
              Ajouter
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue';
import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query';
import { toast } from 'vue-sonner';
import {
  ArrowTopRightOnSquareIcon,
  BellIcon,
  CheckIcon,
  CheckCircleIcon,
  Cog6ToothIcon,
  CreditCardIcon,
  CurrencyDollarIcon,
  DocumentTextIcon,
  InformationCircleIcon,
  LockClosedIcon,
  PlusIcon,
  SparklesIcon,
  TagIcon,
  TrashIcon,
  XCircleIcon,
  XMarkIcon
} from '@heroicons/vue/24/outline';
import { useAdminAuthStore } from '@/stores/adminAuth';
import {
  deletePlatformRequiredDocument as deleteRequiredDocument,
  deletePlatformCategory as deleteSalonCategory,
  fetchPlatformSettings,
  fetchPlatformRequiredDocuments as fetchRequiredDocuments,
  fetchPlatformCategories as fetchSalonCategories,
  updatePlatformSetting,
  upsertPlatformCategory,
  upsertPlatformRequiredDocument
} from '@/lib/api';
import type { PlatformSetting } from '@beauteavenue/contracts';

// ── Types ──────────────────────────────────────────────────────────────────

type SettingType = 'text' | 'email' | 'tel' | 'number' | 'percentage' | 'select' | 'readonly';

type SettingMeta = {
  label: string;
  description: string;
  example?: string;
  type: SettingType;
  options?: { value: string; label: string }[];
  min?: number;
  max?: number;
  unit?: string;
  maxLength?: number;
};

// ── Settings metadata ──────────────────────────────────────────────────────
// Labels, input types, validation rules, and tooltips live here — not in the DB.

const SETTINGS_META: Record<string, SettingMeta> = {
  commission_rate_percent: {
    label: 'Commission plateforme',
    description: 'Pourcentage prélevé par Beauté Avenue sur chaque paiement de réservation.',
    example: '5 → 5% de chaque transaction client',
    type: 'percentage',
    min: 0,
    max: 30,
    unit: '%'
  },
  subscription_standard_price_xof: {
    label: 'Prix abonnement Standard',
    description: 'Montant mensuel facturé aux salons inscrits sur le plan Standard.',
    example: '15000 XOF / mois',
    type: 'number',
    min: 0,
    unit: 'XOF'
  },
  subscription_premium_price_xof: {
    label: 'Prix abonnement Premium',
    description: 'Montant mensuel facturé aux salons inscrits sur le plan Premium. Doit être supérieur au prix Standard.',
    example: '25000 XOF / mois',
    type: 'number',
    min: 0,
    unit: 'XOF'
  },
  deposit_minimum_xof: {
    label: 'Acompte minimum',
    description: "Montant minimal qu'un client peut verser comme acompte lors d'une réservation Premium.",
    example: '2000 XOF',
    type: 'number',
    min: 500,
    unit: 'XOF'
  },
  cancellation_window_hours: {
    label: "Fenêtre d'annulation gratuite",
    description: "Délai avant la prestation à partir duquel l'annulation est pénalisée. En dessous de ce seuil, l'acompte est retenu.",
    example: "24 → annulation gratuite jusqu'à 24h avant le RDV",
    type: 'number',
    min: 1,
    max: 72,
    unit: 'h'
  },
  // ── Feature flags (subscription_features group) ─────────────────────────
  feature_deposits_enabled: {
    label: 'Acomptes clients',
    description: 'Activer la fonctionnalité d\'acomptes pour les réservations en ligne.',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  },
  feature_deposits_tier_required: {
    label: 'Niveau requis',
    description: 'Quel abonnement est nécessaire pour proposer des acomptes clients ?',
    type: 'select',
    options: [
      { value: 'premium', label: 'Premium uniquement' },
      { value: 'standard', label: 'Standard et Premium' }
    ]
  },
  feature_analytics_enabled: {
    label: 'Rapports financiers',
    description: 'Activer les statistiques avancées et rapports financiers pour les salons.',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  },
  feature_analytics_tier_required: {
    label: 'Niveau requis',
    description: 'Quel abonnement est nécessaire pour accéder aux rapports financiers ?',
    type: 'select',
    options: [
      { value: 'premium', label: 'Premium uniquement' },
      { value: 'standard', label: 'Standard et Premium' }
    ]
  },
  feature_auto_renew_enabled: {
    label: 'Renouvellement automatique',
    description: 'Activer la possibilité de renouvellement automatique des abonnements.',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  },
  feature_billing_paydunya: {
    label: 'PayDunya',
    description: 'Afficher PayDunya comme option de mode de paiement pour la facturation.',
    type: 'select',
    options: [
      { value: 'true', label: 'Afficher' },
      { value: 'false', label: 'Masquer' }
    ]
  },
  feature_billing_intech: {
    label: 'Intech',
    description: 'Afficher Intech comme option de mode de paiement pour la facturation.',
    type: 'select',
    options: [
      { value: 'true', label: 'Afficher' },
      { value: 'false', label: 'Masquer' }
    ]
  },
  feature_billing_manual: {
    label: 'Manuel',
    description: 'Afficher le mode manuel (hors ligne) comme option de mode de paiement.',
    type: 'select',
    options: [
      { value: 'true', label: 'Afficher' },
      { value: 'false', label: 'Masquer' }
    ]
  },
  feature_card_payments: {
    label: 'Carte bancaire',
    description: 'Activer l\'option carte bancaire dans PayDunya (nécessaire pour le renouvellement automatique).',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  },
  support_email: {
    label: 'Email du support',
    description: "Adresse email affichée aux utilisateurs pour contacter l'équipe Beauté Avenue.",
    type: 'email'
  },
  support_phone: {
    label: 'Téléphone du support',
    description: "Numéro de téléphone affiché dans l'application mobile et sur la page de contact.",
    example: '+221338001234',
    type: 'tel'
  },
  booking_advance_days_max: {
    label: 'Horizon de réservation',
    description: "Nombre maximum de jours dans le futur qu'un client peut réserver un créneau.",
    example: "30 → réservations jusqu'à 1 mois à l'avance",
    type: 'number',
    min: 7,
    max: 180,
    unit: 'jours'
  },
  salon_approval_sla_days: {
    label: 'Délai SLA approbation',
    description: "Engagement de traitement d'une demande d'inscription salon, affiché au partenaire comme délai indicatif.",
    example: '3 → engagement 3 jours ouvrés',
    type: 'number',
    min: 1,
    max: 14,
    unit: 'jours'
  },
  paydunya_enabled_wave_senegal: {
    label: 'Wave Sénégal',
    description: 'Paiements via Wave (Orange Money Mobile).',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  },
  paydunya_enabled_orange_senegal: {
    label: 'Orange Money Sénégal',
    description: 'Paiements via Orange Money Sénégal.',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  },
  paydunya_enabled_free_senegal: {
    label: 'Free Money Sénégal',
    description: 'Paiements via Free Money Sénégal.',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  },
  paydunya_enabled_wizall_senegal: {
    label: 'Wizall Sénégal',
    description: 'Paiements via Wizall Sénégal.',
    type: 'select',
    options: [
      { value: 'true', label: 'Activé' },
      { value: 'false', label: 'Désactivé' }
    ]
  }
};

function metaFor(key: string): SettingMeta {
  return SETTINGS_META[key] ?? { label: key, description: '', type: 'text' };
}

// ── Auth + Query client ────────────────────────────────────────────────────

const auth = useAdminAuthStore();
const queryClient = useQueryClient();
const token = computed(() => auth.accessToken ?? '');

// ── Tabs ───────────────────────────────────────────────────────────────────

const tabs = [
  { id: 'documents',        label: 'Pièces Justificatives',  description: "Documents demandés lors de l'inscription d'un partenaire.",     icon: DocumentTextIcon },
  { id: 'categories',       label: 'Catégories Salons',       description: "Catégories disponibles lors de l'inscription d'un partenaire.", icon: TagIcon },
  { id: 'pricing',          label: 'Tarification & Frais',    description: 'Règles financières appliquées aux réservations et abonnements.', icon: CurrencyDollarIcon },
  { id: 'payment_methods',  label: 'Moyens de Paiement',      description: 'Activer/désactiver les méthodes de paiement PayDunya.',         icon: CreditCardIcon },
  { id: 'subscription_features', label: 'Fonctionnalités',    description: 'Activer/désactiver les fonctionnalités par niveau d\'abonnement.', icon: SparklesIcon },
  { id: 'general',          label: 'Paramètres Généraux',     description: 'Coordonnées du support et règles opérationnelles globales.',     icon: Cog6ToothIcon },
  ...(import.meta.env.DEV ? [{ id: 'paydunya_sandbox', label: 'Test PayDunya', description: 'Tester l\'API PayDunya en sandbox.', icon: CreditCardIcon }] : []),
];

const activeTab = ref('documents');
const currentTab = computed(() => tabs.find(t => t.id === activeTab.value));
const isSettingsTab = computed(() => ['pricing', 'payment_methods', 'subscription_features', 'general'].includes(activeTab.value));

// ── Queries ────────────────────────────────────────────────────────────────

const documentsQuery = useQuery({
  queryKey: ['config-documents'],
  queryFn: () => fetchRequiredDocuments(token.value),
  enabled: computed(() => !!token.value)
});

const categoriesQuery = useQuery({
  queryKey: ['config-categories'],
  queryFn: () => fetchSalonCategories(token.value),
  enabled: computed(() => !!token.value)
});

const settingsQuery = useQuery({
  queryKey: ['config-settings'],
  queryFn: () => fetchPlatformSettings(token.value),
  enabled: computed(() => !!token.value)
});

function settingsByGroup(group: string): PlatformSetting[] {
  return settingsQuery.data.value?.filter(s => s.group === group) ?? [];
}

// ── Settings state ─────────────────────────────────────────────────────────

const pendingChanges = reactive<Record<string, string>>({});
const validationErrors = reactive<Record<string, string>>({});
const savingSettings = ref(false);
const fieldRefs = new Map<string, Element | null>();

// ── PayDunya sandbox state (dev only) ──────────────────────────────────────

const sandboxForm = reactive({
  amountXof: 5000,
  method: 'sandbox_direct',
  phone: '97403627',
  email: 'marnel.gnacadja@paydunya.com',
  password: 'Miliey@2121',
  description: 'Test réservation'
});
const sandboxRunning = ref(false);
const sandboxResult = ref<any>(null);

async function runSandboxTest() {
  sandboxRunning.value = true;
  sandboxResult.value = null;
  try {
    const response = await fetch('/api/v1/admin/paydunya/sandbox-test', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${auth.accessToken}`
      },
      body: JSON.stringify({
        amountXof: sandboxForm.amountXof,
        method: sandboxForm.method,
        customerPhone: sandboxForm.phone,
        customerEmail: sandboxForm.email,
        customerPassword: sandboxForm.password,
        description: sandboxForm.description
      })
    });
    sandboxResult.value = await response.json();
  } catch (e) {
    sandboxResult.value = { success: false, payment: { message: String(e) } };
  } finally {
    sandboxRunning.value = false;
  }
}

// ── Pending changes state ──────────────────────────────────────────────────

const pendingCount = computed(() => Object.keys(pendingChanges).length);

function setFieldRef(key: string, el: unknown) {
  fieldRefs.set(key, el as Element | null);
}

function currentValue(s: PlatformSetting): string | number {
  const v = pendingChanges[s.key] !== undefined ? pendingChanges[s.key] : s.value;
  const meta = metaFor(s.key);
  if (meta.type === 'number' || meta.type === 'percentage') return parseFloat(v) || 0;
  return v;
}

function onInput(key: string, value: string) {
  const original = settingsQuery.data.value?.find(s => s.key === key)?.value;
  if (value === original) {
    delete pendingChanges[key];
  } else {
    pendingChanges[key] = value;
  }
  delete validationErrors[key];
}

// Helpers for the subscription_features card layout (Switch + SegmentedControl)
function boolVal(key: string): boolean {
  const v = settingsQuery.data.value?.find(s => s.key === key)?.value;
  const p = pendingChanges[key];
  return (p ?? v) === 'true';
}

function tierVal(key: string): string {
  const v = settingsQuery.data.value?.find(s => s.key === key)?.value;
  const p = pendingChanges[key];
  return p ?? v ?? 'premium';
}

function toggleBool(key: string) {
  const current = boolVal(key);
  onInput(key, current ? 'false' : 'true');
}

function validateSetting(key: string, value: string): string | null {
  const meta = metaFor(key);
  if (meta.type === 'number' || meta.type === 'percentage') {
    const n = parseFloat(value);
    if (isNaN(n)) return 'Valeur numérique requise.';
    if (meta.min !== undefined && n < meta.min) return `Minimum : ${meta.min}${meta.unit ? ' ' + meta.unit : ''}.`;
    if (meta.max !== undefined && n > meta.max) return `Maximum : ${meta.max}${meta.unit ? ' ' + meta.unit : ''}.`;
  }
  if (meta.type === 'email') {
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) return 'Adresse email invalide.';
  }
  if (meta.type === 'text') {
    if (meta.maxLength && value.length > meta.maxLength) return `Maximum ${meta.maxLength} caractères.`;
  }
  return null;
}

function shakeField(key: string) {
  const el = fieldRefs.get(key) as HTMLElement | null;
  if (!el) return;
  el.classList.add('animate-field-shake');
  setTimeout(() => el.classList.remove('animate-field-shake'), 300);
}

async function saveSettings() {
  const keys = Object.keys(pendingChanges);
  if (!keys.length) return;

  let hasErrors = false;
  for (const key of keys) {
    const err = validateSetting(key, pendingChanges[key]);
    if (err) {
      validationErrors[key] = err;
      shakeField(key);
      hasErrors = true;
    }
  }
  if (hasErrors) {
    toast.error('Corrigez les erreurs avant d\'enregistrer.');
    return;
  }

  savingSettings.value = true;
  try {
    await Promise.all(keys.map(key => updatePlatformSetting(token.value, key, pendingChanges[key])));
    keys.forEach(k => delete pendingChanges[k]);
    await queryClient.invalidateQueries({ queryKey: ['config-settings'] });
    toast.success(`${keys.length} paramètre${keys.length > 1 ? 's' : ''} enregistré${keys.length > 1 ? 's' : ''}.`);
  } catch {
    toast.error('Erreur lors de l\'enregistrement.');
  } finally {
    savingSettings.value = false;
  }
}

// ── Mutations ──────────────────────────────────────────────────────────────

const deleteDocMutation = useMutation({
  mutationFn: (id: string) => deleteRequiredDocument(token.value, id),
  onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['config-documents'] }); toast.success('Document supprimé.'); },
  onError: () => toast.error('Erreur lors de la suppression.')
});

const deleteCatMutation = useMutation({
  mutationFn: (id: string) => deleteSalonCategory(token.value, id),
  onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['config-categories'] }); toast.success('Catégorie supprimée.'); },
  onError: () => toast.error('Erreur lors de la suppression.')
});

const addDocMutation = useMutation({
  mutationFn: (data: { label: string; slug: string; type: string; isRequired: boolean }) =>
    upsertPlatformRequiredDocument(token.value, {
      label: data.label,
      slug: data.slug,
      type: data.type as 'image' | 'pdf' | 'any',
      isRequired: data.isRequired
    }),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['config-documents'] });
    showAddDocModal.value = false;
    newDoc.label = '';
    newDoc.slug = '';
    newDoc.type = 'any';
    newDoc.isRequired = true;
    toast.success('Document ajouté.');
  },
  onError: () => toast.error("Erreur lors de l'ajout.")
});

const addCatMutation = useMutation({
  mutationFn: (data: { name: string; slug: string }) =>
    upsertPlatformCategory(token.value, { name: data.name, slug: data.slug }),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['config-categories'] });
    showAddCatModal.value = false;
    newCat.name = '';
    newCat.slug = '';
    toast.success('Catégorie ajoutée.');
  },
  onError: () => toast.error("Erreur lors de l'ajout.")
});

// ── Presets ─────────────────────────────────────────────────────────────────

const CATEGORY_PRESETS = [
  { label: 'Coiffure', name: 'Coiffure', slug: 'coiffure' },
  { label: 'Barbier', name: 'Barbier', slug: 'barbier' },
  { label: 'Ongles', name: 'Ongles', slug: 'ongles' },
  { label: 'Spa & Bien-être', name: 'Spa & Bien-être', slug: 'spa-bien-etre' },
  { label: 'Esthétique', name: 'Esthétique', slug: 'esthetique' },
  { label: 'Maquillage', name: 'Maquillage', slug: 'maquillage' },
  { label: 'Soins visage', name: 'Soins visage', slug: 'soins-visage' },
  { label: 'Épilation', name: 'Épilation', slug: 'epilation' },
  { label: 'Massage', name: 'Massage', slug: 'massage' },
  { label: 'Institut', name: 'Institut de beauté', slug: 'institut' },
];

const DOCUMENT_PRESETS = [
  { label: 'Carte d\'identité', slug: 'carte-identite', type: 'image', isRequired: true },
  { label: 'Extrait Kbis', slug: 'extrait-kbis', type: 'pdf', isRequired: true },
  { label: 'Registre de commerce', slug: 'registre-commerce', type: 'pdf', isRequired: true },
  { label: 'Licence d\'exploitation', slug: 'licence-exploitation', type: 'pdf', isRequired: true },
  { label: 'Photo de façade', slug: 'photo-facade', type: 'image', isRequired: false },
  { label: 'Attestation CNSS', slug: 'attestation-cnss', type: 'pdf', isRequired: true },
  { label: 'Assurance responsabilité', slug: 'assurance-responsabilite', type: 'pdf', isRequired: false },
  { label: 'Diplôme / Certificat', slug: 'diplome', type: 'image', isRequired: false },
  { label: 'RIB bancaire', slug: 'rib-bancaire', type: 'pdf', isRequired: false },
];

const catDuplicate = computed(() => {
  if (!newCat.name.trim()) return null;
  const match = (categoriesQuery.data.value ?? []).find(
    (c) => c.name.trim().toLowerCase() === newCat.name.trim().toLowerCase() || c.slug === newCat.slug.trim()
  );
  return match ? match.name : null;
});

const docDuplicate = computed(() => {
  if (!newDoc.label.trim()) return null;
  const match = (documentsQuery.data.value ?? []).find(
    (d) => d.label.trim().toLowerCase() === newDoc.label.trim().toLowerCase() || d.slug === newDoc.slug.trim()
  );
  return match ? match.label : null;
});

function autoSlugCat() {
  if (!newCat.slug || newCat.slug === CATEGORY_PRESETS.find(p => p.label === newCat.name)?.slug || !newCat.slug.trim()) {
    newCat.slug = newCat.name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  }
}

// ── Modal state ────────────────────────────────────────────────────────────

const showAddDocModal = ref(false);
const newDoc = reactive({ label: '', slug: '', type: 'any', isRequired: true });

const showAddCatModal = ref(false);
const newCat = reactive({ name: '', slug: '' });

function submitNewDoc() {
  if (!newDoc.label || !newDoc.slug) { toast.error('Libellé et slug sont requis.'); return; }
  if (docDuplicate.value) { toast.error(`Le document "${docDuplicate.value}" existe déjà.`); return; }
  addDocMutation.mutate({ ...newDoc });
}

function submitNewCat() {
  if (!newCat.name || !newCat.slug) { toast.error('Nom et slug sont requis.'); return; }
  if (catDuplicate.value) { toast.error(`La catégorie "${catDuplicate.value}" existe déjà.`); return; }
  addCatMutation.mutate({ ...newCat });
}
</script>
