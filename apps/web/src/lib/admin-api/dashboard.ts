import { authHeaders, request } from "./shared";

export async function fetchAdminDashboard(token: string) {
  return request<{
    totalSalons: number;
    pendingSalons: number;
    activeSubscriptions: number;
    revenueXof: number;
    [key: string]: unknown;
  }>("/api/v1/admin/dashboard", {
    headers: authHeaders(token)
  });
}

export async function fetchCancellationStats(token: string) {
  return request<{
    totalCancelled: number;
    retainedCount: number;
    items: Array<{ reason: string; count: number; percent: number; label: string; emoji: string }>;
  }>("/api/v1/admin/subscriptions/cancellation-stats", {
    headers: authHeaders(token)
  });
}
