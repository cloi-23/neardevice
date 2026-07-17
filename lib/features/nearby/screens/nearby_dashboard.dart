import 'package:flutter/material.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../platform/nearby_platform.dart';
import '../controllers/nearby_controller.dart';
import '../models/nearby_device.dart';
import '../widgets/nearby_device_tile.dart';

class NearbyDashboard extends StatefulWidget {
  const NearbyDashboard({super.key});

  @override
  State<NearbyDashboard> createState() =>
      _NearbyDashboardState();
}

class _NearbyDashboardState
    extends State<NearbyDashboard> {

  final NearbyController controller =
      NearbyController();

  @override
  void initState() {
    super.initState();

    controller.startListening();

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Find My Little Brother"),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                onPressed: () async {

                final granted =
                    await PermissionService.requestNearbyPermissions();

                if (!context.mounted) return;

                if (!granted) {

                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Nearby permissions required"),
                    ),
                    );

                    return;
                }

                final ok =
                    await NearbyPlatform.startAdvertising(
                    "",
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text(
                        ok
                            ? "Advertising Started"
                            : "Advertising Failed",
                    ),
                    ),
                );

                },
                  child: const Text("Start Advertising"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                onPressed: () async {

                final granted =
                    await PermissionService.requestNearbyPermissions();

                if (!context.mounted) return;

                if (!granted) {

                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Nearby permissions required"),
                    ),
                    );

                    return;
                }

                final ok =
                    await NearbyPlatform.startDiscovery();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text(
                        ok
                            ? "Discovery Started"
                            : "Discovery Failed",
                    ),
                    ),
                );

                },
                  child: const Text("Start Discovery"),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: controller.devices.isEmpty
              ? const Center(
                  child: Text(
                    "No nearby devices",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (_, index) {
                    return NearbyDeviceTile(
                      device: controller.devices[index],
                      onConnect: _connectToDevice,
                      onConnectedAction: _handleConnectedAction,
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

  Future<void> _connectToDevice(NearbyDevice device) async {
    final ok = await NearbyPlatform.requestConnection(device.endpointId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Connection request sent to ${device.endpointName}'
              : 'Could not request a connection',
        ),
      ),
    );
  }

  Future<void> _sendHello(NearbyDevice device) async {
    final ok = await NearbyPlatform.sendMessage(
      device.endpointId,
      'Hello',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Hello sent to ${device.endpointName}' : 'Could not send Hello',
        ),
      ),
    );
  }

  Future<void> _sendJson(NearbyDevice device) async {
    const json = '{"type":"hello","message":"Hello"}';
    final ok = await NearbyPlatform.sendJson(device.endpointId, json);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'JSON sent to ${device.endpointName}' : 'Could not send JSON',
        ),
      ),
    );
  }

  Future<void> _disconnect(NearbyDevice device) async {
    final ok = await NearbyPlatform.disconnect(device.endpointId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Disconnected from ${device.endpointName}'
              : 'Could not disconnect from ${device.endpointName}',
        ),
      ),
    );
  }

  Future<void> _handleConnectedAction(
    NearbyDevice device,
    NearbyDeviceAction action,
  ) {
    switch (action) {
      case NearbyDeviceAction.sendHello:
        return _sendHello(device);
      case NearbyDeviceAction.sendJson:
        return _sendJson(device);
      case NearbyDeviceAction.disconnect:
        return _disconnect(device);
    }
  }
}
