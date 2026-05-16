<template>
  <div class="min-h-screen bg-neutral-bg selection:bg-primary/20">
    <header class="sticky top-0 z-[100] border-b border-outline-variant/50 bg-surface/95 backdrop-blur-xl">
      <div class="mx-auto flex max-w-[1480px] items-center gap-8 px-4 py-3 sm:px-6 lg:px-8">
        <!-- Left: Logo + Salon name -->
        <div class="flex items-center gap-4 shrink-0">
          <RouterLink to="/pro/calendar" class="flex items-center gap-3 transition hover:opacity-80">
            <img src="/logo.png" alt="Beauté Avenue" class="h-8 w-auto object-contain" />
            <div class="hidden sm:block">
              <p class="text-sm font-bold tracking-tight text-espresso font-display">
                {{ auth.salonName ?? "Mon Salon" }}
              </p>
            </div>
          </RouterLink>
        </div>

        <!-- Center: Navigation -->
        <nav class="flex min-w-0 flex-1 items-center justify-center gap-1 overflow-x-auto no-scrollbar">
          <template v-for="item in centerNavItems" :key="item.to">
            <RouterLink
              v-if="!item.ownerOnly || auth.isOwner"
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
          <button @click="callSupport" class="p-2 text-cocoa/60 hover:text-espresso transition">
            <PhoneIcon class="w-5 h-5" />
          </button>
          <button @click="openInbox" class="p-2 text-cocoa/60 hover:text-espresso transition relative">
            <BellIcon class="w-5 h-5" />
            <span class="absolute top-2 right-2 w-2 h-2 bg-primary rounded-full"></span>
          </button>
          
          <div class="h-6 w-px bg-outline-variant"></div>

          <div class="flex items-center gap-3">
            <div class="hidden text-right lg:block">
              <p class="text-[13px] font-bold text-espresso leading-none mb-0.5">{{ auth.currentUser?.fullName }}</p>
              <p class="text-[11px] font-semibold text-cocoa/40 uppercase tracking-wider">{{ auth.currentUser?.role === 'salon_owner' ? 'Propriétaire' : 'Staff' }}</p>
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
                      v-if="!item.ownerOnly || auth.isOwner"
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
  PhoneIcon,
  BellIcon,
  UserIcon,
  UserGroupIcon,
  ClockIcon,
  CreditCardIcon,
  ArrowRightOnRectangleIcon,
  BuildingStorefrontIcon,
  TicketIcon
} from "@heroicons/vue/24/outline";

import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();
const route = useRoute();
const router = useRouter();
const menuOpen = ref(false);
const menuRoot = ref<HTMLElement | null>(null);

const centerNavItems = [
  { label: "Agenda", to: "/pro/calendar", icon: CalendarIcon },
  { label: "Clients", to: "/pro/clients", icon: UsersIcon },
  { label: "Ventes", to: "/pro/payouts", icon: BanknotesIcon },
  { label: "Inbox", to: "/pro/bookings/inbox", icon: InboxIcon },
  { label: "Rapports", to: "/pro/analytics", icon: ChartBarIcon, ownerOnly: true },
  { label: "Services", to: "/pro/salon/services", icon: Squares2X2Icon, ownerOnly: true },
  // { label: "Codes Promo", to: "/pro/vouchers", icon: TicketIcon, ownerOnly: true },
];

const dropdownItems = [
  { label: "Profil Salon", to: "/pro/salon/profile", icon: BuildingStorefrontIcon, ownerOnly: true },
  { label: "Équipe", to: "/pro/salon/team", icon: UserGroupIcon, ownerOnly: true },
  { label: "Horaires", to: "/pro/salon/hours", icon: ClockIcon, ownerOnly: true },
  { label: "Abonnement", to: "/pro/subscription", icon: CreditCardIcon, ownerOnly: true },
  { label: "Mon Compte", to: "/pro/account", icon: UserIcon },
];

const userInitials = computed(() => {
  const fullName = auth.currentUser?.fullName?.trim();
  if (!fullName) return "BA";
  return fullName.split(/\s+/).slice(0, 2).map(n => n[0].toUpperCase()).join("");
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

function callSupport() {
  window.open("tel:+221338671010", "_self");
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
  () => route.fullPath,
  () => {
    menuOpen.value = false;
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
