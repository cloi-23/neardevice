# AGENTS.md

# Find My Little Brother

Offline Android child-tracking application built with Flutter and the official Google Nearby Connections API.

---

# Current Status

## Milestone 1 - Discovery ✅

Working:

- Flutter ↔ Kotlin bridge (Pigeon)
- EventChannel
- Google Nearby Connections API
- Advertising
- Discovery
- Device repository
- Flutter receives nearby devices
- Automatic Android device name (DeviceInfoService)

Current result:

Phone A

Advertising

↓

Phone B

Discovery

↓

Flutter UI receives

device_found

↓

Nearby device appears in list

---

# Current Milestone

Connection handshake source and Pigeon bridge are complete. `flutter analyze`
passes; Android build and two-device handshake testing remain.

Discovery remains working.

---

# Flutter Architecture

lib/

```
core/
    permissions/

features/
    nearby/
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

---

# Android Architecture

```
MainActivity.kt

NearbyPlugin.kt

generated/

events/
    NearbyEvents.kt

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

---

# Refactor Progress

## Completed

Created

NearbyManager.kt

NearbyManager now owns:

- ConnectionsClient
- AdvertisingController
- DiscoveryController
- ConnectionController
- PayloadController
- NearbyConnectionCallback

Device name now comes from:

DeviceInfoService.getDeviceName()

instead of a hardcoded string.

NearbyPlugin has been updated to use NearbyManager. NearbyService has been
removed; NearbyManager is the single Nearby entry point.

---

# Communication

Commands

Flutter

↓

NearbyPlatform

↓

Pigeon

↓

NearbyPlugin

↓

NearbyManager

Events

NearbyManager

↓

NearbyEvents

↓

EventChannel

↓

Flutter Stream

---

# Current Features

Working

- Initialize
- Advertising
- Discovery
- Device found event
- Device lost event
- Connect button sends `requestConnection(endpointId)` through Pigeon
- Incoming connection requests are accepted automatically
- Connected and disconnected events are sent through the EventChannel
- A successful connection automatically sends a UTF-8 `Hello` text payload
- Connected devices can send `Hello` through the Flutter UI and Pigeon
- Received text payloads are published through the EventChannel and displayed
  for the nearby device
- Connected devices can send JSON object or array payloads through the Flutter
  UI and Pigeon
- Received JSON object or array payloads are published as JSON events and
  displayed for the nearby device; plain text remains a text event
- Connected-device actions include Send Hello, Send JSON, and Disconnect;
  disconnect before starting a new connection flow
- Repeated Start Advertising and Start Discovery commands are idempotent, and
  transient discovery loss does not reset a connected device in Flutter

Not Implemented

- GPS
- Maps
- Background service

---

# Immediate Next Task

Test JSON payload delivery on two Android devices.

Target flow:

Advertising

↓

Discovery

↓

Device appears

↓

Connect button

↓

requestConnection(endpointId)

↓

Phone A

onConnectionInitiated()

↓

acceptConnection()

↓

Connected Event

↓

Send and receive "Hello"

---

# Coding Rules

Never modify generated Pigeon files.

Always regenerate after editing pigeons/.

Compile after every change.

Run

flutter analyze

before flutter run.

One feature at a time.

Keep Flutter UI separate from Nearby logic.

Use EventChannel for asynchronous events.

Use Pigeon for command calls.

Do not hardcode device names.

Use

DeviceInfoService.getDeviceName()

---

# Git Workflow

Branches

main

refactor/nearby-manager

Commit after every successful compile.

Suggested tags

v0.1-discovery

v0.2-connection

v0.3-payloads

v0.4-gps

v1.0-release

---

# Long-Term Goal

Offline parent/brother tracking.

Communication:

Google Nearby Connections

Mediums:

- Bluetooth Classic
- Bluetooth LE
- Wi-Fi Direct

Target:

Android 5.0+

No internet required.

Universal APK.

---

# Important Notes

Discovery has been fully proven.

Do not redesign architecture again.

Finish remaining modules using the current structure:

NearbyPlugin

↓

NearbyManager

↓

Controllers

↓

NearbyEvents

↓

Flutter

Future work should focus on functionality, not further refactoring.
