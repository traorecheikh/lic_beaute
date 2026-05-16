<template>
  <div>
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Équipe</h1>
        <p class="text-cocoa/60">Gérez vos collaborateurs et leurs spécialités.</p>
      </div>
      <button @click="addMember" class="btn-primary gap-2">
        <PlusIcon class="w-4 h-4" />
        {{ editingMemberId ? "Modifier le membre" : "Ajouter un membre" }}
      </button>
    </div>

    <div class="panel-clean mb-6 p-6">
      <h2 class="section-label mb-4">Affichage mobile</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <label class="flex items-start gap-3 rounded-xl border border-outline-variant/40 p-4 cursor-pointer">
          <input
            type="checkbox"
            class="mt-1 h-4 w-4 accent-primary"
            :checked="teamDisplaySettings.showPhotos"
            @change="onShowPhotosToggle"
            :disabled="teamSettingsMutation.isPending.value"
          />
          <span class="space-y-1">
            <span class="row-primary block">Afficher les photos de l'équipe</span>
            <span class="row-meta block">Si activé, une photo devient obligatoire pour chaque collaborateur actif.</span>
          </span>
        </label>
        <label class="flex items-start gap-3 rounded-xl border border-outline-variant/40 p-4 cursor-pointer">
          <input
            type="checkbox"
            class="mt-1 h-4 w-4 accent-primary"
            :checked="teamDisplaySettings.showDescriptions"
            @change="onShowDescriptionsToggle"
            :disabled="teamSettingsMutation.isPending.value"
          />
          <span class="space-y-1">
            <span class="row-primary block">Afficher les descriptions des collaborateurs</span>
            <span class="row-meta block">Contrôle le texte affiché dans l'app mobile lors du choix du prestataire.</span>
          </span>
        </label>
      </div>
    </div>

    <div v-if="showCreateForm" class="panel-clean mb-6 p-6">
      <h2 class="section-label mb-4">{{ editingMemberId ? "Modifier le collaborateur" : "Nouveau collaborateur" }}</h2>
      <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
        <div>
          <label class="section-label mb-2 block">Nom complet</label>
          <input v-model="createForm.fullName" class="input-shell" placeholder="Awa Sow" />
        </div>
        <div>
          <label class="section-label mb-2 block">Téléphone</label>
          <input v-model="createForm.phone" class="input-shell" placeholder="+221771234567" :disabled="Boolean(editingMemberId)" />
        </div>
        <div v-if="teamDisplaySettings.showPhotos" class="md:col-span-2">
          <label class="section-label mb-2 block">Photo du collaborateur</label>
          <div class="flex flex-wrap items-center gap-4 rounded-xl border border-outline-variant/40 p-3">
            <div class="h-16 w-16 overflow-hidden rounded-full border border-outline-variant bg-neutral-bg">
              <img v-if="createForm.avatarUrl" :src="createForm.avatarUrl" class="h-full w-full object-cover" />
              <div v-else class="flex h-full w-full items-center justify-center text-[10px] font-bold text-cocoa/40">Aucun</div>
            </div>
            <div class="flex items-center gap-2">
              <input ref="avatarUploadInput" type="file" accept="image/*" class="hidden" @change="onAvatarSelected" />
              <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="triggerAvatarUpload" :disabled="uploadAvatarMutation.isPending.value">
                {{ uploadAvatarMutation.isPending.value ? "Téléversement..." : "Téléverser" }}
              </button>
              <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="createForm.avatarUrl = ''" :disabled="!createForm.avatarUrl">
                Supprimer
              </button>
            </div>
          </div>
        </div>
        <div v-if="teamDisplaySettings.showDescriptions" class="md:col-span-2">
          <label class="section-label mb-2 block">Description courte</label>
          <textarea
            v-model="createForm.description"
            class="input-shell h-24"
            maxlength="240"
            placeholder="Ex: Spécialiste coloration et soins naturels."
          ></textarea>
        </div>
        <template v-if="editingMemberId">
          <div>
            <label class="section-label mb-2 block">Statut</label>
            <select v-model="createForm.isActive" class="input-shell">
              <option :value="true">Actif</option>
              <option :value="false">Inactif</option>
            </select>
          </div>
          <div>
            <label class="section-label mb-2 block">Disponibilité planning</label>
            <select v-model="createForm.schedulingEnabled" class="input-shell">
              <option :value="true">Disponible</option>
              <option :value="false">Hors planning</option>
            </select>
          </div>
        </template>
        <div class="md:col-span-2">
          <label class="section-label mb-2 block">Spécialités</label>
          <div class="grid grid-cols-1 gap-2 sm:grid-cols-2">
            <label v-for="service in availableServices" :key="service.id" class="flex items-center gap-2 rounded-lg border border-outline-variant/50 px-3 py-2">
              <input :checked="createForm.serviceIds.includes(service.id)" @change="toggleService(service.id)" type="checkbox" class="h-4 w-4 rounded border-outline-variant text-primary focus:ring-primary/20" />
              <span class="row-meta">{{ service.name }}</span>
            </label>
          </div>
        </div>
      </div>
      <div class="mt-4 flex justify-end gap-2">
        <button @click="cancelCreateMember" class="btn-secondary px-4 py-2 ring-0 border">Annuler</button>
        <button :disabled="actionPending" @click="submitMember" class="btn-primary px-4 py-2 disabled:opacity-60">
          {{ actionPendingLabel }}
        </button>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="member in team" :key="member.id" class="panel-clean p-6 flex flex-col items-center text-center group relative">
        <div class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition flex gap-1">
          <button @click="editMember(member)" class="p-2 hover:bg-neutral-bg rounded-full text-cocoa/60 hover:text-espresso"><PencilIcon class="w-4 h-4" /></button>
          <button @click="removeMember(member.id)" class="p-2 hover:bg-neutral-bg rounded-full text-cocoa/60 hover:text-error"><TrashIcon class="w-4 h-4" /></button>
        </div>

        <div class="w-20 h-20 rounded-full bg-sand flex items-center justify-center font-bold text-2xl text-espresso mb-4 border-2 border-white shadow-sm overflow-hidden">
          <img v-if="teamDisplaySettings.showPhotos && member.avatar" :src="member.avatar" class="w-full h-full object-cover" />
          <span v-else>{{ member.initials }}</span>
        </div>

        <h3 class="row-primary text-base mb-1">{{ member.name }}</h3>
        <p class="row-meta uppercase tracking-widest text-[10px] font-bold mb-4">{{ member.role }}</p>
        <p v-if="teamDisplaySettings.showDescriptions && member.description" class="row-meta mb-4 leading-relaxed">
          {{ member.description }}
        </p>

        <div class="flex flex-wrap justify-center gap-1.5 mb-6">
          <span v-for="spec in member.specialties" :key="spec" class="px-2 py-0.5 rounded-full bg-neutral-bg text-[10px] font-bold text-cocoa/60 uppercase tracking-wider">
            {{ spec }}
          </span>
        </div>

        <div class="w-full pt-4 border-t border-outline-variant/30 flex items-center justify-between text-[11px] font-bold">
          <span :class="member.active ? 'text-primary' : 'text-cocoa/30'">
            {{ member.active ? '● Actif' : '○ Inactif' }}
          </span>
          <button @click="openPlanning(member.id)" class="text-primary hover:underline uppercase tracking-widest">Voir planning</button>
        </div>
      </div>

      <button @click="addMember" class="panel-clean p-6 flex flex-col items-center justify-center text-center border-dashed border-2 bg-transparent hover:bg-white hover:border-primary/20 transition group min-h-[280px]">
        <div class="w-16 h-16 rounded-full bg-neutral-bg flex items-center justify-center text-cocoa/20 group-hover:bg-primary/5 group-hover:text-primary transition mb-4">
          <PlusIcon class="w-8 h-8" />
        </div>
        <p class="font-bold text-espresso mb-1">Recruter un nouveau talent</p>
        <p class="text-xs text-cocoa/40">Ajoutez un collaborateur à votre salon.</p>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { useRouter } from "vue-router";
import { toast } from "vue-sonner";
import {
  PlusIcon,
  PencilIcon,
  TrashIcon
} from "@heroicons/vue/24/outline";
import { createProStaff, deleteProStaff, fetchProSalon, fetchProServices, fetchProStaff, updateProSalon, updateProStaff, uploadProMedia } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";

const auth = useProAuthStore();
const router = useRouter();
const queryClient = useQueryClient();
const showCreateForm = ref(false);
const editingMemberId = ref<string | null>(null);
const avatarUploadInput = ref<HTMLInputElement | null>(null);
const teamDisplaySettings = reactive({
  showPhotos: false,
  showDescriptions: false
});
const createForm = reactive({
  fullName: "",
  phone: "",
  avatarUrl: "",
  description: "",
  serviceIds: [] as string[],
  isActive: true,
  schedulingEnabled: true
});

const servicesQuery = useQuery({
  queryKey: ["pro-services"],
  queryFn: () => fetchProServices(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const staffQuery = useQuery({
  queryKey: ["pro-staff"],
  queryFn: () => fetchProStaff(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const salonQuery = useQuery({
  queryKey: ["pro-salon"],
  queryFn: () => fetchProSalon(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const teamSettingsMutation = useMutation({
  mutationFn: (next: { showPhotos: boolean; showDescriptions: boolean }) =>
    updateProSalon(auth.accessToken ?? "", { teamDisplay: next }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-salon"] });
    toast.success("Paramètres d'affichage équipe mis à jour.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Mise à jour des paramètres impossible pour le moment."));
  }
});

const deleteMutation = useMutation({
  mutationFn: (employeeId: string) => deleteProStaff(auth.accessToken ?? "", employeeId),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-staff"] });
    toast.success("Membre de l'équipe supprimé.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Suppression impossible pour le moment."));
  }
});

const createMutation = useMutation({
  mutationFn: () =>
    createProStaff(auth.accessToken ?? "", {
      fullName: createForm.fullName.trim(),
      phone: createForm.phone.replace(/\s+/g, ""),
      avatarUrl: createForm.avatarUrl.trim() ? createForm.avatarUrl.trim() : null,
      description: createForm.description.trim() ? createForm.description.trim() : null,
      serviceIds: createForm.serviceIds
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-staff"] });
    toast.success("Membre ajouté.");
    cancelCreateMember();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Création impossible pour le moment."));
  }
});

const updateMutation = useMutation({
  mutationFn: () =>
    updateProStaff(auth.accessToken ?? "", editingMemberId.value ?? "", {
      displayName: createForm.fullName.trim(),
      avatarUrl: createForm.avatarUrl.trim() ? createForm.avatarUrl.trim() : null,
      description: createForm.description.trim() ? createForm.description.trim() : null,
      isActive: createForm.isActive,
      schedulingEnabled: createForm.schedulingEnabled,
      serviceIds: createForm.serviceIds
    }),
  onSuccess: async () => {
    await queryClient.invalidateQueries({ queryKey: ["pro-staff"] });
    toast.success("Membre mis à jour.");
    cancelCreateMember();
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Mise à jour impossible pour le moment."));
  }
});

const uploadAvatarMutation = useMutation({
  mutationFn: (file: File) => uploadProMedia(auth.accessToken ?? "", file, "avatar"),
  onSuccess: (asset) => {
    createForm.avatarUrl = asset.publicUrl;
    toast.success("Photo du collaborateur téléversée.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Téléversement impossible pour le moment."));
  }
});

const availableServices = computed(() => servicesQuery.data.value ?? []);

const serviceById = computed(() => {
  return new Map((servicesQuery.data.value ?? []).map((service) => [service.id, service.name]));
});

const team = computed(() => {
  return (staffQuery.data.value ?? []).map((member) => {
    const initials = member.displayName
      .split(" ")
      .slice(0, 2)
      .map((name) => name[0]?.toUpperCase() ?? "")
      .join("");
    return {
      id: member.id,
      name: member.displayName,
      initials,
      role: member.schedulingEnabled ? "Disponible" : "Hors planning",
      specialties: member.serviceIds.map((serviceId) => serviceById.value.get(serviceId) ?? "Service"),
      active: member.isActive,
      schedulingEnabled: member.schedulingEnabled,
      serviceIds: member.serviceIds,
      avatar: member.avatarUrl,
      description: member.description
    };
  });
});

const actionPending = computed(() => createMutation.isPending.value || updateMutation.isPending.value);
const actionPendingLabel = computed(() => {
  if (editingMemberId.value) {
    return updateMutation.isPending.value ? "Enregistrement..." : "Enregistrer";
  }
  return createMutation.isPending.value ? "Création..." : "Créer le membre";
});

function addMember() {
  showCreateForm.value = true;
  editingMemberId.value = null;
}

function cancelCreateMember() {
  showCreateForm.value = false;
  editingMemberId.value = null;
  createForm.fullName = "";
  createForm.phone = "";
  createForm.avatarUrl = "";
  createForm.description = "";
  createForm.serviceIds = [];
  createForm.isActive = true;
  createForm.schedulingEnabled = true;
}

function triggerAvatarUpload() {
  avatarUploadInput.value?.click();
}

function onAvatarSelected(event: Event) {
  const input = event.target as HTMLInputElement | null;
  const file = input?.files?.[0];
  if (!file) return;
  if (!file.type.startsWith("image/")) {
    toast.error("Veuillez sélectionner une image.");
    if (input) input.value = "";
    return;
  }
  uploadAvatarMutation.mutate(file);
  if (input) input.value = "";
}

function toggleTeamDisplay(
  key: "showPhotos" | "showDescriptions",
  value: boolean
) {
  const next = {
    showPhotos: key === "showPhotos" ? value : teamDisplaySettings.showPhotos,
    showDescriptions: key === "showDescriptions" ? value : teamDisplaySettings.showDescriptions
  };
  teamDisplaySettings.showPhotos = next.showPhotos;
  teamDisplaySettings.showDescriptions = next.showDescriptions;
  teamSettingsMutation.mutate(next, {
    onError: () => {
      const current = salonQuery.data.value?.teamDisplay;
      teamDisplaySettings.showPhotos = current?.showPhotos ?? false;
      teamDisplaySettings.showDescriptions = current?.showDescriptions ?? false;
    }
  });
}

function onShowPhotosToggle(event: Event) {
  const input = event.target as HTMLInputElement | null;
  toggleTeamDisplay("showPhotos", input?.checked ?? false);
}

function onShowDescriptionsToggle(event: Event) {
  const input = event.target as HTMLInputElement | null;
  toggleTeamDisplay("showDescriptions", input?.checked ?? false);
}

function toggleService(serviceId: string) {
  if (createForm.serviceIds.includes(serviceId)) {
    createForm.serviceIds = createForm.serviceIds.filter((id) => id !== serviceId);
    return;
  }
  createForm.serviceIds = [...createForm.serviceIds, serviceId];
}

function submitMember() {
  if (!createForm.fullName.trim()) {
    toast.error("Le nom est requis.");
    return;
  }
  if (!editingMemberId.value && !createForm.phone.trim()) {
    toast.error("Le téléphone est requis pour créer un membre.");
    return;
  }
  if (teamDisplaySettings.showPhotos && createForm.isActive && !createForm.avatarUrl.trim()) {
    toast.error("Photo obligatoire pour activer un collaborateur.");
    return;
  }

  if (editingMemberId.value) {
    updateMutation.mutate();
    return;
  }

  createMutation.mutate();
}

function removeMember(id: string) {
  deleteMutation.mutate(id);
}

function editMember(member: {
  id: string;
  name: string;
  active: boolean;
  schedulingEnabled: boolean;
  serviceIds: string[];
  avatar: string | null;
  description: string | null;
}) {
  showCreateForm.value = true;
  editingMemberId.value = member.id;
  createForm.fullName = member.name;
  createForm.phone = "";
  createForm.avatarUrl = member.avatar ?? "";
  createForm.description = member.description ?? "";
  createForm.serviceIds = [...member.serviceIds];
  createForm.isActive = member.active;
  createForm.schedulingEnabled = member.schedulingEnabled;
}

function openPlanning(employeeId: string) {
  void router.push({ path: "/pro/calendar", query: { employeeId } });
}

watch(
  () => salonQuery.data.value?.teamDisplay,
  (teamDisplay) => {
    if (!teamDisplay) return;
    teamDisplaySettings.showPhotos = teamDisplay.showPhotos;
    teamDisplaySettings.showDescriptions = teamDisplay.showDescriptions;
  },
  { immediate: true }
);
</script>
