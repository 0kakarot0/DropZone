# PRD + Sprint Execution Plan

The DropZone Chauffeur platform already has the core foundation working, including Firebase authentication, base point-to-point booking flow, Stripe payments, driver dispatch, live tracking, and localization. The following execution plan outlines how the product will be extended logically across 8 key Sprints.

**Prioritized Order:** Sprint 1 → Sprint 2 → Sprint 4 → Sprint 3 → Sprint 5 → Sprint 6 → Sprint 7 → Sprint 8.
*(Expands product offer -> Improves conversion/payments -> Strengthens operations and scalability).*

## Sprint 1: Advanced Booking Types

| Area     | Main Task                  | Implementation Details                                                                                                                                                               | Suggested Branch                                 |
| -------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------ |
| Database | Hourly + Multi-stop schema | Add booking type enum (`point_to_point`, `hourly`, `multi_stop`), duration fields, stop sequence table, pricing metadata fields, booking summary snapshot fields                     | `feature/sprint-1/be-booking-schema-enhancement` |
| Backend  | Booking domain enhancement | Extend booking APIs to accept hourly and multi-stop payloads, validate booking type rules, prevent invalid combinations, keep backward compatibility for current point-to-point flow | `feature/sprint-1/be-advanced-booking-api`       |
| Backend  | Pricing engine refactor    | Update pricing service to support hourly base pricing, overage rules, stop-based adjustments, and summary breakdown                                                                  | `feature/sprint-1/be-pricing-refactor`           |
| Frontend | Trip type enhancement      | Add Hourly and Multi-stop options in existing booking flow, keep current booking flow intact for standard rides                                                                      | `feature/sprint-1/fe-booking-type-ui`            |
| Frontend | Booking form adaptation    | Hide drop-off for hourly, add duration selector, add dynamic stop list for multi-stop, keep validation clear and simple                                                              | `feature/sprint-1/fe-booking-form-enhancement`   |
| QA       | Booking validation tests   | Add tests for standard vs hourly vs multi-stop creation, edge cases for invalid stops, invalid duration, past dates                                                                  | `feature/sprint-1/qa-advanced-booking-tests`     |

## Sprint 2: Booking UI/UX Simplification

| Area         | Main Task                   | Implementation Details                                                                                          | Suggested Branch                                    |
| ------------ | --------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| Product / UX | Simplify booking flow       | Reduce heavy instruction steps, combine related inputs into fewer screens, preserve all required functionality  | `feature/sprint-2/ux-booking-flow-simplification`   |
| Frontend     | Smart booking screen        | Merge pickup, date/time, and ride type in a cleaner first step; use progressive disclosure for advanced options | `feature/sprint-2/fe-smart-booking-flow`            |
| Frontend     | Quick booking               | Add "repeat last ride" and "book from saved places" options                                                     | `feature/sprint-2/fe-quick-booking`                 |
| Frontend     | Better input controls       | Replace manual date inputs with date picker, time picker, location autocomplete, and reusable selectors         | `feature/sprint-2/fe-input-upgrades`                |
| Backend      | Support simplified payloads | Accept partially guided booking payloads and normalize them server-side before persistence                      | `feature/sprint-2/be-booking-payload-normalization` |
| QA           | UX regression coverage      | Verify simplified flow does not break current estimation, booking creation, reschedule, or cancellation         | `feature/sprint-2/qa-booking-ux-regression`         |

## Sprint 3: Driver Operations Optimization

| Area     | Main Task                      | Implementation Details                                                                                                   | Suggested Branch                                 |
| -------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------ |
| Database | Driver schedule & availability | Add shift windows, availability slots, break windows, preferred zones, and capacity constraints                          | `feature/sprint-3/be-driver-availability-schema` |
| Backend  | Assignment enhancement         | Improve current dispatch by adding assignment rules based on availability, shift timing, zone, and ride type suitability | `feature/sprint-3/be-dispatch-enhancement`       |
| Backend  | Driver planning endpoints      | Add APIs for driver schedules, availability updates, queue views, and assignment visibility                              | `feature/sprint-3/be-driver-ops-api`             |
| Frontend | Driver schedule view           | Add driver schedule/calendar view showing upcoming rides, gaps, and accepted jobs                                        | `feature/sprint-3/fe-driver-schedule-ui`         |
| Frontend | Assignment visibility          | Show why a ride is assigned, ride priority, and any operational notes in driver app                                      | `feature/sprint-3/fe-driver-assignment-ui`       |
| QA       | Dispatch consistency tests     | Add race-condition tests, overlapping ride prevention tests, and schedule conflict scenarios                             | `feature/sprint-3/qa-driver-ops-tests`           |

## Sprint 4: Payment Flexibility & Notifications

| Area     | Main Task                    | Implementation Details                                                                                                                   | Suggested Branch                                 |
| -------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| Backend  | Cash payment support         | Extend existing payment flow to support `cash`, `card`, and future `wallet` modes without breaking Stripe flow                           | `feature/sprint-4/be-payment-flexibility`        |
| Backend  | Payment state model          | Add payment states like `pending`, `authorized`, `paid`, `cash_due`, `failed`, `refunded`                                                | `feature/sprint-4/be-payment-state-enhancement`  |
| Frontend | Payment selection UI         | Allow user to choose payment method during booking and display payment rules clearly                                                     | `feature/sprint-4/fe-payment-method-ui`          |
| Backend  | External notifications       | Add email/SMS dispatch abstraction with provider adapters and fallback handling, since custom external notifications are a BRD gap today | `feature/sprint-4/be-notification-service`       |
| Frontend | Notification preferences     | Add profile-level notification preferences and clearer in-app confirmation states                                                        | `feature/sprint-4/fe-notification-preferences`   |
| QA       | Payment + notification tests | Test cash/card branching, fallback notifications, retry behavior, and message consistency                                                | `feature/sprint-4/qa-payment-notification-tests` |

## Sprint 5: Admin Dashboard Foundation

| Area     | Main Task                  | Implementation Details                                                                                                | Suggested Branch                                 |
| -------- | -------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| Frontend | Admin dashboard foundation | Build web/tablet-friendly admin UI for bookings, drivers, system alerts, and ride status overview                     | `feature/sprint-5/fe-admin-dashboard-foundation` |
| Backend  | Admin query APIs           | Add optimized endpoints for booking search, driver status, assignment monitoring, and operational filtering           | `feature/sprint-5/be-admin-ops-api`              |
| Frontend | Dispatcher board           | Create live dispatcher panel for unassigned rides, delayed rides, driver assignment overrides, and escalation actions | `feature/sprint-5/fe-dispatcher-board`           |
| Backend  | Admin actions              | Support force assignment, re-assignment, booking flags, escalation notes, and audit history                           | `feature/sprint-5/be-admin-actions`              |
| Frontend | Reporting widgets          | Add KPI cards for bookings, cancellation rate, payment mix, driver utilization, and support load                      | `feature/sprint-5/fe-admin-reporting`            |
| QA       | Admin workflow tests       | Verify search, filter, assign, reassign, and audit actions across roles                                               | `feature/sprint-5/qa-admin-workflow-tests`       |

## Sprint 6: Offline Resilience & Ops

| Area     | Main Task               | Implementation Details                                                                                             | Suggested Branch                             |
| -------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------ | -------------------------------------------- |
| Frontend | Offline-safe UX         | Add local cache for bookings, trip details, and profile snapshots; show clear sync states in UI                    | `feature/sprint-6/fe-offline-cache`          |
| Frontend | Offline action queue    | Queue reschedule, cancel, support tickets, and status updates when signal is weak; sync automatically on reconnect | `feature/sprint-6/fe-offline-action-queue`   |
| Backend  | Idempotent sync support | Add idempotency keys and safe replay handling for queued actions from mobile apps                                  | `feature/sprint-6/be-idempotent-sync`        |
| Backend  | Connectivity resilience | Improve API retry strategy, conflict handling, and stale data detection                                            | `feature/sprint-6/be-resilience-layer`       |
| DevOps   | Observability           | Add dashboards for API latency, failed sync jobs, webhook failures, booking creation drop-offs, and dispatch lag   | `feature/sprint-6/devops-observability`      |
| QA       | Poor-network testing    | Simulate low connectivity, reconnect flows, duplicate submission protection, and webhook delay handling            | `feature/sprint-6/qa-low-connectivity-tests` |

## Sprint 7: Corporate Fleet Booking

| Area     | Main Task                 | Implementation Details                                                                                       | Suggested Branch                            |
| -------- | ------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------- |
| Database | Corporate booking support | Add company account structures, department/cost center linkage, group booking references, and approval flags | `feature/sprint-7/be-corporate-schema`      |
| Backend  | Bulk booking engine       | Support CSV/manual bulk ride creation, ride grouping, and fleet allocation workflows                         | `feature/sprint-7/be-bulk-booking-engine`   |
| Frontend | Corporate booking UI      | Extend business account flow with event booking, passenger lists, and group ride creation                    | `feature/sprint-7/fe-corporate-booking-ui`  |
| Frontend | Fleet coordinator view    | Add corporate operator panel for monitoring bulk rides and assignment status                                 | `feature/sprint-7/fe-fleet-coordinator-ui`  |
| QA       | Bulk operation tests      | Validate concurrency, assignment spread, failure rollback, and partial success handling                      | `feature/sprint-7/qa-corporate-fleet-tests` |

## Sprint 8: Feature Toggles, Scaling & QA

| Area     | Main Task               | Implementation Details                                                                                                    | Suggested Branch                          |
| -------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| Backend  | Feature flags           | Wrap new enhancements in toggles for controlled rollout by tenant, geography, or user segment                             | `feature/sprint-8/be-feature-flags`       |
| DevOps   | Performance and scaling | Add stress tests, DB tuning, queue monitoring, and memory/CPU dashboards                                                  | `feature/sprint-8/devops-scale-readiness` |
| Frontend | Final polish            | Improve loading states, error handling, accessibility, and UX consistency across passenger, driver, and admin experiences | `feature/sprint-8/fe-polish`              |
| QA       | Full regression pack    | Run blocking FE + BE regression for booking, dispatch, tracking, payment, notifications, and offline sync                 | `feature/sprint-8/qa-full-regression`     |
| Release  | Controlled launch       | Roll out features progressively, monitor health, and keep rollback paths ready                                            | `release/sprint-8`                        |

## Standard Branching & Release Rules
| Step | Action                                                       |
| ---- | ------------------------------------------------------------ |
| 1    | Create sprint branch: `sprint/<number>-<name>`               |
| 2    | FE work goes in `feature/sprint-x/fe-*` branches             |
| 3    | BE work goes in `feature/sprint-x/be-*` branches             |
| 4    | QA or test automation goes in `feature/sprint-x/qa-*`        |
| 5    | Merge feature branches into sprint branch through PR         |
| 6    | Run integration/regression on sprint branch                  |
| 7    | Merge sprint branch into `develop`                           |
| 8    | After validation, merge `develop` into `main` via release PR |
