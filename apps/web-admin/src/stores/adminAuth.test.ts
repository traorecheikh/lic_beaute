/* @vitest-environment jsdom */

import { beforeEach, describe, expect, it, vi } from "vitest";
import { createPinia, setActivePinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";

import { useAdminAuthStore } from "./adminAuth";

const { fetchCurrentUser, loginAdmin, logoutAdmin } = vi.hoisted(() => ({
  fetchCurrentUser: vi.fn(),
  loginAdmin: vi.fn(),
  logoutAdmin: vi.fn()
}));

vi.mock("@/lib/api", () => ({
  fetchCurrentUser,
  loginAdmin,
  logoutAdmin
}));

function installLocalStorage() {
  const storage = new Map<string, string>();
  const localStorageMock = {
    getItem: (key: string) => storage.get(key) ?? null,
    setItem: (key: string, value: string) => {
      storage.set(key, String(value));
    },
    removeItem: (key: string) => {
      storage.delete(key);
    },
    clear: () => {
      storage.clear();
    }
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

describe("admin auth store", () => {
  beforeEach(() => {
    installLocalStorage();
    setActivePinia(createTestingPinia());
    fetchCurrentUser.mockReset();
    loginAdmin.mockReset();
    logoutAdmin.mockReset();
  });

  it("restores an existing admin session", async () => {
    fetchCurrentUser.mockResolvedValue({
      id: "user-admin",
      fullName: "Platform Admin",
      email: "admin@beauteavenue.local",
      phone: null,
      role: "platform_admin"
    });

    const store = useAdminAuthStore();
    store.$patch({ accessToken: "stored-token" });
    await store.restoreSession();

    expect(fetchCurrentUser).toHaveBeenCalledWith("stored-token");
    expect(store.isAuthenticated).toBe(true);
    expect(store.currentUser?.role).toBe("platform_admin");
    expect(store.initialized).toBe(true);
  });

  it("logs in and persists the received token", async () => {
    loginAdmin.mockResolvedValue({
      accessToken: "fresh-token",
      refreshToken: "refresh-token",
      expiresInSeconds: 900
    });
    fetchCurrentUser.mockResolvedValue({
      id: "user-admin",
      fullName: "Platform Admin",
      email: "admin@beauteavenue.local",
      phone: null,
      role: "platform_admin"
    });

    const store = useAdminAuthStore();
    await store.login("admin@beauteavenue.local", "supersecure");

    expect(loginAdmin).toHaveBeenCalledWith({
      email: "admin@beauteavenue.local",
      password: "supersecure"
    });
    expect(store.accessToken).toBe("fresh-token");
    expect(store.isAuthenticated).toBe(true);
  });

  it("clears the session on logout", async () => {
    logoutAdmin.mockResolvedValue({ revoked: true });

    const store = useAdminAuthStore();
    store.$patch({
      accessToken: "fresh-token",
      currentUser: {
        id: "user-admin",
        fullName: "Platform Admin",
        email: "admin@beauteavenue.local",
        phone: null,
        role: "platform_admin"
      },
      initialized: true
    });

    await store.logout();

    expect(logoutAdmin).toHaveBeenCalledWith("fresh-token");
    expect(store.accessToken).toBeNull();
    expect(store.isAuthenticated).toBe(false);
    expect(store.currentUser).toBeNull();
  });
});
