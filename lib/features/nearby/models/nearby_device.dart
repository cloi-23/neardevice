class NearbyDevice {
  final String endpointId;
  final String endpointName;
  final bool connected;
  final String? lastMessage;
  final String? lastJson;
  final double? latitude;
  final double? longitude;
  final double? locationAccuracy;

  const NearbyDevice({
    required this.endpointId,
    required this.endpointName,
    this.connected = false,
    this.lastMessage,
    this.lastJson,
    this.latitude,
    this.longitude,
    this.locationAccuracy,
  });

  factory NearbyDevice.fromMap(Map<dynamic, dynamic> map) {
    return NearbyDevice(
      endpointId: map['endpointId'] as String,
      endpointName: map['endpointName'] as String,
      connected: false,
    );
  }

  NearbyDevice copyWith({
    bool? connected,
    String? lastMessage,
    String? lastJson,
    double? latitude,
    double? longitude,
    double? locationAccuracy,
  }) {
    return NearbyDevice(
      endpointId: endpointId,
      endpointName: endpointName,
      connected: connected ?? this.connected,
      lastMessage: lastMessage ?? this.lastMessage,
      lastJson: lastJson ?? this.lastJson,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationAccuracy: locationAccuracy ?? this.locationAccuracy,
    );
  }
}
