<template>
  <article class="panel-clean p-8 text-center bg-white/50 backdrop-blur-sm border-dashed border-2">
    <p v-if="eyebrow" class="section-label mb-2">{{ eyebrow }}</p>
    <h3 class="mt-2 text-[15px] font-semibold text-espresso">{{ title }}</h3>
    <p class="mx-auto mt-2 max-w-lg row-meta leading-relaxed">{{ message }}</p>
    <button
      v-if="actionLabel"
      type="button"
      class="btn-primary mt-6"
      @click="$emit('action')"
    >
      {{ actionLabel }}
    </button>
  </article>
</template>

<script setup lang="ts">
defineProps<{
  eyebrow?: string;
  title: string;
  message: string;
  actionLabel?: string;
}>();

defineEmits<{
  action: [];
}>();
</script>
