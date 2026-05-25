<template>
  <div class="min-h-screen bg-neutral-bg py-12 px-4 sm:px-6 lg:px-8 font-sans antialiased">
    <div class="mx-auto max-w-3xl">
      <!-- Header -->
      <div class="text-center mb-16">
        <RouterLink to="/pro" class="inline-block mb-10">
          <img src="/logo.png" alt="Beauté Avenue" class="h-14 w-auto mx-auto" />
        </RouterLink>
        <p class="text-[11px] font-bold uppercase tracking-[0.4em] text-cocoa/40 mb-4">Étape {{ currentStep }} sur 5</p>
        <h1 class="text-[42px] font-medium-bold text-espresso leading-tight tracking-tight">
          {{ stepTitles[currentStep - 1] }}
        </h1>
        <p class="text-[17px] text-cocoa/60 mt-4 max-w-lg mx-auto leading-relaxed">
          {{ stepSubtitles[currentStep - 1] }}
        </p>
      </div>

      <!-- Stepper -->
      <div class="flex items-center justify-center gap-3 mb-16">
        <div 
          v-for="step in 5" 
          :key="step"
          :class="[
            'h-1.5 rounded-full transition-all duration-500',
            currentStep === step ? 'w-12 bg-primary' : currentStep > step ? 'w-4 bg-primary/40' : 'w-4 bg-outline-variant'
          ]"
        ></div>
      </div>

      <form @submit.prevent="submitRegistration">
      <!-- Form Content -->
      <div class="panel-clean p-10 mb-12 shadow-xl shadow-espresso/5 border-none">
        
        <!-- Step 1: Identity & Salon -->
        <div v-if="currentStep === 1" class="space-y-8">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="md:col-span-2">
              <label for="salon-name" class="section-label mb-3 block">Nom du salon</label>
              <input id="salon-name" type="text" v-model="form.salonName" name="organization" autocomplete="organization" :class="['input-shell text-lg py-4', fieldErrors.salonName ? 'border-red-400' : '']" placeholder="Beauté Divine" />
              <p v-if="fieldErrors.salonName" class="text-xs text-red-600 mt-1">{{ fieldErrors.salonName }}</p>
            </div>
            <div>
              <label for="salon-city" class="section-label mb-3 block">Ville</label>
              <select id="salon-city" v-model="form.city" name="address-level2" autocomplete="address-level2" :class="['input-shell text-lg py-4 h-[60px]', fieldErrors.city ? 'border-red-400' : '']">
                <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
              </select>
              <p v-if="fieldErrors.city" class="text-xs text-red-600 mt-1">{{ fieldErrors.city }}</p>
            </div>
            <div>
              <label for="owner-email" class="section-label mb-3 block">Email professionnel</label>
              <input id="owner-email" type="email" v-model="form.email" name="email" autocomplete="email" :class="['input-shell text-lg py-4', fieldErrors.email ? 'border-red-400' : '']" placeholder="contact@monsalon.com" />
              <p v-if="fieldErrors.email" class="text-xs text-red-600 mt-1">{{ fieldErrors.email }}</p>
            </div>
            <div>
              <label for="owner-name" class="section-label mb-3 block">Nom complet du gérant</label>
              <input id="owner-name" type="text" v-model="form.fullName" name="name" autocomplete="name" :class="['input-shell text-lg py-4', fieldErrors.fullName ? 'border-red-400' : '']" placeholder="Marie Diop" />
              <p v-if="fieldErrors.fullName" class="text-xs text-red-600 mt-1">{{ fieldErrors.fullName }}</p>
            </div>
            <div>
              <label for="owner-phone" class="section-label mb-3 block">Téléphone (+221)</label>
              <input id="owner-phone" type="tel" v-model="form.phone" name="tel" autocomplete="tel" :class="['input-shell text-lg py-4', fieldErrors.phone ? 'border-red-400' : '']" placeholder="77 123 45 67" />
              <p v-if="fieldErrors.phone" class="text-xs text-red-600 mt-1">{{ fieldErrors.phone }}</p>
            </div>
            <div>
              <label for="salon-address" class="section-label mb-3 block">Adresse précise</label>
              <input id="salon-address" type="text" v-model="form.address" name="street-address" autocomplete="street-address" :class="['input-shell text-lg py-4', fieldErrors.address ? 'border-red-400' : '']" placeholder="Rue des Poilus, Zone A..." />
              <p v-if="fieldErrors.address" class="text-xs text-red-600 mt-1">{{ fieldErrors.address }}</p>
            </div>
            <div>
              <label for="salon-neighborhood" class="section-label mb-3 block">Quartier <span class="text-cocoa/40 font-normal normal-case">(optionnel)</span></label>
              <input id="salon-neighborhood" type="text" v-model="form.neighborhood" name="address-level3" autocomplete="address-level3" class="input-shell text-lg py-4" placeholder="Plateau, Mermoz, Almadies…" />
            </div>
            <div class="md:col-span-2">
              <label for="salon-description" class="section-label mb-3 block">Description du salon <span class="text-cocoa/40 font-normal normal-case">(optionnel)</span></label>
              <textarea id="salon-description" v-model="form.description" rows="3" class="input-shell text-lg py-4 resize-none" placeholder="Décrivez votre salon, vos spécialités, l'ambiance…"></textarea>
            </div>
            <div class="md:col-span-2">
              <label for="owner-password" class="section-label mb-3 block">Mot de passe</label>
              <div class="relative">
                <input
                  id="owner-password"
                  :type="showPassword ? 'text' : 'password'"
                  v-model="form.password"
                  name="new-password"
                  autocomplete="new-password"
                  :class="['input-shell text-lg py-4 pr-12', fieldErrors.password ? 'border-red-400' : '']"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  class="absolute right-3 top-1/2 -translate-y-1/2 text-cocoa/50 hover:text-cocoa"
                  :aria-label="showPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe'"
                  @click="showPassword = !showPassword"
                >
                  <EyeSlashIcon v-if="showPassword" class="w-5 h-5" />
                  <EyeIcon v-else class="w-5 h-5" />
                </button>
              </div>
              <p v-if="fieldErrors.password" class="text-xs text-red-600 mt-1">{{ fieldErrors.password }}</p>
            </div>
          </div>
        </div>

        <!-- Step 2: Categories -->
        <div v-if="currentStep === 2">
          <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
            <button 
              v-for="cat in categoryOptions" 
              :key="cat.name"
              @click="form.category = cat.name"
              :class="[
                'p-6 rounded-2xl border-2 transition-all flex flex-col items-center gap-4 text-center group',
                form.category === cat.name 
                  ? 'border-primary bg-primary/5 shadow-md shadow-primary/5' 
                  : 'border-outline-variant bg-white hover:border-primary/30'
              ]"
            >
              <div :class="[
                'w-14 h-14 rounded-2xl flex items-center justify-center transition-all',
                form.category === cat.name ? 'bg-primary text-white scale-110' : 'bg-neutral-bg text-cocoa/40 group-hover:bg-primary/10 group-hover:text-primary'
              ]">
                <component :is="cat.icon" class="w-7 h-7" />
              </div>
              <span :class="[
                'text-[15px] font-medium-bold tracking-tight',
                form.category === cat.name ? 'text-espresso' : 'text-cocoa/60'
              ]">{{ cat.name }}</span>
            </button>
          </div>
        </div>

        <!-- Step 3: Team Size -->
        <div v-if="currentStep === 3">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <button 
              v-for="size in teamSizeOptions" 
              :key="size.label"
              @click="form.teamSize = size.label"
              :class="[
                'p-8 rounded-2xl border-2 transition-all flex flex-col items-center gap-5 text-center group',
                form.teamSize === size.label 
                  ? 'border-primary bg-primary/5 shadow-md shadow-primary/5' 
                  : 'border-outline-variant bg-white hover:border-primary/30'
              ]"
            >
              <div class="flex items-center gap-1">
                <div 
                  v-for="i in size.dots" 
                  :key="i"
                  :class="[
                    'w-3 h-3 rounded-full',
                    form.teamSize === size.label ? 'bg-primary' : 'bg-outline-variant group-hover:bg-primary/30'
                  ]"
                ></div>
              </div>
              <div>
                <span :class="[
                  'text-lg font-medium-bold tracking-tight block',
                  form.teamSize === size.label ? 'text-espresso' : 'text-cocoa/60'
                ]">{{ size.label }}</span>
                <span class="text-xs text-cocoa/40 font-bold uppercase tracking-widest mt-1 block">{{ size.desc }}</span>
              </div>
            </button>
          </div>
        </div>

        <!-- Step 4: Subscription Intent -->
        <div v-if="currentStep === 4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <button 
              @click="form.subscriptionIntentTier = 'standard'"
              :class="[
                'p-8 rounded-3xl border-2 text-left transition-all relative overflow-hidden',
                form.subscriptionIntentTier === 'standard' 
                  ? 'border-primary bg-primary/5' 
                  : 'border-outline-variant bg-white hover:border-primary/20'
              ]"
            >
              <div v-if="form.subscriptionIntentTier === 'standard'" class="absolute top-4 right-4 text-primary">
                <CheckCircleIcon class="w-6 h-6" />
              </div>
              <h3 class="text-sm font-bold uppercase tracking-widest text-cocoa/60 mb-2">Plan Standard</h3>
              <p class="text-2xl font-medium-bold text-espresso mb-6">
                {{ formatPriceXof(pricing.standardPriceXof) }} F <span class="text-sm text-cocoa/40">/mois</span>
              </p>
              <ul class="space-y-3">
                <li class="flex items-center gap-3 text-sm text-cocoa/80">
                  <CheckIcon class="w-4 h-4 text-primary" />
                  Agenda & Réservations
                </li>
                <li class="flex items-center gap-3 text-sm text-cocoa/80">
                  <CheckIcon class="w-4 h-4 text-primary" />
                  Base clients
                </li>
              </ul>
            </button>

            <button 
              @click="form.subscriptionIntentTier = 'premium'"
              :class="[
                'p-8 rounded-3xl border-2 text-left transition-all relative overflow-hidden',
                form.subscriptionIntentTier === 'premium' 
                  ? 'border-secondary bg-secondary/5' 
                  : 'border-outline-variant bg-white hover:border-secondary/20'
              ]"
            >
              <div v-if="form.subscriptionIntentTier === 'premium'" class="absolute top-4 right-4 text-secondary">
                <CheckCircleIcon class="w-6 h-6" />
              </div>
              <div class="absolute -right-8 -top-8 w-24 h-24 bg-secondary/10 rounded-full blur-2xl"></div>
              <h3 class="text-sm font-bold uppercase tracking-widest text-secondary mb-2">Plan Premium</h3>
              <p class="text-2xl font-medium-bold text-espresso mb-6">
                {{ formatPriceXof(pricing.premiumPriceXof) }} F <span class="text-sm text-cocoa/40">/mois</span>
              </p>
              <ul class="space-y-3">
                <li class="flex items-center gap-3 text-sm text-espresso font-semibold">
                  <StarIcon class="w-4 h-4 text-secondary" />
                  Acomptes automatisés
                </li>
                <li class="flex items-center gap-3 text-sm text-espresso font-semibold">
                  <StarIcon class="w-4 h-4 text-secondary" />
                  Marketing & SMS
                </li>
                <li class="flex items-center gap-3 text-sm text-espresso font-semibold">
                  <StarIcon class="w-4 h-4 text-secondary" />
                  Visibilité prioritaire
                </li>
              </ul>
            </button>
          </div>
        </div>

        <!-- Step 5: Documents -->
        <div v-if="currentStep === 5" class="space-y-8">
          <div class="bg-primary/5 rounded-2xl p-6 border border-primary/10 mb-8">
            <p class="text-sm text-espresso leading-relaxed">
              Pour des raisons de sécurité et de conformité, nous devons vérifier l'existence légale de votre établissement.
            </p>
          </div>

          <div class="space-y-6">
            <div v-for="(doc, index) in requiredDocs" :key="doc.label" class="panel-clean p-6 border-dashed border-2 flex flex-col md:flex-row items-center gap-6">
              <div class="flex-1 text-center md:text-left">
                <h3 class="text-[15px] font-medium-bold text-espresso mb-1">{{ doc.label }}</h3>
                <p class="text-xs text-cocoa/60">{{ doc.desc }}</p>
              </div>
              
              <div class="shrink-0 w-full md:w-auto">
                <div v-if="doc.fileUrl" class="flex items-center gap-3 bg-primary/10 px-4 py-2 rounded-xl text-primary font-bold text-xs">
                  <DocumentCheckIcon class="w-4 h-4" />
                  Document ajouté
                  <button @click="removeDoc(index)" class="ml-2 text-cocoa/40 hover:text-error transition">
                    <XMarkIcon class="w-4 h-4" />
                  </button>
                </div>
                <label v-else class="btn-secondary w-full md:w-auto px-6 py-2.5 text-[11px] cursor-pointer">
                  <span>Téléverser</span>
                  <input type="file" @change="handleFileUpload($event, index)" class="sr-only" accept="image/*,.pdf" />
                </label>
              </div>
            </div>
          </div>
        </div>

      </div>

      <!-- Navigation -->
      <div class="flex items-center justify-center gap-4">
        <button
          type="button"
          v-if="currentStep > 1" 
          @click="currentStep--" 
          class="btn-secondary px-10 py-4 h-[60px] ring-0 border-none hover:bg-white transition-all font-medium-bold"
        >
          Retour
        </button>
        
        <button
          type="button"
          v-if="currentStep < 5" 
          @click="nextStep" 
          class="btn-primary flex-1 max-w-xs py-4 h-[60px] text-lg font-medium-bold shadow-xl shadow-primary/20"
        >
          Continuer
        </button>
        <button
          v-else
          type="submit"
          :disabled="loading"
          class="btn-primary flex-1 max-w-xs py-4 h-[60px] text-lg font-medium-bold shadow-xl shadow-primary/20 disabled:opacity-50 flex items-center justify-center gap-2"
        >
          <svg v-if="loading" class="animate-spin w-5 h-5 shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-30" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
            <path class="opacity-80" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
          </svg>
          <span>{{ loading ? 'Finalisation en cours…' : 'Ouvrir mon salon' }}</span>
        </button>
      </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { useRouter } from "vue-router";
import { toast } from "vue-sonner";
import {
  XMarkIcon,
  PlusIcon,
  BuildingStorefrontIcon,
  CheckCircleIcon,
  StarIcon,
  EyeIcon,
  EyeSlashIcon,
  CheckIcon,
  ScissorsIcon,
  SparklesIcon,
  PaintBrushIcon,
  ShoppingBagIcon,
  UserGroupIcon,
  DocumentCheckIcon
} from "@heroicons/vue/24/outline";
import { registerProOwner } from "@/lib/pro-api";
import { fetchPublicRegistrationDocs, uploadRegistrationDoc, fetchPublicCategories, fetchPublicPricing } from "@/lib/api";

const router = useRouter();
const currentStep = ref(1);
const loading = ref(false);
const docsLoading = ref(false);
const showPassword = ref(false);
const pricing = ref<{ standardPriceXof: number; premiumPriceXof: number }>({
  standardPriceXof: 15000,
  premiumPriceXof: 25000
});

const stepTitles = [
  "Inscrivez votre salon",
  "Que proposez-vous ?",
  "Quelle est la taille de votre équipe ?",
  "Choisissez votre plan",
  "Pièces justificatives"
];

const stepSubtitles = [
  "Commençons par faire connaissance. Votre salon sera configuré en quelques minutes.",
  "Sélectionnez la catégorie principale qui définit le mieux votre activité.",
  "Cela nous permet d'adapter l'agenda et la gestion des ressources.",
  "Sélectionnez le plan qui correspond le mieux à vos besoins actuels.",
  "Téléversez les documents nécessaires pour la validation de votre compte."
];

const CATEGORY_ICON_MAP: Record<string, ReturnType<typeof Object.values>[number]> = {
  Coiffure: ScissorsIcon,
  Barbier: ScissorsIcon,
  Barbershop: ScissorsIcon,
  Esthétique: SparklesIcon,
  Spa: SparklesIcon,
  Maquillage: ShoppingBagIcon,
  Ongles: PaintBrushIcon,
};

const categoryOptions = ref<{ name: string; icon: unknown }[]>([
  { name: "Coiffure", icon: ScissorsIcon },
  { name: "Esthétique", icon: SparklesIcon },
  { name: "Barbier", icon: ScissorsIcon },
  { name: "Ongles", icon: PaintBrushIcon },
  { name: "Spa", icon: SparklesIcon },
  { name: "Maquillage", icon: ShoppingBagIcon },
]);

async function loadCategories() {
  try {
    const cats = await fetchPublicCategories();
    if (cats.length > 0) {
      categoryOptions.value = cats.map((c) => ({
        name: c.name,
        icon: CATEGORY_ICON_MAP[c.name] ?? BuildingStorefrontIcon,
      }));
      if (!categoryOptions.value.find((c) => c.name === form.category)) {
        form.category = categoryOptions.value[0]?.name ?? "";
      }
    }
  } catch {
    // keep local fallback
  }
}

function formatPriceXof(value: number) {
  return new Intl.NumberFormat("fr-FR").format(value);
}

async function loadPricing() {
  try {
    const data = await fetchPublicPricing();
    pricing.value = {
      standardPriceXof: data.standard.priceXof,
      premiumPriceXof: data.premium.priceXof
    };
  } catch {
    // keep local fallback
  }
}

const teamSizeOptions = [
  { label: "Juste moi", desc: "1 collaborateur", dots: 1 },
  { label: "Petite équipe", desc: "2 à 5 collaborateurs", dots: 3 },
  { label: "Moyenne équipe", desc: "6 à 15 collaborateurs", dots: 5 },
  { label: "Grande équipe", desc: "16+ collaborateurs", dots: 10 }
];

const requiredDocs = ref([
  { label: "Registre de Commerce", desc: "Copie du RCCM ou équivalent", fileUrl: "" },
  { label: "Pièce d'Identité du Gérant", desc: "CNI, Passeport ou Permis", fileUrl: "" }
]);

// Fetch required docs from API when user reaches step 5
async function loadRequiredDocs() {
  if (docsLoading.value) return;
  docsLoading.value = true;
  try {
    const docs = await fetchPublicRegistrationDocs();
    if (docs.length > 0) {
      requiredDocs.value = docs.map((d) => ({
        label: d.label,
        desc: d.description ?? "",
        fileUrl: ""
      }));
    }
  } catch {
    // keep hardcoded fallback
  } finally {
    docsLoading.value = false;
  }
}

onMounted(() => {
  void loadCategories();
  void loadPricing();
});

const cities = ["Dakar", "Saint-Louis", "Thiès", "Saly", "Ziguinchor"];

const form = reactive({
  fullName: "",
  email: "",
  phone: "",
  password: "",
  salonName: "",
  category: "Coiffure",
  city: "Dakar",
  address: "",
  neighborhood: "",
  description: "",
  teamSize: "Juste moi",
  subscriptionIntentTier: "standard" as "standard" | "premium"
});

const fieldErrors = reactive<Record<string, string>>({});

function resetFieldErrors() {
  Object.keys(fieldErrors).forEach((k) => delete fieldErrors[k]);
}

function validateCurrentStep() {
  resetFieldErrors();
  if (currentStep.value === 1) {
    if (!form.salonName.trim()) fieldErrors.salonName = "Nom du salon requis.";
    if (!form.city.trim()) fieldErrors.city = "Ville requise.";
    if (!form.email.trim()) fieldErrors.email = "Email requis.";
    if (form.email.trim() && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email.trim())) {
      fieldErrors.email = "Format email invalide.";
    }
    if (!form.fullName.trim()) fieldErrors.fullName = "Nom complet requis.";
    if (!form.phone.replace(/\s+/g, "").trim()) fieldErrors.phone = "Téléphone requis.";
    if (!form.address.trim()) fieldErrors.address = "Adresse requise.";
    if (!form.password.trim()) fieldErrors.password = "Mot de passe requis.";
    if (form.password.trim() && form.password.trim().length < 8) {
      fieldErrors.password = "Minimum 8 caractères.";
    }
  }
  if (currentStep.value === 2 && !form.category) {
    toast.error("Sélectionnez une catégorie.");
    return false;
  }
  if (currentStep.value === 3 && !form.teamSize) {
    toast.error("Sélectionnez la taille de votre équipe.");
    return false;
  }
  if (currentStep.value === 4 && !form.subscriptionIntentTier) {
    toast.error("Choisissez un plan.");
    return false;
  }
  if (Object.keys(fieldErrors).length > 0) {
    toast.error("Corrigez les champs en erreur.");
    return false;
  }
  return true;
}

function nextStep() {
  if (!validateCurrentStep()) return;
  currentStep.value++;
  if (currentStep.value === 5) {
    void loadRequiredDocs();
  }
}

async function handleFileUpload(event: Event, index: number) {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];
  if (!file) return;

  const toastId = toast.loading("Téléversement du document...");
  try {
    const asset = await uploadRegistrationDoc(file);
    requiredDocs.value[index].fileUrl = asset.url;
    toast.success("Document ajouté.", { id: toastId });
  } catch (err) {
    toast.error("Échec du téléversement. Vérifiez le fichier puis réessayez.", { id: toastId });
  }
}

function removeDoc(index: number) {
  requiredDocs.value[index].fileUrl = "";
}

async function submitRegistration() {
  const email = form.email.trim();
  const phone = form.phone.replace(/\s+/g, "");
  
  // Mandatory documents check
  const missingDocs = requiredDocs.value.some(d => !d.fileUrl);
  if (missingDocs) {
    toast.error("Veuillez téléverser tous les documents requis.");
    return;
  }

  loading.value = true;
  try {
    await registerProOwner({
      type: "salon_owner",
      fullName: form.fullName.trim(),
      email,
      phone,
      password: form.password,
      subscriptionIntentTier: form.subscriptionIntentTier,
      salon: {
        name: form.salonName.trim(),
        category: form.category,
        city: form.city,
        address: form.address.trim(),
        neighborhood: form.neighborhood.trim() || undefined,
        description: form.description.trim() || `${form.category} à ${form.city}`,
      },
      hours: [0, 1, 2, 3, 4, 5, 6].map(d => ({
        dayOfWeek: d,
        isOpen: d !== 0,
        opensAt: "09:00",
        closesAt: "19:00"
      })),
      services: [],
      documents: requiredDocs.value.map(d => ({
        label: d.label,
        fileUrl: d.fileUrl
      }))
    });

    toast.success("Votre dossier a été soumis. Veuillez vous connecter pour suivre son avancement.");
    await router.push({
      path: "/pro/login",
      query: { email, registered: "1" }
    });
  } catch (error) {
    toast.error("Inscription impossible pour le moment. Vérifiez les champs du formulaire.");
  } finally {
    loading.value = false;
  }
}
</script>
