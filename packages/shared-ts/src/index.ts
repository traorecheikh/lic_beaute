export const appName = "Beauté Avenue";
export const apiPrefix = "/api/v1";

export const bookingStatuses = [
  "pending",
  "confirmed",
  "in_progress",
  "completed",
  "cancelled"
] as const;

export const paymentProviders = ["paydunya"] as const;

export function formatMoneyXof(amount: number) {
  return new Intl.NumberFormat("fr-SN", {
    style: "currency",
    currency: "XOF",
    maximumFractionDigits: 0
  }).format(amount);
}

export { validateForm } from "./validate-form.js";
export type { FieldErrors, ValidationResult } from "./validate-form.js";
export { SERVICE_CATEGORY_MAP } from "./services.js";
export { legalConfig } from "./legal-config.js";
export type { LegalConfig } from "./legal-config.js";
