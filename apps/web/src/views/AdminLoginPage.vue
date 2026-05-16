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
              <label class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest block ml-0.5">Email professionnel</label>
              <div class="relative">
                <EnvelopeIcon class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/30 pointer-events-none" />
                <input
                  v-model="email"
                  class="input-shell bg-neutral-bg/30 border border-outline-variant/60 focus:ring-primary/20 h-11 text-[13px] rounded-md transition-all pl-10"
                  :class="{ 'border-error/50 ring-1 ring-error/20': errors.email }"
                  type="email"
                  autocomplete="username"
                  placeholder="nom@beauteavenue.com"
                />
              </div>
              <p v-if="errors.email" class="text-[10px] font-bold text-error mt-1 uppercase tracking-wider">{{ errors.email }}</p>
            </div>

            <div class="space-y-1.5">
              <label class="text-[10px] font-bold text-cocoa/70 uppercase tracking-widest block ml-0.5">Mot de passe</label>
              <div class="relative">
                <LockClosedIcon class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/30 pointer-events-none" />
                <input
                  v-model="password"
                  class="input-shell bg-neutral-bg/30 border border-outline-variant/60 focus:ring-primary/20 h-11 text-[13px] rounded-md transition-all pl-10"
                  :class="{ 'border-error/50 ring-1 ring-error/20': errors.password }"
                  type="password"
                  autocomplete="current-password"
                  placeholder="••••••••"
                />
              </div>
              <p v-if="errors.password" class="text-[10px] font-bold text-error mt-1 uppercase tracking-wider">{{ errors.password }}</p>
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
        </form>
      </article>

      <footer class="mt-8 text-center">
        <p class="text-[9px] font-bold uppercase tracking-[0.4em] text-cocoa/20">Système d'Exploitation Centralisé • v1.0</p>
      </footer>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { useForm } from "vee-validate";
import { toTypedSchema } from "@vee-validate/zod";
import { z } from "zod";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { EnvelopeIcon, LockClosedIcon } from "@heroicons/vue/24/outline";

import { getErrorMessage } from "@/lib/errors";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();
const route = useRoute();
const router = useRouter();

const loginSchema = toTypedSchema(
  z.object({
    email: z.string().email("Entrez un email valide."),
    password: z.string().min(8, "Le mot de passe doit contenir au moins 8 caractères.")
  })
);

const { errors, defineField, handleSubmit: withFormSubmit, isSubmitting, setFieldError } = useForm({
  validationSchema: loginSchema
});

const [email] = defineField("email");
const [password] = defineField("password");

const showExpiredBanner = computed(() => route.query.expired === "1");

const handleSubmit = withFormSubmit(async (values) => {
  try {
    await auth.login(values.email, values.password);
    toast.success("Connexion admin établie.");
    const redirect = typeof route.query.redirect === "string" ? route.query.redirect : "/admin/dashboard";
    await router.push(redirect);
  } catch (error) {
    const message = getErrorMessage(error, "Connexion impossible pour le moment.");
    setFieldError("password", message);
    toast.error(message);
  }
});
</script>
