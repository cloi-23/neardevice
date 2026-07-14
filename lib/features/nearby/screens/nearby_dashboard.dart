import 'package:flutter/material.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../platform/nearby_platform.dart';
import '../controllers/nearby_controller.dart';
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
                        content: Text("Location permission required"),
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
                        content: Text("Location permission required"),
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
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
}