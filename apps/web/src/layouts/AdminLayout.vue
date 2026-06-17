<template>
  <div class="min-h-screen bg-neutral-bg selection:bg-primary/20">
    <header class="sticky top-0 z-[100] border-b border-white/10 bg-[#1B1730]/95 text-white shadow-[0_18px_40px_rgba(13,10,28,0.18)] backdrop-blur-xl">
      <div class="mx-auto flex max-w-[1480px] items-center gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <RouterLink
          to="/admin/dashboard"
          class="flex min-w-0 items-center gap-5 transition hover:opacity-80"
        >
          <img src="/logo.png" alt="Beauté Avenue" class="h-10 w-auto object-contain" />
          <div class="min-w-0">
            <p class="text-[19px] font-medium-bold tracking-tight text-white font-sans">Beauté Avenue</p>
          </div>
        </RouterLink>

        <nav class="hidden min-w-0 flex-1 items-center justify-center gap-1 lg:flex">
          <RouterLink
            v-for="item in navItems"
            :key="item.to"
            :to="item.to"
            :class="[
              'inline-flex items-center gap-2 rounded-full px-5 py-2 text-[13px] font-bold tracking-tight transition',
              isNavItemActive(item)
                ? 'bg-white/10 text-white shadow-[inset_0_0_0_1px_rgba(255,255,255,0.1)]'
                : 'text-white/50 hover:bg-white/5 hover:text-white'
            ]"
          >
            <component :is="item.icon" class="w-4 h-4 shrink-0" />
            <span class="whitespace-nowrap">{{ item.label }}</span>
          </RouterLink>
        </nav>

        <div class="ml-auto flex items-center gap-3">
          <button @click="goToNotifications" class="relative p-2 text-white/40 hover:text-white transition" :title="`${adminUnreadCount} notification${adminUnreadCount !== 1 ? 's' : ''} non lue${adminUnreadCount !== 1 ? 's' : ''}`">
            <BellIcon class="w-5 h-5" :class="{ 'text-primary': adminUnreadCount > 0 }" />
            <span v-if="adminUnreadCount > 0" class="absolute -top-0.5 -right-0.5 min-w-[16px] h-4 px-1 bg-primary text-white text-[10px] font-bold rounded-full flex items-center justify-center leading-none">
              {{ adminUnreadCount > 99 ? '99+' : adminUnreadCount }}
            </span>
          </button>

          <div class="hidden items-center gap-3 rounded-full border border-white/5 bg-white/5 pl-1 pr-4 py-1 md:flex">
            <div class="flex h-8 w-8 items-center justify-center rounded-full bg-primary/20 text-[10px] font-bold text-primary ring-1 ring-primary/20">
              {{ userInitials }}
            </div>
            <p class="truncate text-xs font-bold tracking-tight text-white/70">
              {{ auth.currentUser?.fullName ?? "Admin" }}
            </p>
          </div>

          <button
            type="button"
            class="inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-widest text-white/30 transition hover:text-white"
            @click="handleLogout"
          >
            <ArrowRightOnRectangleIcon class="w-4 h-4" />
            Déconnexion
          </button>
        </div>
      </div>

      <div class="border-t border-white/10 lg:hidden">
        <div class="mx-auto flex max-w-[1480px] gap-2 overflow-x-auto px-4 py-3 sm:px-6">
          <RouterLink
            v-for="item in navItems"
            :key="`mobile-${item.to}`"
            :to="item.to"
            :class="[
              'whitespace-nowrap rounded-full px-4 py-2 text-[12px] font-semibold tracking-tight transition',
              isNavItemActive(item)
                ? 'bg-white text-[#1B1730]'
                : 'border border-white/10 bg-white/5 text-white/70'
            ]"
          >
            {{ item.label }}
          </RouterLink>
        </div>
      </div>
    </header>

    <main>
      <div class="mx-auto max-w-[1480px] px-4 pb-8 pt-6 sm:px-6 lg:px-8">
        <RouterView v-slot="{ Component }">
          <Transition
            mode="out-in"
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="opacity-0 translate-y-1"
            enter-to-class="opacity-100 translate-y-0"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="opacity-100 translate-y-0"
            leave-to-class="opacity-0 translate-y-1"
          >
            <component :is="Component" />
          </Transition>
        </RouterView>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useQuery } from "@tanstack/vue-query";
import { toast } from "vue-sonner";
import {
  ArrowRightOnRectangleIcon,
  BellIcon,
  BuildingStorefrontIcon,
  ChartBarIcon,
  ClipboardDocumentListIcon,
  Cog6ToothIcon,
  CreditCardIcon,
  UserCircleIcon,
  BanknotesIcon
} from "@heroicons/vue/24/outline";

import { useAdminAuthStore } from "@/stores/adminAuth";
import { fetchNotificationsUnreadCount } from "@/lib/pro-api";

const auth = useAdminAuthStore();
const route = useRoute();
const router = useRouter();

const adminNotifQuery = useQuery({
  queryKey: ["admin-notifications-unread"],
  queryFn: () => fetchNotificationsUnreadCount(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken)),
  refetchInterval: 30_000,
  staleTime: 15_000
});
const adminUnreadCount = computed(() => adminNotifQuery.data.value ?? 0);

function playNotifSound() {
  try {
    const ctx = new AudioContext();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.type = "sine";
    osc.frequency.setValueAtTime(880, ctx.currentTime);
    osc.frequency.exponentialRampToValueAtTime(660, ctx.currentTime + 0.15);
    gain.gain.setValueAtTime(0.18, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.3);
    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + 0.3);
    osc.onended = () => void ctx.close();
  } catch {
    // AudioContext may be unavailable in some environments
  }
}

let prevAdminUnreadCount: number | null = null;
watch(adminUnreadCount, (next, prev) => {
  if (prevAdminUnreadCount === null) { prevAdminUnreadCount = prev ?? 0; return; }
  if (next > (prev ?? 0)) playNotifSound();
  prevAdminUnreadCount = next;
});

function goToNotifications() {
  void router.push("/admin/salons");
}

const navItems = [
  { label: "Pilotage",       to: "/admin/dashboard",     icon: ChartBarIcon },
  { label: "Salons",         to: "/admin/salons",         icon: BuildingStorefrontIcon },
  { label: "Abonnements",    to: "/admin/subscriptions",  icon: CreditCardIcon },
  { label: "Versements",     to: "/admin/payouts",        icon: BanknotesIcon },
  { label: "Audit log",      to: "/admin/audit",          icon: ClipboardDocumentListIcon },
  { label: "Configuration",  to: "/admin/config",         icon: Cog6ToothIcon },
  { label: "Compte",         to: "/admin/account",        icon: UserCircleIcon }
] as const;

const userInitials = computed(() => {
  const fullName = auth.currentUser?.fullName?.trim();

  if (!fullName) {
    return "BA";
  }

  return fullName
    .split(/\s+/)
    .slice(0, 2)
    .map((part) => part.charAt(0).toUpperCase())
    .join("");
});

const roleLabel = computed(() => {
  const role = auth.currentUser?.role;

  if (!role) {
    return "Platform admin";
  }

  return role
    .split("_")
    .map((segment) => segment.charAt(0).toUpperCase() + segment.slice(1))
    .join(" ");
});

function isNavItemActive(item: (typeof navItems)[number]) {
  return route.path === item.to || route.path.startsWith(`${item.to}/`);
}

async function handleLogout() {
  await auth.logout();
  toast.success("Session fermée.");
  await router.push({ name: "admin-login" });
}
</script>
