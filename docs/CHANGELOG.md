# Changelog

All notable changes to the DropZone project documentation and platform are tracked here.

## [2026-04-09] Driver App MVP Skeleton

### Added — Driver App
- New in-repo dedicated Flutter project at `driver_app/`
- Starter clean architecture layout:
  - `presentation/`
  - `domain/`
  - `data/`
  - `core/`
- Riverpod, `go_router`, and Dio foundation for the driver app
- Placeholder auth flow with linked-driver and unlinked-driver states
- Starter domain entities:
  - `DriverProfile`
  - `DriverRide`
  - `RideAssignment`
  - `DriverAuthSession`
- Driver repository contracts plus:
  - HTTP repository shell for verified backend endpoints
  - mock repository for starter UI behavior
- Placeholder screens wired together:
  - auth
  - home
  - rides
  - ride detail
  - profile
- Starter architecture reference at `driver_app/docs/DRIVER_APP_STARTER_ARCHITECTURE.md`

### Added — Documentation
- `docs/DRIVER_APP_SCOPE.md` created to define the dedicated driver app MVP scope and architecture

### Notable constraints kept explicit
- Driver app is a separate project, not a mode inside the rider app
- Firebase auth is scaffolded as a placeholder flow by default
- Background location, availability toggle, push-first offers, and live ride execution wiring were intentionally deferred
- Current verified assigned-rides contract does not clearly guarantee assignment status in the list response, so the starter UI preserves an honest “state unknown” section

---

## [2026-04-06] Sprint 1: Map-Based Location Picker

### Added — Backend
- Flyway V10 migration: `pickup_latitude`, `pickup_longitude`, `dropoff_latitude`, `dropoff_longitude` columns on `bookings` table
- Coordinate fields on `BookingEntity`, domain `Booking`, `CreateBookingRequest`, `BookingResponse`
- `CreateBookingService` accepts and persists coordinates
- All 3 controllers updated (`BookingController`, `AdminController`, `DriverAppController`)
- `BookingRepositoryAdapter` maps coordinates in both directions

### Added — Flutter
- New `MapLocationPicker` widget (centred-pin UX with camera-idle address, animate-on-drag, bottom confirm card)
- `PickedLocation` result class with address + lat/lng
- Booking entity, DTO, draft, and HTTP repository all transport coordinates end-to-end
- Step 2 of booking flow now has "Pick on Map" icon buttons for both pickup and dropoff
- Coordinate badges displayed under text fields when map-picked

### Changed — Admin Dashboard
- `BookingResponse` interface includes coordinate fields
- Smart dispatch uses booking coordinates instead of hardcoded defaults

---

## [2026-04-06] Documentation Review Update

### Updated
- **BRD.md** — Added business model, revenue structure, target segments, MVP launch scope, driver/fleet operating model, compliance assumptions, trust & safety requirements, admin dashboard as functional module, references to detailed review documents
- **HLD.md** — Added backend architecture layers, booking state machine diagram, admin dashboard architecture, integration dependencies table, security/RBAC notes, open architecture decisions table
- **PRD_Sprint_Execution_Plan.md** — Added completed sprints reference table (verified from codebase), Sprint 0 for business/compliance readiness, moved admin dashboard earlier (Sprint 2), added acceptance criteria expectations, deferred corporate fleet to post-MVP, renumbered future sprints
- **STATUS.md** — Rewrote with accurate implementation status verified against all three codebases (FE Sprint 10, BE Sprint 14, Admin foundation), added documentation review tracking, open items requiring external decisions
- **TECH_STACK_AND_LOCATIONS.md** — Expanded to cover all three project surfaces, integration providers with status, pending stack decisions
- **DropZoneBE/docs/ARCHITECTURE.md** — Expanded with domain modules, booking state machine, database schema, API endpoints
- **dropzone-admin/docs/ARCHITECTURE.md** — Created starter architecture doc with module overview, tech stack, auth flow

### Source material used
- `review documents/BUSINESS_MODEL_AND_UNIT_ECONOMICS.md`
- `review documents/UAE_COMPLIANCE_AND_OPERATING_ASSUMPTIONS.md`
- `review documents/DRIVER_SUPPLY_AND_ONBOARDING_OPERATING_MODEL.md`
- `review documents/BACKEND_HLD_STARTER.md`
- `review documents/ACCEPTANCE_CRITERIA_AND_TESTABILITY_TEMPLATE.md`

## [2026-04-03] Dispatch & Tracking Fixes

### Fixed
- **Driver locations:** Seeded initial coordinates for test drivers to enable NearestDriverStrategy
- **Smart dispatch:** Admin dashboard dispatch-content.tsx updated from hardcoded Dubai coordinates to Islamabad defaults
- **Map crash:** Resolved `PlatformException(recreating_view)` in trip tracking by keeping GoogleMap permanently mounted
- **Map alignment:** Updated default map center to match seeded driver locations

### Added
- Admin bookings API endpoint (`GET /api/admin/bookings`)
- Admin metrics with real booking counts
- BookingRepository.findAll for admin-wide retrieval
