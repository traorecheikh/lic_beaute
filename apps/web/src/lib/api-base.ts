function normalizeLocalhost(url: string): string {
  return url.replace("http://localhost:", "http://127.0.0.1:");
}

export function resolveApiBaseUrl(): string {
  const configuredBase = (import.meta.env.VITE_API_URL as string | undefined) ?? "";

  if (configuredBase.startsWith("http")) {
    return normalizeLocalhost(configuredBase);
  }

  const runtimeOrigin =
    typeof window !== "undefined" ? window.location.origin : "http://127.0.0.1:3000";
  return normalizeLocalhost(`${runtimeOrigin}${configuredBase}`);
}
