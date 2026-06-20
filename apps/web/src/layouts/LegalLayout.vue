<script setup lang="ts">
import { ChevronLeftIcon } from '@heroicons/vue/24/outline';
import { RouterLink } from 'vue-router';
import { legalConfig } from '@beauteavenue/shared-ts';

defineProps<{
  pageTitle: string;
  pageSubtitle: string;
  badgeText: string;
}>();
</script>

<template>
  <div class="min-h-screen bg-neutral-bg text-espresso font-sans antialiased selection:bg-primary/20 flex flex-col">
    <!-- Navigation header -->
    <nav class="sticky top-0 z-50 h-20 flex items-center bg-white/95 backdrop-blur-md border-b border-outline-variant/40" aria-label="Navigation principale">
      <div class="max-w-7xl mx-auto w-full px-4 sm:px-8 flex items-center justify-between">
        <div class="flex items-center gap-6">
          <RouterLink to="/" class="flex items-center gap-3.5 group focus:outline-none focus:ring-2 focus:ring-primary/40 rounded-lg p-1" aria-label="Retour à l'accueil Beauté Avenue">
            <img src="/logo.png" alt="Logo Beauté Avenue" class="h-9 w-auto object-contain transition-transform duration-300 group-hover:scale-105" />
            <span class="font-sans text-[18px] font-medium-bold tracking-tight text-espresso">{{ legalConfig.appName }}</span>
          </RouterLink>
          <div class="hidden md:flex items-center gap-2 text-cocoa/30 text-[13px]" aria-hidden="true">
            <span>/</span>
            <span class="font-medium">Légal</span>
            <span>/</span>
            <span class="font-medium text-cocoa/60">{{ pageTitle }}</span>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <RouterLink to="/" class="btn-secondary px-5 py-2 text-[12px] flex items-center gap-2 focus:outline-none focus:ring-2 focus:ring-espresso/30">
            <ChevronLeftIcon class="w-4 h-4" aria-hidden="true" />
            <span>Retour à l'accueil</span>
          </RouterLink>
        </div>
      </div>
    </nav>

    <!-- Header Section -->
    <header class="relative pt-16 pb-12 px-4 sm:px-8 bg-gradient-to-b from-sand/40 to-transparent text-center">
      <div class="max-w-4xl mx-auto space-y-4">
        <div class="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-primary/10 text-primary text-[10px] font-bold uppercase tracking-wider">
          <slot name="badge-icon"></slot>
          <span>{{ badgeText }}</span>
        </div>
        <h1 class="text-4xl sm:text-6xl font-display font-medium-bold text-espresso tracking-tight leading-tight">
          {{ pageTitle }}
        </h1>
        <p class="text-cocoa/60 text-sm sm:text-base max-w-xl mx-auto">
          {{ pageSubtitle }}
        </p>
        <p class="text-[11px] text-cocoa/40 font-semibold uppercase tracking-widest pt-2">
          Version {{ legalConfig.documentVersion }} • Mise à jour : {{ legalConfig.lastUpdate }}
        </p>
      </div>
    </header>

    <!-- Main Content wrapper -->
    <main class="max-w-4xl mx-auto w-full px-4 sm:px-8 pb-24 flex-grow">
      <div class="panel-clean bg-white p-6 sm:p-10 md:p-12 space-y-10 border border-outline-variant/60 shadow-[0_4px_20px_rgba(45,26,18,0.02)]">
        <slot></slot>
      </div>
    </main>

    <!-- Simple Legal Footer -->
    <footer class="bg-white border-t border-outline-variant/30 py-12 px-4 sm:px-8 text-center mt-auto" aria-label="Pied de page de conformité">
      <div class="max-w-7xl mx-auto space-y-4">
        <div class="flex items-center justify-center gap-2.5">
          <img src="/logo.png" alt="Logo Beauté Avenue" class="h-6 w-auto object-contain" />
          <span class="font-sans text-sm font-semibold text-espresso">{{ legalConfig.appName }}</span>
        </div>
        <nav class="flex flex-wrap justify-center gap-6 text-[12px] font-medium text-cocoa/70" aria-label="Liens légaux secondaires">
          <RouterLink to="/" class="hover:text-primary focus:text-primary focus:outline-none transition-colors">Accueil</RouterLink>
          <RouterLink to="/privacy" class="hover:text-primary focus:text-primary focus:outline-none transition-colors">Confidentialité</RouterLink>
          <RouterLink to="/terms" class="hover:text-primary focus:text-primary focus:outline-none transition-colors">Conditions d'Utilisation</RouterLink>
          <RouterLink to="/legal-notice" class="hover:text-primary focus:text-primary focus:outline-none transition-colors">Mentions Légales</RouterLink>
          <RouterLink to="/cookies" class="hover:text-primary focus:text-primary focus:outline-none transition-colors">Cookies</RouterLink>
          <a href="mailto:support@beauteavenue.sn" class="hover:text-primary focus:text-primary focus:outline-none transition-colors">Contact</a>
        </nav>
        <p class="text-[10px] font-bold text-cocoa/20 uppercase tracking-[0.2em] pt-4">
          © 2026 {{ legalConfig.appName }} • Plateforme exploitée par {{ legalConfig.operatorName }}
        </p>
      </div>
    </footer>
  </div>
</template>
