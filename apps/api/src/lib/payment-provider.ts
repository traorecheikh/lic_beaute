export function toDbProvider(provider: "intech" | "paydunya" | "manual" | null | undefined): "intech" | "paydunya" | "manual" | null {
  if (provider === "manual") return "manual";
  if (provider === "paydunya") return "paydunya";
  if (provider === "intech") return "intech";
  return null;
}

export function toPublicGatewayProvider(provider: string | null | undefined): "intech" | "paydunya" {
  if (!provider) return "intech";
  if (provider === "paydunya") return "paydunya";
  if (provider === "intech") return "intech";
  return "intech";
}

export function toPublicBillingProvider(provider: string | null | undefined): "intech" | "paydunya" | "manual" | null {
  if (!provider) return null;
  if (provider === "manual") return "manual";
  if (provider === "paydunya") return "paydunya";
  return "intech";
}
