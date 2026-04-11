# Business Requirements Document (BRD)

## 1. Project Overview
**Project Name:** DropZone Chauffeur
**Description:** A premium, private chauffeur application designed for airport transfers and business transport within the United Arab Emirates (UAE).

## 2. Business Purpose
The purpose of DropZone Chauffeur is to digitize and streamline the luxury chauffeur booking process, moving away from manual coordination to a seamless, app-based ecosystem. It connects high-end travelers with professional drivers in real-time or scheduled advances.

## 3. Problem Statement
Many high-end passengers require reliable, luxurious, and trackable transport, especially around airport transfers in the UAE. Existing mass-market ride-hailing apps lack the premium exclusivity, and traditional limousine services often lack modern apps, leading to poor communication, manual payment processing, and a lack of real-time tracking.

## 4. Objectives of the System
- Provide an intuitive, premium mobile app for seamless ride bookings.
- Ensure fully secure and compliant digital payments.
- Automate driver dispatch logic and ride tracking in real-time.
- Offer localized experiences in English and Arabic for the UAE demographic.

## 5. Target Audience / User Types / Roles
- **Passenger (Client):** High-end business travelers and corporate clients who book trips.
- **Driver (Chauffeur):** Verified chauffeurs who receive and fulfill booking requests.
- **Admin:** System operators who oversee bookings, users, and general platform health.

## 6. Role Permissions / Access Behavior
- **Passenger:** Can manage personal preferences, book rides, view past trips, manage payments, and track assigned drivers.
- **Driver:** Can log in securely, set availability, accept/reject rides, update trip status, and broadcast location.
- **Admin:** Handles oversight over backend services and user management via administrative API endpoints.

## 7. Functional Modules & Detailed Feature Descriptions

### A. Authentication Module
- **What it is:** Secure user and driver login utilizing Firebase.
- **Why it exists:** To strongly secure user identities.
- **Who uses it:** Passengers, Drivers, Admins.
- **What the user does:** Authenticates via the mobile interface.
- **What the system does:** Generates tokens and validates them on every backend API request using a specialized `FirebaseAuthFilter`.
- **Final Result:** A secure and authenticated session.
- **Current Status:** Implemented.

### B. Booking & Scheduling Module
- **What it is:** The end-to-end flow for reserving a vehicle.
- **Why it exists:** It is the core business offering of the system.
- **Who uses it:** Passengers.
- **What the user does:** Selects pickup/drop-off locations, trip date/time, and passenger counts.
- **What the system does:** Calculates estimated prices using internal logic, registers the booking, and stores it in the database.
- **Dependencies:** Google Maps/Places for location, HTTP Booking API.
- **Current Status:** Implemented (features include API endpoints for create, list, cancel, reschedule, and price estimation).

### C. Driver Dispatch & Ride Management Module
- **What it is:** The logic to find and assign drivers to pending bookings, plus the dedicated driver-side mobile application.
- **Who uses it:** Drivers and Backend System.
- **What the system does:** Utilizes a `NearestDriverStrategy` or direct assignments to offer trips to available drivers.
- **What the driver does:** Signs in via the dedicated driver app (`driver_app/`), reviews ride details, accepts or rejects trips. Once accepted, they advance through the ride lifecycle: `Arrived` → `Started` → `Completed`.
- **Current Status:** Implemented. Backend employs `DriverAppController` for ride acceptance and state mutation. A dedicated driver Flutter app is fully functional with Firebase auth, accept/reject with conflict handling, status progression state machine, auto-polling rides inbox, bottom navigation, and dark theme support.

### D. Trip Tracking Module
- **What it is:** Real-time visibility of the driver's location.
- **Who uses it:** Passengers and Admins.
- **What the system does:** The driver's device pushes periodic location updates to the backend. The passenger's app fetches updates to display a moving icon on a map.
- **Current Status:** Implemented. Operational through `TrackingController` and frontend tracking screens (`trip_tracking_screen.dart`).

### E. Payments Module
- **What it is:** The financial engine processing trip costs.
- **Who uses it:** Passengers.
- **What the system does:** Integrates with Stripe for online payment. It handles "Payment Intents", securely confirms transactions utilizing the Stripe SDK, and listens via Webhooks (`WebhookController`) for notifications to automatically adjust the booking state.
- **Current Status:** Implemented.

## 8. End-to-End Business Flows / User Journeys

**Passenger Journey:**
1. Opens app, logging in securely.
2. Selects an airport transfer destination and date.
3. Receives a real-time price estimate and proceeds.
4. Confirms the payment method electronically via Stripe.
5. Receives a booking confirmation.
6. On the trip day, tracks the assigned driver's real-time approach on the map widget.
7. Completes the ride.

**Driver Journey:**
1. Logs into the dedicated driver application mode.
2. Receives a new booking request.
3. Evaluates and accepts the request.
4. Navigates to the pickup location, dynamically updating the status to "Arrived".
5. Transports the user, marking the ride "Started" and eventually "Completed".

## 9. Business Rules & Input Validations
- **Payments:** Rides must guarantee security and correct pre-authorization or payment before active completion.
- **Booking Constraints:** Scheduled bookings must meet valid timeframe rules (e.g., cannot book in the past).
- **Driver States:** A driver can fulfill only one ride trip simultaneously, minimizing overlap exceptions.

## 10. Current Implemented Scope
*This section summarizes functionalities verified against the actual backend and frontend codebase.*
- Complete Firebase-based authentication for both passengers and drivers securely verified per request.
- Full RESTful API-driven booking flow (price estimates, creation, scheduling, canceling).
- Driver dispatch interactions (nearest driver strategy, accepting/rejecting assignments, viewing assigned queues, providing lifecycle updates).
- **Dedicated driver Flutter app** (`driver_app/`) with:
  - Firebase email/password sign-in with ID token extraction.
  - Ride inbox with auto-polling (30s), grouped views (Offered/Active/Completed).
  - Accept/reject flow with 409 conflict handling and confirmation dialogs.
  - Full ride status progression state machine (ASSIGNED → EN_ROUTE → ARRIVED → IN_PROGRESS → COMPLETED) with visual stepper.
  - Bottom navigation shell (Home, Rides, Profile).
  - Light and dark theme support with Material 3.
  - Typed API exceptions and error interceptors matching rider app patterns.
- High-fidelity Stripe integration reliably handling complex payment intents and webhook event listeners.
- Live tracking endpoints broadcasting driver locations.
- Arabic (RTL) and English text localization infrastructure.
- Application architecture built robustly with Spring Boot controllers and Flutter Riverpod scopes, containerized by Docker.

## 11. Gaps / Pending Items
*This section documents missing or partially formed features.*
- **Admin Dashboard UI:** While administrative API endpoints exist, comprehensive visual web-based reporting, analytics, and driver management interfaces have not been fully developed.
- **External Notifications:** Custom Email or SMS notification dispatch logic (e.g., SendGrid/Twilio fallback) is not visually implemented; the system primarily leans on Firebase Messaging.
- **Offline / Low-Connectivity Modes:** Handling low-connectivity areas (like airport sub-basements) with robust local caching or offline queues is currently unhandled or partially implemented.
- **Multi-stop / Hourly Bookings:** Complex routing requirements beyond point-to-point standard transfers appear to be out of the immediate implemented scope.

## 12. Non-Functional Requirements & Security
- All sensitive API traffic guarantees verification with a Firebase Bearer Token.
- Platform is isolated efficiently via Docker (`Dockerfile` and `docker-compose.yml` integration present).
- Development environments and secure keys are abstracted using respective `.env` files.

## 13. Future Enhancements
For detailed breakdown of upcoming sprints, task scopes, branch strategies, and execution timelines handling operations like Hourly rules, Dashboard updates, and Fleet limits, please refer to the dedicated planning document:
- [PRD & Sprint Execution Plan](./PRD_Sprint_Execution_Plan.md)

Key upcoming enhancements include:
- Advanced Booking Types (Hourly, Multi-stop)
- Driver Operations Optimization
- Corporate Fleet Management
- Offline Mode Support
- Enhanced Notification System
