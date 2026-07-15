import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/platform/generated/nearby_bridge.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/example/find_my_little_brother/generated/NearbyBridge.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.example.find_my_little_brother.generated',
    ),
  ),
)
@HostApi()
abstract class NearbyBridge {
  String initialize();

  bool startAdvertising(String deviceName);

  bool stopAdvertising();

  bool startDiscovery();

  bool stopDiscovery();

  bool requestConnection(String endpointId);

  bool disconnect(String endpointId);

  bool sendMessage(
    String endpointId,
    String message,
  );

  bool sendJson(
    String endpointId,
    String json,
  );
}
