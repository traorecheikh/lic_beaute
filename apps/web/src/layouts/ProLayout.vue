<template>
  <div class="min-h-screen bg-neutral-bg selection:bg-primary/20">
    <header class="sticky top-0 z-[100] border-b border-outline-variant/50 bg-surface/95 backdrop-blur-xl">
      <div class="mx-auto flex max-w-[1480px] items-center gap-8 px-4 py-3 sm:px-6 lg:px-8">
        <!-- Left: Logo + Salon name -->
        <div class="flex items-center gap-5 shrink-0">
          <RouterLink to="/pro/calendar" class="flex items-center gap-4 transition hover:opacity-80">
            <img src="/logo.png" alt="Beauté Avenue" class="h-10 w-auto object-contain" />
            <div class="hidden sm:block">
              <p class="text-[17px] font-medium-bold tracking-tight text-espresso font-sans">
                {{ auth.salonName ?? "Mon Salon" }}
              </p>
            </div>
          </RouterLink>
        </div>

        <!-- Center: Navigation -->
        <nav class="flex min-w-0 flex-1 items-center justify-center gap-1 overflow-x-auto no-scrollbar">
          <template v-for="item in centerNavItems" :key="item.to">
            <RouterLink
              v-if="(!item.ownerOnly || auth.isOwner) && (!item.managerOnly || auth.isManager)"
              :to="item.to"
              :class="[
                'inline-flex items-center gap-2 rounded-full px-4 py-2 text-[13px] font-bold tracking-tight transition whitespace-nowrap',
                isNavItemActive(item.to)
                  ? 'bg-primary-container text-on-primary-container'
                  : 'text-cocoa/60 hover:bg-neutral-bg hover:text-espresso'
              ]"
            >
              <component :is="item.icon" class="w-4 h-4 shrink-0" />
              <span>{{ item.label }}</span>
            </RouterLink>
          </template>
        </nav>

        <!-- Right: Actions + User -->
        <div class="flex items-center gap-3 shrink-0">
          <a href="https://wa.me/221338671010" target="_blank" rel="noopener noreferrer" class="p-2 text-cocoa/60 hover:text-espresso transition" title="Contacter le support via WhatsApp">
            <ChatBubbleLeftRightIcon class="w-5 h-5" />
          </a>
          <button @click="openInbox" class="p-2 text-cocoa/60 hover:text-espresso transition relative" :title="`${unreadCount} notification${unreadCount !== 1 ? 's' : ''} non lue${unreadCount !== 1 ? 's' : ''}`">
            <BellIcon class="w-5 h-5" :class="{ 'text-primary': unreadCount > 0 }" />
            <span v-if="unreadCount > 0" class="absolute -top-0.5 -right-0.5 min-w-[16px] h-4 px-1 bg-primary text-white text-[10px] font-bold rounded-full flex items-center justify-center leading-none">
              {{ unreadCount > 99 ? '99+' : unreadCount }}
            </span>
          </button>
          
          <div class="h-6 w-px bg-outline-variant"></div>

          <div class="flex items-center gap-3">
            <div class="hidden text-right lg:block">
              <p class="text-[13px] font-bold text-espresso leading-none mb-0.5">{{ auth.currentUser?.fullName }}</p>
              <p class="text-[11px] font-semibold text-cocoa/40 uppercase tracking-wider">{{ userRoleLabel }}</p>
            </div>
            
            <div ref="menuRoot" class="relative">
              <button @click="menuOpen = !menuOpen" class="flex h-10 w-10 items-center justify-center rounded-full bg-secondary-container text-[12px] font-bold text-on-secondary-container ring-1 ring-secondary/20 overflow-hidden">
                {{ userInitials }}
              </button>
              <transition
                enter-active-class="transition duration-100 ease-out"
                enter-from-class="transform scale-95 opacity-0"
                enter-to-class="transform scale-100 opacity-100"
                leave-active-class="transition duration-75 ease-in"
                leave-from-class="transform scale-100 opacity-100"
                leave-to-class="transform scale-95 opacity-0"
              >
                <div v-if="menuOpen" class="absolute right-0 mt-2 w-56 origin-top-right rounded-2xl bg-surface p-2 shadow-xl ring-1 ring-outline-variant focus:outline-none">
                  <div class="px-3 py-2 border-b border-outline-variant mb-2">
                    <p class="text-xs font-bold text-espresso">{{ auth.currentUser?.fullName }}</p>
                    <p class="text-[10px] text-cocoa/60">{{ auth.currentUser?.email }}</p>
                  </div>
                  
                  <template v-for="item in dropdownItems" :key="item.to">
                    <RouterLink
                      v-if="(!item.ownerOnly || auth.isOwner) && (!item.managerOnly || auth.isManager)"
                      :to="item.to"
                      @click="menuOpen = false"
                      class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm text-cocoa/60 transition hover:bg-neutral-bg hover:text-espresso"
                    >
                      <component :is="item.icon" class="w-4 h-4" />
                      {{ item.label }}
                    </RouterLink>
                  </template>

                  <div class="mt-2 pt-2 border-t border-outline-variant">
                    <button
                      @click="handleLogout"
                      class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm text-error transition hover:bg-error/5"
                    >
                      <ArrowRightOnRectangleIcon class="w-4 h-4" />
                      Déconnexion
                    </button>
                  </div>
                </div>
              </transition>
            </div>
          </div>
        </div>
      </div>
    </header>

    <div v-if="gracePeriodEndsAt && !graceBannerDismissed" data-testid="grace-banner" class="bg-amber-50 border-b border-amber-200 px-4 py-3 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-[1480px] flex items-center justify-between gap-4">
        <p class="text-sm font-semibold text-amber-800">
          Votre abonnement a expiré. Vous disposez encore de <strong>{{ graceDaysLeft }} jour{{ graceDaysLeft === 1 ? '' : 's' }}</strong> avant la suspension de votre salon.
          <RouterLink to="/pro/subscription" class="underline ml-1">Renouveler maintenant →</RouterLink>
        </p>
        <button @click="graceBannerDismissed = true" class="shrink-0 text-amber-600 hover:text-amber-900 text-lg font-bold leading-none">×</button>
      </div>
    </div>

    <div
      v-if="showSubscriptionLockReminder"
      class="fixed inset-0 z-[120] flex items-center justify-center bg-black/35 p-4"
      @click.self="subscriptionLockDismissed = true"
    >
      <div class="w-full max-w-lg rounded-2xl border border-outline-variant bg-surface p-6 shadow-2xl">
        <h3 class="text-lg font-semibold text-espresso">Mode lecture seule</h3>
        <p class="mt-2 text-sm text-cocoa/70 leading-relaxed">
          Votre salon est approuvé mais l'abonnement n'est pas encore actif.
          Vous pouvez consulter vos données, mais les actions de modification sont temporairement bloquées.
        </p>
        <div class="mt-5 flex items-center justify-end gap-3">
          <button class="btn-secondary px-4 text-sm" @click="subscriptionLockDismissed = true">
            Plus tard
          </button>
          <RouterLink class="btn-primary px-4 text-sm" to="/pro/subscription" @click="subscriptionLockDismissed = true">
            Activer l'abonnement
          </RouterLink>
        </div>
      </div>
    </div>

    <main>
      <div class="mx-auto max-w-[1480px] px-4 pb-12 pt-8 sm:px-6 lg:px-8">
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
import { computed, onBeforeUnmount, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import {
  CalendarIcon,
  UsersIcon,
  BanknotesIcon,
  InboxIcon,
  ChartBarIcon,
  Squares2X2Icon,
  ChatBubbleLeftRightIcon,
  BellIcon,
  UserIcon,
  UserGroupIcon,
  ClockIcon,
  CreditCardIcon,
  ArrowRightOnRectangleIcon,
  BuildingStorefrontIcon,
  TicketIcon
} from "@heroicons/vue/24/outline";

import { useQuery } from "@tanstack/vue-query";
import { fetchNotificationsUnreadCount, fetchProSalon, fetchProSubscription } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();
const route = useRoute();
const router = useRouter();
const menuOpen = ref(false);
const menuRoot = ref<HTMLElement | null>(null);
const graceBannerDismissed = ref(false);
const subscriptionLockDismissed = ref(false);

const subQuery = useQuery({
  queryKey: ["pro-subscription", "layout"],
  queryFn: () => fetchProSubscription(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken && auth.isOwner)),
  staleTime: 5 * 60 * 1000
});

const salonQuery = useQuery({
  queryKey: ["pro-salon", "layout"],
  queryFn: () => fetchProSalon(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken)),
  staleTime: 60 * 1000
});

const notifQuery = useQuery({
  queryKey: ["pro-notifications-unread"],
  queryFn: () => fetchNotificationsUnreadCount(auth.accessToken ?? ""),
  enabled: computed(() => Boolean(auth.accessToken)),
  refetchInterval: 30_000,
  staleTime: 15_000
});

const unreadCount = computed(() => notifQuery.data.value ?? 0);

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

let prevUnreadCount: number | null = null;
watch(unreadCount, (next, prev) => {
  if (prevUnreadCount === null) { prevUnreadCount = prev ?? 0; return; }
  if (next > (prev ?? 0)) playNotifSound();
  prevUnreadCount = next;
});

const gracePeriodEndsAt = computed(() => {
  const v = (subQuery.data.value as Record<string, unknown> | undefined)?.gracePeriodEndsAt;
  if (!v) return null;
  const d = v instanceof Date ? v : new Date(v as string);
  return d > new Date() ? d : null;
});

const graceDaysLeft = computed(() => {
  if (!gracePeriodEndsAt.value) return null;
  return Math.ceil((gracePeriodEndsAt.value.getTime() - Date.now()) / (1000 * 60 * 60 * 24));
});

const subscriptionStatus = computed(() => {
  const status = (subQuery.data.value as Record<string, unknown> | undefined)?.status;
  return typeof status === "string" ? status : null;
});

const isSubscriptionLocked = computed(() => {
  const status = subscriptionStatus.value;
  return status === "inactive" || status === "paused" || status === "cancelled" || status === "expired";
});

const isLockExceptionRoute = computed(() => {
  const name = route.name;
  return name === "pro-subscription" || name === "pro-subscription-callback" || name === "pro-account" || name === "pro-approval-status";
});

const showSubscriptionLockReminder = computed(() =>
  auth.isOwner &&
  isSubscriptionLocked.value &&
  !isLockExceptionRoute.value &&
  !subscriptionLockDismissed.value
);

const centerNavItems = [
  { label: "Agenda", to: "/pro/calendar", icon: CalendarIcon },
  { label: "Clients", to: "/pro/clients", icon: UsersIcon },
  { label: "Ventes", to: "/pro/payouts", icon: BanknotesIcon, ownerOnly: true },
  { label: "Inbox", to: "/pro/bookings/inbox", icon: InboxIcon },
  { label: "Rapports", to: "/pro/analytics", icon: ChartBarIcon, managerOnly: true },
  { label: "Services", to: "/pro/salon/services", icon: Squares2X2Icon, managerOnly: true },
];

const dropdownItems = [
  { label: "Profil Salon", to: "/pro/salon/profile", icon: BuildingStorefrontIcon, ownerOnly: true },
  { label: "Équipe", to: "/pro/salon/team", icon: UserGroupIcon, managerOnly: true },
  { label: "Horaires", to: "/pro/salon/hours", icon: ClockIcon, managerOnly: true },
  { label: "Abonnement", to: "/pro/subscription", icon: CreditCardIcon, ownerOnly: true },
  { label: "Mon Compte", to: "/pro/account", icon: UserIcon },
];

const userInitials = computed(() => {
  const fullName = auth.currentUser?.fullName?.trim();
  if (!fullName) return "BA";
  return fullName.split(/\s+/).slice(0, 2).map(n => n[0].toUpperCase()).join("");
});

const userRoleLabel = computed(() => {
  if (auth.currentUser?.role === "salon_owner") return "Propriétaire";
  if (auth.currentUser?.role === "salon_manager") return "Manager";
  return "Staff";
});

function isNavItemActive(path: string) {
  return route.path === path || (path !== "/pro/dashboard" && route.path.startsWith(path));
}

async function handleLogout() {
  menuOpen.value = false;
  await auth.logout();
  router.push("/pro/login");
}

function handleDocumentClick(event: MouseEvent) {
  if (!menuOpen.value || !menuRoot.value) return;
  if (!menuRoot.value.contains(event.target as Node)) {
    menuOpen.value = false;
  }
}

function openInbox() {
  void router.push("/pro/bookings/inbox");
}

onMounted(() => {
  document.addEventListener("click", handleDocumentClick);
});

onBeforeUnmount(() => {
  document.removeEventListener("click", handleDocumentClick);
});

watch(
  () => (salonQuery.data.value as any)?.approvalStatus,
  (status: string | undefined) => {
    if (status && status !== "approved" && route.path !== "/pro/approval-status") {
      router.replace("/pro/approval-status");
    }
  },
  { immediate: true }
);

watch(
  () => route.fullPath,
  () => {
    menuOpen.value = false;
    const status = (salonQuery.data.value as any)?.approvalStatus as string | undefined;
    if (status && status !== "approved" && route.path !== "/pro/approval-status") {
      router.replace("/pro/approval-status");
    }
  }
);

watch(
  () => subscriptionStatus.value,
  () => {
    subscriptionLockDismissed.value = false;
  }
);
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>
