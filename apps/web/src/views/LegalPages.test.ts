/* @vitest-environment jsdom */
import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import PrivacyPolicyPage from "./PrivacyPolicyPage.vue";
import TermsOfServicePage from "./TermsOfServicePage.vue";

describe("Legal pages text content and compliance", () => {
  const forbiddenPhrases = [
    "Beauté Avenue SAS",
    "NumuConnect SAS",
    "enregistrée au RCCM",
    "déclarée auprès de la CDP",
    "siège social situé à"
  ];

  it("renders PrivacyPolicyPage with correct headings and no forbidden phrases", () => {
    const wrapper = mount(PrivacyPolicyPage, {
      global: {
        stubs: {
          RouterLink: {
            template: "<a><slot /></a>"
          }
        }
      }
    });

    const html = wrapper.html().toLowerCase();
    expect(html).toContain("politique de confidentialité");
    expect(html).toContain("numuconnect");
    expect(html).toContain("2008-12");

    // Check for absence of forbidden phrases
    for (const phrase of forbiddenPhrases) {
      expect(html).not.toContain(phrase.toLowerCase());
    }
  });

  it("renders TermsOfServicePage with correct headings and no forbidden phrases", () => {
    const wrapper = mount(TermsOfServicePage, {
      global: {
        stubs: {
          RouterLink: {
            template: "<a><slot /></a>"
          }
        }
      }
    });

    const html = wrapper.html().toLowerCase();
    expect(html).toContain("conditions générales d'utilisation");
    expect(html).toContain("numuconnect");
    expect(html).toContain("2008-08");

    // Check for absence of forbidden phrases
    for (const phrase of forbiddenPhrases) {
      expect(html).not.toContain(phrase.toLowerCase());
    }
  });
});
