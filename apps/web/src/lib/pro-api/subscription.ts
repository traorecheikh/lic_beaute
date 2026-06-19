import type {
  ProSubscriptionUpdateInput,
  ProSubscriptionCheckoutInput,
  ProSubscriptionExecuteInput
} from "@/lib/generated";
import {
  getProApi,
  resolveAccessToken,
  withApiError,
  fetchWithProAuth,
  fetchProAuthResponse
} from "./shared";

export async function fetchProSubscription(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionGet()
  );
}

export async function fetchProSubscriptionFeatures(token: string): Promise<{
  billingProviders?: { paydunya?: boolean; manual?: boolean };
  planTiers?: Array<{ tier: "standard" | "premium"; label: string; priceLabel: string; priceXof?: number; features?: Array<{ label: string; included: boolean }> }>;
}> {
  return fetchWithProAuth("/api/v1/pro/subscription/features", {
    method: "GET",
    headers: { Accept: "application/json" }
  }, token);
}

export async function updateProSubscription(token: string, payload: ProSubscriptionUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionPatch({ proSubscriptionUpdateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionPatch({ proSubscriptionUpdateInput: payload })
  );
}

export async function checkoutProSubscription(token: string, payload: ProSubscriptionCheckoutInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionCheckoutPost({ proSubscriptionCheckoutInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionCheckoutPost({ proSubscriptionCheckoutInput: payload })
  );
}

export async function executeProSubscription(token: string, chargeId: string, payload: ProSubscriptionExecuteInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionChargeChargeIdExecutePost({ chargeId, proSubscriptionExecuteInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionChargeChargeIdExecutePost({ chargeId, proSubscriptionExecuteInput: payload })
  );
}

export async function cancelProSubscription(token: string, body?: { reason: string; additionalInfo?: string }): Promise<{ ok: boolean }> {
  return fetchWithProAuth<{ ok: boolean }>("/api/v1/pro/subscription/cancel", {
    method: "POST",
    body: body ? JSON.stringify(body) : undefined
  }, token);
}

export async function retainProSubscription(token: string): Promise<{ ok: boolean }> {
  return fetchWithProAuth<{ ok: boolean }>("/api/v1/pro/subscription/retain", {
    method: "POST"
  }, token);
}

export async function fetchProSubscriptionChargeStatus(token: string, chargeId: string): Promise<{ status?: string; subscriptionStatus?: string }> {
  return fetchWithProAuth<{ status?: string; subscriptionStatus?: string }>(`/api/v1/pro/subscription/charge/${chargeId}/status`, {
    method: "GET",
    headers: { Accept: "application/json" }
  }, token);
}

// ─── Invoices ─────────────────────────────────────────────────────────────────

export async function fetchProInvoices(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProInvoicesGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProInvoicesGet()
  );
}

export async function downloadProInvoicePdf(token: string, invoiceId: string) {
  const response = await fetchProAuthResponse(`/api/v1/pro/invoices/${invoiceId}/pdf`, {
    method: "GET"
  }, token);
  return response.blob();
}
