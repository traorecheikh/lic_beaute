<script setup lang="ts">
import { onMounted, onUnmounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";

import { ApiError } from "@/lib/api";
import { fetchProSubscriptionChargeStatus } from "@/lib/pro-api";
import { isSuccessfulSubscriptionCharge } from "@/lib/pro-billing";
import { useProAuthStore } from "@/stores/proAuth";

const POLL_INTERVAL_MS = 6_000;
const TIMEOUT_MS = 5 * 60_000;

const route = useRoute();
const router = useRouter();
const auth = useProAuthStore();

const status = ref<"processing" | "success" | "error">("processing");
const errorMessage = ref("");
const timedOut = ref(false);
const manualChecking = ref(false);

const chargeId = route.query.chargeId as string | undefined;

let pollTimer: number | null = null;
let startedAt = 0;
let backgroundChecking = false;

function clearPoll() {
  if (pollTimer !== null) {
    window.clearTimeout(pollTimer);
    pollTimer = null;
  }
}

function schedulePoll() {
  clearPoll();
  pollTimer = window.setTimeout(() => {
    void verifyCharge(false);
  }, POLL_INTERVAL_MS);
}

function redirectToSubscription(delayMs = 5_000) {
  window.setTimeout(() => {
    void router.replace({ name: "pro-subscription" });
  }, delayMs);
}

async function verifyCharge(manual: boolean) {
  if (!chargeId || !auth.accessToken) return;
  if (backgroundChecking || manualChecking.value) return;

  if (manual) {
    manualChecking.value = true;
  } else {
    backgroundChecking = true;
  }

  try {
    const charge = await fetchProSubscriptionChargeStatus(auth.accessToken, chargeId);

    if (isSuccessfulSubscriptionCharge(charge)) {
      clearPoll();
      status.value = "success";
      redirectToSubscription();
      return;
    }

    if (charge.status === "failed" || charge.status === "refunded") {
      clearPoll();
      status.value = "error";
      errorMessage.value = "Le paiement a échoué.";
      redirectToSubscription();
      return;
    }

    if (charge.status === "pending" || charge.status === "authorized") {
      status.value = "processing";
      timedOut.value = Date.now() - startedAt >= TIMEOUT_MS;
      if (!timedOut.value) {
        schedulePoll();
      }
      return;
    }

    clearPoll();
    status.value = "error";
    errorMessage.value = "Statut du paiement inconnu.";
    redirectToSubscription();
  } catch (error) {
    const apiError = error instanceof ApiError ? error : null;
    if (apiError && (apiError.statusCode === 401 || apiError.statusCode === 403 || apiError.statusCode === 404)) {
      clearPoll();
      status.value = "error";
      errorMessage.value = apiError.message || "Impossible de vérifier le statut du paiement.";
      redirectToSubscription();
      return;
    }

    status.value = "processing";
    timedOut.value = Date.now() - startedAt >= TIMEOUT_MS;
    if (!timedOut.value && !manual) {
      schedulePoll();
    }
  } finally {
    backgroundChecking = false;
    if (manual) manualChecking.value = false;
  }
}

function handleWindowFocus() {
  if (status.value === "processing") {
    void verifyCharge(false);
  }
}

function handleVisibilityChange() {
  if (document.visibilityState === "visible" && status.value === "processing") {
    void verifyCharge(false);
  }
}

onMounted(() => {
  if (!chargeId) {
    status.value = "error";
    errorMessage.value = "Référence de paiement manquante.";
    redirectToSubscription();
    return;
  }

  startedAt = Date.now();
  void verifyCharge(false);
  window.addEventListener("focus", handleWindowFocus);
  document.addEventListener("visibilitychange", handleVisibilityChange);
});

onUnmounted(() => {
  clearPoll();
  window.removeEventListener("focus", handleWindowFocus);
  document.removeEventListener("visibilitychange", handleVisibilityChange);
});
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-oat/30 px-6">
    <div class="panel-clean max-w-md w-full text-center space-y-4">
      <template v-if="status === 'processing'">
        <div v-if="!timedOut" class="flex justify-center">
          <svg class="animate-spin h-8 w-8 text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
          </svg>
        </div>
        <p class="row-primary">{{ timedOut ? "En attente de confirmation" : "Traitement du paiement en cours…" }}</p>
        <p class="row-meta">
          {{ timedOut
            ? "Le paiement sera confirmé automatiquement dès que PayDunya nous répond. Vous pouvez retourner dans votre espace abonnement."
            : "Veuillez patienter, nous confirmons votre abonnement avec PayDunya." }}
        </p>
        <div class="flex flex-col gap-3 pt-2">
          <button class="btn-secondary" :disabled="manualChecking" @click="verifyCharge(true)">
            {{ manualChecking ? "Vérification…" : "Vérifier maintenant" }}
          </button>
          <button v-if="timedOut" class="btn-primary" @click="router.replace({ name: 'pro-subscription' })">
            Retourner à l'abonnement
          </button>
        </div>
      </template>
      <template v-else-if="status === 'success'">
        <p class="page-title text-primary">Paiement confirmé !</p>
        <p class="row-primary">Votre abonnement premium est maintenant actif.</p>
        <p class="row-meta">Redirection vers votre espace abonnement…</p>
      </template>
      <template v-else>
        <p class="page-title text-error">Paiement échoué</p>
        <p class="row-primary">{{ errorMessage || "Le paiement n'a pas pu être confirmé." }}</p>
        <p class="row-meta">Redirection vers votre espace abonnement…</p>
      </template>
    </div>
  </div>
</template>
