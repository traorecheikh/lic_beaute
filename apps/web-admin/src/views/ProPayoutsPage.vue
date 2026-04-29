<template>
  <div>
    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-2">Ventes & Versements</h1>
        <p class="text-cocoa/60">Suivez vos revenus encaissés et vos virements à venir.</p>
      </div>
      <div class="flex items-center gap-2">
        <select class="input-shell py-2 min-w-[150px]">
          <option>Derniers 30 jours</option>
          <option>Mois dernier</option>
        </select>
        <button class="btn-secondary px-4 py-2 ring-0 border flex items-center gap-2">
          <ArrowDownTrayIcon class="w-4 h-4" />
          Relevé PDF
        </button>
      </div>
    </div>

    <!-- Payout KPIs -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-secondary shadow-sm">
        <p class="metric-label mb-2">En attente de versement</p>
        <p class="metric-value text-secondary">85 000 FCFA</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Prochain virement: Mardi 23 juillet</p>
      </div>
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-primary shadow-sm">
        <p class="metric-label mb-2">Déjà versé (30 jrs)</p>
        <p class="metric-value text-espresso">425 000 FCFA</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Total 12 virements effectués</p>
      </div>
      <div class="panel-clean p-8 bg-surface border-l-4 border-l-cocoa/20 shadow-sm">
        <p class="metric-label mb-2">Frais de plateforme</p>
        <p class="metric-value text-cocoa/40">12 450 FCFA</p>
        <p class="text-[10px] text-cocoa/40 mt-4 font-bold uppercase tracking-widest">Taux moyen: 2.5% + fixe</p>
      </div>
    </div>

    <div class="panel-clean overflow-hidden">
      <div class="p-8 border-b border-outline-variant/30 flex items-center justify-between">
        <h2 class="section-label">Transactions récentes</h2>
        <div class="flex gap-2">
          <span class="flex items-center gap-1.5 text-[10px] font-bold text-cocoa/40">
            <div class="w-2 h-2 rounded-full bg-green-500"></div> Terminé
          </span>
          <span class="flex items-center gap-1.5 text-[10px] font-bold text-cocoa/40 ml-4">
            <div class="w-2 h-2 rounded-full bg-amber-500"></div> En attente
          </span>
        </div>
      </div>
      
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-neutral-bg/50">
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Date</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Client & Service</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Méthode</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Montant</th>
            <th class="px-8 py-4 text-[10px] font-bold uppercase tracking-widest text-cocoa/40">Statut</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/30">
          <tr v-for="tx in transactions" :key="tx.id" class="hover:bg-neutral-bg/30 transition-colors">
            <td class="px-8 py-5">
              <p class="text-sm font-semibold text-espresso">{{ tx.date }}</p>
              <p class="text-[10px] text-cocoa/40 uppercase font-bold">{{ tx.id }}</p>
            </td>
            <td class="px-8 py-5">
              <p class="row-primary">{{ tx.client }}</p>
              <p class="row-meta">{{ tx.service }}</p>
            </td>
            <td class="px-8 py-5">
              <div class="flex items-center gap-2">
                <img :src="tx.methodLogo" class="w-5 h-5 object-contain rounded" />
                <span class="text-xs font-semibold text-espresso">{{ tx.method }}</span>
              </div>
            </td>
            <td class="px-8 py-5">
              <p class="text-sm font-bold text-espresso">{{ tx.amount }} FCFA</p>
              <p class="text-[10px] text-cocoa/40 font-bold">Frais: {{ tx.fee }}</p>
            </td>
            <td class="px-8 py-5">
              <span :class="['px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest', tx.status === 'Terminé' ? 'bg-green-100 text-green-700' : 'bg-amber-100 text-amber-700']">
                {{ tx.status }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowDownTrayIcon } from "@heroicons/vue/24/outline";

const transactions = [
  { 
    id: "TX-98231", date: "16 Juillet, 14:30", client: "Awa Ndiaye", service: "Brushing + Soin",
    method: "Wave", methodLogo: "https://vignette.wikia.nocookie.net/logopedia/images/2/2c/Wave_Logo.png",
    amount: "25 000", fee: "750", status: "En attente" 
  },
  { 
    id: "TX-98230", date: "16 Juillet, 11:00", client: "Ibrahim Diallo", service: "Coupe Homme",
    method: "Espèces", methodLogo: "https://cdn-icons-png.flaticon.com/512/2489/2489756.png",
    amount: "10 000", fee: "0", status: "Terminé" 
  },
  { 
    id: "TX-98229", date: "15 Juillet, 16:45", client: "Fatou Sow", service: "Manucure",
    method: "Orange Money", methodLogo: "https://upload.wikimedia.org/wikipedia/commons/f/ff/Orange_logo.svg",
    amount: "15 000", fee: "450", status: "Terminé" 
  },
  { 
    id: "TX-98228", date: "15 Juillet, 09:30", client: "Khady Fall", service: "Pédicure",
    method: "Wave", methodLogo: "https://vignette.wikia.nocookie.net/logopedia/images/2/2c/Wave_Logo.png",
    amount: "20 000", fee: "600", status: "Terminé" 
  }
];
</script>
