<template>
  <div>
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Prestations</h1>
        <p class="text-cocoa/60">Gérez votre menu de services et vos tarifs.</p>
      </div>
      <button @click="addService" class="btn-primary gap-2">
        <PlusIcon class="w-4 h-4" />
        {{ showCreateForm && editingServiceId ? "Modifier la prestation" : "Nouvelle prestation" }}
      </button>
    </div>

    <div v-if="showCreateForm" class="panel-clean mb-6 p-6">
      <h2 class="section-label mb-4">{{ editingServiceId ? "Modifier la prestation" : "Nouvelle prestation" }}</h2>
      <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
        <div class="md:col-span-2">
          <label class="section-label mb-2 block">Nom</label>
          <input v-model="createForm.name" class="input-shell" placeholder="Brushing + soin" />
        </div>
        <div class="md:col-span-2">
          <label class="section-label mb-2 block">Catégorie</label>
          <input v-model="createForm.category" class="input-shell" placeholder="Coiffure, Ongles, Spa..." />
        </div>
        <div>
          <label class="section-label mb-2 block">Durée (minutes)</label>
          <input v-model.number="createForm.durationMinutes" type="number" min="5" step="5" class="input-shell" />
        </div>
        <div>
          <label class="section-label mb-2 block">Prix (XOF)</label>
          <input v-model.number="createForm.priceXof" type="number" min="0" step="500" class="input-shell" />
        </div>
        <div>
          <label class="section-label mb-2 block">Type d'acompte</label>
          <select v-model="createForm.depositMode" class="input-shell">
            <option value="none">Aucun</option>
            <option value="fixed">Montant fixe</option>
            <option value="percent">Pourcentage</option>
          </select>
        </div>
        <div v-if="createForm.depositMode === 'fixed'">
          <label class="section-label mb-2 block">Acompte (XOF)</label>
          <input v-model.number="createForm.depositAmountXof" type="number" min="0" step="500" class="input-shell" />
        </div>
        <div v-if="createForm.depositMode === 'percent'">
          <label class="section-label mb-2 block">Acompte (%)</label>
          <input v-model.number="createForm.depositPercent" type="number" min="1" max="100" step="1" class="input-shell" />
        </div>
      </div>
      <div class="mt-4 flex justify-end gap-2">
        <button @click="cancelCreateService" class="btn-secondary px-4 py-2 ring-0 border">Annuler</button>
        <button :disabled="actionPending" @click="submitService" class="btn-primary px-4 py-2 disabled:opacity-60">
          {{ actionPendingLabel }}
        </button>
      </div>
    </div>

    <div class="panel-clean overflow-hidden">
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-neutral-bg/50">
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Statut</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Nom du service</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Durée</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Prix</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Acompte</th>
            <th class="px-6 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40 text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/30">
          <tr v-for="service in services" :key="service.id" class="hover:bg-neutral-bg/30 transition-colors group">
            <td class="px-6 py-4">
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" :checked="service.active" disabled class="sr-only peer">
                <div class="w-9 h-5 bg-outline-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </td>
            <td class="px-6 py-4">
              <p class="row-primary">{{ service.name }}</p>
              <p class="row-meta">{{ service.category }}</p>
            </td>
            <td class="px-6 py-4 text-sm text-espresso font-medium">{{ service.duration }} min</td>
            <td class="px-6 py-4 text-sm text-espresso font-bold">{{ service.priceLabel }}</td>
            <td class="px-6 py-4">
              <span v-if="service.deposit > 0" class="px-2 py-0.5 rounded-full bg-secondary/10 text-secondary text-[10px] font-bold uppercase tracking-wider">
                {{ service.depositLabel }}
              </span>
              <span v-else class="text-[10px] text-cocoa/30 italic font-semibold uppercase tracking-widest">Aucun</span>
            </td>
            <td class="px-6 py-4 text-right">
              <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
                <button @click="editService(service)" class="p-2 hover:bg-white rounded-full text-cocoa/60 hover:text-espresso shadow-sm"><PencilIcon class="w-4 h-4" /></button>
                <button @click="deleteService(service.id)" class="p-2 hover:bg-white rounded-full text-cocoa/60 hover:text-error shadow-sm"><TrashIcon class="w-4 h-4" /></button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="mt-8 panel-clean p-6 bg-primary/5 border-primary/10 flex items-center justify-between">
      <div class="flex items-center gap-4">
        <div class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center text-primary">
          <InformationCircleIcon class="w-6 h-6" />
        </div>
        <div>
          <p class="text-sm font-bold text-espresso">Astuce : Demandez un acompte</p>
          <p class="text-xs text-cocoa/60">Les services avec acompte ont 80% de chances en moins d'être annulés.</p>
        </div>
      </div>
      <button @click="learnAboutDeposits" class="text-xs font-bold text-primary uppercase tracking-widest">En savoir plus</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { formatMoneyXof } from "@beauteavenue/shared-ts";
import { toast } from "vue-sonner";
import {
  PlusIcon,
  PencilIcon,
  TrashIcon,
  InformationCircleIcon
} from "@heroicons/vue/24/outline";
import { createProService, deleteProService, fetchProServices, updateProService } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";

const auth = useProAuthStore();
const queryClient = useQueryClient();
const showCreateForm = ref(false);
const editingServiceId = ref<string | null>(null);
const createForm = reactive({
  name: "",
  category: "",
  durationMinutes: 30,
  priceXof: 5000,
  depositMode: "none" as "none" | "fixed" | "percent",
  depositAmountXof: 0,
  depositPercent: 20
});

const servicesQuery = useQuery({
  queryKey: ["pro-services"],
  queryFn: () => fetchProServices(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken))
});

const deleteMutation = useMutation({
  mutationFn: (serviceId: string) => deleteProService(auth.accessToken ?? "", serviceId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-services"] });
    toast.success("Prestation supprimée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Suppression impossible pour le moment."));
  }
});

const createMutation = useMutation({
  mutationFn: () =>
    createProService(auth.accessToken ?? "", {
      name: createForm.name.trim(),
      category: createForm.category.trim() || undefined,
      durationMinutes: Number(createForm.durationMinutes),
      priceXof: Number(createForm.priceXof),
      depositMode: createForm.depositMode,
      depositAmountXof: createForm.depositMode === "fixed" ? Number(createForm.depositAmountXof) : undefined,
      depositPercent: createForm.depositMode === "percent" ? Number(createForm.depositPercent) : undefined
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-services"] });
    toast.success("Prestation créée.");
    cancelCreateService();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Création impossible pour le moment."));
  }
});

const updateMutation = useMutation({
  mutationFn: () =>
    updateProService(auth.accessToken ?? "", editingServiceId.value ?? "", {
      name: createForm.name.trim(),
      category: createForm.category.trim() || undefined,
      durationMinutes: Number(createForm.durationMinutes),
      priceXof: Number(createForm.priceXof),
      depositMode: createForm.depositMode,
      depositAmountXof: createForm.depositMode === "fixed" ? Number(createForm.depositAmountXof) : undefined,
      depositPercent: createForm.depositMode === "percent" ? Number(createForm.depositPercent) : undefined
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-services"] });
    toast.success("Prestation mise à jour.");
    cancelCreateService();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Mise à jour impossible pour le moment."));
  }
});

const services = computed(() => {
  return (servicesQuery.data.value ?? []).map((service) => {
    const deposit = service.depositMode === "fixed"
      ? service.depositAmountXof ?? 0
      : service.depositMode === "percent"
        ? Math.round(service.priceXof * ((service.depositPercent ?? 0) / 100))
        : 0;
    return {
      id: service.id,
      name: service.name,
      category: service.category,
      depositMode: service.depositMode,
      depositAmountXof: service.depositAmountXof ?? 0,
      depositPercent: service.depositPercent ?? 0,
      duration: service.durationMinutes,
      price: service.priceXof,
      priceLabel: formatMoneyXof(service.priceXof),
      deposit,
      depositLabel: formatMoneyXof(deposit),
      active: service.isActive
    };
  });
});

const actionPending = computed(() => createMutation.isPending.value || updateMutation.isPending.value);
const actionPendingLabel = computed(() => {
  if (editingServiceId.value) {
    return updateMutation.isPending.value ? "Mise à jour..." : "Enregistrer";
  }
  return createMutation.isPending.value ? "Création..." : "Créer la prestation";
});

function addService() {
  showCreateForm.value = true;
  editingServiceId.value = null;
}

function cancelCreateService() {
  showCreateForm.value = false;
  editingServiceId.value = null;
  createForm.name = "";
  createForm.category = "";
  createForm.durationMinutes = 30;
  createForm.priceXof = 5000;
  createForm.depositMode = "none";
  createForm.depositAmountXof = 0;
  createForm.depositPercent = 20;
}

function submitService() {
  if (!createForm.name.trim()) {
    toast.error("Le nom de la prestation est requis.");
    return;
  }
  if (!createForm.category.trim()) {
    toast.error("La catégorie de la prestation est requise.");
    return;
  }
  if (Number(createForm.durationMinutes) <= 0 || Number(createForm.priceXof) < 0) {
    toast.error("Durée et prix invalides.");
    return;
  }
  if (createForm.depositMode === "fixed" && Number(createForm.depositAmountXof) < 0) {
    toast.error("Acompte fixe invalide.");
    return;
  }
  if (createForm.depositMode === "percent" && (Number(createForm.depositPercent) < 1 || Number(createForm.depositPercent) > 100)) {
    toast.error("Acompte en pourcentage invalide.");
    return;
  }
  if (editingServiceId.value) {
    updateMutation.mutate();
    return;
  }
  createMutation.mutate();
}

function deleteService(id: string) {
  deleteMutation.mutate(id);
}

function editService(service: {
  id: string;
  name: string;
  category: string;
  duration: number;
  price: number;
  depositMode: "none" | "fixed" | "percent";
  depositAmountXof: number;
  depositPercent: number;
}) {
  editingServiceId.value = service.id;
  showCreateForm.value = true;
  createForm.name = service.name;
  createForm.category = service.category;
  createForm.durationMinutes = service.duration;
  createForm.priceXof = service.price;
  createForm.depositMode = service.depositMode;
  createForm.depositAmountXof = service.depositAmountXof;
  createForm.depositPercent = service.depositPercent || 20;
}

function learnAboutDeposits() {
  toast.info("Utilisez un acompte fixe pour les prestations premium ou un pourcentage pour les services standards.");
}
</script>
