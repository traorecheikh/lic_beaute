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

export function resolvePaydunyaLaunchUrl(
  result: ProSubscriptionExecuteLikeResult,
  device: { userAgent?: string; maxTouchPoints?: number } = {}
): string | null {
  const providerUrl = typeof result.url === "string" && result.url.length > 0 ? result.url : null;
  const otherUrl = result.other_url && typeof result.other_url === "object"
    ? result.other_url as { om_url?: string; maxit_url?: string }
    : null;
  const omUrl = typeof otherUrl?.om_url === "string" && otherUrl.om_url.length > 0 ? otherUrl.om_url : null;
  const maxitUrl = typeof otherUrl?.maxit_url === "string" && otherUrl.maxit_url.length > 0 ? otherUrl.maxit_url : null;
  const deepLink = omUrl ?? maxitUrl;

  if (isLikelyMobileDevice(device) && deepLink) return deepLink;
  return providerUrl ?? deepLink ?? null;
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
