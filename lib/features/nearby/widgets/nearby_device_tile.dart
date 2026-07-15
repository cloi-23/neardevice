import 'package:flutter/material.dart';

import '../models/nearby_device.dart';

enum NearbyDeviceAction {
  sendHello,
  sendJson,
  disconnect,
}

class NearbyDeviceTile extends StatelessWidget {

  final NearbyDevice device;
  final Future<void> Function(NearbyDevice device) onConnect;
  final Future<void> Function(
    NearbyDevice device,
    NearbyDeviceAction action,
  ) onConnectedAction;

  const NearbyDeviceTile({
    super.key,
    required this.device,
    required this.onConnect,
    required this.onConnectedAction,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.all(8),

      child: ListTile(

        isThreeLine: device.connected,

        leading: const Icon(
          Icons.phone_android,
          color: Colors.green,
        ),

        title: Text(device.endpointName),

        subtitle: Text(
          device.lastJson != null
              ? 'JSON: ${device.lastJson}'
              : device.lastMessage != null
                  ? 'Message: ${device.lastMessage}'
                  : device.endpointId,
        ),

        trailing: device.connected
            ? PopupMenuButton<NearbyDeviceAction>(
                onSelected: (action) => onConnectedAction(device, action),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: NearbyDeviceAction.sendHello,
                    child: Text('Send Hello'),
                  ),
                  PopupMenuItem(
                    value: NearbyDeviceAction.sendJson,
                    child: Text('Send JSON'),
                  ),
                  PopupMenuItem(
                    value: NearbyDeviceAction.disconnect,
                    child: Text('Disconnect'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () => onConnect(device),
                child: const Text('Connect'),
              ),

      ),

    );

  }
}
