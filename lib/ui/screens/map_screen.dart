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
    Marker buildMarker(LatLng coordinates) {
      return Marker(
        point: coordinates,
        width: 100,
        height: 12,
        child: Icon(
          Icons.location_on,
          color: Colors.red, // ניתן לשנות את הצבע אם תרצה
          size: 24.0, // ניתן להתאים את הגודל
        ),
      );
    }

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
        MarkerLayer(
            markers: packages.map((pckg) {
          // המרה של List<double> ל-LatLng
          final coordinates = LatLng(pckg.coordinates[0], pckg.coordinates[1]);
          return buildMarker(coordinates);
        }).toList())
      ],
    );
  }
}
