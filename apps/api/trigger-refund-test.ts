import { createPaymentAdapter } from "./src/adapters/index.js";
import { config } from "./src/config.js";

async function run() {
  console.log("PayDunya Environmental Setup:", config.paydunyaEnv);
  
  const adapter = createPaymentAdapter("paydunya", {
    paydunyaMasterKey: config.paydunyaMasterKey,
    paydunyaPublicKey: config.paydunyaPublicKey,
    paydunyaPrivateKey: config.paydunyaPrivateKey,
    paydunyaToken: config.paydunyaToken,
    paydunyaEnv: config.paydunyaEnv,
    baseOrigin: config.webOrigin,
    paydunyaBaseUrl: config.paydunyaBaseUrl,
  });

  const phone = "781706184";
  const amount = 200;
  
  console.log(`Triggering disburse of ${amount} XOF to phone number ${phone} (Wave)...`);
  try {
    const res = await adapter.requestRefund({
      providerRef: "manual_test_cli_" + Date.now(),
      amountXof: amount,
      reason: "Test refund Beauté Avenue via CLI",
      phone: phone,
      withdrawMode: "wave-senegal"
    });
    console.log("SUCCESS! Refund/Disbursement Invoice Token:", res.refundRef);
  } catch (err: any) {
    console.error("FAILED to trigger refund/disbursement:", err.message || err);
  }
}

run();
