<template>
  <div>
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h1 class="page-title mb-2">Équipe</h1>
        <p class="text-cocoa/60">Gérez vos collaborateurs et leurs spécialités.</p>
      </div>
      <button @click="addMember" class="btn-primary gap-2">
        <PlusIcon class="w-4 h-4" />
        Ajouter un membre
      </button>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="member in team" :key="member.id" class="panel-clean p-6 flex flex-col items-center text-center group relative">
        <div class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition flex gap-1">
          <button class="p-2 hover:bg-neutral-bg rounded-full text-cocoa/60 hover:text-espresso"><PencilIcon class="w-4 h-4" /></button>
          <button @click="removeMember(member.id)" class="p-2 hover:bg-neutral-bg rounded-full text-cocoa/60 hover:text-error"><TrashIcon class="w-4 h-4" /></button>
        </div>

        <div class="w-20 h-20 rounded-full bg-sand flex items-center justify-center font-display text-2xl text-espresso mb-4 border-2 border-white shadow-sm overflow-hidden">
          <img v-if="member.avatar" :src="member.avatar" class="w-full h-full object-cover" />
          <span v-else>{{ member.initials }}</span>
        </div>

        <h3 class="row-primary text-base mb-1">{{ member.name }}</h3>
        <p class="row-meta uppercase tracking-widest text-[10px] font-bold mb-4">{{ member.role }}</p>

        <div class="flex flex-wrap justify-center gap-1.5 mb-6">
          <span v-for="spec in member.specialties" :key="spec" class="px-2 py-0.5 rounded-full bg-neutral-bg text-[10px] font-bold text-cocoa/60 uppercase tracking-wider">
            {{ spec }}
          </span>
        </div>

        <div class="w-full pt-4 border-t border-outline-variant/30 flex items-center justify-between text-[11px] font-bold">
          <span :class="member.active ? 'text-green-600' : 'text-cocoa/30'">
            {{ member.active ? '● Actif' : '○ Inactif' }}
          </span>
          <button class="text-primary hover:underline uppercase tracking-widest">Voir planning</button>
        </div>
      </div>

      <!-- Add Card -->
      <button @click="addMember" class="panel-clean p-6 flex flex-col items-center justify-center text-center border-dashed border-2 bg-transparent hover:bg-white hover:border-primary/20 transition group min-h-[280px]">
        <div class="w-16 h-16 rounded-full bg-neutral-bg flex items-center justify-center text-cocoa/20 group-hover:bg-primary/5 group-hover:text-primary transition mb-4">
          <PlusIcon class="w-8 h-8" />
        </div>
        <p class="font-bold text-espresso mb-1">Recruter un nouveau talent</p>
        <p class="text-xs text-cocoa/40">Ajoutez un collaborateur à votre salon.</p>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { toast } from "vue-sonner";
import { 
  PlusIcon, 
  PencilIcon, 
  TrashIcon 
} from "@heroicons/vue/24/outline";

const team = ref([
  { 
    id: 1, name: "Marie Diop", initials: "MD", role: "Manager / Senior", 
    specialties: ["Coiffure", "Coloration", "Soin"], active: true,
    avatar: "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?auto=format&fit=crop&q=80"
  },
  { 
    id: 2, name: "Jean Faye", initials: "JF", role: "Coiffeur Senior", 
    specialties: ["Barber", "Coupe Homme"], active: true,
    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80"
  },
  { 
    id: 3, name: "Awa Sow", initials: "AS", role: "Esthéticienne", 
    specialties: ["Manucure", "Pédicure", "Maquillage"], active: true,
    avatar: null
  },
  { 
    id: 4, name: "Fatou Fall", initials: "FF", role: "Apprentie", 
    specialties: ["Brushing", "Lavage"], active: false,
    avatar: null
  }
]);

function addMember() {
  toast.info("L'ajout de membre sera disponible bientôt.");
}

function removeMember(id: number) {
  team.value = team.value.filter(m => m.id !== id);
  toast.success("Membre de l'équipe supprimé.");
}
</script>
