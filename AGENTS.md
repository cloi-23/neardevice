# AGENTS.md

# Find My Little Brother

Android-focused Flutter app for offline nearby-device tracking. Google Nearby Connections handles local peer-to-peer communication; Firebase Realtime Database stores each device's latest foreground location.

## Current status

Nearby discovery, connection, payload delivery, foreground GPS sharing, permission handling, and Firebase location persistence are implemented.

### Working features

- Flutter-to-Kotlin commands through Pigeon
- Native-to-Flutter events through an EventChannel
- Nearby advertising and discovery with dynamic device names from `DeviceInfoService.getDeviceName()`
- Automatic Nearby connection requests and automatic acceptance of incoming requests
- Connected and disconnected events
- UTF-8 text and JSON object/array payload delivery
- Automatic foreground location updates sent as JSON to connected devices
- Radar UI for connected devices
- Firebase Realtime Database persistence of the local device's latest location
- OpenStreetMap view with Firebase-backed device markers
- Startup requests for location and Bluetooth permissions

### Remaining work

- Real-device OpenStreetMap testing
- Background service
- Reconnection behavior
- Broader real-device and Android-version testing
- Release APK preparation

## Architecture

### Flutter

```text
lib/
  core/permissions/
  features/location/services/
  features/nearby/
    controllers/
    models/
    screens/
    services/
    widgets/
  platform/
    generated/
    nearby_platform.dart
  main.dart
```

### Android

```text
MainActivity.kt
NearbyPlugin.kt
generated/
events/NearbyEvents.kt
controllers/
  AdvertisingController.kt
  DiscoveryController.kt
  ConnectionController.kt
  NearbyConnectionCallback.kt
  NearbyDiscoveryCallback.kt
  PayloadController.kt
services/
  DeviceInfoService.kt
  NearbyManager.kt
  NearbyRepository.kt
```

## Communication

```text
Commands: Flutter -> NearbyPlatform -> Pigeon -> NearbyPlugin -> NearbyManager
Events:   NearbyManager -> NearbyEvents -> EventChannel -> Flutter stream
```

`NearbyManager` is the single Android Nearby entry point. It owns the `ConnectionsClient` and coordinates the advertising, discovery, connection, and payload controllers.

## Current behavior

On launch, the app requests the location and Bluetooth permissions, starts advertising and discovery, obtains foreground location updates, and attempts to connect to discovered devices. When connected, it sends location JSON updates to peers and saves the local device's latest location to Firebase. Firebase failures must not interrupt Nearby sharing.

## Coding rules

- Never modify generated Pigeon files; edit `pigeons/` and regenerate instead.
- Compile after every change, and run `flutter analyze` before `flutter run`.
- Keep Flutter UI, permission, location, Firebase, and Nearby concerns separated.
- Use Pigeon for commands and EventChannel for asynchronous native events.
- Do not hardcode device names; use `DeviceInfoService.getDeviceName()`.
- Make repeated start commands idempotent and do not let transient discovery loss reset a connected device.
- Implement one feature at a time; do not redesign the Nearby architecture.

## Workflow

- Branches: `main`, `refactor/nearby-manager`
- Commit after every successful compile.
- Suggested tags: `v0.1-discovery`, `v0.2-connection`, `v0.3-payloads`, `v0.4-gps`, `v1.0-release`

## Long-term goal

Reliable, offline parent/brother tracking on Android 5.0+ using Bluetooth Classic, Bluetooth LE, and Wi-Fi Direct through Google Nearby Connections. The app should work without internet for nearby sharing; Firebase persistence is an optional online enhancement.
