/* @vitest-environment jsdom */

import { beforeEach, describe, expect, it } from "vitest";
import { createPinia, setActivePinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";

import { useAdminAuthStore } from "@/stores/adminAuth";
import router from "./index";

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

describe("router", () => {
  beforeEach(async () => {
    installLocalStorage();
    setActivePinia(createTestingPinia());
    await router.push("/");
  });

  it("registers admin dashboard route", () => {
    const route = router.resolve("/admin/dashboard");

    expect(route.matched.length).toBeGreaterThan(0);
    expect(route.fullPath).toBe("/admin/dashboard");
  });

  it("registers admin login and detail routes", () => {
    expect(router.resolve("/admin/login").name).toBe("admin-login");
    expect(router.resolve("/admin/salons/salon-maison-kinka").name).toBe("admin-salon-detail");
    expect(router.resolve("/admin/subscriptions/sub-dione-signature").name).toBe(
      "admin-subscription-detail"
    );
    expect(router.resolve("/admin/audit/audit-wave-1").name).toBe("admin-audit-detail");
  });

  it("redirects unauthenticated admin access to login", async () => {
    await router.push("/admin/dashboard");

    expect(router.currentRoute.value.name).toBe("admin-login");
    expect(router.currentRoute.value.query.redirect).toBe("/admin/dashboard");
  });

  it("redirects authenticated admins away from login", async () => {
    const auth = useAdminAuthStore();
    auth.$patch({
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

    await router.push("/admin/login");

    expect(router.currentRoute.value.name).toBe("admin-dashboard");
  });
});
