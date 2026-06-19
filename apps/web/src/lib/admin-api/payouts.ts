import { authHeaders, request } from "./shared";

export type AdminPayoutVerificationQueueItem = {
  salonId: string;
  salonName: string;
  city: string;
  ownerUserId: string | null;
  ownerName: string;
  ownerEmail: string | null;
  payoutMethod: "wave_senegal" | "orange_money_senegal" | null;
  payoutPhoneMasked: string | null;
  payoutName: string | null;
  payoutVerificationStatus: "unverified" | "rejected" | "verified";
  payoutVerifiedAt: string | null;
  updatedAt: string;
  blockedPayoutCount: number;
  blockedForVerificationCount: number;
  totalPayoutCount: number;
};

export async function fetchAdminMerchantPayouts(token: string, filters?: { salonId?: string; status?: string; page?: number; limit?: number }) {
  const params = new URLSearchParams();
  if (filters?.salonId) params.set("salonId", filters.salonId);
  if (filters?.status) params.set("status", filters.status);
  if (filters?.page !== undefined) params.set("page", filters.page.toString());
  if (filters?.limit !== undefined) params.set("limit", filters.limit.toString());
  const qs = params.toString();
  return request<any[]>(`/api/v1/admin/payouts${qs ? `?${qs}` : ""}`, {
    headers: authHeaders(token)
  });
}

export async function fetchAdminPayoutVerificationQueue(
  token: string,
  filters?: { search?: string; status?: "unverified" | "rejected" | "all" }
) {
  const params = new URLSearchParams();
  if (filters?.search) params.set("search", filters.search);
  if (filters?.status) params.set("status", filters.status);
  const qs = params.toString();
  return request<AdminPayoutVerificationQueueItem[]>(
    `/api/v1/admin/payouts/verification-queue${qs ? `?${qs}` : ""}`,
    {
      headers: authHeaders(token)
    }
  );
}

export async function fetchAdminMerchantPayoutDetail(token: string, payoutId: string) {
  return request<any>(`/api/v1/admin/payouts/${payoutId}`, {
    headers: authHeaders(token)
  });
}

export async function reconcileAdminPayout(token: string, payoutId: string) {
  return request<any>(`/api/v1/admin/payouts/${payoutId}/reconcile`, {
    method: "POST",
    headers: authHeaders(token)
  });
}

export async function retryAdminPayout(token: string, payoutId: string, reason: string) {
  return request<any>(`/api/v1/admin/payouts/${payoutId}/retry`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify({ reason })
  });
}

export async function approveAdminPayout(token: string, payoutId: string, reason: string) {
  return request<any>(`/api/v1/admin/payouts/${payoutId}/approve`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify({ reason })
  });
}

export async function cancelAdminPayout(token: string, payoutId: string, reason: string) {
  return request<any>(`/api/v1/admin/payouts/${payoutId}/cancel`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify({ reason })
  });
}
