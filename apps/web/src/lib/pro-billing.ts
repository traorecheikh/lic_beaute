export type ProSubscriptionChargeStatusResult = {
  status?: string;
  subscriptionStatus?: string;
};

export type ProSubscriptionExecuteLikeResult = {
  status?: string;
  message?: string;
  url?: string;
  other_url?: {
    om_url?: string;
    maxit_url?: string;
  } | unknown;
  data?: Record<string, unknown>;
  pendingProviderConfirmation?: boolean;
};

export type PaydunyaLaunchTargets = {
  preferredUrl: string | null;
  hostedUrl: string | null;
  deeplinkUrls: string[];
};

export function getPaydunyaLaunchLabel(url: string | null): string {
  if (!url) return "le moyen de paiement";
  const normalized = url.toLowerCase();
  if (normalized.includes("orangemoneysn.page.link")) return "Orange Money";
  if (normalized.includes("sugu.orange-sonatel.com")) return "Maxit";
  if (normalized.includes("pay.wave.com")) return "Wave";
  if (normalized.includes("app.paydunya.com") || normalized.includes("paydunya.com")) {
    return "la page PayDunya";
  }
  return "le moyen de paiement";
}

export function isLikelyMobileDevice(
  device: { userAgent?: string; maxTouchPoints?: number } = {}
): boolean {
  const userAgent = device.userAgent ?? "";
  const maxTouchPoints = device.maxTouchPoints ?? 0;
  return (
    /android|iphone|ipad|ipod|mobile/i.test(userAgent) ||
    (/macintosh/i.test(userAgent) && maxTouchPoints > 1)
  );
}

export function isSuccessfulSubscriptionCharge(result: ProSubscriptionChargeStatusResult): boolean {
  return result.status === "succeeded";
}

export function isPaydunyaMethodAvailableForCountry(methodCountry: string, selectedCountry: string): boolean {
  return methodCountry === "intl" || methodCountry === selectedCountry;
}

export function resolvePaydunyaLaunchTargets(
  result: ProSubscriptionExecuteLikeResult,
  device: { userAgent?: string; maxTouchPoints?: number } = {}
): PaydunyaLaunchTargets {
  const providerUrl = typeof result.url === "string" && result.url.length > 0 ? result.url : null;
  const otherUrl = result.other_url && typeof result.other_url === "object"
    ? result.other_url as { om_url?: string; maxit_url?: string }
    : null;
  const deeplinkUrls = [otherUrl?.om_url, otherUrl?.maxit_url]
    .filter((value): value is string => typeof value === "string" && value.length > 0);
  const preferredUrl = isLikelyMobileDevice(device)
    ? deeplinkUrls[0] ?? providerUrl ?? null
    : providerUrl ?? deeplinkUrls[0] ?? null;

  return {
    preferredUrl,
    hostedUrl: providerUrl,
    deeplinkUrls
  };
}

export function resolvePaydunyaLaunchUrl(
  result: ProSubscriptionExecuteLikeResult,
  device: { userAgent?: string; maxTouchPoints?: number } = {}
): string | null {
  return resolvePaydunyaLaunchTargets(result, device).preferredUrl;
}

export function shouldOpenPaydunyaLinkInSameTab(
  url: string,
  device: { userAgent?: string; maxTouchPoints?: number } = {}
): boolean {
  if (!/^https?:\/\//i.test(url)) return true;
  return isLikelyMobileDevice(device);
}

export function requiresAsyncSubscriptionConfirmation(result: ProSubscriptionExecuteLikeResult): boolean {
  if (result.url || result.other_url) return true;
  if (result.pendingProviderConfirmation === true || result.status === "authorized") return true;

  const message = typeof result.message === "string"
    ? result.message.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase()
    : "";
  if (
    message.includes("rediriger vers cette url") ||
    message.includes("en cours de traitement") ||
    message.includes("veuillez completer le paiement") ||
    message.includes("veuillez tapez") ||
    message.includes("compose") ||
    message.includes("valider le paiement")
  ) {
    return true;
  }

  const details = result.data && typeof result.data.details === "object" && result.data.details
    ? result.data.details as Record<string, unknown>
    : null;
  const providerStatus = typeof result.data?.status === "string" ? result.data.status.toUpperCase() : null;
  if (providerStatus === "PENDING" || providerStatus === "PROCESSING") return true;
  const cid = typeof result.data?.cid === "string" ? result.data.cid : typeof details?.cid === "string" ? details.cid : null;
  return Boolean(cid);
}
