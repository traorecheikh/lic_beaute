<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useProAuthStore } from "@/stores/proAuth";

const route = useRoute();
const router = useRouter();
const auth = useProAuthStore();

const status = ref<"processing" | "success" | "error">("processing");
const errorMessage = ref("");

onMounted(async () => {
  const chargeId = route.query.chargeId as string | undefined;
  const result = route.query.status as string | undefined;

  if (!chargeId) {
    status.value = "error";
    errorMessage.value = "Référence de paiement manquante.";
    setTimeout(() => router.replace({ name: "pro-subscription" }), 5000);
    return;
  }

  // Verify payment status server-side — do NOT trust URL query params
  try {
    const response = await fetch(`/api/v1/pro/subscription/charge/${chargeId}/status`, {
      headers: { Authorization: `Bearer ${auth.accessToken}` }
    });

    if (!response.ok) {
      const body = await response.json().catch(() => ({}));
      status.value = "error";
      errorMessage.value = body.message ?? "Impossible de vérifier le statut du paiement.";
      setTimeout(() => router.replace({ name: "pro-subscription" }), 5000);
      return;
    }

    const charge = await response.json();

    if (charge.status === "succeeded") {
      status.value = "success";
    } else if (charge.status === "failed") {
      status.value = "error";
      errorMessage.value = "Le paiement a échoué.";
    } else if (charge.status === "pending") {
      status.value = "processing";
      // Poll again after 3 seconds
      setTimeout(() => {
        window.location.reload();
      }, 3000);
      return;
    } else {
      status.value = "error";
      errorMessage.value = "Statut du paiement inconnu.";
    }
  } catch {
    status.value = "processing";
  }

  setTimeout(() => {
    router.replace({ name: "pro-subscription" });
  }, 5000);
});
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-oat/30">
    <div class="panel-clean max-w-md w-full text-center space-y-4">
      <template v-if="status === 'processing'">
        <div class="flex justify-center">
          <svg class="animate-spin h-8 w-8 text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
          </svg>
        </div>
        <p class="row-primary">Traitement du paiement en cours…</p>
        <p class="row-meta">Veuillez patienter, nous confirmons votre abonnement.</p>
      </template>
      <template v-else-if="status === 'success'">
        <p class="page-title text-primary">Paiement confirmé !</p>
        <p class="row-primary">Votre abonnement premium est maintenant actif.</p>
        <p class="row-meta">Redirection vers votre espace abonnement…</p>
      </template>
      <template v-else>
        <p class="page-title text-error">Paiement échoué</p>
        <p class="row-primary">{{ errorMessage || 'Le paiement n\'a pas pu être confirmé.' }}</p>
        <p class="row-meta">Redirection vers votre espace abonnement…</p>
      </template>
    </div>
  </div>
</template>
