export const appName = "Beauté Avenue";
export const apiPrefix = "/api/v1";

export const bookingStatuses = [
  "pending",
  "confirmed",
  "in_progress",
  "completed",
  "cancelled"
] as const;

export const paymentProviders = ["paytech"] as const;

export function formatMoneyXof(amount: number) {
  return new Intl.NumberFormat("fr-SN", {
    style: "currency",
    currency: "XOF",
    maximumFractionDigits: 0
  }).format(amount);
}
