import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/nearby_device.dart';
import 'location_radar.dart';

class NearbyDeviceTile extends StatelessWidget {
  const NearbyDeviceTile({
    super.key,
    required this.device,
    required this.currentPosition,
  });

  final NearbyDevice device;
  final Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    final hasRemoteLocation =
        device.latitude != null && device.longitude != null;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.radar, color: Colors.green),
            title: Text(device.endpointName),
            subtitle: Text(
              hasRemoteLocation
                  ? 'Location received (+/-${device.locationAccuracy?.round() ?? '?'} m)'
                  : 'Connected — waiting for location…',
            ),
          ),
          if (currentPosition != null && hasRemoteLocation)
            LocationRadar(
              deviceName: device.endpointName,
              localLatitude: currentPosition!.latitude,
              localLongitude: currentPosition!.longitude,
              remoteLatitude: device.latitude!,
              remoteLongitude: device.longitude!,
            )
          else
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
