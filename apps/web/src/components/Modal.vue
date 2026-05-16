<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div v-if="show" class="fixed inset-0 z-[200] flex items-center justify-center p-4 sm:p-6">
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-[#1B1730]/60 backdrop-blur-sm" @click="$emit('close')"></div>
        
        <!-- Modal Content -->
        <div 
          class="relative w-full bg-white rounded-[2rem] shadow-2xl shadow-espresso/20 overflow-hidden flex flex-col"
          :class="maxWidthClass"
        >
          <!-- Header -->
          <div class="px-8 py-6 border-b border-outline-variant/40 flex items-center justify-between shrink-0">
            <div>
              <h3 v-if="title" class="text-lg font-bold text-espresso">{{ title }}</h3>
              <p v-if="subtitle" class="text-xs text-cocoa/60 mt-0.5">{{ subtitle }}</p>
            </div>
            <button 
              type="button" 
              class="w-10 h-10 rounded-full bg-neutral-bg flex items-center justify-center text-cocoa/40 hover:text-espresso transition-colors"
              @click="$emit('close')"
            >
              <XMarkIcon class="w-5 h-5" />
            </button>
          </div>

          <!-- Body -->
          <div class="flex-1 overflow-y-auto p-8">
            <slot />
          </div>

          <!-- Footer -->
          <div v-if="$slots.footer" class="px-8 py-6 bg-neutral-bg/50 border-t border-outline-variant/40 shrink-0">
            <slot name="footer" />
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { XMarkIcon } from '@heroicons/vue/24/outline';

const props = defineProps<{
  show: boolean;
  title?: string;
  subtitle?: string;
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '4xl' | 'full';
}>();

defineEmits(['close']);

const maxWidthClass = computed(() => {
  switch (props.maxWidth) {
    case 'sm': return 'max-w-sm';
    case 'md': return 'max-w-md';
    case 'lg': return 'max-w-lg';
    case 'xl': return 'max-w-xl';
    case '2xl': return 'max-w-2xl';
    case '4xl': return 'max-w-4xl';
    case 'full': return 'max-w-[calc(100vw-48px)] h-[calc(100vh-48px)]';
    default: return 'max-w-lg';
  }
});
</script>
