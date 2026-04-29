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
                <td class="px-6 py-4 text-sm text-espresso font-bold text-right">{{ client.totalSpent.toLocaleString() }} FCFA</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Detail Side Panel (Desktop) -->
      <div class="hidden lg:block">
        <div v-if="selectedClient" class="panel-clean p-8 sticky top-32">
          <div class="text-center mb-8">
            <div class="w-20 h-20 rounded-full bg-sand mx-auto flex items-center justify-center font-display text-3xl text-espresso mb-4 border border-outline-variant">
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
                "Préfère les brushings volumineux. Toujours ponctuelle."
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 gap-3">
            <button class="btn-primary w-full py-3 text-[11px]">Nouveau RDV</button>
            <button class="btn-secondary w-full py-3 ring-0 border text-[11px]">Voir historique complet</button>
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
import { ref, computed } from "vue";
import { MagnifyingGlassIcon, UsersIcon } from "@heroicons/vue/24/outline";

const searchQuery = ref("");
const selectedId = ref<number | null>(1);

const clients = [
  { 
    id: 1, name: "Awa Ndiaye", initials: "AN", phone: "+221 77 123 45 67", 
    email: "awa.ndiaye@gmail.com", lastVisit: "12 Juillet 2026", 
    visitCount: 12, totalSpent: 245000, memberSince: "Avril 2024" 
  },
  { 
    id: 2, name: "Fatou Binetou", initials: "FB", phone: "+221 78 987 65 43", 
    email: "fatou.b@yahoo.fr", lastVisit: "16 Juillet 2026", 
    visitCount: 4, totalSpent: 85000, memberSince: "Janvier 2026" 
  },
  { 
    id: 3, name: "Ibrahim Diallo", initials: "ID", phone: "+221 70 555 44 33", 
    email: "idiallo@gmail.com", lastVisit: "10 Juillet 2026", 
    visitCount: 8, totalSpent: 110000, memberSince: "Juin 2025" 
  },
  { 
    id: 4, name: "Khady Fall", initials: "KF", phone: "+221 76 111 22 33", 
    email: "kfall@outlook.com", lastVisit: "05 Juillet 2026", 
    visitCount: 1, totalSpent: 20000, memberSince: "Juillet 2026" 
  }
];

const filteredClients = computed(() => {
  if (!searchQuery.value) return clients;
  const q = searchQuery.value.toLowerCase();
  return clients.filter(c => c.name.toLowerCase().includes(q) || c.phone.includes(q));
});

const selectedClient = computed(() => clients.find(c => c.id === selectedId.value));
</script>
