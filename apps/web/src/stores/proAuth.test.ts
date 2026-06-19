/* @vitest-environment jsdom */

import { beforeEach, describe, expect, it, vi } from "vitest";
import { createPinia, setActivePinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";

import { useProAuthStore } from "./proAuth";

const {
  fetchProCurrentUser,
  fetchProSalon,
  loginPro,
  logoutPro,
  registerProSessionController,
  refreshProSession
} = vi.hoisted(() => ({
  fetchProCurrentUser: vi.fn(),
  fetchProSalon: vi.fn(),
  loginPro: vi.fn(),
  logoutPro: vi.fn(),
  registerProSessionController: vi.fn(),
  refreshProSession: vi.fn()
}));

vi.mock("@/lib/pro-api", () => ({
  fetchProCurrentUser,
  fetchProSalon,
  loginPro,
  logoutPro,
  registerProSessionController,
  refreshProSession
}));

function installLocalStorage() {
  const storage = new Map<string, string>();
  const localStorageMock = {
    getItem: (key: string) => storage.get(key) ?? null,
    setItem: (key: string, value: string) => { storage.set(key, String(value)); },
    removeItem: (key: string) => { storage.delete(key); },
    clear: () => { storage.clear(); }
  };

  Object.defineProperty(window, "localStorage", {
    value: localStorageMock,
    configurable: true
  });
  Object.defineProperty(globalThis, "localStorage", {
    value: localStorageMock,
    configurable: true
  });
}

function createTestingPinia() {
  const pinia = createPinia();
  pinia.use(piniaPluginPersistedstate);
  return pinia;
}

describe("pro auth store", () => {
  beforeEach(() => {
    installLocalStorage();
    setActivePinia(createTestingPinia());
    fetchProCurrentUser.mockReset();
    fetchProSalon.mockReset();
    loginPro.mockReset();
    logoutPro.mockReset();
    refreshProSession.mockReset();
  });

  it("restores an existing salon_owner session", async () => {
    fetchProCurrentUser.mockResolvedValue({
      id: "user-pro",
      fullName: "Salon Owner",
      email: "owner@salon.local",
      phone: "+221771234567",
      role: "salon_owner",
      salonId: "salon-1",
      city: "Dakar",
      avatarUrl: null,
      preferredContactChannel: "whatsapp",
      pushOptIn: true,
      marketingOptIn: false,
      preferredLanguage: "fr"
    });
    fetchProSalon.mockResolvedValue({
      id: "salon-1",
      name: "Mon Salon",
      approvalStatus: "approved",
      city: "Dakar",
      neighborhood: "Point E"
    });

    const store = useProAuthStore();
    store.$patch({ accessToken: "stored-token" });
    await store.restoreSession();

    expect(fetchProCurrentUser).toHaveBeenCalledWith("stored-token");
    expect(store.isAuthenticated).toBe(true);
    expect(store.currentUser?.role).toBe("salon_owner");
    expect(store.isOwner).toBe(true);
    expect(store.salonName).toBe("Mon Salon");
    expect(store.initialized).toBe(true);
  });

  it("restores a salon_staff session", async () => {
    fetchProCurrentUser.mockResolvedValue({
      id: "user-staff",
      fullName: "Staff Member",
      email: "staff@salon.local",
      phone: "+221771234568",
      role: "salon_staff",
      salonId: "salon-1",
      city: "Dakar",
      avatarUrl: null,
      preferredContactChannel: "sms",
      pushOptIn: true,
      marketingOptIn: false,
      preferredLanguage: "fr"
    });
    fetchProSalon.mockResolvedValue({
      id: "salon-1",
      name: "Mon Salon",
      approvalStatus: "approved",
      city: "Dakar",
      neighborhood: "Point E"
    });

    const store = useProAuthStore();
    store.$patch({ accessToken: "stored-staff-token" });
    await store.restoreSession();

    expect(store.isAuthenticated).toBe(true);
    expect(store.isOwner).toBe(false); // Staff is not owner
    expect(store.isManager).toBe(false); // Staff is not manager
    expect(store.salonName).toBe("Mon Salon");
    expect(store.initialized).toBe(true);
  });

  it("clears session for non-pro roles", async () => {
    fetchProCurrentUser.mockResolvedValue({
      id: "user-client",
      fullName: "Client User",
      email: "client@test.local",
      phone: "+221771234569",
      role: "client",
      salonId: null,
      city: "Dakar",
      avatarUrl: null,
      preferredContactChannel: "whatsapp",
      pushOptIn: true,
      marketingOptIn: false,
      preferredLanguage: "fr"
    });

    const store = useProAuthStore();
    store.$patch({ accessToken: "client-token" });
    await store.restoreSession();

    expect(store.isAuthenticated).toBe(false);
    expect(store.currentUser).toBeNull();
    expect(store.initialized).toBe(true);
  });

  it("logs in and persists the received token", async () => {
    loginPro.mockResolvedValue({
      accessToken: "fresh-token",
      refreshToken: "refresh-token",
      expiresInSeconds: 900
    });
    fetchProCurrentUser.mockResolvedValue({
      id: "user-pro",
      fullName: "Salon Owner",
      email: "owner@salon.local",
      phone: "+221771234567",
      role: "salon_owner",
      salonId: "salon-1",
      city: "Dakar",
      avatarUrl: null,
      preferredContactChannel: "whatsapp",
      pushOptIn: true,
      marketingOptIn: false,
      preferredLanguage: "fr"
    });
    fetchProSalon.mockResolvedValue({
      id: "salon-1",
      name: "Mon Salon",
      approvalStatus: "approved",
      city: "Dakar",
      neighborhood: "Point E"
    });

    const store = useProAuthStore();
    await store.login("owner@salon.local", "supersecure");

    expect(loginPro).toHaveBeenCalledWith({
      email: "owner@salon.local",
      password: "supersecure"
    });
    expect(store.accessToken).toBe("fresh-token");
    expect(store.refreshToken).toBe("refresh-token");
    expect(store.isAuthenticated).toBe(true);
    expect(store.isOwner).toBe(true);
  });

  it("clears the session on logout", async () => {
    logoutPro.mockResolvedValue({ revoked: true });

    const store = useProAuthStore();
    store.$patch({
      accessToken: "fresh-token",
      refreshToken: "refresh-token",
      currentUser: {
        id: "user-pro",
        fullName: "Salon Owner",
        email: "owner@salon.local",
        phone: "+221771234567",
        role: "salon_owner",
        salonId: "salon-1",
        city: "Dakar",
        avatarUrl: null,
        preferredContactChannel: "whatsapp",
        pushOptIn: true,
        marketingOptIn: false,
        preferredLanguage: "fr"
      } as any,
      salonName: "Mon Salon",
      initialized: true
    });

    await store.logout();

    expect(logoutPro).toHaveBeenCalledWith("fresh-token", "refresh-token");
    expect(store.accessToken).toBeNull();
    expect(store.isAuthenticated).toBe(false);
    expect(store.currentUser).toBeNull();
    expect(store.salonName).toBeNull();
  });

  it("refreshes session when refreshPossible returns valid tokens", async () => {
    refreshProSession.mockResolvedValue({
      accessToken: "refreshed-token",
      refreshToken: "new-refresh-token",
      expiresInSeconds: 900
    });

    const store = useProAuthStore();
    store.$patch({
      accessToken: "stale-token",
      refreshToken: "stale-refresh"
    });

    const result = await store.refreshSessionIfPossible();

    expect(result).toBe(true);
    expect(store.accessToken).toBe("refreshed-token");
    expect(store.refreshToken).toBe("new-refresh-token");
  });

  it("refresh fails when no refresh token is available", async () => {
    const store = useProAuthStore();
    const result = await store.refreshSessionIfPossible();
    expect(result).toBe(false);
  });
});
