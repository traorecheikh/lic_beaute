<template>
  <div class="h-[calc(100vh-160px)] flex flex-col">
    <!-- Calendar Toolbar -->
    <div class="flex items-center justify-between mb-6 bg-surface p-2 rounded-2xl border border-outline-variant/50 shadow-sm">
      <div class="flex items-center gap-4">
        <button class="btn-secondary px-4 py-2 text-[11px] ring-0 border">Aujourd'hui</button>
        <div class="flex items-center gap-1">
          <button class="p-2 hover:bg-neutral-bg rounded-full transition"><ChevronLeftIcon class="w-4 h-4" /></button>
          <button class="p-2 hover:bg-neutral-bg rounded-full transition"><ChevronRightIcon class="w-4 h-4" /></button>
        </div>
        <h2 class="font-display text-xl text-espresso ml-2">Mardi 16 juillet 2026</h2>
      </div>

      <div class="flex items-center gap-2">
        <div class="flex bg-neutral-bg p-1 rounded-full">
          <button class="px-4 py-1.5 rounded-full text-[11px] font-bold transition bg-white shadow-sm text-espresso">Jour</button>
          <button class="px-4 py-1.5 rounded-full text-[11px] font-bold transition text-cocoa/40 hover:text-espresso">Semaine</button>
        </div>
        <button class="btn-secondary px-4 py-2 text-[11px] ring-0 border flex items-center gap-2">
          <FunnelIcon class="w-4 h-4" />
          Filtres
        </button>
      </div>
    </div>

    <div class="flex-1 flex overflow-hidden relative">
      <!-- Calendar Grid Area -->
      <div class="flex-1 overflow-auto bg-surface rounded-2xl border border-outline-variant/50 relative">
        <!-- Staff Headers -->
        <div class="sticky top-0 z-20 flex bg-surface border-b border-outline-variant">
          <div class="w-20 shrink-0 border-r border-outline-variant bg-neutral-bg/50"></div>
          <div v-for="staff in staffMembers" :key="staff.id" class="flex-1 min-w-[200px] py-4 px-4 flex items-center gap-3 border-r border-outline-variant last:border-r-0">
            <div :class="['w-10 h-10 rounded-full flex items-center justify-center font-bold text-xs ring-2 ring-white', staff.tone]">
              {{ staff.initials }}
            </div>
            <div>
              <p class="text-xs font-bold text-espresso">{{ staff.name }}</p>
              <p class="text-[10px] text-cocoa/40 uppercase tracking-widest font-semibold">{{ staff.role }}</p>
            </div>
          </div>
        </div>

        <!-- Time Grid -->
        <div class="relative flex">
          <!-- Time Labels -->
          <div class="w-20 shrink-0 bg-neutral-bg/30 border-r border-outline-variant">
            <div v-for="hour in hours" :key="hour" class="h-20 border-b border-outline-variant/50 px-2 pt-2 text-right">
              <span class="text-[10px] font-bold text-cocoa/40 uppercase">{{ hour }}</span>
            </div>
          </div>

          <!-- Staff Columns Content -->
          <div class="flex-1 flex relative">
            <div v-for="staff in staffMembers" :key="staff.id" class="flex-1 min-w-[200px] relative border-r border-outline-variant last:border-r-0">
              <div v-for="hour in hours" :key="hour" class="h-20 border-b border-outline-variant/30"></div>
              
              <!-- Mock Appointment Blocks -->
              <div 
                v-for="booking in getStaffBookings(staff.id)" 
                :key="booking.id"
                @click="selectedBooking = booking"
                :class="[
                  'absolute left-1 right-1 rounded-xl p-2 cursor-pointer transition-all hover:ring-2 hover:ring-primary/20 overflow-hidden',
                  booking.tone,
                  booking.status === 'pending' ? 'opacity-70 border-2 border-dashed border-cocoa/10' : 'border border-white/50 shadow-sm'
                ]"
                :style="{ top: booking.top + 'px', height: booking.height + 'px' }"
              >
                <div v-if="booking.status === 'checked_in'" class="absolute left-0 top-0 bottom-0 w-1 bg-primary"></div>
                <p class="text-[9px] font-bold uppercase tracking-wider text-cocoa/40 mb-0.5">{{ booking.category }}</p>
                <p class="text-[11px] font-bold text-espresso leading-tight truncate">{{ booking.client }}</p>
                <p class="text-[10px] text-cocoa/60 mt-0.5">{{ booking.timeRange }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Side Panel -->
      <transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="translate-x-full"
        enter-to-class="translate-x-0"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="translate-x-0"
        leave-to-class="translate-x-full"
      >
        <div v-if="selectedBooking" class="w-80 shrink-0 bg-surface border-l border-outline-variant shadow-2xl z-30 flex flex-col">
          <div class="p-6 border-b border-outline-variant flex items-center justify-between">
            <h3 class="font-display text-lg text-espresso">Détails RDV</h3>
            <button @click="selectedBooking = null" class="p-2 hover:bg-neutral-bg rounded-full transition">
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <div class="flex-1 overflow-y-auto p-6 space-y-8">
            <!-- Status + Action -->
            <div class="flex items-center justify-between gap-4">
              <span :class="['px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest', statusStyles[selectedBooking.status]]">
                {{ statusLabels[selectedBooking.status] }}
              </span>
              <button @click="advanceStatus" class="btn-primary flex-1 py-2 text-[10px]">
                {{ nextActionLabels[selectedBooking.status] }}
              </button>
            </div>

            <!-- Client Info -->
            <div class="space-y-4">
              <label class="section-label">Client</label>
              <div class="flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-sand flex items-center justify-center font-bold text-espresso text-lg">
                  {{ selectedBooking.clientInitials }}
                </div>
                <div>
                  <p class="font-bold text-espresso">{{ selectedBooking.client }}</p>
                  <p class="text-xs text-cocoa/60">+221 77 123 45 67</p>
                </div>
              </div>
            </div>

            <!-- Service Info -->
            <div class="space-y-4">
              <label class="section-label">Prestation</label>
              <div class="panel-clean p-4 border-dashed bg-neutral-bg/30">
                <p class="font-bold text-sm text-espresso mb-1">{{ selectedBooking.service }}</p>
                <p class="text-xs text-cocoa/60">{{ selectedBooking.timeRange }} • {{ selectedBooking.duration }} min</p>
                <p class="text-sm font-bold text-primary mt-3">{{ selectedBooking.price }} FCFA</p>
              </div>
            </div>

            <!-- Notes -->
            <div class="space-y-4">
              <label class="section-label">Notes client</label>
              <p class="text-sm text-cocoa/60 italic leading-relaxed">"Je voudrais un dégradé très bas sur les côtés, merci !"</p>
            </div>
          </div>

          <div v-if="selectedBooking.status === 'checked_in'" class="p-6 border-t border-outline-variant bg-primary/5">
            <RouterLink :to="`/pro/checkout/${selectedBooking.id}`" class="btn-primary w-full py-4 text-sm">ENCAISSER</RouterLink>
          </div>
        </div>
      </transition>

      <!-- Floating Action Button -->
      <button class="absolute bottom-6 right-6 w-14 h-14 bg-primary text-white rounded-full shadow-lg flex items-center justify-center hover:scale-110 active:scale-95 transition-all z-10">
        <PlusIcon class="w-7 h-7" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { toast } from "vue-sonner";
import { 
  ChevronLeftIcon, 
  ChevronRightIcon, 
  FunnelIcon,
  XMarkIcon,
  PlusIcon
} from "@heroicons/vue/24/outline";

const staffMembers = [
  { id: 1, name: "Marie Diop", initials: "MD", role: "Manager", tone: "bg-pink-100 text-pink-700" },
  { id: 2, name: "Jean Faye", initials: "JF", role: "Senior", tone: "bg-blue-100 text-blue-700" },
  { id: 3, name: "Awa Sow", initials: "AS", role: "Junior", tone: "bg-green-100 text-green-700" }
];

const hours = ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00"];

const bookings = [
  { 
    id: 1, staffId: 1, top: 40, height: 120, 
    category: "COIFFURE", client: "Fatou Binetou", clientInitials: "FB",
    service: "Tresses + Soin", timeRange: "09:30 – 11:00", duration: 90, price: "25 000",
    status: "confirmed", tone: "bg-pink-50" 
  },
  { 
    id: 2, staffId: 2, top: 200, height: 80, 
    category: "BARBER", client: "Oumar Sy", clientInitials: "OS",
    service: "Coupe + Barbe", timeRange: "11:30 – 12:30", duration: 60, price: "10 000",
    status: "checked_in", tone: "bg-blue-50" 
  },
  { 
    id: 3, staffId: 3, top: 80, height: 40, 
    category: "ONGLES", client: "Aminata Traoré", clientInitials: "AT",
    service: "Pose vernis", timeRange: "10:00 – 10:30", duration: 30, price: "5 000",
    status: "pending", tone: "bg-green-50" 
  }
];

const selectedBooking = ref<any>(null);

const statusLabels: any = {
  pending: "En attente",
  confirmed: "Confirmé",
  checked_in: "Arrivé",
  completed: "Terminé"
};

const statusStyles: any = {
  pending: "bg-amber-100 text-amber-700 border border-amber-200",
  confirmed: "bg-blue-100 text-blue-700 border border-blue-200",
  checked_in: "bg-green-100 text-green-700 border border-green-200",
  completed: "bg-gray-100 text-gray-700 border border-gray-200"
};

const nextActionLabels: any = {
  pending: "Confirmer",
  confirmed: "Marquer Arrivé",
  checked_in: "Encaisser",
  completed: "Archiver"
};

function getStaffBookings(staffId: number) {
  return bookings.filter(b => b.staffId === staffId);
}

function advanceStatus() {
  if (!selectedBooking.value) return;
  
  const currentStatus = selectedBooking.value.status;
  if (currentStatus === 'pending') selectedBooking.value.status = 'confirmed';
  else if (currentStatus === 'confirmed') selectedBooking.value.status = 'checked_in';
  else if (currentStatus === 'checked_in') {
    toast.info("Navigation vers l'encaissement...");
  }
  
  toast.success(`Statut mis à jour : ${statusLabels[selectedBooking.value.status]}`);
}
</script>
