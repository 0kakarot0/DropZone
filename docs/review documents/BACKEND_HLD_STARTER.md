# DropZone Chauffeur — Backend HLD (Starter)

## 1. Purpose
This document provides a starter high-level design for the backend so future features do not evolve without a shared architecture view.

## 2. Technology Baseline
- Framework: Spring Boot
- Auth: Firebase token verification
- API style: REST
- Database: PostgreSQL (recommended canonical choice if not yet formally documented)
- Payment integration: Stripe or approved payment provider
- Containers: Docker / docker-compose
- Frontends:
  - Flutter rider app
  - Driver app / driver mode
  - Admin dashboard (planned / separate frontend)

## 3. Backend Responsibilities
The backend is responsible for:
- Authentication and authorization enforcement
- Booking lifecycle management
- Pricing and fare calculation
- Driver assignment and ride state management
- Payment orchestration and webhook handling
- Tracking ingestion and passenger-visible trip state
- Notification orchestration
- Admin and operations endpoints
- Audit-friendly event records

## 4. Logical Architecture
### Main layers
- **Controller layer**
  - Validates request shape
  - Maps transport DTOs
- **Application/service layer**
  - Implements booking, dispatch, pricing, tracking, payment logic
- **Domain layer**
  - Business rules, state transitions, policies
- **Repository/data layer**
  - Persistence, queries, indexing
- **Integration layer**
  - Firebase, payment provider, notification provider, maps/geocoding provider

## 5. Core Domain Modules
### 5.1 Auth & RBAC
- Firebase token validation
- Role enforcement:
  - passenger
  - driver
  - admin
- Route protection per role
- Access ownership checks

### 5.2 Booking
Owns:
- Create booking
- Estimate price
- View booking(s)
- Cancel booking
- Reschedule booking
- Booking details

### 5.3 Dispatch
Owns:
- Candidate driver selection
- Assignment offer lifecycle
- Acceptance / rejection handling
- Escalation for unassigned rides

### 5.4 Tracking
Owns:
- Driver location updates
- Active ride state view
- ETA / current status serving
- Stale location handling

### 5.5 Payment
Owns:
- Payment intent initiation
- Confirmation state
- Webhook reconciliation
- Refund / failure handling
- Idempotency for payment events

### 5.6 Notifications
Owns:
- Event-driven notifications
- Push/email/SMS abstraction
- Retry / fallback policy

### 5.7 Admin / Ops
Owns:
- Metrics
- Search / filters
- Booking oversight
- Driver oversight
- Manual dispatch/reassignment actions
- Audit views

## 6. Recommended Core Entities
- User
- Driver
- Vehicle
- PartnerFleet
- Booking
- BookingStop
- BookingAssignment
- PaymentTransaction
- LocationPing
- NotificationEvent
- SupportTicket
- AuditEvent

## 7. Recommended Booking State Machine
Suggested starter states:
- DRAFT
- PENDING_PAYMENT
- CONFIRMED
- PENDING_ASSIGNMENT
- ASSIGNED
- DRIVER_EN_ROUTE
- DRIVER_ARRIVED
- RIDE_IN_PROGRESS
- COMPLETED
- CANCELLED
- PAYMENT_FAILED
- REFUND_PENDING
- REFUNDED

Rules:
- Invalid backwards transitions must be blocked
- Payment-confirmed and assignment-confirmed states must not be conflated
- State changes should be auditable

## 8. Recommended Dispatch Flow
1. Booking becomes dispatchable
2. Eligible driver pool is queried
3. Offer is created
4. One driver accepts
5. Assignment is locked
6. Other pending offers expire/revoke
7. Booking moves to assigned state
8. Escalate if no driver accepts within threshold

## 9. Non-Functional Requirements
### Performance
- Index booking status, scheduled time, driver availability, and geospatial lookup fields
- Avoid naive location queries at scale
- Use pagination for admin lists

### Security
- Enforce RBAC
- Validate all input payloads
- Apply rate limiting on sensitive endpoints
- Avoid exposing private driver/passenger data unnecessarily

### Reliability
- Use idempotency keys for payment and queued mobile actions
- Retry external integrations safely
- Log failed webhooks and failed notifications
- Support reconciliation jobs

## 10. API Versioning
Recommended:
- `/api/v1/...` for all externally consumed endpoints
- Avoid breaking changes without migration path

## 11. Migration Strategy
Every schema change should include:
- forward migration
- rollback approach
- data compatibility notes
- release-order dependency notes

## 12. Observability
Recommended telemetry:
- request latency
- booking creation success/failure
- assignment time
- webhook failures
- payment mismatch events
- stale tracking sessions
- notification failures

## 13. Open Architecture Decisions
1. Is tracking polling-based, WebSocket-based, or hybrid?
2. What is the canonical geospatial strategy?
3. What payment gateway is legally viable for launch?
4. What admin actions require audit logging?
5. What data retention rules apply per entity?

## 14. Recommendation
Formalize this backend HLD before major new sprints so database, service, and API evolution stay consistent across FE, BE, QA, and admin tooling.

---
Status: Starter draft
Owner: Backend / Architecture
