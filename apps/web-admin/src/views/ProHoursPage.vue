<template>
  <div class="max-w-2xl mx-auto">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Horaires d'ouverture</h1>
        <p class="text-cocoa/60">Définissez vos jours et heures de travail hebdomadaires.</p>
      </div>
      <button @click="saveHours" :disabled="saving" class="btn-primary px-8">
        {{ saving ? 'Enregistrement...' : 'Enregistrer' }}
      </button>
    </div>

    <div class="panel-clean p-8">
      <div class="space-y-6">
        <div v-for="day in days" :key="day" class="flex items-center gap-6 py-3 border-b border-outline-variant/30 last:border-0 group">
          <div class="w-32 text-sm font-bold text-espresso">{{ day }}</div>
          
          <label class="relative inline-flex items-center cursor-pointer">
            <input type="checkbox" v-model="hours[day].open" class="sr-only peer">
            <div class="w-11 h-6 bg-outline-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
          </label>

          <div v-if="hours[day].open" class="flex-1 flex items-center gap-3">
            <div class="flex-1">
              <input type="time" v-model="hours[day].start" class="input-shell py-2" />
            </div>
            <span class="text-cocoa/30 font-bold">à</span>
            <div class="flex-1">
              <input type="time" v-model="hours[day].end" class="input-shell py-2" />
            </div>
          </div>
          <div v-else class="flex-1 text-sm text-cocoa/30 italic font-medium">Fermé toute la journée</div>

          <button v-if="hours[day].open" @click="copyToAll(day)" class="opacity-0 group-hover:opacity-100 transition p-2 text-primary hover:bg-primary/5 rounded-lg" title="Copier à tous les jours ouverts">
            <DocumentDuplicateIcon class="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>

    <div class="mt-8 flex items-center gap-4 p-4 bg-secondary-container/30 rounded-2xl border border-secondary/20">
      <div class="w-10 h-10 rounded-xl bg-secondary/10 flex items-center justify-center text-secondary">
        <InformationCircleIcon class="w-6 h-6" />
      </div>
      <p class="text-xs text-on-secondary-container/80 leading-relaxed">
        <strong>Note :</strong> Les modifications d'horaires s'appliquent uniquement aux nouvelles réservations. Les rendez-vous déjà confirmés ne seront pas déplacés.
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue";
import { toast } from "vue-sonner";
import { 
  DocumentDuplicateIcon,
  InformationCircleIcon
} from "@heroicons/vue/24/outline";

const saving = ref(false);
const days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];

const hours = reactive(days.reduce((acc, day) => {
  acc[day] = { 
    open: day !== "Dimanche", 
    start: "09:00", 
    end: "19:00" 
  };
  return acc;
}, {} as any));

function copyToAll(sourceDay: string) {
  const source = hours[sourceDay];
  days.forEach(day => {
    if (hours[day].open) {
      hours[day].start = source.start;
      hours[day].end = source.end;
    }
  });
  toast.success(`Horaires du ${sourceDay} copiés partout !`);
}

async function saveHours() {
  saving.value = true;
  setTimeout(() => {
    saving.value = false;
    toast.success("Horaires enregistrés.");
  }, 1000);
}
</script>
