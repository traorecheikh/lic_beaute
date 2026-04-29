<template>
  <div>
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Prestations</h1>
        <p class="text-cocoa/60">Gérez votre menu de services et vos tarifs.</p>
      </div>
      <button @click="addService" class="btn-primary gap-2">
        <PlusIcon class="w-4 h-4" />
        Nouvelle prestation
      </button>
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
                <input type="checkbox" v-model="service.active" class="sr-only peer">
                <div class="w-9 h-5 bg-outline-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </td>
            <td class="px-6 py-4">
              <p class="row-primary">{{ service.name }}</p>
              <p class="row-meta">{{ service.category }}</p>
            </td>
            <td class="px-6 py-4 text-sm text-espresso font-medium">{{ service.duration }} min</td>
            <td class="px-6 py-4 text-sm text-espresso font-bold">{{ service.price.toLocaleString() }} FCFA</td>
            <td class="px-6 py-4">
              <span v-if="service.deposit > 0" class="px-2 py-0.5 rounded-full bg-secondary/10 text-secondary text-[10px] font-bold uppercase tracking-wider">
                {{ service.deposit.toLocaleString() }} FCFA
              </span>
              <span v-else class="text-[10px] text-cocoa/30 italic font-semibold uppercase tracking-widest">Aucun</span>
            </td>
            <td class="px-6 py-4 text-right">
              <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
                <button class="p-2 hover:bg-white rounded-full text-cocoa/60 hover:text-espresso shadow-sm"><PencilIcon class="w-4 h-4" /></button>
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
      <button class="text-xs font-bold text-primary uppercase tracking-widest">En savoir plus</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { toast } from "vue-sonner";
import { 
  PlusIcon, 
  PencilIcon, 
  TrashIcon,
  InformationCircleIcon
} from "@heroicons/vue/24/outline";

const services = ref([
  { id: 1, name: "Brushing Cheveux Longs", category: "Coiffure", duration: 45, price: 15000, deposit: 3000, active: true },
  { id: 2, name: "Soin Capillaire Intense", category: "Coiffure", duration: 60, price: 25000, deposit: 5000, active: true },
  { id: 3, name: "Pose Vernis Semi-Permanent", category: "Onglerie", duration: 30, price: 10000, deposit: 0, active: true },
  { id: 4, name: "Coupe Homme + Barbe", category: "Barber", duration: 45, price: 10000, deposit: 2000, active: true },
  { id: 5, name: "Manucure Complète", category: "Onglerie", duration: 60, price: 15000, deposit: 3000, active: false }
]);

function addService() {
  toast.info("L'ajout de service sera disponible dans la version finale.");
}

function deleteService(id: number) {
  services.value = services.value.filter(s => s.id !== id);
  toast.success("Prestation supprimée.");
}
</script>
