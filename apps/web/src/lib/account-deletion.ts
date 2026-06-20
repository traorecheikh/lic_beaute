import { ApiError } from "./admin-api/shared";

const API_BASE = "";

export async function requestAccountDeletion(email: string): Promise<{ sent: boolean }> {
  const response = await fetch(`${API_BASE}/api/v1/auth/request-deletion`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email }),
  });
  if (!response.ok) {
    const payload = await response.json().catch(() => ({ code: "error", message: "Erreur" })) as { code?: string; message?: string };
    throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Erreur lors de l'envoi.");
  }
  return response.json() as Promise<{ sent: boolean }>;
}

export async function confirmAccountDeletion(
  token: string,
  email: string,
  reasons?: string[],
  feedback?: string,
): Promise<{ deleted: boolean }> {
  const response = await fetch(`${API_BASE}/api/v1/auth/confirm-deletion`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ token, email, reasons, feedback }),
  });
  if (!response.ok) {
    const payload = await response.json().catch(() => ({ code: "error", message: "Erreur" })) as { code?: string; message?: string };
    throw new ApiError(response.status, payload.code ?? "error", payload.message ?? "Erreur lors de la suppression.");
  }
  return response.json() as Promise<{ deleted: boolean }>;
}
