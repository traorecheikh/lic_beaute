<template>
  <div class="max-w-4xl mx-auto space-y-6 pb-20">
    <!-- Header -->
    <div class="flex items-center gap-4 mb-8">
      <button @click="$router.back()" class="p-2 hover:bg-white rounded-full transition">
        <ArrowLeftIcon class="w-6 h-6 text-espresso" />
      </button>
      <div>
        <h1 class="page-title mb-1">Encaissement</h1>
        <p class="row-meta">Finalisez la transaction pour le rendez-vous de {{ booking?.clientName }}</p>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Left Column: Items & Summary -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Booking Summary Card -->
        <div class="panel-clean p-6">
          <label class="section-label mb-4 block">Détails du rendez-vous</label>
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 rounded-full bg-sand flex items-center justify-center font-bold text-espresso text-lg">
                {{ clientInitials }}
              </div>
              <div>
                <p class="row-primary text-lg">{{ booking?.clientName }}</p>
                <p class="row-meta">{{ booking?.date }} • {{ booking?.time }}</p>
              </div>
            </div>
            <div class="text-right">
              <p class="row-meta">Personnel</p>
              <p class="row-primary">{{ booking?.staffName }}</p>
            </div>
          </div>
        </div>

        <!-- Line Items -->
        <div class="panel-clean p-6">
          <div class="flex items-center justify-between mb-6">
            <label class="section-label">Prestations et Produits</label>
            <button @click="addItem" class="text-primary font-bold text-xs flex items-center gap-1 hover:opacity-80 transition">
              <PlusIcon class="w-4 h-4" />
              AJOUTER
            </button>
          </div>

          <div class="space-y-4">
            <div v-for="(item, index) in items" :key="index" class="flex items-center gap-4 p-3 rounded-xl bg-neutral-bg/30 group">
              <div class="flex-1">
                <input 
                  v-model="item.name" 
                  class="bg-transparent border-none focus:ring-0 p-0 font-bold text-espresso text-sm w-full"
                  placeholder="Nom de la prestation ou produit"
                />
              </div>
              <div class="w-32 flex items-center gap-2">
                <input 
                  v-model.number="item.price" 
                  type="number"
                  class="bg-transparent border-none focus:ring-0 p-0 font-bold text-espresso text-sm text-right w-full tabular-nums"
                />
                <span class="text-[10px] font-bold text-cocoa/40">FCFA</span>
              </div>
              <button @click="removeItem(index)" class="p-1 text-cocoa/20 hover:text-error opacity-0 group-hover:opacity-100 transition">
                <TrashIcon class="w-4 h-4" />
              </button>
            </div>
          </div>

          <!-- Discount — hidden (promos feature disabled) -->
          <!--
          <div class="mt-8 pt-8 border-t border-outline-variant/50">
            <div class="flex items-end gap-4">
              <div class="flex-1">
                <label class="section-label mb-2 block">Code promo / Remise</label>
                <input 
                  v-model="discountCode" 
                  placeholder="Ex: BIENVENUE10"
                  class="input-shell w-full"
                />
              </div>
                <button @click="applyDiscount" class="btn-secondary py-3 px-6 h-[50px]">Appliquer</button>
            </div>
          </div>
          -->
        </div>
      </div>

      <!-- Right Column: Payment & Total -->
      <div class="space-y-6">
        <div class="panel-clean p-6 sticky top-6">
          <label class="section-label mb-6 block">Récapitulatif</label>
          
          <div class="space-y-4 mb-8">
            <div class="flex justify-between text-sm">
              <span class="text-cocoa/60">Sous-total</span>
              <span class="font-bold text-espresso tabular-nums">{{ formatMoneyXof(subtotal) }}</span>
            </div>
            <div v-if="discount > 0" class="flex justify-between text-sm text-green-600">
              <span>Remise</span>
              <span class="font-bold tabular-nums">- {{ formatMoneyXof(discount) }}</span>
            </div>
            <div class="flex justify-between text-sm">
              <span class="text-cocoa/60">Acompte payé</span>
              <span class="font-bold text-espresso tabular-nums">- {{ formatMoneyXof(deposit) }}</span>
            </div>
            <div class="pt-4 border-t border-outline-variant flex justify-between items-end">
              <span class="font-bold text-espresso">Reste à payer</span>
              <span class="metric-value text-primary">{{ formatMoneyXof(balance) }}</span>
            </div>
          </div>

          <label class="section-label mb-4 block">Mode de paiement</label>
          <div class="grid grid-cols-2 gap-2 mb-8">
            <button 
              v-for="method in paymentMethods" 
              :key="method.id"
              @click="selectedMethod = method.id"
              :class="[
                'p-3 rounded-xl border-2 transition-all flex flex-col items-center gap-2 text-center',
                selectedMethod === method.id 
                  ? 'border-primary bg-primary/5 text-primary shadow-sm' 
                  : 'border-outline-variant/50 hover:border-outline text-cocoa/60'
              ]"
            >
              <component :is="method.icon" class="w-6 h-6" />
              <span class="text-[10px] font-bold uppercase tracking-wider">{{ method.label }}</span>
            </button>
          </div>

          <div class="space-y-3">
            <button :disabled="completeMutation.isPending.value" @click="completeCheckout" class="btn-gold w-full py-4 text-sm flex items-center justify-center gap-2 disabled:opacity-60">
              <CheckCircleIcon class="w-5 h-5" />
              {{ completeMutation.isPending.value ? "ENCAISSEMENT..." : `ENCAISSER ${formatMoneyXof(balance)}` }}
            </button>
            <button @click="sendToClient" class="btn-secondary w-full py-4 text-sm flex items-center justify-center gap-2">
              <PaperAirplaneIcon class="w-4 h-4" />
              ENVOYER AU CLIENT
            </button>
          </div>
          
          <p class="text-[10px] text-cocoa/40 text-center mt-6 leading-relaxed">
            En encaissant, vous marquez ce rendez-vous comme terminé et enregistrez le paiement dans votre comptabilité.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from "vue";
import { useMutation, useQuery } from "@tanstack/vue-query";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { 
  ArrowLeftIcon, 
  PlusIcon, 
  TrashIcon, 
  CheckCircleIcon,
  PaperAirplaneIcon,
  BanknotesIcon,
  WalletIcon,
  EllipsisHorizontalCircleIcon
} from "@heroicons/vue/24/outline";
import { completeProCheckout, fetchProCheckout } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";

const route = useRoute();
const router = useRouter();
const auth = useProAuthStore();

const items = ref<Array<{ name: string; price: number }>>([]);
const discountCode = ref("");
const discount = ref(0);
const selectedMethod = ref("cash");

const paymentMethods = [
  { id: "cash", label: "Espèces", icon: BanknotesIcon },
  { id: "intech", label: "Mobile Money (Intech)", icon: WalletIcon },
  { id: "other", label: "Autre", icon: EllipsisHorizontalCircleIcon },
];

const checkoutQuery = useQuery({
  queryKey: computed(() => ["pro-checkout", route.params.bookingId]),
  queryFn: () => fetchProCheckout(auth.accessToken ?? "", String(route.params.bookingId)),
  enabled: computed(() => Boolean(auth.accessToken && route.params.bookingId))
});

const completeMutation = useMutation({
  mutationFn: () =>
    completeProCheckout(auth.accessToken ?? "", String(route.params.bookingId), {
      paymentMethod: selectedMethod.value as "cash" | "intech" | "other",
      discountXof: discount.value,
      lineItems: items.value
        .map((item) => ({
          name: item.name.trim(),
          amountXof: Math.max(0, Number(item.price || 0))
        }))
        .filter((item) => item.name.length > 0)
    }),
  onSuccess: async () => {
    toast.success("Paiement enregistré avec succès.");
    await router.push("/pro/calendar");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Encaissement impossible pour le moment."));
  }
});

const booking = computed(() => {
  const data = checkoutQuery.data.value;
  if (!data) return null;
  return {
    id: data.bookingId,
    clientName: data.clientName ?? "Client",
    date: dayjs(data.startsAt).format("DD MMM YYYY"),
    time: dayjs(data.startsAt).format("HH:mm"),
    staffName: data.staffName ?? "Non assigné",
    serviceName: data.serviceName,
    price: data.subtotalXof
  };
});

const subtotal = computed(() => {
  return items.value.reduce((sum, item) => sum + (item.price || 0), 0);
});

const deposit = computed(() => checkoutQuery.data.value?.depositPaidXof ?? 0);

const balance = computed(() => {
  const total = subtotal.value - discount.value - deposit.value;
  return Math.max(0, total);
});

const clientInitials = computed(() => {
  if (!booking.value?.clientName) return "??";
  return booking.value.clientName
    .split(" ")
    .map((n: string) => n[0] ?? "")
    .join("")
    .toUpperCase();
});

function addItem() {
  items.value.push({ name: "", price: 0 });
}

function removeItem(index: number) {
  items.value.splice(index, 1);
}

function applyDiscount() {
  const raw = discountCode.value.trim().toUpperCase();
  if (!raw) {
    discount.value = 0;
    toast.info("Remise réinitialisée.");
    return;
  }

  let nextDiscount = 0;

  if (/^\d+$/.test(raw)) {
    nextDiscount = Number(raw);
  } else if (/^\d+%$/.test(raw)) {
    const percent = Number(raw.replace("%", ""));
    nextDiscount = Math.round(subtotal.value * (percent / 100));
  } else if (/^BIENVENUE\d+$/.test(raw)) {
    const percent = Number(raw.replace("BIENVENUE", ""));
    nextDiscount = Math.round(subtotal.value * (percent / 100));
  } else if (/^VIP\d+$/.test(raw)) {
    const percent = Number(raw.replace("VIP", ""));
    nextDiscount = Math.round(subtotal.value * (percent / 100));
  } else {
    toast.error("Code de remise invalide. Utilisez par exemple BIENVENUE10 ou 5000.");
    return;
  }

  const maxDiscount = Math.max(0, subtotal.value - deposit.value);
  discount.value = Math.max(0, Math.min(nextDiscount, maxDiscount));
  toast.success(`Remise appliquée: ${formatMoneyXof(discount.value)}.`);
}

function completeCheckout() {
  if (!items.value.some((item) => item.name.trim().length > 0)) {
    toast.error("Ajoutez au moins une ligne de facturation.");
    return;
  }
  completeMutation.mutate();
}

async function sendToClient() {
  const clientName = booking.value?.clientName ?? "Client";
  const checkoutUrl = `${window.location.origin}/pro/checkout/${route.params.bookingId}`;
  const message = `Bonjour ${clientName}, voici le lien de suivi de votre encaissement: ${checkoutUrl}`;

  try {
    await navigator.clipboard.writeText(message);
    toast.success("Message copié. Vous pouvez le coller dans un SMS.");
  } catch {
    toast.info(message);
  }
}

watch(
  () => checkoutQuery.data.value,
  (data) => {
    if (!data) return;
    items.value = data.lineItems.map((item) => ({
      name: item.name,
      price: item.amountXof
    }));
  },
  { immediate: true }
);
</script>
