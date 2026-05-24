export function toDbProvider(provider: "paydunya" | "manual" | null | undefined): "paydunya" | "manual" | null {
  if (provider === "manual") return "manual";
  if (provider === "paydunya") return "paydunya";
  return null;
}

export function toPublicGatewayProvider(provider: string | null | undefined): "paydunya" {
  if (provider === "paydunya") return "paydunya";
  return "paydunya";
}

export function toPublicBillingProvider(provider: string | null | undefined): "paydunya" | "manual" | null {
  if (!provider) return null;
  if (provider === "manual") return "manual";
  if (provider === "paydunya") return "paydunya";
  return null;
}
