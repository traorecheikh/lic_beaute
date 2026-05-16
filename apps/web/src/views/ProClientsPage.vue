<template>
  <div>
    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-2">Fichier Clients</h1>
        <p class="text-cocoa/60">Gérez votre base de clients et leur historique.</p>
      </div>
      <div class="relative flex-1 max-w-md">
        <MagnifyingGlassIcon class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-cocoa/40" />
        <input type="text" v-model="searchQuery" class="input-shell pl-12" placeholder="Rechercher par nom ou téléphone..." />
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Client List -->
      <div class="lg:col-span-2 space-y-4">
        <div class="panel-clean overflow-hidden">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="bg-neutral-bg/50">
                <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Client</th>
                <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Dernière visite</th>
                <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40 text-center">Visites</th>
                <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40 text-right">Total dépensé</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant/30">
              <tr 
                v-for="client in filteredClients" 
                :key="client.id"
                @click="selectedId = client.id"
                :class="[
                  'hover:bg-neutral-bg/30 transition-colors cursor-pointer',
                  selectedId === client.id ? 'bg-primary/5' : ''
                ]"
              >
                <td class="px-6 py-4">
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-sand flex items-center justify-center font-bold text-espresso text-xs">
                      {{ client.initials }}
                    </div>
                    <div>
                      <p class="row-primary">{{ client.name }}</p>
                      <p class="row-meta">{{ client.phone }}</p>
                    </div>
                  </div>
                </td>
                <td class="px-6 py-4 text-sm text-espresso font-medium">{{ client.lastVisit }}</td>
                <td class="px-6 py-4 text-sm text-espresso font-bold text-center">{{ client.visitCount }}</td>
                <td class="px-6 py-4 text-sm text-espresso font-bold text-right">{{ client.totalSpentLabel }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Detail Side Panel (Desktop) -->
      <div class="hidden lg:block">
        <div v-if="selectedClient" class="panel-clean p-8 sticky top-32">
          <div class="text-center mb-8">
            <div class="w-20 h-20 rounded-full bg-sand mx-auto flex items-center justify-center font-bold text-3xl text-espresso mb-4 border border-outline-variant">
              {{ selectedClient.initials }}
            </div>
            <h3 class="entity-title">{{ selectedClient.name }}</h3>
            <p class="text-sm text-cocoa/60">Client depuis {{ selectedClient.memberSince }}</p>
          </div>

          <div class="space-y-6 mb-8">
            <div class="flex justify-between py-2 border-b border-outline-variant/30">
              <span class="text-xs font-bold text-cocoa/40 uppercase">Téléphone</span>
              <span class="text-sm font-semibold text-espresso">{{ selectedClient.phone }}</span>
            </div>
            <div class="flex justify-between py-2 border-b border-outline-variant/30">
              <span class="text-xs font-bold text-cocoa/40 uppercase">Email</span>
              <span class="text-sm font-semibold text-espresso">{{ selectedClient.email }}</span>
            </div>
          </div>

          <div class="space-y-4 mb-8">
            <label class="section-label">Dernières notes</label>
            <div class="p-4 bg-neutral-bg rounded-xl">
              <p class="text-xs text-cocoa/60 italic leading-relaxed">
                {{ latestClientInsight }}
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 gap-3 mb-6">
            <button @click="startBookingForClient" class="btn-primary w-full py-3 text-[11px]">Nouveau RDV</button>
            <button @click="openClientHistory" class="btn-secondary w-full py-3 ring-0 border text-[11px]">Voir historique complet</button>
            <button @click="showBenefitForm = !showBenefitForm" class="btn-gold w-full py-3 text-[11px]">Attribuer un avantage</button>
          </div>

          <!-- Benefit assignment form -->
          <div v-if="showBenefitForm" class="border border-outline-variant/50 rounded-2xl p-5 space-y-4">
            <label class="section-label block">Attribuer un abonnement / package</label>
            <div>
              <label class="section-label block mb-1">Type</label>
              <select v-model="benefitForm.kind" class="input-shell">
                <option value="membership">Abonnement</option>
                <option value="package">Package</option>
              </select>
            </div>
            <div>
              <label class="section-label block mb-1">Nom *</label>
              <input v-model="benefitForm.name" type="text" class="input-shell" placeholder="Pass Bien-être" required />
            </div>
            <div>
              <label class="section-label block mb-1">Utilisations incluses</label>
              <input v-model.number="benefitForm.remainingUses" type="number" class="input-shell" placeholder="Illimité" min="1" />
            </div>
            <div>
              <label class="section-label block mb-1">Date d'expiration</label>
              <input v-model="benefitForm.expiresAt" type="date" class="input-shell" />
            </div>
            <p v-if="benefitError" class="text-error row-meta">{{ benefitError }}</p>
            <div class="flex gap-2 pt-1">
              <button @click="showBenefitForm = false; benefitError = null" class="btn-secondary flex-1 py-2.5 text-[11px]">Annuler</button>
              <button @click="submitBenefit" :disabled="benefitSubmitting" class="btn-gold flex-1 py-2.5 text-[11px]">
                {{ benefitSubmitting ? 'Envoi…' : 'Attribuer' }}
              </button>
            </div>
          </div>
        </div>
        <div v-else class="panel-clean p-8 text-center border-dashed flex flex-col items-center justify-center min-h-[400px]">
          <UsersIcon class="w-12 h-12 text-cocoa/20 mb-4" />
          <p class="text-sm text-cocoa/40 italic">Sélectionnez un client pour voir son profil complet.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from "vue";
import { useQuery } from "@tanstack/vue-query";
import { refDebounced } from "@vueuse/core";
import dayjs from "dayjs";
import { useRouter } from "vue-router";
import { MagnifyingGlassIcon, UsersIcon } from "@heroicons/vue/24/outline";
import { createClientBenefit, fetchProClient, fetchProClients } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { formatMoneyXof } from "@beauteavenue/shared-ts";

const searchQuery = ref("");
const debouncedSearch = refDebounced(searchQuery, 300);
const selectedId = ref<string | null>(null);
const router = useRouter();
const auth = useProAuthStore();

const showBenefitForm = ref(false);
const benefitSubmitting = ref(false);
const benefitError = ref<string | null>(null);
const benefitForm = ref({
  kind: "membership" as "membership" | "package",
  name: "",
  remainingUses: null as number | null,
  expiresAt: ""
});

const clientsQuery = useQuery({
  queryKey: computed(() => ["pro-clients", debouncedSearch.value.trim()]),
  queryFn: () => fetchProClients(auth.accessToken ?? "", debouncedSearch.value.trim() || undefined),
  enabled: computed(() => Boolean(auth.accessToken))
});

const filteredClients = computed(() => {
  return (clientsQuery.data.value ?? []).map((client) => {
    const initials = client.fullName
      .split(" ")
      .slice(0, 2)
      .map((name) => name[0]?.toUpperCase() ?? "")
      .join("");
    return {
      id: client.id,
      name: client.fullName,
      initials,
      phone: client.phone ?? "Non renseigné",
      email: client.email ?? "Non renseigné",
      lastVisit: client.lastVisitAt ? dayjs(client.lastVisitAt).format("DD MMM YYYY") : "Aucune",
      visitCount: client.visitCount,
      totalSpent: client.totalSpentXof,
      totalSpentLabel: formatMoneyXof(client.totalSpentXof),
      memberSince: client.lastVisitAt ? dayjs(client.lastVisitAt).format("MMM YYYY") : "N/A"
    };
  });
});

const selectedClientQuery = useQuery({
  queryKey: computed(() => ["pro-client", selectedId.value]),
  queryFn: () => fetchProClient(auth.accessToken ?? "", selectedId.value ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && selectedId.value))
});

const selectedClient = computed(() => {
  const base = filteredClients.value.find((client) => client.id === selectedId.value);
  if (!base) return null;

  const detail = selectedClientQuery.data.value;
  if (!detail) return base;

  return {
    ...base,
    phone: detail.phone ?? base.phone,
    email: detail.email ?? base.email,
    visitCount: detail.visitCount,
    totalSpent: detail.totalSpentXof,
    totalSpentLabel: formatMoneyXof(detail.totalSpentXof),
    lastVisit: detail.lastVisitAt ? dayjs(detail.lastVisitAt).format("DD MMM YYYY") : base.lastVisit
  };
});

const latestClientInsight = computed(() => {
  const detail = selectedClientQuery.data.value;
  const latestBooking = detail?.recentBookings?.[0];
  if (!latestBooking) {
    return "Aucun historique de réservation disponible pour ce client.";
  }

  return `${latestBooking.serviceName} • ${dayjs(latestBooking.startsAt).format("DD MMM YYYY HH:mm")} • ${formatMoneyXof(latestBooking.amountXof)}`;
});

function startBookingForClient() {
  if (!selectedClient.value) return;
  void router.push({
    path: "/pro/calendar",
    query: {
      compose: "manual",
      clientId: selectedClient.value.id,
      clientName: selectedClient.value.name,
      clientPhone: selectedClient.value.phone === "Non renseigné" ? "" : selectedClient.value.phone
    }
  });
}

function openClientHistory() {
  const latestBookingId = selectedClientQuery.data.value?.recentBookings?.[0]?.bookingId;
  void router.push({
    path: "/pro/bookings/inbox",
    query: latestBookingId ? { bookingId: latestBookingId } : undefined
  });
}

watch(
  () => filteredClients.value,
  (items) => {
    if (!items.length) {
      selectedId.value = null;
      return;
    }
    if (!selectedId.value || !items.some((client) => client.id === selectedId.value)) {
      selectedId.value = items[0].id;
    }
  },
  { immediate: true }
);

watch(selectedId, () => {
  showBenefitForm.value = false;
  benefitError.value = null;
  benefitForm.value = { kind: "membership", name: "", remainingUses: null, expiresAt: "" };
});

async function submitBenefit() {
  if (!auth.accessToken || !selectedId.value) return;
  if (!benefitForm.value.name.trim()) {
    benefitError.value = "Le nom est obligatoire.";
    return;
  }
  benefitSubmitting.value = true;
  benefitError.value = null;
  try {
    await createClientBenefit(auth.accessToken, {
      clientId: selectedId.value,
      kind: benefitForm.value.kind,
      name: benefitForm.value.name.trim(),
      remainingUses: benefitForm.value.remainingUses ?? undefined,
      expiresAt: benefitForm.value.expiresAt ? new Date(benefitForm.value.expiresAt) : undefined
    });
    showBenefitForm.value = false;
    benefitForm.value = { kind: "membership", name: "", remainingUses: null, expiresAt: "" };
  } catch (err: unknown) {
    benefitError.value = err instanceof Error ? err.message : "Impossible d'attribuer l'avantage.";
  } finally {
    benefitSubmitting.value = false;
  }
}
</script>
