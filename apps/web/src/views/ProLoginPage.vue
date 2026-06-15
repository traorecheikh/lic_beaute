<template>
  <div class="min-h-screen bg-neutral-bg flex flex-col justify-center py-12 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <RouterLink to="/pro">
        <img src="/logo.png" alt="Beauté Avenue" class="h-12 w-auto mx-auto" />
      </RouterLink>
      <h2 class="mt-6 text-center page-title">Accès Professionnel</h2>
      <p class="mt-2 text-center row-meta">
        Gérez votre salon et vos réservations.
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <div class="panel-clean py-8 px-4 sm:px-10">
        <form class="space-y-6" @submit.prevent="handleLogin">
          <div>
            <label for="email" class="section-label mb-2 block">Email ou Téléphone</label>
            <div class="mt-1">
              <input id="email" v-model="email" type="text" name="login_identifier" required class="input-shell" :class="{ 'border-red-400': fieldErrors.email }" placeholder="marie@monsalon.com ou 77 123 45 67" autocomplete="username" />
            </div>
            <p v-if="fieldErrors.email" class="text-[11px] text-error font-medium mt-0.5">{{ fieldErrors.email }}</p>
          </div>

          <div>
            <label for="password" class="section-label mb-2 block">Mot de passe</label>
            <div class="mt-1 relative">
              <input id="password" v-model="password" :type="showPassword ? 'text' : 'password'" name="login_password" required class="input-shell pr-11" :class="{ 'border-red-400': fieldErrors.password }" placeholder="••••••••" autocomplete="current-password" />
              <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-cocoa/50 hover:text-cocoa" :aria-label="showPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe'" @click="showPassword = !showPassword">
                <EyeSlashIcon v-if="showPassword" class="w-5 h-5" />
                <EyeIcon v-else class="w-5 h-5" />
              </button>
            </div>
            <p v-if="fieldErrors.password" class="text-[11px] text-error font-medium mt-0.5">{{ fieldErrors.password }}</p>
          </div>

          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input id="remember-me" type="checkbox" class="h-4 w-4 rounded border-outline-variant text-primary focus:ring-primary/20" />
              <label for="remember-me" class="ml-2 block text-sm text-espresso">Rester connecté</label>
            </div>

            <div class="text-sm">
              <button type="button" @click="forgotEmail = email; showForgotModal = true" class="font-semibold text-primary hover:text-primary/80">Mot de passe oublié ?</button>
            </div>
          </div>

          <div>
            <button type="submit" :disabled="loading" class="btn-primary w-full py-3 flex items-center justify-center gap-2">
              <svg v-if="loading" class="animate-spin w-4 h-4 shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-30" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
                <path class="opacity-80" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              <span>{{ loading ? 'Connexion en cours…' : 'Se connecter' }}</span>
            </button>
          </div>
        </form>

        <div class="mt-6">
          <div class="relative">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-outline-variant"></div>
            </div>
          </div>
        </div>
      </div>

      <p class="mt-10 text-center text-sm text-cocoa/60">
        Pas encore inscrit ?
        <RouterLink to="/pro/register" class="font-bold text-primary hover:text-primary/80">Ouvrez votre salon gratuitement</RouterLink>
      </p>
    </div>

    <!-- Forgot password modal -->
    <Teleport to="body">
      <div v-if="showForgotModal" class="fixed inset-0 z-50 flex items-center justify-center px-4">
        <div class="absolute inset-0 bg-espresso/30 backdrop-blur-sm" @click="showForgotModal = false"></div>
        <div class="relative panel-clean w-full max-w-md p-8 space-y-6">
          <div>
            <h3 class="text-lg font-bold text-espresso">Mot de passe oublié</h3>
            <p class="row-meta mt-1">Entrez votre adresse e-mail professionnelle. Nous vous enverrons un lien de réinitialisation.</p>
          </div>
          <form @submit.prevent="handleForgotPassword" class="space-y-4">
            <div>
              <label for="forgot-email" class="section-label mb-2 block">Adresse e-mail</label>
              <input id="forgot-email" v-model="forgotEmail" type="email" required class="input-shell" placeholder="marie@monsalon.com" />
              <p v-if="forgotError" class="text-[11px] text-error font-medium mt-1">{{ forgotError }}</p>
            </div>
            <div class="flex gap-3 justify-end">
              <button type="button" class="btn-secondary px-4 py-2" @click="showForgotModal = false">Annuler</button>
              <button type="submit" :disabled="forgotLoading" class="btn-primary px-6 py-2 flex items-center gap-2">
                <svg v-if="forgotLoading" class="animate-spin w-4 h-4 shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-30" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
                  <path class="opacity-80" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                </svg>
                <span>{{ forgotLoading ? 'Envoi…' : 'Envoyer le lien' }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from "vue";
import { emailLoginSchema } from "@beauteavenue/contracts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { EyeIcon, EyeSlashIcon } from "@heroicons/vue/24/outline";
import { useProAuthStore } from "@/stores/proAuth";
import { forgotPassword } from "@/lib/pro-api";
import { getErrorMessage } from "@/lib/errors";
import { validateForm } from "@beauteavenue/shared-ts";

const router = useRouter();
const route = useRoute();
const auth = useProAuthStore();

const email = ref("");
const password = ref("");
const showPassword = ref(false);
const loading = ref(false);
const fieldErrors = reactive<Record<string, string>>({});

const showForgotModal = ref(false);
const forgotEmail = ref("");
const forgotLoading = ref(false);
const forgotError = ref("");

function validate(): boolean {
  Object.keys(fieldErrors).forEach((k) => delete fieldErrors[k]);
  // Pro login accepts email OR phone — emailLoginSchema only requires email format.
  // Check if it looks like a phone, skip email validation.
  const isPhone = /^\+?\d{8,15}$/.test(email.value.trim().replace(/[^\d+]/g, ""));
  if (isPhone) {
    if (!email.value.trim()) fieldErrors.email = "Téléphone requis.";
    return Object.keys(fieldErrors).length === 0;
  }
  const result = validateForm(emailLoginSchema, { email: email.value, password: password.value });
  if (!result.success) {
    Object.assign(fieldErrors, result.errors);
    return false;
  }
  return true;
}

async function handleLogin() {
  if (!validate()) return;

  loading.value = true;
  try {
    await auth.login(email.value.trim(), password.value);
    toast.success(`Bienvenue ${auth.currentUser?.fullName ?? ""}`.trim());
    const redirect = typeof route.query.redirect === "string" ? route.query.redirect : "/pro/calendar";
    await router.push(redirect);
  } catch (error) {
    toast.error(getErrorMessage(error, "Connexion impossible pour le moment."));
  } finally {
    loading.value = false;
  }
}

async function handleForgotPassword() {
  forgotError.value = "";
  const trimmed = forgotEmail.value.trim();
  if (!trimmed) { forgotError.value = "Adresse e-mail requise."; return; }

  forgotLoading.value = true;
  try {
    await forgotPassword(trimmed);
    showForgotModal.value = false;
    toast.success("Si un compte existe avec cette adresse, un lien de réinitialisation a été envoyé.");
    forgotEmail.value = "";
  } catch (error) {
    forgotError.value = getErrorMessage(error, "Impossible d'envoyer le lien pour le moment.");
  } finally {
    forgotLoading.value = false;
  }
}

onMounted(async () => {
  if (typeof route.query.email === "string") {
    email.value = route.query.email;
  }

  if (typeof route.query.inviteToken === "string") {
    loading.value = true;
    try {
      await auth.loginWithInviteToken(route.query.inviteToken, route.query.userId as string ?? "");
      toast.success(`Bienvenue ${auth.currentUser?.fullName ?? ""}`.trim());
      await router.push("/pro/calendar");
    } catch (error) {
      toast.error(getErrorMessage(error, "Lien d'invitation invalide ou expiré."));
    } finally {
      loading.value = false;
    }
  }
});
</script>
