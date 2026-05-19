<template>
  <div class="h-[calc(100vh-160px)] flex flex-col">
    <div class="flex items-center justify-between mb-6 bg-surface p-2 rounded-2xl border border-outline-variant/50 shadow-sm">
      <div class="flex items-center gap-4">
        <button @click="goToday" class="btn-secondary px-4 py-2 text-[11px] ring-0 border">Aujourd'hui</button>
        <div class="flex items-center gap-1">
          <button @click="goPrevious" class="p-2 hover:bg-neutral-bg rounded-full transition"><ChevronLeftIcon class="w-4 h-4" /></button>
          <button @click="goNext" class="p-2 hover:bg-neutral-bg rounded-full transition"><ChevronRightIcon class="w-4 h-4" /></button>
        </div>
        <h2 class="row-primary text-base ml-2">{{ calendarLabel }}</h2>
      </div>

      <div class="flex items-center gap-2">
        <div class="flex bg-neutral-bg p-1 rounded-full">
          <button
            @click="viewMode = 'day'"
            :class="[
              'px-4 py-1.5 rounded-full text-[11px] font-bold transition',
              viewMode === 'day' ? 'bg-white shadow-sm text-espresso' : 'text-cocoa/40 hover:text-espresso'
            ]"
          >
            Jour
          </button>
          <button
            @click="viewMode = 'week'"
            :class="[
              'px-4 py-1.5 rounded-full text-[11px] font-bold transition',
              viewMode === 'week' ? 'bg-white shadow-sm text-espresso' : 'text-cocoa/40 hover:text-espresso'
            ]"
          >
            Semaine
          </button>
        </div>
        <select v-model="statusFilter" class="input-shell py-2 text-[11px] min-w-[140px]">
          <option value="all">Tous statuts</option>
          <option value="pending">En attente</option>
          <option value="confirmed">Confirmés</option>
          <option value="in_progress">En cours</option>
          <option value="completed">Terminés</option>
          <option value="cancelled">Annulés</option>
        </select>
        <select v-if="auth.isManager" v-model="selectedEmployeeId" class="input-shell py-2 text-[11px] min-w-[140px]">
          <option value="all">Toute l'équipe</option>
          <option v-for="staff in staffMembers" :key="staff.id" :value="staff.id">{{ staff.name }}</option>
        </select>
        <button @click="openCreateModal('manual')" class="btn-secondary px-4 py-2 text-[11px] ring-0 border flex items-center gap-2">
          <PlusIcon class="w-4 h-4" />
          Nouveau RDV
        </button>
      </div>
    </div>

    <div class="flex-1 flex overflow-hidden relative">
      <div class="flex-1 overflow-auto bg-surface rounded-2xl border border-outline-variant/50 relative">

        <!-- Day view header: staff columns -->
        <div v-if="viewMode === 'day'" class="sticky top-0 z-20 flex bg-surface border-b border-outline-variant">
          <div class="w-20 shrink-0 border-r border-outline-variant bg-neutral-bg/50"></div>
          <div v-for="staff in displayedStaffMembers" :key="staff.id" class="flex-1 min-w-[200px] py-4 px-4 flex items-center gap-3 border-r border-outline-variant last:border-r-0">
            <div :class="['w-10 h-10 rounded-full flex items-center justify-center font-bold text-xs ring-2 ring-white', staff.tone]">
              {{ staff.initials }}
            </div>
            <div>
              <p class="text-xs font-bold text-espresso">{{ staff.name }}</p>
              <p class="text-[10px] text-cocoa/40 uppercase tracking-widest font-semibold">{{ staff.role }}</p>
            </div>
          </div>
        </div>

        <!-- Week view header: day columns -->
        <div v-else class="sticky top-0 z-20 flex bg-surface border-b border-outline-variant">
          <div class="w-20 shrink-0 border-r border-outline-variant bg-neutral-bg/50"></div>
          <div
            v-for="day in weekDays"
            :key="day.dateStr"
            :class="[
              'flex-1 min-w-[120px] py-4 px-3 text-center border-r border-outline-variant last:border-r-0',
              day.isToday ? 'bg-primary/5' : ''
            ]"
          >
            <p class="text-[10px] font-bold uppercase tracking-widest text-cocoa/40">{{ day.weekLabel }}</p>
            <p :class="['text-sm font-bold mt-1', day.isToday ? 'text-primary' : 'text-espresso']">{{ day.dayLabel }}</p>
          </div>
        </div>

        <!-- Day view grid -->
        <div v-if="viewMode === 'day'" class="relative flex">
          <div class="w-20 shrink-0 bg-neutral-bg/30 border-r border-outline-variant">
            <div v-for="hour in hours" :key="hour" class="h-20 border-b border-outline-variant/50 px-2 pt-2 text-right">
              <span class="text-[10px] font-bold text-cocoa/40 uppercase">{{ hour }}</span>
            </div>
          </div>

          <div class="flex-1 flex relative">
            <!-- Blocked slot overlays spanning all staff columns -->
            <div
              v-for="slot in dayModeBlockedSlots"
              :key="slot.id"
              @click="selectedBlockedSlotId = slot.id; selectedBookingId = null"
              :class="[
                'absolute left-0 right-0 z-[5] cursor-pointer transition-all',
                selectedBlockedSlotId === slot.id
                  ? 'bg-error/10 border-l-4 border-error'
                  : 'bg-error/5 border-l-4 border-error/30 hover:bg-error/10'
              ]"
              :style="{ top: slot.top + 'px', height: slot.height + 'px' }"
            >
              <div class="px-3 py-1.5">
                <p class="text-[9px] font-bold uppercase tracking-wider text-error">Créneau bloqué</p>
                <p class="text-[10px] text-error/80 font-semibold truncate">{{ slot.reason ?? slot.timeRange }}</p>
              </div>
            </div>

            <div v-for="staff in displayedStaffMembers" :key="staff.id" class="flex-1 min-w-[200px] relative border-r border-outline-variant last:border-r-0">
              <div v-for="hour in hours" :key="hour" class="h-20 border-b border-outline-variant/30"></div>

              <div
                v-for="booking in getStaffBookings(staff.id)"
                :key="booking.id"
                @click="selectedBookingId = booking.id; selectedBlockedSlotId = null"
                :class="[
                  'absolute left-1 right-1 rounded-xl p-2 cursor-pointer transition-all hover:ring-2 hover:ring-primary/20 overflow-hidden z-10',
                  booking.tone,
                  booking.status === 'pending' ? 'opacity-70 border-2 border-dashed border-cocoa/10' : 'border border-white/50 shadow-sm'
                ]"
                :style="{ top: booking.top + 'px', height: booking.height + 'px' }"
              >
                <div v-if="booking.status === 'in_progress'" class="absolute left-0 top-0 bottom-0 w-1 bg-primary"></div>
                <p class="text-[9px] font-bold uppercase tracking-wider text-cocoa/40 mb-0.5">{{ booking.category }}</p>
                <p class="text-[11px] font-bold text-espresso leading-tight truncate">{{ booking.client }}</p>
                <p class="text-[10px] text-cocoa/60 mt-0.5">{{ booking.timeRange }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Week view grid -->
        <div v-else class="relative flex">
          <div class="w-20 shrink-0 bg-neutral-bg/30 border-r border-outline-variant">
            <div v-for="hour in hours" :key="hour" class="h-20 border-b border-outline-variant/50 px-2 pt-2 text-right">
              <span class="text-[10px] font-bold text-cocoa/40 uppercase">{{ hour }}</span>
            </div>
          </div>

          <div class="flex-1 flex relative">
            <div
              v-for="day in weekDays"
              :key="day.dateStr"
              :class="[
                'flex-1 min-w-[120px] relative border-r border-outline-variant last:border-r-0',
                day.isToday ? 'bg-primary/[0.02]' : ''
              ]"
            >
              <div v-for="hour in hours" :key="hour" class="h-20 border-b border-outline-variant/30"></div>

              <!-- Blocked slots for this day -->
              <div
                v-for="slot in getWeekDayBlockedSlots(day.dateStr)"
                :key="slot.id"
                @click="selectedBlockedSlotId = slot.id; selectedBookingId = null"
                :class="[
                  'absolute left-0 right-0 z-[5] cursor-pointer transition-all',
                  selectedBlockedSlotId === slot.id
                    ? 'bg-error/10 border-l-4 border-error'
                    : 'bg-error/5 border-l-4 border-error/30 hover:bg-error/10'
                ]"
                :style="{ top: slot.top + 'px', height: slot.height + 'px' }"
              >
                <div class="px-2 py-1">
                  <p class="text-[8px] font-bold uppercase tracking-wider text-error">Bloqué</p>
                  <p class="text-[9px] text-error/80 font-semibold truncate">{{ slot.reason ?? slot.timeRange }}</p>
                </div>
              </div>

              <!-- Bookings for this day -->
              <div
                v-for="booking in getWeekDayBookings(day.dateStr)"
                :key="booking.id"
                @click="selectedBookingId = booking.id; selectedBlockedSlotId = null"
                :class="[
                  'absolute left-0.5 right-0.5 rounded-lg p-1.5 cursor-pointer transition-all hover:ring-2 hover:ring-primary/20 overflow-hidden z-10',
                  booking.tone,
                  booking.status === 'pending' ? 'opacity-70 border border-dashed border-cocoa/10' : 'border border-white/50 shadow-sm'
                ]"
                :style="{ top: booking.top + 'px', height: booking.height + 'px' }"
              >
                <p class="text-[10px] font-bold text-espresso leading-tight truncate">{{ booking.client }}</p>
                <p class="text-[9px] text-cocoa/60">{{ booking.timeRange }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Booking detail panel -->
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
            <h3 class="row-primary text-base">Détails RDV</h3>
            <button @click="selectedBookingId = null" class="p-2 hover:bg-neutral-bg rounded-full transition">
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <div class="flex-1 overflow-y-auto p-6 space-y-8">
            <div class="flex items-center justify-between gap-4">
              <span :class="['px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest', statusStyles[selectedBooking.status]]">
                {{ statusLabels[selectedBooking.status] }}
              </span>
              <button @click="advanceStatus" class="btn-primary flex-1 py-2 text-[10px]">
                {{ nextActionLabels[selectedBooking.status] }}
              </button>
            </div>

            <div class="space-y-4">
              <label class="section-label">Client</label>
              <div class="flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-sand flex items-center justify-center font-bold text-espresso text-lg">
                  {{ selectedBooking.clientInitials }}
                </div>
                <div>
                  <p class="font-bold text-espresso">{{ selectedBooking.client }}</p>
                  <p class="text-xs text-cocoa/60">{{ selectedBooking.phone ?? "Contact indisponible" }}</p>
                </div>
              </div>
            </div>

            <div class="space-y-4">
              <label class="section-label">Prestation</label>
              <div class="panel-clean p-4 border-dashed bg-neutral-bg/30">
                <p class="font-bold text-sm text-espresso mb-1">{{ selectedBooking.service }}</p>
                <p class="text-xs text-cocoa/60">{{ selectedBooking.timeRange }} • {{ selectedBooking.duration }} min</p>
                <p class="text-sm font-bold text-primary mt-3">{{ selectedBooking.price }} FCFA</p>
              </div>
            </div>

            <div class="space-y-4">
              <label class="section-label">Source</label>
              <p class="text-sm text-cocoa/60 italic leading-relaxed">Réservation {{ selectedBooking.source }}</p>
            </div>
          </div>

          <div v-if="selectedBooking.status === 'in_progress'" class="p-6 border-t border-outline-variant bg-primary/5">
            <RouterLink :to="`/pro/checkout/${selectedBooking.id}`" class="btn-primary w-full py-4 text-sm">ENCAISSER</RouterLink>
          </div>
        </div>
      </transition>

      <!-- Blocked slot detail panel -->
      <transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="translate-x-full"
        enter-to-class="translate-x-0"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="translate-x-0"
        leave-to-class="translate-x-full"
      >
        <div v-if="selectedBlockedSlot && !selectedBooking" class="w-80 shrink-0 bg-surface border-l border-outline-variant shadow-2xl z-30 flex flex-col">
          <div class="p-6 border-b border-outline-variant flex items-center justify-between">
            <h3 class="row-primary text-base">Créneau bloqué</h3>
            <button @click="selectedBlockedSlotId = null" class="p-2 hover:bg-neutral-bg rounded-full transition">
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <div class="flex-1 overflow-y-auto p-6 space-y-6">
            <div class="panel-clean p-4 bg-error/5 border-error/10">
              <div class="flex items-center gap-2 mb-3">
                <div class="w-3 h-3 rounded-full bg-error"></div>
                <span class="text-[10px] font-bold uppercase tracking-widest text-error">Bloqué</span>
              </div>
              <p class="row-primary mb-1">{{ selectedBlockedSlot.timeRange }}</p>
              <p class="row-meta">{{ selectedBlockedSlot.dateLabel }}</p>
            </div>

            <div v-if="selectedBlockedSlot.reason" class="space-y-2">
              <label class="section-label">Motif</label>
              <p class="text-sm text-cocoa/60 italic">{{ selectedBlockedSlot.reason }}</p>
            </div>

            <div class="space-y-2">
              <label class="section-label">Portée</label>
              <p class="text-sm text-espresso">{{ selectedBlockedSlot.scope === 'salon' ? 'Tout le salon' : 'Employé spécifique' }}</p>
            </div>
          </div>

          <div class="p-6 border-t border-outline-variant">
            <button
              @click="deleteSelectedBlockedSlot"
              :disabled="deleteBlockedSlotMutation.isPending.value"
              class="flex w-full items-center justify-center gap-2 rounded-xl px-4 py-3 text-sm font-bold text-error transition hover:bg-error/5 disabled:opacity-60 border border-error/20"
            >
              <TrashIcon class="w-4 h-4" />
              {{ deleteBlockedSlotMutation.isPending.value ? 'Suppression...' : 'Supprimer ce créneau' }}
            </button>
          </div>
        </div>
      </transition>

      <button @click="openCreateModal('manual')" class="absolute bottom-6 right-6 w-14 h-14 bg-primary text-white rounded-full shadow-lg flex items-center justify-center hover:scale-110 active:scale-95 transition-all z-10">
        <PlusIcon class="w-7 h-7" />
      </button>
    </div>

    <Modal
      :show="showCreateModal"
      :title="composeMode === 'manual' ? 'Nouveau RDV manuel' : 'Bloquer un créneau'"
      :subtitle="composeMode === 'manual' ? 'Créez un rendez-vous confirmé immédiatement.' : 'Empêchez les réservations sur une plage précise.'"
      max-width="lg"
      @close="closeCreateModal"
    >
      <div class="space-y-4">
        <div class="flex gap-2">
          <button
            @click="composeMode = 'manual'"
            :class="['btn-secondary ring-0 border px-4 py-2 text-[11px]', composeMode === 'manual' ? '!bg-primary/10 !text-primary !border-primary/20' : '']"
          >
            RDV manuel
          </button>
          <button
            @click="composeMode = 'blocked'"
            :class="['btn-secondary ring-0 border px-4 py-2 text-[11px]', composeMode === 'blocked' ? '!bg-primary/10 !text-primary !border-primary/20' : '']"
          >
            Créneau bloqué
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="section-label mb-2 block">Début</label>
            <input v-model="composeForm.startsAt" type="datetime-local" class="input-shell" />
          </div>
          <div v-if="composeMode === 'blocked'">
            <label class="section-label mb-2 block">Fin</label>
            <input v-model="composeForm.blockEndsAt" type="datetime-local" class="input-shell" />
          </div>
          <div v-if="composeMode === 'manual'">
            <label class="section-label mb-2 block">Service</label>
            <select v-model="composeForm.serviceId" class="input-shell">
              <option value="">Sélectionner</option>
              <option v-for="service in servicesQuery.data.value ?? []" :key="service.id" :value="service.id">{{ service.name }}</option>
            </select>
          </div>
          <div>
            <label class="section-label mb-2 block">Employé</label>
            <select v-model="composeForm.employeeId" class="input-shell">
              <option value="">Non assigné</option>
              <option v-for="staff in staffMembers" :key="staff.id" :value="staff.id">{{ staff.name }}</option>
            </select>
          </div>
          <template v-if="composeMode === 'manual'">
            <div class="md:col-span-2">
              <label class="section-label mb-2 block">Client</label>
              
              <div v-if="composeForm.clientId" class="flex items-center justify-between p-3 bg-neutral-bg/50 border border-outline-variant/50 rounded-xl mb-3">
                <div>
                  <div class="font-bold text-espresso text-sm">{{ composeForm.clientName }}</div>
                  <div class="text-xs text-cocoa/60">{{ composeForm.clientPhone }}</div>
                </div>
                <button @click="clearClientSelection" class="p-1 text-cocoa/60 hover:text-error hover:bg-error/5 rounded-full transition-colors">
                  <XMarkIcon class="w-5 h-5" />
                </button>
              </div>

              <div v-else class="relative mb-3">
                <div class="relative">
                  <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-cocoa/40" />
                  <input 
                    v-model="clientSearchText" 
                    @focus="isClientDropdownOpen = true"
                    @blur="isClientDropdownOpen = false"
                    class="input-shell pl-9" 
                    placeholder="Rechercher un client (nom ou téléphone)..." 
                  />
                </div>
                
                <div v-if="isClientDropdownOpen" class="absolute z-50 w-full mt-1 bg-white border border-outline-variant shadow-xl rounded-xl max-h-60 overflow-y-auto py-1">
                  <div v-if="filteredDropdownClients.length === 0" class="px-4 py-3 text-sm text-cocoa/60 text-center">
                    Aucun client trouvé pour "{{ clientSearchText }}"
                  </div>
                  <button 
                    v-for="client in filteredDropdownClients" 
                    :key="client.id" 
                    @mousedown.prevent="selectClientDropdown(client)" 
                    class="w-full text-left px-4 py-2 hover:bg-neutral-bg/50 focus:bg-neutral-bg/50 transition-colors flex flex-col"
                  >
                    <span class="font-bold text-espresso text-sm">{{ client.fullName }}</span>
                    <span class="text-xs text-cocoa/60">{{ client.phone ?? "Pas de téléphone" }}</span>
                  </button>
                  <div class="border-t border-outline-variant/30 mt-1 pt-1">
                    <button @mousedown.prevent="isClientDropdownOpen = false" class="w-full text-left px-4 py-2 text-primary font-semibold text-sm hover:bg-primary/5 transition-colors">
                      + Nouveau client manuellement
                    </button>
                  </div>
                </div>
              </div>

              <div v-if="!composeForm.clientId" class="grid grid-cols-1 md:grid-cols-2 gap-4 bg-neutral-bg/30 p-4 rounded-xl border border-dashed border-cocoa/10">
                <div>
                  <label class="text-[10px] font-bold uppercase text-cocoa/40 mb-1 block">Nom complet</label>
                  <input v-model="composeForm.clientName" class="input-shell bg-white" placeholder="Fatou Diop" />
                </div>
                <div>
                  <label class="text-[10px] font-bold uppercase text-cocoa/40 mb-1 block">Téléphone</label>
                  <input v-model="composeForm.clientPhone" class="input-shell bg-white" placeholder="+221771234567" />
                </div>
              </div>
            </div>
          </template>
          <div v-if="composeMode === 'blocked'" class="md:col-span-2">
            <label class="section-label mb-2 block">Motif</label>
            <input v-model="composeForm.blockReason" class="input-shell" placeholder="Pause, maintenance, formation..." />
          </div>
        </div>
      </div>

      <template #footer>
        <div class="flex items-center justify-end gap-2">
          <button @click="closeCreateModal" class="btn-secondary">Annuler</button>
          <button :disabled="createPending" @click="submitCompose" class="btn-primary disabled:opacity-60">
            {{ createPending ? 'Enregistrement...' : composeMode === 'manual' ? 'Créer le RDV' : 'Bloquer le créneau' }}
          </button>
        </div>
      </template>
    </Modal>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { refDebounced } from "@vueuse/core";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import {
  ChevronLeftIcon,
  ChevronRightIcon,
  XMarkIcon,
  PlusIcon,
  TrashIcon,
  MagnifyingGlassIcon
} from "@heroicons/vue/24/outline";
import {
  acceptProBooking,
  createManualProBooking,
  createProBlockedSlot,
  deleteProBlockedSlot,
  fetchProBlockedSlots,
  fetchProBookings,
  fetchProClients,
  fetchProServices,
  fetchProStaff,
  startProBooking
} from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";
import Modal from "@/components/Modal.vue";
import type { ProBlockedSlot, ProBookingDetail } from "@/lib/generated";

const auth = useProAuthStore();
const route = useRoute();
const router = useRouter();
const queryClient = useQueryClient();

const tones = [
  "bg-primary/10 text-primary",
  "bg-secondary/10 text-secondary",
  "bg-primary/15 text-primary",
  "bg-secondary/15 text-secondary",
  "bg-primary/20 text-primary"
];

const hours = ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00"];
const DAY_START_HOUR = 9;
const SLOT_HEIGHT_PX = 80;

const viewMode = ref<"day" | "week">("day");
const currentDate = ref(dayjs());
const statusFilter = ref<"all" | "pending" | "confirmed" | "in_progress" | "completed" | "cancelled">("all");
const selectedEmployeeId = ref<string>("all");
const selectedBookingId = ref<string | null>(null);
const selectedBlockedSlotId = ref<string | null>(null);

const showCreateModal = ref(false);
const composeMode = ref<"manual" | "blocked">("manual");
const composeForm = reactive({
  serviceId: "",
  employeeId: "",
  startsAt: dayjs().add(1, "hour").minute(0).second(0).millisecond(0).format("YYYY-MM-DDTHH:mm"),
  clientId: "",
  clientName: "",
  clientPhone: "",
  blockEndsAt: dayjs().add(2, "hour").minute(0).second(0).millisecond(0).format("YYYY-MM-DDTHH:mm"),
  blockReason: ""
});

const clientSearchText = ref("");
const debouncedClientSearch = refDebounced(clientSearchText, 300);
const isClientDropdownOpen = ref(false);

const filteredDropdownClients = computed(() => {
  return (clientsQuery.data.value ?? []).slice(0, 10);
});

function selectClientDropdown(client: any) {
  composeForm.clientId = client.id;
  composeForm.clientName = client.fullName;
  composeForm.clientPhone = client.phone ?? "";
  clientSearchText.value = "";
  isClientDropdownOpen.value = false;
}

function clearClientSelection() {
  composeForm.clientId = "";
  composeForm.clientName = "";
  composeForm.clientPhone = "";
  clientSearchText.value = "";
}

// ── Date helpers ──────────────────────────────────────────────────────────────

const dateKey = computed(() => currentDate.value.format("YYYY-MM-DD"));
const weekStart = computed(() => currentDate.value.startOf("week"));
const weekDayKeys = computed(() =>
  [0, 1, 2, 3, 4, 5, 6].map((offset) => weekStart.value.add(offset, "day").format("YYYY-MM-DD"))
);

// ── Queries ───────────────────────────────────────────────────────────────────

const servicesQuery = useQuery({
  queryKey: ["pro-services", "calendar"],
  queryFn: () => fetchProServices(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const staffQuery = useQuery({
  queryKey: ["pro-staff", "calendar"],
  queryFn: () => fetchProStaff(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isManager))
});

const clientsQuery = useQuery({
  queryKey: computed(() => ["pro-clients", "selector", debouncedClientSearch.value.trim()]),
  queryFn: () => fetchProClients(auth.accessToken ?? "", debouncedClientSearch.value.trim() || undefined),
  enabled: computed(() => Boolean(auth.accessToken))
});

const bookingsQuery = useQuery({
  queryKey: computed(() => ["pro-bookings", "calendar", dateKey.value, statusFilter.value]),
  queryFn: () =>
    fetchProBookings(auth.accessToken ?? "", {
      date: dateKey.value,
      status: statusFilter.value === "all" ? undefined : statusFilter.value,
      page: 0,
      pageSize: 200
    }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "day")
});

// Seven fixed week-day queries — enabled only in week mode
const weekD0Query = useQuery({
  queryKey: computed(() => ["pro-bookings", "week", weekDayKeys.value[0], statusFilter.value]),
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { date: weekDayKeys.value[0], status: statusFilter.value === "all" ? undefined : statusFilter.value, page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "week")
});
const weekD1Query = useQuery({
  queryKey: computed(() => ["pro-bookings", "week", weekDayKeys.value[1], statusFilter.value]),
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { date: weekDayKeys.value[1], status: statusFilter.value === "all" ? undefined : statusFilter.value, page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "week")
});
const weekD2Query = useQuery({
  queryKey: computed(() => ["pro-bookings", "week", weekDayKeys.value[2], statusFilter.value]),
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { date: weekDayKeys.value[2], status: statusFilter.value === "all" ? undefined : statusFilter.value, page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "week")
});
const weekD3Query = useQuery({
  queryKey: computed(() => ["pro-bookings", "week", weekDayKeys.value[3], statusFilter.value]),
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { date: weekDayKeys.value[3], status: statusFilter.value === "all" ? undefined : statusFilter.value, page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "week")
});
const weekD4Query = useQuery({
  queryKey: computed(() => ["pro-bookings", "week", weekDayKeys.value[4], statusFilter.value]),
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { date: weekDayKeys.value[4], status: statusFilter.value === "all" ? undefined : statusFilter.value, page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "week")
});
const weekD5Query = useQuery({
  queryKey: computed(() => ["pro-bookings", "week", weekDayKeys.value[5], statusFilter.value]),
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { date: weekDayKeys.value[5], status: statusFilter.value === "all" ? undefined : statusFilter.value, page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "week")
});
const weekD6Query = useQuery({
  queryKey: computed(() => ["pro-bookings", "week", weekDayKeys.value[6], statusFilter.value]),
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { date: weekDayKeys.value[6], status: statusFilter.value === "all" ? undefined : statusFilter.value, page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken) && viewMode.value === "week")
});

const blockedSlotsQuery = useQuery({
  queryKey: ["pro-blocked-slots"],
  queryFn: () => fetchProBlockedSlots(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

// ── Mutations ─────────────────────────────────────────────────────────────────

const acceptMutation = useMutation({
  mutationFn: (bookingId: string) => acceptProBooking(auth.accessToken ?? "", bookingId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-bookings"] });
    toast.success("Réservation confirmée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Action impossible pour le moment."));
  }
});

const startMutation = useMutation({
  mutationFn: (bookingId: string) => startProBooking(auth.accessToken ?? "", bookingId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-bookings"] });
    toast.success("Service démarré.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Action impossible pour le moment."));
  }
});

const manualBookingMutation = useMutation({
  mutationFn: () =>
    createManualProBooking(auth.accessToken ?? "", {
      clientId: composeForm.clientId || undefined,
      serviceId: composeForm.serviceId,
      employeeId: composeForm.employeeId || undefined,
      startsAt: new Date(composeForm.startsAt),
      clientName: composeForm.clientId ? undefined : (composeForm.clientName.trim() || undefined),
      clientPhone: composeForm.clientId ? undefined : (composeForm.clientPhone.trim() || undefined)
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-bookings"] });
    await queryClient.invalidateQueries({ queryKey: ["pro-clients"] });
    toast.success("Rendez-vous manuel créé.");
    closeCreateModal();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Création impossible pour le moment."));
  }
});

const blockedSlotMutation = useMutation({
  mutationFn: () =>
    createProBlockedSlot(auth.accessToken ?? "", {
      startsAt: new Date(composeForm.startsAt),
      endsAt: new Date(composeForm.blockEndsAt),
      reason: composeForm.blockReason.trim() || undefined,
      scope: composeForm.employeeId ? "employee" : "salon",
      employeeId: composeForm.employeeId || undefined
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-blocked-slots"] });
    toast.success("Créneau bloqué.");
    closeCreateModal();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Blocage impossible pour le moment."));
  }
});

const deleteBlockedSlotMutation = useMutation({
  mutationFn: (slotId: string) => deleteProBlockedSlot(auth.accessToken ?? "", slotId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-blocked-slots"] });
    selectedBlockedSlotId.value = null;
    toast.success("Créneau bloqué supprimé.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Suppression impossible pour le moment."));
  }
});

// ── Staff ─────────────────────────────────────────────────────────────────────

const staffMembers = computed(() => {
  const apiStaff = staffQuery.data.value ?? [];
  const mapped = apiStaff.map((staff, index) => ({
    id: staff.id,
    name: staff.displayName,
    initials: staff.displayName
      .split(" ")
      .slice(0, 2)
      .map((part) => part[0]?.toUpperCase() ?? "")
      .join(""),
    role: staff.isActive ? "Actif" : "Inactif",
    tone: tones[index % tones.length]
  }));

  if (mapped.length > 0) return mapped;

  const bookingPeople = Array.from(
    new Set((bookingsQuery.data.value ?? []).map((booking) => booking.employeeName).filter(Boolean))
  ) as string[];

  if (bookingPeople.length === 0) {
    return [{ id: "unassigned", name: "Équipe salon", initials: "ES", role: "Agenda", tone: tones[0] }];
  }

  return bookingPeople.map((name, index) => ({
    id: `fallback-${index}`,
    name,
    initials: name.split(" ").slice(0, 2).map((part) => part[0]?.toUpperCase() ?? "").join(""),
    role: "Équipe",
    tone: tones[index % tones.length]
  }));
});

const displayedStaffMembers = computed(() => {
  if (selectedEmployeeId.value === "all") return staffMembers.value;
  const filtered = staffMembers.value.filter((staff) => staff.id === selectedEmployeeId.value);
  return filtered.length > 0 ? filtered : staffMembers.value;
});

const staffToneById = computed(() => new Map(staffMembers.value.map((staff) => [staff.id, staff.tone])));

// ── Booking mapping ───────────────────────────────────────────────────────────

function mapBooking(booking: ProBookingDetail) {
  const start = dayjs(booking.startsAt);
  const end = dayjs(booking.endsAt);
  const startMinutes = start.hour() * 60 + start.minute();
  const top = Math.max(0, ((startMinutes - DAY_START_HOUR * 60) / 60) * SLOT_HEIGHT_PX);
  const durationMinutes = Math.max(30, end.diff(start, "minute"));
  const height = Math.max(40, (durationMinutes / 60) * SLOT_HEIGHT_PX);
  const fallbackStaffId = staffMembers.value[0]?.id ?? "unassigned";
  const staffId = booking.employeeId ?? fallbackStaffId;
  const client = booking.clientName ?? "Client";
  return {
    id: booking.id,
    staffId,
    top,
    height,
    category: booking.serviceName.split(" ")[0]?.toUpperCase() ?? "SERVICE",
    client,
    clientInitials: client.split(" ").slice(0, 2).map((part) => part[0]?.toUpperCase() ?? "").join(""),
    phone: booking.clientPhone ?? null,
    service: booking.serviceName,
    timeRange: `${start.format("HH:mm")} – ${end.format("HH:mm")}`,
    duration: durationMinutes,
    price: formatMoneyXof(booking.depositAmountXof),
    source: booking.source,
    status: booking.status,
    tone: (staffToneById.value.get(staffId) ?? tones[0]).replace("100", "50")
  };
}

// ── Blocked slot mapping ──────────────────────────────────────────────────────

function mapBlockedSlot(slot: ProBlockedSlot) {
  const start = dayjs(slot.startsAt);
  const end = dayjs(slot.endsAt);
  const startMinutes = start.hour() * 60 + start.minute();
  const top = Math.max(0, ((startMinutes - DAY_START_HOUR * 60) / 60) * SLOT_HEIGHT_PX);
  const durationMinutes = Math.max(30, end.diff(start, "minute"));
  const height = Math.max(40, (durationMinutes / 60) * SLOT_HEIGHT_PX);
  return {
    id: slot.id,
    top,
    height,
    reason: slot.reason ?? null,
    scope: slot.scope,
    employeeId: slot.employeeId ?? null,
    timeRange: `${start.format("HH:mm")} – ${end.format("HH:mm")}`,
    dateStr: start.format("YYYY-MM-DD"),
    dateLabel: start.format("dddd DD MMMM YYYY")
  };
}

// ── Computed views ────────────────────────────────────────────────────────────

const bookings = computed(() =>
  (bookingsQuery.data.value ?? [])
    .map(mapBooking)
    .filter((b) => selectedEmployeeId.value === "all" || b.staffId === selectedEmployeeId.value)
);

const weekBookingsByDate = computed(() => {
  const queries = [weekD0Query, weekD1Query, weekD2Query, weekD3Query, weekD4Query, weekD5Query, weekD6Query];
  const result: Record<string, ReturnType<typeof mapBooking>[]> = {};
  queries.forEach((q, offset) => {
    const dateStr = weekDayKeys.value[offset];
    const rows = (q.data.value ?? []).map(mapBooking);
    result[dateStr] = selectedEmployeeId.value === "all"
      ? rows
      : rows.filter((b) => b.staffId === selectedEmployeeId.value);
  });
  return result;
});

const allBlockedSlots = computed(() =>
  (blockedSlotsQuery.data.value ?? []).map(mapBlockedSlot)
);

const dayModeBlockedSlots = computed(() =>
  allBlockedSlots.value.filter((slot) => slot.dateStr === dateKey.value)
);

const weekModeBlockedSlotsByDate = computed(() => {
  const byDate: Record<string, ReturnType<typeof mapBlockedSlot>[]> = {};
  for (const dateStr of weekDayKeys.value) {
    byDate[dateStr] = allBlockedSlots.value.filter((slot) => slot.dateStr === dateStr);
  }
  return byDate;
});

const weekDays = computed(() =>
  weekDayKeys.value.map((dateStr) => {
    const d = dayjs(dateStr);
    return {
      dateStr,
      weekLabel: d.format("ddd").toUpperCase(),
      dayLabel: d.format("D MMM"),
      isToday: d.isSame(dayjs(), "day")
    };
  })
);

const selectedBooking = computed(() => {
  const fromDay = bookings.value.find((b) => b.id === selectedBookingId.value);
  if (fromDay) return fromDay;
  if (viewMode.value === "week") {
    return Object.values(weekBookingsByDate.value).flat().find((b) => b.id === selectedBookingId.value) ?? null;
  }
  return null;
});

const selectedBlockedSlot = computed(() =>
  allBlockedSlots.value.find((s) => s.id === selectedBlockedSlotId.value) ?? null
);

const calendarLabel = computed(() => {
  if (viewMode.value === "week") {
    const start = weekStart.value;
    const end = start.add(6, "day");
    return `Semaine ${start.format("DD MMM")} - ${end.format("DD MMM YYYY")}`;
  }
  return currentDate.value.format("dddd DD MMMM YYYY");
});

const createPending = computed(() => manualBookingMutation.isPending.value || blockedSlotMutation.isPending.value);

const statusLabels: Record<string, string> = {
  pending: "En attente",
  confirmed: "Confirmé",
  in_progress: "En cours",
  completed: "Terminé",
  cancelled: "Annulé"
};

const statusStyles: Record<string, string> = {
  pending: "bg-secondary/10 text-secondary border border-secondary/20",
  confirmed: "bg-primary/10 text-primary border border-primary/20",
  in_progress: "bg-primary/15 text-primary border border-primary/25",
  completed: "bg-neutral-bg text-cocoa/60 border border-outline-variant",
  cancelled: "bg-error/5 text-error border border-error/10"
};

const nextActionLabels: Record<string, string> = {
  pending: "Confirmer",
  confirmed: "Démarrer",
  in_progress: "Encaisser",
  completed: "Archiver",
  cancelled: "Archivé"
};

// ── Actions ───────────────────────────────────────────────────────────────────

function goToday() { currentDate.value = dayjs(); }
function goPrevious() { currentDate.value = currentDate.value.subtract(viewMode.value === "week" ? 7 : 1, "day"); }
function goNext() { currentDate.value = currentDate.value.add(viewMode.value === "week" ? 7 : 1, "day"); }

function getStaffBookings(staffId: string) {
  return bookings.value.filter((b) => b.staffId === staffId);
}

function getWeekDayBookings(dateStr: string) {
  return weekBookingsByDate.value[dateStr] ?? [];
}

function getWeekDayBlockedSlots(dateStr: string) {
  return weekModeBlockedSlotsByDate.value[dateStr] ?? [];
}

async function advanceStatus() {
  if (!selectedBooking.value) return;
  const status = selectedBooking.value.status;
  if (status === "pending") { acceptMutation.mutate(selectedBooking.value.id); return; }
  if (status === "confirmed") { startMutation.mutate(selectedBooking.value.id); return; }
  if (status === "in_progress") { await router.push(`/pro/checkout/${selectedBooking.value.id}`); return; }
  toast.info("Ce rendez-vous est déjà terminé.");
}

function deleteSelectedBlockedSlot() {
  if (!selectedBlockedSlotId.value) return;
  deleteBlockedSlotMutation.mutate(selectedBlockedSlotId.value);
}

function resetComposeForm() {
  composeForm.serviceId = "";
  composeForm.employeeId = "";
  composeForm.startsAt = dayjs().add(1, "hour").minute(0).second(0).millisecond(0).format("YYYY-MM-DDTHH:mm");
  composeForm.clientId = "";
  composeForm.clientName = "";
  composeForm.clientPhone = "";
  composeForm.blockEndsAt = dayjs().add(2, "hour").minute(0).second(0).millisecond(0).format("YYYY-MM-DDTHH:mm");
  composeForm.blockReason = "";
}

function openCreateModal(mode: "manual" | "blocked") {
  composeMode.value = mode;
  showCreateModal.value = true;
}

function closeCreateModal() {
  showCreateModal.value = false;
  resetComposeForm();
}

function submitCompose() {
  if (!composeForm.startsAt) { toast.error("La date de début est requise."); return; }
  if (composeMode.value === "manual") {
    if (!composeForm.serviceId) { toast.error("Sélectionnez un service."); return; }
    if (!composeForm.clientId && !composeForm.clientPhone) {
      toast.error("Sélectionnez un client ou entrez un numéro de téléphone.");
      return;
    }
    manualBookingMutation.mutate();
    return;
  }
  if (!composeForm.blockEndsAt) { toast.error("La date de fin est requise."); return; }
  if (new Date(composeForm.blockEndsAt).getTime() <= new Date(composeForm.startsAt).getTime()) {
    toast.error("La fin doit être après le début.");
    return;
  }
  blockedSlotMutation.mutate();
}

// ── Watchers ──────────────────────────────────────────────────────────────────

watch(
  () => bookings.value,
  (rows) => {
    if (!rows.length) { selectedBookingId.value = null; return; }
    const targetBookingId = typeof route.query.bookingId === "string" ? route.query.bookingId : null;
    if (targetBookingId && rows.some((row) => row.id === targetBookingId)) {
      selectedBookingId.value = targetBookingId;
      return;
    }
    if (!selectedBookingId.value || !rows.some((row) => row.id === selectedBookingId.value)) {
      selectedBookingId.value = rows[0].id;
    }
  },
  { immediate: true }
);

// Staff members only see their own bookings — auto-set filter on load
watch(
  () => auth.isManager,
  (isManager) => {
    if (!isManager && auth.currentUser?.id) {
      // Find the employee ID linked to this user ID
      const me = staffMembers.value.find(s => s.id === auth.currentUser?.id || s.name === auth.currentUser?.fullName);
      if (me) {
        selectedEmployeeId.value = me.id;
      } else {
        // Fallback to current user ID which is often the employee ID in this context
        selectedEmployeeId.value = auth.currentUser?.id ?? "all";
      }
    }
  },
  { immediate: true }
);

watch(
  () => route.query,
  (query) => {
    if (typeof query.employeeId === "string") selectedEmployeeId.value = query.employeeId;
    if (typeof query.compose === "string" && (query.compose === "manual" || query.compose === "blocked")) {
      openCreateModal(query.compose);
      composeMode.value = query.compose;
      if (typeof query.clientId === "string") composeForm.clientId = query.clientId;
      if (typeof query.clientName === "string") composeForm.clientName = query.clientName;
      if (typeof query.clientPhone === "string") composeForm.clientPhone = query.clientPhone;
    }
  },
  { immediate: true }
);
</script>
