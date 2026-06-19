import { authHeaders, request } from "./shared";
import type {
  AdminSubscriptionDetail,
  AdminSubscriptionOverrideInput,
  AdminManualExtendInput,
  AdminManualExtendResponse,
  AdminSubscriptionSummary
} from "@beauteavenue/contracts";

type AdminSubscriptionListResponse = {
  summary: {
    premiumCount: number;
    standardCount: number;
    pausedCount: number;
  };
  items: AdminSubscriptionSummary[];
  total: number;
};

export async function fetchSubscriptions(token: string, query: Record<string, string | undefined>) {
  return request<AdminSubscriptionListResponse>(
    "/api/v1/admin/subscriptions",
    { headers: authHeaders(token) },
    query
  );
}

export async function fetchSubscriptionDetail(token: string, subscriptionId: string) {
  return request<AdminSubscriptionDetail>(`/api/v1/admin/subscriptions/${subscriptionId}`, {
    headers: authHeaders(token)
  });
}

export async function overrideSubscription(token: string, subscriptionId: string, payload: AdminSubscriptionOverrideInput) {
  return request<AdminSubscriptionDetail>(`/api/v1/admin/subscriptions/${subscriptionId}/override`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify(payload)
  });
}

export async function manualExtendSubscription(token: string, subscriptionId: string, payload: AdminManualExtendInput) {
  return request<AdminManualExtendResponse>(`/api/v1/admin/subscriptions/${subscriptionId}/manual-extend`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify(payload)
  });
}
