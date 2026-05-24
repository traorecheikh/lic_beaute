import { describe, it } from "vitest";
import { config } from "../../config.js";

describe("PayDunya Sandbox Invoice Test", () => {
  it("creates a checkout invoice and probes SoftPay endpoint", async () => {
    const MASTER_KEY = config.paydunyaMasterKey;
    const PRIVATE_KEY = config.paydunyaPrivateKey;
    const PAYDUNYA_TOKEN = config.paydunyaToken;

    if (!MASTER_KEY || !PRIVATE_KEY || !PAYDUNYA_TOKEN) {
      console.log("SKIP: No PayDunya credentials configured");
      return;
    }

    const headers = {
      "Content-Type": "application/json",
      "PAYDUNYA-MASTER-KEY": MASTER_KEY,
      "PAYDUNYA-PRIVATE-KEY": PRIVATE_KEY,
      "PAYDUNYA-TOKEN": PAYDUNYA_TOKEN
    };

    // Step 1: Create invoice on sandbox-api
    let invoiceToken = "";
    let checkoutUrl = "";
    try {
      const response = await fetch("https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create", {
        method: "POST",
        headers,
        body: JSON.stringify({
          invoice: { total_amount: 5000, description: "Test sandbox payment probe" },
          store: { name: "Beauté Avenue Test" }
        })
      });
      const raw = await response.text();
      console.log("Invoice response:", raw);
      const json = JSON.parse(raw);
      if (json.response_code === "00") {
        invoiceToken = json.token;
        checkoutUrl = `https://app.paydunya.com/sandbox-checkout/invoice/${json.token}`;
        console.log("Checkout URL:", checkoutUrl);
      } else {
        console.log("Invoice creation failed:", json.response_text);
        return;
      }
    } catch (err) {
      console.error("Invoice error:", err);
      return;
    }

    // Step 2: Test SoftPay per-method endpoint (lives under api/v1/ even in sandbox)
    const softpayUrl = "https://app.paydunya.com/api/v1/softpay/wave-senegal";
    try {
      const response = await fetch(softpayUrl, {
        method: "POST",
        headers,
        body: JSON.stringify({
          invoice_token: invoiceToken,
          customer_name: "Test",
          customer_email: "test@beauteavenue.sn",
          phone_number: "777777777",
          wave_senegal_payment_token: invoiceToken
        })
      });
      const raw = await response.text();
      console.log(`SoftPay wave-senegal -> ${response.status}:`, raw.slice(0, 200));
      // 200 with success=false is expected — actual payment requires real user interaction
      // 422 means invalid data (endpoint works)
    } catch (err: any) {
      console.error("SoftPay error:", err.message);
    }
  });
});
