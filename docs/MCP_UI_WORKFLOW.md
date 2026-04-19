# MCP UI Workflow

Use these MCP targets when you want to inspect the customer app and the driver app separately.

## Customer App

- Dart MCP root: `file:///Users/macbookpro/DropZone`
- Flutter entrypoint: `lib/main.dart`
- iOS workspace: `/Users/macbookpro/DropZone/ios/Runner.xcworkspace`
- iOS scheme: `Runner`
- iOS bundle id: `com.example.dropzoneApp`

## Driver App

- Dart MCP root: `file:///Users/macbookpro/DropZone/driver_app`
- Flutter entrypoint: `lib/main.dart`
- iOS workspace: `/Users/macbookpro/DropZone/driver_app/ios/Runner.xcworkspace`
- iOS scheme: `Runner`
- iOS bundle id: `com.example.dropzoneDriverApp`

## Notes

- The customer app now defaults to mock backend mode in local development unless `USE_MOCK_BACKEND=false` is set in `.env`.
- The driver app already uses a mock backend in development, so it is a good target for UI-only MCP inspection.
- For live backend testing, set `USE_MOCK_BACKEND=false` and ensure the API configured by `API_BASE_URL` is reachable from the target device or simulator.
