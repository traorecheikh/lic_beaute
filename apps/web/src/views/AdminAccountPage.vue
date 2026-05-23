<template>
  <div class="space-y-8">
    <header class="flex items-end justify-between gap-6">
      <div>
        <h2 class="page-title">Mon Compte</h2>
        <p class="row-meta mt-1">Profil et sécurité de l'accès administrateur plateforme.</p>
      </div>
    </header>

    <!-- Identity card -->
    <section class="panel-clean p-6 md:p-8">
      <div class="flex items-center gap-5">
        <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-[15px] font-bold text-primary ring-1 ring-primary/20">
          {{ userInitials }}
        </div>
        <div class="min-w-0 flex-1">
          <div class="flex flex-wrap items-center gap-2">
            <p class="row-primary truncate">{{ auth.currentUser?.fullName ?? "Compte administrateur" }}</p>
            <span class="inline-flex items-center rounded-full bg-primary/10 px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-widest text-primary">
              Admin Plateforme
            </span>
          </div>
          <p class="row-meta mt-0.5 truncate">{{ auth.currentUser?.email ?? "Email non renseigné" }}</p>
        </div>
      </div>
      <p class="row-meta mt-4 border-t border-outline-variant/40 pt-4">
        Accès complet à la plateforme : gestion des salons, abonnements, audit et configuration.
      </p>
    </section>

    <!-- Quick navigation -->
    <section class="panel-clean divide-y divide-outline-variant/40">
      <div class="px-6 py-4 md:px-8">
        <h3 class="section-label">Navigation rapide</h3>
      </div>
      <RouterLink
        v-for="link in adminLinks"
        :key="link.to"
        :to="link.to"
        class="flex items-center justify-between gap-4 px-6 py-4 transition hover:bg-neutral-bg group md:px-8"
      >
        <div class="flex items-center gap-3">
          <component :is="link.icon" class="w-4 h-4 shrink-0 text-cocoa/50 group-hover:text-primary transition" />
          <div>
            <p class="row-primary group-hover:text-primary transition">{{ link.label }}</p>
            <p class="row-meta">{{ link.description }}</p>
          </div>
        </div>
        <ChevronRightIcon class="w-4 h-4 text-cocoa/30 group-hover:text-primary transition shrink-0" />
      </RouterLink>
    </section>

    <!-- Password change -->
    <section class="panel-clean p-6 md:p-8">
      <div class="flex items-center justify-between gap-4 mb-6">
        <div>
          <h3 class="row-primary">Sécurité</h3>
          <p class="row-meta mt-1">En tant qu'administrateur, veillez à maintenir un mot de passe fort et unique.</p>
        </div>
        <KeyIcon class="w-5 h-5 text-cocoa/40 shrink-0" />
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
              placeholder="Min. 8 caractères"
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
              placeholder="Répétez le mot de passe"
              :disabled="loading"
            />
          </div>
        </div>

        <p v-if="error" class="text-[11px] font-bold text-error uppercase tracking-wider">{{ error }}</p>

        <div class="pt-2 flex justify-end">
          <button type="submit" class="btn-primary min-w-[220px]" :disabled="loading">
            {{ loading ? "Enregistrement…" : "Mettre à jour le mot de passe" }}
          </button>
        </div>
      </form>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import {
  BuildingStorefrontIcon,
  ChartBarIcon,
  ChevronRightIcon,
  ClipboardDocumentListIcon,
  Cog6ToothIcon,
  CreditCardIcon,
  KeyIcon
} from "@heroicons/vue/24/outline";
import { toast } from "vue-sonner";

import { changePassword } from "@/lib/api";
import { useAdminAuthStore } from "@/stores/adminAuth";

const auth = useAdminAuthStore();

const form = reactive({ currentPassword: "", newPassword: "", confirm: "" });
const loading = ref(false);
const error = ref("");

const userInitials = computed(() => {
  const name = auth.currentUser?.fullName?.trim();
  if (!name) return "BA";
  return name.split(/\s+/).slice(0, 2).map(n => n[0].toUpperCase()).join("");
});

const adminLinks = [
  {
    label: "Pilotage",
    description: "Vue d'ensemble des KPIs et métriques clés",
    to: "/admin/dashboard",
    icon: ChartBarIcon
  },
  {
    label: "Salons",
    description: "Approbation, suspension et gestion des établissements",
    to: "/admin/salons",
    icon: BuildingStorefrontIcon
  },
  {
    label: "Abonnements",
    description: "Suivi des formules actives et revenus",
    to: "/admin/subscriptions",
    icon: CreditCardIcon
  },
  {
    label: "Audit log",
    description: "Historique des actions administratives",
    to: "/admin/audit",
    icon: ClipboardDocumentListIcon
  },
  {
    label: "Configuration",
    description: "Paramètres plateforme, motifs et valeurs de référence",
    to: "/admin/config",
    icon: Cog6ToothIcon
  },
];

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
