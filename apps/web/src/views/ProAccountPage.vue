<template>
  <div class="max-w-lg">
    <h2 class="page-title mb-1">Mon Compte</h2>
    <p class="row-meta mb-8">{{ auth.currentUser?.email }}</p>

    <div class="panel-clean p-6">
      <h3 class="section-label mb-5">Changer le mot de passe</h3>

      <form @submit.prevent="submit" class="space-y-4">
        <div>
          <label class="section-label mb-2 block">Mot de passe actuel</label>
          <input
            v-model="form.currentPassword"
            type="password"
            autocomplete="current-password"
            class="input-shell"
            placeholder="••••••••"
            :disabled="loading"
          />
        </div>

        <div>
          <label class="section-label mb-2 block">Nouveau mot de passe</label>
          <input
            v-model="form.newPassword"
            type="password"
            autocomplete="new-password"
            class="input-shell"
            placeholder="••••••••"
            :disabled="loading"
          />
        </div>

        <div>
          <label class="section-label mb-2 block">Confirmer le nouveau mot de passe</label>
          <input
            v-model="form.confirm"
            type="password"
            autocomplete="new-password"
            class="input-shell"
            placeholder="••••••••"
            :disabled="loading"
          />
        </div>

        <p v-if="error" class="text-[11px] font-bold text-error uppercase tracking-wider">{{ error }}</p>

        <button type="submit" class="btn-primary w-full" :disabled="loading">
          {{ loading ? "Enregistrement…" : "Mettre à jour" }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from "vue";
import { toast } from "vue-sonner";

import { changePassword } from "@/lib/api";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();

const form = reactive({ currentPassword: "", newPassword: "", confirm: "" });
const loading = ref(false);
const error = ref("");

async function submit() {
  error.value = "";

  if (!form.currentPassword || !form.newPassword || !form.confirm) {
    error.value = "Tous les champs sont requis.";
    return;
  }
  if (form.newPassword.length < 8) {
    error.value = "Le nouveau mot de passe doit contenir au moins 8 caractères.";
    return;
  }
  if (form.newPassword !== form.confirm) {
    error.value = "Les mots de passe ne correspondent pas.";
    return;
  }

  loading.value = true;
  try {
    await changePassword(auth.accessToken!, form.currentPassword, form.newPassword);
    toast.success("Mot de passe mis à jour.");
    form.currentPassword = "";
    form.newPassword = "";
    form.confirm = "";
  } catch (e: unknown) {
    const code = (e as { code?: string })?.code;
    if (code === "invalid_current_password") {
      error.value = "Mot de passe actuel incorrect.";
    } else {
      error.value = "Une erreur est survenue. Réessayez.";
    }
  } finally {
    loading.value = false;
  }
}
</script>
