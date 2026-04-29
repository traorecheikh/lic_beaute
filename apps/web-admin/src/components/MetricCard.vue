<template>
  <div class="panel-clean p-6 group hover:border-primary/30 transition-all bg-white">
    <div class="space-y-4">
      <p class="metric-label">{{ label }}</p>
      <p class="metric-value">{{ value }}</p>
      <div v-if="note" class="pt-4 border-t border-outline-variant/30">
        <p class="row-meta leading-relaxed">{{ note }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  label: string;
  value: string;
  note?: string;
}>();
</script>
