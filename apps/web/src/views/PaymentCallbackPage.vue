<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();
const launchAttempted = ref(false);

const bookingId = computed(() => {
  const value = route.query.bookingId;
  return typeof value === "string" ? value.trim() : "";
});
const paymentId = computed(() => {
  const value = route.query.paymentId;
  return typeof value === "string" ? value.trim() : "";
});
const token = computed(() => {
  const value = route.query.token;
  return typeof value === "string" ? value.trim() : "";
});

const canOpenApp = computed(() => bookingId.value.length > 0);
const appCallbackUrl = computed(() => {
  if (!canOpenApp.value) return "";
  const target = new URL("beauteavenue:///payment/callback");
  target.searchParams.set("bookingId", bookingId.value);
  if (paymentId.value) target.searchParams.set("paymentId", paymentId.value);
  if (token.value) target.searchParams.set("token", token.value);
  return target.toString();
});

let fallbackTimer: number | null = null;

function clearFallbackTimer() {
  if (fallbackTimer !== null) {
    window.clearTimeout(fallbackTimer);
    fallbackTimer = null;
  }
}

function openApp() {
  if (!appCallbackUrl.value) return;
  launchAttempted.value = true;
  clearFallbackTimer();
  window.location.href = appCallbackUrl.value;
  fallbackTimer = window.setTimeout(() => {
    launchAttempted.value = false;
  }, 1800);
}

function shouldAutoOpen() {
  if (!canOpenApp.value) return false;
  const ua = navigator.userAgent.toLowerCase();
  return /android|iphone|ipad|ipod/.test(ua);
}

onMounted(() => {
  if (shouldAutoOpen()) {
    openApp();
  }
});

onBeforeUnmount(() => {
  clearFallbackTimer();
});
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-oat/30 px-6">
    <div class="panel-clean max-w-md w-full text-center space-y-4">
      <p class="page-title">Paiement en cours de confirmation</p>
      <p class="row-primary">Votre retour a bien ete pris en compte.</p>
      <p class="row-meta">
        Retournez dans l'application Beauté Avenue pour finaliser la verification de votre acompte.
      </p>
      <div v-if="canOpenApp" class="pt-2 flex flex-col gap-3">
        <button class="btn-primary" type="button" @click="openApp">
          {{ launchAttempted ? "Ouverture de l'application..." : "Ouvrir l'application" }}
        </button>
        <p class="row-meta">
          Si rien ne se passe, revenez dans l'application manuellement puis poursuivez la verification.
        </p>
      </div>
    </div>
  </div>
</template>
