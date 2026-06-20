<template>
  <div class="max-w-4xl mx-auto">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Profil du Salon</h1>
        <p class="text-cocoa/60">Gérez l'apparence de votre salon sur la marketplace.</p>
      </div>
      <button @click="saveProfile" :disabled="saving" class="btn-primary px-8">
        {{ saving ? "Enregistrement..." : "Enregistrer" }}
      </button>
    </div>

    <div class="space-y-8">
      <section class="panel-clean p-8">
        <h2 class="section-label mb-6">Photos & Galerie</h2>

        <div class="mb-6">
          <label class="section-label mb-2 block">Logo du salon</label>
          <div class="flex flex-wrap items-center gap-4">
            <div class="h-24 w-24 overflow-hidden rounded-2xl border border-outline-variant bg-neutral-bg">
              <img v-if="profile.logoUrl" :src="profile.logoUrl" class="h-full w-full object-cover" />
              <div v-else class="flex h-full w-full items-center justify-center text-[10px] font-bold uppercase tracking-widest text-cocoa/40">
                Aucun logo
              </div>
            </div>
            <div class="flex flex-wrap items-center gap-2">
              <input ref="logoUploadInput" type="file" accept="image/*" class="hidden" @change="onLogoSelected" />
              <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="triggerLogoUpload" :disabled="uploadingLogo">
                {{ uploadingLogo ? "Téléversement..." : "Téléverser un logo" }}
              </button>
              <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="removeLogo" :disabled="!profile.logoUrl">
                Supprimer
              </button>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
          <div
            v-for="(photo, index) in photos"
            :key="index"
            class="relative group aspect-square rounded-2xl overflow-hidden bg-neutral-bg"
          >
            <img :src="photo.url" class="w-full h-full object-cover transition group-hover:scale-110" />
            <div class="absolute inset-0 bg-espresso/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center gap-2">
              <button type="button" @click="openEditPhotoModal(index)" class="p-2 bg-white rounded-full text-espresso hover:text-primary">
                <PencilIcon class="w-4 h-4" />
              </button>
              <button type="button" @click="removePhoto(index)" class="p-2 bg-white rounded-full text-espresso hover:text-error">
                <TrashIcon class="w-4 h-4" />
              </button>
            </div>
          </div>
          <button
            type="button"
            @click="triggerPhotoUpload"
            :class="[
              'aspect-square rounded-2xl border-2 border-dashed flex flex-col items-center justify-center gap-2 transition group',
              isGalleryFull
                ? 'border-outline-variant/30 bg-neutral-bg/50 cursor-not-allowed text-cocoa/20'
                : 'border-outline-variant text-cocoa/40 hover:border-primary/40 hover:text-primary'
            ]"
            :title="isGalleryFull ? galleryLimitTooltip : 'Ajouter une photo'"
          >
            <PlusIcon class="w-8 h-8 group-hover:scale-110 transition" :class="isGalleryFull ? 'opacity-30' : ''" />
            <span class="text-[10px] font-bold uppercase tracking-widest">{{ isGalleryFull ? 'Limite atteinte' : 'Ajouter' }}</span>
          </button>
        </div>
        <div class="flex flex-wrap items-center gap-2">
          <input ref="photoUploadInput" type="file" accept="image/*" class="hidden" @change="onPhotoSelected" />
          <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="triggerPhotoUpload" :disabled="uploadingPhoto || isGalleryFull" :title="isGalleryFull ? galleryLimitTooltip : ''">
            {{ uploadingPhoto ? "Téléversement..." : isGalleryFull ? "Limite atteinte" : "Téléverser une photo" }}
          </button>
          <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="openAddPhotoModal" :disabled="isGalleryFull" :title="isGalleryFull ? galleryLimitTooltip : ''">
            Ajouter via URL
          </button>
        </div>
        <p class="text-[10px] text-cocoa/40 italic mt-2">Les changements de galerie sont enregistrés avec le profil.</p>
      </section>

      <section class="panel-clean p-8 space-y-6">
        <h2 class="section-label mb-2">Informations Générales</h2>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Nom commercial</label>
            <input type="text" v-model="profile.name" class="input-shell" disabled />
          </div>

          <div>
            <label class="section-label mb-2 block">Catégorie principale</label>
            <select v-model="profile.category" class="input-shell">
              <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
            </select>
          </div>

          <div>
            <label class="section-label mb-2 block">Ville</label>
            <select v-model="profile.city" class="input-shell">
              <option v-for="city in cityOptions" :key="city" :value="city">{{ city }}</option>
            </select>
          </div>

          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Adresse complète</label>
            <input type="text" v-model="profile.address" class="input-shell" placeholder="Rue..., Quartier..." />
          </div>

          <!-- Missing coordinates soft warning -->
          <div
            v-if="hasNoCoordinates"
            class="md:col-span-2 rounded-xl border border-amber-200 bg-amber-50/80 px-4 py-3 flex items-start gap-3"
          >
            <div class="mt-0.5 shrink-0 w-5 h-5 rounded-full bg-amber-400 text-white flex items-center justify-center text-[11px] font-bold">i</div>
            <div>
              <p class="text-sm font-medium text-amber-800">Position manquante</p>
              <p class="text-xs text-amber-700/80 mt-0.5">
                Ajoutez la position de votre salon pour être visible dans les résultats
                <strong>« Près de vous »</strong> sur l'application mobile.
                Utilisez le bouton « Utiliser ma position actuelle » ci-dessous pour ajouter votre position GPS.
              </p>
            </div>
          </div>

          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Quartier</label>
            <input type="text" v-model="profile.neighborhood" class="input-shell" placeholder="Ex: Almadies" />
          </div>

          <div>
            <label class="section-label mb-2 block">Latitude</label>
            <input type="text" v-model="profile.latitude" class="input-shell" placeholder="14.716700" />
          </div>

          <div>
            <label class="section-label mb-2 block">Longitude</label>
            <input type="text" v-model="profile.longitude" class="input-shell" placeholder="-17.467700" />
          </div>

          <div class="md:col-span-2 flex flex-wrap items-center gap-3">
            <button type="button" class="btn-secondary px-4 py-2" :disabled="locating" @click="useCurrentLocation">
              {{ locating ? "Localisation..." : "Utiliser ma position actuelle" }}
            </button>
            <p v-if="locationCapturedAt" class="row-meta">
              Position capturée{{ locationAccuracyMeters === null ? "" : ` (±${locationAccuracyMeters}m)` }} · {{ locationCapturedAt }}
            </p>
          </div>

          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Description</label>
            <textarea
              v-model="profile.description"
              class="input-shell h-32"
              placeholder="Présentez votre salon, votre expertise..."
            ></textarea>
          </div>
        </div>
      </section>

      <section class="panel-clean p-8">
        <h2 class="section-label mb-6">Contact & Réseaux</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="section-label mb-2 block">Téléphone public</label>
            <input type="tel" v-model="profile.phone" class="input-shell" />
          </div>
          <div>
            <label class="section-label mb-2 block">Instagram (Lien)</label>
            <input type="text" v-model="profile.instagram" class="input-shell" placeholder="@votre_salon" />
          </div>
        </div>
      </section>
    </div>

    <Modal
      :show="showPhotoModal"
      :title="editingPhotoIndex === null ? 'Ajouter une photo' : 'Modifier la photo'"
      subtitle="Collez une URL d'image accessible publiquement."
      max-width="md"
      @close="closePhotoModal"
    >
      <div class="space-y-3">
        <label class="section-label block">URL de l'image</label>
        <input v-model="photoDraftUrl" class="input-shell" placeholder="https://example.com/photo.jpg" />
      </div>
      <template #footer>
        <div class="flex items-center justify-end gap-2">
          <button type="button" class="btn-secondary" @click="closePhotoModal">Annuler</button>
          <button type="button" class="btn-primary" @click="savePhotoDraft">
            {{ editingPhotoIndex === null ? "Ajouter" : "Mettre à jour" }}
          </button>
        </div>
      </template>
    </Modal>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { useRouter } from "vue-router";
import { toast } from "vue-sonner";
import {
  PlusIcon,
  TrashIcon,
  PencilIcon
} from "@heroicons/vue/24/outline";

import type { ProSalonUpdateInput } from "@/lib/generated";
import { proSalonUpdateInputSchema } from "@beauteavenue/contracts";
import { validateForm } from "@beauteavenue/shared-ts";
import { fetchProSalon, updateProSalon, uploadProMedia, deleteProMediaAsset } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";
import Modal from "@/components/Modal.vue";

const saving = ref(false);
const locating = ref(false);
const locationAccuracyMeters = ref<number | null>(null);
const locationCapturedAt = ref<string | null>(null);
const photoUploadInput = ref<HTMLInputElement | null>(null);
const logoUploadInput = ref<HTMLInputElement | null>(null);

const categories = ["Coiffure", "Barbershop", "Esthétique", "Ongles", "Spa", "Maquillage"];
const cities = ["Dakar", "Saint-Louis", "Thiès", "Saly", "Ziguinchor"];
const auth = useProAuthStore();
const queryClient = useQueryClient();
const router = useRouter();

interface GalleryPhoto {
  url: string;
  assetId?: string;
}

const photos = ref<GalleryPhoto[]>([]);
const uploadingPhoto = ref(false);
const uploadingLogo = ref(false);
const logoAssetId = ref<string | undefined>(undefined);
const showPhotoModal = ref(false);
const editingPhotoIndex = ref<number | null>(null);
const photoDraftUrl = ref("");

const profile = reactive({
  name: "Mon salon",
  category: "Coiffure",
  logoUrl: "",
  city: "Dakar",
  address: "",
  neighborhood: "",
  latitude: "",
  longitude: "",
  description: "",
  phone: "",
  instagram: ""
});

const cityOptions = computed(() => {
  if (!profile.city.trim()) return cities;
  if (cities.includes(profile.city)) return cities;
  return [profile.city, ...cities];
});

const salonQuery = useQuery({
  queryKey: ["pro-salon"],
  queryFn: () => fetchProSalon(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner))
});

const salonTier = computed(() => (salonQuery.data.value as Record<string, unknown> | undefined)?.subscriptionTier as string | undefined);

const galleryLimit = computed(() => salonTier.value === "premium" ? 50 : 3);

const galleryRemaining = computed(() => galleryLimit.value - photos.value.length);

const isGalleryFull = computed(() => galleryRemaining.value <= 0);

const galleryLimitTooltip = computed(() => {
  if (salonTier.value === "premium") return "Limite de 50 photos atteinte.";
  return "Plan Standard limité à 3 photos. Passez en Premium pour en ajouter plus.";
});

const hasNoCoordinates = computed(() => {
  return !profile.latitude.trim() && !profile.longitude.trim();
});

let hadCoordinatesBefore = false;

const saveMutation = useMutation({
  mutationFn: (payload: ProSalonUpdateInput) => updateProSalon(auth.accessToken ?? "", payload),
  onSuccess: async () => {
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ["pro-salon"] }),
      auth.restoreSession()
    ]);
    toast.success("Profil mis à jour.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Mise à jour impossible pour le moment."));
  },
  onSettled: () => {
    saving.value = false;
  }
});

const uploadMutation = useMutation({
  mutationFn: (file: File) => uploadProMedia(auth.accessToken ?? "", file, "salon_gallery"),
  onMutate: () => {
    uploadingPhoto.value = true;
  },
  onSuccess: (asset) => {
    photos.value = [...photos.value, { url: asset.publicUrl, assetId: asset.id }];
    toast.success("Photo téléversée.");
  },
  onError: async (error) => {
    if (typeof error === "object" && error !== null && "code" in error && (error as { code?: string }).code === "gallery_limit_reached") {
      toast.error("Plan Standard limité à 3 photos. Passez en Premium pour en ajouter plus.");
      await router.push({
        path: "/pro/subscription",
        query: { upgrade: "gallery_limit" }
      });
      return;
    }
    toast.error(getErrorMessage(error, "Téléversement impossible pour le moment."));
  },
  onSettled: () => {
    uploadingPhoto.value = false;
  }
});

const uploadLogoMutation = useMutation({
  mutationFn: (file: File) => uploadProMedia(auth.accessToken ?? "", file, "salon_logo"),
  onMutate: () => {
    uploadingLogo.value = true;
  },
  onSuccess: (asset) => {
    profile.logoUrl = asset.publicUrl;
    logoAssetId.value = asset.id;
    toast.success("Logo téléversé.");
  },
  onError: (error) => {
    toast.error(getErrorMessage(error, "Téléversement du logo impossible pour le moment."));
  },
  onSettled: () => {
    uploadingLogo.value = false;
  }
});

function removePhoto(index: number) {
  const photo = photos.value[index];
  if (photo.assetId) {
    deleteProMediaAsset(auth.accessToken ?? "", photo.assetId).catch(() => {
      // Silent fail — asset will eventually be cleaned up or user can retry
    });
  }
  photos.value.splice(index, 1);
}

function triggerLogoUpload() {
  logoUploadInput.value?.click();
}

function onLogoSelected(event: Event) {
  const input = event.target as HTMLInputElement | null;
  const file = input?.files?.[0];
  if (!file) return;
  if (!file.type.startsWith("image/")) {
    toast.error("Veuillez sélectionner une image.");
    if (input) input.value = "";
    return;
  }
  uploadLogoMutation.mutate(file);
  if (input) input.value = "";
}

function removeLogo() {
  if (logoAssetId.value) {
    deleteProMediaAsset(auth.accessToken ?? "", logoAssetId.value).catch(() => {});
    logoAssetId.value = undefined;
  }
  profile.logoUrl = "";
}

function triggerPhotoUpload() {
  photoUploadInput.value?.click();
}

function onPhotoSelected(event: Event) {
  const input = event.target as HTMLInputElement | null;
  const file = input?.files?.[0];
  if (!file) return;
  if (!file.type.startsWith("image/")) {
    toast.error("Veuillez sélectionner une image.");
    if (input) input.value = "";
    return;
  }
  uploadMutation.mutate(file);
  if (input) input.value = "";
}

function normalizePhotoUrl(raw: string) {
  return raw.trim();
}

function isValidPhotoUrl(url: string) {
  if (url.startsWith("/")) return true;
  try {
    const parsed = new URL(url);
    return parsed.protocol === "http:" || parsed.protocol === "https:";
  } catch {
    return false;
  }
}

function openAddPhotoModal() {
  editingPhotoIndex.value = null;
  photoDraftUrl.value = "";
  showPhotoModal.value = true;
}

function openEditPhotoModal(index: number) {
  editingPhotoIndex.value = index;
  photoDraftUrl.value = photos.value[index]?.url ?? "";
  showPhotoModal.value = true;
}

function closePhotoModal() {
  showPhotoModal.value = false;
  editingPhotoIndex.value = null;
  photoDraftUrl.value = "";
}

function savePhotoDraft() {
  const normalized = normalizePhotoUrl(photoDraftUrl.value);
  if (!normalized) {
    toast.error("L'URL de la photo est requise.");
    return;
  }
  if (!isValidPhotoUrl(normalized)) {
    toast.error("URL invalide. Utilisez http(s)://... ou /static/...");
    return;
  }

  if (editingPhotoIndex.value === null) {
    photos.value = [...photos.value, { url: normalized }];
  } else {
    photos.value.splice(editingPhotoIndex.value, 1, { url: normalized });
  }
  closePhotoModal();
}

function parseCoordinate(raw: string, label: string, min: number, max: number): number | null {
  const normalized = raw.trim();
  if (!normalized) return null;
  const value = Number(normalized.replace(",", "."));
  if (!Number.isFinite(value) || value < min || value > max) {
    throw new Error(`${label} invalide. Valeur attendue entre ${min} et ${max}.`);
  }
  return value;
}

function parseCoordinateLenient(raw: string, min: number, max: number): number | null {
  const normalized = raw.trim();
  if (!normalized) return null;
  const value = Number(normalized.replace(",", "."));
  if (!Number.isFinite(value) || value < min || value > max) return null;
  return value;
}

function useCurrentLocation() {
  if (typeof window === "undefined" || !("geolocation" in navigator)) {
    toast.error("La géolocalisation n'est pas disponible sur cet appareil.");
    return;
  }

  locating.value = true;
  navigator.geolocation.getCurrentPosition(
    async (position) => {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;

      profile.latitude = lat.toFixed(6);
      profile.longitude = lng.toFixed(6);

      locationAccuracyMeters.value = Math.round(position.coords.accuracy);
      locationCapturedAt.value = new Date().toLocaleTimeString("fr-FR", {
        hour: "2-digit",
        minute: "2-digit"
      });

      // Reverse geocode to fill in address fields
      try {
        const response = await fetch(
          `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&zoom=18&addressdetails=1&accept-language=fr`
        );
        if (response.ok) {
          const data = await response.json();
          if (data.address) {
            const addr = data.address;
            const house = addr.house_number ?? "";
            const road = addr.road ?? "";
            const streetParts = [house, road].filter(Boolean);
            profile.address = streetParts.length > 0
              ? streetParts.join(" ")
              : (data.display_name ?? "").split(",").slice(0, 2).join(",").trim();

            const city = addr.city ?? addr.town ?? addr.village ?? addr.municipality ?? addr.county ?? "";
            if (city) {
              const matchedCity = cities.find(c => c.toLowerCase() === city.toLowerCase());
              if (matchedCity) {
                profile.city = matchedCity;
              } else {
                profile.city = city.charAt(0).toUpperCase() + city.slice(1);
              }
            }

            const neighborhood = addr.neighbourhood ?? addr.suburb ?? addr.quarter ?? addr.city_district ?? "";
            if (neighborhood) profile.neighborhood = neighborhood;
          }
        }
      } catch {
        // Reverse geocode failed silently — coordinates are still saved
      }

      locating.value = false;
      toast.success("Position détectée. Enregistrez le profil pour la sauvegarder.");
    },
    (error) => {
      locating.value = false;
      const messageByCode: Record<number, string> = {
        1: "Accès à la localisation refusé. Autorisez-la dans votre navigateur.",
        2: "Position indisponible pour le moment.",
        3: "Délai de localisation dépassé. Réessayez."
      };
      toast.error(messageByCode[error.code] ?? "Impossible de récupérer votre position.");
    },
    {
      enableHighAccuracy: true,
      timeout: 10000,
      maximumAge: 60000
    }
  );
}

async function saveProfile() {
  try {
    saving.value = true;
    const phone = profile.phone.trim();
    const instagram = profile.instagram.trim();
    const neighborhood = profile.neighborhood.trim();
    const logoUrl = profile.logoUrl.trim();
    let lat: number | null = null;
    let lng: number | null = null;
    try {
      lat = profile.latitude.trim() ? parseCoordinate(profile.latitude, "Latitude", -90, 90) : null;
      lng = profile.longitude.trim() ? parseCoordinate(profile.longitude, "Longitude", -180, 180) : null;
    } catch (e) {
      toast.error((e as Error).message);
      saving.value = false;
      return;
    }
    const payload = {
      category: profile.category,
      logoUrl: logoUrl.length > 0 ? logoUrl : null,
      description: profile.description.trim(),
      city: profile.city,
      address: profile.address.trim(),
      neighborhood: neighborhood.length > 0 ? neighborhood : null,
      latitude: lat,
      longitude: lng,
      phone: phone.length > 0 ? phone : null,
      instagram: instagram.length > 0 ? instagram : null,
      gallery: photos.value.map((photo) => photo.url.trim()).filter((url) => url.length > 0)
    };
    const result = validateForm(proSalonUpdateInputSchema, payload);
    if (!result.success) {
      const firstError = Object.values(result.errors)[0];
      toast.error(firstError ?? result.formError ?? "Corrigez les champs.");
      saving.value = false;
      return;
    }
    saveMutation.mutate(result.data as ProSalonUpdateInput);
  } catch (error) {
    saving.value = false;
    toast.error("Erreur lors de la sauvegarde du profil.");
  }
}

watch(
  () => [profile.latitude, profile.longitude],
  ([latRaw, lngRaw]) => {
    // Detect when user clears coordinates after they were previously set
    if (hadCoordinatesBefore && !latRaw.trim() && !lngRaw.trim()) {
      toast.info("Sans position, votre salon n'apparaîtra pas dans les résultats « Près de vous ».", {
        duration: 5000,
      });
    }

    const lat = parseCoordinateLenient(latRaw, -90, 90);
    const lng = parseCoordinateLenient(lngRaw, -180, 180);

    if (lat === null || lng === null) {
      hadCoordinatesBefore = false;
      return;
    }
    hadCoordinatesBefore = true;
  }
);

watch(
  () => salonQuery.data.value,
  (salon) => {
    if (!salon) return;
    profile.name = salon.name;
    profile.category = salon.category;
    profile.logoUrl = salon.logoUrl ?? "";
    logoAssetId.value = undefined;
    profile.city = salon.city;
    profile.address = salon.address;
    profile.neighborhood = salon.neighborhood ?? "";
    profile.latitude = salon.latitude === null ? "" : String(salon.latitude);
    profile.longitude = salon.longitude === null ? "" : String(salon.longitude);
    locationAccuracyMeters.value = null;
    locationCapturedAt.value = null;
    // Track initial coordinate state for clearance detection
    const hasInitialCoords = salon.latitude !== null && salon.longitude !== null;
    hadCoordinatesBefore = hasInitialCoords;

    profile.description = salon.description;
    profile.phone = salon.phone ?? "";
    profile.instagram = salon.instagram ?? "";
    photos.value = salon.gallery.map((url: string) => ({ url }));
  },
  { immediate: true }
);

</script>
