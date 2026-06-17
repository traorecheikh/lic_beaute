/**
 * ═══════════════════════════════════════════════════════════════
 * Theme composable — LIGHT MODE ONLY
 * ═══════════════════════════════════════════════════════════════
 *
 * Dark mode is intentionally disabled during the current test phase.
 * This composable always returns `light` regardless of OS preference
 * or stored user preference.
 *
 * Do NOT re-enable OS detection or expose a toggle until the full
 * application-wide audit is complete (see docs/ui/dark-mode-status.md).
 */

export type ThemeMode = "light" | "dark" | "system";

export function useTheme() {
  return {
    mode: "light" as const,
    resolved: "light" as const,
    setMode: (_mode: ThemeMode) => {
      // No-op: dark mode disabled
    },
    cycleMode: () => {
      // No-op: dark mode disabled
    }
  };
}
