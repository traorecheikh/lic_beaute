import type {
  ProBookingDetail,
  ProManualBookingInput
} from "@/lib/generated";
import {
  getProApi,
  resolveAccessToken,
  withApiError,
  fetchWithProAuth,
  getProBaseUrl,
  ApiError
} from "./shared";

export async function fetchProBookings(token: string, query: { status?: string; date?: string; page?: number; pageSize?: number } = {}) {
  const params = new URLSearchParams();
  if (query.status) params.set("status", query.status);
  if (query.date) params.set("date", query.date);
  params.set("page", String(query.page ?? 0));
  params.set("pageSize", String(query.pageSize ?? 20));
  const apiBaseUrl = getProBaseUrl();
  const resp = await fetch(`${apiBaseUrl}/api/v1/pro/bookings?${params}`, {
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

// ─── Checkout ─────────────────────────────────────────────────────────────────

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
}): Promise<{ paymentId: string; status: string }> {
  return fetchWithProAuth(`/api/v1/pro/checkout/${bookingId}/complete`, {
    method: "POST",
    headers: { Accept: "application/json" },
    body: JSON.stringify(payload)
  }, token);
}

export async function fetchPaymentMethods(token: string): Promise<{ methods: Array<{ code: string; country: string; label: string; enabled: boolean }> }> {
  return fetchWithProAuth<{ methods: Array<{ code: string; country: string; label: string; enabled: boolean }> }>("/api/v1/payments/methods", {
    method: "GET",
    headers: { Accept: "application/json" }
  }, token);
}
