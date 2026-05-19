<template>
  <div class="max-w-5xl mx-auto py-12 px-4 font-sans antialiased">
    <SkeletonLoader v-if="salonQuery.isLoading.value" variant="dashboard" />
    
    <template v-else-if="salon">
      <!-- Status Banner -->
      <div 
        :class="[
          'rounded-3xl p-8 mb-12 flex flex-col md:flex-row items-center gap-8 shadow-xl shadow-espresso/5',
          statusTheme.bg
        ]"
      >
        <div :class="['w-20 h-20 rounded-2xl flex items-center justify-center shrink-0 shadow-lg', statusTheme.iconBg]">
          <component :is="statusTheme.icon" class="w-10 h-10 text-white" />
        </div>
        
        <div class="flex-1 text-center md:text-left">
          <p class="text-[10px] font-bold uppercase tracking-[0.3em] opacity-40 mb-2">État de votre dossier</p>
          <h2 class="text-3xl font-medium-bold text-espresso mb-2">{{ statusTheme.title }}</h2>
          <p class="text-[15px] text-cocoa/70 leading-relaxed max-w-2xl">
            {{ statusTheme.desc }}
          </p>
          
          <div v-if="salon.latestAdminNote" class="mt-6 p-5 bg-white/50 rounded-2xl border border-white/40 text-sm text-espresso leading-relaxed italic">
            <p class="font-bold uppercase tracking-widest text-[10px] text-cocoa/40 mb-2 not-italic">Note de l'administrateur :</p>
            "{{ salon.latestAdminNote }}"
          </div>
        </div>

        <div v-if="salon.approvalStatus === 'needs_info'" class="shrink-0 w-full md:w-auto">
          <button @click="openSupport" class="btn-primary w-full md:w-auto px-8 py-4 h-[56px] shadow-lg shadow-primary/20">
            Compléter mon dossier
          </button>
        </div>
      </div>

      <!-- Preview Sections (Locked) -->
      <div class="relative">
        <div class="absolute inset-0 bg-neutral-bg/40 backdrop-blur-[2px] z-10 rounded-3xl flex items-center justify-center">
          <div class="bg-white/90 p-8 rounded-3xl shadow-2xl text-center max-w-sm border border-outline-variant/30">
            <LockClosedIcon class="w-12 h-12 text-cocoa/20 mx-auto mb-4" />
            <h3 class="text-lg font-medium-bold text-espresso mb-2">Fonctionnalités verrouillées</h3>
            <p class="text-sm text-cocoa/60 leading-relaxed">
              Une fois votre salon approuvé, vous aurez accès à votre agenda, vos clients et vos outils de vente.
            </p>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 opacity-30 select-none grayscale">
          <div v-for="i in 3" :key="i" class="panel-clean p-8 h-32">
            <div class="w-1/3 h-2 bg-outline-variant rounded-full mb-4"></div>
            <div class="w-1/2 h-4 bg-outline-variant rounded-full"></div>
          </div>
          <div class="md:col-span-2 panel-clean p-8 h-64">
             <div class="w-1/4 h-3 bg-outline-variant rounded-full mb-8"></div>
             <div class="space-y-4">
                <div v-for="j in 3" :key="j" class="flex gap-4">
                  <div class="w-12 h-12 rounded-full bg-outline-variant"></div>
                  <div class="flex-1 space-y-2 py-2">
                    <div class="w-1/2 h-2 bg-outline-variant rounded-full"></div>
                    <div class="w-1/4 h-2 bg-outline-variant rounded-full"></div>
                  </div>
                </div>
             </div>
          </div>
          <div class="panel-clean p-8 h-64">
            <div class="w-1/2 h-3 bg-outline-variant rounded-full mb-8"></div>
            <div class="grid grid-cols-1 gap-3">
              <div v-for="k in 4" :key="k" class="h-10 bg-outline-variant rounded-xl"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Marketing Footer -->
      <div class="mt-16 text-center">
        <h3 class="text-sm font-bold uppercase tracking-widest text-cocoa/30 mb-8">Partenaire de votre réussite</h3>
        <div class="flex flex-wrap justify-center gap-12 grayscale opacity-40">
           <img src="/logo.png" alt="" class="h-6 w-auto" />
           <p class="text-lg font-medium-bold text-espresso font-display">Beauté Avenue Pro</p>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, watch } from "vue";
import { useRouter } from "vue-router";
import { useQuery } from "@tanstack/vue-query";
import { 
  CheckCircleIcon, 
  ExclamationTriangleIcon, 
  XCircleIcon, 
  ClockIcon,
  LockClosedIcon,
  SparklesIcon
} from "@heroicons/vue/24/outline";

import SkeletonLoader from "@/components/SkeletonLoader.vue";
import { fetchProSalon } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();
const router = useRouter();

const salonQuery = useQuery({
  queryKey: ["pro-salon", "approval"],
  queryFn: () => fetchProSalon(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken)),
  refetchInterval: 30_000
});

const salon = computed(() => salonQuery.data.value as any);

const statusTheme = computed(() => {
  const status = salon.value?.approvalStatus;
  
  if (status === "approved") {
    return {
      title: "C'est parti !",
      desc: "Votre salon est désormais actif. Vous allez être redirigé vers votre agenda dans quelques secondes.",
      bg: "bg-primary/10",
      iconBg: "bg-primary",
      icon: CheckCircleIcon
    };
  }
  
  if (status === "needs_info") {
    return {
      title: "Action requise",
      desc: "L'équipe de validation a besoin de précisions sur votre dossier pour finaliser l'ouverture de votre compte.",
      bg: "bg-secondary/10",
      iconBg: "bg-secondary",
      icon: ExclamationTriangleIcon
    };
  }
  
  if (status === "rejected") {
    return {
      title: "Dossier refusé",
      desc: "Malheureusement, nous n'avons pas pu valider votre établissement. Veuillez consulter le motif ci-dessous.",
      bg: "bg-error/10",
      iconBg: "bg-error",
      icon: XCircleIcon
    };
  }
  
  return {
    title: "Vérification en cours",
    desc: "Nous examinons vos documents. Cette étape prend généralement moins de 24h. Vous recevrez une notification par email.",
    bg: "bg-white",
    iconBg: "bg-cocoa/10",
    icon: ClockIcon
  };
});

watch(
  () => salon.value?.approvalStatus,
  (status) => {
    if (status === "approved") {
      setTimeout(() => router.replace("/pro/calendar"), 3000);
    }
  },
  { immediate: true }
);

function openSupport() {
  window.open("mailto:support@beauteavenue.sn", "_blank");
}
</script>
