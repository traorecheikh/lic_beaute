import type { CurrentUser } from "@/lib/generated";
import { defineStore } from "pinia";
import { ref, computed } from "vue";

import { ApiError } from "@/lib/api";
import {
  fetchProCurrentUser,
  fetchProSalon,
  loginPro,
  logoutPro,
  refreshProSession,
  verifyProOtp
} from "@/lib/pro-api";

export type ProAuthState = {
  accessToken: string | null;
  refreshToken: string | null;
  currentUser: CurrentUser | null;
  salonName: string | null;
  initialized: boolean;
};

function isProRole(role: CurrentUser["role"]): role is "salon_owner" | "salon_staff" {
  return role === "salon_owner" || role === "salon_staff";
}

export const useProAuthStore = defineStore("pro-auth", () => {
  const accessToken = ref<string | null>(null);
  const refreshToken = ref<string | null>(null);
  const currentUser = ref<CurrentUser | null>(null);
  const salonName = ref<string | null>(null);
  const initialized = ref(false);

  const isAuthenticated = computed(() =>
    Boolean(accessToken.value && currentUser.value && isProRole(currentUser.value.role))
  );
  const isOwner = computed(() => currentUser.value?.role === "salon_owner");

  function clearSession() {
    accessToken.value = null;
    refreshToken.value = null;
    currentUser.value = null;
    salonName.value = null;
  }

  async function refreshSessionIfPossible(): Promise<boolean> {
    if (!refreshToken.value) return false;
    try {
      const session = await refreshProSession(refreshToken.value);
      accessToken.value = session.accessToken;
      refreshToken.value = session.refreshToken;
      return true;
    } catch {
      clearSession();
      return false;
    }
  }

  async function applySession(token: string, refresh: string) {
    accessToken.value = token;
    refreshToken.value = refresh;
    await restoreSession();
    if (!isAuthenticated.value) {
      throw new Error("Ce compte n'a pas accès à l'espace pro.");
    }
  }

  async function restoreSession() {
    if (!accessToken.value) {
      currentUser.value = null;
      salonName.value = null;
      initialized.value = true;
      return;
    }

    try {
      const user = await fetchProCurrentUser(accessToken.value);
      if (!isProRole(user.role)) {
        clearSession();
        initialized.value = true;
        return;
      }
      currentUser.value = user;
      try {
        const salon = await fetchProSalon(accessToken.value);
        salonName.value = salon.name;
      } catch {
        salonName.value = null;
      }
    } catch (error) {
      const isAuthError = error instanceof ApiError && error.statusCode === 401;
      if (isAuthError && (await refreshSessionIfPossible()) && accessToken.value) {
        try {
          const user = await fetchProCurrentUser(accessToken.value);
          if (!isProRole(user.role)) {
            clearSession();
            return;
          }
          currentUser.value = user;
          try {
            const salon = await fetchProSalon(accessToken.value);
            salonName.value = salon.name;
          } catch {
            salonName.value = null;
          }
        } catch (retryError) {
          if (retryError instanceof ApiError && retryError.statusCode === 401) {
            clearSession();
          }
        }
      } else if (isAuthError) {
        clearSession();
      }
    } finally {
      initialized.value = true;
    }
  }

  async function login(email: string, password: string) {
    const session = await loginPro({ email, password });
    await applySession(session.accessToken, session.refreshToken);
  }

  async function loginWithOtp(phone: string, code: string) {
    const session = await verifyProOtp({ phone, code });
    await applySession(session.accessToken, session.refreshToken);
  }

  async function logout() {
    const token = accessToken.value;
    const refresh = refreshToken.value;

    if (token) {
      await logoutPro(token, refresh ?? undefined).catch(() => undefined);
    }

    clearSession();
    initialized.value = true;
  }

  return {
    accessToken,
    refreshToken,
    currentUser,
    salonName,
    initialized,
    isAuthenticated,
    isOwner,
    clearSession,
    refreshSessionIfPossible,
    applySession,
    restoreSession,
    login,
    loginWithOtp,
    logout
  };
}, {
  persist: {
    key: "beauteavenue.pro.session",
    pick: ["accessToken", "refreshToken"]
  }
});
