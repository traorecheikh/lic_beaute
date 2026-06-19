import type {
  ProClientSummary,
  ProClientBenefitCreateInput
} from "@/lib/generated";
import {
  getProApi,
  resolveAccessToken,
  withApiError,
  getProBaseUrl
} from "./shared";

export async function fetchProClients(token: string, search?: string, page = 0, pageSize = 20) {
  const params = new URLSearchParams();
  if (search) params.set("search", search);
  params.set("page", String(page));
  params.set("pageSize", String(pageSize));
  const apiBaseUrl = getProBaseUrl();
  const resp = await fetch(`${apiBaseUrl}/api/v1/pro/clients?${params}`, {
    headers: { Authorization: `Bearer ${resolveAccessToken(token) ?? token}` }
  });
  if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
  return resp.json() as Promise<{ items: ProClientSummary[]; total: number; page: number; pageSize: number }>;
}

export async function fetchProClient(token: string, clientId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProClientsClientIdGet({ clientId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProClientsClientIdGet({ clientId })
  );
}

export async function createClientBenefit(token: string, payload: ProClientBenefitCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProClientsBenefitsPost({ proClientBenefitCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProClientsBenefitsPost({ proClientBenefitCreateInput: payload })
  );
}
