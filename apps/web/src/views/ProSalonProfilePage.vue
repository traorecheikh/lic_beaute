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
            <img :src="photo" class="w-full h-full object-cover transition group-hover:scale-110" />
            <div class="absolute inset-0 bg-espresso/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center gap-2">
              <button type="button" @click="openEditPhotoModal(index)" class="p-2 bg-white rounded-full text-espresso hover:text-primary">
                <PencilIcon class="w-4 h-4" />
              </button>
              <button type="button" @click="removePhoto(index)" class="p-2 bg-white rounded-full text-espresso hover:text-error">
                <TrashIcon class="w-4 h-4" />
              </button>
            </div>
          </div>
          <button type="button" @click="triggerPhotoUpload" class="aspect-square rounded-2xl border-2 border-dashed border-outline-variant flex flex-col items-center justify-center gap-2 text-cocoa/40 hover:border-primary/40 hover:text-primary transition group">
            <PlusIcon class="w-8 h-8 group-hover:scale-110 transition" />
            <span class="text-[10px] font-bold uppercase tracking-widest">Ajouter</span>
          </button>
        </div>
        <div class="flex flex-wrap items-center gap-2">
          <input ref="photoUploadInput" type="file" accept="image/*" class="hidden" @change="onPhotoSelected" />
          <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="triggerPhotoUpload" :disabled="uploadingPhoto">
            {{ uploadingPhoto ? "Téléversement..." : "Téléverser une photo" }}
          </button>
          <button type="button" class="btn-secondary px-3 py-1 text-[10px]" @click="openAddPhotoModal">
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
            <label class="section-label mb-2 block">Rechercher une adresse</label>
            <div class="relative">
              <input
                type="text"
                v-model="locationQuery"
                class="input-shell"
                placeholder="Ex: Route des Almadies, Dakar"
                @input="queueAddressLookup"
                @focus="openAddressSuggestions"
                @blur="closeAddressSuggestions"
              />
              <div v-if="searchingAddress" class="absolute right-3 top-1/2 -translate-y-1/2 row-meta">
                Recherche...
              </div>
              <ul
                v-if="showAddressSuggestions"
                class="absolute z-20 mt-2 w-full rounded-2xl border border-outline-variant bg-white shadow-sm max-h-56 overflow-auto"
              >
                <li
                  v-for="suggestion in addressSuggestions"
                  :key="suggestion.place_id"
                  class="px-4 py-3 cursor-pointer hover:bg-neutral-bg"
                  @mousedown.prevent="selectAddressSuggestion(suggestion)"
                >
                  <p class="row-primary">{{ suggestion.display_name }}</p>
                </li>
              </ul>
            </div>
            <p class="row-meta mt-2">
              Sélectionnez une suggestion pour remplir automatiquement l'adresse, la ville et la position.
            </p>
          </div>

          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Adresse complète</label>
            <input type="text" v-model="profile.address" class="input-shell" placeholder="Rue..., Quartier..." />
          </div>

          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Position sur la carte</label>
            <div ref="mapContainer" class="h-80 w-full rounded-2xl border border-outline-variant"></div>
            <p class="row-meta mt-2">Cliquez sur la carte ou déplacez l'épingle pour ajuster la localisation exacte.</p>
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
            <button type="button" class="btn-secondary px-4 py-2" :disabled="reverseGeocoding" @click="reverseGeocodeFromFields">
              {{ reverseGeocoding ? "Mise à jour..." : "Actualiser adresse depuis la carte" }}
            </button>
            <p v-if="locationCapturedAt" class="row-meta">
              Position capturée{{ locationAccuracyMeters === null ? "" : ` (±${locationAccuracyMeters}m)` }} · {{ locationCapturedAt }}
            </p>
          </div>

          <p class="row-meta md:col-span-2">
            Astuce: après déplacement du pin, cliquez sur "Actualiser adresse depuis la carte" pour recalculer l'adresse texte.
          </p>

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
import { computed, onBeforeUnmount, onMounted, reactive, ref, watch } from "vue";
import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { toast } from "vue-sonner";
import {
  PlusIcon,
  TrashIcon,
  PencilIcon
} from "@heroicons/vue/24/outline";
import L from "leaflet";
import type { LeafletMouseEvent, Map as LeafletMap, Marker as LeafletMarker } from "leaflet";
import markerIconRetinaUrl from "leaflet/dist/images/marker-icon-2x.png";
import markerIconUrl from "leaflet/dist/images/marker-icon.png";
import markerShadowUrl from "leaflet/dist/images/marker-shadow.png";
import "leaflet/dist/leaflet.css";

import type { ProSalonUpdateInput } from "@/lib/generated";
import { fetchProSalon, updateProSalon, uploadProMedia } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";
import { getErrorMessage } from "@/lib/errors";
import Modal from "@/components/Modal.vue";

interface NominatimAddress {
  house_number?: string;
  road?: string;
  neighbourhood?: string;
  suburb?: string;
  quarter?: string;
  city_district?: string;
  city?: string;
  town?: string;
  village?: string;
  municipality?: string;
  county?: string;
}

interface NominatimResult {
  place_id: number;
  display_name: string;
  lat: string;
  lon: string;
  address?: NominatimAddress;
}

const DAKAR_COORDS = { lat: 14.7167, lng: -17.4677 };

L.Icon.Default.mergeOptions({
  iconRetinaUrl: markerIconRetinaUrl,
  iconUrl: markerIconUrl,
  shadowUrl: markerShadowUrl
});

const saving = ref(false);
const locating = ref(false);
const searchingAddress = ref(false);
const reverseGeocoding = ref(false);
const locationAccuracyMeters = ref<number | null>(null);
const locationCapturedAt = ref<string | null>(null);
const locationQuery = ref("");
const addressSuggestions = ref<NominatimResult[]>([]);
const showAddressSuggestions = ref(false);
const mapContainer = ref<HTMLElement | null>(null);
const photoUploadInput = ref<HTMLInputElement | null>(null);
const logoUploadInput = ref<HTMLInputElement | null>(null);

let mapInstance: LeafletMap | null = null;
let markerInstance: LeafletMarker | null = null;
let addressSearchTimer: ReturnType<typeof setTimeout> | null = null;

const categories = ["Coiffure", "Barbershop", "Esthétique", "Ongles", "Spa", "Maquillage"];
const cities = ["Dakar", "Saint-Louis", "Thiès", "Saly", "Ziguinchor"];
const auth = useProAuthStore();
const queryClient = useQueryClient();

const photos = ref<string[]>([]);
const uploadingPhoto = ref(false);
const uploadingLogo = ref(false);
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
    photos.value = [...photos.value, asset.publicUrl];
    toast.success("Photo téléversée.");
  },
  onError: (error) => {
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
  photoDraftUrl.value = photos.value[index] ?? "";
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
    photos.value = [...photos.value, normalized];
  } else {
    photos.value.splice(editingPhotoIndex.value, 1, normalized);
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

function updateCoordinates(lat: number, lng: number) {
  profile.latitude = lat.toFixed(6);
  profile.longitude = lng.toFixed(6);
}

function extractCity(address?: NominatimAddress) {
  return address?.city ?? address?.town ?? address?.village ?? address?.municipality ?? address?.county ?? "";
}

function extractNeighborhood(address?: NominatimAddress) {
  return address?.neighbourhood ?? address?.suburb ?? address?.quarter ?? address?.city_district ?? "";
}

function extractStreetAddress(result: NominatimResult) {
  const house = result.address?.house_number;
  const road = result.address?.road;
  const compact = [house, road].filter((part): part is string => Boolean(part && part.trim().length > 0));
  if (compact.length > 0) return compact.join(" ");
  return result.display_name.split(",").slice(0, 2).join(",").trim();
}

function syncMapMarker(lat: number, lng: number, pan = true) {
  if (!markerInstance || !mapInstance) return;
  markerInstance.setLatLng([lat, lng]);
  if (pan) mapInstance.setView([lat, lng], Math.max(mapInstance.getZoom(), 15));
}

function buildNominatimUrl(path: string, params: Record<string, string>) {
  const url = new URL(`https://nominatim.openstreetmap.org/${path}`);
  Object.entries(params).forEach(([key, value]) => url.searchParams.set(key, value));
  return url.toString();
}

async function reverseGeocode(lat: number, lng: number, silent = false) {
  reverseGeocoding.value = true;
  try {
    const url = buildNominatimUrl("reverse", {
      format: "jsonv2",
      lat: String(lat),
      lon: String(lng),
      zoom: "18",
      addressdetails: "1",
      "accept-language": "fr"
    });
    const response = await fetch(url);
    if (!response.ok) throw new Error("reverse_failed");
    const result = (await response.json()) as NominatimResult;

    profile.address = extractStreetAddress(result);
    const city = extractCity(result.address);
    if (city) profile.city = city;
    const neighborhood = extractNeighborhood(result.address);
    if (neighborhood) profile.neighborhood = neighborhood;
    locationQuery.value = result.display_name;
  } catch {
    if (!silent) {
      toast.error("Impossible de recalculer l'adresse à partir des coordonnées.");
    }
  } finally {
    reverseGeocoding.value = false;
  }
}

function applySuggestion(result: NominatimResult, pan = true) {
  const lat = Number(result.lat);
  const lng = Number(result.lon);
  if (!Number.isFinite(lat) || !Number.isFinite(lng)) return;

  updateCoordinates(lat, lng);
  syncMapMarker(lat, lng, pan);
  profile.address = extractStreetAddress(result);

  const city = extractCity(result.address);
  if (city) profile.city = city;

  const neighborhood = extractNeighborhood(result.address);
  profile.neighborhood = neighborhood;

  locationQuery.value = result.display_name;
}

function openAddressSuggestions() {
  showAddressSuggestions.value = addressSuggestions.value.length > 0;
}

function closeAddressSuggestions() {
  window.setTimeout(() => {
    showAddressSuggestions.value = false;
  }, 120);
}

async function fetchAddressSuggestions(query: string) {
  searchingAddress.value = true;
  try {
    const url = buildNominatimUrl("search", {
      format: "jsonv2",
      q: query,
      addressdetails: "1",
      limit: "6",
      countrycodes: "sn",
      "accept-language": "fr"
    });
    const response = await fetch(url);
    if (!response.ok) throw new Error("search_failed");
    const results = (await response.json()) as NominatimResult[];
    addressSuggestions.value = results;
    showAddressSuggestions.value = results.length > 0;
  } catch {
    addressSuggestions.value = [];
    showAddressSuggestions.value = false;
    toast.error("La recherche d'adresse est indisponible pour le moment.");
  } finally {
    searchingAddress.value = false;
  }
}

function queueAddressLookup() {
  const query = locationQuery.value.trim();
  if (addressSearchTimer) clearTimeout(addressSearchTimer);
  if (query.length < 3) {
    addressSuggestions.value = [];
    showAddressSuggestions.value = false;
    return;
  }

  addressSearchTimer = setTimeout(() => {
    void fetchAddressSuggestions(query);
  }, 600);
}

function selectAddressSuggestion(result: NominatimResult) {
  applySuggestion(result);
  addressSuggestions.value = [];
  showAddressSuggestions.value = false;
}

function initializeMap() {
  if (!mapContainer.value || mapInstance) return;

  const initialLat = parseCoordinateLenient(profile.latitude, -90, 90) ?? DAKAR_COORDS.lat;
  const initialLng = parseCoordinateLenient(profile.longitude, -180, 180) ?? DAKAR_COORDS.lng;

  mapInstance = L.map(mapContainer.value, {
    center: [initialLat, initialLng],
    zoom: 14
  });

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution: "&copy; OpenStreetMap contributors"
  }).addTo(mapInstance);

  markerInstance = L.marker([initialLat, initialLng], { draggable: true }).addTo(mapInstance);

  markerInstance.on("dragend", () => {
    if (!markerInstance) return;
    const point = markerInstance.getLatLng();
    updateCoordinates(point.lat, point.lng);
    void reverseGeocode(point.lat, point.lng, true);
  });

  mapInstance.on("click", (event: LeafletMouseEvent) => {
    const { lat, lng } = event.latlng;
    updateCoordinates(lat, lng);
    syncMapMarker(lat, lng, false);
    void reverseGeocode(lat, lng, true);
  });

  window.setTimeout(() => {
    mapInstance?.invalidateSize();
  }, 0);
}

function reverseGeocodeFromFields() {
  try {
    const lat = parseCoordinate(profile.latitude, "Latitude", -90, 90);
    const lng = parseCoordinate(profile.longitude, "Longitude", -180, 180);
    if (lat === null || lng === null) {
      toast.error("Latitude et longitude requises pour recalculer l'adresse.");
      return;
    }
    syncMapMarker(lat, lng, true);
    void reverseGeocode(lat, lng);
  } catch (error) {
    toast.error(error instanceof Error ? error.message : "Coordonnées invalides.");
  }
}

function useCurrentLocation() {
  if (typeof window === "undefined" || !("geolocation" in navigator)) {
    toast.error("La géolocalisation n'est pas disponible sur cet appareil.");
    return;
  }

  locating.value = true;
  navigator.geolocation.getCurrentPosition(
    (position) => {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
      updateCoordinates(lat, lng);
      syncMapMarker(lat, lng);
      locationAccuracyMeters.value = Math.round(position.coords.accuracy);
      locationCapturedAt.value = new Date().toLocaleTimeString("fr-FR", {
        hour: "2-digit",
        minute: "2-digit"
      });
      locating.value = false;
      void reverseGeocode(lat, lng, true);
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
    const neighborhood = profile.neighborhood.trim();
    const phone = profile.phone.trim();
    const instagram = profile.instagram.trim();
    const logoUrl = profile.logoUrl.trim();
    const payload: ProSalonUpdateInput = {
      category: profile.category,
      logoUrl: logoUrl.length > 0 ? logoUrl : null,
      description: profile.description.trim(),
      city: profile.city,
      address: profile.address.trim(),
      neighborhood: neighborhood.length > 0 ? neighborhood : null,
      latitude: parseCoordinate(profile.latitude, "Latitude", -90, 90),
      longitude: parseCoordinate(profile.longitude, "Longitude", -180, 180),
      phone: phone.length > 0 ? phone : null,
      instagram: instagram.length > 0 ? instagram : null,
      gallery: photos.value.map((photo) => photo.trim()).filter((photo) => photo.length > 0)
    };
    saveMutation.mutate(payload);
  } catch (error) {
    saving.value = false;
    toast.error(
      error instanceof Error
        ? error.message
        : "Coordonnées invalides. Vérifiez la latitude et la longitude."
    );
  }
}

watch(
  () => [profile.latitude, profile.longitude],
  ([latRaw, lngRaw]) => {
    const lat = parseCoordinateLenient(latRaw, -90, 90);
    const lng = parseCoordinateLenient(lngRaw, -180, 180);
    if (lat === null || lng === null) return;
    syncMapMarker(lat, lng, false);
  }
);

watch(
  () => salonQuery.data.value,
  (salon) => {
    if (!salon) return;
    profile.name = salon.name;
    profile.category = salon.category;
    profile.logoUrl = salon.logoUrl ?? "";
    profile.city = salon.city;
    profile.address = salon.address;
    profile.neighborhood = salon.neighborhood ?? "";
    profile.latitude = salon.latitude === null ? "" : String(salon.latitude);
    profile.longitude = salon.longitude === null ? "" : String(salon.longitude);
    locationAccuracyMeters.value = null;
    locationCapturedAt.value = null;
    profile.description = salon.description;
    profile.phone = salon.phone ?? "";
    profile.instagram = salon.instagram ?? "";
    photos.value = [...salon.gallery];
    locationQuery.value = [salon.address, salon.city].filter(Boolean).join(", ");

    const lat = parseCoordinateLenient(profile.latitude, -90, 90);
    const lng = parseCoordinateLenient(profile.longitude, -180, 180);
    if (lat !== null && lng !== null) {
      syncMapMarker(lat, lng, true);
    }
  },
  { immediate: true }
);

onMounted(() => {
  initializeMap();
});

onBeforeUnmount(() => {
  if (addressSearchTimer) {
    clearTimeout(addressSearchTimer);
    addressSearchTimer = null;
  }
  markerInstance?.off();
  markerInstance = null;
  mapInstance?.off();
  mapInstance?.remove();
  mapInstance = null;
});
</script>
