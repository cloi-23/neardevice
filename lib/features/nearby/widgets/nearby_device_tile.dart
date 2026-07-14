import 'package:flutter/material.dart';

import '../models/nearby_device.dart';

class NearbyDeviceTile extends StatelessWidget {

  final NearbyDevice device;

  const NearbyDeviceTile({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.all(8),

      child: ListTile(

        leading: const Icon(
          Icons.phone_android,
          color: Colors.green,
        ),

        title: Text(device.endpointName),

        subtitle: Text(device.endpointId),

        trailing: ElevatedButton(

          onPressed: () {

          },

          child: const Text(
            "Connect",
          ),

        ),

      ),

    );

  }
}