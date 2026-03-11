# High-Level Design (HLD)

## 1. System Architecture Overview
The DropZone platform consists of a mobile client application (Flutter) and a dedicated backend system. The frontend adheres to Clean Architecture principles separating UI, domain logic, and data layers.

## 2. Architecture Layers (Frontend)
- **Presentation Layer (`lib/presentation/`):** Contains UI components, screens, and Riverpod state providers. Uses `go_router` for structured navigation.
- **Domain Layer (`lib/domain/`):** Houses business logic, entities, and abstract repository interfaces (e.g., `BookingRepository`).
- **Data Layer (`lib/data/`):** Contains implementations of repositories (e.g., `HttpBookingRepository`), API clients (using DIO), and local data storage mechanisms.
- **Core Layer (`lib/core/`):** Shared utilities, constants, themes, and configuration (e.g., localized strings).

## 3. Key Integrations
- **State Management:** Riverpod (`flutter_riverpod`) for robust and scalable state handling.
- **Networking:** `dio` with secure token interceptors and robust error handling (timeouts, caching).
- **Authentication & Analytics:** Firebase Core, Firebase Auth, and Firebase Crashlytics.
- **Payment Gateway:** Stripe (`flutter_stripe`) configured for UAE processing and 3DS compliance.
- **Maps Location:** Google Maps Flutter plugin combined with WebSocket/polling for real-time live location updates.

## 4. Communication Flow
- **REST/HTTP:** Primary communication with the DropZone backend for CRUD operations (Bookings, User Profiles).
- **WebSockets:** Used for real-time location pushes from driver to passenger app.
- **Webhooks:** Asynchronous backend processing from Stripe to confirm final payment success, triggering auto-refresh on the client list.
