# User Journeys & UX Audit

> **App:** Beauté Avenue (Mobile Client + Web Pro/Admin)
> **Date:** 2026-06-06
> **Scope:** Complete end-to-end user journeys across all surfaces

---

## 📱 Mobile App — Client Journeys

### 1. Discovery & Browsing

**Flow:** Splash → Onboarding → Home → Browse salons → Salon detail → Back to home

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 1.1 | SplashPage | ✅ | Brief loading, auto-transitions |
| 1.2 | OnboardingPage | ✅ | Good intro |
| 1.3 | AuthChoicePage (if not authenticated) | ⚠️ | "Continuer sans compte" leads to home, but favorites/notifications require auth. User hits wall later. |
| 1.4 | HomePage | ⚠️ | Hero image hardcoded from Unsplash (not salon-specific). Search bar has misaligned chevron |
| 1.5 | SalonsListPage / SalonDetailPage | ✅ | Well-structured with gallery, map, services, CTA |
| 1.6 | SalonDetail → Booking CTA | ⚠️ | 12-second prefetch timeout; if it fails, user gets error instead of navigating to booking anyway |

**Friction points:**
- Search bar hint "Salon, prestation, quartier..." leads to search page but the filter button is small
- No way to reorder salon lists (always by API order)
- Location permission banner dismissed permanently — user can't re-enable later without app restart

### 2. Authentication

**Flow:** Auth choice → Email login / Register (OTP) → Profile bootstrap → Payment setup → Home

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 2.1 | AuthChoicePage | ✅ | Clear CTA hierarchy |
| 2.2 | EmailLoginPage | ⚠️ | "Mot de passe oublié ?" shows toast "coming soon" — not implemented |
| 2.3 | RegisterPage | ⚠️ | No OTP resend timer/countdown. "Modifier l'email" just resets state instead of navigating back |
| 2.4 | OTP input (Pinput) | ✅ | Auto-submit on 6 digits |
| 2.5 | ProfileBootstrapPage | ✅ | Name + city, skippable unless required |
| 2.6 | PaymentMethodsPage | ✅ | Add mobile money, set default |

**Friction points:**
- **MISSING**: OTP resend countdown (user can spam "receive code" — rate-limited but no UX feedback)
- **MISSING**: Password reset flow (both mobile and web)
- Login with email only — no phone-based OTP login for clients

### 3. Booking Funnel

**Flow:** Service selection → Staff selection → Slot selection → Review → Payment → Success

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 3.1 | ServiceSelectionPage | ⚠️ | Single service auto-selects via postFrameCallback → causes flicker. "Continuer" should auto-advance |
| 3.2 | StaffSelectionPage | ⚠️ | "N'importe qui" triggers 5-day availability scan with no progress indicator |
| 3.3 | SlotSelectionPage | ✅ | Date strip + variant switcher. "Essayer le lendemain" on empty slots |
| 3.4 | BookingReviewPage | ✅ | Summary card, price breakdown, cancellation policy |
| 3.5 | PaymentHandoffPage | 🔴 | **Most complex page — see detailed issues below** |
| 3.6 | BookingSuccessPage | ✅ | Nice animation, share button, navigation |

**PaymentHandoffPage detailed issues:**
- **🔴 SECURITY**: Credit card fields (number, CVV, expiry) collected client-side — PCI DSS compliance risk
- **🔴 PERFORMANCE**: 3+ `addPostFrameCallback` calls causing rebuild chain
- **⚠️ INCONSISTENCY**: OTP dialog uses raw `TextField` with no formatting vs Pinput in auth
- **⚠️ COMPLEXITY**: Wizall OTP handled via separate dialog + re-execute — confusing sub-flow
- **⚠️ POLLING**: 5-minute timeout on payment waiting sheet — too long with no visible progress

### 4. Post-Booking Management

**Flow:** Bookings tab → Booking detail → Manage (reschedule/cancel) → Review

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 4.1 | BookingsListPage | ✅ | Tabs for upcoming/past, empty state with CTA |
| 4.2 | BookingDetailPage | ✅ | Status badge, info sections, actions |
| 4.3 | BookingManagePage | ✅ | Reschedule (reuses slot picker) or cancel |
| 4.4 | ReviewNewPage | ✅ | Star rating + comment |

**Friction points:**
- Cancellation dialog says "Non" / "Annuler" — confusing labels (one is cancel action, other is decline dialog)
- No "rate booking" reminder after successful visit (only shown on detail page)

### 5. Profile & Settings

**Flow:** Profile tab → View profile → Edit / Payment methods / Notifications / Logout

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 5.1 | ProfilePage | ✅ | Avatar, menu tiles, pending sync indicator |
| 5.2 | EditProfilePage | ✅ | Name, email, phone, avatar |
| 5.3 | PaymentMethodsPage | ✅ | Add/edit/delete with operator dropdown |
| 5.4 | NotificationsPage | ✅ | Toggle preferences |

**Friction points:**
- **MISSING**: Vouchers/promos feature is commented out — stale code in router
- **MISSING**: Memberships page exists but unclear what it shows
- Profile page: `pendingSyncCount` shows "Modifications en attente" but no "sync now" button

---

## 🌐 Web App — Pro Journeys

### 6. Landing & Professional Acquisition

**Flow:** Landing → Pro registration (4 steps) → Login

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 6.1 | LandingPage | ⚠️ | "Réserver maintenant" scrolls to `#client` section — no app download CTA |
| 6.2 | ProRegistrationPage (Step 1) | ✅ | Identity & salon info, good validation |
| 6.3 | ProRegistrationPage (Step 2) | ✅ | Category selection cards |
| 6.4 | ProRegistrationPage (Step 3) | ✅ | Team size visual cards |
| 6.5 | ProRegistrationPage (Step 4) | ⚠️ | Document uploads required — no draft save. If user closes, all data lost |
| 6.6 | ProLoginPage | ⚠️ | "Mot de passe oublié ?" shows toast "coming soon" — same as mobile |

**Friction points:**
- **MISSING**: Save draft/progress through registration (4-step form, data lost on refresh)
- **MISSING**: Phone number country selector is a dropdown — works but keyboard entry could be better
- Category API fallback is hardcoded list — if API returns unexpected names, icons fall back to generic

### 7. Pro Dashboard & Daily Operations

**Flow:** Login → Dashboard → Calendar → Inbox → Analytics

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 7.1 | ProLoginPage → redirect | ✅ | Token refresh, session restore |
| 7.2 | ProDashboardPage | ⚠️ | Manual booking modal + block modal embedded in dashboard — lot of code |
| 7.3 | ProCalendarPage | 🔴 | **7 separate API queries for week view** — performance issue |
| 7.4 | ProBookingInboxPage | ✅ | List + detail panel, filter pills |
| 7.5 | ProAnalyticsPage | ✅ | Charts and metrics |

**CalendarPage detailed issues:**
- **🔴 PERFORMANCE**: 7 individual week-day queries (weekD0–weekD6) fire 7 separate API calls
- **⚠️**: Staff colors computed by array index — colors change if staff order changes
- **⚠️**: Bookings and blocked slots can both be selected simultaneously
- **⚠️**: "Nouveau RDV" button appears in both header AND as floating action button — duplication

### 8. Service & Team Management

**Flow:** Services → Create/Edit → Deposit config → Team → Hours

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 8.1 | ProServicesPage | ⚠️ | Category field is free-text with datalist — may not match API categories |
| 8.2 | Service wizard (3-step modal) | ✅ | Well-designed with deposit options |
| 8.3 | Delete service | ⚠️ | Uses `confirm()` dialog instead of styled modal |
| 8.4 | ProTeamPage | ✅ | Staff management |

**Friction points:**
- Category input uses `<datalist>` which behaves differently across browsers — Safari doesn't support live filtering
- Delete confirmation uses native `confirm()` — inconsistent with rest of app (uses styled modals)
- Deposit percentage slider goes 5–100% in 5% steps — 5% minimum may be too low

### 9. Salon Profile & Location

**Flow:** Salon profile → Photos → Map → Contact info → Save

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 9.1 | ProSalonProfilePage | ⚠️ | Map initializes before data loads — renders default Dakar coordinates first |
| 9.2 | Photo upload | ✅ | File upload + URL input |
| 9.3 | Address autocomplete (Nominatim) | ⚠️ | `window.setTimeout` for search debounce not properly cleaned up |
| 9.4 | Map interaction | ✅ | Draggable marker, reverse geocode |

**Friction points:**
- Map initializes on mount but profile data may arrive later — flashes default position
- Photo gallery has no drag-to-reorder
- `locationQuery.value` is separate from `profile.address` — could desync

### 10. Subscription & Billing

**Flow:** Billing page → Plan comparison → Upgrade → Checkout (PayDunya) → Invoice history

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 10.1 | ProBillingPage | ✅ | Plan comparison, current plan hero |
| 10.2 | Checkout modal | 🔴 | **Most complex UI in app** — see below |
| 10.3 | Invoice history | ✅ | Download via API or URL |
| 10.4 | Payment method config | ⚠️ | Modal layout shifts when "Supprimer" button appears |
| 10.5 | Downgrade flow | ⚠️ | Calls checkout API for downgrade — semantically wrong endpoint |

**Checkout modal detailed issues:**
- **⚠️ COMPLEXITY**: 4-step process (method selection → details → Wizall OTP → waiting confirmation)
- **⚠️**: Wizall OTP sub-flow embedded in checkout — complex state management
- **⚠️**: External payment link handling has `shouldOpenPaydunyaLinkInSameTab` device detection — fragile

### 11. Admin Console

**Flow:** Admin login → Dashboard → Salons → Subscriptions → Audit → Config

| Step | Screen | UX OK? | Issues |
|------|--------|--------|--------|
| 11.1 | AdminLoginPage | ✅ | Clean, professional |
| 11.2 | AdminDashboardPage | ✅ | KPIs, alerts, shortcuts |
| 11.3 | SalonApprovalPage | ✅ | Queue management |
| 11.4 | SubscriptionsPage | 🔴 | **Memory leak** — see below |
| 11.5 | AuditPage | ✅ | Activity log |
| 11.6 | ConfigurationPage | ✅ | System settings |

**SubscriptionsPage issues:**
- **🔴 MEMORY LEAK**: `document.addEventListener('click', ...)` registered on component load, never removed
- Dropdown toggle uses string comparison for open/close state — one dropdown at a time
- Quick action "Résilier" uses `confirm()` before proceeding

---

## 🔴 Summary of Critical Issues

### Security
| ID | Issue | Severity | App |
|----|-------|----------|-----|
| S1 | Credit card fields (PCI-DSS data) collected client-side in PaymentHandoffPage | 🔴 Critical | Mobile |
| S2 | Subscription checkout also collects card info client-side | 🔴 Critical | Web |

### Performance
| ID | Issue | Severity | App |
|----|-------|----------|-----|
| P1 | Calendar week view fires 7 separate API queries | 🔴 High | Web |
| P2 | PaymentHandoffPage 3+ postFrameCallback chain causing rebuilds | 🟠 Medium | Mobile |
| P3 | SubscriptionsPage `document.addEventListener` never cleaned up (memory leak) | 🟠 Medium | Web |

### UX Consistency
| ID | Issue | Severity | App |
|----|-------|----------|-----|
| U1 | "Mot de passe oublié" shows toast on all login pages — no reset flow | 🟠 Medium | Both |
| U2 | OTP dialog uses TextField (mobile payment) vs Pinput (mobile auth) | 🟡 Low | Mobile |
| U3 | Delete confirmation uses `confirm()` in web services vs styled modals elsewhere | 🟡 Low | Web |
| U4 | Subscription downgrade calls checkout API endpoint | 🟡 Low | Web |
| U5 | Map flashes default coords before salon data loads | 🟡 Low | Web |
| U6 | No OTP resend timer/countdown on register page | 🟡 Low | Mobile |
| U7 | "ENVOYER AU CLIENT" copies to clipboard instead of actually sending | 🟡 Low | Web |
| U8 | Checkout payment method modal layout shifts with "Supprimer" button | 🟡 Low | Web |
| U9 | Registration 4-step form has no draft save — data lost on refresh | 🟡 Low | Web |
| U10 | Services category field uses free-text datalist — may mismatch API | 🟡 Low | Web |
| U11 | Calendar "Nouveau RDV" button duplicated (header + FAB) | 🟡 Low | Web |
| U12 | Vouchers/promos feature commented out — stale router code | 🟡 Low | Mobile |

### Flow Gaps
| ID | Issue | Severity | App |
|----|-------|----------|-----|
| F1 | Booking prefetch timeout (12s) blocks navigation entirely | 🟠 Medium | Mobile |
| F2 | No way to re-enable location permission banner after dismissal | 🟡 Low | Mobile |
| F3 | "Rate booking" only prompted on detail page — no push notification reminder | 🟡 Low | Mobile |

---

## ✅ Things Done Well

### Mobile App
- Smooth onboarding → auth → home transition with session persistence
- Beautiful home page with parallax hero, shimmer loading, and categorized sections
- Booking funnel step bar showing progress (1/4, 2/4, etc.)
- Payment method auto-detection from stored profile
- "Essayer le lendemain" when no slots available — nice recovery
- Success page with animation, share, and summary
- Stale data notices on booking detail
- Cancellation policy clearly shown
- Pending sync indicator on profile
- Favorites toggle with auth-gating via bottom sheet

### Web App
- Professional, cohesive design system with consistent styling
- Rich calendar with day/week views, staff columns, blocked slots overlays
- Multi-step service creation wizard with deposit configuration
- Salon profile with Leaflet map, Nominatim geocoding, interactive marker
- Subscription page with dark hero, plan comparison, marketing upsell
- Admin layout with dark theme, mobile scroll nav
- Grace period banner and subscription lock overlay
- Notification sound on new unread count
- Route guards for auth, role, approval status, subscription lock
