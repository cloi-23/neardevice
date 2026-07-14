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

Refactoring Android architecture before implementing connection.

Discovery is working.

We are replacing NearbyService with NearbyManager.

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
    NearbyService.kt (temporary wrapper - scheduled for removal)
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

Device name now comes from:

DeviceInfoService.getDeviceName()

instead of a hardcoded string.

NearbyPlugin has been updated to use NearbyManager.

---

## Remaining Refactor

Search project for:

NearbyService

If there are no remaining references:

Delete

NearbyService.kt

NearbyManager becomes the single Nearby entry point.

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

Not Implemented

- Connect button
- requestConnection()
- acceptConnection()
- Payloads
- GPS
- Maps
- Background service

---

# Immediate Next Task

Implement connection handshake.

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

Send "Hello"

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