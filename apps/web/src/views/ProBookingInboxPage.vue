<template>
  <div>
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Inbox Réservations</h1>
        <p class="text-cocoa/60">Gérez vos demandes entrantes et à venir.</p>
      </div>
      <button @click="newBooking" class="btn-primary gap-2">
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
            <p class="text-sm font-bold text-espresso">{{ booking.price }}</p>
            <p class="text-[10px] text-cocoa/40 font-semibold uppercase tracking-widest">Payé: {{ booking.deposit }}</p>
          </div>
        </div>

        <!-- Pagination -->
        <div v-if="(bookingsQuery.data.value?.total ?? 0) > 50" class="flex items-center justify-between px-4 py-3 panel-clean">
          <p class="text-[12px] text-cocoa/60">
            {{ bookingsQuery.data.value?.total ?? 0 }} réservation{{ (bookingsQuery.data.value?.total ?? 0) > 1 ? 's' : '' }}
          </p>
          <p class="text-[11px] text-cocoa/40 italic">Affiche les 50 plus récentes</p>
        </div>
      </div>

      <!-- Detail Panel (Fixed on desktop) -->
      <div class="hidden lg:block">
        <div v-if="selectedBooking" class="panel-clean p-8 sticky top-32">
          <div class="text-center mb-8">
            <div class="w-20 h-20 rounded-full bg-primary/5 mx-auto flex items-center justify-center font-bold text-3xl text-primary mb-4 border border-primary/10">
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
            <button :disabled="actionLoading" @click="rejectBooking" class="btn-secondary py-3 ring-0 border text-[11px] disabled:opacity-60">Refuser</button>
            <button :disabled="actionLoading" @click="acceptBooking" class="btn-primary py-3 text-[11px] disabled:opacity-60">Accepter</button>
          </div>
          <button v-else @click="viewInCalendar" class="btn-secondary w-full py-3 ring-0 border text-[11px]">Voir dans l'agenda</button>
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
import { ref, computed, watch } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { useRoute, useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { PlusIcon, InboxIcon } from "@heroicons/vue/24/outline";
import { getErrorMessage } from "@/lib/errors";
import {
  acceptProBooking,
  fetchProBooking,
  fetchProBookings,
  rejectProBooking
} from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";

const filters = ["Tous", "En attente", "Confirmés", "Aujourd'hui", "Cette semaine"];
const activeFilter = ref("Tous");
const selectedId = ref<string | null>(null);
const route = useRoute();
const router = useRouter();
const auth = useProAuthStore();
const queryClient = useQueryClient();

const bookingsQuery = useQuery({
  queryKey: ["pro-bookings", "inbox"],
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { page: 0, pageSize: 50 }),
  enabled: computed(() => Boolean(auth.accessToken))
});

const acceptMutation = useMutation({
  mutationFn: (bookingId: string) => acceptProBooking(auth.accessToken ?? "", bookingId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-bookings"] });
    toast.success("Réservation acceptée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Action impossible pour le moment."));
  }
});

const rejectMutation = useMutation({
  mutationFn: (bookingId: string) => rejectProBooking(auth.accessToken ?? "", bookingId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-bookings"] });
    toast.info("Réservation refusée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Action impossible pour le moment."));
  }
});

const actionLoading = computed(() => acceptMutation.isPending.value || rejectMutation.isPending.value);

const selectedBookingQuery = useQuery({
  queryKey: computed(() => ["pro-booking", selectedId.value]),
  queryFn: () => fetchProBooking(auth.accessToken ?? "", selectedId.value ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && selectedId.value))
});

const bookingRows = computed(() => {
  return (bookingsQuery.data.value?.items ?? []).map((booking) => {
    const startsAt = dayjs(booking.startsAt);
    const clientName = booking.clientName ?? "Client";
    return {
      id: booking.id,
      day: startsAt.format("ddd").toUpperCase(),
      date: startsAt.format("DD"),
      time: startsAt.format("HH:mm"),
      client: clientName,
      clientInitials: clientName
        .split(" ")
        .slice(0, 2)
        .map((name) => name[0]?.toUpperCase() ?? "")
        .join(""),
      phone: booking.clientPhone ?? "Non renseigné",
      service: booking.serviceName,
      staff: booking.employeeName ?? "Non assigné",
      fullDate: startsAt.format("dddd DD MMMM"),
      price: formatMoneyXof(Math.max(booking.depositAmountXof, 0)),
      deposit: formatMoneyXof(booking.depositAmountXof),
      status: booking.status,
      startsAt
    };
  });
});

const filteredBookings = computed(() => {
  if (activeFilter.value === "Tous") return bookingRows.value;
  if (activeFilter.value === "En attente") return bookingRows.value.filter((booking) => booking.status === "pending");
  if (activeFilter.value === "Confirmés") return bookingRows.value.filter((booking) => booking.status === "confirmed");
  if (activeFilter.value === "Aujourd'hui") {
    return bookingRows.value.filter((booking) => booking.startsAt.isSame(dayjs(), "day"));
  }
  if (activeFilter.value === "Cette semaine") {
    const start = dayjs().startOf("day");
    const end = dayjs().add(7, "day").endOf("day");
    return bookingRows.value.filter((booking) => booking.startsAt.isAfter(start) && booking.startsAt.isBefore(end));
  }
  return bookingRows.value;
});

const selectedBooking = computed(() => {
  const booking = filteredBookings.value.find((value) => value.id === selectedId.value)
    ?? bookingRows.value.find((value) => value.id === selectedId.value);
  if (!booking) return null;

  const detailed = selectedBookingQuery.data.value;
  return {
    ...booking,
    phone: detailed?.clientPhone ?? booking.phone,
    status: detailed?.status ?? booking.status
  };
});

const statusLabels: Record<string, string> = {
  pending: "En attente",
  confirmed: "Confirmé",
  in_progress: "En cours",
  completed: "Terminé",
  cancelled: "Annulé"
};

const statusStyles: Record<string, string> = {
  pending: "bg-secondary/10 text-secondary",
  confirmed: "bg-primary/10 text-primary",
  in_progress: "bg-primary/15 text-primary",
  completed: "bg-neutral-bg text-cocoa/60",
  cancelled: "bg-error/5 text-error"
};

function acceptBooking() {
  if (selectedBooking.value?.id) {
    acceptMutation.mutate(selectedBooking.value.id);
  }
}

function rejectBooking() {
  if (selectedBooking.value?.id) {
    rejectMutation.mutate(selectedBooking.value.id);
  }
}

function newBooking() {
  void router.push({ path: "/pro/calendar", query: { compose: "manual" } });
}

function viewInCalendar() {
  if (!selectedBooking.value?.id) return;
  void router.push({
    path: "/pro/calendar",
    query: { bookingId: selectedBooking.value.id }
  });
}

watch(
  () => filteredBookings.value,
  (rows) => {
    if (!rows.length) {
      selectedId.value = null;
      return;
    }
    if (!selectedId.value || !rows.some((row) => row.id === selectedId.value)) {
      selectedId.value = rows[0].id;
    }
  },
  { immediate: true }
);

watch(
  () => route.query.bookingId,
  (bookingId) => {
    if (typeof bookingId === "string" && bookingRows.value.some((row) => row.id === bookingId)) {
      selectedId.value = bookingId;
    }
  },
  { immediate: true }
);
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
