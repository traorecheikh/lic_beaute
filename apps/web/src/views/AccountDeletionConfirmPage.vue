<script setup lang="ts">
import { ref, computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import { TrashIcon, ArrowLeftIcon, ExclamationTriangleIcon } from "@heroicons/vue/24/outline";
import { legalConfig } from "@beauteavenue/shared-ts";
import { confirmAccountDeletion } from "@/lib/api";

const route = useRoute();
const router = useRouter();
const token = computed(() => (route.query.token as string) ?? "");
const email = computed(() => (route.query.email as string) ?? "");

const reasons = ref<string[]>([]);
const otherFeedback = ref("");
const loading = ref(false);
const error = ref("");
const deleted = ref(false);
const showConfirm = ref(false);

const reasonOptions = [
  { value: "no_longer_use", label: "Je n'utilise plus l'application" },
  { value: "too_expensive", label: "Je trouve les prix trop élevés" },
  { value: "prefer_other", label: "Je préfère un autre service" },
  { value: "other", label: "Autre" },
];

function toggleReason(value: string) {
  if (reasons.value.includes(value)) {
    reasons.value = reasons.value.filter((r) => r !== value);
  } else {
    reasons.value = [...reasons.value, value];
  }
}

async function confirmDelete() {
  showConfirm.value = false;
  loading.value = true;
  error.value = "";
  try {
    await confirmAccountDeletion(token.value, email.value, reasons.value, otherFeedback.value);
    deleted.value = true;
  } catch (e: any) {
    const data = e?.response?.data;
    if (data?.code === "invalid_token") {
      error.value = "Ce lien est invalide ou a déjà été utilisé.";
    } else if (data?.code === "token_expired") {
      error.value = "Ce lien a expiré. Veuillez refaire une demande.";
    } else if (data?.code === "user_not_found") {
      error.value = "Compte introuvable.";
    } else {
      error.value = "Une erreur est survenue. Veuillez réessayer.";
    }
  } finally {
    loading.value = false;
  }
}
</script>

<template>
  <div class="min-h-screen bg-neutral-bg text-espresso font-sans antialiased flex flex-col">
    <!-- Navigation -->
    <nav class="sticky top-0 z-50 h-20 flex items-center bg-white/95 backdrop-blur-md border-b border-outline-variant/40">
      <div class="max-w-2xl mx-auto w-full px-4 sm:px-8 flex items-center justify-between">
        <button class="flex items-center gap-2 text-sm font-medium text-cocoa/60 hover:text-espresso transition-colors" @click="router.push('/')">
          <ArrowLeftIcon class="w-4 h-4" />
          <span>Retour</span>
        </button>
        <span class="font-sans text-[15px] font-semibold tracking-tight text-espresso">{{ legalConfig.appName }}</span>
      </div>
    </nav>

    <main class="flex-1 flex items-center justify-center px-4 py-16">
      <div class="w-full max-w-lg">
        <!-- Success state -->
        <div v-if="deleted" class="panel-clean p-8 sm:p-10 text-center space-y-4">
          <div class="w-14 h-14 rounded-full bg-red-100 flex items-center justify-center mx-auto">
            <TrashIcon class="w-7 h-7 text-red-600" />
          </div>
          <h1 class="text-xl font-display font-bold text-espresso">Compte supprimé</h1>
          <p class="text-sm text-cocoa/70 leading-relaxed">
            Votre compte Beauté Avenue a bien été supprimé. Toutes vos données personnelles ont été effacées.
          </p>
          <p class="text-xs text-cocoa/50">L'historique de vos réservations est conservé de manière anonymisée.</p>
          <button class="btn-secondary mt-4" @click="router.push('/')">Retour à l'accueil</button>
        </div>

        <!-- Confirmation form -->
        <div v-else class="panel-clean p-8 sm:p-10 space-y-6">
          <div class="text-center space-y-2">
            <div class="w-12 h-12 rounded-full bg-red-50 flex items-center justify-center mx-auto">
              <ExclamationTriangleIcon class="w-6 h-6 text-red-500" />
            </div>
            <h1 class="text-xl font-display font-bold text-espresso">Supprimer mon compte</h1>
            <p class="text-sm text-cocoa/60">
              Compte : <strong class="text-espresso">{{ email }}</strong>
            </p>
            <p class="text-xs text-cocoa/40">Cette action est irréversible.</p>
          </div>

          <!-- Reasons -->
          <div class="space-y-3">
            <p class="section-label block">Dites-nous pourquoi vous partez (facultatif)</p>
            <label
              v-for="opt in reasonOptions"
              :key="opt.value"
              class="flex items-start gap-3 p-3 rounded-lg border cursor-pointer transition-colors"
              :class="reasons.includes(opt.value) ? 'border-primary bg-primary/5' : 'border-outline-variant/60 hover:border-cocoa/30'"
            >
              <input
                type="checkbox"
                :checked="reasons.includes(opt.value)"
                class="mt-0.5 accent-primary"
                @change="toggleReason(opt.value)"
              />
              <span class="text-sm text-cocoa/80">{{ opt.label }}</span>
            </label>
            <textarea
              v-if="reasons.includes('other')"
              v-model="otherFeedback"
              placeholder="Dites-nous en plus…"
              class="input-shell mt-1 min-h-[80px] resize-none"
              maxlength="500"
            />
          </div>

          <p v-if="error" class="text-xs text-red-500 text-center">{{ error }}</p>

          <!-- Delete button -->
          <button
            class="w-full py-3 rounded-xl font-semibold text-sm text-white transition-colors flex items-center justify-center gap-2"
            :class="loading ? 'bg-red-300 cursor-not-allowed' : 'bg-red-600 hover:bg-red-700'"
            :disabled="loading"
            @click="showConfirm = true"
          >
            <TrashIcon v-if="!loading" class="w-4 h-4" />
            {{ loading ? "Suppression en cours…" : "Supprimer définitivement mon compte" }}
          </button>
        </div>
      </div>
    </main>

    <!-- Confirmation dialog -->
    <Teleport to="body">
      <div
        v-if="showConfirm"
        class="fixed inset-0 z-[100] flex items-center justify-center bg-black/40 px-4"
        @click.self="showConfirm = false"
      >
        <div class="bg-white rounded-2xl shadow-xl max-w-sm w-full p-6 space-y-4">
          <div class="text-center space-y-2">
            <div class="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center mx-auto">
              <ExclamationTriangleIcon class="w-5 h-5 text-red-600" />
            </div>
            <h2 class="text-lg font-bold text-espresso">Êtes-vous sûr ?</h2>
            <p class="text-sm text-cocoa/60">
              Cette action est irréversible. Toutes vos données personnelles seront définitivement supprimées.
            </p>
          </div>
          <div class="flex gap-3">
            <button class="flex-1 py-2.5 rounded-xl text-sm font-semibold border border-outline-variant/60 text-cocoa/80 hover:bg-neutral-bg transition-colors" @click="showConfirm = false">Annuler</button>
            <button class="flex-1 py-2.5 rounded-xl text-sm font-semibold bg-red-600 text-white hover:bg-red-700 transition-colors" @click="confirmDelete">Oui, supprimer</button>
          </div>
        </div>
      </div>
    </Teleport>

    <footer class="text-center py-8 text-[11px] text-cocoa/30 font-medium">
      <p>{{ legalConfig.appName }} — Plateforme exploitée par {{ legalConfig.operatorName }}</p>
    </footer>
  </div>
</template>
