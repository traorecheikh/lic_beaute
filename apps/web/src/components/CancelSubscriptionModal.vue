<template>
  <Modal
    :show="show"
    title="Résilier votre abonnement"
    subtitle="Choisissez le motif principal. Un détail optionnel suffit si vous voulez préciser."
    max-width="xl"
    @close="$emit('close')"
  >
    <!-- Step 1: Pick reason -->
    <template v-if="step === 'reason'">
      <div class="space-y-5">
        <div class="flex items-start justify-between gap-4">
          <div>
            <p id="cancel-reason-label" class="section-label mb-2">Motif principal <span class="text-red-400" aria-hidden="true">*</span></p>
            <p class="row-meta max-w-xl">Une sélection rapide suffit. Vous pourrez confirmer juste après.</p>
          </div>
          <p v-if="selectedReason" class="hidden sm:block section-label text-right">1 sélection</p>
        </div>

        <div role="radiogroup" aria-labelledby="cancel-reason-label" class="grid grid-cols-1 gap-3 sm:grid-cols-2">
          <button
            v-for="opt in reasonOptions"
            :key="opt.value"
            type="button"
            role="radio"
            :aria-checked="selectedReason === opt.value"
            :aria-label="`${opt.label} — ${opt.hint}`"
            @click="selectedReason = opt.value"
            class="w-full rounded-[1.35rem] border px-4 py-3 text-left transition-all duration-150"
            :class="selectedReason === opt.value ? 'border-primary bg-primary/5 shadow-[0_0_0_1px_rgba(215,102,143,0.18)]' : 'border-outline-variant/60 hover:border-cocoa/35 hover:bg-neutral-bg/40'"
          >
            <div class="flex items-start gap-3">
              <div
                class="mt-0.5 flex h-10 w-10 shrink-0 items-center justify-center rounded-2xl border"
                :class="selectedReason === opt.value ? 'border-primary/30 bg-primary/10 text-primary' : 'border-outline-variant/60 bg-neutral-bg/70 text-cocoa/70'"
              >
                <component :is="opt.icon" class="h-5 w-5" aria-hidden="true" />
              </div>
              <div class="min-w-0 flex-1">
                <p class="row-primary leading-snug">{{ opt.label }}</p>
                <p class="row-meta mt-1 leading-snug">{{ opt.hint }}</p>
              </div>
              <CheckCircleIcon
                v-if="selectedReason === opt.value"
                class="mt-0.5 h-5 w-5 shrink-0 text-primary"
                aria-hidden="true"
              />
            </div>
          </button>
        </div>

        <div class="rounded-[1.35rem] border border-outline-variant/50 bg-neutral-bg/35 p-4">
          <label for="cancel-additional-info" class="section-label mb-2 block">Ajouter un détail (optionnel)</label>
          <textarea
            id="cancel-additional-info"
            v-model="additionalInfo"
            class="input-shell min-h-[84px] resize-none bg-white"
            placeholder="Exemple: trop d’erreurs sur les paiements ou il manque la gestion d’équipe."
            maxlength="500"
          ></textarea>
          <div class="mt-2 flex items-center justify-between gap-3">
            <p class="row-meta">Court et direct. Pas besoin d’un long message.</p>
            <p
              aria-live="polite"
              class="row-meta whitespace-nowrap"
              :class="{ 'text-red-500 font-semibold': additionalInfo.length >= 450 }"
            >
              {{ additionalInfo.length }}/500
            </p>
          </div>
        </div>
      </div>
    </template>

    <!-- Step 2: Retention offer -->
    <template v-if="step === 'retention' && retentionOffer">
      <div aria-live="polite" class="rounded-3xl bg-gradient-to-br from-primary/10 to-secondary/10 border border-primary/20 p-6 text-center space-y-4">
        <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-white/80 text-primary shadow-sm shadow-primary/10" aria-hidden="true">
          <ShieldCheckIcon class="h-7 w-7" />
        </div>
        <h4 class="row-primary text-base sm:text-lg">{{ retentionOffer.title }}</h4>
        <p class="row-meta mx-auto max-w-xl leading-relaxed">{{ retentionOffer.description }}</p>
        <div class="flex flex-col sm:flex-row gap-3 justify-center pt-2">
          <button @click="$emit('accept')" class="btn-primary !py-3 text-sm flex items-center justify-center gap-2">
            <CheckCircleIcon class="w-5 h-5" aria-hidden="true" />
            Accepter — Je reste !
          </button>
          <button @click="$emit('confirm')" class="btn-secondary !py-3 text-sm">Résilier quand même</button>
        </div>
      </div>
      <p class="text-xs text-cocoa/50 text-center mt-3">Cette offre est unique et ne sera plus disponible après confirmation.</p>
    </template>

    <!-- Step 3: Confirmation before final cancel -->
    <template v-if="step === 'confirm'">
      <div aria-live="assertive" class="rounded-3xl bg-red-50 border border-red-100 p-6 text-center space-y-4">
        <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-white text-red-500 shadow-sm shadow-red-100" aria-hidden="true">
          <ExclamationTriangleIcon class="h-7 w-7" />
        </div>
        <h4 class="row-primary text-base sm:text-lg">Confirmer la résiliation</h4>
        <p class="row-meta leading-relaxed">
          Vous êtes sur le point de résilier votre abonnement. Vos services seront suspendus et votre salon ne sera plus visible sur la marketplace.
        </p>
        <div class="flex flex-col sm:flex-row gap-3 justify-center pt-2">
          <button @click="$emit('confirm')" class="btn-primary !bg-red-500 !border-red-500 !py-3 text-sm">Oui, résilier</button>
          <button @click="$emit('back')" class="btn-secondary !py-3 text-sm">Retour au motif</button>
        </div>
      </div>
    </template>

    <template #footer>
      <div v-if="step === 'reason'" class="flex items-center justify-end gap-2">
        <button type="button" class="btn-secondary text-xs" @click="$emit('close')">Annuler</button>
        <button
          type="button"
          class="btn-primary text-xs"
          :disabled="!selectedReason"
          :aria-disabled="!selectedReason"
          :title="selectedReason ? undefined : 'Sélectionnez un motif pour continuer'"
          @click="$emit('submit', { reason: selectedReason, additionalInfo })"
        >
          Continuer
        </button>
      </div>
    </template>
  </Modal>
</template>

<script setup lang="ts">
import { ref } from "vue";
import {
  BanknotesIcon,
  CheckCircleIcon,
  CreditCardIcon,
  ExclamationTriangleIcon,
  LifebuoyIcon,
  LockClosedIcon,
  PencilSquareIcon,
  RocketLaunchIcon,
  ShieldCheckIcon,
  SparklesIcon,
  WrenchScrewdriverIcon,
  XCircleIcon
} from "@heroicons/vue/24/outline";
import Modal from "@/components/Modal.vue";

defineProps<{
  show: boolean;
  step: "reason" | "retention" | "confirm";
  retentionOffer: { title: string; description: string } | null;
}>();

defineEmits<{
  close: [];
  back: [];
  submit: [payload: { reason: string; additionalInfo: string }];
  accept: [];
  confirm: [];
}>();

const selectedReason = ref("");
const additionalInfo = ref("");

const reasonOptions = [
  { value: "too_expensive", icon: BanknotesIcon, label: "Trop cher", hint: "Le budget ne suit pas" },
  { value: "missing_features", icon: WrenchScrewdriverIcon, label: "Fonctionnalités manquantes", hint: "Il manque des outils utiles" },
  { value: "low_traffic", icon: SparklesIcon, label: "Pas assez de visibilité", hint: "Je reçois trop peu de clients" },
  { value: "technical_issues", icon: XCircleIcon, label: "Problèmes techniques", hint: "L'application bugue ou freine mon équipe" },
  { value: "poor_support", icon: LifebuoyIcon, label: "Support insatisfaisant", hint: "Je n'ai pas eu l'aide attendue" },
  { value: "seasonal_closure", icon: ShieldCheckIcon, label: "Fermeture saisonnière", hint: "Je ferme temporairement" },
  { value: "switching_competitor", icon: RocketLaunchIcon, label: "Je vais chez un concurrent", hint: "Une autre solution me tente" },
  { value: "business_closure", icon: LockClosedIcon, label: "Fermeture définitive", hint: "J'arrête mon activité" },
  { value: "payment_issues", icon: CreditCardIcon, label: "Problèmes de paiement", hint: "Difficultés avec PayDunya" },
  { value: "other", icon: PencilSquareIcon, label: "Autre", hint: "Une autre raison" }
];
</script>
