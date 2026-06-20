<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import { EnvelopeIcon, ArrowLeftIcon } from "@heroicons/vue/24/outline";
import { legalConfig } from "@beauteavenue/shared-ts";
import { requestAccountDeletion } from "@/lib/api";

const router = useRouter();
const email = ref("");
const submitted = ref(false);
const loading = ref(false);
const error = ref("");
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

async function submitRequest() {
  if (!email.value.trim() || !emailRegex.test(email.value.trim())) {
    error.value = "Veuillez entrer une adresse e-mail valide.";
    return;
  }
  loading.value = true;
  error.value = "";
  try {
    await requestAccountDeletion(email.value.trim());
    submitted.value = true;
  } catch (e: any) {
    const data = e?.response?.data;
    if (data?.code === "user_not_found") {
      error.value = "Aucun compte trouvé avec cette adresse e-mail.";
    } else if (data?.code === "forbidden") {
      error.value = "Seuls les comptes clients peuvent être supprimés ici. Contactez le support.";
    } else if (data?.code === "rate_limited") {
      error.value = "Trop de tentatives. Réessayez plus tard.";
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
        <div v-if="submitted" class="panel-clean p-8 sm:p-10 text-center space-y-4">
          <div class="w-14 h-14 rounded-full bg-green-100 flex items-center justify-center mx-auto">
            <EnvelopeIcon class="w-7 h-7 text-green-600" />
          </div>
          <h1 class="text-xl font-display font-bold text-espresso">Email envoyé !</h1>
          <p class="text-sm text-cocoa/70 leading-relaxed">
            Un email de confirmation vient d'être envoyé à <strong class="text-espresso">{{ email }}</strong>.
            Cliquez sur le lien qu'il contient pour confirmer la suppression définitive de votre compte.
          </p>
          <p class="text-xs text-cocoa/50">Le lien est valable 24 heures. Si vous ne recevez rien, vérifiez vos spams.</p>
          <button class="btn-secondary mt-4" @click="submitted = false; email = ''">Envoyer à une autre adresse</button>
        </div>

        <!-- Form -->
        <div v-else class="panel-clean p-8 sm:p-10 space-y-6">
          <div class="text-center space-y-2">
            <h1 class="text-xl font-display font-bold text-espresso">Supprimer mon compte</h1>
            <p class="text-sm text-cocoa/60">
              Saisissez l'adresse e-mail associée à votre compte. Vous recevrez un lien de confirmation.
            </p>
          </div>

          <form @submit.prevent="submitRequest" class="space-y-4">
            <div>
              <label for="deletion-email" class="section-label block mb-1.5">Adresse e-mail</label>
              <input
                id="deletion-email"
                v-model="email"
                type="email"
                autocomplete="email"
                placeholder="exemple@email.com"
                class="input-shell"
                :class="{ 'border-red-400': error }"
                required
              />
              <p v-if="error" class="text-xs text-red-500 mt-1.5">{{ error }}</p>
            </div>

            <button type="submit" class="btn-primary w-full justify-center" :disabled="loading">
              {{ loading ? "Envoi en cours…" : "Envoyer le lien de confirmation" }}
            </button>
          </form>

          <p class="text-xs text-cocoa/40 text-center leading-relaxed">
            Cette action est irréversible. Toutes vos données personnelles seront supprimées.
            L'historique des réservations sera conservé de manière anonymisée.
          </p>
        </div>
      </div>
    </main>

    <footer class="text-center py-8 text-[11px] text-cocoa/30 font-medium">
      <p>{{ legalConfig.appName }} — Plateforme exploitée par {{ legalConfig.operatorName }}</p>
    </footer>
  </div>
</template>
