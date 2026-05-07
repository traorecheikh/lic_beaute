import type { CurrentUser } from "@beauteavenue/contracts";
import { defineStore } from "pinia";

import { fetchCurrentUser, loginAdmin, logoutAdmin } from "@/lib/api";

type AdminAuthState = {
  accessToken: string | null;
  currentUser: CurrentUser | null;
  initialized: boolean;
};

export const useAdminAuthStore = defineStore("admin-auth", {
  state: (): AdminAuthState => ({
    accessToken: null,
    currentUser: null,
    initialized: false
  }),
  persist: {
    key: "beauteavenue.admin.accessToken",
    paths: ["accessToken"]
  },
  getters: {
    isAuthenticated: (state) => Boolean(state.accessToken && state.currentUser?.role === "platform_admin")
  },
  actions: {
    async restoreSession() {
      if (!this.accessToken) {
        this.currentUser = null;
        this.initialized = true;
        return;
      }

      try {
        this.currentUser = await fetchCurrentUser(this.accessToken);
      } catch {
        this.accessToken = null;
        this.currentUser = null;
      } finally {
        this.initialized = true;
      }
    },
    async login(email: string, password: string) {
      const session = await loginAdmin({ email, password });
      this.accessToken = session.accessToken;
      await this.restoreSession();
    },
    async logout() {
      const token = this.accessToken;

      if (token) {
        await logoutAdmin(token).catch(() => undefined);
      }

      this.$reset();
      this.initialized = true;
    }
  }
});
