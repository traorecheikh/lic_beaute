# flutter
- Run 'npx jscpd lib --min-lines 5 --min-tokens 40 --reporters console' to check code duplication. Confidence: 0.70
- Use 'flutter run' without additional arguments for running the app. Confidence: 0.65

# workflow
- Coordinate between multiple AI agents via an agent-meet.md file. Read it before starting any task and append your current task. Confidence: 0.70
- Exclude AI agent files, UX examples, Design.md, and non-essential plan documents from git via .gitignore. Confidence: 0.65

# code-style
- Wire all features fully to the backend with real API calls. No mock or fake implementations. Confidence: 0.80
- Store domain data (document types, categories, pricing, settings) in database-backed configuration tables, not hardcoded in UI components. Confidence: 0.70

# payment-integration
- Use backend-only payment integration with a custom frontend instead of third-party Flutter SDKs. Confidence: 0.75
- When replacing a payment provider, fully remove deprecated providers (Wave, Orange Money) rather than maintaining backward compatibility. Confidence: 0.65

# testing
- Write heavy unit tests for payment webhooks to ensure no breaking changes and that webhooks are never missed. Confidence: 0.70

# workflow
- Write plan files to ~/.commandcode/plans/ using absolute paths, not relative paths. Confidence: 0.65

# web-admin
- Use Heroicons exclusively for icons; never use emojis in UI components. Confidence: 0.70
- Use Inter font exclusively; no decorative/display fonts like Cormorant Garamond or Sora. Confidence: 0.70
- Centralize UI primitives (TextField, Dropdown, buttons) into shared widget components to prevent design drift and duplication. Confidence: 0.65

# feature-visibility
- Hide promos/vouchers (codes promo) features from all UIs; do not delete the code, just hide it. Keep salon subscription (abonnement) features visible. Confidence: 0.80

# api-contracts
- Use OpenAPI Generator to create API clients from Zod schemas; generate both TypeScript fetch and Dart Dio clients. Confidence: 0.80
- Follow contract-first development: Zod schemas → OpenAPI spec → generated clients. Confidence: 0.75

# flutter
- Run 'flutter analyze' and fix all issues before considering work complete. Confidence: 0.85
- Use presigned URL pattern for file uploads: backend generates presigned PUT URL, client uploads directly to storage, backend verifies via HEAD request. Confidence: 0.80

# infrastructure
- Implement real infrastructure integrations (FCM, SMS, storage) with actual API calls; no skeleton or mock implementations. Confidence: 0.85

# code-review
- When providing a code review, implement fixes for all identified issues (blocking, important, and nits), not just identify them. Confidence: 0.75
