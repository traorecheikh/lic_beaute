# paydunya
- Use `app.paydunya.com/sandbox-api/v1` (not `sandbox.paydunya.com`) as the sandbox API base URL. Confidence: 0.80
- Use `/checkout-invoice/create` (not `/softpay/create-invoice`) for creating payment invoices. Confidence: 0.80
- Use per-method SoftPay endpoints (e.g., `/softpay/wave-senegal`, `/softpay/orange-money-senegal`) instead of `/softpay/confirm` for executing payments. Confidence: 0.80
- The IPN callback hash is SHA-512 of the MasterKey, not token+privateKey+invoice_data. Confidence: 0.70
- Items in the invoice payload should be an object with numeric keys (item_0, item_1) not an array. Confidence: 0.65

# workflow
- Validate fixes by running the Docker build locally before committing and pushing. Confidence: 0.85
- When a user asks how to access/verify something on a server they have SSH to, execute the command and show the result instead of just explaining the command. Confidence: 0.75

# ui
- Display form validation errors as field-level inline messages with red borders on the specific input fields, not as a generic message below the form. Confidence: 0.65

# deployment
- For staging deployments, use the project's actual configured drivers/services (email, OTP, payment) instead of defaulting to `noop` or `mock` placeholders. Confidence: 0.60
- Configure services (email, payment, OTP drivers) via environment variables, not by patching compiled files or source code. Confidence: 0.85
- Let Coolify handle Docker pulls and restarts automatically after a git push instead of manually SSH-ing to run docker pull/restart. Confidence: 0.70
