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
            event["endpointId"];

        _devices.removeWhere(
          (d) => d.endpointId == endpointId,
        );

        notifyListeners();

        break;
    }
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}