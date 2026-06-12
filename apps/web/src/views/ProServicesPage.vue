<template>
  <div>
    <div class="mb-10 flex flex-col md:flex-row md:items-end justify-between gap-6">
      <div>
        <h1 class="page-title mb-2">Prestations</h1>
        <p class="text-cocoa/60 font-medium">Gérez votre menu de services, vos tarifs et vos acomptes.</p>
      </div>
      <button @click="addService" class="btn-primary gap-2 h-[52px] px-8 shadow-lg shadow-primary/20">
        <PlusIcon class="w-5 h-5" />
        Nouvelle prestation
      </button>
    </div>

    <!-- Categories / Tabs -->
    <div class="flex items-center gap-2 mb-8 overflow-x-auto no-scrollbar pb-2">
      <button 
        @click="selectedCategory = 'all'"
        :class="[
          'px-6 py-2.5 rounded-full text-xs font-bold uppercase tracking-widest transition-all whitespace-nowrap',
          selectedCategory === 'all' ? 'bg-espresso text-white shadow-md' : 'bg-white text-cocoa/60 hover:bg-sand'
        ]"
      >
        Tout voir
      </button>
      <button 
        v-for="cat in uniqueCategories" 
        :key="cat"
        @click="selectedCategory = cat"
        :class="[
          'px-6 py-2.5 rounded-full text-xs font-bold uppercase tracking-widest transition-all whitespace-nowrap',
          selectedCategory === cat ? 'bg-espresso text-white shadow-md' : 'bg-white text-cocoa/60 hover:bg-sand'
        ]"
      >
        {{ cat }}
      </button>
    </div>

    <!-- Service List -->
    <div class="space-y-12">
      <div v-for="cat in (selectedCategory === 'all' ? uniqueCategories : [selectedCategory])" :key="cat" class="space-y-4">
        <h2 class="section-label px-2">{{ cat }}</h2>
        <div class="grid grid-cols-1 gap-3">
          <div 
            v-for="service in servicesByCategory[cat]" 
            :key="service.id" 
            class="panel-clean p-5 flex items-center justify-between group hover:border-primary/30 transition-all hover:shadow-md hover:shadow-espresso/5"
          >
            <div class="flex items-center gap-6">
              <div class="w-12 h-12 rounded-2xl bg-neutral-bg flex items-center justify-center text-cocoa/40 group-hover:bg-primary/5 group-hover:text-primary transition-colors">
                <ScissorsIcon v-if="cat.toLowerCase().includes('coif') || cat.toLowerCase().includes('barber')" class="w-6 h-6" />
                <SparklesIcon v-else class="w-6 h-6" />
              </div>
              <div class="space-y-1">
                <p class="row-primary text-[15px]">{{ service.name }}</p>
                <div class="flex items-center gap-3 text-[12px] text-cocoa/40 font-medium">
                  <span class="flex items-center gap-1"><ClockIcon class="w-3.5 h-3.5" /> {{ service.duration }} min</span>
                  <span class="w-1 h-1 rounded-full bg-outline-variant"></span>
                  <span class="text-espresso font-bold">{{ service.priceLabel }}</span>
                </div>
              </div>
            </div>

            <div class="flex items-center gap-6">
              <div v-if="service.deposit > 0" class="text-right hidden sm:block">
                <p class="text-[10px] font-bold uppercase tracking-widest text-secondary mb-0.5">Acompte</p>
                <p class="text-[12px] font-bold text-espresso">{{ service.depositLabel }}</p>
              </div>
              
              <div class="flex items-center gap-2">
                <button @click="editService(service)" class="w-10 h-10 rounded-full bg-sand/50 flex items-center justify-center text-cocoa/60 hover:bg-primary hover:text-white transition-all shadow-sm">
                  <PencilIcon class="w-4 h-4" />
                </button>
                <button @click="deleteService(service.id)" class="w-10 h-10 rounded-full bg-sand/50 flex items-center justify-center text-cocoa/60 hover:bg-error hover:text-white transition-all shadow-sm">
                  <TrashIcon class="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="services.length === 0" class="panel-clean py-20 text-center border-dashed border-2">
        <div class="w-20 h-20 bg-neutral-bg rounded-full flex items-center justify-center mx-auto mb-6 text-cocoa/20">
          <Squares2X2Icon class="w-10 h-10" />
        </div>
        <p class="row-primary text-lg mb-2">Votre carte de services est vide</p>
        <p class="row-meta max-w-sm mx-auto mb-2">Créez vos prestations pour que vos talents puissent être associés à des spécialités.</p>
        <p class="row-meta max-w-xs mx-auto mb-8">Vos clients pourront alors réserver en ligne.</p>
        <button @click="addService" class="btn-primary">Créer ma première prestation</button>
      </div>
    </div>

    <!-- Add/Edit Modal -->
    <Teleport to="body">
      <div
        v-if="showCreateForm"
        class="fixed inset-0 z-[200] flex items-center justify-center p-4"
        @click.self="cancelCreateService"
      >
        <div class="absolute inset-0 bg-espresso/40 backdrop-blur-sm"></div>
        <div class="relative w-full max-w-lg bg-surface rounded-[32px] shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-300">

          <!-- Header -->
          <div class="px-8 pt-8 pb-6">
            <div class="flex items-start justify-between mb-6">
              <div>
                <h3 class="text-xl font-bold text-espresso">{{ editingServiceId ? "Modifier la prestation" : "Nouvelle prestation" }}</h3>
                <p class="text-[12px] text-cocoa/50 font-semibold uppercase tracking-widest mt-1">Étape {{ wizardStep }} sur {{ depositsAvailable ? 3 : 2 }}</p>
              </div>
              <button @click="cancelCreateService" class="p-2 hover:bg-neutral-bg rounded-full transition">
                <XMarkIcon class="w-5 h-5 text-cocoa/40" />
              </button>
            </div>

            <!-- Step indicator -->
            <div class="flex items-center gap-2">
              <div
                v-for="step in (depositsAvailable ? 3 : 2)"
                :key="step"
                class="flex items-center gap-2"
              >
                <div
                  :class="[
                    'flex items-center justify-center w-7 h-7 rounded-full text-[11px] font-bold transition-all duration-300',
                    wizardStep > step
                      ? 'bg-primary text-white'
                      : wizardStep === step
                        ? 'bg-espresso text-white ring-4 ring-espresso/10'
                        : 'bg-neutral-bg text-cocoa/40'
                  ]"
                >
                  <CheckIcon v-if="wizardStep > step" class="w-3.5 h-3.5" />
                  <span v-else>{{ step }}</span>
                </div>
                <span
                  :class="[
                    'text-[11px] font-bold uppercase tracking-wider hidden sm:inline transition-colors',
                    wizardStep === step ? 'text-espresso' : 'text-cocoa/30'
                  ]"
                >
                  {{ ['Identité', 'Tarification', 'Acompte'][step - 1] }}
                </span>
                <div v-if="step < (depositsAvailable ? 3 : 2)" class="flex-1 h-px bg-outline-variant/60 mx-2 w-8"></div>
              </div>
            </div>
          </div>

          <!-- Step content -->
          <div class="px-8 pb-8">

            <!-- Step 1: Identity -->
            <div v-if="wizardStep === 1" class="space-y-5 animate-in fade-in slide-in-from-right-4 duration-300">
              <div class="bg-neutral-bg/40 rounded-2xl p-6 space-y-5">
                <div>
                  <label class="section-label mb-2 block">Nom de la prestation</label>
                  <div class="relative">
                    <input
                      v-model="createForm.name"
                      class="input-shell text-base"
                      placeholder="Tapez le nom de la prestation…"
                      autofocus
                      @input="onServiceNameInput"
                      @focus="showServiceSuggestions = true"
                      @blur="onServiceNameBlur"
                    />
                    <div
                      v-if="showServiceSuggestions && filteredServices.length > 0"
                      class="absolute left-0 right-0 top-full mt-1 z-50 bg-white rounded-xl shadow-xl ring-1 ring-outline-variant max-h-60 overflow-y-auto"
                    >
                      <button
                        v-for="svc in filteredServices"
                        :key="svc.name"
                        type="button"
                        class="w-full text-left px-4 py-2.5 text-sm hover:bg-neutral-bg transition flex items-center justify-between"
                        @mousedown.prevent="selectServiceSuggestion(svc)"
                      >
                        <span class="font-medium text-espresso">{{ svc.name }}</span>
                        <span class="text-[10px] font-bold uppercase tracking-wider text-cocoa/40">{{ svc.category }}</span>
                      </button>
                    </div>
                  </div>
                </div>
                <div v-if="!autoCategory">
                  <label class="section-label mb-2 block">Catégorie</label>
                  <select v-model="createForm.category" class="input-shell">
                    <option value="" disabled>Sélectionner une catégorie</option>
                    <option v-for="cat in platformCategories" :key="cat.id" :value="cat.name">
                      {{ cat.name }}
                    </option>
                  </select>
                  <p class="text-[11px] text-cocoa/40 mt-2">La catégorie regroupe vos prestations dans votre catalogue.</p>
                </div>
              </div>

              <div class="flex gap-3 pt-2">
                <button type="button" @click="cancelCreateService" class="btn-secondary h-[52px] px-6 text-sm">Annuler</button>
                <button type="button" @click="nextStep" :disabled="!createForm.name.trim() || !createForm.category.trim()" class="btn-primary flex-1 h-[52px] text-sm shadow-lg shadow-primary/20">
                  Continuer →
                </button>
              </div>
            </div>

            <!-- Step 2: Pricing -->
            <div v-if="wizardStep === 2" class="space-y-5 animate-in fade-in slide-in-from-right-4 duration-300">
              <div class="bg-neutral-bg/40 rounded-2xl p-6 space-y-5">
                <div>
                  <label class="section-label mb-2 block">Durée de la prestation</label>
                  <div class="flex items-center gap-3">
                    <div class="relative flex-1">
                      <ClockIcon class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40" />
                      <input v-model.number="createForm.durationMinutes" type="number" min="5" step="5" class="input-shell pl-11" />
                    </div>
                    <span class="text-sm font-semibold text-cocoa/50">min</span>
                  </div>
                  <div class="flex gap-2 mt-3 flex-wrap">
                    <button
                      v-for="preset in [15, 30, 45, 60, 90, 120]"
                      :key="preset"
                      type="button"
                      @click="createForm.durationMinutes = preset"
                      :class="[
                        'px-3 py-1 rounded-full text-[11px] font-bold transition-all',
                        createForm.durationMinutes === preset
                          ? 'bg-espresso text-white'
                          : 'bg-white text-cocoa/50 border border-outline-variant hover:border-espresso hover:text-espresso'
                      ]"
                    >{{ preset }}min</button>
                  </div>
                </div>
                <div>
                  <label class="section-label mb-2 block">Prix de vente (XOF)</label>
                  <input v-model.number="createForm.priceXof" type="number" min="0" step="500" class="input-shell font-bold text-base" />
                  <p class="text-[11px] text-cocoa/40 mt-2">Prix affiché à vos clients lors de la réservation.</p>
                </div>
              </div>

              <div class="flex gap-3 pt-2">
                <button type="button" @click="wizardStep = 1" class="btn-secondary h-[52px] px-6 text-sm">← Retour</button>
                <button type="button" @click="nextStep" :disabled="!createForm.priceXof || !createForm.durationMinutes" class="btn-primary flex-1 h-[52px] text-sm shadow-lg shadow-primary/20">
                  Continuer →
                </button>
              </div>
            </div>

            <!-- Step 3: Deposit (only if available for this subscription) -->
            <div v-if="wizardStep === 3 && depositsAvailable" class="space-y-4 animate-in fade-in slide-in-from-right-4 duration-300">
              <!-- Service preview -->
              <div class="flex items-center gap-4 bg-neutral-bg/40 rounded-2xl px-5 py-4 border border-outline-variant/40">
                <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                  <SparklesIcon class="w-5 h-5 text-primary" />
                </div>
                <div class="min-w-0">
                  <p class="row-primary truncate">{{ createForm.name }}</p>
                  <p class="row-meta">{{ createForm.durationMinutes }} min · {{ formatMoneyXof(createForm.priceXof) }}</p>
                </div>
              </div>

              <!-- Deposit mode cards -->
              <p class="section-label px-1">Demander un acompte à la réservation ?</p>
              <div class="space-y-2">
                <button
                  v-for="option in depositOptions"
                  :key="option.value"
                  type="button"
                  @click="createForm.depositMode = option.value as any"
                  :class="[
                    'w-full flex items-start gap-4 p-4 rounded-2xl border-2 transition-all text-left',
                    createForm.depositMode === option.value
                      ? 'border-primary bg-primary/5'
                      : 'border-outline-variant/50 bg-white hover:border-primary/30'
                  ]"
                >
                  <div :class="['w-5 h-5 rounded-full border-2 mt-0.5 shrink-0 flex items-center justify-center transition-all', createForm.depositMode === option.value ? 'border-primary bg-primary' : 'border-outline-variant']">
                    <div v-if="createForm.depositMode === option.value" class="w-2 h-2 rounded-full bg-white"></div>
                  </div>
                  <div>
                    <p class="text-[13px] font-bold text-espresso">{{ option.label }}</p>
                    <p class="text-[11px] text-cocoa/50 mt-0.5">{{ option.description }}</p>
                  </div>
                </button>
              </div>

              <!-- Deposit amount config -->
              <div v-if="createForm.depositMode === 'fixed'" class="bg-primary/5 border border-primary/20 rounded-2xl p-5 animate-in slide-in-from-top-2 duration-200">
                <label class="section-label mb-3 block">Montant de l'acompte (XOF)</label>
                <input v-model.number="createForm.depositAmountXof" type="number" min="0" step="500" class="input-shell bg-white font-bold" />
                <div v-if="createForm.depositAmountXof > 0 && createForm.priceXof > 0" class="mt-3 flex items-center gap-2 text-[11px] text-primary font-semibold">
                  <InformationCircleIcon class="w-4 h-4 shrink-0" />
                  <span>Soit {{ Math.round((createForm.depositAmountXof / createForm.priceXof) * 100) }}% du prix de la prestation</span>
                </div>
              </div>

              <div v-if="createForm.depositMode === 'percent'" class="bg-primary/5 border border-primary/20 rounded-2xl p-5 animate-in slide-in-from-top-2 duration-200">
                <label class="section-label mb-3 block">Pourcentage de l'acompte</label>
                <div class="flex items-center gap-4 mb-3">
                  <input v-model.number="createForm.depositPercent" type="range" min="5" max="100" step="5" class="flex-1 accent-primary" />
                  <span class="text-2xl font-bold text-espresso tabular-nums w-14 text-right">{{ createForm.depositPercent }}%</span>
                </div>
                <div class="flex gap-2 flex-wrap">
                  <button
                    v-for="preset in [10, 20, 25, 30, 50]"
                    :key="preset"
                    type="button"
                    @click="createForm.depositPercent = preset"
                    :class="[
                      'px-3 py-1 rounded-full text-[11px] font-bold transition-all',
                      createForm.depositPercent === preset ? 'bg-primary text-white' : 'bg-white text-cocoa/50 border border-outline-variant hover:border-primary hover:text-primary'
                    ]"
                  >{{ preset }}%</button>
                </div>
                <p v-if="createForm.priceXof > 0" class="mt-3 text-[11px] text-primary font-semibold flex items-center gap-1">
                  <InformationCircleIcon class="w-4 h-4 shrink-0" />
                  <span>Soit {{ formatMoneyXof(Math.round(createForm.priceXof * createForm.depositPercent / 100)) }} pour cette prestation</span>
                </p>
              </div>

              <p class="text-[11px] text-cocoa/40 leading-relaxed px-1">
                L'acompte est prélevé automatiquement via Wave ou Orange Money lors de la réservation.
              </p>

              <div class="flex gap-3 pt-2">
                <button type="button" @click="wizardStep = 2" class="btn-secondary h-[52px] px-6 text-sm">← Retour</button>
                <button type="button" @click="submitService" :disabled="actionPending" class="btn-primary flex-1 h-[52px] text-sm shadow-lg shadow-primary/20">
                  {{ actionPendingLabel }}
                </button>
              </div>
            </div>
            <!-- else: no deposit step, show submit on step 2 -->
            <div v-if="wizardStep === 2 && !depositsAvailable" class="flex gap-3 pt-2">
              <button type="button" @click="wizardStep = 1" class="btn-secondary h-[52px] px-6 text-sm">← Retour</button>
              <button type="button" @click="submitService" :disabled="actionPending" class="btn-primary flex-1 h-[52px] text-sm shadow-lg shadow-primary/20">
                {{ actionPendingLabel }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { proServiceCreateInputSchema } from "@beauteavenue/contracts";
import { formatMoneyXof, validateForm, SERVICE_CATEGORY_MAP } from "@beauteavenue/shared-ts";
import { toast } from "vue-sonner";
import {
  PlusIcon,
  PencilIcon,
  TrashIcon,
  ClockIcon,
  XMarkIcon,
  ScissorsIcon,
  SparklesIcon,
  Squares2X2Icon,
  CheckIcon,
  InformationCircleIcon
} from "@heroicons/vue/24/outline";
import { createProService, deleteProService, fetchProServices, fetchProSubscriptionFeatures, updateProService } from "@/lib/pro-api";
import { fetchPublicCategories } from "@/lib/api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";

const auth = useProAuthStore();
const queryClient = useQueryClient();
const showCreateForm = ref(false);
const editingServiceId = ref<string | null>(null);
const selectedCategory = ref("all");
const wizardStep = ref(1);
const showServiceSuggestions = ref(false);
const autoCategory = ref("");

const depositOptions = [
  { value: "none", label: "Pas d'acompte", description: "Les clients réservent sans payer à l'avance." },
  { value: "fixed", label: "Montant fixe", description: "Un montant précis en XOF est dû à la réservation." },
  { value: "percent", label: "Pourcentage du prix", description: "Un pourcentage du prix total est prélevé à la réservation." }
];

const createForm = reactive({
  name: "",
  category: "",
  durationMinutes: 30,
  priceXof: 5000,
  depositMode: "none" as "none" | "fixed" | "percent",
  depositAmountXof: 0,
  depositPercent: 20
});

const servicesQuery = useQuery({
  queryKey: ["pro-services"],
  queryFn: () => fetchProServices(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const featuresQuery = useQuery({
  queryKey: ["pro-subscription-features"],
  queryFn: () => fetchProSubscriptionFeatures(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const categoriesQuery = useQuery({
  queryKey: ["platform-categories"],
  queryFn: () => fetchPublicCategories(),
  staleTime: 10 * 60 * 1000
});

const platformCategories = computed(() => categoriesQuery.data.value ?? []);

const serviceNameMap = SERVICE_CATEGORY_MAP as Record<string, string>;
const filteredServices = computed(() => {
  const q = createForm.name.toLowerCase().trim();
  if (!q) return [];
  return Object.entries(serviceNameMap)
    .filter(([name]) => name.toLowerCase().includes(q))
    .slice(0, 20)
    .map(([name, category]) => ({ name, category }));
});

function onServiceNameInput() {
  showServiceSuggestions.value = true;
  const matched = serviceNameMap[createForm.name.trim()];
  if (matched) {
    autoCategory.value = matched;
    createForm.category = matched;
  } else {
    autoCategory.value = "";
  }
}

function onServiceNameBlur() {
  // Delay to allow click on suggestion
  setTimeout(() => { showServiceSuggestions.value = false; }, 200);
}

function selectServiceSuggestion(svc: { name: string; category: string }) {
  createForm.name = svc.name;
  createForm.category = svc.category;
  autoCategory.value = svc.category;
  showServiceSuggestions.value = false;
}

const depositsAvailable = computed(() => {
  const f = featuresQuery.data.value as { deposits?: { available: boolean } } | undefined;
  return f?.deposits?.available ?? false;
});

const deleteMutation = useMutation({
  mutationFn: (serviceId: string) => deleteProService(auth.accessToken ?? "", serviceId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-services"] });
    toast.success("Prestation supprimée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Suppression impossible pour le moment."));
  }
});

const createMutation = useMutation({
  mutationFn: () =>
    createProService(auth.accessToken ?? "", {
      name: createForm.name.trim(),
      category: createForm.category.trim() || undefined,
      durationMinutes: Number(createForm.durationMinutes),
      priceXof: Number(createForm.priceXof),
      depositMode: createForm.depositMode,
      depositAmountXof: createForm.depositMode === "fixed" ? Number(createForm.depositAmountXof) : undefined,
      depositPercent: createForm.depositMode === "percent" ? Number(createForm.depositPercent) : undefined
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-services"] });
    toast.success("Prestation créée.");
    cancelCreateService();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Création impossible pour le moment."));
  }
});

const updateMutation = useMutation({
  mutationFn: () =>
    updateProService(auth.accessToken ?? "", editingServiceId.value ?? "", {
      name: createForm.name.trim(),
      category: createForm.category.trim() || undefined,
      durationMinutes: Number(createForm.durationMinutes),
      priceXof: Number(createForm.priceXof),
      depositMode: createForm.depositMode,
      depositAmountXof: createForm.depositMode === "fixed" ? Number(createForm.depositAmountXof) : undefined,
      depositPercent: createForm.depositMode === "percent" ? Number(createForm.depositPercent) : undefined
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-services"] });
    toast.success("Prestation mise à jour.");
    cancelCreateService();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Mise à jour impossible pour le moment."));
  }
});

const services = computed(() => {
  return (servicesQuery.data.value ?? []).map((service) => {
    const deposit = service.depositMode === "fixed"
      ? service.depositAmountXof ?? 0
      : service.depositMode === "percent"
        ? Math.round(service.priceXof * ((service.depositPercent ?? 0) / 100))
        : 0;
    return {
      id: service.id,
      name: service.name,
      category: service.category || "Général",
      depositMode: service.depositMode,
      depositAmountXof: service.depositAmountXof ?? 0,
      depositPercent: service.depositPercent ?? 0,
      duration: service.durationMinutes,
      price: service.priceXof,
      priceLabel: formatMoneyXof(service.priceXof),
      deposit,
      depositLabel: formatMoneyXof(deposit),
      active: service.isActive
    };
  });
});

const uniqueCategories = computed(() => {
  const cats = new Set(services.value.map(s => s.category));
  return Array.from(cats).sort();
});

const servicesByCategory = computed(() => {
  const map: Record<string, any[]> = {};
  services.value.forEach(s => {
    if (!map[s.category]) map[s.category] = [];
    map[s.category].push(s);
  });
  return map;
});

const actionPending = computed(() => createMutation.isPending.value || updateMutation.isPending.value);
const actionPendingLabel = computed(() => {
  if (editingServiceId.value) {
    return updateMutation.isPending.value ? "Enregistrer les modifications" : "Enregistrer";
  }
  return createMutation.isPending.value ? "Création..." : "Ajouter à ma carte";
});

function addService() {
  showCreateForm.value = true;
  editingServiceId.value = null;
  wizardStep.value = 1;
}

function cancelCreateService() {
  showCreateForm.value = false;
  editingServiceId.value = null;
  wizardStep.value = 1;
  createForm.name = "";
  createForm.category = "";
  createForm.durationMinutes = 30;
  createForm.priceXof = 5000;
  createForm.depositMode = "none";
  createForm.depositAmountXof = 0;
  createForm.depositPercent = 20;
}

function nextStep() {
  const maxStep = depositsAvailable.value ? 3 : 2;
  if (wizardStep.value < maxStep) {
    wizardStep.value++;
  } else if (!depositsAvailable.value) {
    // Last step reached and no deposit step: submit directly
    submitService();
  }
}

function submitService() {
  const result = validateForm(proServiceCreateInputSchema, {
    name: createForm.name,
    category: createForm.category || undefined,
    durationMinutes: createForm.durationMinutes,
    priceXof: createForm.priceXof,
    depositMode: createForm.depositMode,
    depositAmountXof: createForm.depositMode === "fixed" ? createForm.depositAmountXof : undefined,
    depositPercent: createForm.depositMode === "percent" ? createForm.depositPercent : undefined
  });
  if (!result.success) {
    const firstError = Object.values(result.errors)[0];
    toast.error(firstError ?? result.formError ?? "Vérifiez les champs.");
    return;
  }
  if (editingServiceId.value) {
    updateMutation.mutate();
    return;
  }
  createMutation.mutate();
}

function deleteService(id: string) {
  if (!confirm('Supprimer cette prestation ? Cette action est irréversible.')) return;
  deleteMutation.mutate(id);
}

function editService(service: any) {
  editingServiceId.value = service.id;
  wizardStep.value = 1;
  showCreateForm.value = true;
  createForm.name = service.name;
  createForm.category = service.category;
  createForm.durationMinutes = service.duration;
  createForm.priceXof = service.price;
  createForm.depositMode = service.depositMode;
  createForm.depositAmountXof = service.depositAmountXof;
  createForm.depositPercent = service.depositPercent || 20;
}
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>
