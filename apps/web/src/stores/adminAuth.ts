import type { CurrentUser } from "@beauteavenue/contracts";
import { defineStore } from "pinia";
import { ref, computed } from "vue";

import { ApiError, fetchCurrentUser, loginAdmin, logoutAdmin, refreshAdminSession } from "@/lib/api";

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
    if (!refreshToken.value) return false;
    try {
      const session = await refreshAdminSession(refreshToken.value);
      accessToken.value = session.accessToken;
      refreshToken.value = session.refreshToken;
      return true;
    } catch {
      clearSession();
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
      const isAuthError = error instanceof ApiError && error.statusCode === 401;
      if (isAuthError && (await refreshSessionIfPossible()) && accessToken.value) {
        try {
          currentUser.value = await fetchCurrentUser(accessToken.value);
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

  return { accessToken, refreshToken, currentUser, initialized, isAuthenticated, clearSession, refreshSessionIfPossible, restoreSession, login, logout };
}, {
  persist: {
    key: "beauteavenue.admin.session",
    pick: ["accessToken", "refreshToken"]
  }
});
