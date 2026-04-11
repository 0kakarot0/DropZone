# Driver App Starter Architecture

## Purpose

This project is the initial dedicated Flutter driver app skeleton for DropZone. It is separate from the rider app and is scoped only to the verified driver MVP foundation.

## Module Structure

- `lib/presentation/`
  - `app/` router and app shell
  - `auth/` placeholder sign-in flow and controller
  - `home/` dashboard shell
  - `rides/` inbox and ride detail shells
  - `profile/` driver profile shell
- `lib/domain/`
  - driver entities
  - repository contracts
- `lib/data/`
  - verified driver API service
  - DTOs
  - HTTP repository
  - mock repository
  - placeholder and Firebase auth repository implementations
- `lib/core/`
  - app config
  - bootstrap
  - DI providers
  - Dio client

## Verified Backend Assumptions

- `GET /api/driver/profile`
- `GET /api/driver/rides/assigned`
- `POST /api/driver/rides/{bookingId}/accept`
- `POST /api/driver/rides/{bookingId}/reject`
- `POST /api/driver/rides/{bookingId}/status`
- `POST /api/driver/location`

Additional verified behavior:

- Firebase-authenticated drivers must map to a backend driver record
- accept can fail due to another driver accepting first
- ride status progression is backend-constrained
- location updates are supported

## Current Scope

- separate Flutter app under `driver_app/`
- Riverpod, `go_router`, and Dio foundation
- placeholder auth flow
- driver profile, home, rides, ride detail, and profile screens
- starter domain and repository layers
- HTTP repository shell for verified endpoints
- mock repository so the app remains usable before backend integration is switched on

## Deferred Items

- live Firebase auth wiring
- real ride polling behavior
- accept/reject UI mutations
- ride status action wiring
- background location
- availability toggle
- push delivery
- navigation and ETA integration

## Open Decisions

- whether availability is self-service or admin-controlled
- whether ride offers are polling-only or push-assisted
- background location policy and platform requirements
- whether the long-term repo strategy stays in-repo or moves to a dedicated sibling repo

## Important Contract Gap

The current verified assigned-rides response returns booking data, but it does not clearly expose assignment status. The starter UI keeps an explicit “state unknown” section so the app does not overclaim offered versus accepted grouping when the backend cannot guarantee that distinction.
