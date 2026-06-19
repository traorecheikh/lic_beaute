import { authHeaders, request } from "./shared";
import type {
  PlatformSetting,
  PlatformSalonCategory,
  PlatformRequiredDocument,
  PlatformServiceSuggestion,
  UpsertSalonCategoryInput,
  UpsertRequiredDocumentInput,
  UpsertPlatformServiceSuggestionInput
} from "@beauteavenue/contracts";

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

export async function fetchPlatformServiceSuggestions(token: string) {
  return request<PlatformServiceSuggestion[]>(`/api/v1/admin/config/service-suggestions`, {
    headers: authHeaders(token)
  });
}

export async function upsertPlatformServiceSuggestion(token: string, data: UpsertPlatformServiceSuggestionInput) {
  return request<PlatformServiceSuggestion>(`/api/v1/admin/config/service-suggestions`, {
    method: "POST",
    headers: authHeaders(token),
    body: JSON.stringify(data)
  });
}

export async function deletePlatformServiceSuggestion(token: string, id: string) {
  return request<void>(`/api/v1/admin/config/service-suggestions/${id}`, {
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
