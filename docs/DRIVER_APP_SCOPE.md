# Driver App Scope

This document defines the recommended MVP scope and architecture for a dedicated DropZone driver application.

- It is based on verified backend contracts in `/Users/macbookpro/DropZoneBE`.
- It treats the root Flutter app in `/Users/macbookpro/DropZone` as the rider app, while a dedicated driver starter now exists at `/Users/macbookpro/DropZone/driver_app`.
- It separates what is buildable now from what still requires backend work or product decisions.

## 1. Current Verified Baseline

What exists today:

- Rider Flutter app in `/Users/macbookpro/DropZone`
- Dedicated driver Flutter app in `/Users/macbookpro/DropZone/driver_app` with functional MVP core flows
- Backend API in `/Users/macbookpro/DropZoneBE`
- Admin dashboard in `/Users/macbookpro/dropzone-admin`
- Driver-facing backend controller at `/api/driver`

What has been implemented in the driver app:

- Firebase email/password authentication with ID token extraction
- Ride accept/reject flow with 409 conflict handling
- Ride status progression state machine (ASSIGNED → DRIVER_EN_ROUTE → ARRIVED → IN_PROGRESS → COMPLETED)
- Rides inbox with auto-polling (30s), grouped views (Offered/Active/Completed)
- Bottom navigation shell (Home/Rides/Profile)
- Typed API exceptions and error interceptors matching rider app patterns
- Light and dark theme support
- All 6 verified backend endpoints wired through `HttpDriverRepository`

What does not exist today:

- no foreground or background location sharing implementation
- no push notification delivery for ride offers
- no verified driver availability toggle endpoint exposed through `DriverAppController`

Verified driver-facing backend endpoints:

- `GET /api/driver/profile`
- `GET /api/driver/rides/assigned`
- `POST /api/driver/rides/{bookingId}/accept`
- `POST /api/driver/rides/{bookingId}/reject`
- `POST /api/driver/rides/{bookingId}/status`
- `POST /api/driver/location`

Verified backend behavior relevant to driver app MVP:

- drivers authenticate with Firebase and must map to a `drivers` table row
- assigned rides include both offered and accepted assignments
- accept can fail with conflict if another driver already accepted first
- ride status progression is constrained to:
  - `ASSIGNED` -> `DRIVER_EN_ROUTE`
  - `DRIVER_EN_ROUTE` -> `ARRIVED`
  - `ARRIVED` -> `IN_PROGRESS`
  - `IN_PROGRESS` -> `COMPLETED`
- location updates write driver latitude, longitude, and `locationUpdatedAt`
- backend marks driver `BUSY` after acceptance and `AVAILABLE` after completion

## 2. Product Purpose

The driver app should enable chauffeur partners to participate in the booking lifecycle safely and operationally.

Primary jobs to be done:

- authenticate the driver
- show currently offered and accepted rides
- let the driver accept or reject ride offers
- guide the driver through ride execution status changes
- continuously share location during active work

This scope aligns with the partner-fleet operating model described in `docs/review documents/DRIVER_SUPPLY_AND_ONBOARDING_OPERATING_MODEL.md`.

## 3. Recommended MVP Scope

### In scope for MVP

#### 1. Authentication and driver identity

- Firebase sign-in
- backend validation that the authenticated Firebase user is linked to a driver record
- basic unauthorized and not-registered error handling

#### 2. Driver profile

- view driver display name
- view phone and email
- view current backend driver status
- view vehicle type and plate

#### 3. Offered and assigned rides inbox

- show rides currently offered to the driver
- show rides already accepted by the driver
- distinguish offer state versus active state in the UI
- refresh manually and on a short polling interval

#### 4. Ride decision flow

- accept an offered ride
- reject an offered ride
- show clear conflict state when another driver accepted first
- remove or downgrade stale offers after response

#### 5. Active ride execution

- ride detail screen with:
  - pickup and dropoff labels
  - coordinates where available
  - scheduled pickup time
  - passenger count
  - notes
  - payment method summary
- status action buttons for:
  - start route
  - mark arrived
  - start trip
  - complete trip

#### 6. Location sharing

- foreground location updates while driver is in an accepted or active ride
- best-effort background continuation if product and platform constraints allow
- visible UI state when location permissions are denied

#### 7. Operational resilience

- offline or flaky-network banners
- retry for failed accept/reject/status/location actions
- clear handling for unauthorized, forbidden, not found, conflict, and bad-request responses

### Out of scope for MVP

- in-app navigation routing for drivers
- rider-driver chat
- masked calling
- earnings, payouts, or wallet
- driver document upload
- fleet management UI
- ratings and reviews management
- incident reporting workflow
- push notification delivery guarantees
- multi-ride queue optimization beyond the current backend assignment model

## 4. Backend Gaps Blocking Full Driver Scope

These items should not be assumed implemented just because they appear in broader docs.

### 1. Driver availability toggle

The docs describe drivers setting availability, but no driver-facing endpoint was verified for changing availability between `AVAILABLE` and `OFFLINE`.

Needed backend decision:

- add driver self-service availability endpoint
- or define that availability is controlled only by admin/ops

### 2. Push-first ride offer delivery

Current verified contract supports polling `GET /api/driver/rides/assigned`, but no verified driver push-notification offer flow was validated.

Needed backend/product decision:

- polling-only MVP
- or push-assisted offer delivery with polling fallback

### 3. Navigation and ETA support

Ride data currently includes pickup and dropoff labels plus coordinates where available, but turn-by-turn navigation integration is not part of the verified contract.

### 4. Background location policy

Location updates are supported by backend, but platform-specific background behavior, battery policy, and operational requirements remain product and engineering decisions.

## 5. Recommended App Architecture

Use a dedicated Flutter app rather than embedding driver mode into the rider app.

Why:

- driver workflows, permissions, and lifecycle are materially different from rider flows
- background location and operational constraints are driver-specific
- release cadence and QA needs are likely to diverge from the rider app
- role separation is cleaner for auth, navigation, and analytics

### Suggested project shape

- separate repo or sibling Flutter app directory for the driver app
- same architectural style as the rider app:
  - `presentation/`
  - `domain/`
  - `data/`
  - `core/`

### Suggested feature modules

- `presentation/auth/`
- `presentation/home/`
- `presentation/rides/`
- `presentation/profile/`
- `presentation/location/`
- `core/network/`
- `core/di/`
- `data/api/driver_api_service.dart`
- `data/repositories/http_driver_repository.dart`
- `domain/entities/driver_profile.dart`
- `domain/entities/driver_ride.dart`
- `domain/entities/ride_assignment.dart`
- `domain/repositories/driver_repository.dart`

### State management and navigation

- Riverpod for app state and side effects
- `go_router` for top-level routes
- feature-local providers for driver profile, offers, active ride, and location sync

Suggested core providers:

- `driverProfileProvider`
- `assignedRidesProvider`
- `activeRideProvider`
- `locationPermissionProvider`
- `locationSyncProvider`

Suggested top-level routes:

- `/auth`
- `/`
- `/rides`
- `/rides/:bookingId`
- `/profile`

## 6. MVP Screen Map

### 1. Auth screen

- Firebase login
- loading state
- unauthorized and missing-driver-account handling

### 2. Home screen

- current availability summary
- active ride card when a ride is in progress
- offered ride count
- shortcut into rides inbox

### 3. Rides inbox screen

- segmented or grouped list:
  - offered rides
  - accepted or active ride
- pull to refresh
- stale assignment handling

### 4. Ride detail screen

- booking summary
- pickup and dropoff
- schedule info
- notes
- payment method
- accept/reject CTA for offered rides
- status progression CTA for accepted rides

### 5. Profile screen

- driver identity and vehicle info
- operational status display
- sign out

## 7. Data Contract Expectations

The driver app should consume backend responses as source of truth rather than deriving operational state client-side.

Required response capabilities already visible in current backend:

- driver profile metadata
- booking summary for assigned rides
- assignment decision responses
- ride status mutation response

Driver app should not infer:

- availability rules
- booking ownership overrides
- invalid status transitions
- dispatch eligibility

## 8. MVP Delivery Sequence

Build in this order:

1. ~~Backend contract completion~~ ✅ — all 6 endpoints verified
2. ~~Driver Flutter app skeleton~~ ✅ — auth, DI, router, HTTP client
3. ~~Ride inbox and accept/reject flow~~ ✅ — implemented with conflict handling
4. ~~Active ride detail and status progression flow~~ ✅ — full state machine with visual stepper
5. Location sync — **next priority**, requires package selection and platform policy
6. QA and operational dry run — after location sync and backend integration testing

## 9. Suggested Acceptance Criteria

### Authentication

- Given a valid Firebase-authenticated driver linked to a driver record, when the app loads, then the driver can access the driver surface
- Given a Firebase-authenticated user without a linked driver record, when the app loads, then access is denied with a clear support message

### Assigned rides

- Given the backend has offered or accepted rides for the driver, when the rides inbox loads, then the app shows those rides with correct state labels

### Accept or reject

- Given a ride is in `OFFERED` state for the driver, when the driver accepts, then the app reflects acceptance success
- Given another driver accepted first, when this driver tries to accept, then the app shows a conflict state and removes the stale offer
- Given a ride is in `OFFERED` state for the driver, when the driver rejects, then the app removes or downgrades that offer from the inbox

### Ride execution

- Given the driver has an accepted ride, when the driver moves through allowed ride states, then the app only exposes valid next actions
- Given the driver attempts an invalid status change, when the backend rejects it, then the app shows a clear error and preserves backend truth

### Location

- Given the driver is on an active ride and location permission is granted, when the app sends periodic location updates, then the backend accepts them successfully
- Given location permission is denied, when the driver opens an active ride, then the app clearly communicates tracking limitations

## 10. Risks And Operational Notes

- Background location rules differ across iOS and Android and should be treated as a delivery risk early
- Polling-only ride offers may be operationally weaker than push-assisted offers for response-time SLAs
- If availability remains admin-controlled, the driver home experience must avoid implying self-service online/offline control
- Partner-fleet onboarding and support procedures should be ready before real drivers are activated in production-like testing

## 11. Current Status

The driver app MVP core flows are implemented as a sibling Flutter project at `driver_app/`.

Completed:

- ✅ auth (Firebase email/password + placeholder mode)
- ✅ profile (view driver identity, vehicle, rating)
- ✅ assigned rides (inbox with auto-polling)
- ✅ accept/reject (with conflict handling)
- ✅ ride status progression (full state machine)
- ✅ bottom navigation shell
- ✅ dark theme support
- ✅ typed error handling

Remaining before full MVP:

- location updates (foreground GPS sharing during active rides)
- driver-controlled availability (requires backend endpoint)
- offer delivery model (push vs. polling — currently polling-only)
- background location policy (platform-specific constraints)
