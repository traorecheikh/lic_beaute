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

          <!-- Discount -->
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
              <button class="btn-secondary py-3 px-6 h-[50px]">Appliquer</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Right Column: Payment & Total -->
      <div class="space-y-6">
        <div class="panel-clean p-6 sticky top-6">
          <label class="section-label mb-6 block">Récapitulatif</label>
          
          <div class="space-y-4 mb-8">
            <div class="flex justify-between text-sm">
              <span class="text-cocoa/60">Sous-total</span>
              <span class="font-bold text-espresso tabular-nums">{{ subtotal.toLocaleString() }} FCFA</span>
            </div>
            <div v-if="discount > 0" class="flex justify-between text-sm text-green-600">
              <span>Remise</span>
              <span class="font-bold tabular-nums">- {{ discount.toLocaleString() }} FCFA</span>
            </div>
            <div class="flex justify-between text-sm">
              <span class="text-cocoa/60">Acompte payé</span>
              <span class="font-bold text-espresso tabular-nums">- {{ deposit.toLocaleString() }} FCFA</span>
            </div>
            <div class="pt-4 border-t border-outline-variant flex justify-between items-end">
              <span class="font-bold text-espresso">Reste à payer</span>
              <span class="metric-value text-primary">{{ balance.toLocaleString() }} FCFA</span>
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
            <button @click="completeCheckout" class="btn-primary w-full py-4 text-sm flex items-center justify-center gap-2">
              <CheckCircleIcon class="w-5 h-5" />
              ENCAISSER {{ balance.toLocaleString() }} FCFA
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
import { ref, computed, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { 
  ArrowLeftIcon, 
  PlusIcon, 
  TrashIcon, 
  CheckCircleIcon,
  PaperAirplaneIcon,
  BanknotesIcon,
  DevicePhoneMobileIcon,
  WalletIcon,
  EllipsisHorizontalCircleIcon
} from "@heroicons/vue/24/outline";

const route = useRoute();
const router = useRouter();

const booking = ref<any>(null);
const items = ref<any[]>([]);
const discountCode = ref("");
const discount = ref(0);
const deposit = ref(5000);
const selectedMethod = ref("cash");

const paymentMethods = [
  { id: "cash", label: "Espèces", icon: BanknotesIcon },
  { id: "wave", label: "Wave", icon: WalletIcon },
  { id: "om", label: "Orange Money", icon: DevicePhoneMobileIcon },
  { id: "other", label: "Autre", icon: EllipsisHorizontalCircleIcon },
];

const subtotal = computed(() => {
  return items.value.reduce((sum, item) => sum + (item.price || 0), 0);
});

const balance = computed(() => {
  const total = subtotal.value - discount.value - deposit.value;
  return Math.max(0, total);
});

const clientInitials = computed(() => {
  if (!booking.value?.clientName) return "??";
  return booking.value.clientName
    .split(" ")
    .map((n: string) => n[0])
    .join("")
    .toUpperCase();
});

function addItem() {
  items.value.push({ name: "", price: 0 });
}

function removeItem(index: number) {
  items.value.splice(index, 1);
}

function completeCheckout() {
  toast.success("Paiement enregistré avec succès !");
  router.push("/pro/calendar");
}

function sendToClient() {
  toast.info("Lien de paiement envoyé au client par SMS.");
}

onMounted(() => {
  // Mock data fetching based on :bookingId
  const bookingId = route.params.bookingId;
  
  // In a real app, we'd call fetchBooking(bookingId)
  booking.value = {
    id: bookingId,
    clientName: "Fatou Binetou",
    date: "16 Juillet 2026",
    time: "09:30",
    staffName: "Marie Diop",
    serviceName: "Tresses + Soin",
    price: 25000
  };

  items.value = [
    { name: booking.value.serviceName, price: booking.value.price }
  ];
});
</script>
