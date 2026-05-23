<template>
  <div class="min-h-screen bg-neutral-bg flex flex-col justify-center py-12 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <RouterLink to="/pro">
        <img src="/logo.png" alt="Beauté Avenue" class="h-12 w-auto mx-auto" />
      </RouterLink>
      <h2 class="mt-6 text-center page-title">Connexion rapide</h2>
      <p class="mt-2 text-center row-meta">
        Connexion automatique à votre espace professionnel.
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <div class="panel-clean py-8 px-4 sm:px-10">
        <!-- Loading state -->
        <div v-if="loading" class="text-center space-y-4 py-8">
          <svg class="animate-spin w-8 h-8 mx-auto text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-30" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" />
            <path class="opacity-80" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
          </svg>
          <p class="text-sm text-cocoa/80">Connexion en cours…</p>
        </div>

        <!-- Success state (brief flash before redirect) -->
        <div v-else-if="success" class="text-center space-y-4 py-8">
          <div class="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mx-auto">
            <svg class="w-8 h-8 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <p class="text-sm font-semibold text-espresso">Connexion réussie ! Redirection…</p>
        </div>

        <!-- Invalid / expired link state -->
        <div v-else class="text-center space-y-4 py-8">
          <div class="w-16 h-16 rounded-full bg-error/10 flex items-center justify-center mx-auto">
            <svg class="w-8 h-8 text-error" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4.5c-.77-.833-2.694-.833-3.464 0L3.34 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
          <p class="row-primary text-error">Ce lien de connexion est invalide ou a expiré.</p>
          <p class="row-meta">Les liens sont valables 24h. Contactez l'administrateur pour en obtenir un nouveau.</p>
          <RouterLink to="/pro/login" class="btn-secondary px-6 py-2.5 inline-block mt-2">Aller à la connexion</RouterLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { useProAuthStore } from "@/stores/proAuth";

const route = useRoute();
const router = useRouter();
const proAuth = useProAuthStore();

const loading = ref(false);
const success = ref(false);

onMounted(async () => {
  const token = route.query.token;
  const email = route.query.email;

  if (typeof token !== "string" || !token || typeof email !== "string" || !email) {
    return; // Shows invalid state
  }

  loading.value = true;
  try {
    await proAuth.loginWithMagicToken(token, decodeURIComponent(email));
    success.value = true;
    toast.success("Connexion réussie !");
    await router.push("/pro/calendar");
  } catch {
    // Shows invalid state
  } finally {
    loading.value = false;
  }
});
</script>
