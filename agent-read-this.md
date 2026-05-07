````md
# Feature Scope Guardrails for Agents

## Purpose

This document defines mandatory rules for any agent working on the project.

The goal is simple: agents must implement only what was requested, preserve every requested feature, and avoid adding irrelevant technical or architectural work that does not directly improve the client-facing product.

The client cares about the application, its usability, and the features they asked for. The client does not care about the technology stack, internal architecture, framework preferences, database elegance, or engineering vanity projects pretending to be requirements.

---

## Non-Negotiable Rules

### 1. Do not add unrequested features

Agents have no permission to add features that were not explicitly requested.

This includes:

- Extra screens
- Extra buttons
- Extra user roles
- Extra workflows
- Extra settings
- Extra dashboards
- Extra analytics
- Extra automations
- Extra notification types
- Extra payment behavior
- Extra moderation tools
- Extra onboarding steps
- Extra “nice to have” improvements

If a feature was not requested, it must not be implemented.

Good intentions are not scope. Assumptions are not requirements. Creativity is not authorization.

---

### 2. Do not omit requested features without asking

Agents must not remove, skip, simplify, delay, or silently ignore a requested feature.

Before omitting anything, the agent must ask the user/client for explicit approval.

This applies even when the agent thinks the feature is:

- Too complex
- Not useful
- Hard to implement
- Bad UX
- Technically risky
- Better handled later
- Better replaced by another feature
- Outside the agent’s preferred architecture

The agent may explain the concern, but it must not omit the feature without approval.

Mandatory wording pattern:

> This requested feature may create an issue because [reason]. Do you want to keep it, modify it, or remove it?

Until the user/client answers, the requested feature remains in scope.

---

### 3. Ask before changing feature behavior

Agents must ask before changing the behavior of a requested feature.

The following count as behavior changes:

- Replacing one flow with another
- Making a required step optional
- Making an optional step required
- Changing who can access a feature
- Changing when a user sees a feature
- Changing what data is collected
- Changing payment rules
- Changing booking rules
- Changing notification timing
- Changing cancellation or refund logic

If the behavior changes from what was requested, the agent must stop and ask.

---

### 4. Architecture is not product scope

Agents must not treat architecture, frameworks, infrastructure, or stack choices as client-facing requirements unless the user explicitly asks for technical implementation.

The following are not product features:

- React Native
- NestJS
- PostgreSQL
- Redis
- Microservices
- API Gateway
- Docker
- CI/CD
- AWS
- DigitalOcean
- Firebase
- WebSockets
- Monitoring tools
- Logging systems
- DevOps pipelines

These may matter internally, but they are not reasons to add, remove, or change product features.

The product must be described and delivered in terms of user value:

- Can the client book a service?
- Can the salon manage appointments?
- Can the salon define services and prices?
- Can the user pay an advance when required?
- Can the user receive confirmations and reminders?
- Can the admin validate salons?

Architecture supports features. It does not define them.

---

### 5. Client-facing usability comes first

When explaining or planning work for the client, agents must focus on usability and feature outcomes, not technical implementation.

Bad:

> We will use Redis with Bull queues for asynchronous notification processing.

Better:

> Users will receive booking confirmations and appointment reminders reliably, even when traffic increases.

Bad:

> We will use PostGIS for geospatial queries.

Better:

> Users can find nearby salons based on their location.

Bad:

> We will use JWT and refresh tokens.

Better:

> Users can securely log in and stay connected without repeatedly entering their details.

The client buys a working app, not a museum exhibit for software architecture.

---

## Source of Truth for Features

Agents must use the requested product features as the source of truth.

A feature is considered in scope only if it appears in one of these places:

1. The user/client explicitly requested it.
2. The approved functional specification includes it.
3. The user/client approved it after the agent asked.

A feature is not in scope just because:

- It is common in similar apps
- It would be “standard”
- It would be easy to add
- It would make the architecture cleaner
- It would help future scalability
- The agent thinks users may want it
- The agent saw it in a template or boilerplate

---

## Mandatory Scope Control Process

Before implementing anything, the agent must classify the task.

### Step 1: Identify requested features

List only the features explicitly requested.

Example:

```md
Requested features:
- Client can search salons
- Client can book an appointment
- Salon can manage availability
- Premium salon can request an advance payment
````

### Step 2: Identify assumptions

List anything that is unclear or not directly stated.

Example:

```md
Assumptions requiring confirmation:
- Should clients be able to reschedule appointments?
- Should salons manually confirm bookings?
- Should advance payment be fixed or percentage-based?
```

### Step 3: Ask before deciding

If a decision affects product behavior, the agent must ask.

The agent may make technical implementation choices only when they do not affect the visible feature behavior.

### Step 4: Implement only approved scope

The agent must implement only the confirmed features.

No extras. No silent omissions. No “while I was here” improvements. Humanity has suffered enough from that phrase.

---

## Rules for Omissions

A requested feature can only be omitted if one of the following is true:

1. The user/client explicitly says to remove it.
2. The user/client agrees to postpone it.
3. The feature is technically impossible in the current environment, and the agent clearly explains why.
4. The feature is unsafe, illegal, or violates policy, and the agent explains the restriction.

If none of these conditions apply, the feature must remain in scope.

Agents must never write:

* “I skipped this for simplicity.”
* “This can be added later.”
* “This is out of scope.”
* “This is unnecessary.”
* “I replaced it with a better approach.”

Unless the user/client already approved that decision.

---

## Rules for Additions

A new feature can only be added if the user/client explicitly approves it.

When the agent sees a potentially useful feature, it must present it as optional, not implement it directly.

Correct format:

```md
Optional suggestion, not implemented:
- Add salon loyalty rewards so returning clients can receive discounts.

Reason:
- This may improve retention, but it was not part of the requested scope.

Decision needed:
- Approve, reject, or save for later.
```

Until approved, the feature must not be implemented.

---

## Feature vs Architecture Separation

Agents must separate product features from technical implementation.

### Product feature examples

These affect users directly:

* Search salons
* Filter by category, price, rating, or distance
* View salon details
* Add salons to favorites
* Book appointments
* Receive SMS or push confirmations
* Cancel or modify appointments according to salon rules
* Rate salons after appointments
* Salon creates and edits services
* Salon manages staff availability
* Salon accepts or refuses bookings
* Salon blocks unavailable time slots
* Salon views business dashboard
* Premium salon requests advance payment
* Admin validates salons

### Architecture examples

These are internal implementation details:

* API Gateway
* Microservices
* PostgreSQL schema
* Redis cache
* Message queue
* JWT tokens
* Docker containers
* CI/CD workflows
* Monitoring stack
* Cloud hosting provider

Agents may discuss architecture only when the task is explicitly technical or when it is necessary to explain implementation constraints.

Architecture must not create new product scope.

---

## Required Questions Before Proceeding

The agent must ask before proceeding when:

* A requested feature is ambiguous
* Two requested features conflict
* A feature appears expensive or risky
* The agent wants to omit a feature
* The agent wants to simplify a feature
* The agent wants to replace a feature
* The agent wants to add a new feature
* The architecture would change visible app behavior

The agent must not ask just to avoid work. A question is required only when the answer affects product scope or user behavior.

---

## Forbidden Agent Behaviors

Agents must not:

* Invent features
* Remove features silently
* Replace requested features with alternatives
* Convert business requirements into architecture-only work
* Prioritize stack decisions over user workflows
* Hide missing features behind technical explanations
* Add “best practice” features without approval
* Expand MVP scope without approval
* Treat assumptions as decisions
* Treat internal architecture as client value
* Present unapproved additions as completed work

---

## Completion Checklist

Before delivering work, the agent must verify:

```md
Scope checklist:
- [ ] Every implemented feature was explicitly requested or approved.
- [ ] No unrequested feature was added.
- [ ] No requested feature was omitted without approval.
- [ ] Any ambiguity was raised before implementation.
- [ ] Technical decisions did not change product behavior.
- [ ] Client-facing explanation focuses on usability and business value.
- [ ] Architecture details are separated from product features.
```

If any item is unchecked, the work is not ready.

---

## Agent Response Template

Agents should use this structure when planning or reporting work:

```md
## Confirmed Scope

- Feature 1
- Feature 2
- Feature 3

## Not Implemented Because Not Requested

- Extra feature A
- Extra feature B

## Questions Before Changing Scope

- Question 1
- Question 2

## Technical Notes

Technical details are included only where they support the requested features. They do not add new product scope.
```

---

## Final Rule

The agent’s job is not to impress the client with architecture.

The agent’s job is to deliver the requested application behavior exactly, without inventing features, without deleting features, and without pretending stack choices are product value.

When in doubt:

1. Keep the requested feature.
2. Do not add anything new.
3. Ask before omitting, replacing, or changing behavior.

That is the whole discipline. Somehow, civilization requires it in writing.

```
```
## Beauté Avenue Approved Feature Scope

The following features are already approved and must not be omitted without explicit permission.

### Client Features

- Sign up/login by phone OTP or email
- Manage profile: name, photo, address, preferences
- View past and upcoming appointments
- Browse salon list
- Filter salons by category, rating, price, and distance
- Search by salon name or service
- View nearby salons on a map
- View salon details: photos, hours, services, reviews, prices
- Add/remove salons from favorites
- Select service and provider
- Choose available time slot
- Confirm booking
- Pay deposit when required by a Premium salon
- Receive push confirmation, with selective SMS fallback when needed
- Cancel or modify appointment according to salon policy
- View appointment statuses
- Receive reminders 24h and 1h before appointment (push-first, selective SMS fallback)
- Rate salon after completed service

### Salon / Professional Features

- Professional sign-up
- Optional NINEA for V1
- Create salon profile: name, address, category, photos, description
- Define services with price and duration
- Manage employees and specialties
- Define opening hours and closing days
- View daily and weekly calendar
- Manage employee availability
- Accept or reject appointment requests
- Block unavailable time slots
- Add manual appointments
- View business dashboard
- View reservation history with filters
- View statistics: recurring clients and most requested services
- Manage client reviews

### Subscription Features

- Normal and Premium salon plans
- Premium salons can be highlighted in results
- Premium badge on salon profile
- Premium salons get advanced statistics
- Premium salons can request client deposits
- Premium salons can upload unlimited gallery photos
- Premium salons get priority notifications and dedicated support

### Deposit / Payment Features

- Premium salon can define deposit as fixed amount or percentage
- Client pays deposit through Mobile Money
- Supported providers: Wave, Orange Money, Free Money
- Deposit is held by Beauté Avenue until appointment completion
- Deposit is transferred to salon after completed appointment
- Late client cancellation may retain deposit according to salon rules
- Salon cancellation automatically refunds client

### Admin Features

- Admin validates salons
- Admin manages users
- Admin manages subscriptions
- Admin manages platform-level operations

## Audit Hotfix Log — 2026-05-06 (Codex)

Scope fixed immediately (outside prior two-agent prompt slices):

- Mobile search: removed mock/placeholder filter logic in `search_page.dart`.
  - Deleted fake premium/nearby checks that were not backed by real data.
  - Search now filters only on verified fields (name/category/neighborhood/city + category chip).

- Mobile payment cutover alignment (`intech` + channel):
  - `paymentInitiateProvider` now always sends `provider: "intech"` and explicit `channel`.
  - `payment_handoff_page.dart` now uses canonical channels:
    - `wave`
    - `orange_money`
    - `free_money`
  - Added Free Money option to payment handoff UI.
  - Booking review auto-pay now infers channel from saved method label/provider and falls back to handoff if unknown.

- Payment methods UI alignment:
  - Add payment method now stores `provider: "intech"` (public contract compliant).
  - Operator choice is preserved via label (`Wave`, `Orange Money`, `Free Money`).
  - Display tile resolves operator from label/provider for backward compatibility with legacy records.

- Model/provider defaults aligned:
  - Default payment method provider fallback changed `wave -> intech` in client model and offline pending list merge.

Validation run:

- `flutter test` (apps/mobile-client): PASS.
- `flutter analyze`: still has pre-existing repo issues; current hard errors are outside this slice (`booking_detail_page.dart` `gapH20` undefined).

Residual backend/infrastructure gaps still not closed by this hotfix:

- Real FCM delivery implementation (push is still skeleton).
- Real media upload provider implementation.
- Real OTP provider path (noop adapter still present).
- Full OpenAPI parity check against runtime routes should be re-run in CI gate.
