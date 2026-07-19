import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationRadar extends StatelessWidget {
  const LocationRadar({
    super.key,
    required this.deviceName,
    required this.localLatitude,
    required this.localLongitude,
    required this.remoteLatitude,
    required this.remoteLongitude,
  });

  final String deviceName;
  final double localLatitude;
  final double localLongitude;
  final double remoteLatitude;
  final double remoteLongitude;

  @override
  Widget build(BuildContext context) {
    final distance = Geolocator.distanceBetween(
      localLatitude,
      localLongitude,
      remoteLatitude,
      remoteLongitude,
    );
    final bearing = Geolocator.bearingBetween(
      localLatitude,
      localLongitude,
      remoteLatitude,
      remoteLongitude,
    );
    final scale = _radarScale(distance);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: CustomPaint(
              painter: _RadarPainter(
                bearing: bearing,
                distance: distance,
                scale: scale,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Text(
            '$deviceName: ${_distanceText(distance)} ${_directionText(bearing)}',
            textAlign: TextAlign.center,
          ),
          Text('Radar range: ${_distanceText(scale)}'),
        ],
      ),
    );
  }

  double _radarScale(double distance) {
    if (distance <= 25) return 25;
    if (distance <= 100) return 100;
    if (distance <= 500) return 500;
    if (distance <= 1000) return 1000;
    return distance * 1.2;
  }

  String _distanceText(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  String _directionText(double bearing) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((bearing + 22.5) ~/ 45) % directions.length;
    return directions[index];
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({
    required this.bearing,
    required this.distance,
    required this.scale,
    required this.color,
  });

  final double bearing;
  final double distance;
  final double scale;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;
    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final factor in [1 / 3, 2 / 3, 1.0]) {
      canvas.drawCircle(center, radius * factor, ringPaint);
    }
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      ringPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      ringPaint,
    );

    final angle = (bearing - 90) * math.pi / 180;
    final dotDistance = math.min(distance / scale, 1.0) * radius;
    final dot = Offset(
      center.dx + math.cos(angle) * dotDistance,
      center.dy + math.sin(angle) * dotDistance,
    );
    canvas.drawCircle(center, 6, Paint()..color = color);
    canvas.drawCircle(dot, 8, Paint()..color = Colors.red);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(center.dx - 4, 0));
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) {
    return bearing != oldDelegate.bearing ||
        distance != oldDelegate.distance ||
        scale != oldDelegate.scale ||
        color != oldDelegate.color;
  }
}
