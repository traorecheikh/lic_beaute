<template>
  <span
    class="inline-flex items-center rounded-full px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-widest ring-1 ring-inset"
    :class="styles"
  >
    {{ label }}
  </span>
</template>

<script setup lang="ts">
import { computed } from "vue";

const props = defineProps<{
  value: string;
}>();

const label = computed(() => {
  const map: Record<string, string> = {
    // Booking Status
    pending: "En attente",
    confirmed: "Confirmé",
    in_progress: "En cours",
    completed: "Terminé",
    cancelled: "Annulé",
    
    // Payment Status
    authorized: "Autorisé",
    succeeded: "Réussi",
    failed: "Échoué",
    refunded: "Remboursé",

    // Subscription Tiers
    standard: "Standard",
    premium: "Premium",

    // Approval Status
    pending_review: "À traiter",
    approved: "Approuvé",
    rejected: "Rejeté",
    needs_info: "Infos requises",

    // Document Status
    missing: "Manquant",
    received: "Reçu",
    verified: "Vérifié",

    // Deposit Mode
    none: "Aucun",
    fixed: "Fixe",
    percentage: "Pourcentage"
  };

  return map[props.value] ?? props.value;
});

const styles = computed(() => {
  const val = props.value.toLowerCase();
  
  if (['pending', 'pending_review', 'missing', 'none'].includes(val)) {
    return "bg-neutral-bg text-cocoa/60 ring-outline-variant/50";
  }
  
  if (['confirmed', 'succeeded', 'approved', 'verified', 'active'].includes(val)) {
    return "bg-primary/5 text-primary ring-primary/20";
  }

  if (['failed', 'cancelled', 'rejected', 'needs_info'].includes(val)) {
    return "bg-error/5 text-error ring-error/20";
  }

  if (['premium'].includes(val)) {
    return "bg-secondary/10 text-secondary ring-secondary/30";
  }

  if (['in_progress'].includes(val)) {
    return "bg-primary/10 text-primary ring-primary/30";
  }

  return "bg-neutral-bg text-cocoa/60 ring-outline-variant/50";
});
</script>
