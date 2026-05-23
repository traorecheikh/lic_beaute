<template>
  <div class="space-y-8">
    <header class="flex items-end justify-between gap-6">
      <div>
        <h2 class="page-title">Mon Compte</h2>
        <p class="row-meta mt-1">Profil, rôle et sécurité de votre accès professionnel.</p>
      </div>
    </header>

    <!-- Identity card -->
    <section class="panel-clean p-6 md:p-8">
      <div class="flex items-center gap-5">
        <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-secondary-container text-[15px] font-bold text-on-secondary-container ring-1 ring-secondary/20">
          {{ userInitials }}
        </div>
        <div class="min-w-0 flex-1">
          <div class="flex flex-wrap items-center gap-2">
            <p class="row-primary truncate">{{ auth.currentUser?.fullName ?? "Compte professionnel" }}</p>
            <span :class="roleBadgeClass">{{ roleLabel }}</span>
          </div>
          <p class="row-meta mt-0.5 truncate">{{ auth.currentUser?.email ?? "Email non renseigné" }}</p>
        </div>
      </div>
    </section>

    <!-- Quick-nav to salon settings (role-gated) -->
    <section class="panel-clean divide-y divide-outline-variant/40">
      <div class="px-6 py-4 md:px-8">
        <h3 class="section-label">Paramètres du salon</h3>
      </div>
      <template v-for="link in salonLinks" :key="link.to">
        <RouterLink
          v-if="link.show"
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
      </template>
      <div v-if="!auth.isManager" class="px-6 py-4 md:px-8">
        <p class="row-meta italic">Seuls les managers et propriétaires peuvent modifier les paramètres du salon.</p>
      </div>
    </section>

    <!-- Password change -->
    <section class="panel-clean p-6 md:p-8">
      <div class="flex items-center justify-between gap-4 mb-6">
        <div>
          <h3 class="row-primary">Sécurité</h3>
          <p class="row-meta mt-1">Mettez à jour votre mot de passe régulièrement pour protéger votre accès.</p>
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
  ChevronRightIcon,
  ClockIcon,
  CreditCardIcon,
  KeyIcon,
  UserGroupIcon
} from "@heroicons/vue/24/outline";
import { toast } from "vue-sonner";

import { changePassword } from "@/lib/api";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();

const form = reactive({ currentPassword: "", newPassword: "", confirm: "" });
const loading = ref(false);
const error = ref("");

const userInitials = computed(() => {
  const name = auth.currentUser?.fullName?.trim();
  if (!name) return "BA";
  return name.split(/\s+/).slice(0, 2).map(n => n[0].toUpperCase()).join("");
});

const roleLabel = computed(() => {
  if (auth.currentUser?.role === "salon_owner") return "Propriétaire";
  if (auth.currentUser?.role === "salon_manager") return "Manager";
  return "Staff";
});

const roleBadgeClass = computed(() => {
  if (auth.currentUser?.role === "salon_owner")
    return "inline-flex items-center rounded-full bg-primary/10 px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-widest text-primary";
  if (auth.currentUser?.role === "salon_manager")
    return "inline-flex items-center rounded-full bg-secondary/10 px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-widest text-secondary";
  return "inline-flex items-center rounded-full bg-outline-variant/40 px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-widest text-cocoa/60";
});

const salonLinks = computed(() => [
  {
    label: "Profil du salon",
    description: "Informations, photos, services visibles par les clients",
    to: "/pro/salon/profile",
    icon: BuildingStorefrontIcon,
    show: auth.isOwner
  },
  {
    label: "Équipe",
    description: "Membres du personnel, rôles et accès",
    to: "/pro/salon/team",
    icon: UserGroupIcon,
    show: auth.isManager
  },
  {
    label: "Horaires",
    description: "Plages d'ouverture et disponibilités",
    to: "/pro/salon/hours",
    icon: ClockIcon,
    show: auth.isManager
  },
  {
    label: "Abonnement",
    description: "Formule active, renouvellement et facturation",
    to: "/pro/subscription",
    icon: CreditCardIcon,
    show: auth.isOwner
  },
]);

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
