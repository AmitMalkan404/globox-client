import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:latlong2/latlong.dart';

import '../../models/package.dart';

class PackageMapView extends StatelessWidget {
  final List<Package> packages;

  const PackageMapView({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(32.1553, 34.898),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        const MapCompass.cupertino(
          hideIfRotatedNorth: true,
        ),

        // Or use the primary constructor to customize all
        const MapCompass(
          icon: Icon(Icons.arrow_upward),
          hideIfRotatedNorth: true,
        ),
      ],
    );
  }
}
