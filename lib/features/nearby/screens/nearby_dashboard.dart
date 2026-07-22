import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/permissions/permission_service.dart';
import '../../../platform/nearby_platform.dart';
import '../../location/services/location_service.dart';
import '../../location/services/location_database_service.dart';
import '../controllers/nearby_controller.dart';
import '../models/nearby_device.dart';
import '../widgets/nearby_device_tile.dart';

class NearbyDashboard extends StatefulWidget {
  const NearbyDashboard({super.key});

  @override
  State<NearbyDashboard> createState() => _NearbyDashboardState();
}

class _NearbyDashboardState extends State<NearbyDashboard> {
  final NearbyController controller = NearbyController();
  final LocationService _locationService = const LocationService();
  final LocationDatabaseService _locationDatabaseService =
      LocationDatabaseService();
  final Set<String> _requestedEndpointIds = {};
  final Set<String> _connectedEndpointIds = {};

  StreamSubscription<Position>? _positionSubscription;
  Timer? _locationRefreshTimer;
  Position? _currentPosition;
  String _status = 'Preparing nearby search...';
  bool _isRefreshingLocation = false;
  String? _deviceId;
  String? _deviceName;

  @override
  void initState() {
    super.initState();
    controller.addListener(_handleControllerChange);
    controller.startListening();
    unawaited(_loadDeviceDetails());
    unawaited(_startAutomaticNearby());
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _locationRefreshTimer?.cancel();
    controller
      ..removeListener(_handleControllerChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectedDevices = controller.devices
        .where((device) => device.connected)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Nearby Devices'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: connectedDevices.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Flexible(child: Text(_status)),
                    ],
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.radar,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tracking ${connectedDevices.length} '
                              '${connectedDevices.length == 1 ? 'device' : 'devices'}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Text('Searching for more nearby phones'),
                          ],
                        ),
                      ),
                      const Icon(Icons.wifi_tethering),
                    ],
                  ),
          ),
          const Divider(height: 1),
          Expanded(
            child: connectedDevices.isEmpty
                ? const Center(
                    child: Text(
                      'Searching for your brother\'s phone...',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: connectedDevices.length,
                    itemBuilder: (_, index) {
                      return NearbyDeviceTile(
                        device: connectedDevices[index],
                        currentPosition: _currentPosition,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _startAutomaticNearby() async {
    final granted = await PermissionService.requestNearbyPermissions();
    if (!mounted) return;

    if (!granted) {
      _setStatus('Location permission is needed to search and show radar.');
      return;
    }

    _setStatus('Starting nearby search...');
    final advertisingStarted = await NearbyPlatform.startAdvertising('');
    final discoveryStarted = await NearbyPlatform.startDiscovery();
    if (!mounted) return;

    if (!advertisingStarted || !discoveryStarted) {
      _setStatus('Could not start nearby search.');
      return;
    }

    _setStatus('Searching for more nearby phones...');
    await _refreshLocation();
    _positionSubscription = _locationService.watchPosition().listen(
      _onPositionUpdated,
      onError: (_) =>
          _setStatus('Location updates are temporarily unavailable.'),
    );
    _locationRefreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => unawaited(_refreshLocation()),
    );
  }

  Future<void> _refreshLocation() async {
    if (_isRefreshingLocation) return;

    _isRefreshingLocation = true;
    try {
      _onPositionUpdated(await _locationService.getCurrentPosition());
    } on AppLocationServiceDisabledException {
      _setStatus('Turn on location services to show radar.');
    } on AppLocationPermissionDeniedException {
      _setStatus('Location permission is needed to show radar.');
    } catch (_) {
      _setStatus('Waiting for a GPS location fix...');
    } finally {
      _isRefreshingLocation = false;
    }
  }

  void _onPositionUpdated(Position position) {
    if (!mounted) return;

    setState(() {
      _currentPosition = position;
    });
    unawaited(_sendLocationToConnectedDevices(position));
    unawaited(_saveLocationToDatabase(position));
  }

  Future<void> _loadDeviceDetails() async {
    try {
      final details = await Future.wait([
        NearbyPlatform.getDeviceId(),
        NearbyPlatform.getDeviceName(),
      ]);
      if (!mounted) return;
      _deviceId = details[0];
      _deviceName = details[1];
      final currentPosition = _currentPosition;
      if (currentPosition != null) {
        unawaited(_saveLocationToDatabase(currentPosition));
      }
    } catch (_) {
      _setStatus('Could not identify this device for Firebase.');
    }
  }

  Future<void> _saveLocationToDatabase(Position position) async {
    final deviceId = _deviceId;
    final deviceName = _deviceName;
    if (deviceId == null || deviceName == null) return;

    try {
      await _locationDatabaseService.saveLocation(
        deviceId: deviceId,
        deviceName: deviceName,
        position: position,
      );
    } catch (_) {
      // Nearby location sharing continues if Firebase is unavailable.
    }
  }

  void _handleControllerChange() {
    if (!mounted) return;

    final nearbyStatus = controller.nearbyStatus;
    if (nearbyStatus != null) {
      _setStatus(nearbyStatus);
    }

    final discoveredEndpointIds = controller.devices
        .map((device) => device.endpointId)
        .toSet();
    _requestedEndpointIds.removeWhere(
      (endpointId) => !discoveredEndpointIds.contains(endpointId),
    );
    _connectedEndpointIds.removeWhere(
      (endpointId) => !discoveredEndpointIds.contains(endpointId),
    );

    setState(() {});
    unawaited(_connectToDiscoveredDevices());
  }

  Future<void> _connectToDiscoveredDevices() async {
    for (final device in controller.devices) {
      if (device.connected) {
        if (_connectedEndpointIds.add(device.endpointId)) {
          _setStatus(
            'Connected to ${device.endpointName}. Finding location...',
          );
          if (_currentPosition != null) {
            await _sendLocation(device, _currentPosition!);
          }
        }
        continue;
      }

      _connectedEndpointIds.remove(device.endpointId);
      // A previous request may have failed while the device was out of range.
      // A new discovery event must be allowed to request a connection again.
      _requestedEndpointIds.remove(device.endpointId);
      if (_requestedEndpointIds.add(device.endpointId)) {
        _setStatus('Connecting to ${device.endpointName}...');
        final requested = await NearbyPlatform.requestConnection(
          device.endpointId,
        );
        if (!requested) {
          _requestedEndpointIds.remove(device.endpointId);
        }
      }
    }
  }

  Future<void> _sendLocationToConnectedDevices(Position position) async {
    final devices = controller.devices.where((device) => device.connected);
    for (final device in devices) {
      await _sendLocation(device, position);
    }
  }

  Future<void> _sendLocation(NearbyDevice device, Position position) {
    return NearbyPlatform.sendJson(
      device.endpointId,
      jsonEncode({
        'type': 'location',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
      }),
    );
  }

  void _setStatus(String status) {
    if (!mounted) return;
    setState(() {
      _status = status;
    });
  }
}
