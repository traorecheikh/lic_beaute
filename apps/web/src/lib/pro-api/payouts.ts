import {
  withApiError,
  fetchWithProAuth,
  getProApi,
  resolveAccessToken,
  getProBaseUrl,
  ApiError
} from "./shared";

export async function fetchProPayouts(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProPayoutsGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProPayoutsGet()
  );
}

export async function fetchProPayoutSettings(token: string): Promise<{
  payoutMethod: "wave_senegal" | "orange_money_senegal" | null;
  payoutPhone: string | null;
  payoutName: string | null;
  payoutVerificationStatus: string;
  payoutVerifiedAt: string | null;
}> {
  return withApiError(async () => {
    const apiBaseUrl = getProBaseUrl();
    const response = await fetch(`${apiBaseUrl}/api/v1/pro/payout-settings`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      }
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Erreur lors de la récupération des coordonnées." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Erreur lors de la récupération des coordonnées.");
    }
    return response.json() as Promise<{
      payoutMethod: "wave_senegal" | "orange_money_senegal" | null;
      payoutPhone: string | null;
      payoutName: string | null;
      payoutVerificationStatus: string;
      payoutVerifiedAt: string | null;
    }>;
  });
}

export async function updateProPayoutSettings(token: string, payload: Record<string, unknown>): Promise<Record<string, unknown>> {
  return withApiError(async () => {
    const apiBaseUrl = getProBaseUrl();
    const response = await fetch(`${apiBaseUrl}/api/v1/pro/payout-settings`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify(payload)
    });
    if (!response.ok) {
      const p = await response.json().catch(() => ({ message: "Erreur lors de la mise à jour des coordonnées." })) as { code?: string; message?: string };
      throw new ApiError(response.status, p.code ?? "error", p.message ?? "Erreur lors de la mise à jour des coordonnées.");
    }
    return response.json() as Promise<Record<string, unknown>>;
  });
}

export async function fetchProMerchantPayouts(token: string): Promise<unknown[]> {
  return withApiError(async () => {
    const apiBaseUrl = getProBaseUrl();
    const response = await fetch(`${apiBaseUrl}/api/v1/pro/merchant-payouts`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      }
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Erreur lors de la récupération de l'historique des règlements." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Erreur lors de la récupération de l'historique des règlements.");
    }
    return response.json() as Promise<unknown[]>;
  });
}
