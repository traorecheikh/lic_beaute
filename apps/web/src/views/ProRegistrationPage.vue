<template>
  <main class="bg-neutral-bg py-6 md:py-10 px-4 sm:px-6 font-sans antialiased min-h-screen flex items-center justify-center">
    <div class="w-full max-w-xl">
      <form @submit.prevent="submitRegistration" class="space-y-6">
        
        <!-- Header -->
        <header class="text-center lg:text-left mb-6">
          <RouterLink to="/pro" class="inline-flex items-center gap-2 mb-4 justify-center lg:justify-start">
            <img src="/logo.png" alt="Beauté Avenue" class="h-8 w-auto" />
            <span class="row-meta font-bold">Beauté Avenue Pro</span>
          </RouterLink>
          <p class="section-label mb-1.5">Étape {{ currentStep }} sur 4 : {{ stepLabels[currentStep - 1] }}</p>
          <h1 class="page-title">
            {{ stepTitles[currentStep - 1] }}
          </h1>
          <p class="row-meta mt-2 text-cocoa/70 leading-relaxed">
            {{ stepSubtitles[currentStep - 1] }}
          </p>
          
          <!-- Progress Bar Indicators -->
          <div class="flex items-center justify-center lg:justify-start gap-2.5 mt-4">
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

        <p class="text-[13px] text-cocoa/60 text-right">
          Déjà inscrit ?
          <RouterLink to="/pro/login" class="font-bold text-primary hover:text-primary/80 transition-colors">Connectez-vous</RouterLink>
        </p>

        <!-- Main Form Panel -->
        <section class="panel-clean p-6 md:p-8 pb-24 md:pb-8 bg-white border border-outline-variant/60 shadow-xl shadow-espresso/[0.02]">
           <!-- Step 1: Identity & Salon -->
          <div v-if="currentStep === 1" class="space-y-5">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
              
              <!-- Salon Name -->
              <div class="md:col-span-2">
                <label for="salon-name" class="section-label mb-2 block">Nom du salon</label>
                <input 
                  id="salon-name" 
                  type="text" 
                  v-model="form.salonName" 
                  name="salon_name" 
                  autocomplete="organization" 
                  required 
                  :aria-invalid="Boolean(fieldErrors.salonName)" 
                  aria-describedby="salon-name-error" 
                  :class="['input-shell text-base py-3', fieldErrors.salonName ? 'input-error' : '']" 
                  placeholder="Beauté Divine" 
                  @blur="touched.salonName = true; validateField('salonName')"
                  @input="handleFieldInput('salonName')"
                />
                <div class="flex items-center gap-2 mt-1.5 min-h-[16px]">
                  <p id="salon-name-error" v-if="fieldErrors.salonName" class="text-xs text-error font-medium">{{ fieldErrors.salonName }}</p>
                  <span v-if="validatingSalonName" class="text-[10px] text-cocoa/40 animate-pulse">Vérification de la disponibilité...</span>
                </div>
              </div>

              <!-- Location Selection -->
              <div class="md:col-span-2 space-y-4">
                <div class="flex items-center justify-between">
                  <span class="section-label">Localisation du salon</span>
                </div>
                
                <!-- State: Geolocation not done and manual mode not active -->
                <div v-if="!isGeolocated && !showManualAddress" class="p-6 border border-dashed border-outline-variant rounded-2xl bg-sand/30 flex flex-col items-center justify-center text-center gap-4 transition-all">
                  <div class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                    <MapPinIcon class="w-6 h-6" />
                  </div>
                  <div>
                    <h3 class="row-primary text-base">Où se situe votre salon ?</h3>
                    <p class="row-meta mt-1 text-cocoa/60 max-w-sm">
                      Utilisez la géolocalisation pour remplir automatiquement votre adresse, quartier et ville en un clic.
                    </p>
                  </div>
                  <div class="flex flex-col sm:flex-row items-center gap-3 w-full max-w-md justify-center mt-2">
                    <button
                      type="button"
                      @click="geolocateUser"
                      :disabled="geolocating"
                      class="btn-primary w-full sm:w-auto px-6 py-3 flex items-center justify-center gap-2 cursor-pointer disabled:opacity-50 select-none"
                    >
                      <svg v-if="geolocating" class="animate-spin h-3.5 w-3.5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                      </svg>
                      <MapPinIcon v-else class="w-4 h-4" />
                      <span>{{ geolocating ? 'Détection...' : 'Détecter ma position' }}</span>
                    </button>
                    <button
                      type="button"
                      @click="showManualAddress = true"
                      class="btn-secondary w-full sm:w-auto px-6 py-3 cursor-pointer select-none"
                    >
                      Saisir manuellement
                    </button>
                  </div>
                </div>

                <!-- State: Geolocation Success -->
                <div v-else-if="isGeolocated && !showManualAddress" class="p-5 border border-primary/20 bg-primary/[0.02] rounded-2xl flex items-start gap-4 transition-all">
                  <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary shrink-0 mt-0.5">
                    <MapPinIcon class="w-5 h-5" />
                  </div>
                  <div class="flex-1 min-w-0">
                    <div class="flex items-center justify-between gap-2">
                      <span class="section-label text-primary">Position Détectée</span>
                      <button
                        type="button"
                        @click="showManualAddress = true"
                        class="row-meta font-bold text-cocoa/50 hover:text-primary transition-colors cursor-pointer select-none"
                      >
                        Modifier
                      </button>
                    </div>
                    <p class="row-primary mt-1.5 truncate">{{ form.address }}</p>
                    <p class="row-meta mt-1 text-cocoa/60">
                      {{ form.neighborhood ? form.neighborhood + ', ' : '' }}{{ form.city }}
                    </p>
                  </div>
                </div>

                <!-- State: Manual Address Inputs OR Editing Mode -->
                <div v-else class="space-y-4 border border-outline-variant/60 p-5 rounded-2xl bg-neutral-bg/20">
                  <div class="flex items-center justify-between">
                    <span class="section-label">Adresse de l'établissement</span>
                    <button
                      type="button"
                      @click="geolocateUser"
                      :disabled="geolocating"
                      class="row-meta font-bold text-primary hover:text-primary/80 flex items-center gap-1.5 cursor-pointer disabled:opacity-50 select-none"
                    >
                      <svg v-if="geolocating" class="animate-spin h-3.5 w-3.5 text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                      </svg>
                      <MapPinIcon v-else class="w-3.5 h-3.5" />
                      <span>{{ geolocating ? 'Détection...' : 'Me géolocaliser' }}</span>
                    </button>
                  </div>

                  <!-- Address Field -->
                  <div>
                    <label for="salon-address" class="row-meta font-bold block mb-1.5">Adresse précise</label>
                    <input 
                      id="salon-address" 
                      type="text" 
                      v-model="form.address" 
                      name="salon_address" 
                      autocomplete="street-address" 
                      required 
                      :aria-invalid="Boolean(fieldErrors.address)" 
                      aria-describedby="salon-address-error" 
                      :class="['input-shell text-base py-3', fieldErrors.address ? 'input-error' : '']" 
                      placeholder="Rue des Poilus, Zone A..." 
                      @blur="touched.address = true; validateField('address')"
                      @input="handleFieldInput('address')"
                    />
                    <p id="salon-address-error" v-if="fieldErrors.address" class="row-meta text-error font-bold mt-1.5">{{ fieldErrors.address }}</p>
                  </div>

                  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Neighborhood / Quartier -->
                    <div>
                      <label for="salon-neighborhood" class="row-meta font-bold block mb-1.5">Quartier <span class="row-meta text-cocoa/40 font-normal normal-case">(optionnel)</span></label>
                      <input 
                        id="salon-neighborhood" 
                        type="text" 
                        v-model="form.neighborhood" 
                        name="salon_neighborhood" 
                        autocomplete="address-level3" 
                        class="input-shell text-base py-3" 
                        placeholder="Plateau, Mermoz, Almadies…" 
                      />
                    </div>

                    <!-- City / Ville -->
                    <div>
                      <label for="salon-city" class="row-meta font-bold block mb-1.5">Ville</label>
                      <select 
                        id="salon-city" 
                        v-model="form.city" 
                        name="city" 
                        autocomplete="address-level2" 
                        required 
                        :aria-invalid="Boolean(fieldErrors.city)" 
                        aria-describedby="salon-city-error" 
                        :class="['input-shell text-base py-3 h-[52px]', fieldErrors.city ? 'input-error' : '']"
                        @change="touched.city = true; validateField('city')"
                      >
                        <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
                      </select>
                      <p id="salon-city-error" v-if="fieldErrors.city" class="row-meta text-error font-bold mt-1.5">{{ fieldErrors.city }}</p>
                    </div>
                  </div>

                  <!-- Option to go back to summary if we have geolocated before -->
                  <div v-if="isGeolocated" class="text-right">
                    <button
                      type="button"
                      @click="showManualAddress = false"
                      class="row-meta font-bold text-primary hover:text-primary/80 cursor-pointer select-none"
                    >
                      Retour à la vue simplifiée
                    </button>
                  </div>
                </div>
              </div>

              <!-- Owner Full Name -->
              <div>
                <label for="owner-name" class="section-label mb-2 block">Nom du gérant</label>
                <input 
                  id="owner-name" 
                  type="text" 
                  v-model="form.fullName" 
                  name="owner_full_name" 
                  autocomplete="name" 
                  required 
                  :aria-invalid="Boolean(fieldErrors.fullName)" 
                  aria-describedby="owner-name-error" 
                  :class="['input-shell text-base py-3', fieldErrors.fullName ? 'input-error' : '']" 
                  placeholder="Marie Diop" 
                  @blur="touched.fullName = true; validateField('fullName')"
                  @input="handleFieldInput('fullName')"
                />
                <p id="owner-name-error" v-if="fieldErrors.fullName" class="text-xs text-error font-medium mt-1.5">{{ fieldErrors.fullName }}</p>
              </div>

              <!-- Phone Number -->
              <div>
                <label for="owner-phone" class="section-label mb-2 block">Téléphone</label>
                <div
                  :class="[
                    'flex items-center rounded-xl border bg-white px-3 focus-within:ring-2 focus-within:ring-primary/10 focus-within:border-primary/40 transition-all',
                    fieldErrors.phone ? 'border-error/50 ring-1 ring-error/20 bg-error/[0.02]' : 'border-outline-variant'
                  ]"
                >
                  <select
                    id="owner-phone-country"
                    v-model="selectedPhoneCountryCode"
                    name="phone_country_code"
                    autocomplete="tel-country-code"
                    class="h-[52px] w-[96px] bg-transparent border-0 pr-1 text-sm focus:outline-none cursor-pointer"
                    aria-label="Indicatif pays"
                    @change="handleFieldInput('phone')"
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
                    class="h-[52px] w-full border-0 bg-transparent pl-3 text-base focus:outline-none placeholder:text-cocoa/30"
                    :placeholder="selectedPhoneCountry.placeholder"
                    @input="handlePhoneInput"
                    @blur="touched.phone = true; validateField('phone')"
                  />
                </div>
                <div class="flex items-center gap-2 mt-1.5 min-h-[16px]">
                  <p id="owner-phone-error" v-if="fieldErrors.phone" class="text-xs text-error font-medium">{{ fieldErrors.phone }}</p>
                  <span v-if="validatingPhone" class="text-[10px] text-cocoa/40 animate-pulse">Vérification de la disponibilité...</span>
                </div>
              </div>

              <!-- Professional Email -->
              <div>
                <label for="owner-email" class="section-label mb-2 block">Email professionnel</label>
                <input 
                  id="owner-email" 
                  type="email" 
                  v-model="form.email" 
                  name="owner_email" 
                  autocomplete="email" 
                  required 
                  :aria-invalid="Boolean(fieldErrors.email)" 
                  aria-describedby="owner-email-error" 
                  :class="['input-shell text-base py-3', fieldErrors.email ? 'input-error' : '']" 
                  placeholder="contact@monsalon.com" 
                  @blur="touched.email = true; validateField('email')"
                  @input="handleFieldInput('email')"
                />
                <div class="flex items-center gap-2 mt-1.5 min-h-[16px]">
                  <p id="owner-email-error" v-if="fieldErrors.email" class="text-xs text-error font-medium">{{ fieldErrors.email }}</p>
                  <span v-if="validatingEmail" class="text-[10px] text-cocoa/40 animate-pulse">Vérification de la disponibilité...</span>
                </div>
              </div>

              <!-- Password -->
              <div>
                <label for="owner-password" class="section-label mb-2 block">Mot de passe</label>
                <div class="relative">
                  <input
                    id="owner-password"
                    :type="showPassword ? 'text' : 'password'"
                    v-model="form.password"
                    name="owner_password"
                    autocomplete="new-password"
                    minlength="8"
                    :class="['input-shell text-base py-3 pr-12', fieldErrors.password ? 'input-error' : '']"
                    placeholder="••••••••"
                    required
                    :aria-invalid="Boolean(fieldErrors.password)"
                    aria-describedby="owner-password-error"
                    @blur="touched.password = true; validateField('password')"
                    @input="handleFieldInput('password')"
                  />
                  <button
                    type="button"
                    class="absolute right-3 top-1/2 -translate-y-1/2 text-cocoa/50 hover:text-cocoa cursor-pointer p-1 rounded focus:outline-none focus:ring-2 focus:ring-primary/20"
                    :aria-label="showPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe'"
                    @click="showPassword = !showPassword"
                  >
                    <EyeSlashIcon v-if="showPassword" class="w-5 h-5" />
                    <EyeIcon v-else class="w-5 h-5" />
                  </button>
                </div>
                <p id="owner-password-error" v-if="fieldErrors.password" class="text-xs text-error font-medium mt-1.5">{{ fieldErrors.password }}</p>
              </div>
            </div>
          </div>

          <!-- Step 2: Categories -->
          <div v-if="currentStep === 2" class="space-y-6">
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
              <button
                type="button"
                v-for="cat in categoryOptions" 
                :key="cat.name"
                @click="form.category = cat.name"
                :aria-pressed="form.category === cat.name"
                :class="[
                  'p-6 rounded-2xl border-2 transition-all flex flex-col items-center gap-4 text-center group cursor-pointer',
                  form.category === cat.name 
                    ? 'border-primary bg-primary/5 shadow-sm' 
                    : 'border-outline-variant bg-white hover:border-primary/30'
                ]"
              >
                <div :class="[
                  'w-14 h-14 rounded-2xl flex items-center justify-center transition-all',
                  form.category === cat.name ? 'bg-primary text-white scale-105' : 'bg-neutral-bg text-cocoa/40 group-hover:bg-primary/10 group-hover:text-primary'
                ]">
                  <component :is="cat.icon" class="w-7 h-7" />
                </div>
                <span :class="[
                  'text-[14px] font-medium-bold tracking-tight',
                  form.category === cat.name ? 'text-espresso' : 'text-cocoa/60'
                ]">{{ cat.name }}</span>
              </button>
            </div>

            <!-- Description du salon -->
            <div class="border-t border-outline-variant/60 pt-5">
              <label for="salon-description" class="section-label mb-2 block">Description du salon <span class="text-cocoa/40 font-normal normal-case">(optionnel)</span></label>
              <textarea 
                id="salon-description" 
                v-model="form.description" 
                rows="3" 
                name="salon_description" 
                autocomplete="off" 
                class="input-shell text-base py-3 resize-none h-[115px]" 
                placeholder="Décrivez votre salon, vos spécialités, l'ambiance…"
              ></textarea>
            </div>
          </div>

          <!-- Step 3: Team Size -->
          <div v-if="currentStep === 3" class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <button
                type="button"
                v-for="size in teamSizeOptions" 
                :key="size.label"
                @click="form.teamSize = size.label"
                :aria-pressed="form.teamSize === size.label"
                :class="[
                  'p-8 rounded-2xl border-2 transition-all flex flex-col items-center gap-5 text-center group cursor-pointer',
                  form.teamSize === size.label 
                    ? 'border-primary bg-primary/5 shadow-sm' 
                    : 'border-outline-variant bg-white hover:border-primary/30'
                ]"
              >
                <div class="flex items-center gap-1">
                  <div 
                    v-for="i in size.dots" 
                    :key="i"
                    :class="[
                      'w-2.5 h-2.5 rounded-full',
                      form.teamSize === size.label ? 'bg-primary' : 'bg-outline-variant group-hover:bg-primary/30'
                    ]"
                  ></div>
                </div>
                <div>
                  <span :class="[
                    'text-[16px] font-medium-bold tracking-tight block',
                    form.teamSize === size.label ? 'text-espresso' : 'text-cocoa/60'
                  ]">{{ size.label }}</span>
                  <span class="text-[10px] text-cocoa/45 font-bold uppercase tracking-wider mt-1 block">{{ size.desc }}</span>
                </div>
              </button>
            </div>
          </div>

          <!-- Step 4: Documents -->
          <div v-if="currentStep === 4" class="space-y-6">
            <div class="bg-primary/5 rounded-2xl p-5 border border-primary/10">
              <p class="text-xs text-cocoa leading-relaxed">
                Pour des raisons de sécurité et de conformité, nous devons vérifier l'existence légale de votre établissement. Vos pièces justificatives restent hautement sécurisées.
              </p>
            </div>

            <div class="space-y-4">
              <div v-for="(doc, index) in requiredDocs" :key="doc.label" class="panel-clean p-5 border-dashed border-2 flex flex-col md:flex-row items-center gap-5">
                <div class="flex-1 text-center md:text-left">
                  <h3 class="text-[14px] font-medium-bold text-espresso mb-0.5">{{ doc.label }}</h3>
                  <p class="text-[11px] text-cocoa/60">{{ doc.desc }}</p>
                </div>
                
                <div class="shrink-0 w-full md:w-auto">
                  <div v-if="doc.fileUrl" class="flex items-center justify-center gap-2 bg-primary/10 px-4 py-2.5 rounded-xl text-primary font-bold text-xs">
                    <DocumentCheckIcon class="w-4 h-4 shrink-0" />
                    <span>Document ajouté</span>
                    <button type="button" @click="removeDoc(index)" class="ml-2 text-cocoa/40 hover:text-error transition cursor-pointer p-0.5 rounded" aria-label="Supprimer le document">
                      <XMarkIcon class="w-4 h-4" />
                    </button>
                  </div>
                  <label v-else class="btn-secondary w-full md:w-auto px-5 py-2.5 text-[10px] cursor-pointer inline-flex items-center justify-center gap-1.5 select-none">
                    <span>Téléverser</span>
                    <input type="file" @change="handleFileUpload($event, index)" class="sr-only" accept="image/*,.pdf" />
                  </label>
                </div>
              </div>
            </div>
          </div>

          <!-- Actions Footer Buttons -->
          <div class="fixed bottom-0 left-0 right-0 p-4 bg-white/95 backdrop-blur-sm border-t border-outline-variant/60 shadow-[0_-8px_24px_rgba(45,26,18,0.04)] z-40 flex items-center justify-center gap-4 md:relative md:bottom-auto md:left-auto md:right-auto md:p-0 md:bg-transparent md:backdrop-blur-none md:border-t-0 md:shadow-none md:z-auto md:mt-8">
            <button
              type="button"
              v-if="currentStep > 1" 
              @click="currentStep--" 
              class="btn-secondary px-8 py-3.5 h-[52px] font-medium-bold cursor-pointer select-none flex-1 md:flex-initial"
            >
              Retour
            </button>
            
            <button
              type="button"
              v-if="currentStep < 4" 
              @click="nextStep" 
              class="btn-primary flex-1 max-w-xs py-3.5 h-[52px] text-sm font-medium-bold shadow-md shadow-primary/10 cursor-pointer select-none"
            >
              Continuer
            </button>
            
            <button
              v-else
              type="submit"
              :disabled="loading"
              class="btn-primary flex-1 max-w-xs py-3.5 h-[52px] text-sm font-medium-bold shadow-md shadow-primary/10 disabled:opacity-50 flex items-center justify-center gap-2 cursor-pointer select-none"
            >
              <svg v-if="loading" class="animate-spin w-5 h-5 shrink-0 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-30" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
                <path class="opacity-80" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              <span>{{ loading ? 'Finalisation en cours…' : 'Ouvrir mon salon' }}</span>
            </button>
          </div>

        </section>

          </form>
        </div>
      </main>
    </template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted, computed, watch } from "vue";
import { useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { refDebounced } from "@vueuse/core";
import {
  XMarkIcon,
  EyeIcon,
  EyeSlashIcon,
  ScissorsIcon,
  SparklesIcon,
  PaintBrushIcon,
  ShoppingBagIcon,
  DocumentCheckIcon,
  MapPinIcon
} from "@heroicons/vue/24/outline";
import { registerProOwner } from "@/lib/pro-api";
import { fetchPublicRegistrationDocs, uploadRegistrationDoc, fetchPublicCategories, fetchPublicPricing, checkPublicUniqueness } from "@/lib/api";
import { getErrorMessage } from "@/lib/errors";

const router = useRouter();
const currentStep = ref(1);
const loading = ref(false);
const docsLoading = ref(false);
const showPassword = ref(false);
const geolocating = ref(false);
const isGeolocated = ref(false);
const showManualAddress = ref(false);

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

const stepLabels = [
  "Informations de base",
  "Catégorie d'activité",
  "Taille de l'équipe",
  "Pièces justificatives"
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
        icon: CATEGORY_ICON_MAP[c.name] ?? ScissorsIcon,
      }));
      if (!categoryOptions.value.find((c) => c.name === form.category)) {
        form.category = categoryOptions.value[0]?.name ?? "";
      }
    }
  } catch {
    // keep local fallback
  }
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

const cities = ref(["Dakar", "Saint-Louis", "Thiès", "Saly", "Ziguinchor"]);

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

const validatingEmail = ref(false);
const validatingPhone = ref(false);
const validatingSalonName = ref(false);

const rawEmail = ref("");
const rawPhone = ref("");
const rawSalonName = ref("");
watch(() => form.email, (v) => { rawEmail.value = v; });
watch(() => form.phone.replace(/\D+/g, ""), (v) => { rawPhone.value = v; });
watch(() => form.salonName, (v) => { rawSalonName.value = v; });
const debouncedEmail = refDebounced(rawEmail, 600);
const debouncedPhone = refDebounced(rawPhone, 600);
const debouncedSalonName = refDebounced(rawSalonName, 600);

watch(debouncedEmail, async (email) => {
  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return;
  validatingEmail.value = true;
  try {
    const result = await checkPublicUniqueness({ email });
    if (result.email === "taken") {
      fieldErrors.email = "Cet email est déjà associé à un salon.";
    } else if (fieldErrors.email === "Cet email est déjà associé à un salon.") {
      delete fieldErrors.email;
    }
  } catch { /* ignore */ }
  finally { validatingEmail.value = false; }
});

watch(debouncedPhone, async (phone) => {
  if (!phone || phone.length < 8) return;
  validatingPhone.value = true;
  try {
    const result = await checkPublicUniqueness({ phone });
    if (result.phone === "taken") {
      fieldErrors.phone = "Ce numéro est déjà associé à un salon.";
    } else if (fieldErrors.phone === "Ce numéro est déjà associé à un salon.") {
      delete fieldErrors.phone;
    }
  } catch { /* ignore */ }
  finally { validatingPhone.value = false; }
});

watch(debouncedSalonName, async (name) => {
  if (!name || name.trim().length < 2) return;
  validatingSalonName.value = true;
  try {
    const result = await checkPublicUniqueness({ name: name.trim() });
    if (result.name === "taken") {
      fieldErrors.salonName = "Ce nom de salon est déjà utilisé.";
    } else if (fieldErrors.salonName === "Ce nom de salon est déjà utilisé.") {
      delete fieldErrors.salonName;
    }
  } catch { /* ignore */ }
  finally { validatingSalonName.value = false; }
});

function onPhoneInput(event: Event) {
  const input = event.target as HTMLInputElement;
  const digits = input.value.replace(/\D+/g, "").slice(0, selectedPhoneCountry.value.nationalDigits);
  const chunks = digits.match(/.{1,2}/g) ?? [];
  form.phone = chunks.join(" ");
}

function handleFieldInput(field: string) {
  if (touched[field]) {
    validateField(field);
  }
}

function handlePhoneInput(event: Event) {
  onPhoneInput(event);
  if (touched.phone) {
    validateField("phone");
  }
}

const fieldErrors = reactive<Record<string, string>>({});
const touched = reactive<Record<string, boolean>>({});

function validateField(field: string) {
  if (field === "salonName") {
    const val = form.salonName.trim();
    if (!val) fieldErrors.salonName = "Nom du salon requis.";
    else if (val.length < 2) fieldErrors.salonName = "Le nom doit comporter au moins 2 caractères.";
    else if (val.length > 120) fieldErrors.salonName = "Le nom ne doit pas dépasser 120 caractères.";
    else if (fieldErrors.salonName && fieldErrors.salonName !== "Ce nom de salon est déjà utilisé.") {
      delete fieldErrors.salonName;
    }
  }

  if (field === "city") {
    const val = form.city.trim();
    if (!val) fieldErrors.city = "Ville requise.";
    else if (!cities.value.includes(val)) fieldErrors.city = "Ville invalide.";
    else delete fieldErrors.city;
  }

  if (field === "fullName") {
    const val = form.fullName.trim();
    if (!val) fieldErrors.fullName = "Nom complet du gérant requis.";
    else if (val.length < 2) fieldErrors.fullName = "Le nom doit comporter au moins 2 caractères.";
    else delete fieldErrors.fullName;
  }

  if (field === "email") {
    const val = form.email.trim();
    if (!val) fieldErrors.email = "Email requis.";
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
      fieldErrors.email = "Format d'adresse email invalide.";
    } else if (fieldErrors.email && fieldErrors.email !== "Cet email est déjà associé à un salon.") {
      delete fieldErrors.email;
    }
  }

  if (field === "phone") {
    const digits = form.phone.replace(/\D+/g, "");
    const expected = selectedPhoneCountry.value.nationalDigits;
    if (!digits) fieldErrors.phone = "Numéro de téléphone requis.";
    else if (digits.length !== expected) {
      fieldErrors.phone = `Le numéro doit comporter exactement ${expected} chiffres.`;
    } else if (fieldErrors.phone && fieldErrors.phone !== "Ce numéro est déjà associé à un salon.") {
      delete fieldErrors.phone;
    }
  }

  if (field === "address") {
    const val = form.address.trim();
    if (!val) fieldErrors.address = "Adresse précise requise.";
    else if (val.length < 5) fieldErrors.address = "L'adresse doit comporter au moins 5 caractères.";
    else delete fieldErrors.address;
  }

  if (field === "password") {
    const val = form.password;
    if (!val) fieldErrors.password = "Mot de passe requis.";
    else if (val.length < 8) fieldErrors.password = "Minimum 8 caractères.";
    else if (!/[A-Za-z]/.test(val) || !/\d/.test(val)) {
      fieldErrors.password = "Doit contenir au moins une lettre et un chiffre.";
    } else delete fieldErrors.password;
  }
}

function cleanLocalityName(name: string): string {
  if (!name) return "";
  return name
    .replace(/^(Commune de|Arrondissement de|Ville de|Département de|Région de|Quartier de|District de|Commune d'|Arrondissement d')\s+/gi, "")
    .trim();
}

async function geolocateUser() {
  if (!navigator.geolocation) {
    toast.error("La géolocalisation n'est pas supportée par votre navigateur.");
    return;
  }
  
  geolocating.value = true;
  navigator.geolocation.getCurrentPosition(
    async (position) => {
      const { latitude, longitude } = position.coords;
      try {
        const response = await fetch(
          `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}&zoom=18&addressdetails=1`
        );
        if (!response.ok) throw new Error();
        const data = await response.json();
        
        if (data.address) {
          const addr = data.address;
          
          // Clean and extract neighborhood
          const rawQuartier = addr.suburb || addr.neighbourhood || addr.quarter || addr.village || addr.city_district || addr.county || "";
          form.neighborhood = cleanLocalityName(rawQuartier);
          
          // Build unique precise address parts
          const addressParts = [
            addr.house_number,
            addr.road,
            addr.pedestrian,
            addr.suburb ? cleanLocalityName(addr.suburb) : null,
            addr.neighbourhood ? cleanLocalityName(addr.neighbourhood) : null,
            addr.city_district ? cleanLocalityName(addr.city_district) : null
          ].filter(Boolean);
          
          const uniqueParts = Array.from(new Set(addressParts));
          let resolvedAddress = uniqueParts.join(", ");
          
          if (!resolvedAddress || resolvedAddress.length < 5) {
            resolvedAddress = data.display_name || "";
          }
          form.address = resolvedAddress;
          
          // Determine the city with regional fallbacks for Dakar/Abidjan departments/regions
          let cityVal = addr.city || addr.town || addr.village || addr.municipality || addr.county || addr.state || "";
          const displayName = data.display_name || "";
          const checkStr = (displayName + " " + cityVal).toLowerCase();
          
          if (checkStr.includes("dakar") || checkStr.includes("pikine") || checkStr.includes("guédiawaye") || checkStr.includes("rufisque")) {
            cityVal = "Dakar";
          } else if (checkStr.includes("abidjan") || checkStr.includes("cocody") || checkStr.includes("yopougon") || checkStr.includes("plateau")) {
            cityVal = "Abidjan";
          } else if (checkStr.includes("saint-louis") || checkStr.includes("saint-louis")) {
            cityVal = "Saint-Louis";
          } else if (checkStr.includes("thiès") || checkStr.includes("thies")) {
            cityVal = "Thiès";
          } else if (checkStr.includes("saly") || checkStr.includes("mbour")) {
            cityVal = "Saly";
          } else if (checkStr.includes("ziguinchor")) {
            cityVal = "Ziguinchor";
          } else {
            cityVal = cleanLocalityName(cityVal);
          }
          
          if (cityVal) {
            const matchedCity = cities.value.find(c => c.toLowerCase() === cityVal.toLowerCase());
            if (matchedCity) {
              form.city = matchedCity;
            } else {
              const formattedCity = cityVal.charAt(0).toUpperCase() + cityVal.slice(1);
              cities.value.push(formattedCity);
              form.city = formattedCity;
            }
          }
          
          // Set Geolocated states
          isGeolocated.value = true;
          showManualAddress.value = false;
          
          // Validate immediately
          touched.address = true;
          touched.city = true;
          validateField("address");
          validateField("city");
          
          toast.success("Position détectée ! Adresse pré-remplie.");
        } else {
          toast.error("Impossible de déterminer l'adresse exacte.");
        }
      } catch (err) {
        toast.error("Échec de la récupération de l'adresse depuis votre position.");
      } finally {
        geolocating.value = false;
      }
    },
    (error) => {
      geolocating.value = false;
      if (error.code === error.PERMISSION_DENIED) {
        toast.error("Accès à la position refusé. Veuillez renseigner l'adresse manuellement.");
      } else {
        toast.error("Échec de la géolocalisation. Veuillez renseigner l'adresse manuellement.");
      }
      showManualAddress.value = true;
    },
    { enableHighAccuracy: true, timeout: 8000 }
  );
}

function validateCurrentStep() {
  if (currentStep.value === 1) {
    // Force validation on all fields
    ["salonName", "city", "fullName", "email", "phone", "address", "password"].forEach((f) => {
      touched[f] = true;
      validateField(f);
    });

    if (Object.keys(fieldErrors).length > 0) {
      if (fieldErrors.address || fieldErrors.city) {
        showManualAddress.value = true;
      }
      toast.error("Veuillez corriger les champs en erreur.");
      return false;
    }
  }
  if (currentStep.value === 2 && !form.category) {
    toast.error("Veuillez sélectionner une catégorie.");
    return false;
  }
  if (currentStep.value === 3 && !form.teamSize) {
    toast.error("Veuillez sélectionner la taille de votre équipe.");
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
  
  // Validate Step 4
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
