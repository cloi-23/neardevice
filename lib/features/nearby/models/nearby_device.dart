class NearbyDevice {
  final String endpointId;
  final String endpointName;
  final bool connected;

  const NearbyDevice({
    required this.endpointId,
    required this.endpointName,
    this.connected = false,
  });

  factory NearbyDevice.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return NearbyDevice(
      endpointId: map['endpointId'] as String,
      endpointName: map['endpointName'] as String,
      connected: false,
    );
  }

  NearbyDevice copyWith({
    bool? connected,
  }) {
    return NearbyDevice(
      endpointId: endpointId,
      endpointName: endpointName,
      connected: connected ?? this.connected,
    );
  }
}