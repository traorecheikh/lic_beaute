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
      <div
        v-if="show"
        ref="dialogRef"
        role="dialog"
        aria-modal="true"
        :aria-labelledby="title ? titleId : undefined"
        :aria-describedby="subtitle ? subtitleId : undefined"
        class="fixed inset-0 z-[200] flex items-center justify-center p-4 sm:p-6"
        @keydown.escape="handleClose"
      >
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-[#1B1730]/60 backdrop-blur-sm" @click="handleClose"></div>

        <!-- Modal Content -->
        <div
          class="relative w-full bg-white rounded-[2rem] shadow-2xl shadow-espresso/20 overflow-hidden flex flex-col"
          :class="maxWidthClass"
        >
          <!-- Header -->
          <div class="px-8 py-6 border-b border-outline-variant/40 flex items-center justify-between shrink-0">
            <div>
              <h3 v-if="title" :id="titleId" class="text-lg font-bold text-espresso">{{ title }}</h3>
              <p v-if="subtitle" :id="subtitleId" class="text-xs text-cocoa/60 mt-0.5">{{ subtitle }}</p>
            </div>
            <button
              type="button"
              aria-label="Fermer"
              class="w-10 h-10 rounded-full bg-neutral-bg flex items-center justify-center text-cocoa/40 hover:text-espresso transition-colors"
              @click="handleClose"
            >
              <XMarkIcon class="w-5 h-5" aria-hidden="true" />
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
import { computed, nextTick, ref, watch } from 'vue';
import { XMarkIcon } from '@heroicons/vue/24/outline';

const props = defineProps<{
  show: boolean;
  title?: string;
  subtitle?: string;
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '4xl' | 'full';
}>();

const emit = defineEmits<{ close: [] }>();

const titleId = computed(() => props.title ? `modal-title-${uid}` : undefined);
const subtitleId = computed(() => props.subtitle ? `modal-desc-${uid}` : undefined);

const uid = ref(crypto.randomUUID().slice(0, 8));
const dialogRef = ref<HTMLElement | null>(null);
let triggerElement: HTMLElement | null = null;

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

function handleClose() {
  emit('close');
}

function getFocusableElements(el: HTMLElement): HTMLElement[] {
  return Array.from(
    el.querySelectorAll<HTMLElement>(
      'a[href], button:not([disabled]), textarea:not([disabled]), input:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])'
    )
  );
}

function trapFocus(e: KeyboardEvent) {
  if (e.key !== 'Tab' || !dialogRef.value) return;
  const focusable = getFocusableElements(dialogRef.value);
  if (focusable.length === 0) { e.preventDefault(); return; }
  const first = focusable[0];
  const last = focusable[focusable.length - 1];
  if (e.shiftKey && document.activeElement === first) {
    e.preventDefault();
    last.focus();
  } else if (!e.shiftKey && document.activeElement === last) {
    e.preventDefault();
    first.focus();
  }
}

watch(
  () => props.show,
  async (showing) => {
    if (showing) {
      triggerElement = document.activeElement as HTMLElement;
      await nextTick();
      if (dialogRef.value) {
        const focusable = getFocusableElements(dialogRef.value);
        if (focusable.length > 0) focusable[0].focus();
        dialogRef.value.addEventListener('keydown', trapFocus);
      }
    } else {
      if (dialogRef.value) dialogRef.value.removeEventListener('keydown', trapFocus);
      triggerElement?.focus?.();
      triggerElement = null;
    }
  },
  { immediate: false }
);
</script>
