# PRD + Cross-Repo Sprint Execution Plan

This document is the working product and delivery plan for the DropZone platform across:

- Flutter rider app: `/Users/macbookpro/DropZone`
- Backend API: `/Users/macbookpro/DropZoneBE`
- Admin dashboard: `/Users/macbookpro/dropzone-admin`

It replaces the older broad roadmap with a plan based on verified implementation status.

## Scope And Source Of Truth

- Flutter rider app code is the source of truth for rider-facing implementation status.
- Backend and admin were reviewed only to validate contracts and cross-project dependencies.
- Detailed Flutter implementation gaps are tracked in [FRONTEND_GAP_ANALYSIS.md](FRONTEND_GAP_ANALYSIS.md).

## Verified Current Baseline

### Rider App

Implemented and validated in Flutter:

- Firebase auth
- Booking creation with estimate and card/cash branching
- Pending-payment recovery from bookings list
- Booking detail, cancel, reschedule, and event timeline
- Live trip tracking
- Saved booking preferences and quick re-book
- Map picker with coordinate capture
- Basic profile persistence for `displayName` and `corporateMode`

Not complete in Flutter:

- Support submission
- Masked calling/chat
- Notifications inbox
- Receipts flow
- Full profile/corporate editing
- Resolved addresses for map-picked locations
- Real analytics and Crashlytics wiring

### Backend

Validated rider-facing contracts:

- bookings list, detail, create, estimate, cancel, reschedule, events, and last booking
- booking payment intent and payment confirmation
- profile and profile preferences
- tracking by booking id

Validated admin-facing contracts:

- admin metrics
- admin bookings list
- driver listing
- smart dispatch
- driver assignment to booking

Not validated as implemented in backend:

- rider support tickets
- notification inbox or delivery preferences
- receipts retrieval flow
- saved-card management
- masked calling/chat
- map geocoding or address resolution APIs

### Admin Dashboard

Validated as implemented:

- metrics
- bookings list/detail fetch
- drivers list
- smart dispatch
- manual assignment

Not validated as implemented:

- support queue
- rider notifications tooling
- receipt tooling
- rider profile operations beyond current booking/dispatch context

## Delivery Rules For Interlinked Work

For any feature that touches multiple repos, execute in this order unless the task is truly frontend-only:

1. Backend contract and persistence
2. Flutter rider integration
3. Admin dashboard operational tooling

This order keeps the rider app and admin dashboard from building against placeholder contracts.

For every interlinked feature:

- define the backend request and response shape first
- confirm ownership of state transitions and auditability in backend
- implement rider UI only after the contract is stable
- add admin controls only when the underlying workflow is operationally useful

## Cross-Repo Execution Template

Use this template for any feature that spans rider app, backend, and admin:

| Phase | Repo | Purpose | Exit Condition |
|------|------|---------|----------------|
| 1 | Backend | Define DTOs, persistence, state transitions, and permissions | Contract is merged or stable enough for integration |
| 2 | Flutter | Integrate rider UX against real contract | Rider flow works without mock or placeholder behavior |
| 3 | Admin | Add operator workflows only where operationally needed | Admin actions and visibility reflect backend truth |
| 4 | QA | Run cross-repo regression for the specific workflow | Acceptance criteria are verified end-to-end |

For branch naming, use these defaults:

- Backend: `feature/<sprint>/be-*`
- Flutter: `feature/<sprint>/fe-*`
- Admin: `feature/<sprint>/admin-*`
- QA: `feature/<sprint>/qa-*`

## Priority Roadmap

## Sprint 1: Booking Location Completion

Priority: High

Goal:
- Finish the coordinate-based booking flow so booking data is operationally reliable across rider, backend, and dispatch.

Why now:
- Coordinate capture is now present in Flutter, backend booking payloads, and admin dispatch assumptions.
- The remaining gap is product polish and data quality, not baseline architecture.

### Backend

- Add a clear address strategy for map-picked bookings:
  - either persist rider-entered text plus coordinates
  - or add geocoding/address resolution support
- Define whether address resolution happens:
  - at booking creation
  - asynchronously after booking creation
  - or client-side only
- Normalize pickup and dropoff address fields so admin and rider see consistent values

### Flutter Rider App

- Keep map picker as the primary coordinate capture flow
- Once backend address behavior is confirmed, replace coordinate-only display with resolved addresses where available
- Add clearer fallback states when only coordinates exist

### Admin Dashboard

- Show booking coordinate availability and resolved address quality in booking/dispatch views
- Keep smart dispatch tied to booking coordinates, not defaults

### Acceptance Criteria

- Given a rider selects pickup and dropoff on the map, when the booking is created, then backend stores usable location data for dispatch
- Given a booking has coordinates, when admin opens dispatch, then smart dispatch uses those booking coordinates
- Given address resolution is unavailable, rider and admin both see a consistent fallback representation

### Execution Breakdown

| Repo | Branch | Main Deliverables | Depends On |
|------|--------|-------------------|------------|
| Backend | `feature/sprint-1/be-booking-location-contract` | address strategy, booking payload normalization, coordinate/address persistence rules | none |
| Flutter | `feature/sprint-1/fe-booking-location-polish` | address fallback UX, booking summary updates, map-picked location display cleanup | backend contract |
| Admin | `feature/sprint-1/admin-booking-location-visibility` | coordinate/address visibility in booking and dispatch UI | backend contract |
| QA | `feature/sprint-1/qa-booking-location-regression` | booking creation, dispatch, and fallback display coverage | FE + BE + admin ready |

### Sequence Notes

1. Backend decides the address model first.
2. Flutter keeps coordinate-only fallback until backend response shape is stable.
3. Admin should not infer or transform addresses independently from rider/backend behavior.

### Concrete Task Checklists

#### Backend Checklist

- [ ] Decide and document the canonical booking location model:
  - pickup text label
  - pickup latitude/longitude
  - dropoff text label
  - dropoff latitude/longitude
  - resolved address fields, if supported
- [ ] Confirm whether address resolution is:
  - not supported in Sprint 1
  - synchronous at booking creation
  - asynchronous after booking creation
- [ ] Update booking request/response DTOs so the rider app and admin dashboard receive the same location representation
- [ ] Ensure booking persistence stores coordinates without dropping rider-entered labels
- [ ] Ensure booking detail and bookings list APIs return consistent location fields
- [ ] Ensure admin bookings and smart dispatch continue using booking coordinates when available
- [ ] Add validation rules for incomplete coordinate payloads:
  - pickup lat without pickup lng
  - dropoff lat without dropoff lng
  - malformed coordinate values
- [ ] Add backend tests for:
  - text-only booking
  - map-picked booking with coordinates
  - mixed payload validation failures

#### Flutter Rider Checklist

- [ ] Keep map picker as the supported coordinate capture flow for pickup and dropoff
- [ ] Update booking summary and confirmation surfaces to use the backend-approved location representation
- [ ] Replace raw coordinate-only UX with resolved address display only if backend contract supports it
- [ ] Keep a clear fallback when only coordinates are available
- [ ] Ensure booking draft state preserves pickup and dropoff coordinates
- [ ] Ensure create-booking payload sends coordinates only when both latitude and longitude are present for that location
- [ ] Ensure booking detail/list screens render location values consistently with the booking flow
- [ ] Keep user-facing copy honest when address resolution is not available
- [ ] Add regression coverage for:
  - choose pickup on map
  - choose dropoff on map
  - leave map flow and return to booking
  - create booking with coordinates

#### Admin Dashboard Checklist

- [ ] Display booking coordinates in booking detail or dispatch views when present
- [ ] Display the backend-provided location label or address exactly as returned
- [ ] Avoid client-side address inference inside admin
- [ ] Confirm smart dispatch requests always use booking coordinates rather than dashboard defaults
- [ ] Add clear fallback states when coordinates are missing or address resolution is unavailable
- [ ] Add regression coverage for:
  - booking with coordinates visible in admin
  - smart dispatch using those coordinates

#### QA Checklist

- [ ] Verify booking creation still works for text-only locations if that path remains supported
- [ ] Verify map-picked bookings persist coordinates through create, detail, and list flows
- [ ] Verify smart dispatch behavior with booking coordinates
- [ ] Verify rider and admin show matching location information for the same booking
- [ ] Verify fallback behavior when only coordinates are available
- [ ] Verify no regression to estimate, reschedule, cancel, or payment flows

### Sprint 1 Acceptance Criteria Breakdown

#### Backend Acceptance

- Backend exposes one stable location contract across create, list, detail, and admin-facing booking responses
- Backend stores and returns booking coordinates accurately when supplied
- Backend rejects malformed partial coordinate payloads with clear validation errors

#### Flutter Acceptance

- Given a rider picks a location on the map, when they return to booking, then the booking flow retains that location data
- Given a rider creates a booking with map-picked coordinates, when the booking succeeds, then those coordinates are included in downstream booking data
- Given resolved addresses are not supported, when a rider reviews the booking, then the UI shows an honest fallback instead of implying address lookup exists

#### Admin Acceptance

- Given a booking has stored coordinates, when it appears in admin, then operators can see and dispatch using those coordinates
- Given backend returns a location label or fallback text, when admin renders the booking, then it displays that value without inventing a different one

### Sprint 1 Subtasks By Repo

#### Backend Subtasks

- Define DTO changes in API layer
- Update persistence/entity mapping if needed
- Align admin booking response shape with rider booking response shape
- Add validation and tests
- Publish example request/response payloads for FE and admin consumers

#### Flutter Subtasks

- Align booking-flow display with the finalized backend contract
- Align booking draft and repository mapping with contract edge cases
- Update booking list/detail screens if returned location fields change
- Add or refresh widget/integration coverage for map-picker path

#### Admin Subtasks

- Update booking table/detail typing for finalized location fields
- Update dispatch screen to rely on booking coordinates and backend-provided labels
- Add empty/fallback display states for missing address resolution

#### Dependency Notes

- Flutter location-polish work is blocked on the backend deciding whether resolved addresses exist in Sprint 1
- Admin display work is blocked on the backend finalizing the booking response shape
- QA signoff should happen only after the same booking can be checked in rider app, backend response, and admin dashboard

## Sprint 2: Support And Escalation Workflow

Priority: High

Goal:
- Turn the current static rider support flow into a real operational workflow.

Why now:
- Flutter currently shows an honest unavailable state, which is better than fake success but still not a usable support path.
- This is a cross-repo feature by definition.

### Backend

- Add rider support ticket APIs
- Define ticket schema:
  - booking-linked and general support cases
  - category
  - priority
  - status
  - message history or notes
- Add admin-facing endpoints for ticket queue and ticket status updates

### Flutter Rider App

- Replace placeholder support UI with real submission flow
- Allow optional booking attachment for support requests
- Show submission state and basic ticket status

### Admin Dashboard

- Add support queue view
- Add ticket detail and status update actions
- Allow operators to link support issues to booking context

### Acceptance Criteria

- Given a rider submits a support issue, when the request succeeds, then a persisted support ticket exists in backend
- Given an operator opens the admin dashboard, when support tickets exist, then they can view and update ticket status
- Given a rider reopens support, when their ticket exists, then they can see its latest state

### Execution Breakdown

| Repo | Branch | Main Deliverables | Depends On |
|------|--------|-------------------|------------|
| Backend | `feature/sprint-2/be-support-ticketing` | support ticket schema, rider submission API, admin queue/status APIs | none |
| Flutter | `feature/sprint-2/fe-rider-support-flow` | support submission form, booking-linked support option, ticket status view | backend contract |
| Admin | `feature/sprint-2/admin-support-queue` | ticket queue, ticket detail, operator status updates | backend contract |
| QA | `feature/sprint-2/qa-support-workflow` | end-to-end support submission and triage coverage | FE + BE + admin ready |

### Sequence Notes

1. Backend owns ticket lifecycle and permissions.
2. Flutter should not show successful submission until backend persistence exists.
3. Admin support queue is blocked until backend status model is finalized.

### Concrete Task Checklists

#### Backend Checklist

- [ ] Define rider support ticket schema and lifecycle states
- [ ] Decide whether support tickets can optionally link to a booking id
- [ ] Add rider submission API for new support tickets
- [ ] Add rider-facing retrieval API for ticket status or ticket history
- [ ] Add admin queue and admin ticket-detail APIs
- [ ] Add admin ticket update actions:
  - status update
  - internal note
  - priority change, if supported
- [ ] Add validation and permission checks for rider and admin access
- [ ] Add backend tests for:
  - general support ticket creation
  - booking-linked support ticket creation
  - rider access only to own tickets
  - admin queue and status changes

#### Flutter Rider Checklist

- [ ] Replace the current unavailable support UI with a real submit flow only after backend contract exists
- [ ] Allow rider to choose issue category and enter message
- [ ] Allow optional booking selection when the ticket is booking-related
- [ ] Show loading, success, and failure states clearly
- [ ] Show current ticket state or ticket summary if backend retrieval is supported
- [ ] Prevent fake-success behavior if the backend request fails
- [ ] Add regression coverage for:
  - submit general support issue
  - submit booking-linked support issue
  - retry after submission failure

#### Admin Dashboard Checklist

- [ ] Add support queue list view
- [ ] Add ticket detail view with booking context where available
- [ ] Add operator actions for status updates
- [ ] Add visible priority and status indicators
- [ ] Ensure admin actions are based on backend ticket truth, not local-only state
- [ ] Add regression coverage for:
  - open queue
  - open ticket
  - update status

#### QA Checklist

- [ ] Verify rider can submit both general and booking-linked support requests
- [ ] Verify admin can see newly created tickets
- [ ] Verify status changes flow back to rider-visible state if supported
- [ ] Verify access control across rider/admin roles
- [ ] Verify booking, payment, and tracking flows are unaffected

### Sprint 2 Acceptance Criteria Breakdown

#### Backend Acceptance

- Backend persists support tickets with stable lifecycle states
- Riders can only create and access their own support records
- Admin can list and update support tickets through dedicated APIs

#### Flutter Acceptance

- Given backend support APIs exist, when a rider submits a valid issue, then the app shows real submission state tied to persisted backend data
- Given submission fails, when the rider retries, then the UI reflects the true request result and never implies success incorrectly

#### Admin Acceptance

- Given support tickets exist, when an operator opens admin, then tickets are visible in a queue with actionable status information
- Given an operator updates a ticket, when the update succeeds, then the queue and detail state reflect backend truth

### Sprint 2 Subtasks By Repo

#### Backend Subtasks

- Create support ticket DTOs and persistence model
- Add rider submission and retrieval endpoints
- Add admin queue and update endpoints
- Add validation, auth, and tests
- Publish sample payloads for Flutter and admin

#### Flutter Subtasks

- Build support submission form against the real contract
- Add optional booking linkage UI
- Add ticket state rendering if backend supports retrieval
- Replace current unavailable-state copy only when backend path is ready

#### Admin Subtasks

- Add support queue and detail typing
- Add operator status update actions
- Add booking-context linking in support views where applicable

#### Dependency Notes

- Flutter support implementation is fully blocked on backend ticket APIs
- Admin queue work is blocked on backend ticket schema and status model
- QA should validate both rider and admin views against the same ticket records

## Sprint 3: Notifications And Receipts

Priority: High

Goal:
- Deliver real rider notification and receipt experiences instead of scaffold screens.

Why now:
- Flutter has notifications and receipt screens, but they are not tied to validated backend contracts.
- Payment and booking lifecycle events already exist, so this is a natural next operational layer.

### Backend

- Define notification event model for rider-visible events:
  - booking created
  - payment pending
  - payment confirmed
  - driver assigned
  - trip started
  - trip completed
  - trip cancelled
- Add receipt retrieval contract for completed paid rides
- Decide whether notifications are inbox-backed, push-only, or both

### Flutter Rider App

- Wire notifications screen only after inbox contract exists
- Show receipt access from completed bookings only after receipt contract exists
- Keep current screens hidden or clearly inactive until the backend is ready

### Admin Dashboard

- Add basic visibility into notification delivery state only if operations need it
- Add operator access to receipt/audit context only if support workflows require it

### Acceptance Criteria

- Given a rider booking changes state, when a supported event occurs, then the backend records a rider-visible notification event
- Given a completed paid ride, when the rider opens that booking, then a receipt can be retrieved through a real API

### Execution Breakdown

| Repo | Branch | Main Deliverables | Depends On |
|------|--------|-------------------|------------|
| Backend | `feature/sprint-3/be-notifications-receipts` | notification event model, inbox/receipt APIs, lifecycle event mapping | none |
| Flutter | `feature/sprint-3/fe-notifications-receipts` | notifications screen wiring, receipt entry points from bookings | backend contract |
| Admin | `feature/sprint-3/admin-notification-audit` | optional operational visibility for notification/receipt audit | backend contract |
| QA | `feature/sprint-3/qa-notifications-receipts` | booking-event, receipt retrieval, and visibility regression | FE + BE ready |

### Sequence Notes

1. Backend defines whether notifications are inbox-backed, push-only, or hybrid.
2. Flutter should keep inactive screens hidden or clearly inactive until that contract exists.
3. Admin only gets notification tooling if the workflow has real operational value.

### Concrete Task Checklists

#### Backend Checklist

- [ ] Define rider-visible notification event types and payload shape
- [ ] Decide delivery model:
  - inbox only
  - push only
  - inbox plus push
- [ ] Add notification retrieval API if inbox is supported
- [ ] Map booking/payment lifecycle events into notification records
- [ ] Define receipt retrieval contract for completed paid bookings
- [ ] Add backend tests for:
  - event creation
  - receipt retrieval authorization
  - completed vs non-completed booking receipt access

#### Flutter Rider Checklist

- [ ] Keep notifications and receipts hidden or inactive until backend contracts exist
- [ ] Once notification inbox contract exists, wire notifications screen to real data
- [ ] Once receipt contract exists, expose receipt access from completed bookings only
- [ ] Show clear empty states and failure states
- [ ] Ensure notification and receipt UI does not depend on mock data
- [ ] Add regression coverage for:
  - notifications list loading
  - no notifications state
  - completed booking receipt access

#### Admin Dashboard Checklist

- [ ] Only add notification/receipt operational visibility if support or ops teams need it
- [ ] If added, use backend event truth rather than derived frontend assumptions
- [ ] Keep admin scope limited to audit/support value, not rider-feature duplication

#### QA Checklist

- [ ] Verify booking and payment events produce the correct rider-visible notifications
- [ ] Verify receipts are available only for eligible completed paid rides
- [ ] Verify riders cannot access receipts for unauthorized bookings
- [ ] Verify inactive screens remain honest until real contracts exist

### Sprint 3 Acceptance Criteria Breakdown

#### Backend Acceptance

- Backend exposes a stable notification event contract if inbox support is part of scope
- Backend exposes a real receipt retrieval path for eligible rides
- Notification and receipt access rules are enforced correctly

#### Flutter Acceptance

- Given a real inbox contract exists, when a rider opens notifications, then the screen shows backend-backed results or honest empty/error states
- Given a completed paid booking has a receipt, when a rider opens that booking, then receipt access is available through a real API path

#### Admin Acceptance

- If admin visibility is in scope, operators can inspect backend-backed notification or receipt audit data without relying on inferred client state

### Sprint 3 Subtasks By Repo

#### Backend Subtasks

- Define notification DTOs and receipt DTOs
- Map booking lifecycle events to notifications
- Add receipt retrieval endpoint and auth checks
- Publish contract examples for Flutter and admin

#### Flutter Subtasks

- Wire notifications screen to backend only after contract is ready
- Add receipt entry point from eligible booking states only
- Add honest empty/error/inactive states

#### Admin Subtasks

- Add notification/receipt audit views only if operationally justified
- Keep implementation thin and backend-driven

#### Dependency Notes

- Flutter notifications and receipts remain blocked on backend contracts
- Admin audit tooling is optional and should not start before backend event models exist
- QA should validate eligibility and authorization carefully because these flows touch payment and booking state

## Sprint 4: Profile And Corporate Data Expansion

Priority: Medium

Goal:
- Expand beyond the currently validated profile fields without inventing unsupported UI.

Why now:
- Flutter now persists only `displayName` and `corporateMode`, which matches the current backend contract.
- The rest of the profile UI should only grow when the data model is real.

### Backend

- Decide the supported rider profile model beyond:
  - display name
  - email
  - corporate mode
- If corporate mode is real product scope, define company and cost-center fields explicitly
- Add validation and persistence rules for any new fields

### Flutter Rider App

- Persist only fields backed by real backend support
- Remove or clearly mark unsupported profile fields until the contract exists

### Admin Dashboard

- Add profile visibility only if operations or support teams truly need it
- Do not build admin profile editing tools without a clear operational use case

### Acceptance Criteria

- Given a rider edits a supported profile field, when they save, then backend and Flutter reflect the same persisted value
- Unsupported fields are not presented as editable production features

### Execution Breakdown

| Repo | Branch | Main Deliverables | Depends On |
|------|--------|-------------------|------------|
| Backend | `feature/sprint-4/be-profile-expansion` | explicit supported profile fields, validation, persistence | none |
| Flutter | `feature/sprint-4/fe-profile-expansion` | field-level UI updates only for backend-backed properties | backend contract |
| Admin | `feature/sprint-4/admin-profile-ops` | optional support-facing profile visibility if justified | backend contract |
| QA | `feature/sprint-4/qa-profile-contract` | profile edit regression and unsupported-field checks | FE + BE ready |

### Sequence Notes

1. Backend must define the real corporate/profile model before UI expands.
2. Flutter should continue hiding or disabling unsupported fields until then.
3. Admin profile tooling is optional and should not be built by default.

### Concrete Task Checklists

#### Backend Checklist

- [ ] Define the full supported rider profile contract beyond current fields
- [ ] Decide whether corporate mode remains a simple flag or expands into a structured company model
- [ ] If supported, define:
  - company name
  - cost center
  - passenger/contact fields
  - any approval or validation rules
- [ ] Add persistence and validation for newly supported fields only
- [ ] Add backend tests for profile read/update and field validation

#### Flutter Rider Checklist

- [ ] Keep current persisted fields limited to backend-supported properties
- [ ] Add editable UI only for newly supported backend fields
- [ ] Remove or clearly disable any still-unsupported profile inputs
- [ ] Ensure save behavior only sends supported payload fields
- [ ] Add regression coverage for:
  - edit supported field
  - unsupported field remains non-editable
  - profile reload after save

#### Admin Dashboard Checklist

- [ ] Confirm whether support/ops teams actually need rider profile visibility
- [ ] If needed, add read-only or limited operational profile views
- [ ] Avoid adding broad admin editing capabilities without a defined operational use case

#### QA Checklist

- [ ] Verify supported profile fields persist correctly end to end
- [ ] Verify unsupported profile fields are not misleadingly editable
- [ ] Verify rider-visible and backend-returned profile values stay aligned

### Sprint 4 Acceptance Criteria Breakdown

#### Backend Acceptance

- Backend clearly defines and validates the supported rider profile contract
- Backend persists and returns newly supported fields consistently

#### Flutter Acceptance

- Given a field is backend-supported, when a rider edits and saves it, then the updated value persists and reloads correctly
- Given a field is not backend-supported, when the rider views profile, then the app does not present it as a working editable feature

#### Admin Acceptance

- If admin profile visibility is enabled, operators only see or edit the fields justified by real operational needs

### Sprint 4 Subtasks By Repo

#### Backend Subtasks

- Expand profile DTOs and persistence model
- Add validation for new fields
- Publish clear supported-field contract

#### Flutter Subtasks

- Align profile form with supported backend contract
- Remove or disable unsupported save paths
- Add regression coverage for supported profile edits

#### Admin Subtasks

- Add limited operational profile visibility only if approved by product/ops
- Keep admin surface minimal and support-driven

#### Dependency Notes

- Flutter profile expansion is blocked on backend defining the real field set
- Admin profile tooling should not start unless product/ops justify it
- QA should check for misleading UI as carefully as successful persistence

## Sprint 5: Observability And Launch Readiness

Priority: Medium

Goal:
- Replace documented-overclaim areas with real instrumentation and release confidence.

Why now:
- The docs currently overstate analytics and Crashlytics readiness in Flutter.
- The app now analyzes and tests cleanly on the repaired FVM environment, so engineering validation can be part of the normal workflow again.

### Backend

- Ensure booking, payment, and support workflows expose enough structured logging for investigation
- Add dashboards or monitoring only where product and ops teams need them

### Flutter Rider App

- Replace mock analytics and crash services with real integrations
- Track the core funnel:
  - auth success
  - estimate success/failure
  - booking create success/failure
  - payment sheet shown
  - payment confirmation success/failure
  - tracking opened

### Admin Dashboard

- Add operational reporting only after source events are trustworthy
- Avoid dashboard widgets backed by incomplete telemetry

### Acceptance Criteria

- Given a rider flow fails in production, engineering can trace the failure from client and server signals
- Product telemetry for core booking and payment steps is available without relying on mock services

### Execution Breakdown

| Repo | Branch | Main Deliverables | Depends On |
|------|--------|-------------------|------------|
| Backend | `feature/sprint-5/be-observability` | structured logs, event correlation, operational dashboards as needed | none |
| Flutter | `feature/sprint-5/fe-analytics-crashlytics` | real analytics/crash reporting wiring and event coverage | backend event naming where needed |
| Admin | `feature/sprint-5/admin-operational-metrics` | trustworthy dashboards only for validated source events | backend telemetry quality |
| QA | `feature/sprint-5/qa-launch-readiness` | funnel checks, failure-path checks, release-readiness validation | FE + BE + admin ready |

### Sequence Notes

1. Replace mock observability in Flutter only with real configured services.
2. Admin dashboard metrics should not outpace the trustworthiness of source telemetry.
3. This sprint closes launch-readiness gaps rather than adding speculative features.

### Concrete Task Checklists

#### Backend Checklist

- [ ] Define the minimum structured logging and event correlation needed for booking, payment, tracking, and support workflows
- [ ] Ensure critical backend events can be tied to request or booking identifiers
- [ ] Add monitoring or dashboards only for signals teams will actually use
- [ ] Add backend verification for critical failure-path coverage where possible

#### Flutter Rider Checklist

- [ ] Replace mock analytics service with real analytics integration
- [ ] Replace mock crash reporting with real crash reporting integration
- [ ] Track the agreed core funnel events only
- [ ] Ensure failures and cancellations are distinguished from success events
- [ ] Avoid adding telemetry that cannot be interpreted operationally
- [ ] Add smoke validation for analytics/crash initialization paths

#### Admin Dashboard Checklist

- [ ] Only add dashboards backed by trustworthy source events
- [ ] Ensure any operational metrics shown in admin are traceable to backend event sources
- [ ] Avoid reporting cards that imply coverage for unsupported workflows

#### QA Checklist

- [ ] Verify analytics and crash integrations initialize correctly in supported environments
- [ ] Verify key booking and payment funnel events fire in expected paths
- [ ] Verify admin metrics do not overclaim unsupported workflows
- [ ] Verify docs and implemented telemetry scope remain aligned

### Sprint 5 Acceptance Criteria Breakdown

#### Backend Acceptance

- Backend emits enough structured signals to support debugging of booking, payment, tracking, and support workflows
- Operational dashboards are based on reliable event sources

#### Flutter Acceptance

- Given a rider goes through core booking and payment flows, when key steps succeed or fail, then real analytics/crash integrations capture the defined signals
- Mock observability services are no longer treated as implemented production capability

#### Admin Acceptance

- Any new operational metrics shown in admin are backed by validated telemetry, not placeholders or assumptions

### Sprint 5 Subtasks By Repo

#### Backend Subtasks

- Define observability event list and correlation identifiers
- Add logging or instrumentation for critical lifecycle transitions
- Align dashboard data sources with real backend events

#### Flutter Subtasks

- Add real analytics/crash packages and configuration
- Replace mock provider wiring
- Instrument agreed funnel events only
- Add validation steps for environment-specific setup

#### Admin Subtasks

- Audit existing metrics against telemetry truth
- Add only the dashboards justified by available source events

#### Dependency Notes

- Flutter observability implementation depends on real configured services, not just provider swaps
- Admin reporting quality is blocked by backend telemetry quality
- QA should verify both technical initialization and business meaning of tracked events

## Deferred Until Contract Exists

The following should stay out of active implementation until backend contracts are defined:

- saved-card wallet or standalone payment screen
- masked rider-driver calling or chat
- notifications inbox UI exposure
- receipt route exposure
- advanced corporate fleet workflows

## Branching And Merge Guidance

Recommended pattern for one interlinked feature:

1. Open backend PR first
2. Open Flutter PR against the agreed backend contract
3. Open admin PR after backend behavior is verified
4. Run targeted cross-repo QA
5. Merge in dependency order or behind feature flags

Use sprint branches only when multiple coordinated branches need a shared integration target. Otherwise, feature branches can merge directly by PR as long as dependency order is preserved.

## Definition Of Ready

A cross-repo feature is ready only when:

- product behavior is defined clearly enough for acceptance testing
- backend contract shape is agreed
- repo ownership is clear
- dependencies and blockers are listed
- unsupported placeholder UI is not being treated as production scope

## Definition Of Done

A cross-repo feature is done only when:

- backend contract is merged and testable
- Flutter behavior matches the contract
- admin tooling is present if the workflow requires it
- docs reflect actual implementation status
- analyze and test pass in the Flutter repo
