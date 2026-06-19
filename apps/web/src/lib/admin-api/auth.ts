import type { CurrentUser } from "@beauteavenue/contracts";
import { authHeaders, request } from "./shared";

type LoginPayload = {
  email: string;
  password: string;
};

type AuthSession = {
  accessToken: string;
  refreshToken: string;
  expiresInSeconds: number;
};

export async function loginAdmin(payload: LoginPayload) {
  return request<AuthSession>("/api/v1/auth/login", {
    method: "POST",
    body: JSON.stringify(payload)
  });
}

export async function fetchCurrentUser(token: string) {
  return request<CurrentUser>("/api/v1/me", {
    headers: authHeaders(token)
  });
}

export async function logoutAdmin(token: string, refreshToken?: string) {
  return request<{ revoked: boolean }>("/api/v1/auth/logout", {
    method: "POST",
    headers: authHeaders(token),
    body: refreshToken ? JSON.stringify({ refreshToken }) : undefined
  });
}

export async function refreshAdminSession(refreshToken: string) {
  return request<AuthSession>("/api/v1/auth/refresh", {
    method: "POST",
    body: JSON.stringify({ refreshToken })
  });
}

export async function forgotPassword(email: string): Promise<{ sent: boolean }> {
  return request<{ sent: boolean }>("/api/v1/auth/forgot-password", {
    method: "POST",
    body: JSON.stringify({ email })
  });
}

export async function changePassword(token: string, currentPassword: string, newPassword: string) {
  return request<CurrentUser>("/api/v1/me", {
    method: "PATCH",
    headers: authHeaders(token),
    body: JSON.stringify({ currentPassword, newPassword })
  });
}
