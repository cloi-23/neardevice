import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_database_service.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final LocationDatabaseService _locationDatabaseService =
      LocationDatabaseService();
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Locations')),
      body: StreamBuilder<DatabaseEvent>(
        stream: _locationDatabaseService.watchLocations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const _MapMessage(
              icon: Icons.cloud_off,
              message: 'Could not load saved locations.',
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final locations = _locationsFromSnapshot(snapshot.data!.snapshot);
          if (locations.isEmpty) {
            return const _MapMessage(
              icon: Icons.location_off_outlined,
              message: 'No device locations have been saved yet.',
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: locations.first.position,
                  initialZoom: 15,
                  onMapReady: () => _moveCameraToLocations(locations),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.find_my_little_brother',
                  ),
                  MarkerLayer(
                    markers: locations.map(_markerForLocation).toList(),
                  ),
                ],
              ),
              const Positioned(
                left: 8,
                bottom: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white70),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      '© OpenStreetMap contributors',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  tooltip: 'Show all devices',
                  onPressed: () => _moveCameraToLocations(locations),
                  child: const Icon(Icons.center_focus_strong),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Marker _markerForLocation(_SavedLocation location) {
    final accuracy = location.accuracy == null
        ? 'Accuracy unavailable'
        : 'Accuracy: ±${location.accuracy!.round()} m';
    return Marker(
      point: location.position,
      width: 48,
      height: 56,
      child: Tooltip(
        message: '${location.deviceName}\n$accuracy',
        child: const Icon(Icons.location_pin, color: Colors.red, size: 48),
      ),
    );
  }

  void _moveCameraToLocations(List<_SavedLocation> locations) {
    if (locations.length == 1) {
      _mapController.move(locations.single.position, 16);
      return;
    }
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(
          locations.map((location) => location.position).toList(),
        ),
        padding: const EdgeInsets.all(64),
      ),
    );
  }

  List<_SavedLocation> _locationsFromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value;
    if (value is! Map) return const [];
    return value.entries
        .map((entry) {
          final details = entry.value;
          if (details is! Map) return null;
          final latitude = details['latitude'];
          final longitude = details['longitude'];
          if (latitude is! num || longitude is! num) return null;
          return _SavedLocation(
            deviceId: entry.key.toString(),
            deviceName: details['deviceName']?.toString() ?? 'Unknown device',
            position: LatLng(latitude.toDouble(), longitude.toDouble()),
            accuracy: details['accuracy'] is num
                ? (details['accuracy'] as num).toDouble()
                : null,
          );
        })
        .whereType<_SavedLocation>()
        .toList(growable: false);
  }
}

class _SavedLocation {
  const _SavedLocation({
    required this.deviceId,
    required this.deviceName,
    required this.position,
    required this.accuracy,
  });

  final String deviceId;
  final String deviceName;
  final LatLng position;
  final double? accuracy;
}

class _MapMessage extends StatelessWidget {
  const _MapMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
