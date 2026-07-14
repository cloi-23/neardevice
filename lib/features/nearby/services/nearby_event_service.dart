import 'package:flutter/services.dart';

class NearbyEventService {
  NearbyEventService._();

  static const EventChannel _channel =
      EventChannel('find_my_little_brother/events');

  static Stream<Map<dynamic, dynamic>> events() {
    return _channel.receiveBroadcastStream().map(
      (event) => Map<dynamic, dynamic>.from(event),
    );
  }
}