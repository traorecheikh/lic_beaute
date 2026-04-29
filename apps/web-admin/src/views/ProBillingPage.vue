<template>
  <div class="max-w-4xl mx-auto">
    <div class="mb-8">
      <h1 class="page-title mb-2">Abonnement & Facturation</h1>
      <p class="text-cocoa/60">Gérez votre plan Beauté Avenue et vos factures.</p>
    </div>

    <!-- Current Plan -->
    <div class="panel-clean p-8 mb-10 bg-gradient-to-br from-espresso to-[#1B1730] text-white border-none shadow-xl relative overflow-hidden">
      <div class="absolute top-0 right-0 w-64 h-64 bg-primary/20 rounded-full blur-3xl -mr-32 -mt-32"></div>
      
      <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-8">
        <div>
          <span class="px-3 py-1 rounded-full bg-primary text-[10px] font-bold uppercase tracking-widest mb-4 inline-block">Plan Actuel</span>
          <h2 class="text-4xl font-display mb-2">Beauté Avenue Premium</h2>
          <p class="text-white/60 text-sm">Prochaine facture le 15 août 2026 • 15 000 FCFA / mois</p>
        </div>
        <div class="flex gap-3">
          <button class="btn-secondary bg-white/10 text-white border-white/20 hover:bg-white/20 hover:text-white px-6">Gérer</button>
          <button class="btn-gold px-6">Améliorer</button>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <!-- Entitlements -->
      <div class="md:col-span-2 space-y-8">
        <section class="panel-clean p-8">
          <h2 class="section-label mb-6">Inclus dans votre plan</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div v-for="benefit in benefits" :key="benefit" class="flex items-center gap-3">
              <CheckCircleIcon class="w-5 h-5 text-primary shrink-0" />
              <span class="text-sm text-espresso font-medium">{{ benefit }}</span>
            </div>
          </div>
        </section>

        <!-- Billing History -->
        <section class="panel-clean overflow-hidden">
          <div class="p-8 border-b border-outline-variant/30">
            <h2 class="section-label">Historique des factures</h2>
          </div>
          <table class="w-full text-left border-collapse">
            <tbody class="divide-y divide-outline-variant/30">
              <tr v-for="invoice in invoices" :key="invoice.id" class="hover:bg-neutral-bg/30 transition-colors">
                <td class="px-8 py-4">
                  <p class="row-primary">{{ invoice.date }}</p>
                  <p class="row-meta">{{ invoice.id }}</p>
                </td>
                <td class="px-8 py-4">
                  <span class="px-2 py-0.5 rounded-full bg-green-100 text-green-700 text-[10px] font-bold uppercase tracking-wider">Payé</span>
                </td>
                <td class="px-8 py-4 text-sm font-bold text-espresso">{{ invoice.amount }} FCFA</td>
                <td class="px-8 py-4 text-right">
                  <button class="p-2 hover:bg-white rounded-full text-cocoa/60 hover:text-primary transition shadow-sm">
                    <ArrowDownTrayIcon class="w-4 h-4" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </section>
      </div>

      <!-- Payment Method -->
      <div class="space-y-8">
        <section class="panel-clean p-6">
          <h2 class="section-label mb-6">Mode de paiement</h2>
          <div class="flex items-center gap-4 mb-6">
            <div class="w-12 h-12 rounded-xl bg-orange-50 flex items-center justify-center p-2 border border-orange-100">
              <img src="https://upload.wikimedia.org/wikipedia/commons/f/ff/Orange_logo.svg" class="w-full h-auto" />
            </div>
            <div>
              <p class="text-sm font-bold text-espresso">Orange Money</p>
              <p class="text-xs text-cocoa/40">77 *** 45 67</p>
            </div>
          </div>
          <button class="btn-secondary w-full py-2 text-[10px] ring-0 border">Modifier</button>
        </section>

        <section class="panel-clean p-6 bg-primary/5 border-primary/10">
          <h2 class="section-label mb-4 text-primary">Besoin d'aide ?</h2>
          <p class="text-xs text-cocoa/60 leading-relaxed mb-4">Une question sur votre facture ou votre abonnement ?</p>
          <button class="text-xs font-bold text-primary uppercase tracking-widest hover:underline">Contacter le support</button>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { 
  CheckCircleIcon, 
  ArrowDownTrayIcon 
} from "@heroicons/vue/24/outline";

const benefits = [
  "Agenda illimité",
  "Paiements en ligne Wave/OM",
  "Rapports financiers complets",
  "Export CSV des données",
  "Marketing SMS (500/mois)",
  "Fidélisation client",
  "Support prioritaire 24/7",
  "Badge 'Vérifié' sur l'app"
];

const invoices = [
  { id: "INV-2026-004", date: "15 Juillet 2026", amount: "15 000" },
  { id: "INV-2026-003", date: "15 Juin 2026", amount: "15 000" },
  { id: "INV-2026-002", date: "15 Mai 2026", amount: "15 000" },
  { id: "INV-2026-001", date: "15 Avril 2026", amount: "15 000" }
];
</script>
