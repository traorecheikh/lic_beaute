# paydunya
- Use `app.paydunya.com/sandbox-api/v1` (not `sandbox.paydunya.com`) as the sandbox API base URL. Confidence: 0.80
- Use `/checkout-invoice/create` (not `/softpay/create-invoice`) for creating payment invoices. Confidence: 0.80
- Use per-method SoftPay endpoints (e.g., `/softpay/wave-senegal`, `/softpay/orange-money-senegal`) instead of `/softpay/confirm` for executing payments. Confidence: 0.80
- The IPN callback hash is SHA-512 of the MasterKey, not token+privateKey+invoice_data. Confidence: 0.70
- Items in the invoice payload should be an object with numeric keys (item_0, item_1) not an array. Confidence: 0.65
