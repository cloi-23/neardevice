# Find My Little Brother

Android-focused Flutter app for offline nearby-device discovery, automatic connection, and location sharing. It uses Google Nearby Connections for peer-to-peer communication and Firebase Realtime Database to persist the local device's latest location.

## Current capabilities

- Advertise and discover nearby Android devices
- Automatically request and accept Nearby Connections
- Send and receive UTF-8 text and JSON payloads
- Automatically share foreground GPS locations with connected devices
- Display connected devices in a radar-style interface
- Save the current device's location, name, accuracy, and timestamp to Firebase Realtime Database
- Request the required location and Bluetooth permissions at startup

## Architecture

Commands flow from Flutter through Pigeon to the Android implementation:

```text
Flutter UI -> NearbyPlatform -> Pigeon -> NearbyPlugin -> NearbyManager -> controllers
```

Asynchronous Android events return through an EventChannel:

```text
NearbyManager -> NearbyEvents -> EventChannel -> NearbyController -> Flutter UI
```

The native Nearby layer is organized around advertising, discovery, connection, and payload controllers. Flutter location and permission concerns remain in `lib/core` and `lib/features/location`.

## Technology

- Flutter and Dart
- Kotlin
- Google Nearby Connections API
- Pigeon and EventChannel
- Geolocator and permission_handler
- Firebase Core and Firebase Realtime Database

## Requirements

- Android 5.0+ target
- Location services enabled and location/Bluetooth permissions granted
- Firebase configured for the Android app when Firebase location persistence is needed

## Run

```bash
flutter pub get
flutter analyze
flutter run
```

The map uses OpenStreetMap tiles and needs no API key. It requires internet access to load map tiles.

For Nearby testing, run the app on two Android devices, grant permissions on both, and keep both devices in the foreground. Each device advertises, discovers, and attempts to connect automatically.

## Roadmap

- [x] Nearby advertising and discovery
- [x] Connection handshake and payload messaging
- [x] Foreground GPS sharing over Nearby
- [x] Firebase location persistence
- [x] OpenStreetMap view for Firebase-stored locations
- [ ] Background location service
- [ ] Reliable reconnection and production release

## License

MIT License
