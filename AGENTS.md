# AGENTS.md

# Find My Little Brother

Offline parent/child tracking application built with Flutter + Kotlin using the **official Google Nearby Connections API**.

---

# Goal

A universal APK that can run in either mode:

- Parent
- Brother

No Internet required.

Communication uses Google Nearby Connections over:

- Bluetooth
- BLE
- Wi-Fi Direct (handled automatically by Nearby Connections)

Target Android:

- Android 5.0 (API 21)
- Latest Android

Flutter version:

- Flutter 3.35.x

---

# Current Status

## ✅ Module 1 Complete

Architecture completed.

Working:

- Flutter
- Kotlin
- Pigeon bridge
- Google Nearby dependency
- initialize()

App launches and displays:

```
Nearby Ready
```

Bridge:

```
Flutter

↓

NearbyPlatform

↓

Pigeon

↓

MainActivity

↓

NearbyPlugin

↓

NearbyService

↓

Google Nearby
```

---

## ✅ Module 2 Partial

Advertising implemented.

Working:

```
Start Advertising

↓

AdvertisingController

↓

Google Nearby

↓

Advertising Started
```

---

## 🚧 Module 3 In Progress

Discovery starts.

Current state:

```
Discovery Started
```

Phones do NOT discover each other yet.

Likely missing:

- Runtime permissions
- Location Services verification
- Endpoint callback verification

---

# Architecture

## Flutter

```
lib/

app/

core/

features/

platform/

main.dart
```

Platform layer:

```
lib/platform/

generated/
    nearby_bridge.g.dart

nearby_platform.dart
```

DO NOT edit:

```
generated/
```

Only edit:

```
nearby_platform.dart
```

---

## Android

```
android/app/src/main/kotlin/com/example/find_my_little_brother/

MainActivity.kt

plugin/
    NearbyPlugin.kt

services/
    NearbyService.kt

controllers/

    AdvertisingController.kt

    DiscoveryController.kt

    NearbyConnectionCallback.kt

    NearbyDiscoveryCallback.kt

    ConnectionController.kt

    PayloadController.kt
```

---

# Design Rules

MainActivity

Only registers Pigeon.

No business logic.

NearbyPlugin

Only delegates.

No Google Nearby logic.

NearbyService

Business layer.

Owns controllers.

Controllers

One responsibility each.

AdvertisingController

Advertising only.

DiscoveryController

Discovery only.

ConnectionController

Connections only.

PayloadController

Payload only.

---

# Communication

Flutter

↓

NearbyPlatform

↓

Pigeon

↓

NearbyPlugin

↓

NearbyService

↓

Controller

↓

Google Nearby Connections

---

# Future Event Flow

Commands

Flutter

↓

Pigeon

Events

Google Nearby

↓

EventChannel

↓

Flutter

Discovery should eventually use EventChannel.

NOT Pigeon.

---

# Coding Rules

- One file at a time.
- Compile after every file.
- flutter analyze must stay clean.
- Never edit generated Pigeon files.
- Business logic never goes into MainActivity.
- Controllers never talk directly to Flutter.
- Flutter never imports Android code.

---

# Remaining Roadmap

## Module 3

Finish Discovery.

Need:

- Runtime permissions
- Endpoint callbacks
- Device found event

---

## Module 4

Connection.

Implement:

```
requestConnection()

acceptConnection()

rejectConnection()

disconnect()
```

---

## Module 5

Payloads.

JSON packets.

Example:

```json
{
  "type":"location",
  "lat":14.5995,
  "lng":120.9842
}
```

---

## Module 6

GPS.

Using:

geolocator

---

## Module 7

Google Maps.

Parent sees Brother location.

---

## Module 8

Background Service.

Auto reconnect.

Foreground notification.

---

## Module 9

Release APK.

Single universal APK.

Mode selected on startup.

---

# Current Problem

Advertising works.

Discovery starts.

Phones do not discover each other.

Need to verify:

- Runtime permissions
- Location Services enabled
- Same SERVICE_ID
- Same Strategy (P2P_STAR)
- EndpointDiscoveryCallback firing

---

# Current Dependencies

Flutter

permission_handler

flutter_riverpod (planned)

Pigeon

Official Google Nearby Connections API

NO nearby_connections Flutter plugin.

---

# Philosophy

Build vertical slices.

Every module must compile.

Every module must be testable on two physical Android phones.

Never leave broken code in the project.

Architecture is prioritized over quick hacks.
