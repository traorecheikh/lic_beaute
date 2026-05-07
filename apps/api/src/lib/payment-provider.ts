export function toDbProvider(provider: "intech" | "paytech" | "manual" | null | undefined): "intech" | "paytech" | "manual" | null {
  if (provider === "manual") return "manual";
  if (provider === "paytech") return "paytech";
  if (provider === "intech") return "intech";
  return null;
}

export function toPublicGatewayProvider(provider: string | null | undefined): "intech" {
  if (!provider) return "intech";
  if (provider === "paytech" || provider === "intech") return "intech";
  return "intech";
}

export function toPublicBillingProvider(provider: string | null | undefined): "intech" | "manual" | null {
  if (!provider) return null;
  if (provider === "manual") return "manual";
  return "intech";
}
