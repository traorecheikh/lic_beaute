<template>
  <div class="space-y-8">
    <header class="flex items-end justify-between gap-6">
      <div>
        <h2 class="page-title">Mon Compte</h2>
        <p class="row-meta mt-1">Profil et sécurité de l'espace professionnel.</p>
      </div>
    </header>

    <section class="panel-clean p-6 md:p-8 flex items-center gap-4">
      <div class="h-12 w-12 rounded-2xl bg-sand flex items-center justify-center border border-outline-variant">
        <UserCircleIcon class="w-7 h-7 text-cocoa/70" />
      </div>
      <div class="min-w-0">
        <p class="row-primary truncate">{{ auth.currentUser?.fullName ?? "Compte professionnel" }}</p>
        <p class="row-meta truncate">{{ auth.currentUser?.email ?? "Email non renseigné" }}</p>
      </div>
    </section>

    <section class="panel-clean p-6 md:p-8">
      <div class="flex items-center justify-between gap-4 mb-6">
        <div>
          <h3 class="row-primary">Sécurité</h3>
          <p class="row-meta mt-1">Modification du mot de passe de connexion.</p>
        </div>
        <KeyIcon class="w-5 h-5 text-cocoa/40" />
      </div>

      <form @submit.prevent="submit" class="space-y-5">
        <div class="space-y-1.5">
          <label class="section-label block">Mot de passe actuel</label>
          <input
            v-model="form.currentPassword"
            type="password"
            autocomplete="current-password"
            class="input-shell"
            placeholder="••••••••"
            :disabled="loading"
          />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="space-y-1.5">
            <label class="section-label block">Nouveau mot de passe</label>
            <input
              v-model="form.newPassword"
              type="password"
              autocomplete="new-password"
              class="input-shell"
              placeholder="••••••••"
              :disabled="loading"
            />
          </div>

          <div class="space-y-1.5">
            <label class="section-label block">Confirmation</label>
            <input
              v-model="form.confirm"
              type="password"
              autocomplete="new-password"
              class="input-shell"
              placeholder="••••••••"
              :disabled="loading"
            />
          </div>
        </div>

        <p v-if="error" class="text-[11px] font-bold text-error uppercase tracking-wider">{{ error }}</p>

        <div class="pt-2 flex justify-end">
          <button type="submit" class="btn-primary min-w-[220px]" :disabled="loading">
            {{ loading ? "Enregistrement…" : "Mettre à jour" }}
          </button>
        </div>
      </form>
    </section>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from "vue";
import { KeyIcon, UserCircleIcon } from "@heroicons/vue/24/outline";
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
