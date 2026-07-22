import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/nearby_device.dart';
import '../services/nearby_event_service.dart';

class NearbyController extends ChangeNotifier {
  final List<NearbyDevice> _devices = [];

  StreamSubscription? _subscription;
  String? _nearbyStatus;

  List<NearbyDevice> get devices => List.unmodifiable(_devices);
  String? get nearbyStatus => _nearbyStatus;

  void startListening() {
    _subscription ??= NearbyEventService.events().listen(_handleEvent);
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _handleEvent(Map<dynamic, dynamic> event) {
    final type = event["type"];

    switch (type) {
      case 'status':
        _nearbyStatus = event['message'] as String;
        notifyListeners();
        break;

      case "device_found":
        final device = NearbyDevice.fromMap(event);

        final exists = _devices.any((d) => d.endpointId == device.endpointId);

        if (!exists) {
          _devices.add(device);
          notifyListeners();
        } else {
          // A device can be lost while it is connected, then rediscovered after
          // the connection drops. Notify the dashboard so it can retry.
          notifyListeners();
        }

        break;

      case "device_lost":
        final endpointId = event['endpointId'] as String;

        final isConnected = _devices.any(
          (device) => device.endpointId == endpointId && device.connected,
        );

        if (isConnected) {
          break;
        }

        _devices.removeWhere((d) => d.endpointId == endpointId);

        notifyListeners();

        break;

      case "connected":
        _updateDevice(event['endpointId'] as String, connected: true);
        break;

      case "disconnected":
        _updateDevice(event['endpointId'] as String, connected: false);
        break;

      case "text_received":
        _updateDevice(
          event['endpointId'] as String,
          lastMessage: event['message'] as String,
        );
        break;

      case "json_received":
        _handleJsonReceived(
          event['endpointId'] as String,
          event['json'] as String,
        );
        break;
    }
  }

  void _handleJsonReceived(String endpointId, String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic> && decoded['type'] == 'location') {
        final latitude = decoded['latitude'];
        final longitude = decoded['longitude'];
        final accuracy = decoded['accuracy'];

        if (latitude is num && longitude is num) {
          _updateDevice(
            endpointId,
            latitude: latitude.toDouble(),
            longitude: longitude.toDouble(),
            locationAccuracy: accuracy is num ? accuracy.toDouble() : null,
          );
          return;
        }
      }
    } on FormatException {
      // Native code only emits this event for valid JSON. Keep the payload visible
      // if an unexpected valid JSON shape reaches Flutter.
    }

    _updateDevice(endpointId, lastJson: json);
  }

  void _updateDevice(
    String endpointId, {
    bool? connected,
    String? lastMessage,
    String? lastJson,
    double? latitude,
    double? longitude,
    double? locationAccuracy,
  }) {
    final index = _devices.indexWhere(
      (device) => device.endpointId == endpointId,
    );

    if (index == -1) return;

    _devices[index] = _devices[index].copyWith(
      connected: connected,
      lastMessage: lastMessage,
      lastJson: lastJson,
      latitude: latitude,
      longitude: longitude,
      locationAccuracy: locationAccuracy,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
