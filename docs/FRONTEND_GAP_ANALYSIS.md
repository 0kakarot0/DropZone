# Frontend Gap Analysis

This document summarizes the verified state of the Flutter rider app in `/Users/macbookpro/DropZone`.

- Flutter code is treated as the source of truth when docs conflict.
- Backend checks were limited to contract validation in `/Users/macbookpro/DropZoneBE`.
- Admin checks were limited to dependency validation in `/Users/macbookpro/dropzone-admin`.

## 1. Current Architecture Map

- `lib/presentation/`: screens, widgets, route entrypoints, and feature-local Riverpod providers.
- `lib/domain/`: entities and repository contracts for bookings, payments, tracking, and preferences.
- `lib/data/`: Dio-backed API services, DTOs, and repository implementations.
- `lib/core/`: environment config, shared Dio client, app exceptions, DI providers, and analytics/crash abstractions.

Bootstrap flow:

- `.env` is loaded in `lib/main.dart`.
- Firebase and Stripe are initialized before `ProviderScope` starts the app.
- `go_router` is the top-level navigation system with a Firebase-auth redirect.

Key architectural pattern:

- UI depends on Riverpod providers.
- Providers depend on repository or service abstractions.
- Repository implementations map DTOs to domain entities.
- Dio is shared through one provider with Firebase Bearer token attachment.

## 2. Implemented Rider Flows

Implemented:

- Email/password auth with Firebase in `lib/presentation/auth/auth_screen.dart`
- Booking creation with estimate, card/cash branching, and booking submission in `lib/presentation/booking_flow/booking_flow_screen.dart`
- Upcoming/past booking list and pending-payment retry in `lib/presentation/bookings/bookings_screen.dart`
- Booking detail, cancel, reschedule, and event timeline in `lib/presentation/bookings/booking_detail_screen.dart`
- Live ride tracking with 5-second polling in `lib/presentation/tracking/trip_tracking_screen.dart`
- Tracking contact CTA now routes into the existing `/contact` screen from `lib/presentation/tracking/trip_tracking_screen.dart`
- Booking preferences and quick re-book support in `lib/core/di/preferences_providers.dart` and `lib/presentation/booking_flow/booking_flow_screen.dart`

Partially implemented:

- Map-based location picking exists, but confirmed addresses are still coordinate strings until geocoding is wired in `lib/presentation/booking_flow/map_location_picker.dart`
- Profile now persists `displayName` and `corporateMode`, while other profile-adjacent fields remain non-editable from Flutter

Mostly static/demo:

- Support flow in `lib/presentation/support/support_screen.dart`
- Contact driver flow in `lib/presentation/contact/contact_screen.dart`
- Airport enhancements in `lib/presentation/airport/airport_enhancements_screen.dart`
- Notifications screen in `lib/presentation/notifications/notifications_screen.dart`
- Receipt screen in `lib/presentation/receipts/receipt_screen.dart`

## 3. Routing Model

Top-level routing uses `go_router` in `lib/presentation/app/app_router.dart`:

- `/auth`
- `/tracking/:bookingId`
- `/airport`
- `/contact`
- shell routes for `/`, `/book`, `/bookings`, `/support`, `/profile`

Actual routing behavior is hybrid:

- Top-level destinations use `go_router`
- tracking now routes its contact action through `/contact`
- Contextual subflows still use `Navigator` and `MaterialPageRoute`
  - booking detail
  - edit booking
  - map picker

Inactive/orphaned screens:

- `NotificationsScreen` is not routed
- `ReceiptScreen` is not routed
- the old standalone `/payment` route has been removed from active app navigation

## 4. State Management Model

Riverpod is used in a lightweight, feature-local way:

- `bookingsProvider`: `AsyncNotifier<List<Booking>>`
- `bookingDraftProvider`: `Notifier<BookingDraft>`
- `userPreferencesProvider`: `AsyncNotifier<UserPreferences>`
- `lastBookingProvider`: `FutureProvider<Booking?>`
- analytics, crashlytics, env, Dio, and API services are injected through `Provider`

State outside Riverpod:

- booking step state is local widget state in `BookingFlowScreen`
- trip tracking uses local widget state plus a polling timer
- some screens still use controller-only local state without shared feature models

## 5. Shared Widgets And Theme System

Shared widgets:

- `PrimaryButton`
- `ResultPopup`
- `SkeletonCard`

Theme system:

- Brand colors live in `lib/presentation/theme/app_colors.dart`
- Theme construction lives in `lib/presentation/theme/app_theme.dart`
- Both `theme` and `darkTheme` currently resolve to the same dark-brand theme

Effectively, the app has one visual theme rather than distinct light/dark experiences.

## 6. API Integration Patterns

Real integration pattern:

- shared Dio client in `lib/core/network/dio_client.dart`
- Firebase ID token attached to every request
- thin API service layer
- repository layer maps DTOs to domain entities

Validated rider-facing backend contracts:

- `GET /api/bookings`
- `GET /api/bookings/last`
- `GET /api/bookings/{id}`
- `GET /api/bookings/{id}/events`
- `POST /api/bookings`
- `POST /api/bookings/estimate`
- `POST /api/bookings/{id}/cancel`
- `POST /api/bookings/{id}/reschedule`
- `POST /api/bookings/{id}/payment-intent`
- `POST /api/bookings/{id}/confirm-payment`
- `GET /api/profile`
- `PUT /api/profile`
- `GET /api/profile/preferences`
- `PUT /api/profile/preferences`
- `GET /api/tracking/{bookingId}`

Validated admin dependency assumptions from `/Users/macbookpro/dropzone-admin`:

- admin uses shared booking coordinate fields
- admin dispatch expects booking coordinates where available
- admin consumes `/api/admin/metrics`, `/api/admin/bookings`, `/api/drivers`, `/api/admin/dispatch/smart`, and `/api/bookings/{id}/assign`

Current payment behavior:

- user-facing payment now stays centered on booking-backed flows
- booking creation and pending-payment recovery both use validated backend payment endpoints
- the old mock standalone payment stack has been removed from the Flutter repo

## 7. Docs vs Implementation Comparison

Accurate in docs:

- layered Flutter architecture
- Riverpod + `go_router` baseline
- real booking/tracking/preferences backend integration
- quick re-book support
- map picker support at coordinate level

Docs that overstate frontend readiness:

- `docs/STATUS.md` says analytics and Crashlytics are implemented, but Flutter injects mock no-op services in `lib/core/di/providers.dart`
- `docs/TECH_STACK_AND_LOCATIONS.md` says Crashlytics is implemented, but there is no real Flutter Crashlytics wiring
- `docs/BRD.md` and `docs/STATUS.md` imply fuller profile/corporate support than Flutter actually persisted
- `docs/CHANGELOG.md` describes map picker address behavior more strongly than the current coordinate-only confirmation text supports

Docs that should defer to code:

- Flutter has real booking-backed payments, but not a real standalone payment feature
- several rider-facing screens exist as UI scaffolds only and should not be treated as complete features

## 8. Prioritized Gap Analysis

### Flutter-only issues

#### 1. Analytics and crash reporting are documented as implemented but are no-op in Flutter

- Priority: High
- Type: documented-not-implemented
- Evidence:
  - docs claim implementation in `docs/STATUS.md` and `docs/TECH_STACK_AND_LOCATIONS.md`
  - Flutter injects `MockAnalyticsService` and `MockCrashlyticsService` in `lib/core/di/providers.dart`
- Impact:
  - app behavior, error reporting, and product telemetry are overstated
  - failures in key flows are not observable from the Flutter app

#### 2. Hybrid navigation leaves some screens inactive or inconsistently reached

- Priority: Medium
- Type: UX inconsistency
- Evidence:
  - top-level routing uses `go_router` in `lib/presentation/app/app_router.dart`
  - booking detail, edit booking, and map picker use manual pushes
  - `NotificationsScreen` and `ReceiptScreen` are not wired to routes
- Impact:
  - navigation model is harder to reason about
  - some screens exist without a supported user path

#### 3. High-traffic screens still contain hardcoded English strings

- Priority: Medium
- Type: UX inconsistency
- Evidence:
  - localization coverage improved in auth, booking flow, shell, tracking, and profile, but rider-facing strings are still mixed across active and secondary screens
  - remaining gaps are most visible in booking detail/listing and static support-style screens such as:
    - `lib/presentation/bookings/booking_detail_screen.dart`
    - `lib/presentation/bookings/bookings_screen.dart`
    - `lib/presentation/support/support_screen.dart`
    - `lib/presentation/contact/contact_screen.dart`
- Impact:
  - localization coverage is incomplete in common flows
  - EN/AR support is weaker than docs imply

#### 4. Support, contact, airport, notifications, and receipt screens are mostly static

- Priority: Medium
- Type: documented-not-implemented
- Evidence:
  - no validated backend calls in:
    - `lib/presentation/support/support_screen.dart`
    - `lib/presentation/contact/contact_screen.dart`
    - `lib/presentation/airport/airport_enhancements_screen.dart`
    - `lib/presentation/notifications/notifications_screen.dart`
    - `lib/presentation/receipts/receipt_screen.dart`
  - support, contact, and airport now show honest “not available yet” UI instead of implying successful submission/persistence, but they still do not complete real backend-backed tasks
- Impact:
  - secondary rider flows look more complete than they are
  - user expectations are set higher than the implemented behavior

### Backend-dependent issues

#### 1. Support issue submission has no validated rider backend API

- Priority: Medium
- Type: dependency blocker
- Evidence:
  - Flutter support screen now explicitly tells users submission is unavailable in `lib/presentation/support/support_screen.dart`
  - no validated backend endpoint was found for rider support ticket submission
- Impact:
  - issue-reporting cannot be safely completed from Flutter alone

#### 2. Saved-cards / standalone payment UX has no validated backend contract

- Priority: Medium
- Type: dependency blocker
- Evidence:
  - the old mock standalone payment stack was removed from Flutter because there is no validated real contract to replace it
  - validated backend contracts cover booking payment intents, not arbitrary saved-card management
- Impact:
  - Flutter should not expose a generic card wallet/payment screen as a real feature

#### 3. Map picker confirms coordinates, not resolved addresses

- Priority: Medium
- Type: integration gap
- Evidence:
  - `MapLocationPicker` explicitly states geocoding is not wired in `lib/presentation/booking_flow/map_location_picker.dart`
  - confirmed “address” text is currently lat/lng
- Impact:
  - map-picked locations are functional for coordinates but not polished for rider-readable addresses

### Admin-dependent issues

#### 1. No direct rider-facing blocker from admin repo for core Flutter fixes

- Priority: Low
- Type: dependency blocker
- Evidence:
  - admin contract checks in `/Users/macbookpro/dropzone-admin` confirmed booking coordinate and dispatch assumptions already align with Flutter/backend
  - actual admin source is limited to dashboard, bookings, drivers, and dispatch APIs in `src/lib/api.ts`
- Impact:
  - current high-value Flutter fixes do not require admin code changes

#### 2. User prompt path mismatch for admin repo

- Priority: Low
- Type: integration gap
- Evidence:
  - active admin repo path is `/Users/macbookpro/dropzone-admin`
  - `/Users/macbookpro/DropZoneAdmin` does not exist in the local environment
- Impact:
  - future cross-project checks should use the correct path to avoid false negatives

## Top 5 Highest-Priority Gaps

1. Replace or clearly document mock analytics/crash reporting because docs currently overstate observability.
2. Continue cleaning up hybrid/orphaned navigation where real screens exist but user entry points are inconsistent or missing.
3. Finish reducing remaining rider-facing hardcoded strings so localization matches the documented EN/AR foundation.
4. Replace static support/contact/airport/notification/receipt scaffolds with validated product flows or keep them clearly inactive.
5. Add real backend-supported address resolution if the map picker is expected to show rider-friendly location names.
