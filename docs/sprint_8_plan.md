# 🚀 Sprint 8 Planning: Launch Readiness

**Goal:** Polish core features, finalize backend integrations, and prepare for App Store/Play Store submissions.

## 📋 Board Structure (GitHub Projects)
- **Column 1:** Backlog
- **Column 2:** Ready
- **Column 3:** In Progress
- **Column 4:** Review
- **Column 5:** Done

---

## 🎯 Sprint 8 Themes & Issues

### 1. Real Backend Integration Hardening
Move away from `MockBookingRepository` and wire up real endpoints.
- [ ] Create `HttpBookingRepository` implementing the interface
- [ ] Implement secure token interceptors for Dio/http client
- [ ] Add robust error handling (timeout, 500s, offline caching)
- [ ] Replace DI provider to use `HttpBookingRepository`

### 2. Payments QA (3DS Edge Cases)
Ensure the payment gateway integration is production-proof.
- [ ] Test and handle 3D Secure (3DS) challenge flows via WebView
- [ ] Handle payment gateway webhooks for asynchronous success/failure
- [ ] Auto-refresh Booking list when payment webhook succeeds

### 3. Trip Tracking Polish
Enhance the driver-assigned tracking map.
- [ ] Real google_maps_flutter integration with polyline route
- [ ] Live location updates via WebSocket/Polling from driver app
- [ ] Smooth marker animation for ETA updates

### 4. Analytics Dashboards
Finalize event tracking matrix.
- [ ] Verify Firebase Crashlytics non-fatal error logging
- [ ] Verify `booking_created` and `payment_success` custom events in Firebase console
- [ ] Set up user properties (e.g., `corporate_user: true`)

### 5. App Store Prep & Bug Fixes
- [ ] Generate proper iOS/Android app icons using new theme
- [ ] Write privacy policy & terms of service pages
- [ ] Test on generic iOS simulators (iPhone SE -> 15 Pro Max) for layout overflows
- [ ] Final localization string audit
