<template>
  <main class="bg-neutral-bg py-4 md:py-6 px-4 sm:px-6 font-sans antialiased">
    <form @submit.prevent="submitRegistration" class="mx-auto max-w-2xl">
      <header class="mb-4">
        <RouterLink to="/pro" class="inline-flex items-center gap-2 mb-3">
          <img src="/logo.png" alt="Beauté Avenue" class="h-7 w-auto" />
          <span class="row-meta">Beauté Avenue Pro</span>
        </RouterLink>
        <p class="section-label mb-1">Étape {{ currentStep }} sur 4</p>
        <h1 class="text-[30px] md:text-[34px] font-medium-bold text-espresso leading-tight tracking-tight">
          {{ stepTitles[currentStep - 1] }}
        </h1>
        <p class="text-[15px] text-cocoa/70 mt-1.5 leading-relaxed">
          {{ stepSubtitles[currentStep - 1] }}
        </p>
        <div class="flex items-center gap-2 mt-3">
          <div
            v-for="step in 4"
            :key="step"
            :class="[
              'h-1.5 rounded-full transition-all duration-500',
              currentStep === step ? 'w-10 bg-primary' : currentStep > step ? 'w-4 bg-primary/40' : 'w-4 bg-outline-variant'
            ]"
          ></div>
        </div>
      </header>

      <section class="panel-clean p-4 md:p-5 shadow-lg shadow-espresso/5 border-none">
        
        <!-- Step 1: Identity & Salon -->
        <div v-if="currentStep === 1" class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="md:col-span-2">
              <label for="salon-name" class="section-label mb-3 block">Nom du salon</label>
              <input id="salon-name" type="text" v-model="form.salonName" name="salon_name" autocomplete="organization" required :aria-invalid="Boolean(fieldErrors.salonName)" aria-describedby="salon-name-error" :class="['input-shell text-base py-3', fieldErrors.salonName ? 'border-red-400' : '']" placeholder="Beauté Divine" />
              <p id="salon-name-error" v-if="fieldErrors.salonName" class="text-xs text-red-600 mt-1">{{ fieldErrors.salonName }}</p>
            </div>
            <div>
              <label for="salon-city" class="section-label mb-3 block">Ville</label>
              <select id="salon-city" v-model="form.city" name="city" autocomplete="address-level2" required :aria-invalid="Boolean(fieldErrors.city)" aria-describedby="salon-city-error" :class="['input-shell text-base py-3 h-[52px]', fieldErrors.city ? 'border-red-400' : '']">
                <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
              </select>
              <p id="salon-city-error" v-if="fieldErrors.city" class="text-xs text-red-600 mt-1">{{ fieldErrors.city }}</p>
            </div>
            <div>
              <label for="owner-phone" class="section-label mb-3 block">Téléphone</label>
              <div
                :class="[
                  'flex items-center rounded-2xl border bg-white px-3',
                  fieldErrors.phone ? 'border-red-400' : 'border-outline-variant'
                ]"
              >
                <select
                  id="owner-phone-country"
                  v-model="selectedPhoneCountryCode"
                  name="phone_country_code"
                  autocomplete="tel-country-code"
                  class="h-[52px] w-[112px] bg-transparent border-0 pr-2 text-sm focus:outline-none"
                  aria-label="Indicatif pays"
                >
                  <option v-for="option in allowedPhoneCountries" :key="option.code" :value="option.code">
                    {{ option.flag }} {{ option.dialCode }}
                  </option>
                </select>
                <input
                  id="owner-phone"
                  type="tel"
                  v-model="form.phone"
                  name="phone_number"
                  autocomplete="tel-national"
                  inputmode="numeric"
                  maxlength="16"
                  required
                  :aria-invalid="Boolean(fieldErrors.phone)"
                  aria-describedby="owner-phone-error"
                  class="h-[52px] w-full border-0 bg-transparent pl-3 text-base focus:outline-none"
                  :placeholder="selectedPhoneCountry.placeholder"
                  @input="onPhoneInput"
                />
              </div>
              <p id="owner-phone-error" v-if="fieldErrors.phone" class="text-xs text-red-600 mt-1">{{ fieldErrors.phone }}</p>
            </div>
            <div>
              <label for="owner-email" class="section-label mb-3 block">Email professionnel</label>
              <input id="owner-email" type="email" v-model="form.email" name="owner_email" autocomplete="email" required :aria-invalid="Boolean(fieldErrors.email)" aria-describedby="owner-email-error" :class="['input-shell text-base py-3', fieldErrors.email ? 'border-red-400' : '']" placeholder="contact@monsalon.com" />
              <p id="owner-email-error" v-if="fieldErrors.email" class="text-xs text-red-600 mt-1">{{ fieldErrors.email }}</p>
            </div>
            <div>
              <label for="owner-name" class="section-label mb-3 block">Nom complet du gérant</label>
              <input id="owner-name" type="text" v-model="form.fullName" name="owner_full_name" autocomplete="name" required :aria-invalid="Boolean(fieldErrors.fullName)" aria-describedby="owner-name-error" :class="['input-shell text-base py-3', fieldErrors.fullName ? 'border-red-400' : '']" placeholder="Marie Diop" />
              <p id="owner-name-error" v-if="fieldErrors.fullName" class="text-xs text-red-600 mt-1">{{ fieldErrors.fullName }}</p>
            </div>
            <div class="md:col-span-2">
              <label for="salon-address" class="section-label mb-3 block">Adresse précise</label>
              <input id="salon-address" type="text" v-model="form.address" name="salon_address" autocomplete="street-address" required :aria-invalid="Boolean(fieldErrors.address)" aria-describedby="salon-address-error" :class="['input-shell text-base py-3', fieldErrors.address ? 'border-red-400' : '']" placeholder="Rue des Poilus, Zone A..." />
              <p id="salon-address-error" v-if="fieldErrors.address" class="text-xs text-red-600 mt-1">{{ fieldErrors.address }}</p>
            </div>
            <div>
              <label for="salon-neighborhood" class="section-label mb-3 block">Quartier <span class="text-cocoa/40 font-normal normal-case">(optionnel)</span></label>
              <input id="salon-neighborhood" type="text" v-model="form.neighborhood" name="salon_neighborhood" autocomplete="address-level3" class="input-shell text-base py-3" placeholder="Plateau, Mermoz, Almadies…" />
            </div>
            <div>
              <label for="salon-description" class="section-label mb-3 block">Description du salon <span class="text-cocoa/40 font-normal normal-case">(optionnel)</span></label>
              <textarea id="salon-description" v-model="form.description" rows="3" name="salon_description" autocomplete="off" class="input-shell text-base py-3 resize-none" placeholder="Décrivez votre salon, vos spécialités, l'ambiance…"></textarea>
            </div>
            <div class="md:col-span-2">
              <label for="owner-password" class="section-label mb-3 block">Mot de passe</label>
              <div class="relative">
                <input
                  id="owner-password"
                  :type="showPassword ? 'text' : 'password'"
                  v-model="form.password"
                  name="owner_password"
                  autocomplete="new-password"
                  minlength="8"
                  :class="['input-shell text-base py-3 pr-12', fieldErrors.password ? 'border-red-400' : '']"
                  placeholder="••••••••"
                  required
                  :aria-invalid="Boolean(fieldErrors.password)"
                  aria-describedby="owner-password-error"
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
              <p id="owner-password-error" v-if="fieldErrors.password" class="text-xs text-red-600 mt-1">{{ fieldErrors.password }}</p>
            </div>
          </div>
        </div>

        <!-- Step 2: Categories -->
        <div v-if="currentStep === 2">
          <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
            <button
              type="button"
              v-for="cat in categoryOptions" 
              :key="cat.name"
              @click="form.category = cat.name"
              :aria-pressed="form.category === cat.name"
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
              type="button"
              v-for="size in teamSizeOptions" 
              :key="size.label"
              @click="form.teamSize = size.label"
              :aria-pressed="form.teamSize === size.label"
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

        <!-- Step 4: Documents -->
        <div v-if="currentStep === 4" class="space-y-8">
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

      </section>

      <div class="flex items-center justify-center gap-3 mt-4">
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
          v-if="currentStep < 4" 
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
  </main>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted, computed } from "vue";
import { useRouter } from "vue-router";
import { toast } from "vue-sonner";
import {
  XMarkIcon,
  PlusIcon,
  BuildingStorefrontIcon,
  EyeIcon,
  EyeSlashIcon,
  ScissorsIcon,
  SparklesIcon,
  PaintBrushIcon,
  ShoppingBagIcon,
  UserGroupIcon,
  DocumentCheckIcon
} from "@heroicons/vue/24/outline";
import { registerProOwner } from "@/lib/pro-api";
import { fetchPublicRegistrationDocs, uploadRegistrationDoc, fetchPublicCategories, fetchPublicPricing } from "@/lib/api";
import { getErrorMessage } from "@/lib/errors";

const router = useRouter();
const currentStep = ref(1);
const loading = ref(false);
const docsLoading = ref(false);
const showPassword = ref(false);

type PhoneCountry = {
  code: string;
  flag: string;
  dialCode: string;
  placeholder: string;
  nationalDigits: number;
};

const PHONE_COUNTRY_MAP: Record<string, PhoneCountry> = {
  sn: { code: "sn", flag: "🇸🇳", dialCode: "+221", placeholder: "77 123 45 67", nationalDigits: 9 },
  ci: { code: "ci", flag: "🇨🇮", dialCode: "+225", placeholder: "01 23 45 67 89", nationalDigits: 10 },
  bf: { code: "bf", flag: "🇧🇫", dialCode: "+226", placeholder: "70 12 34 56", nationalDigits: 8 },
  bj: { code: "bj", flag: "🇧🇯", dialCode: "+229", placeholder: "01 95 12 34 56", nationalDigits: 10 },
  tg: { code: "tg", flag: "🇹🇬", dialCode: "+228", placeholder: "90 12 34 56", nationalDigits: 8 },
  ml: { code: "ml", flag: "🇲🇱", dialCode: "+223", placeholder: "70 12 34 56", nationalDigits: 8 },
  cm: { code: "cm", flag: "🇨🇲", dialCode: "+237", placeholder: "6 12 34 56 78", nationalDigits: 9 }
};

const configuredPhoneCountries = ((import.meta.env.VITE_ALLOWED_PHONE_COUNTRIES as string | undefined) ?? "sn")
  .split(",")
  .map((item) => item.trim().toLowerCase())
  .filter((code) => code in PHONE_COUNTRY_MAP);

const allowedPhoneCountries = (configuredPhoneCountries.length > 0 ? configuredPhoneCountries : ["sn"])
  .map((code) => PHONE_COUNTRY_MAP[code]);

const selectedPhoneCountryCode = ref(allowedPhoneCountries[0]?.code ?? "sn");
const selectedPhoneCountry = computed(() => PHONE_COUNTRY_MAP[selectedPhoneCountryCode.value] ?? PHONE_COUNTRY_MAP.sn);
const pricing = ref<{ standardPriceXof: number; premiumPriceXof: number }>({
  standardPriceXof: 15000,
  premiumPriceXof: 25000
});

const stepTitles = [
  "Inscrivez votre salon",
  "Que proposez-vous ?",
  "Quelle est la taille de votre équipe ?",
  "Pièces justificatives"
];

const stepSubtitles = [
  "Commençons par faire connaissance. Votre salon sera configuré en quelques minutes.",
  "Sélectionnez la catégorie principale qui définit le mieux votre activité.",
  "Cela nous permet d'adapter l'agenda et la gestion des ressources.",
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

// Fetch required docs from API when user reaches step 4
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

function onBeforeUnload(event: BeforeUnloadEvent) {
  const hasData = form.salonName || form.fullName || form.email || form.phone || form.password || form.address || form.neighborhood || form.description;
  if (hasData) {
    event.preventDefault();
  }
}

onMounted(() => {
  void loadCategories();
  void loadPricing();
  window.addEventListener("beforeunload", onBeforeUnload);
});

onUnmounted(() => {
  window.removeEventListener("beforeunload", onBeforeUnload);
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
  teamSize: "Juste moi"
});

function onPhoneInput(event: Event) {
  const input = event.target as HTMLInputElement;
  const digits = input.value.replace(/\D+/g, "").slice(0, selectedPhoneCountry.value.nationalDigits);
  const chunks = digits.match(/.{1,2}/g) ?? [];
  form.phone = chunks.join(" ");
}

const fieldErrors = reactive<Record<string, string>>({});

function resetFieldErrors() {
  Object.keys(fieldErrors).forEach((k) => delete fieldErrors[k]);
}

function validateCurrentStep() {
  resetFieldErrors();
  if (currentStep.value === 1) {
    const salonName = form.salonName.trim();
    const fullName = form.fullName.trim();
    const email = form.email.trim();
    const address = form.address.trim();
    const localDigits = form.phone.replace(/\D+/g, "");
    const expectedDigits = selectedPhoneCountry.value.nationalDigits;

    if (!salonName) fieldErrors.salonName = "Nom du salon requis.";
    else if (salonName.length < 2) fieldErrors.salonName = "Nom du salon trop court.";
    else if (salonName.length > 120) fieldErrors.salonName = "Nom du salon trop long.";

    if (!form.city.trim()) fieldErrors.city = "Ville requise.";
    else if (!cities.includes(form.city)) fieldErrors.city = "Ville invalide.";

    if (!email) fieldErrors.email = "Email requis.";
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      fieldErrors.email = "Format email invalide.";
    }
    if (!fullName) fieldErrors.fullName = "Nom complet requis.";
    else if (fullName.length < 2) fieldErrors.fullName = "Nom complet trop court.";

    if (!localDigits) fieldErrors.phone = "Téléphone requis.";
    else if (localDigits.length !== expectedDigits) {
      fieldErrors.phone = `Ce pays attend ${expectedDigits} chiffres.`;
    }

    if (!address) fieldErrors.address = "Adresse requise.";
    else if (address.length < 5) fieldErrors.address = "Adresse trop courte.";

    if (!form.password.trim()) fieldErrors.password = "Mot de passe requis.";
    if (form.password.trim() && form.password.trim().length < 8) fieldErrors.password = "Minimum 8 caractères.";
    if (form.password.trim() && (!/[A-Za-z]/.test(form.password) || !/\d/.test(form.password))) {
      fieldErrors.password = "Incluez au moins une lettre et un chiffre.";
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
  if (Object.keys(fieldErrors).length > 0) {
    toast.error("Corrigez les champs en erreur.");
    return false;
  }
  return true;
}

function nextStep() {
  if (!validateCurrentStep()) return;
  currentStep.value++;
  if (currentStep.value === 4) {
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
  const phoneNational = form.phone.replace(/\D+/g, "");
  const phone = `${selectedPhoneCountry.value.dialCode}${phoneNational}`;
  
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
    toast.error(getErrorMessage(error, "Inscription impossible pour le moment."));
  } finally {
    loading.value = false;
  }
}
</script>
