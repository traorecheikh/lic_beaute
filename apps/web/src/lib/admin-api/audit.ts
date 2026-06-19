import { authHeaders, request } from "./shared";
import type { AdminAuditSummary, AdminAuditDetail } from "@beauteavenue/contracts";

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
