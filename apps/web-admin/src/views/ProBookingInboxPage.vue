<template>
  <div>
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Inbox Réservations</h1>
        <p class="text-cocoa/60">Gérez vos demandes entrantes et à venir.</p>
      </div>
      <button class="btn-primary gap-2">
        <PlusIcon class="w-4 h-4" />
        Nouveau RDV
      </button>
    </div>

    <!-- Filters -->
    <div class="flex gap-2 mb-8 overflow-x-auto pb-2 no-scrollbar">
      <button 
        v-for="filter in filters" 
        :key="filter"
        :class="[
          'px-6 py-2 rounded-full text-xs font-bold transition whitespace-nowrap',
          activeFilter === filter ? 'bg-primary text-white' : 'bg-surface text-cocoa/60 border border-outline-variant/50 hover:bg-sand'
        ]"
        @click="activeFilter = filter"
      >
        {{ filter }}
      </button>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- List -->
      <div class="lg:col-span-2 space-y-4">
        <div 
          v-for="booking in filteredBookings" 
          :key="booking.id"
          @click="selectedId = booking.id"
          :class="[
            'panel-clean p-4 flex items-center gap-4 cursor-pointer transition-all hover:border-primary/20',
            selectedId === booking.id ? 'ring-2 ring-primary/20 border-primary/40' : ''
          ]"
        >
          <div class="w-12 h-12 rounded-xl bg-sand flex flex-col items-center justify-center shrink-0">
            <span class="text-[10px] font-bold text-cocoa/40 uppercase">{{ booking.day }}</span>
            <span class="text-lg font-bold text-espresso leading-none">{{ booking.date }}</span>
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-0.5">
              <p class="row-primary truncate">{{ booking.client }}</p>
              <span :class="['px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest', statusStyles[booking.status]]">
                {{ statusLabels[booking.status] }}
              </span>
            </div>
            <p class="row-meta truncate">{{ booking.service }} • {{ booking.time }} • {{ booking.staff }}</p>
          </div>
          <div class="text-right shrink-0">
            <p class="text-sm font-bold text-espresso">{{ booking.price }} FCFA</p>
            <p class="text-[10px] text-cocoa/40 font-semibold uppercase tracking-widest">Payé: {{ booking.deposit }}</p>
          </div>
        </div>
      </div>

      <!-- Detail Panel (Fixed on desktop) -->
      <div class="hidden lg:block">
        <div v-if="selectedBooking" class="panel-clean p-8 sticky top-32">
          <div class="text-center mb-8">
            <div class="w-20 h-20 rounded-full bg-primary/5 mx-auto flex items-center justify-center font-display text-3xl text-primary mb-4 border border-primary/10">
              {{ selectedBooking.clientInitials }}
            </div>
            <h3 class="entity-title">{{ selectedBooking.client }}</h3>
            <p class="text-sm text-cocoa/60">{{ selectedBooking.phone }}</p>
          </div>

          <div class="space-y-6 mb-8">
            <div class="flex justify-between py-2 border-b border-outline-variant/30">
              <span class="text-xs font-bold text-cocoa/40 uppercase">Prestation</span>
              <span class="text-sm font-semibold text-espresso text-right">{{ selectedBooking.service }}</span>
            </div>
            <div class="flex justify-between py-2 border-b border-outline-variant/30">
              <span class="text-xs font-bold text-cocoa/40 uppercase">Date & Heure</span>
              <span class="text-sm font-semibold text-espresso">{{ selectedBooking.fullDate }} à {{ selectedBooking.time }}</span>
            </div>
            <div class="flex justify-between py-2 border-b border-outline-variant/30">
              <span class="text-xs font-bold text-cocoa/40 uppercase">Employé</span>
              <span class="text-sm font-semibold text-espresso">{{ selectedBooking.staff }}</span>
            </div>
          </div>

          <div v-if="selectedBooking.status === 'pending'" class="grid grid-cols-2 gap-3">
            <button @click="rejectBooking" class="btn-secondary py-3 ring-0 border text-[11px]">Refuser</button>
            <button @click="acceptBooking" class="btn-primary py-3 text-[11px]">Accepter</button>
          </div>
          <button v-else class="btn-secondary w-full py-3 ring-0 border text-[11px]">Voir dans l'agenda</button>
        </div>
        <div v-else class="panel-clean p-8 text-center border-dashed flex flex-col items-center justify-center min-h-[400px]">
          <InboxIcon class="w-12 h-12 text-cocoa/20 mb-4" />
          <p class="text-sm text-cocoa/40 italic">Sélectionnez une réservation pour voir les détails.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import { toast } from "vue-sonner";
import { PlusIcon, InboxIcon } from "@heroicons/vue/24/outline";

const filters = ["Tous", "En attente", "Confirmés", "Aujourd'hui", "Cette semaine"];
const activeFilter = ref("Tous");
const selectedId = ref<number | null>(1);

const bookings = ref([
  { 
    id: 1, day: "MAR", date: "16", time: "14:30", client: "Awa Ndiaye", clientInitials: "AN",
    phone: "+221 77 123 45 67", service: "Brushing + Soin", staff: "Marie Diop",
    fullDate: "Mardi 16 juillet", price: "25 000", deposit: "5 000", status: "pending" 
  },
  { 
    id: 2, day: "MER", date: "17", time: "10:00", client: "Fatou Sow", clientInitials: "FS",
    phone: "+221 78 987 65 43", service: "Manucure", staff: "Awa Sow",
    fullDate: "Mercredi 17 juillet", price: "15 000", deposit: "3 000", status: "confirmed" 
  },
  { 
    id: 3, day: "MER", date: "17", time: "16:30", client: "Ibrahim Diallo", clientInitials: "ID",
    phone: "+221 70 555 44 33", service: "Coupe Homme", staff: "Jean Faye",
    fullDate: "Mercredi 17 juillet", price: "10 000", deposit: "2 000", status: "confirmed" 
  }
]);

const filteredBookings = computed(() => {
  if (activeFilter.value === "Tous") return bookings.value;
  if (activeFilter.value === "En attente") return bookings.value.filter(b => b.status === 'pending');
  if (activeFilter.value === "Confirmés") return bookings.value.filter(b => b.status === 'confirmed');
  return bookings.value;
});

const selectedBooking = computed(() => bookings.value.find(b => b.id === selectedId.value));

const statusLabels: any = {
  pending: "En attente",
  confirmed: "Confirmé"
};

const statusStyles: any = {
  pending: "bg-amber-100 text-amber-700",
  confirmed: "bg-blue-100 text-blue-700"
};

function acceptBooking() {
  if (selectedBooking.value) {
    selectedBooking.value.status = 'confirmed';
    toast.success("Réservation acceptée !");
  }
}

function rejectBooking() {
  bookings.value = bookings.value.filter(b => b.id !== selectedId.value);
  selectedId.value = bookings.value[0]?.id || null;
  toast.info("Réservation refusée.");
}
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>
