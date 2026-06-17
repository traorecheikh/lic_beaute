import {
  AuthApi,
  Configuration,
  MediaApi,
  NotificationsApi,
  ProApi,
  type ApiV1ProBookingsGetRequest,
  type EmailLoginInput,
  type OtpRequestInput,
  type OtpVerifyInput,
  type RegisterInput,
  type ProBlockedSlotCreateInput,
  type ProBookingDetail,
  type ProSalonProfileHoursInner,
  type ProSalonUpdateInput,
  type ProServiceCreateInput,
  type ProServiceUpdateInput,
  type ProStaffCreateInput,
  type ProStaffUpdateInput,
  type ProSubscriptionCheckoutInput,
  type ProSubscriptionExecuteInput,
  type ProSubscriptionUpdateInput,
  type ProManualBookingInput,
  type ProClientBenefitCreateInput,
  type ProClientSummary,
  type ProVoucherCreateInput
} from "@/lib/generated";
import { ResponseError } from "@/lib/generated/runtime";

import { ApiError } from "./api";
import { resolveApiBaseUrl } from "./api-base";
import type { ProSubscriptionChargeStatusResult } from "./pro-billing";

const apiBaseUrl = resolveApiBaseUrl();

type ProAuthSession = {
  accessToken: string;
  refreshToken: string;
  expiresInSeconds: number;
};

export type PaydunyaMethodRecord = {
  code: string;
  country: string;
  label: string;
  enabled: boolean;
};

export type PaydunyaMethodListResult = {
  methods: PaydunyaMethodRecord[];
};

export type ProSubscriptionFeatureTier = {
  tier: "standard" | "premium";
  label: string;
  priceLabel: string;
  priceXof?: number;
  features?: Array<{
    label: string;
    included: boolean;
  }>;
};

export type ProSubscriptionFeaturesResult = {
  billingProviders?: {
    paydunya?: boolean;
    manual?: boolean;
  };
  planTiers?: ProSubscriptionFeatureTier[];
};

type ProSessionController = {
  getAccessToken(): string | null;
  getRefreshToken(): string | null;
  applySession(session: ProAuthSession): void;
  clearSessionIfRefreshTokenMatches(refreshToken: string | null): void;
};

let proSessionController: ProSessionController | null = null;
let refreshPromise: Promise<boolean> | null = null;

export function registerProSessionController(controller: ProSessionController) {
  proSessionController = controller;
}

function getConfiguration(token?: string) {
  return new Configuration({
    basePath: apiBaseUrl,
    accessToken: token
  });
}

function resolveAccessToken(token?: string) {
  return proSessionController?.getAccessToken() ?? token;
}

function getAuthApi(token?: string) {
  return new AuthApi(getConfiguration(token));
}

function getMediaApi(token: string) {
  return new MediaApi(getConfiguration(token));
}

function getProApi(token: string) {
  return new ProApi(getConfiguration(token));
}

async function withApiError<T>(operation: () => Promise<T>, retry?: () => Promise<T>) {
  try {
    return await operation();
  } catch (error) {
    if (error instanceof ResponseError) {
      const statusCode = error.response.status;
      if (statusCode === 401 && retry && !error.response.url.includes("/api/v1/auth/refresh")) {
        const refreshed = await refreshSessionWithSingleFlight();
        if (refreshed) {
          return retry();
        }
      }
      let code = "unknown_error";
      let message = "Une erreur est survenue.";

      try {
        const payload = (await error.response.clone().json()) as { code?: string; message?: string };
        code = payload.code ?? code;
        message = payload.message ?? message;
      } catch {
        // ignore json parsing failures and keep fallback message
      }

      throw new ApiError(statusCode, code, message);
    }

    if (error instanceof Error) {
      throw new ApiError(0, "network_error", error.message);
    }

    throw error;
  }
}

async function refreshSessionWithSingleFlight(): Promise<boolean> {
  if (!proSessionController) return false;
  if (refreshPromise) return refreshPromise;

  refreshPromise = (async () => {
    const attemptedRefreshToken = proSessionController?.getRefreshToken() ?? null;
    if (!attemptedRefreshToken) return false;

    try {
      const session = await getAuthApi().apiV1AuthRefreshPost({
        refreshInput: { refreshToken: attemptedRefreshToken }
      });
      proSessionController?.applySession(session);
      return true;
    } catch {
      proSessionController?.clearSessionIfRefreshTokenMatches(attemptedRefreshToken);
      return false;
    } finally {
      refreshPromise = null;
    }
  })();

  return refreshPromise;
}

async function fetchProAuthResponse(path: string, init: RequestInit, token?: string, canRetryUnauthorized = true): Promise<Response> {
  const accessToken = resolveAccessToken(token);
  const headers = new Headers(init.headers ?? {});
  if (init.body != null && !(init.body instanceof FormData) && !headers.has("Content-Type")) {
    headers.set("Content-Type", "application/json");
  }
  if (accessToken && !headers.has("Authorization")) {
    headers.set("Authorization", `Bearer ${accessToken}`);
  }
  const response = await fetch(`${apiBaseUrl}${path}`, {
    ...init,
    headers
  });

  if (response.status === 401 && canRetryUnauthorized && proSessionController && !path.startsWith("/api/v1/auth/")) {
    const refreshed = await refreshSessionWithSingleFlight();
    if (refreshed) {
      return fetchProAuthResponse(path, init, token, false);
    }
  }

  if (!response.ok) {
    const payload = await response.json().catch(async () => ({
      code: "unknown_error",
      message: await response.text().catch(() => "Une erreur est survenue.")
    })) as { code?: string; message?: string };
    throw new ApiError(response.status, payload.code ?? "unknown_error", payload.message ?? "Une erreur est survenue.");
  }

  return response;
}

async function fetchWithProAuth<T>(path: string, init: RequestInit, token?: string, canRetryUnauthorized = true): Promise<T> {
  const response = await fetchProAuthResponse(path, init, token, canRetryUnauthorized);
  return response.json() as Promise<T>;
}

export const dayOfWeekLabel: Record<number, string> = {
  0: "Dimanche",
  1: "Lundi",
  2: "Mardi",
  3: "Mercredi",
  4: "Jeudi",
  5: "Vendredi",
  6: "Samedi"
};

export const dayOfWeekOrder = [1, 2, 3, 4, 5, 6, 0];

export function getDayLabel(dayOfWeek: number) {
  return dayOfWeekLabel[dayOfWeek] ?? `Jour ${dayOfWeek}`;
}

export async function loginPro(payload: EmailLoginInput) {
  return withApiError(() => getAuthApi().apiV1AuthLoginPost({ emailLoginInput: payload }));
}

export async function registerProOwner(payload: RegisterInput) {
  return withApiError(() => getAuthApi().apiV1AuthRegisterPost({ registerInput: payload }));
}

export async function requestProOtp(payload: OtpRequestInput) {
  return withApiError(() => getAuthApi().apiV1AuthOtpRequestPost({ otpRequestInput: payload }));
}

export async function verifyProOtp(payload: OtpVerifyInput) {
  return withApiError(() => getAuthApi().apiV1AuthOtpVerifyPost({ otpVerifyInput: payload }));
}

export async function fetchProCurrentUser(token: string) {
  return withApiError(
    () => getAuthApi(resolveAccessToken(token)).apiV1MeGet(),
    () => getAuthApi(resolveAccessToken(token)).apiV1MeGet()
  );
}

export async function logoutPro(token: string, refreshToken?: string) {
  return withApiError(() => getAuthApi(token).apiV1AuthLogoutPost({
    refreshInput: refreshToken ? { refreshToken } : undefined
  }));
}

export async function refreshProSession(refreshToken: string) {
  return withApiError(() => getAuthApi().apiV1AuthRefreshPost({
    refreshInput: { refreshToken }
  }));
}

export async function fetchProDashboard(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProDashboardGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProDashboardGet()
  );
}

export async function fetchProBookings(token: string, query: { status?: string; date?: string; page?: number; pageSize?: number } = {}) {
  const params = new URLSearchParams();
  if (query.status) params.set("status", query.status);
  if (query.date) params.set("date", query.date);
  params.set("page", String(query.page ?? 0));
  params.set("pageSize", String(query.pageSize ?? 20));
  const basePath = resolveApiBaseUrl();
  const resp = await fetch(`${basePath}/api/v1/pro/bookings?${params}`, {
    headers: { Authorization: `Bearer ${resolveAccessToken(token) ?? token}` }
  });
  if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
  return resp.json() as Promise<{ items: ProBookingDetail[]; total: number; page: number; pageSize: number }>;
}

export async function fetchProBooking(token: string, bookingId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdGet({ bookingId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdGet({ bookingId })
  );
}

export async function acceptProBooking(token: string, bookingId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdAcceptPost({ bookingId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdAcceptPost({ bookingId })
  );
}

export async function rejectProBooking(token: string, bookingId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdRejectPost({ bookingId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdRejectPost({ bookingId })
  );
}

export async function startProBooking(token: string, bookingId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdStartPost({ bookingId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdStartPost({ bookingId })
  );
}

export async function completeProBooking(token: string, bookingId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdCompletePost({ bookingId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsBookingIdCompletePost({ bookingId })
  );
}

export async function createManualProBooking(token: string, payload: ProManualBookingInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsManualPost({ proManualBookingInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBookingsManualPost({ proManualBookingInput: payload })
  );
}

export async function fetchProClients(token: string, search?: string, page = 0, pageSize = 20) {
  const params = new URLSearchParams();
  if (search) params.set("search", search);
  params.set("page", String(page));
  params.set("pageSize", String(pageSize));
  const basePath = resolveApiBaseUrl();
  const resp = await fetch(`${basePath}/api/v1/pro/clients?${params}`, {
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

export async function createProVoucher(token: string, payload: ProVoucherCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProVouchersPost({ proVoucherCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProVouchersPost({ proVoucherCreateInput: payload })
  );
}

export async function fetchProCheckout(token: string, bookingId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProCheckoutBookingIdGet({ bookingId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProCheckoutBookingIdGet({ bookingId })
  );
}

export async function completeProCheckout(token: string, bookingId: string, payload: {
  paymentMethod: "cash" | "other";
  softpayMethod?: string;
  discountXof: number;
  lineItems: Array<{ name: string; amountXof: number }>;
}): Promise<{
  paymentId: string;
  status: string;
}> {
  return fetchWithProAuth(`/api/v1/pro/checkout/${bookingId}/complete`, {
    method: "POST",
    headers: { Accept: "application/json" },
    body: JSON.stringify(payload)
  }, token);
}

export async function fetchPaymentMethods(token: string): Promise<PaydunyaMethodListResult> {
  return fetchWithProAuth<PaydunyaMethodListResult>("/api/v1/payments/methods", {
    method: "GET",
    headers: { Accept: "application/json" }
  }, token);
}

export async function fetchProSalon(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonGet()
  );
}

export async function updateProSalon(token: string, payload: ProSalonUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonPatch({ proSalonUpdateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonPatch({ proSalonUpdateInput: payload })
  );
}

export async function uploadProMedia(
  token: string,
  file: File,
  purpose: string
) {
  const formData = new FormData();
  formData.append("purpose", purpose);
  formData.append("file", file);
  const result = await fetchWithProAuth<{ assetId: string; publicUrl?: string }>("/api/v1/media/upload", {
    method: "POST",
    body: formData
  }, token);
  return { id: result.assetId, publicUrl: result.publicUrl ?? "" };
}

/** Delete a previously uploaded media asset (soft-delete in DB). */
export async function deleteProMediaAsset(token: string, mediaId: string) {
  return withApiError(
    () => getMediaApi(resolveAccessToken(token) ?? token).apiV1MediaMediaIdDelete({ mediaId }),
    () => getMediaApi(resolveAccessToken(token) ?? token).apiV1MediaMediaIdDelete({ mediaId })
  );
}

export async function fetchProServices(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesGet()
  );
}

export async function createProService(token: string, payload: ProServiceCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesPost({ proServiceCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesPost({ proServiceCreateInput: payload })
  );
}

export async function updateProService(token: string, serviceId: string, payload: ProServiceUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdPatch({
      serviceId,
      proServiceUpdateInput: payload
    }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdPatch({
      serviceId,
      proServiceUpdateInput: payload
    })
  );
}

export async function deleteProService(token: string, serviceId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdDelete({ serviceId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdDelete({ serviceId })
  );
}

export async function fetchProStaff(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffGet()
  );
}

export async function createProStaff(token: string, payload: ProStaffCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffPost({ proStaffCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffPost({ proStaffCreateInput: payload })
  );
}

export async function updateProStaff(token: string, employeeId: string, payload: ProStaffUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdPatch({
      employeeId,
      proStaffUpdateInput: payload
    }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdPatch({
      employeeId,
      proStaffUpdateInput: payload
    })
  );
}

export async function deleteProStaff(token: string, employeeId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdDelete({ employeeId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdDelete({ employeeId })
  );
}

export async function resendProStaffInvite(token: string, employeeId: string): Promise<{ sent: boolean; email: string }> {
  return fetchWithProAuth(`/api/v1/pro/staff/${employeeId}/resend-invite`, {
    method: "POST"
  }, token);
}

export async function fetchProHours(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursGet()
  );
}

export async function updateProHours(token: string, hours: ProSalonProfileHoursInner[]) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursPut({ proSalonProfileHoursInner: hours }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursPut({ proSalonProfileHoursInner: hours })
  );
}

export async function fetchProBlockedSlots(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsGet()
  );
}

export async function createProBlockedSlot(token: string, payload: ProBlockedSlotCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsPost({ proBlockedSlotCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsPost({ proBlockedSlotCreateInput: payload })
  );
}

export async function deleteProBlockedSlot(token: string, slotId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsSlotIdDelete({ slotId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsSlotIdDelete({ slotId })
  );
}

export async function fetchProAnalytics(token: string, period: "7d" | "30d" | "90d") {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProAnalyticsGet({ period }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProAnalyticsGet({ period })
  );
}

export async function fetchProSubscription(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionGet()
  );
}

export async function fetchProSubscriptionFeatures(token: string): Promise<ProSubscriptionFeaturesResult> {
  return fetchWithProAuth<ProSubscriptionFeaturesResult>("/api/v1/pro/subscription/features", {
    method: "GET",
    headers: { Accept: "application/json" }
  }, token);
}

export async function updateProSubscription(token: string, payload: ProSubscriptionUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionPatch({
      proSubscriptionUpdateInput: payload
    }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionPatch({
      proSubscriptionUpdateInput: payload
    })
  );
}

export async function checkoutProSubscription(token: string, payload: ProSubscriptionCheckoutInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionCheckoutPost({
      proSubscriptionCheckoutInput: payload
    }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionCheckoutPost({
      proSubscriptionCheckoutInput: payload
    })
  );
}

export async function executeProSubscription(token: string, chargeId: string, payload: ProSubscriptionExecuteInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionChargeChargeIdExecutePost({
      chargeId,
      proSubscriptionExecuteInput: payload
    }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSubscriptionChargeChargeIdExecutePost({
      chargeId,
      proSubscriptionExecuteInput: payload
    })
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

export async function fetchProSubscriptionChargeStatus(token: string, chargeId: string): Promise<ProSubscriptionChargeStatusResult> {
  return fetchWithProAuth<ProSubscriptionChargeStatusResult>(`/api/v1/pro/subscription/charge/${chargeId}/status`, {
    method: "GET",
    headers: { Accept: "application/json" }
  }, token);
}

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

export async function fetchProPayouts(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProPayoutsGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProPayoutsGet()
  );
}

function getNotificationsApi(token: string) {
  return new NotificationsApi(getConfiguration(token));
}

export async function fetchNotificationsUnreadCount(token: string): Promise<number> {
  return withApiError(async () => {
    const result = await getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet({});
    return (result as unknown as { unreadCount: number }).unreadCount ?? 0;
  }, async () => {
    const result = await getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet({});
    return (result as unknown as { unreadCount: number }).unreadCount ?? 0;
  });
}

export async function fetchNotifications(token: string) {
  return withApiError(
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet(),
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet()
  );
}

export async function markNotificationRead(token: string, id: string) {
  return withApiError(
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsIdReadPost({ id }),
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsIdReadPost({ id })
  );
}

export async function markAllNotificationsRead(token: string) {
  return withApiError(
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsReadAllPost(),
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsReadAllPost()
  );
}

export async function redeemStaffInviteToken(inviteToken: string, userId: string): Promise<{ accessToken: string; refreshToken: string }> {
  return withApiError(async () => {
    const response = await fetch(`${apiBaseUrl}/api/v1/auth/staff-invite/redeem`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token: inviteToken, userId })
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Lien invalide ou expiré." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Lien invalide ou expiré.");
    }
    return response.json() as Promise<{ accessToken: string; refreshToken: string }>;
  });
}

export async function forgotPassword(email: string): Promise<{ sent: boolean }> {
  return withApiError(async () => {
    const response = await fetch(`${apiBaseUrl}/api/v1/auth/forgot-password`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email })
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Impossible d'envoyer le lien." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Impossible d'envoyer le lien.");
    }
    return response.json() as Promise<{ sent: boolean }>;
  });
}

export async function resetProPassword(token: string, email: string, password: string): Promise<{ accessToken: string; refreshToken: string; expiresInSeconds: number }> {
  return withApiError(async () => {
    const response = await fetch(`${apiBaseUrl}/api/v1/auth/reset-password`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token, email, password })
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Lien invalide ou expiré." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Lien invalide ou expiré.");
    }
    return response.json() as Promise<{ accessToken: string; refreshToken: string; expiresInSeconds: number }>;
  });
}

export async function setupProAccount(token: string, email: string, password: string): Promise<{ accessToken: string; refreshToken: string; expiresInSeconds: number }> {
  return withApiError(async () => {
    const response = await fetch(`${apiBaseUrl}/api/v1/auth/setup-account`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token, email, password })
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Lien invalide ou expiré." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Lien invalide ou expiré.");
    }
    return response.json() as Promise<{ accessToken: string; refreshToken: string; expiresInSeconds: number }>;
  });
}

export async function magicLoginPro(token: string, email: string): Promise<{ accessToken: string; refreshToken: string; expiresInSeconds: number }> {
  return withApiError(async () => {
    const response = await fetch(`${apiBaseUrl}/api/v1/auth/magic-login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token, email })
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Lien de connexion invalide ou expiré." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Lien de connexion invalide ou expiré.");
    }
    return response.json() as Promise<{ accessToken: string; refreshToken: string; expiresInSeconds: number }>;
  });
}

export async function fetchProPayoutSettings(token: string): Promise<{
  payoutMethod: "wave_senegal" | "orange_money_senegal" | null;
  payoutPhone: string | null;
  payoutName: string | null;
  payoutVerificationStatus: string;
  payoutVerifiedAt: string | null;
}> {
  return withApiError(async () => {
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
    return response.json();
  });
}

export async function updateProPayoutSettings(token: string, payload: any): Promise<any> {
  return withApiError(async () => {
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
    return response.json();
  });
}

export async function fetchProMerchantPayouts(token: string): Promise<any[]> {
  return withApiError(async () => {
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
    return response.json();
  });
}
