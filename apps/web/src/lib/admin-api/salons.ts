import { authHeaders, request } from "./shared";
import type {
  AdminSalonQueueItem,
  AdminSalonDetail,
  AdminSalonCreateInput,
  AdminSalonDecisionInput,
  ProService,
  ProServiceCreateInput,
  ProServiceUpdateInput
} from "@beauteavenue/contracts";

type PaginatedResponse<T> = {
  items: T[];
  total: number;
};

export async function fetchPendingSalons(
  token: string,
  query: Record<string, string | undefined>
) {
  return request<PaginatedResponse<AdminSalonQueueItem>>(
    "/api/v1/admin/salons/pending",
    { headers: authHeaders(token) },
    query
  );
}

export async function fetchSalons(
  token: string,
  query: Record<string, string | undefined>
) {
  return request<PaginatedResponse<AdminSalonQueueItem>>(
    "/api/v1/admin/salons",
    { headers: authHeaders(token) },
    query
  );
}

export async function fetchSalonDetail(token: string, salonId: string) {
  return request<AdminSalonDetail>(`/api/v1/admin/salons/${salonId}`, {
    headers: authHeaders(token)
  });
}

export async function createSalon(token: string, data: AdminSalonCreateInput) {
  return request<AdminSalonDetail>("/api/v1/admin/salons", {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify(data)
  });
}

export async function checkSalonUniqueness(token: string, fields: { email?: string; phone?: string }) {
  const params = new URLSearchParams();
  if (fields.email) params.set("email", fields.email);
  if (fields.phone) params.set("phone", fields.phone);
  return request<{ email?: "available" | "taken"; phone?: "available" | "taken" }>(
    `/api/v1/admin/salons/check-uniqueness?${params.toString()}`,
    { headers: authHeaders(token) }
  );
}

async function mutateSalonDecision(token: string, salonId: string, action: "approve" | "reject" | "request-info", payload?: AdminSalonDecisionInput) {
  return request<AdminSalonDetail>(`/api/v1/admin/salons/${salonId}/${action}`, {
    method: "POST",
    headers: authHeaders(token),
    body: payload ? JSON.stringify(payload) : undefined
  });
}

export function approveSalonRequest(token: string, salonId: string) {
  return mutateSalonDecision(token, salonId, "approve");
}

export function rejectSalonRequest(token: string, salonId: string, payload: AdminSalonDecisionInput) {
  return mutateSalonDecision(token, salonId, "reject", payload);
}

export function requestSalonInfo(token: string, salonId: string, payload: AdminSalonDecisionInput) {
  return mutateSalonDecision(token, salonId, "request-info", payload);
}

export async function fetchAdminSalonServices(token: string, salonId: string) {
  return request<ProService[]>(`/api/v1/admin/salons/${salonId}/services`, {
    headers: authHeaders(token)
  });
}

export async function createAdminSalonService(token: string, salonId: string, payload: ProServiceCreateInput) {
  return request<ProService>(`/api/v1/admin/salons/${salonId}/services`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify(payload)
  });
}

export async function updateAdminSalonService(token: string, salonId: string, serviceId: string, payload: ProServiceUpdateInput) {
  return request<ProService>(`/api/v1/admin/salons/${salonId}/services/${serviceId}`, {
    method: "PATCH",
    headers: authHeaders(token),
    body: JSON.stringify(payload)
  });
}

export async function deleteAdminSalonService(token: string, salonId: string, serviceId: string) {
  return request<{ deleted: boolean }>(`/api/v1/admin/salons/${salonId}/services/${serviceId}`, {
    method: "DELETE",
    headers: authHeaders(token)
  });
}

export async function sendPasswordReset(token: string, salonId: string) {
  return request<{ sent: boolean }>(`/api/v1/admin/salons/${salonId}/send-password-reset`, {
    method: "POST",
    headers: authHeaders(token)
  });
}

export async function sendMagicLink(token: string, salonId: string) {
  return request<{ sent: boolean }>(`/api/v1/admin/salons/${salonId}/send-magic-link`, {
    method: "POST",
    headers: authHeaders(token)
  });
}

export async function verifySalonPayoutSettings(token: string, salonId: string, status: "verified" | "rejected") {
  return request<any>(`/api/v1/admin/salons/${salonId}/payout-settings/verify`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify({ status })
  });
}
