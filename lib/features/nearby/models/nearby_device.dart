class NearbyDevice {
  final String endpointId;
  final String endpointName;
  final bool connected;
  final String? lastMessage;
  final String? lastJson;

  const NearbyDevice({
    required this.endpointId,
    required this.endpointName,
    this.connected = false,
    this.lastMessage,
    this.lastJson,
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
    String? lastMessage,
    String? lastJson,
  }) {
    return NearbyDevice(
      endpointId: endpointId,
      endpointName: endpointName,
      connected: connected ?? this.connected,
      lastMessage: lastMessage ?? this.lastMessage,
      lastJson: lastJson ?? this.lastJson,
    );
  }
}
