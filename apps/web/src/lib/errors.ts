import { ApiError } from "./api";

export function getErrorMessage(error: unknown, fallback: string) {
  // In production, do not expose raw server error messages to users
  if (import.meta.env.PROD) {
    return fallback;
  }
  return error instanceof ApiError || error instanceof Error ? error.message : fallback;
}
