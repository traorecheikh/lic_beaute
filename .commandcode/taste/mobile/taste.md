# mobile
- For mobile client authentication, use email-only login — disable phone number login entirely and send OTP via email for account creation. Confidence: 0.65
- Service categories should be fixed enum values (not free-text input) since they impact search/filtering and marketplace discoverability. Confidence: 0.70
- Include email masking/validation and password visibility toggle with validation in the mobile client login form. Confidence: 0.60
- Use a `.env` file (loaded at runtime) for mobile client configuration values like API base URL instead of hardcoding them in Dart source code. Confidence: 0.80
- Apply salon marketplace filtering criteria (logo uploaded, approvalStatus=approved, canReceiveBookings=true, isVisibleInMarketplace=true, at least 1 active service, at least 1 active employee) at the API query level, not just client-side filtering. Confidence: 0.75
- When migrating app identifiers (package name, bundle ID), purge stale references to the old identifier from all configuration files (pubspec.yaml, Info.plist, etc.). Confidence: 0.80
- When asked about or directed to work on "mobile" features, scope all work (code, content, answers) to the mobile client exclusively — do not create web pages, web routes, or web-only features unless explicitly directed otherwise. Confidence: 0.90
- When auditing mobile ↔ backend interaction, scope the review to mobile client code and backend API endpoints only — exclude infrastructure/deployment files (Docker, nginx, docker-compose, CI/CD config). Confidence: 0.70
