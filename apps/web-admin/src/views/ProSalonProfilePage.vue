<template>
  <div class="max-w-4xl mx-auto">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Profil du Salon</h1>
        <p class="text-cocoa/60">Gérez l'apparence de votre salon sur la marketplace.</p>
      </div>
      <button @click="saveProfile" :disabled="saving" class="btn-primary px-8">
        {{ saving ? 'Enregistrement...' : 'Enregistrer' }}
      </button>
    </div>

    <div class="space-y-8">
      <!-- Photos -->
      <section class="panel-clean p-8">
        <h2 class="section-label mb-6">Photos & Galerie</h2>
        
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
          <div v-for="(photo, index) in photos" :key="index" class="relative group aspect-square rounded-2xl overflow-hidden bg-neutral-bg">
            <img :src="photo" class="w-full h-full object-cover transition group-hover:scale-110" />
            <div class="absolute inset-0 bg-espresso/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center gap-2">
              <button class="p-2 bg-white rounded-full text-espresso hover:text-primary"><PencilIcon class="w-4 h-4" /></button>
              <button @click="removePhoto(index)" class="p-2 bg-white rounded-full text-espresso hover:text-error"><TrashIcon class="w-4 h-4" /></button>
            </div>
          </div>
          <button class="aspect-square rounded-2xl border-2 border-dashed border-outline-variant flex flex-col items-center justify-center gap-2 text-cocoa/40 hover:border-primary/40 hover:text-primary transition group">
            <PlusIcon class="w-8 h-8 group-hover:scale-110 transition" />
            <span class="text-[10px] font-bold uppercase tracking-widest">Ajouter</span>
          </button>
        </div>
        <p class="text-[10px] text-cocoa/40 italic">Format recommandé: 16:9, max 5Mo par photo. Glissez pour réordonner.</p>
      </section>

      <!-- Identity -->
      <section class="panel-clean p-8 space-y-6">
        <h2 class="section-label mb-2">Informations Générales</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Nom commercial</label>
            <input type="text" v-model="profile.name" class="input-shell" />
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
              <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
            </select>
          </div>

          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Adresse complète</label>
            <input type="text" v-model="profile.address" class="input-shell" placeholder="Rue..., Quartier..." />
          </div>

          <div class="md:col-span-2">
            <label class="section-label mb-2 block">Description</label>
            <textarea v-model="profile.description" class="input-shell h-32" placeholder="Présentez votre salon, votre expertise..."></textarea>
          </div>
        </div>
      </section>

      <!-- Contact -->
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
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue";
import { toast } from "vue-sonner";
import { 
  PlusIcon, 
  TrashIcon, 
  PencilIcon 
} from "@heroicons/vue/24/outline";

const saving = ref(false);
const categories = ["Coiffure", "Barbershop", "Esthétique", "Ongles", "Spa", "Maquillage"];
const cities = ["Dakar", "Saint-Louis", "Thiès", "Saly", "Ziguinchor"];

const photos = ref([
  "https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&q=80",
  "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?auto=format&fit=crop&q=80",
  "https://images.unsplash.com/photo-1562322140-8baeececf3df?auto=format&fit=crop&q=80"
]);

const profile = reactive({
  name: "Beauté Divine",
  category: "Coiffure",
  city: "Dakar",
  address: "Quartier Plateau, Rue du Commerce",
  description: "Bienvenue chez Beauté Divine, votre sanctuaire de beauté au cœur de Dakar. Nous sommes spécialisés dans les soins capillaires haut de gamme et les tresses artistiques.",
  phone: "+221 77 123 45 67",
  instagram: "@beautedivine_dakar"
});

function removePhoto(index: number) {
  photos.value.splice(index, 1);
}

async function saveProfile() {
  saving.value = true;
  setTimeout(() => {
    saving.value = false;
    toast.success("Profil mis à jour !");
  }, 1000);
}
</script>
