<template>
  <div class="min-h-screen bg-neutral-bg flex flex-col justify-center py-12 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <RouterLink to="/pro">
        <img src="/logo.png" alt="Beauté Avenue" class="h-12 w-auto mx-auto" />
      </RouterLink>
      <h2 class="mt-6 text-center text-3xl font-display text-espresso">Accès Professionnel</h2>
      <p class="mt-2 text-center text-sm text-cocoa/60">
        Gérez votre salon et vos réservations.
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <div class="panel-clean py-8 px-4 sm:px-10">
        <form class="space-y-6" @submit.prevent="handleLogin">
          <div>
            <label for="email" class="section-label mb-2 block">Email ou Téléphone</label>
            <div class="mt-1">
              <input id="email" v-model="email" type="text" required class="input-shell" placeholder="marie@monsalon.com" />
            </div>
          </div>

          <div>
            <label for="password" class="section-label mb-2 block">Mot de passe</label>
            <div class="mt-1">
              <input id="password" v-model="password" type="password" required class="input-shell" placeholder="••••••••" />
            </div>
          </div>

          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input id="remember-me" type="checkbox" class="h-4 w-4 rounded border-outline-variant text-primary focus:ring-primary/20" />
              <label for="remember-me" class="ml-2 block text-sm text-espresso">Rester connecté</label>
            </div>

            <div class="text-sm">
              <a href="#" class="font-semibold text-primary hover:text-primary/80">Mot de passe oublié ?</a>
            </div>
          </div>

          <div>
            <button type="submit" :disabled="loading" class="btn-primary w-full py-3">
              {{ loading ? 'Connexion...' : 'Se connecter' }}
            </button>
          </div>
        </form>

        <div class="mt-6">
          <div class="relative">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-outline-variant"></div>
            </div>
            <div class="relative flex justify-center text-sm">
              <span class="bg-surface px-2 text-cocoa/40 italic">Ou continuer avec</span>
            </div>
          </div>

          <div class="mt-6">
            <button @click="loginWithOTP" class="btn-secondary w-full py-3 ring-0 border">
              Code OTP par SMS
            </button>
          </div>
        </div>
      </div>

      <p class="mt-10 text-center text-sm text-cocoa/60">
        Pas encore inscrit ?
        <RouterLink to="/pro/register" class="font-bold text-primary hover:text-primary/80">Ouvrez votre salon gratuitement</RouterLink>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { useProAuthStore } from "@/stores/proAuth";

const router = useRouter();
const auth = useProAuthStore();

const email = ref("");
const password = ref("");
const loading = ref(false);

async function handleLogin() {
  loading.value = true;
  // Mock login
  setTimeout(async () => {
    loading.value = false;
    await auth.login("salon_owner");
    toast.success("Bienvenue Marie !");
    router.push("/pro/calendar");
  }, 1000);
}

function loginWithOTP() {
  toast.info("Le login par OTP n'est pas encore disponible dans cette démo.");
}
</script>
