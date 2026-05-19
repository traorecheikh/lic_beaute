<template>
  <div class="max-w-3xl mx-auto space-y-8">
    <!-- Breadcrumb -->
    <div class="flex items-center gap-2">
      <RouterLink
        to="/admin/salons"
        class="group flex items-center gap-2 text-[11px] font-bold uppercase tracking-widest text-cocoa/70 hover:text-primary transition-colors"
      >
        <ArrowLeftIcon class="w-4 h-4 transition-transform group-hover:-translate-x-1" />
        Retour à la file
      </RouterLink>
    </div>

    <header>
      <h2 class="page-title">Nouveau salon</h2>
      <p class="row-meta mt-1">Créez un dossier salon et un accès gérant.</p>
    </header>

    <form class="space-y-8" @submit.prevent="submitSalon">
      <!-- Salon info -->
      <div class="panel-clean p-8 space-y-6">
        <p class="section-label border-b border-outline-variant/40 pb-3">Informations salon</p>
        <div class="grid grid-cols-2 gap-6">
          <div class="space-y-1.5">
            <label class="section-label">Nom <span class="text-primary">*</span></label>
            <input v-model="form.name" class="input-shell" placeholder="Ex : Beauty Studio" required />
          </div>
          <div class="space-y-1.5">
            <label class="section-label">Catégorie <span class="text-primary">*</span></label>
            <select v-model="form.category" class="input-shell h-[42px]" required>
              <option value="" disabled>Sélectionnez une catégorie</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.name">{{ cat.name }}</option>
            </select>
          </div>
          <div class="space-y-1.5">
            <label class="section-label">Ville <span class="text-primary">*</span></label>
            <input v-model="form.city" class="input-shell" placeholder="Ex : Dakar" required />
          </div>
          <div class="space-y-1.5">
            <label class="section-label">Adresse <span class="text-primary">*</span></label>
            <input v-model="form.address" class="input-shell" placeholder="Ex : 12 Rue Carnot" required />
          </div>
        </div>
        <div class="space-y-1.5">
          <label class="section-label">Description <span class="text-primary">*</span></label>
          <textarea v-model="form.description" class="input-shell" rows="3" placeholder="Présentation courte du salon…" required></textarea>
        </div>
      </div>

      <!-- Gérant -->
      <div class="panel-clean p-8 space-y-6">
        <p class="section-label border-b border-outline-variant/40 pb-3">Gérant & accès</p>
        <div class="grid grid-cols-2 gap-6">
          <div class="space-y-1.5">
            <label class="section-label">Nom du gérant <span class="text-primary">*</span></label>
            <input v-model="form.ownerName" class="input-shell" placeholder="Prénom Nom" required />
          </div>
          <div class="space-y-1.5">
            <label class="section-label">Téléphone</label>
            <input v-model="form.ownerPhone" class="input-shell" placeholder="+221 77 000 0000" />
          </div>
          <div class="col-span-2 space-y-1.5">
            <label class="section-label">Email gérant <span class="text-primary">*</span></label>
            <input v-model="form.ownerEmail" class="input-shell" type="email" placeholder="gerant@exemple.com" required />
            <p class="row-meta mt-1">Un email d'invitation sera envoyé à cette adresse.</p>
          </div>
        </div>
      </div>

      <p v-if="errorMsg" class="text-error row-meta px-1">{{ errorMsg }}</p>

      <div class="flex items-center justify-end gap-3">
        <RouterLink to="/admin/salons" class="btn-secondary px-6 py-2.5">Annuler</RouterLink>
        <button type="submit" class="btn-primary px-8 py-2.5" :disabled="submitting">
          {{ submitting ? 'Création…' : 'Créer le salon' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useQueryClient } from "@tanstack/vue-query";
import { toast } from "vue-sonner";
import { ArrowLeftIcon } from "@heroicons/vue/24/outline";

import { ApiError, createSalon, fetchPlatformCategories } from "@/lib/api";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();
const router = useRouter();
const queryClient = useQueryClient();

const categories = ref<{ id: string; name: string }[]>([]);
const submitting = ref(false);

onMounted(async () => {
  try {
    categories.value = await fetchPlatformCategories(auth.accessToken ?? "");
  } catch {
    // leave empty — user can still type if categories fail to load
  }
});
const errorMsg = ref("");
const form = ref({
  name: "",
  category: "",
  city: "",
  address: "",
  description: "",
  ownerName: "",
  ownerEmail: "",
  ownerPhone: ""
});

async function submitSalon() {
  errorMsg.value = "";
  submitting.value = true;
  try {
    await createSalon(auth.accessToken ?? "", form.value);
    await queryClient.invalidateQueries({ queryKey: ["admin-salons"] });
    toast.success("Salon créé avec succès.");
    router.push("/admin/salons");
  } catch (e) {
    errorMsg.value = e instanceof ApiError ? e.message : "Erreur lors de la création.";
  } finally {
    submitting.value = false;
  }
}
</script>
