import type {
  EmailLoginInput,
  OtpRequestInput,
  OtpVerifyInput,
  RegisterInput
} from "@/lib/generated";
import {
  getAuthApi,
  resolveAccessToken,
  withApiError,
  fetchWithProAuth,
  getProBaseUrl,
  ApiError
} from "./shared";

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

export async function forgotPassword(email: string): Promise<{ sent: boolean }> {
  return withApiError(async () => {
    const apiBaseUrl = getProBaseUrl();
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
    const apiBaseUrl = getProBaseUrl();
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
    const apiBaseUrl = getProBaseUrl();
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
    const apiBaseUrl = getProBaseUrl();
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

export async function redeemStaffInviteToken(inviteToken: string, userId: string): Promise<{ accessToken: string; refreshToken: string }> {
  return withApiError(async () => {
    const apiBaseUrl = getProBaseUrl();
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
