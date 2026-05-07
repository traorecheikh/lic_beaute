<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useProAuthStore } from "@/stores/proAuth";

const route = useRoute();
const router = useRouter();
const auth = useProAuthStore();

const status = ref<"processing" | "success" | "error">("processing");

onMounted(async () => {
  const chargeId = route.query.chargeId as string | undefined;
  const result = route.query.status as string | undefined;

  if (result === "success") {
    status.value = "success";
  } else if (result === "error") {
    status.value = "error";
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
        <div class="spinner" />
        <p class="row-primary">Traitement du paiement en cours…</p>
        <p class="row-meta">Veuillez patienter, nous confirmons votre abonnement.</p>
      </template>
      <template v-else-if="status === 'success'">
        <p class="page-title text-green-700">Paiement confirmé !</p>
        <p class="row-primary">Votre abonnement premium est maintenant actif.</p>
        <p class="row-meta">Redirection vers votre espace abonnement…</p>
      </template>
      <template v-else>
        <p class="page-title text-red-700">Paiement échoué</p>
        <p class="row-primary">Le paiement n'a pas pu être confirmé.</p>
        <p class="row-meta">Redirection vers votre espace abonnement…</p>
      </template>
    </div>
  </div>
</template>
