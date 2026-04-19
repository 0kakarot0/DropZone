# DropZone Chauffeur — Acceptance Criteria & Testability Template (Starter)

## 1. Purpose
This document provides a starter format to make roadmap items testable, reviewable, and sign-off friendly.

## 2. Why This Is Needed
Current sprint tasks are implementation-focused but not acceptance-based. This creates ambiguity for Product, QA, and Engineering.

## 3. Definition of Ready
A feature should not start until it has:
- Business objective
- User role
- Scope boundaries
- Dependencies
- Acceptance criteria
- Error/edge cases
- Basic analytics/logging expectations where relevant

## 4. Definition of Done
A feature is done only when:
- Functional acceptance criteria pass
- Negative scenarios are handled
- API/UI validations are implemented
- Logging/error states are acceptable
- Tests are added at agreed levels
- Documentation is updated if needed
- Product/QA sign-off is complete

## 5. User Story Template
### Story title
As a [role], I want [goal], so that [value].

### Business value
Short explanation of why this matters.

### Preconditions
What must already be true before the flow works.

### Acceptance criteria
Use clear, testable statements.

### Negative scenarios
List known failure/edge cases.

### Telemetry / audit needs
What should be logged or tracked.

### Out of scope
What is intentionally excluded.

## 6. Acceptance Criteria Format
Use:
- Given / When / Then
or
- numbered observable outcomes

Avoid vague statements like:
- "works properly"
- "robust error handling"
- "user-friendly"

## 7. Example — Passenger Cancels Booking
### User story
As a passenger, I want to cancel my future booking so that I can avoid unwanted trips.

### Acceptance criteria
1. Given a future booking in cancellable state, when the passenger confirms cancel, then the booking status becomes CANCELLED.
2. Given a successful cancellation, when the booking list reloads, then the cancelled booking is shown with updated status.
3. Given a non-cancellable booking, when the passenger attempts cancel, then the user sees a clear message explaining why it cannot be cancelled.
4. Given backend cancellation success, when the flow completes, then an audit/event record is created.
5. Given cancellation triggers a refund, when payment rules allow refund, then refund status is updated or queued.

### Negative scenarios
- Passenger is offline during cancellation
- Booking already completed
- Refund provider delay
- Duplicate cancel request

## 8. Example — Driver Accepts Assignment
### Acceptance criteria
1. Given a dispatchable booking and an eligible driver, when the driver accepts first, then the assignment is locked to that driver.
2. Given another driver tries to accept after lock, then the second driver receives a clear rejection state.
3. Given acceptance succeeds, then the booking status moves to ASSIGNED.
4. Given acceptance fails due to conflict, then no duplicate assignment record is created.

## 9. Test Layer Guidance
### API tests
Best for:
- booking CRUD
- pricing
- dispatch
- payment webhook handling
- RBAC
- state transitions

### UI/widget/integration tests
Best for:
- booking flow
- status visibility
- validation messages
- navigation outcomes
- popup/dialog behavior

### Manual / exploratory
Best for:
- payments with 3DS
- map/tracking behavior
- poor connectivity scenarios
- notification timing

## 10. Required Edge Case Categories
Every feature should review:
- auth/session expiry
- network timeout
- duplicate submission
- role-based unauthorized access
- stale data refresh
- invalid state transition
- empty state / no data
- provider failure (payment, maps, push)

## 11. Recommendation
All future sprint tasks should be rewritten or supplemented with acceptance criteria before implementation starts.

---
Status: Starter draft
Owner: Product / QA
