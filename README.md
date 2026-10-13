# Pasar Oro-Oro Dowo

Flutter/Dart implementation of the existing React interface. The app keeps the
mobile layout at a maximum width of 402 px, reuses the source images and SVG
icons, and maps the existing page routes to Flutter screens.

## Run and verify

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```

The Android application is configured to reach local development services
through `10.0.2.2` on an Android emulator and `localhost` on other platforms.

## Screens

- Splash and introductory landing page
- Home, store list, and store detail
- Market map, facilities, and visit information
- Promotions, recommendations, and AI visit planner
- Market reviews and market/store review forms

## Backend availability

The source tree provided for conversion contains no backend project. Store
review screens retain the source endpoints (`/api/store-reviews` on ports 4000
and 5000) and surface connection or response errors; they do not report a
successful submission when a service is unavailable. The market review and
AI-planner clients imported by React from `backend/src/clients` are missing, so
their server-backed data and submissions cannot be restored without those
client definitions and a reachable backend.
