import type { CurrentUser } from "@beauteavenue/contracts";
import { defineStore } from "pinia";
import { ref, computed } from "vue";

import { ApiError, fetchCurrentUser, loginAdmin, logoutAdmin, refreshAdminSession, registerAdminSessionController } from "@/lib/api";

export const useAdminAuthStore = defineStore("admin-auth", () => {
  const accessToken = ref<string | null>(null);
  const refreshToken = ref<string | null>(null);
  const currentUser = ref<CurrentUser | null>(null);
  const initialized = ref(false);

  const isAuthenticated = computed(() => Boolean(accessToken.value && currentUser.value?.role === "platform_admin"));

  function clearSession() {
    accessToken.value = null;
    refreshToken.value = null;
    currentUser.value = null;
  }

  async function refreshSessionIfPossible(): Promise<boolean> {
    const attemptedRefreshToken = refreshToken.value;
    if (!attemptedRefreshToken) return false;
    try {
      const session = await refreshAdminSession(attemptedRefreshToken);
      accessToken.value = session.accessToken;
      refreshToken.value = session.refreshToken;
      return true;
    } catch {
      if (refreshToken.value === attemptedRefreshToken) {
        clearSession();
      }
      return false;
    }
  }

  async function restoreSession() {
    if (!accessToken.value) {
      currentUser.value = null;
      initialized.value = true;
      return;
    }

    try {
      currentUser.value = await fetchCurrentUser(accessToken.value);
    } catch (error) {
      if (error instanceof ApiError && [401, 403, 404].includes(error.statusCode)) {
        clearSession();
      }
    } finally {
      initialized.value = true;
    }
  }

  async function login(email: string, password: string) {
    const session = await loginAdmin({ email, password });
    accessToken.value = session.accessToken;
    refreshToken.value = session.refreshToken;
    await restoreSession();
  }

  async function logout() {
    const token = accessToken.value;
    const refresh = refreshToken.value;

    if (token) {
      await logoutAdmin(token, refresh ?? undefined).catch(() => undefined);
    }

    clearSession();
    initialized.value = true;
  }

  registerAdminSessionController({
    getAccessToken: () => accessToken.value,
    getRefreshToken: () => refreshToken.value,
    applySession: (session) => {
      accessToken.value = session.accessToken;
      refreshToken.value = session.refreshToken;
    },
    clearSessionIfRefreshTokenMatches: (attemptedRefreshToken) => {
      if (refreshToken.value === attemptedRefreshToken) {
        clearSession();
      }
    }
  });

  return { accessToken, refreshToken, currentUser, initialized, isAuthenticated, clearSession, refreshSessionIfPossible, restoreSession, login, logout };
}, {
  persist: {
    key: "beauteavenue.admin.session",
    pick: ["accessToken", "refreshToken"]
  }
});
