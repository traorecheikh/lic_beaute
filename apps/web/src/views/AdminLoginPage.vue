<template>
  <div class="relative min-h-screen bg-[#FDFDFD] selection:bg-primary/20 flex items-center justify-center px-6 overflow-hidden">
    <!-- Clean, technical background -->
    <div class="absolute inset-0 bg-[radial-gradient(#e5e7eb_1px,transparent_1px)] [background-size:24px_24px] opacity-40"></div>
    
    <section class="relative w-full max-w-[420px]">
      <article class="bg-white rounded-lg border border-outline-variant/60 shadow-2xl shadow-black/[0.05] p-10 relative overflow-hidden">
        <!-- Structural accent -->
        <div class="absolute top-0 left-0 right-0 h-1 bg-primary/40"></div>

        <div class="flex flex-col items-center mb-10 space-y-4">
          <div class="w-12 h-12 flex items-center justify-center bg-primary/10 rounded-lg ring-1 ring-primary/20">
            <img src="/logo.png" alt="Beauté Avenue" class="h-6 w-auto" />
          </div>
          <div class="text-center">
            <h2 class="text-[11px] font-bold uppercase tracking-[0.3em] text-primary">Beauté Avenue</h2>
            <p class="text-[13px] font-medium text-cocoa/60 mt-1">Console Administration</p>
          </div>
        </div>

        <div class="space-y-1 mb-8">
          <h1 class="text-xl font-bold text-espresso tracking-tight">Identification requise</h1>
          <p class="text-[12px] text-cocoa/70 leading-relaxed">
            Utilisez vos identifiants pour accéder au pilotage.
          </p>
        </div>

        <div
          v-if="showExpiredBanner"
          class="mb-6 rounded-md bg-primary/5 border border-primary/10 px-4 py-2 text-[11px] text-primary font-bold uppercase tracking-wider text-center"
        >
          Session expirée. Veuillez vous reconnecter.
        </div>

        <form class="space-y-6" @submit.prevent="handleSubmit">
          <div class="space-y-4">
            <div class="space-y-1.5">
              <label for="admin-email" class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest block ml-0.5">Email professionnel</label>
              <div class="relative">
                <EnvelopeIcon class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/30 pointer-events-none" />
                <input
                  id="admin-email"
                  name="email"
                  v-model="email"
                  class="input-shell bg-neutral-bg/30 border border-outline-variant/60 focus:ring-primary/20 h-11 text-[13px] rounded-md transition-all pl-10"
                  :class="{ 'border-error/50 ring-1 ring-error/20': errors.email }"
                  type="email"
                  autocomplete="username"
                  placeholder="nom@beauteavenue.com"
                  aria-describedby="email-error"
                />
              </div>
              <p v-if="errors.email" id="email-error" class="text-[10px] font-bold text-error mt-1 uppercase tracking-wider">{{ errors.email }}</p>
            </div>

            <div class="space-y-1.5">
              <label for="admin-password" class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest block ml-0.5">Mot de passe</label>
              <div class="relative">
                <LockClosedIcon class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/30 pointer-events-none" />
                <input
                  id="admin-password"
                  name="password"
                  v-model="password"
                  class="input-shell bg-neutral-bg/30 border border-outline-variant/60 focus:ring-primary/20 h-11 text-[13px] rounded-md transition-all pl-10"
                  :class="{ 'border-error/50 ring-1 ring-error/20': errors.password }"
                  type="password"
                  autocomplete="current-password"
                  placeholder="••••••••"
                  aria-describedby="password-error"
                />
              </div>
              <p v-if="errors.password" id="password-error" class="text-[10px] font-bold text-error mt-1 uppercase tracking-wider">{{ errors.password }}</p>
            </div>
          </div>

          <button type="submit" class="btn-primary w-full py-3.5 text-[12px] font-bold uppercase tracking-[0.2em] shadow-lg shadow-primary/10 gap-2" :disabled="isSubmitting">
            <span v-if="!isSubmitting" class="flex items-center justify-center gap-2">
              <LockClosedIcon class="w-3.5 h-3.5" />
              Ouvrir la session
            </span>
            <span v-else class="flex items-center justify-center gap-3">
               <svg class="animate-spin h-3.5 w-3.5" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.932 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
               Traitement...
            </span>
          </button>

          <p class="text-center text-sm mt-4">
            <button type="button" @click="forgotEmail = email; showForgotModal = true" class="font-semibold text-primary hover:text-primary/80">Mot de passe oublié ?</button>
          </p>
        </form>
      </article>

      <!-- Forgot password modal -->
      <Teleport to="body">
        <div v-if="showForgotModal" class="fixed inset-0 z-50 flex items-center justify-center px-4">
          <div class="absolute inset-0 bg-espresso/30 backdrop-blur-sm" @click="showForgotModal = false"></div>
          <div class="relative bg-white rounded-lg border border-outline-variant/60 shadow-2xl w-full max-w-md p-8 space-y-6">
            <div>
              <h3 class="text-lg font-bold text-espresso">Mot de passe oublié</h3>
              <p class="text-[12px] text-cocoa/70 mt-1">Entrez votre adresse e-mail. Nous vous enverrons un lien de réinitialisation.</p>
            </div>
            <form @submit.prevent="handleForgotPassword" class="space-y-4">
              <div>
                <label class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest block ml-0.5 mb-2">Adresse e-mail</label>
                <input v-model="forgotEmail" type="email" required class="input-shell bg-neutral-bg/30 border border-outline-variant/60" placeholder="nom@beauteavenue.com" />
                <p v-if="forgotError" class="text-[10px] font-bold text-error mt-1 uppercase tracking-wider">{{ forgotError }}</p>
              </div>
              <div class="flex gap-3 justify-end">
                <button type="button" class="btn-secondary px-4 py-2 text-[11px] font-bold uppercase tracking-wider" @click="showForgotModal = false">Annuler</button>
                <button type="submit" :disabled="forgotLoading" class="btn-primary px-6 py-2 text-[11px] font-bold uppercase tracking-wider flex items-center gap-2">
                  <svg v-if="forgotLoading" class="animate-spin h-3.5 w-3.5" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                  <span>{{ forgotLoading ? 'Envoi…' : 'Envoyer le lien' }}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </Teleport>

      <footer class="mt-8 text-center">
        <p class="text-[9px] font-bold uppercase tracking-[0.4em] text-cocoa/20">Système d'Exploitation Centralisé • v1.0</p>
      </footer>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { emailLoginSchema } from "@beauteavenue/contracts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { EnvelopeIcon, LockClosedIcon } from "@heroicons/vue/24/outline";

import { getErrorMessage } from "@/lib/errors";
import { useAdminAuthStore } from "@/stores/adminAuth";
import { forgotPassword } from "@/lib/api";
import { validateForm } from "@beauteavenue/shared-ts";

const auth = useAdminAuthStore();
const route = useRoute();
const router = useRouter();

const email = ref("");
const password = ref("");
const isSubmitting = ref(false);
const errors = reactive<Record<string, string>>({});

const showForgotModal = ref(false);
const forgotEmail = ref("");
const forgotLoading = ref(false);
const forgotError = ref("");

const showExpiredBanner = computed(() => route.query.expired === "1");

function validate(): boolean {
  Object.keys(errors).forEach((k) => delete errors[k]);
  const result = validateForm(emailLoginSchema, { email: email.value, password: password.value });
  if (!result.success) {
    Object.assign(errors, result.errors);
    return false;
  }
  return true;
}

async function handleSubmit() {
  if (!validate()) return;
  isSubmitting.value = true;
  try {
    await auth.login(email.value, password.value);
    toast.success("Connexion admin établie.");
    const redirect = typeof route.query.redirect === "string" ? route.query.redirect : "/admin/dashboard";
    await router.push(redirect);
  } catch (error) {
    const message = getErrorMessage(error, "Connexion impossible pour le moment.");
    errors.password = message;
    toast.error(message);
  } finally {
    isSubmitting.value = false;
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
</script>
