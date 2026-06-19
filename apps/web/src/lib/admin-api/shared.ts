import { resolveApiBaseUrl } from "../api-base";

/**
 * Error class for API errors with status code, error code, and optional field.
 */
export class ApiError extends Error {
  readonly field: string | undefined;
  constructor(
    readonly statusCode: number,
    readonly code: string,
    message: string,
    field?: string
  ) {
    super(message);
    this.field = field;
  }
}

type AuthSession = {
  accessToken: string;
  refreshToken: string;
  expiresInSeconds: number;
};

type AdminSessionController = {
  getAccessToken(): string | null;
  getRefreshToken(): string | null;
  applySession(session: AuthSession): void;
  clearSessionIfRefreshTokenMatches(refreshToken: string | null): void;
};

export type { AuthSession, AdminSessionController };

const apiBaseUrl = resolveApiBaseUrl();
let adminSessionController: AdminSessionController | null = null;
let refreshPromise: Promise<boolean> | null = null;

export function registerAdminSessionController(controller: AdminSessionController) {
  adminSessionController = controller;
}

export function getAdminBaseUrl(): string {
  return apiBaseUrl;
}

export function getAdminSessionController(): AdminSessionController | null {
  return adminSessionController;
}

function buildUrl(path: string, query?: Record<string, string | undefined>) {
  const url = new URL(path, apiBaseUrl);

  if (query) {
    for (const [key, value] of Object.entries(query)) {
      if (value) {
        url.searchParams.set(key, value);
      }
    }
  }

  return url.toString();
}

function shouldRetryWithRefresh(path: string, headers: Headers) {
  return !path.startsWith("/api/v1/auth/") && headers.has("authorization") && adminSessionController !== null;
}

export { buildUrl, shouldRetryWithRefresh };

async function refreshSessionWithSingleFlight(): Promise<boolean> {
  if (!adminSessionController) return false;
  if (refreshPromise) return refreshPromise;

  refreshPromise = (async () => {
    const attemptedRefreshToken = adminSessionController?.getRefreshToken() ?? null;
    if (!attemptedRefreshToken) return false;

    try {
      const session = await request<AuthSession>("/api/v1/auth/refresh", {
        method: "POST",
        body: JSON.stringify({ refreshToken: attemptedRefreshToken })
      });
      adminSessionController?.applySession(session);
      return true;
    } catch {
      adminSessionController?.clearSessionIfRefreshTokenMatches(attemptedRefreshToken);
      return false;
    } finally {
      refreshPromise = null;
    }
  })();

  return refreshPromise;
}

export { refreshSessionWithSingleFlight };

export function authHeaders(token: string) {
  return {
    authorization: `Bearer ${token}`
  };
}

export async function request<T>(
  path: string,
  options: RequestInit = {},
  query?: Record<string, string | undefined>,
  canRetryUnauthorized = true
) {
  const headers = new Headers(options.headers ?? {});
  const response = await fetch(buildUrl(path, query), {
    ...options,
    headers: {
      ...(options.body != null ? { "Content-Type": "application/json" } : {}),
      ...Object.fromEntries(headers.entries())
    }
  });

  if (response.status === 401 && canRetryUnauthorized && shouldRetryWithRefresh(path, headers)) {
    const refreshed = await refreshSessionWithSingleFlight();
    if (refreshed) {
      const nextToken = adminSessionController?.getAccessToken();
      if (nextToken) {
        const retryHeaders = new Headers(options.headers ?? {});
        retryHeaders.set("authorization", `Bearer ${nextToken}`);
        return request<T>(path, { ...options, headers: retryHeaders }, query, false);
      }
    }
  }

  if (!response.ok) {
    const fallback = { code: "unknown_error", message: "Une erreur est survenue." };
    const payload = (await response.json().catch(() => fallback)) as { code?: string; message?: string; field?: string };
    throw new ApiError(response.status, payload.code ?? fallback.code, payload.message ?? fallback.message, payload.field);
  }

  return (await response.json()) as T;
}
