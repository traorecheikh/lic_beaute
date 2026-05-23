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
  type ProBlockedSlotCreateInput,
  type ProSalonProfileHoursInner,
  type ProSalonUpdateInput,
  type ProServiceCreateInput,
  type ProServiceUpdateInput,
  type ProStaffCreateInput,
  type ProStaffUpdateInput,
  type ProSubscriptionCheckoutInput,
  type ProSubscriptionUpdateInput,
  type RegisterInput,
  type ProManualBookingInput,
  type ProClientBenefitCreateInput,
  type ProVoucherCreateInput
} from "@/lib/generated";
import { ResponseError } from "@/lib/generated/runtime";

import { ApiError } from "./api";

const _configuredBase = (import.meta.env.VITE_API_URL as string | undefined) ?? "";
const apiBaseUrl = _configuredBase.startsWith("http")
  ? _configuredBase
  : (typeof window !== "undefined" ? window.location.origin : "http://localhost:3000") + _configuredBase;

function getConfiguration(token?: string) {
  return new Configuration({
    basePath: apiBaseUrl,
    accessToken: token
  });
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

async function withApiError<T>(operation: () => Promise<T>) {
  try {
    return await operation();
  } catch (error) {
    if (error instanceof ResponseError) {
      const statusCode = error.response.status;
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
  return withApiError(() => getAuthApi(token).apiV1MeGet());
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
  return withApiError(() => getProApi(token).apiV1ProDashboardGet());
}

export async function fetchProBookings(token: string, query: ApiV1ProBookingsGetRequest = {}) {
  return withApiError(() => getProApi(token).apiV1ProBookingsGet(query));
}

export async function fetchProBooking(token: string, bookingId: string) {
  return withApiError(() => getProApi(token).apiV1ProBookingsBookingIdGet({ bookingId }));
}

export async function acceptProBooking(token: string, bookingId: string) {
  return withApiError(() => getProApi(token).apiV1ProBookingsBookingIdAcceptPost({ bookingId }));
}

export async function rejectProBooking(token: string, bookingId: string) {
  return withApiError(() => getProApi(token).apiV1ProBookingsBookingIdRejectPost({ bookingId }));
}

export async function startProBooking(token: string, bookingId: string) {
  return withApiError(() => getProApi(token).apiV1ProBookingsBookingIdStartPost({ bookingId }));
}

export async function completeProBooking(token: string, bookingId: string) {
  return withApiError(() => getProApi(token).apiV1ProBookingsBookingIdCompletePost({ bookingId }));
}

export async function createManualProBooking(token: string, payload: ProManualBookingInput) {
  return withApiError(() => getProApi(token).apiV1ProBookingsManualPost({ proManualBookingInput: payload }));
}

export async function fetchProClients(token: string, search?: string) {
  return withApiError(() => getProApi(token).apiV1ProClientsGet({ search }));
}

export async function fetchProClient(token: string, clientId: string) {
  return withApiError(() => getProApi(token).apiV1ProClientsClientIdGet({ clientId }));
}

export async function createClientBenefit(token: string, payload: ProClientBenefitCreateInput) {
  return withApiError(() => getProApi(token).apiV1ProClientsBenefitsPost({ proClientBenefitCreateInput: payload }));
}

export async function createProVoucher(token: string, payload: ProVoucherCreateInput) {
  return withApiError(() => getProApi(token).apiV1ProVouchersPost({ proVoucherCreateInput: payload }));
}

export async function fetchProCheckout(token: string, bookingId: string) {
  return withApiError(() => getProApi(token).apiV1ProCheckoutBookingIdGet({ bookingId }));
}

export async function completeProCheckout(token: string, bookingId: string, payload: {
  paymentMethod: "cash" | "intech" | "other";
  softpayMethod?: string;
  discountXof: number;
  lineItems: Array<{ name: string; amountXof: number }>;
}) {
  const cfg = getConfiguration(token);
  const basePath = cfg.basePath ?? "";
  const response = await fetch(`${basePath}/api/v1/pro/checkout/${bookingId}/complete`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
      Accept: "application/json"
    },
    body: JSON.stringify(payload)
  });
  if (!response.ok) {
    const text = await response.text();
    throw new ApiError(response.status, "checkout_complete_failed", text);
  }
  return response.json();
}

export async function fetchPaymentMethods(token: string) {
  // GET /api/v1/payments/methods — not yet in generated client
  const cfg = getConfiguration(token);
  const basePath = cfg.basePath ?? "";
  const response = await fetch(`${basePath}/api/v1/payments/methods`, {
    method: "GET",
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: "application/json"
    }
  });
  if (!response.ok) throw new ApiError(response.status, "get_payment_methods_failed", await response.text());
  return response.json();
}

export async function fetchProSalon(token: string) {
  return withApiError(() => getProApi(token).apiV1ProSalonGet());
}

export async function updateProSalon(token: string, payload: ProSalonUpdateInput) {
  return withApiError(() => getProApi(token).apiV1ProSalonPatch({ proSalonUpdateInput: payload }));
}

export async function uploadProMedia(
  token: string,
  file: File,
  purpose: string
) {
  return withApiError(async () => {
    const formData = new FormData();
    formData.append("purpose", purpose);
    formData.append("file", file);

    const uploadResponse = await fetch(`${apiBaseUrl}/api/v1/media/upload`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`
        // No Content-Type — browser sets it automatically with boundary for multipart/form-data
      },
      body: formData
    });

    if (!uploadResponse.ok) {
      const payload = await uploadResponse.json().catch(() => ({})) as { code?: string; message?: string };
      throw new ApiError(uploadResponse.status, payload.code ?? "upload_failed", payload.message ?? "Échec du téléversement.");
    }

    const result = await uploadResponse.json() as { assetId: string; publicUrl?: string };

    return { id: result.assetId, publicUrl: result.publicUrl ?? "" };
  });
}

/** Delete a previously uploaded media asset (soft-delete in DB). */
export async function deleteProMediaAsset(token: string, mediaId: string) {
  return withApiError(() => getMediaApi(token).apiV1MediaMediaIdDelete({ mediaId }));
}

export async function fetchProServices(token: string) {
  return withApiError(() => getProApi(token).apiV1ProServicesGet());
}

export async function createProService(token: string, payload: ProServiceCreateInput) {
  return withApiError(() => getProApi(token).apiV1ProServicesPost({ proServiceCreateInput: payload }));
}

export async function updateProService(token: string, serviceId: string, payload: ProServiceUpdateInput) {
  return withApiError(() => getProApi(token).apiV1ProServicesServiceIdPatch({
    serviceId,
    proServiceUpdateInput: payload
  }));
}

export async function deleteProService(token: string, serviceId: string) {
  return withApiError(() => getProApi(token).apiV1ProServicesServiceIdDelete({ serviceId }));
}

export async function fetchProStaff(token: string) {
  return withApiError(() => getProApi(token).apiV1ProStaffGet());
}

export async function createProStaff(token: string, payload: ProStaffCreateInput) {
  return withApiError(() => getProApi(token).apiV1ProStaffPost({ proStaffCreateInput: payload }));
}

export async function updateProStaff(token: string, employeeId: string, payload: ProStaffUpdateInput) {
  return withApiError(() => getProApi(token).apiV1ProStaffEmployeeIdPatch({
    employeeId,
    proStaffUpdateInput: payload
  }));
}

export async function deleteProStaff(token: string, employeeId: string) {
  return withApiError(() => getProApi(token).apiV1ProStaffEmployeeIdDelete({ employeeId }));
}

export async function resendProStaffInvite(token: string, employeeId: string): Promise<{ sent: boolean; email: string }> {
  const response = await fetch(`${apiBaseUrl}/api/v1/pro/staff/${employeeId}/resend-invite`, {
    method: "POST",
    headers: { "Content-Type": "application/json", authorization: `Bearer ${token}` }
  });
  if (!response.ok) {
    const payload = await response.json().catch(() => ({ message: "Envoi impossible." })) as { code?: string; message?: string };
    throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Envoi impossible.");
  }
  return response.json() as Promise<{ sent: boolean; email: string }>;
}

export async function fetchProHours(token: string) {
  return withApiError(() => getProApi(token).apiV1ProHoursGet());
}

export async function updateProHours(token: string, hours: ProSalonProfileHoursInner[]) {
  return withApiError(() => getProApi(token).apiV1ProHoursPut({ proSalonProfileHoursInner: hours }));
}

export async function fetchProBlockedSlots(token: string) {
  return withApiError(() => getProApi(token).apiV1ProBlockedSlotsGet());
}

export async function createProBlockedSlot(token: string, payload: ProBlockedSlotCreateInput) {
  return withApiError(() => getProApi(token).apiV1ProBlockedSlotsPost({ proBlockedSlotCreateInput: payload }));
}

export async function deleteProBlockedSlot(token: string, slotId: string) {
  return withApiError(() => getProApi(token).apiV1ProBlockedSlotsSlotIdDelete({ slotId }));
}

export async function fetchProAnalytics(token: string, period: "7d" | "30d" | "90d") {
  return withApiError(() => getProApi(token).apiV1ProAnalyticsGet({ period }));
}

export async function fetchProSubscription(token: string) {
  return withApiError(() => getProApi(token).apiV1ProSubscriptionGet());
}

export async function updateProSubscription(token: string, payload: ProSubscriptionUpdateInput) {
  return withApiError(() => getProApi(token).apiV1ProSubscriptionPatch({
    proSubscriptionUpdateInput: payload
  }));
}

export async function checkoutProSubscription(token: string, payload: ProSubscriptionCheckoutInput) {
  return withApiError(() => getProApi(token).apiV1ProSubscriptionCheckoutPost({
    proSubscriptionCheckoutInput: payload
  }));
}

export async function fetchProInvoices(token: string) {
  return withApiError(() => getProApi(token).apiV1ProInvoicesGet());
}

export async function downloadProInvoicePdf(token: string, invoiceId: string) {
  return withApiError(async () => {
    const response = await fetch(`${apiBaseUrl}/api/v1/pro/invoices/${invoiceId}/pdf`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`
      }
    });

    if (!response.ok) {
      let code = "unknown_error";
      let message = "Téléchargement impossible.";
      try {
        const payload = (await response.clone().json()) as { code?: string; message?: string };
        code = payload.code ?? code;
        message = payload.message ?? message;
      } catch {
        // ignore parsing failures and use fallback message
      }
      throw new ApiError(response.status, code, message);
    }

    return response.blob();
  });
}

export async function fetchProPayouts(token: string) {
  return withApiError(() => getProApi(token).apiV1ProPayoutsGet());
}

function getNotificationsApi(token: string) {
  return new NotificationsApi(getConfiguration(token));
}

export async function fetchNotificationsUnreadCount(token: string): Promise<number> {
  return withApiError(async () => {
    const result = await getNotificationsApi(token).apiV1NotificationsGet({});
    return (result as unknown as { unreadCount: number }).unreadCount ?? 0;
  });
}

export async function fetchNotifications(token: string) {
  return withApiError(() => getNotificationsApi(token).apiV1NotificationsGet());
}

export async function markNotificationRead(token: string, id: string) {
  return withApiError(() => getNotificationsApi(token).apiV1NotificationsIdReadPost({ id }));
}

export async function markAllNotificationsRead(token: string) {
  return withApiError(() => getNotificationsApi(token).apiV1NotificationsReadAllPost());
}

export async function redeemStaffInviteToken(inviteToken: string): Promise<{ accessToken: string; refreshToken: string }> {
  return withApiError(async () => {
    const response = await fetch(`${apiBaseUrl}/api/v1/auth/staff-invite/redeem`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token: inviteToken })
    });
    if (!response.ok) {
      const payload = await response.json().catch(() => ({ message: "Lien invalide ou expiré." })) as { code?: string; message?: string };
      throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Lien invalide ou expiré.");
    }
    return response.json() as Promise<{ accessToken: string; refreshToken: string }>;
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
