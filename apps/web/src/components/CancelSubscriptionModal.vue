<template>
  <Modal
    :show="show"
    title="Résilier votre abonnement"
    subtitle="Nous sommes tristes de vous voir partir. Dites-nous pourquoi pour qu'on puisse vous aider."
    max-width="lg"
    @close="$emit('close')"
  >
    <!-- Step 1: Pick reason -->
    <template v-if="step === 'reason'">
      <div class="space-y-3">
        <p class="section-label mb-1">Motif de résiliation</p>
        <button
          v-for="opt in reasonOptions"
          :key="opt.value"
          type="button"
          @click="selectedReason = opt.value"
          class="w-full flex items-center gap-3 p-4 rounded-2xl border text-left transition-all"
          :class="selectedReason === opt.value ? 'border-primary bg-primary/5 ring-2 ring-primary' : 'border-outline-variant/60 hover:border-cocoa/40'"
        >
          <span class="text-lg">{{ opt.emoji }}</span>
          <div>
            <p class="text-sm font-semibold text-espresso">{{ opt.label }}</p>
            <p class="text-xs text-cocoa/50">{{ opt.hint }}</p>
          </div>
        </button>
      </div>

      <div>
        <label class="section-label mb-1 block">Dites-nous en plus (optionnel)</label>
        <textarea
          v-model="additionalInfo"
          class="input-shell min-h-[100px] resize-none"
          placeholder="Partagez-nous plus de détails pour nous aider à nous améliorer..."
          maxlength="500"
        ></textarea>
        <p class="text-xs text-cocoa/40 text-right mt-1">{{ additionalInfo.length }}/500</p>
      </div>
    </template>

    <!-- Step 2: Retention offer -->
    <template v-if="step === 'retention' && retentionOffer">
      <div class="rounded-3xl bg-gradient-to-br from-primary/5 to-secondary/5 border border-primary/20 p-6 text-center space-y-4">
        <div class="text-4xl">🎯</div>
        <h4 class="text-lg font-bold text-espresso">{{ retentionOffer.title }}</h4>
        <p class="text-sm text-cocoa/70 leading-relaxed">{{ retentionOffer.description }}</p>
        <div class="flex flex-col sm:flex-row gap-3 justify-center pt-2">
          <button @click="$emit('accept')" class="btn-primary !py-3 text-sm flex items-center justify-center gap-2">
            <CheckCircleIcon class="w-5 h-5" />
            Accepter — Je reste !
          </button>
          <button @click="$emit('confirm')" class="btn-secondary !py-3 text-sm">
            Résilier quand même
          </button>
        </div>
      </div>
      <p class="text-xs text-cocoa/30 text-center mt-3">Cette offre est unique et ne sera plus disponible après confirmation.</p>
    </template>

    <!-- Step 3: Confirmation before final cancel -->
    <template v-if="step === 'confirm'">
      <div class="rounded-3xl bg-red-50 border border-red-100 p-6 text-center space-y-4">
        <div class="text-4xl">😔</div>
        <h4 class="text-lg font-bold text-espresso">Confirmer la résiliation</h4>
        <p class="text-sm text-cocoa/70 leading-relaxed">
          Vous êtes sur le point de résilier votre abonnement. Vos services seront suspendus et votre salon ne sera plus visible sur la marketplace.
        </p>
        <div class="flex flex-col sm:flex-row gap-3 justify-center pt-2">
          <button @click="$emit('confirm')" class="btn-primary !bg-red-500 !border-red-500 !py-3 text-sm">
            Oui, résilier
          </button>
          <button @click="step = 'reason'" class="btn-secondary !py-3 text-sm">
            Retour
          </button>
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
import { CheckCircleIcon } from "@heroicons/vue/24/outline";
import Modal from "@/components/Modal.vue";

defineProps<{
  show: boolean;
  step: "reason" | "retention" | "confirm";
  retentionOffer: { title: string; description: string } | null;
}>();

defineEmits<{
  close: [];
  submit: [payload: { reason: string; additionalInfo: string }];
  accept: [];
  confirm: [];
}>();

const selectedReason = ref("");
const additionalInfo = ref("");

const reasonOptions = [
  { value: "too_expensive", emoji: "💰", label: "Trop cher", hint: "Le budget ne suit pas" },
  { value: "missing_features", emoji: "🔧", label: "Fonctionnalités manquantes", hint: "Il me manque des outils" },
  { value: "low_traffic", emoji: "📉", label: "Pas assez de visibilité", hint: "Je ne reçois pas assez de clients" },
  { value: "technical_issues", emoji: "⚡", label: "Problèmes techniques", hint: "L'application plante ou bugue" },
  { value: "poor_support", emoji: "🤷", label: "Support insatisfaisant", hint: "Je n'ai pas eu l'aide attendue" },
  { value: "seasonal_closure", emoji: "🏖️", label: "Fermeture saisonnière", hint: "Je ferme temporairement" },
  { value: "switching_competitor", emoji: "🏃", label: "Je vais chez un concurrent", hint: "Une autre solution me tente" },
  { value: "business_closure", emoji: "🔒", label: "Fermeture définitive du salon", hint: "J'arrête mon activité" },
  { value: "payment_issues", emoji: "💳", label: "Problèmes de paiement", hint: "Difficultés avec PayDunya" },
  { value: "other", emoji: "✍️", label: "Autre", hint: "Une autre raison" }
];
</script>
