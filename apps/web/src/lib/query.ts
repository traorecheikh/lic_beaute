import { ApiError } from "./api";

export function shouldRetryAdminQuery(failureCount: number, error: unknown) {
  if (error instanceof ApiError && error.statusCode >= 400 && error.statusCode < 500) {
    return false;
  }

  return failureCount < 2;
}
