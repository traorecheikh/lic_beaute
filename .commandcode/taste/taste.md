# paydunya
See [paydunya/taste.md](paydunya/taste.md)
# workflow
- Validate fixes by running the Docker build locally before committing and pushing. Confidence: 0.85
- When a user asks how to access/verify something on a server they have SSH to, execute the command and show the result instead of just explaining the command. Confidence: 0.75
- When fixing a systemic UI issue (e.g., navbar overlap affecting all ShellRoute pages), audit and fix ALL affected screens comprehensively instead of fixing just one occurrence. Confidence: 0.75

# ui
- Display form validation errors as field-level inline messages with red borders on the specific input fields, not as a generic message below the form. Confidence: 0.65

# architecture
- Expose business rules (subscription features, payment method availability, deposit settings, auto-renewal, reports access) as admin-configurable settings that can be changed without code changes or redeployment. Confidence: 0.88
- Seed subscription_features settings in both seed-impl.ts (local dev) and seed-admin.ts (production). Confidence: 0.70
- When removing a billing provider (e.g., Intech), audit and prune it across all layers: DB seeds, admin UI, pro-facing API, and frontend components. Confidence: 0.70
- Default `feature_billing_paydunya` to enabled (`true`) in subscription_features seed data. Confidence: 0.70

# ui
See [ui/taste.md](ui/taste.md)
# architecture
- When implementing uniqueness validation for pro registration, include salon name (nom de salon) alongside email and phone. Confidence: 0.65
- When introducing new alternative functionality (e.g., Universal/App Links alongside a custom scheme), keep the existing proven approach working as a fallback — only make the new approach primary after thorough testing. Confidence: 0.70

# deployment
- Gate new or experimental features behind environment variable flags (e.g., `RESTRICTED_FEATURE=on`). When the flag is unset or has any other value, the feature should be hidden entirely with a graceful fallback. Confidence: 0.70
- For staging deployments, use the project's actual configured drivers/services (email, OTP, payment) instead of defaulting to `noop` or `mock` placeholders. Confidence: 0.60
- Configure services (email, payment, OTP drivers) via environment variables, not by patching compiled files or source code. Confidence: 0.85
- Let Coolify handle Docker pulls and restarts automatically after a git push instead of manually SSH-ing to run docker pull/restart. Confidence: 0.70

# mobile
See [mobile/taste.md](mobile/taste.md)
