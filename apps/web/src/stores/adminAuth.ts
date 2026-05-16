import type { CurrentUser } from "@beauteavenue/contracts";
import { defineStore } from "pinia";

import { ApiError, fetchCurrentUser, loginAdmin, logoutAdmin, refreshAdminSession } from "@/lib/api";

type AdminAuthState = {
  accessToken: string | null;
  refreshToken: string | null;
  currentUser: CurrentUser | null;
  initialized: boolean;
};

export const useAdminAuthStore = defineStore("admin-auth", {
  state: (): AdminAuthState => ({
    accessToken: null,
    refreshToken: null,
    currentUser: null,
    initialized: false
  }),
  persist: {
    key: "beauteavenue.admin.session",
    paths: ["accessToken", "refreshToken"]
  },
  getters: {
    isAuthenticated: (state) => Boolean(state.accessToken && state.currentUser?.role === "platform_admin")
  },
  actions: {
    clearSession() {
      this.accessToken = null;
      this.refreshToken = null;
      this.currentUser = null;
    },
    async refreshSessionIfPossible() {
      if (!this.refreshToken) return false;
      try {
        const session = await refreshAdminSession(this.refreshToken);
        this.accessToken = session.accessToken;
        this.refreshToken = session.refreshToken;
        return true;
      } catch {
        this.clearSession();
        return false;
      }
    },
    async restoreSession() {
      if (!this.accessToken) {
        this.currentUser = null;
        this.initialized = true;
        return;
      }

      try {
        this.currentUser = await fetchCurrentUser(this.accessToken);
      } catch (error) {
        const isAuthError = error instanceof ApiError && error.statusCode === 401;
        if (isAuthError && (await this.refreshSessionIfPossible()) && this.accessToken) {
          try {
            this.currentUser = await fetchCurrentUser(this.accessToken);
          } catch (retryError) {
            if (retryError instanceof ApiError && retryError.statusCode === 401) {
              this.clearSession();
            }
          }
        } else if (isAuthError) {
          this.clearSession();
        }
      } finally {
        this.initialized = true;
      }
    },
    async login(email: string, password: string) {
      const session = await loginAdmin({ email, password });
      this.accessToken = session.accessToken;
      this.refreshToken = session.refreshToken;
      await this.restoreSession();
    },
    async logout() {
      const token = this.accessToken;
      const refreshToken = this.refreshToken;

      if (token) {
        await logoutAdmin(token, refreshToken ?? undefined).catch(() => undefined);
      }

      this.$reset();
      this.initialized = true;
    }
  }
});
