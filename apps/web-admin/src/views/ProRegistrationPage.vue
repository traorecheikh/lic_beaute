<template>
  <div class="min-h-screen bg-neutral-bg py-12 px-4 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-2xl">
      <!-- Header -->
      <div class="text-center mb-12">
        <RouterLink to="/pro" class="inline-block mb-8">
          <img src="/logo.png" alt="Beauté Avenue" class="h-12 w-auto mx-auto" />
        </RouterLink>
        <h1 class="text-3xl font-display text-espresso mb-2">Inscrivez votre salon</h1>
        <p class="text-cocoa/60">Rejoignez Beauté Avenue en moins de 5 minutes.</p>
      </div>

      <!-- Stepper -->
      <div class="flex items-center justify-between mb-12 relative">
        <div class="absolute top-1/2 left-0 w-full h-0.5 bg-outline-variant -translate-y-1/2 -z-10"></div>
        <div 
          v-for="step in 5" 
          :key="step"
          :class="[
            'w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm transition-all',
            currentStep >= step ? 'bg-primary text-white' : 'bg-surface text-cocoa/40 border border-outline-variant'
          ]"
        >
          {{ step }}
        </div>
      </div>

      <!-- Form Steps -->
      <div class="panel-clean p-8 mb-8">
        <!-- Step 1: Identity -->
        <div v-if="currentStep === 1">
          <h2 class="text-xl font-display text-espresso mb-6">Étape 1 : Votre Identité</h2>
          <div class="space-y-4">
            <div>
              <label class="section-label mb-2 block">Nom complet</label>
              <input type="text" v-model="form.fullName" class="input-shell" placeholder="Marie Diop" />
            </div>
            <div>
              <label class="section-label mb-2 block">Email professionnel</label>
              <input type="email" v-model="form.email" class="input-shell" placeholder="marie@monsalon.com" />
            </div>
            <div>
              <label class="section-label mb-2 block">Téléphone (+221)</label>
              <input type="tel" v-model="form.phone" class="input-shell" placeholder="77 123 45 67" />
            </div>
            <div>
              <label class="section-label mb-2 block">Mot de passe</label>
              <input type="password" v-model="form.password" class="input-shell" placeholder="••••••••" />
            </div>
          </div>
        </div>

        <!-- Step 2: Salon -->
        <div v-if="currentStep === 2">
          <h2 class="text-xl font-display text-espresso mb-6">Étape 2 : Votre Salon</h2>
          <div class="space-y-4">
            <div>
              <label class="section-label mb-2 block">Nom du salon</label>
              <input type="text" v-model="form.salonName" class="input-shell" placeholder="Beauté Divine" />
            </div>
            <div>
              <label class="section-label mb-2 block">Catégorie</label>
              <select v-model="form.category" class="input-shell">
                <option value="">Sélectionnez une catégorie</option>
                <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
              </select>
            </div>
            <div>
              <label class="section-label mb-2 block">Ville</label>
              <select v-model="form.city" class="input-shell">
                <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
              </select>
            </div>
            <div>
              <label class="section-label mb-2 block">Adresse précise</label>
              <textarea v-model="form.address" class="input-shell h-24" placeholder="Quartier Plateau, Rue des Poilus..."></textarea>
            </div>
          </div>
        </div>

        <!-- Step 3: Services -->
        <div v-if="currentStep === 3">
          <h2 class="text-xl font-display text-espresso mb-6">Étape 3 : Vos Prestations</h2>
          <div class="space-y-4">
            <div v-for="(service, index) in form.services" :key="index" class="p-4 bg-neutral-bg rounded-xl relative">
              <button v-if="form.services.length > 1" @click="removeService(index)" class="absolute top-2 right-2 text-error p-1">
                <XMarkIcon class="w-4 h-4" />
              </button>
              <div class="grid grid-cols-2 gap-4">
                <div class="col-span-2">
                  <label class="section-label mb-1 block">Nom du service</label>
                  <input type="text" v-model="service.name" class="input-shell" placeholder="Brushing" />
                </div>
                <div>
                  <label class="section-label mb-1 block">Durée (min)</label>
                  <input type="number" v-model="service.duration" class="input-shell" placeholder="45" />
                </div>
                <div>
                  <label class="section-label mb-1 block">Prix (FCFA)</label>
                  <input type="number" v-model="service.price" class="input-shell" placeholder="15000" />
                </div>
              </div>
            </div>
            <button @click="addService" class="btn-secondary w-full py-3 border-dashed border-2 ring-0">
              <PlusIcon class="w-4 h-4 mr-2" />
              Ajouter une prestation
            </button>
          </div>
        </div>

        <!-- Step 4: Hours -->
        <div v-if="currentStep === 4">
          <h2 class="text-xl font-display text-espresso mb-6">Étape 4 : Vos Horaires</h2>
          <div class="space-y-3">
            <div v-for="day in days" :key="day" class="flex items-center gap-4 py-2">
              <div class="w-24 text-sm font-semibold text-espresso">{{ day }}</div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" v-model="form.hours[day].open" class="sr-only peer">
                <div class="w-11 h-6 bg-outline-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
              <div v-if="form.hours[day].open" class="flex items-center gap-2 flex-1">
                <input type="time" v-model="form.hours[day].start" class="input-shell py-1 px-2" />
                <span class="text-cocoa/40">à</span>
                <input type="time" v-model="form.hours[day].end" class="input-shell py-1 px-2" />
              </div>
              <div v-else class="flex-1 text-sm text-cocoa/40 italic">Fermé</div>
            </div>
          </div>
        </div>

        <!-- Step 5: Confirmation -->
        <div v-if="currentStep === 5">
          <h2 class="text-xl font-display text-espresso mb-6">Étape 5 : Confirmation</h2>
          <div class="space-y-6">
            <div class="flex items-center gap-4 p-4 bg-primary/5 rounded-2xl">
              <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary">
                <BuildingStorefrontIcon class="w-6 h-6" />
              </div>
              <div>
                <p class="font-bold text-espresso">{{ form.salonName }}</p>
                <p class="text-sm text-cocoa/60">{{ form.category }} • {{ form.city }}</p>
              </div>
            </div>
            
            <div class="panel-clean p-4 border-dashed">
              <p class="text-sm text-cocoa/60 leading-relaxed italic">
                En cliquant sur "Terminer", vous acceptez nos conditions d'utilisation. Votre salon sera soumis à validation par notre équipe (généralement sous 24h).
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Navigation -->
      <div class="flex items-center justify-between gap-4">
        <button v-if="currentStep > 1" @click="currentStep--" class="btn-secondary px-8">Retour</button>
        <div v-else></div>
        
        <button v-if="currentStep < 5" @click="currentStep++" class="btn-primary flex-1 sm:flex-none px-12">Continuer</button>
        <button v-else @click="submitRegistration" :disabled="loading" class="btn-primary flex-1 sm:flex-none px-12">
          {{ loading ? 'Chargement...' : 'Terminer' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue";
import { useRouter } from "vue-router";
import { toast } from "vue-sonner";
import { 
  XMarkIcon, 
  PlusIcon,
  BuildingStorefrontIcon
} from "@heroicons/vue/24/outline";
import { getErrorMessage } from "@/lib/errors";
import { registerProOwner } from "@/lib/pro-api";

const router = useRouter();
const currentStep = ref(1);
const loading = ref(false);

const categories = ["Coiffure", "Barbershop", "Esthétique", "Ongles", "Spa", "Maquillage"];
const cities = ["Dakar", "Saint-Louis", "Thiès", "Saly", "Ziguinchor"];
const days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];
const dayOfWeekByLabel: Record<string, number> = {
  Lundi: 1,
  Mardi: 2,
  Mercredi: 3,
  Jeudi: 4,
  Vendredi: 5,
  Samedi: 6,
  Dimanche: 0
};

const form = reactive({
  fullName: "",
  email: "",
  phone: "",
  password: "",
  salonName: "",
  category: "",
  city: "Dakar",
  address: "",
  services: [
    { name: "", duration: 30, price: 5000 }
  ],
  hours: days.reduce((acc, day) => {
    acc[day] = { open: true, start: "09:00", end: "19:00" };
    return acc;
  }, {} as any)
});

function addService() {
  form.services.push({ name: "", duration: 30, price: 5000 });
}

function removeService(index: number) {
  form.services.splice(index, 1);
}

async function submitRegistration() {
  const email = form.email.trim();
  const phone = form.phone.replace(/\s+/g, "");
  const fullName = form.fullName.trim();
  const salonName = form.salonName.trim();

  if (!fullName || !email || !phone || !form.password || !salonName || !form.category || !form.city || !form.address.trim()) {
    toast.error("Veuillez compléter tous les champs obligatoires.");
    return;
  }

  const validServices = form.services
    .map((service) => ({
      name: service.name.trim(),
      durationMinutes: Number(service.duration),
      priceXof: Number(service.price)
    }))
    .filter((service) => service.name && service.durationMinutes > 0 && service.priceXof >= 0);

  if (validServices.length === 0) {
    toast.error("Ajoutez au moins une prestation valide.");
    return;
  }

  loading.value = true;
  try {
    await registerProOwner({
      type: "salon_owner",
      fullName,
      email,
      phone,
      password: form.password,
      salon: {
        name: salonName,
        category: form.category,
        city: form.city,
        address: form.address.trim(),
        description: ""
      },
      services: validServices.map((service) => ({
        name: service.name,
        durationMinutes: service.durationMinutes,
        priceXof: service.priceXof,
        depositMode: "none" as const
      })),
      hours: days.map((day) => ({
        dayOfWeek: dayOfWeekByLabel[day],
        isOpen: Boolean(form.hours[day].open),
        opensAt: form.hours[day].open ? form.hours[day].start : undefined,
        closesAt: form.hours[day].open ? form.hours[day].end : undefined
      }))
    });

    toast.success("Salon créé avec succès ! Vous pouvez maintenant vous connecter.");
    await router.push({
      path: "/pro/login",
      query: { email }
    });
  } catch (error) {
    toast.error(getErrorMessage(error, "Inscription impossible pour le moment."));
  } finally {
    loading.value = false;
  }
}
</script>
