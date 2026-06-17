/* @vitest-environment jsdom */

import { beforeEach, describe, expect, it } from "vitest";
import { createPinia, setActivePinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";

import { useAdminAuthStore } from "@/stores/adminAuth";
import { useProAuthStore } from "@/stores/proAuth";
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

  it("registers public privacy and terms routes", () => {
    expect(router.resolve("/privacy").name).toBe("privacy");
    expect(router.resolve("/terms").name).toBe("terms");
  });

  it("redirects unauthenticated admin access to login", async () => {
    await router.push("/admin/dashboard");

    expect(router.currentRoute.value.name).toBe("admin-login");
    expect(router.currentRoute.value.query.redirect).toBe("/admin/dashboard");
    expect(router.currentRoute.value.query.expired).toBeUndefined();
  });

  it("marks admin redirect as expired when a token was present", async () => {
    const auth = useAdminAuthStore();
    auth.$patch({ accessToken: "stale-admin-token", initialized: true, currentUser: null, refreshToken: null });

    await router.push("/admin/dashboard");

    expect(router.currentRoute.value.name).toBe("admin-login");
    expect(router.currentRoute.value.query.redirect).toBe("/admin/dashboard");
    expect(router.currentRoute.value.query.expired).toBe("1");
  });

  it("redirects unauthenticated pro access to pro login", async () => {
    await router.push("/pro/calendar");

    expect(router.currentRoute.value.name).toBe("pro-login");
    expect(router.currentRoute.value.query.redirect).toBe("/pro/calendar");
    expect(router.currentRoute.value.query.expired).toBeUndefined();
  });

  it("marks pro redirect as expired when a token was present", async () => {
    const auth = useProAuthStore();
    auth.$patch({ accessToken: "stale-pro-token", initialized: true, currentUser: null, refreshToken: null, salonName: null });

    await router.push("/pro/calendar");

    expect(router.currentRoute.value.name).toBe("pro-login");
    expect(router.currentRoute.value.query.redirect).toBe("/pro/calendar");
    expect(router.currentRoute.value.query.expired).toBe("1");
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
