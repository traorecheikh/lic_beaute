<template>
  <div class="min-h-screen bg-neutral-bg flex flex-col justify-center py-12 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <RouterLink to="/pro">
        <img src="/logo.png" alt="Beauté Avenue" class="h-12 w-auto mx-auto" />
      </RouterLink>
      <h2 class="mt-6 text-center page-title">Activez votre compte</h2>
      <p class="mt-2 text-center row-meta">
        Définissez votre mot de passe pour accéder à votre espace professionnel.
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <div class="panel-clean py-8 px-4 sm:px-10">

        <!-- Invalid / expired link state -->
        <div v-if="linkInvalid" class="text-center space-y-4">
          <p class="row-primary text-error">Ce lien d'activation est invalide ou a expiré.</p>
          <p class="row-meta">Les liens sont valables 72h. Contactez l'administrateur pour en obtenir un nouveau.</p>
          <RouterLink to="/pro/login" class="btn-secondary px-6 py-2.5 inline-block mt-2">Retour à la connexion</RouterLink>
        </div>

        <form v-else class="space-y-6" @submit.prevent="handleSetup">
          <div>
            <label class="section-label mb-2 block">Email</label>
            <input :value="email" type="email" disabled class="input-shell opacity-60 cursor-not-allowed" />
          </div>

          <div>
            <label for="password" class="section-label mb-2 block">Nouveau mot de passe <span class="text-primary">*</span></label>
            <input
              id="password"
              v-model="password"
              type="password"
              required
              minlength="8"
              class="input-shell"
              placeholder="Au moins 8 caractères"
              autocomplete="new-password"
            />
          </div>

          <div>
            <label for="confirm" class="section-label mb-2 block">Confirmer le mot de passe <span class="text-primary">*</span></label>
            <input
              id="confirm"
              v-model="confirm"
              type="password"
              required
              minlength="8"
              class="input-shell"
              placeholder="••••••••"
              autocomplete="new-password"
            />
          </div>

          <p v-if="errorMsg" class="row-meta text-error">{{ errorMsg }}</p>

          <button type="submit" :disabled="loading" class="btn-primary w-full py-3 flex items-center justify-center gap-2">
            <svg v-if="loading" class="animate-spin w-4 h-4 shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-30" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
              <path class="opacity-80" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
            </svg>
            <span>{{ loading ? 'Activation en cours…' : 'Activer mon compte' }}</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { setupAccountInputSchema } from "@beauteavenue/contracts";
import { validateForm } from "@beauteavenue/shared-ts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { useProAuthStore } from "@/stores/proAuth";

const route = useRoute();
const router = useRouter();
const proAuth = useProAuthStore();

const token = ref("");
const email = ref("");
const password = ref("");
const confirm = ref("");
const loading = ref(false);
const errorMsg = ref("");
const linkInvalid = ref(false);

onMounted(() => {
  const t = route.query.token;
  const e = route.query.email;
  if (typeof t !== "string" || !t || typeof e !== "string" || !e) {
    linkInvalid.value = true;
    return;
  }
  token.value = t;
  email.value = decodeURIComponent(e);
});

async function handleSetup() {
  errorMsg.value = "";
  const result = validateForm(setupAccountInputSchema, {
    token: token.value, email: email.value, password: password.value, confirm: confirm.value
  });
  if (!result.success) {
    const firstError = Object.values(result.errors)[0];
    errorMsg.value = firstError ?? result.formError ?? "Vérifiez les champs.";
    return;
  }
  loading.value = true;
  try {
    await proAuth.loginWithSetupToken(token.value, email.value, password.value);
    toast.success("Compte activé ! Bienvenue sur Beauté Avenue.");
    await router.push("/pro/calendar");
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : "Lien invalide ou expiré.";
    if (msg.includes("expiré") || msg.includes("invalide") || msg.includes("introuvable")) {
      linkInvalid.value = true;
    } else {
      errorMsg.value = msg;
    }
  } finally {
    loading.value = false;
  }
}
</script>
