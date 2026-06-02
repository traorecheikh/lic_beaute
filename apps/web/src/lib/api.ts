import type {
  AdminAuditDetail,
  AdminAuditSummary,
  AdminDashboard,
  AdminManualExtendInput,
  AdminManualExtendResponse,
  AdminSalonDecisionInput,
  AdminSalonDetail,
  AdminSalonQueueItem,
  AdminSubscriptionDetail,
  AdminSubscriptionOverrideInput,
  AdminSubscriptionSummary,
  AdminSalonCreateInput,
  CurrentUser,
  PlatformRequiredDocument,
  PlatformSalonCategory,
  PlatformSetting,
  UpsertRequiredDocumentInput,
  UpsertSalonCategoryInput
} from "@beauteavenue/contracts";
import { resolveApiBaseUrl } from "./api-base";

type PaginatedResponse<T> = {
  items: T[];
  total: number;
};

export type EmailAuditItem = {
  id: string;
  to: string;
  subject: string;
  driver: string;
  status: string;
  errorMessage: string | null;
  createdAt: string;
};

type AdminSubscriptionListResponse = {
  summary: {
    premiumCount: number;
    standardCount: number;
    pausedCount: number;
  };
  items: AdminSubscriptionSummary[];
  total: number;
};

type LoginPayload = {
  email: string;
  password: string;
};

type AuthSession = {
  accessToken: string;
  refreshToken: string;
  expiresInSeconds: number;
};

export class ApiError extends Error {
  readonly field: string | undefined;
  constructor(
    readonly statusCode: number,
    readonly code: string,
    message: string,
    field?: string
  ) {
    super(message);
    this.field = field;
  }
}

const apiBaseUrl = resolveApiBaseUrl();

function buildUrl(path: string, query?: Record<string, string | undefined>) {
  const url = new URL(path, apiBaseUrl);

  if (query) {
    for (const [key, value] of Object.entries(query)) {
      if (value) {
        url.searchParams.set(key, value);
      }
    }
  }

  return url.toString();
}

async function request<T>(path: string, options: RequestInit = {}, query?: Record<string, string | undefined>) {
  const response = await fetch(buildUrl(path, query), {
    ...options,
    headers: {
      ...(options.body != null ? { "Content-Type": "application/json" } : {}),
      ...(options.headers ?? {})
    }
  });

  if (!response.ok) {
    const fallback = { code: "unknown_error", message: "Une erreur est survenue." };
    const payload = (await response.json().catch(() => fallback)) as { code?: string; message?: string; field?: string };
    throw new ApiError(response.status, payload.code ?? fallback.code, payload.message ?? fallback.message, payload.field);
  }

  return (await response.json()) as T;
}

function authHeaders(token: string) {
  return {
    authorization: `Bearer ${token}`
  };
}

export async function loginAdmin(payload: LoginPayload) {
  return request<AuthSession>("/api/v1/auth/login", {
    method: "POST",
    body: JSON.stringify(payload)
  });
}

export async function fetchCurrentUser(token: string) {
  return request<CurrentUser>("/api/v1/me", {
    headers: authHeaders(token)
  });
}

export async function logoutAdmin(token: string, refreshToken?: string) {
  return request<{ revoked: boolean }>("/api/v1/auth/logout", {
    method: "POST",
    headers: authHeaders(token),
    body: refreshToken ? JSON.stringify({ refreshToken }) : undefined
  });
}

export async function refreshAdminSession(refreshToken: string) {
  return request<AuthSession>("/api/v1/auth/refresh", {
    method: "POST",
    body: JSON.stringify({ refreshToken })
  });
}

export async function fetchAdminDashboard(token: string) {
  return request<AdminDashboard>("/api/v1/admin/dashboard", {
    headers: authHeaders(token)
  });
}

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

export async function fetchAuditEvents(token: string, query: Record<string, string | undefined>) {
  return request<PaginatedResponse<AdminAuditSummary>>(
    "/api/v1/admin/audit",
    { headers: authHeaders(token) },
    query
  );
}

export async function fetchAuditDetail(token: string, auditId: string) {
  return request<AdminAuditDetail>(`/api/v1/admin/audit/${auditId}`, {
    headers: authHeaders(token)
  });
}

export async function fetchEmailAuditEvents(token: string, query: Record<string, string | undefined>) {
  return request<PaginatedResponse<EmailAuditItem>>(
    "/api/v1/admin/audit/email",
    { headers: authHeaders(token) },
    query
  );
}

// ─── Configuration ────────────────────────────────────────────────────────────

type PublicPricing = {
  standard: { tier: string; priceXof: number; label: string };
  premium: { tier: string; priceXof: number; label: string };
  commissionPercent: number;
};

export async function fetchPublicPricing() {
  return request<PublicPricing>("/api/v1/config/pricing");
}

export async function fetchPlatformSettings(token: string, group?: string) {
  return request<PlatformSetting[]>(`/api/v1/admin/config/settings`, {
    headers: authHeaders(token)
  }, { group });
}

export async function updatePlatformSetting(token: string, key: string, value: string) {
  return request<PlatformSetting>(`/api/v1/admin/config/settings/${key}`, {
    method: "PATCH",
    headers: authHeaders(token),
    body: JSON.stringify({ value })
  });
}

export async function fetchPlatformCategories(token: string) {
  return request<PlatformSalonCategory[]>(`/api/v1/admin/config/categories`, {
    headers: authHeaders(token)
  });
}

export async function upsertPlatformCategory(token: string, data: UpsertSalonCategoryInput) {
  return request<PlatformSalonCategory>(`/api/v1/admin/config/categories`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify(data)
  });
}

export async function deletePlatformCategory(token: string, id: string) {
  return request<void>(`/api/v1/admin/config/categories/${id}`, {
    method: "DELETE",
    headers: authHeaders(token)
  });
}

export async function fetchPlatformRequiredDocuments(token: string) {
  return request<PlatformRequiredDocument[]>(`/api/v1/admin/config/documents`, {
    headers: authHeaders(token)
  });
}

export async function upsertPlatformRequiredDocument(token: string, data: UpsertRequiredDocumentInput) {
  return request<PlatformRequiredDocument>(`/api/v1/admin/config/documents`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify(data)
  });
}

export async function deletePlatformRequiredDocument(token: string, id: string) {
  return request<void>(`/api/v1/admin/config/documents/${id}`, {
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

export async function fetchPublicRegistrationDocs(): Promise<{ id: string; label: string; description?: string }[]> {
  return request<{ id: string; label: string; description?: string }[]>("/api/v1/platform/registration-docs", { method: "GET" });
}

export async function fetchPublicCategories(): Promise<{ id: string; name: string }[]> {
  return request<{ id: string; name: string }[]>("/api/v1/platform/categories", { method: "GET" });
}

export async function uploadRegistrationDoc(file: File): Promise<{ url: string }> {
  const formData = new FormData();
  formData.append("file", file);
  const response = await fetch(`${apiBaseUrl}/api/v1/auth/upload-registration-doc`, {
    method: "POST",
    body: formData
  });
  if (!response.ok) {
    const payload = await response.json().catch(() => ({})) as { message?: string };
    throw new ApiError(response.status, "upload_failed", payload.message ?? "Téléversement impossible.");
  }
  return response.json() as Promise<{ url: string }>;
}

export async function changePassword(token: string, currentPassword: string, newPassword: string) {
  return request<CurrentUser>("/api/v1/me", {
    method: "PATCH",
    headers: authHeaders(token),
    body: JSON.stringify({ currentPassword, newPassword })
  });
}
