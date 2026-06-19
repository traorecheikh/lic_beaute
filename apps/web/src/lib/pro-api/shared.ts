import {
  AuthApi,
  Configuration,
  MediaApi,
  NotificationsApi,
  ProApi
} from "@/lib/generated";
import { ResponseError } from "@/lib/generated/runtime";
import { ApiError } from "../admin-api/shared";
import { resolveApiBaseUrl } from "../api-base";

export { ApiError };

const apiBaseUrl = resolveApiBaseUrl();

type ProAuthSession = {
  accessToken: string;
  refreshToken: string;
  expiresInSeconds: number;
};

type ProSessionController = {
  getAccessToken(): string | null;
  getRefreshToken(): string | null;
  applySession(session: ProAuthSession): void;
  clearSessionIfRefreshTokenMatches(refreshToken: string | null): void;
};

export type { ProAuthSession, ProSessionController };

let proSessionController: ProSessionController | null = null;
let refreshPromise: Promise<boolean> | null = null;

export function registerProSessionController(controller: ProSessionController) {
  proSessionController = controller;
}

export function getProBaseUrl(): string {
  return apiBaseUrl;
}

// ─── Generated client helpers ─────────────────────────────────────────────────

function getConfiguration(token?: string) {
  return new Configuration({
    basePath: apiBaseUrl,
    accessToken: token
  });
}

function resolveAccessToken(token?: string) {
  return proSessionController?.getAccessToken() ?? token;
}

export { getConfiguration, resolveAccessToken };

export function getAuthApi(token?: string) {
  return new AuthApi(getConfiguration(token));
}

export function getMediaApi(token: string) {
  return new MediaApi(getConfiguration(token));
}

export function getProApi(token: string) {
  return new ProApi(getConfiguration(token));
}

export function getNotificationsApi(token: string) {
  return new NotificationsApi(getConfiguration(token));
}

// ─── Refresh helpers ──────────────────────────────────────────────────────────

export async function refreshSessionWithSingleFlight(): Promise<boolean> {
  if (!proSessionController) return false;
  if (refreshPromise) return refreshPromise;

  refreshPromise = (async () => {
    const attemptedRefreshToken = proSessionController?.getRefreshToken() ?? null;
    if (!attemptedRefreshToken) return false;

    try {
      const session = await getAuthApi().apiV1AuthRefreshPost({
        refreshInput: { refreshToken: attemptedRefreshToken }
      });
      proSessionController?.applySession({
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        expiresInSeconds: session.expiresInSeconds
      });
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

// ─── withApiError: retry wrapper for generated client calls ──────────────────

export async function withApiError<T>(operation: () => Promise<T>, retry?: () => Promise<T>) {
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

// ─── fetchProAuthResponse: raw fetch with auth + retry ────────────────────────

export async function fetchProAuthResponse(
  path: string,
  init: RequestInit,
  token?: string,
  canRetryUnauthorized = true
): Promise<Response> {
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

export async function fetchWithProAuth<T>(
  path: string,
  init: RequestInit,
  token?: string,
  canRetryUnauthorized = true
): Promise<T> {
  const response = await fetchProAuthResponse(path, init, token, canRetryUnauthorized);
  return response.json() as Promise<T>;
}
