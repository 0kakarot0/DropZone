# Project Status Document

## 1. What is Done (Implemented)

### Rider App
- **Core Architecture:** Set up standard Clean Architecture (presentation, domain, data, core).
- **State & Routing:** Baseline Riverpod state management and `go_router` navigation established.
- **UI Skeleton:** Modern UI shell and primary booking flow skeleton created.
- **Localization:** EN/AR (RTL) localization foundation laid out.
- **Mock Data Layer:** Initial development utilizing `MockBookingRepository`.
- **Pre-commit/Linting Hooks:** Quality checks with standard flutter analyze and pre-commit scripts.

### Driver App
- **Dedicated Flutter App:** Standalone driver app at `driver_app/` with clean architecture matching the rider app.
- **Firebase Auth:** Real email/password sign-in via `FirebaseDriverAuthRepository`, placeholder mode for offline dev.
- **Ride Accept/Reject:** Wired accept and reject actions with 409 conflict handling and confirmation dialogs.
- **Ride Status Progression:** Full status state machine (ASSIGNED → EN_ROUTE → ARRIVED → IN_PROGRESS → COMPLETED) with visual stepper and context-aware action buttons.
- **Rides Inbox:** Grouped views (Offered/Active/Completed), auto-polling every 30 seconds, pull-to-refresh.
- **Driver Profile:** View display name, phone, email, status, vehicle info, rating.
- **Navigation Shell:** Bottom navigation bar (Home, Rides, Profile) via `StatefulShellRoute`.
- **Network Layer:** Typed API exceptions, `FirebaseAuthInterceptor`, `ErrorInterceptor`, matching rider app patterns.
- **Theme:** Light and dark themes with Material 3, navy + gold accent design system.
- **API Contract:** All 6 verified `/api/driver/*` endpoints wired through `HttpDriverRepository`.

## 2. In Progress (Sprint 8 - Launch Readiness)
- **Real Backend Integration:** 
  - Wiring `HttpBookingRepository` to replace mock data.
  - Adding token interceptors and error handling (timeouts/offline handling).
- **Payments QA:**
  - Handling Stripe 3D Secure (3DS) challenge flows.
  - Connecting webhooks for async payment confirmations.
- **Trip Tracking:**
  - Implementing Google Maps with polyline routing.
  - Live location updates (WebSocket) and smooth marker animations.
- **Analytics:** Firebase Crashlytics and custom event logging (`booking_created`, `payment_success`).

## 3. Pending & Backlog

### Rider App
- App Store / Play Store prep (generating proper iOS/Android icons).
- Writing Privacy Policy & Terms of Service pages.
- Final UI validation on edge-case devices (e.g., iPhone SE, 15 Pro Max layout testing).
- Complete final localization string audits.
- Production deployment of backend services and database.

### Driver App
- **Location Sharing:** Foreground and background GPS updates during active rides (requires platform policy decision and location package selection).
- **Push Notifications:** Push-assisted ride offer delivery (requires backend decision on push vs. polling-only).
- **Availability Toggle:** Driver self-service online/offline control (requires backend endpoint — currently admin-controlled).
- **Network Resilience:** Offline/flaky-network banners, retry for failed actions.
