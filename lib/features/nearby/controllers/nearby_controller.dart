import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/nearby_device.dart';
import '../services/nearby_event_service.dart';

class NearbyController extends ChangeNotifier {
  final List<NearbyDevice> _devices = [];

  StreamSubscription? _subscription;

  List<NearbyDevice> get devices =>
      List.unmodifiable(_devices);

  void startListening() {
    _subscription ??=
        NearbyEventService.events().listen(_handleEvent);
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _handleEvent(
    Map<dynamic, dynamic> event,
  ) {
    final type = event["type"];

    switch (type) {
      case "device_found":

        final device =
            NearbyDevice.fromMap(event);

        final exists = _devices.any(
          (d) => d.endpointId == device.endpointId,
        );

        if (!exists) {
          _devices.add(device);
          notifyListeners();
        }

        break;

      case "device_lost":

        final endpointId =
            event['endpointId'] as String;

        final isConnected = _devices.any(
          (device) =>
              device.endpointId == endpointId && device.connected,
        );

        if (isConnected) {
          break;
        }

        _devices.removeWhere(
          (d) => d.endpointId == endpointId,
        );

        notifyListeners();

        break;

      case "connected":
        _updateDevice(
          event['endpointId'] as String,
          connected: true,
        );
        break;

      case "disconnected":
        _updateDevice(
          event['endpointId'] as String,
          connected: false,
        );
        break;

      case "text_received":
        _updateDevice(
          event['endpointId'] as String,
          lastMessage: event['message'] as String,
        );
        break;

      case "json_received":
        _updateDevice(
          event['endpointId'] as String,
          lastJson: event['json'] as String,
        );
        break;
    }
  }

  void _updateDevice(
    String endpointId, {
    bool? connected,
    String? lastMessage,
    String? lastJson,
  }) {
    final index = _devices.indexWhere(
      (device) => device.endpointId == endpointId,
    );

    if (index == -1) return;

    _devices[index] = _devices[index].copyWith(
      connected: connected,
      lastMessage: lastMessage,
      lastJson: lastJson,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
