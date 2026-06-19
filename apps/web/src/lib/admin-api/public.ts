import { ApiError, request } from "./shared";
import { getAdminBaseUrl } from "./shared";

export async function fetchPublicRegistrationDocs(): Promise<{ id: string; label: string; description?: string }[]> {
  return request<{ id: string; label: string; description?: string }[]>("/api/v1/platform/registration-docs", { method: "GET" });
}

export async function fetchPublicCategories(): Promise<{ id: string; name: string }[]> {
  return request<{ id: string; name: string }[]>("/api/v1/platform/categories", { method: "GET" });
}

export async function fetchPublicServiceSuggestions(): Promise<{ id: string; name: string; category: string }[]> {
  return request<{ id: string; name: string; category: string }[]>("/api/v1/platform/service-suggestions", { method: "GET" });
}

export async function checkPublicUniqueness(fields: { email?: string; phone?: string; name?: string }): Promise<{ email?: "available" | "taken"; phone?: "available" | "taken"; name?: "available" | "taken" }> {
  const params = new URLSearchParams();
  if (fields.email) params.set("email", fields.email);
  if (fields.phone) params.set("phone", fields.phone);
  if (fields.name) params.set("name", fields.name);
  const qs = params.toString();
  return request<{ email?: "available" | "taken"; phone?: "available" | "taken"; name?: "available" | "taken" }>(
    `/api/v1/platform/check-uniqueness${qs ? `?${qs}` : ""}`,
    { method: "GET" }
  );
}

export async function uploadRegistrationDoc(file: File): Promise<{ url: string }> {
  const formData = new FormData();
  formData.append("file", file);
  const apiBaseUrl = getAdminBaseUrl();
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
