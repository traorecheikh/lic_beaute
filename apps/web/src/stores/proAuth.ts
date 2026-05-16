import type { CurrentUser } from "@/lib/generated";
import { defineStore } from "pinia";

import { ApiError } from "@/lib/api";
import {
  fetchProCurrentUser,
  fetchProSalon,
  loginPro,
  logoutPro,
  refreshProSession,
  verifyProOtp
} from "@/lib/pro-api";

type ProAuthState = {
  accessToken: string | null;
  refreshToken: string | null;
  currentUser: CurrentUser | null;
  salonName: string | null;
  initialized: boolean;
};

function isProRole(role: CurrentUser["role"]): role is "salon_owner" | "salon_staff" {
  return role === "salon_owner" || role === "salon_staff";
}

export const useProAuthStore = defineStore("pro-auth", {
  state: (): ProAuthState => ({
    accessToken: null,
    refreshToken: null,
    currentUser: null,
    salonName: null,
    initialized: false
  }),
  persist: {
    key: "beauteavenue.pro.session",
    paths: ["accessToken", "refreshToken"]
  },
  getters: {
    isAuthenticated: (state) => {
      return Boolean(state.accessToken && state.currentUser && isProRole(state.currentUser.role));
    },
    isOwner: (state) => state.currentUser?.role === "salon_owner"
  },
  actions: {
    clearSession() {
      this.accessToken = null;
      this.refreshToken = null;
      this.currentUser = null;
      this.salonName = null;
    },

    async refreshSessionIfPossible() {
      if (!this.refreshToken) return false;
      try {
        const session = await refreshProSession(this.refreshToken);
        this.accessToken = session.accessToken;
        this.refreshToken = session.refreshToken;
        return true;
      } catch {
        this.clearSession();
        return false;
      }
    },

    async applySession(accessToken: string, refreshToken: string) {
      this.accessToken = accessToken;
      this.refreshToken = refreshToken;
      await this.restoreSession();
      if (!this.isAuthenticated) {
        throw new Error("Ce compte n'a pas accès à l'espace pro.");
      }
    },

    async restoreSession() {
      if (!this.accessToken) {
        this.currentUser = null;
        this.salonName = null;
        this.initialized = true;
        return;
      }

      try {
        const user = await fetchProCurrentUser(this.accessToken);
        if (!isProRole(user.role)) {
          this.clearSession();
          this.initialized = true;
          return;
        }

        this.currentUser = user;

        try {
          const salon = await fetchProSalon(this.accessToken);
          this.salonName = salon.name;
        } catch {
          this.salonName = null;
        }
      } catch (error) {
        const isAuthError = error instanceof ApiError && error.statusCode === 401;
        if (isAuthError && (await this.refreshSessionIfPossible()) && this.accessToken) {
          try {
            const user = await fetchProCurrentUser(this.accessToken);
            if (!isProRole(user.role)) {
              this.clearSession();
              return;
            }
            this.currentUser = user;
            try {
              const salon = await fetchProSalon(this.accessToken);
              this.salonName = salon.name;
            } catch {
              this.salonName = null;
            }
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
      const session = await loginPro({ email, password });
      await this.applySession(session.accessToken, session.refreshToken);
    },

    async loginWithOtp(phone: string, code: string) {
      const session = await verifyProOtp({ phone, code });
      await this.applySession(session.accessToken, session.refreshToken);
    },

    async logout() {
      const token = this.accessToken;
      const refreshToken = this.refreshToken;

      if (token) {
        await logoutPro(token, refreshToken ?? undefined).catch(() => undefined);
      }

      this.$reset();
      this.initialized = true;
    }
  }
});
