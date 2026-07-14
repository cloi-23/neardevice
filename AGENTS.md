# AGENTS.md

# Find My Little Brother

Offline child tracking application using the **official Google Nearby Connections API**.

---

# Current Milestone

## Milestone 1

Discovery Complete ✅

Working:

- Flutter
- Kotlin
- Pigeon
- EventChannel
- Nearby Advertising
- Nearby Discovery
- Device Repository
- Flutter device events

Current UI:

```
Nearby Devices

🟢 LG TP260
```

Discovery callback reaches Flutter through EventChannel.

---

# Goal

Universal APK.

No internet.

Two modes:

- Parent
- Brother

Communication:

Google Nearby Connections

- Bluetooth
- BLE
- WiFi Direct

Target:

Android 5.0+

Flutter 3.35.x

---

# Architecture

## Flutter

```
main.dart

core/

platform/

features/

    nearby/

        controllers/

        models/

        services/

        widgets/

        screens/
```

---

## Android

```
MainActivity

NearbyPlugin

NearbyEvents

NearbyManager   (future)

Currently:

NearbyService

AdvertisingController

DiscoveryController

ConnectionController
```

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

Android

Events

Android

↓

EventChannel

↓

Flutter

---

# Current Working Features

Initialize

Advertising

Discovery

EventChannel

Flutter receives:

```
{
 type: device_found,
 endpointId: "...",
 endpointName: "..."
}
```

---

# Current TODO

## High Priority

Replace NearbyService + Controllers

↓

NearbyManager

Reason:

Connection management is becoming shared state.

One manager is simpler.

---

# Roadmap

## Milestone 1

Discovery ✅

## Milestone 2

Connection

requestConnection()

acceptConnection()

disconnect()

## Milestone 3

Payloads

Send text

Send JSON

## Milestone 4

GPS

Geolocator

## Milestone 5

Google Maps

Parent tracks Brother

## Milestone 6

Background Service

Auto reconnect

Foreground notification

---

# Coding Rules

Never edit generated Pigeon files.

Always regenerate.

One feature at a time.

Compile after every change.

flutter analyze should stay clean.

No business logic in MainActivity.

Flutter never imports Android code.

Android callbacks never update UI directly.

Use EventChannel for events.

Use Pigeon for commands.

---

# Future Refactor

Replace

AdvertisingController

DiscoveryController

ConnectionController

NearbyService

with

NearbyManager

This becomes the single owner of:

Advertising

Discovery

Connections

Payloads

Repository

Callbacks

---

# Git Workflow

After every milestone:

```
flutter analyze

flutter test

git add .

git commit
```

Recommended tags:

```
v0.1-discovery

v0.2-connect

v0.3-payload

v0.4-gps

v1.0-release
```

---

# Next Immediate Task

Implement connection handshake.

Current flow:

Advertising

↓

Discovery

↓

Device appears in Flutter

↓

Connect button

↓

requestConnection()

↓

acceptConnection()

↓

Connected

↓

Send payload