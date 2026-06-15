<template>
  <div>
    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-2">Ventes & Versements</h1>
        <p class="text-cocoa/60">Suivez vos revenus encaissés et vos virements à venir.</p>
      </div>
      <div class="flex items-center gap-2">
        <select v-model="period" class="input-shell py-2 min-w-[150px]">
          <option value="30d">Derniers 30 jours</option>
          <option value="last-month">Mois dernier</option>
          <option value="all">Tout</option>
        </select>
        <button @click="printStatement" class="btn-secondary px-4 py-2 ring-0 border flex items-center gap-2">
          <ArrowDownTrayIcon class="w-4 h-4" />
          Relevé PDF
        </button>
      </div>
    </div>

    <!-- Payout KPIs -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-secondary shadow-sm">
        <p class="metric-label mb-2">En attente de versement</p>
        <p class="metric-value text-secondary">{{ pendingAmountLabel }}</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Fonds bloqués en attente</p>
      </div>
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-primary shadow-sm">
        <p class="metric-label mb-2">Déjà versé (30 jrs)</p>
        <p class="metric-value text-espresso">{{ releasedAmountLabel }}</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Total {{ releasedCount }} versements</p>
      </div>
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-cocoa/20 shadow-sm">
        <p class="metric-label mb-2">Frais de plateforme</p>
        <p class="metric-value text-cocoa/40">{{ refundedAmountLabel }}</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Montants remboursés</p>
      </div>
    </div>

    <div class="panel-clean overflow-hidden">
      <div class="p-8 border-b border-outline-variant/30 flex items-center justify-between">
        <h2 class="section-label">Transactions récentes</h2>
        <div class="flex gap-2">
          <span class="flex items-center gap-1.5 text-[10px] font-bold text-cocoa/40">
            <div class="w-2 h-2 rounded-full bg-primary"></div> Terminé
          </span>
          <span class="flex items-center gap-1.5 text-[10px] font-bold text-cocoa/40 ml-4">
            <div class="w-2 h-2 rounded-full bg-secondary"></div> En attente
          </span>
        </div>
      </div>
      
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-neutral-bg/50">
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Date</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Client & Service</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Méthode</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Montant</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Statut</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/30">
          <tr v-for="tx in filteredTransactions" :key="tx.id" class="hover:bg-neutral-bg/30 transition-colors">
            <td class="px-8 py-5">
              <p class="text-sm font-semibold text-espresso">{{ tx.date }}</p>
              <p class="text-[10px] text-cocoa/40 uppercase font-bold">{{ tx.id }}</p>
            </td>
            <td class="px-8 py-5">
              <p class="row-primary">{{ tx.client }}</p>
              <p class="row-meta">{{ tx.service }}</p>
            </td>
            <td class="px-8 py-5">
              <div class="flex items-center gap-2">
                <span class="text-xs font-semibold text-espresso">{{ tx.method }}</span>
              </div>
            </td>
            <td class="px-8 py-5">
              <p class="text-sm font-bold text-espresso">{{ tx.amountLabel }}</p>
              <p class="text-[10px] text-cocoa/40 font-bold">{{ tx.bookingId }}</p>
            </td>
            <td class="px-8 py-5">
              <span :class="['px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest', tx.statusClass]">
                {{ tx.status }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useQuery } from "@tanstack/vue-query";
import dayjs from "dayjs";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { toast } from "vue-sonner";
import { ArrowDownTrayIcon } from "@heroicons/vue/24/outline";
import { fetchProBookings, fetchProPayouts } from "@/lib/pro-api";
import { openPrintableReport } from "@/lib/download";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();
const period = ref<"30d" | "last-month" | "all">("30d");

const payoutsQuery = useQuery({
  queryKey: ["pro-payouts"],
  queryFn: () => fetchProPayouts(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const bookingsQuery = useQuery({
  queryKey: ["pro-bookings", "payout-links"],
  queryFn: () => fetchProBookings(auth.accessToken ?? "", { page: 0, pageSize: 200 }),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const bookingById = computed(() => {
  return new Map((bookingsQuery.data.value?.items ?? []).map((booking) => [booking.id, booking]));
});

const transactions = computed(() => {
  return (payoutsQuery.data.value ?? []).map((event) => {
    const booking = bookingById.value.get(event.bookingId);
    const status = event.eventType === "held"
      ? "En attente"
      : event.eventType === "released"
        ? "Terminé"
        : "Remboursé";
    return {
      id: event.id,
      bookingId: event.bookingId,
      createdAt: event.createdAt,
      date: dayjs(event.createdAt).format("DD MMM, HH:mm"),
      client: booking?.clientName ?? "Client",
      service: booking?.serviceName ?? "Service",
      method: event.eventType,
      amountXof: event.amountXof,
      amountLabel: formatMoneyXof(event.amountXof),
      status,
      statusClass: status === "Terminé"
        ? "bg-primary/10 text-primary"
        : status === "Remboursé"
          ? "bg-error/5 text-error"
          : "bg-secondary/10 text-secondary"
    };
  });
});

const filteredTransactions = computed(() => {
  if (period.value === "all") return transactions.value;

  if (period.value === "last-month") {
    const start = dayjs().subtract(1, "month").startOf("month");
    const end = dayjs().subtract(1, "month").endOf("month");
    return transactions.value.filter((tx) => {
      const date = dayjs(tx.createdAt);
      return date.isAfter(start) && date.isBefore(end);
    });
  }

  const start = dayjs().subtract(30, "day").startOf("day");
  return transactions.value.filter((tx) => {
    const date = dayjs(tx.createdAt);
    return date.isAfter(start);
  });
});

const pendingAmount = computed(() =>
  filteredTransactions.value
    .filter((tx) => tx.method === "held")
    .reduce((sum, tx) => sum + tx.amountXof, 0)
);

const releasedAmount = computed(() =>
  filteredTransactions.value
    .filter((tx) => tx.method === "released")
    .reduce((sum, tx) => sum + tx.amountXof, 0)
);

const refundedAmount = computed(() =>
  filteredTransactions.value
    .filter((tx) => tx.method === "refunded")
    .reduce((sum, tx) => sum + tx.amountXof, 0)
);

const releasedCount = computed(() => filteredTransactions.value.filter((tx) => tx.method === "released").length);
const pendingAmountLabel = computed(() => formatMoneyXof(pendingAmount.value));
const releasedAmountLabel = computed(() => formatMoneyXof(releasedAmount.value));
const refundedAmountLabel = computed(() => formatMoneyXof(refundedAmount.value));

function printStatement() {
  if (filteredTransactions.value.length === 0) {
    toast.error("Aucune transaction à exporter pour la période sélectionnée.");
    return;
  }

  try {
    openPrintableReport(
      "Relevé des ventes et versements",
      ["Date", "Client", "Service", "Méthode", "Montant", "Statut", "Référence"],
      filteredTransactions.value.map((tx) => [
        tx.date,
        tx.client,
        tx.service,
        tx.method,
        tx.amountLabel,
        tx.status,
        tx.bookingId
      ])
    );
    toast.success("Relevé prêt à imprimer.");
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Impossible d'ouvrir le relevé.");
  }
}
</script>
