import { describe, expect, it } from "vitest";

import {
  getPaydunyaLaunchLabel,
  isLikelyMobileDevice,
  isPaydunyaMethodAvailableForCountry,
  isSuccessfulSubscriptionCharge,
  requiresAsyncSubscriptionConfirmation,
  resolvePaydunyaLaunchTargets,
  resolvePaydunyaLaunchUrl,
  shouldOpenPaydunyaLinkInSameTab
} from "./pro-billing";

describe("isSuccessfulSubscriptionCharge", () => {
  it("treats only a succeeded charge as confirmed", () => {
    expect(isSuccessfulSubscriptionCharge({ status: "succeeded", subscriptionStatus: "active" })).toBe(true);
    expect(isSuccessfulSubscriptionCharge({ status: "authorized", subscriptionStatus: "active" })).toBe(false);
    expect(isSuccessfulSubscriptionCharge({ status: "pending", subscriptionStatus: "active" })).toBe(false);
  });
});

describe("requiresAsyncSubscriptionConfirmation", () => {
  it("waits for asynchronous provider confirmations even without redirect urls", () => {
    expect(requiresAsyncSubscriptionConfirmation({
      status: "authorized",
      message: "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le completer."
    })).toBe(true);

    expect(requiresAsyncSubscriptionConfirmation({
      status: "succeeded",
      data: { status: "PENDING" }
    })).toBe(true);

    expect(requiresAsyncSubscriptionConfirmation({
      status: "succeeded",
      message: "Paiement effectué avec succès."
    })).toBe(false);
  });
});

describe("isPaydunyaMethodAvailableForCountry", () => {
  it("keeps intl methods available across country selections", () => {
    expect(isPaydunyaMethodAvailableForCountry("intl", "sn")).toBe(true);
    expect(isPaydunyaMethodAvailableForCountry("intl", "ci")).toBe(true);
    expect(isPaydunyaMethodAvailableForCountry("sn", "sn")).toBe(true);
    expect(isPaydunyaMethodAvailableForCountry("sn", "ci")).toBe(false);
  });
});

describe("resolvePaydunyaLaunchUrl", () => {
  it("prefers deeplinks on mobile devices and hosted urls on desktop", () => {
    const result = {
      url: "https://app.paydunya.com/recharge-orange-sn?token=abc",
      other_url: {
        om_url: "https://orangemoneysn.page.link/abc",
        maxit_url: "https://sugu.orange-sonatel.com/abc"
      }
    };

    expect(resolvePaydunyaLaunchUrl(result, { userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X)" })).toBe(
      "https://orangemoneysn.page.link/abc"
    );
    expect(resolvePaydunyaLaunchUrl(result, { userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" })).toBe(
      "https://app.paydunya.com/recharge-orange-sn?token=abc"
    );
  });

  it("falls back to deeplinks when no hosted provider url exists", () => {
    expect(resolvePaydunyaLaunchUrl({
      other_url: {
        om_url: "https://orangemoneysn.page.link/abc"
      }
    }, { userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" })).toBe("https://orangemoneysn.page.link/abc");
  });
});

describe("resolvePaydunyaLaunchTargets", () => {
  it("keeps both deeplinks and hosted fallback available for waiting-state relaunches", () => {
    expect(resolvePaydunyaLaunchTargets({
      url: "https://app.paydunya.com/recharge-orange-sn?token=abc",
      other_url: {
        om_url: "https://orangemoneysn.page.link/abc",
        maxit_url: "https://sugu.orange-sonatel.com/abc"
      }
    }, { userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X)" })).toEqual({
      preferredUrl: "https://orangemoneysn.page.link/abc",
      hostedUrl: "https://app.paydunya.com/recharge-orange-sn?token=abc",
      deeplinkUrls: [
        "https://orangemoneysn.page.link/abc",
        "https://sugu.orange-sonatel.com/abc"
      ]
    });
  });
});

describe("isLikelyMobileDevice", () => {
  it("detects touch macs and phone user agents as mobile", () => {
    expect(isLikelyMobileDevice({ userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X)" })).toBe(true);
    expect(
      isLikelyMobileDevice({
        userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
        maxTouchPoints: 5
      })
    ).toBe(true);
    expect(isLikelyMobileDevice({ userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" })).toBe(false);
  });
});

describe("shouldOpenPaydunyaLinkInSameTab", () => {
  it("keeps mobile https deeplinks in the current tab so the OS can hand off to the wallet app", () => {
    expect(
      shouldOpenPaydunyaLinkInSameTab("https://sugu.orange-sonatel.com/mp/abc", {
        userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X)"
      })
    ).toBe(true);
    expect(
      shouldOpenPaydunyaLinkInSameTab("https://app.paydunya.com/recharge-orange-sn?token=abc", {
        userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
      })
    ).toBe(false);
    expect(shouldOpenPaydunyaLinkInSameTab("wave://payment/abc")).toBe(true);
  });
});

describe("getPaydunyaLaunchLabel", () => {
  it("maps known PayDunya deeplinks and hosted urls to explicit labels", () => {
    expect(getPaydunyaLaunchLabel("https://orangemoneysn.page.link/abc")).toBe("Orange Money");
    expect(getPaydunyaLaunchLabel("https://sugu.orange-sonatel.com/mp/abc")).toBe("Maxit");
    expect(getPaydunyaLaunchLabel("https://pay.wave.com/c/abc")).toBe("Wave");
    expect(getPaydunyaLaunchLabel("https://app.paydunya.com/recharge-orange-sn?token=abc")).toBe("la page PayDunya");
  });
});
