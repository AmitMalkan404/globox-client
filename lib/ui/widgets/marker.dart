import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final String packageId;
  final LatLng latLng;
  final void Function() onPressed;

  const MapMarker(
    this.packageId,
    this.latLng,
    this.onPressed,
  );

  Marker toMarker() {
    const double iconSize = 36.0;

    return Marker(
      point: latLng,
      width: iconSize,
      height: iconSize * 1.5, // Height adjusted to the shape of the pin
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (TapUpDetails details) {
          // Getting the global pressure point
          final Offset localPosition = details.localPosition;

          if (_isInsidePin(localPosition, iconSize)) {
            onPressed();
          }
        },
        child: Icon(
          Icons.location_on,
          color: Colors.red,
          size: iconSize,
        ),
      ),
    );
  }

  bool _isInsidePin(Offset position, double size) {
    // Checking if the click point is inside the icon shape
    final double centerX = size / 2;
    final double centerY = size / 2;

    final double dx = position.dx - centerX;
    final double dy = position.dy - centerY;

    final double distance = dx * dx + dy * dy;

    return distance <= (size / 2) * (size / 2); // Circle around the icon shape
  }
}
