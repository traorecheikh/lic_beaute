<template>
  <Modal 
    :show="show" 
    title="Exporter les données" 
    subtitle="Générez un rapport détaillé au format Excel"
    max-width="2xl"
    @close="$emit('close')"
  >
    <div class="space-y-6">
      <div class="grid grid-cols-2 gap-4">
        <button 
          v-for="type in exportTypes" 
          :key="type.id"
          class="p-4 rounded-2xl border-2 text-left transition-all"
          :class="selectedType === type.id ? 'border-primary bg-primary/5' : 'border-outline-variant hover:border-primary/20 bg-white'"
          @click="selectedType = type.id"
        >
          <p class="text-[14px] font-bold text-espresso">{{ type.label }}</p>
          <p class="text-[11px] text-cocoa/60 mt-1">{{ type.desc }}</p>
        </button>
      </div>

      <div class="space-y-3">
        <h4 class="section-label px-1">Prévisualisation (10 premières lignes)</h4>
        <div class="bg-neutral-bg/50 rounded-2xl border border-outline-variant overflow-hidden">
          <table class="min-w-full text-[10px] text-left">
            <thead class="bg-white/50 border-b border-outline-variant/40">
              <tr>
                <th v-for="h in previewHeaders" :key="h" class="px-4 py-2 font-bold uppercase tracking-wider text-cocoa/40">{{ h }}</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant/20">
              <tr v-for="(row, i) in previewData" :key="i">
                <td v-for="cell in row" :key="cell" class="px-4 py-2 text-espresso/70 truncate max-w-[120px]">{{ cell }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <template #footer>
      <div class="flex items-center justify-between">
        <p class="text-[11px] text-cocoa/40 italic">Total estimé: {{ totalRows }} lignes</p>
        <div class="flex items-center gap-3">
          <button class="btn-secondary" @click="$emit('close')">Annuler</button>
          <button class="btn-primary flex items-center gap-2" :disabled="isExporting" @click="handleExport">
            <svg v-if="isExporting" class="animate-spin w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>
            {{ isExporting ? 'Génération...' : 'Télécharger .xlsx' }}
          </button>
        </div>
      </div>
    </template>
  </Modal>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { toast } from 'vue-sonner';
import Modal from './Modal.vue';

defineProps<{ show: boolean }>();
const emit = defineEmits(['close']);

const selectedType = ref('salons');
const isExporting = ref(false);

const exportTypes = [
  { id: 'salons', label: 'Salons', desc: 'Liste complète, statuts et contacts.' },
  { id: 'bookings', label: 'Réservations', desc: 'Historique des RDV et revenus.' },
  { id: 'subscriptions', label: 'Abonnements', desc: 'Tiers, expirations et facturation.' },
  { id: 'audit', label: 'Logs Audit', desc: 'Actions système et sécurité.' }
];

const previewHeaders = computed(() => {
  if (selectedType.value === 'salons') return ['ID', 'Nom', 'Ville', 'Statut', 'Inscrit le'];
  if (selectedType.value === 'bookings') return ['Date', 'Salon', 'Client', 'Montant', 'Statut'];
  return ['Donnée 1', 'Donnée 2', 'Donnée 3', 'Donnée 4', 'Donnée 5'];
});

const previewData = computed(() => {
  const data = [];
  for (let i = 0; i < 5; i++) {
    if (selectedType.value === 'salons') {
      data.push([`SAL-${100+i}`, `Salon Excellence ${i}`, 'Dakar', 'Approuvé', '2026-04-10']);
    } else {
      data.push(['2026-04-27', 'Beauty Studio', 'Fatou Diop', '15,000 FCFA', 'Confirmé']);
    }
  }
  return data;
});

const totalRows = computed(() => (selectedType.value === 'salons' ? 524 : 12450));

async function handleExport() {
  isExporting.value = true;
  
  // Simulation of generation and download
  setTimeout(() => {
    isExporting.value = false;
    toast.success('Rapport exporté avec succès.');
    emit('close');
    
    // In a real app, this would trigger a window.location or a blob download
    console.log(`Exporting ${selectedType.value} as .xlsx`);
  }, 1500);
}
</script>
