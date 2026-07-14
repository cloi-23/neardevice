import 'generated/nearby_bridge.g.dart';

class NearbyPlatform {
  NearbyPlatform._();

  static final NearbyBridge _bridge = NearbyBridge();

  static Future<String> initialize() {
    return _bridge.initialize();
  }

  static Future<bool> startAdvertising(String deviceName) {
    return _bridge.startAdvertising(deviceName);
  }

  static Future<bool> stopAdvertising() {
    return _bridge.stopAdvertising();
  }

  static Future<bool> startDiscovery() {
    return _bridge.startDiscovery();
  }

  static Future<bool> stopDiscovery() {
    return _bridge.stopDiscovery();
  }

  static Future<bool> disconnect() {
    return _bridge.disconnect();
  }

  static Future<bool> sendMessage(
    String endpointId,
    String message,
  ) {
    return _bridge.sendMessage(
      endpointId,
      message,
    );
  }
}