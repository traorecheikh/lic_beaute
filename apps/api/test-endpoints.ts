import { config } from "./src/config.js";

async function triggerRealDisbursement() {
  const getUrl = `https://app.paydunya.com/api/v2/disburse/get-invoice`;
  const submitUrl = `https://app.paydunya.com/api/v2/disburse/submit-invoice`;
  
  console.log(`Step 1: Fetching disburse token from ${getUrl}...`);
  try {
    const getResponse = await fetch(getUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "PAYDUNYA-MASTER-KEY": config.paydunyaMasterKey,
        "PAYDUNYA-PRIVATE-KEY": config.paydunyaPrivateKey,
        "PAYDUNYA-TOKEN": config.paydunyaToken
      },
      body: JSON.stringify({
        account_alias: "781706184",
        amount: 200,
        withdraw_mode: "wave-senegal",
        callback_url: "https://httpbin.org/post"
      }),
      signal: AbortSignal.timeout(10_000)
    });

    const getJson = await getResponse.json() as Record<string, any>;
    console.log(`Step 1 Status: ${getResponse.status}`, getJson);

    if (getJson.response_code !== "00") {
      console.error("Step 1 failed, aborting.");
      return;
    }

    const token = getJson.disburse_token;
    const disburseId = "ref_" + Date.now();
    console.log(`Step 2: Submitting disburse token ${token} with disburse_id ${disburseId} to ${submitUrl}...`);

    const submitResponse = await fetch(submitUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "PAYDUNYA-MASTER-KEY": config.paydunyaMasterKey,
        "PAYDUNYA-PRIVATE-KEY": config.paydunyaPrivateKey,
        "PAYDUNYA-TOKEN": config.paydunyaToken
      },
      body: JSON.stringify({
        disburse_invoice: token,
        disburse_id: disburseId
      }),
      signal: AbortSignal.timeout(10_000)
    });

    const submitJson = await submitResponse.json() as Record<string, any>;
    console.log(`Step 2 Status: ${submitResponse.status}`, submitJson);
  } catch (err: any) {
    console.error(`Error executing disbursement:`, err.message || err);
  }
}

triggerRealDisbursement();
