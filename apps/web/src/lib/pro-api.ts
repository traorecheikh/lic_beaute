import {
  AuthApi,
  Configuration,
  MediaApi,
  ProApi,
  type ApiV1MediaUploadIntentPostRequestPurposeEnum,
  type ApiV1ProBookingsGetRequest,
  type EmailLoginInput,
  type OtpRequestInput,
  type OtpVerifyInput,
  type ProCheckoutCompleteInput,
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

export async function completeProCheckout(token: string, bookingId: string, payload: ProCheckoutCompleteInput) {
  return withApiError(() => getProApi(token).apiV1ProCheckoutBookingIdCompletePost({
    bookingId,
    proCheckoutCompleteInput: payload
  }));
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
  purpose: ApiV1MediaUploadIntentPostRequestPurposeEnum
) {
  return withApiError(async () => {
    const mediaApi = getMediaApi(token);

    const intent = await mediaApi.apiV1MediaUploadIntentPost({
      apiV1MediaUploadIntentPostRequest: {
        purpose,
        mimeType: file.type,
        originalFilename: file.name,
        sizeBytes: file.size
      }
    });

    const putResponse = await fetch(intent.uploadUrl, {
      method: "PUT",
      headers: { "Content-Type": file.type },
      body: file
    });

    if (!putResponse.ok) {
      throw new ApiError(putResponse.status, "upload_failed", "Échec du téléversement vers le stockage.");
    }

    await mediaApi.apiV1MediaMediaIdCompletePost({ mediaId: intent.assetId });

    const asset = await mediaApi.apiV1MediaMediaIdGet({ mediaId: intent.assetId });

    return { id: asset.id, publicUrl: asset.publicUrl ?? "" };
  });
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
