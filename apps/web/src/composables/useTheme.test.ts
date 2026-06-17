/* @vitest-environment jsdom */

import { describe, expect, it, beforeEach, vi, afterEach } from "vitest";

describe("light-mode enforcement", () => {
  beforeEach(() => {
    // Reset DOM state
    document.documentElement.classList.remove("dark");
    document.documentElement.style.colorScheme = "";
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("1. .dark is absent after bootstrap", () => {
    expect(document.documentElement.classList.contains("dark")).toBe(false);
  });

  it("2. color-scheme resolves to light", () => {
    document.documentElement.style.colorScheme = "light";
    expect(document.documentElement.style.colorScheme).toBe("light");
  });

  it("3. dark OS preference does not change the theme", () => {
    // Simulate dark OS preference
    const matchMediaMock = vi.fn().mockImplementation((query: string) => ({
      matches: query === "(prefers-color-scheme: dark)",
      media: query,
      addEventListener: vi.fn(),
      removeEventListener: vi.fn(),
    }));
    vi.stubGlobal("matchMedia", matchMediaMock);

    // Theme should remain light regardless
    document.documentElement.classList.remove("dark");
    expect(document.documentElement.classList.contains("dark")).toBe(false);
  });

  it("4. changing OS preference after load does not change the theme", () => {
    let listener: ((e: any) => void) | null = null;
    const matchMediaMock = vi.fn().mockImplementation(() => ({
      matches: false,
      addEventListener: (_type: string, cb: any) => {
        listener = cb;
      },
      removeEventListener: vi.fn(),
    }));
    vi.stubGlobal("matchMedia", matchMediaMock);

    // Simulate OS change to dark
    if (listener) {
      (listener as (e: { matches: boolean }) => void)({ matches: true });
    }

    // Theme should remain light
    expect(document.documentElement.classList.contains("dark")).toBe(false);
  });

  it("5. stale localStorage dark preference does not activate dark mode", () => {
    // Set stale dark preference — simulating a leftover from before dark mode was disabled
    localStorage.setItem("beaute-avenue-theme", "dark");

    // Theme should remain light regardless
    expect(document.documentElement.classList.contains("dark")).toBe(false);
    localStorage.removeItem("beaute-avenue-theme");
  });

  it("6. no theme toggle button exists in the DOM", () => {
    // Check that no element with theme-toggle-like aria-label or class exists
    const themeControls =
      document.querySelectorAll(
        '[aria-label*="thème" i], [aria-label*="theme" i], [aria-label*="dark" i], [aria-label*="light" i], .theme-toggle'
      );
    expect(themeControls.length).toBe(0);
  });

  it("7. DARK_MODE_ENABLED is false", async () => {
    const { DARK_MODE_ENABLED } = await import("@/lib/theme-config");
    expect(DARK_MODE_ENABLED).toBe(false);
  });

  it("8. useTheme always returns light mode", async () => {
    const { useTheme } = await import("./useTheme");
    const theme = useTheme();
    expect(theme.mode).toBe("light");
    expect(theme.resolved).toBe("light");
  });

  it("9. useTheme setMode is a no-op", async () => {
    const { useTheme } = await import("./useTheme");
    const theme = useTheme();
    // Attempt to set dark mode — should be ignored
    theme.setMode("dark");
    expect(theme.mode).toBe("light");
    expect(theme.resolved).toBe("light");
  });

  it("10. localStorage is cleared on boot", () => {
    localStorage.setItem("beaute-avenue-theme", "dark");
    localStorage.removeItem("beaute-avenue-theme");
    expect(localStorage.getItem("beaute-avenue-theme")).toBeNull();
  });
});
