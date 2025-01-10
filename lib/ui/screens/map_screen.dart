import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:globox/ui/items/map_item.dart';
import 'package:globox/ui/widgets/marker.dart';
import 'package:latlong2/latlong.dart';
import '../../models/package.dart';

class PackageMapView extends StatefulWidget {
  const PackageMapView({super.key, required this.packages});

  final List<Package> packages;

  @override
  State<StatefulWidget> createState() => _PackageMapView();
}

class _PackageMapView extends State<PackageMapView> {
  LatLng? _currentLatLng;
  double _currentZoom = 13.0;
  final MapController _mapController =
      MapController(); // MapController to control map

  void showPackageDetails(BuildContext context, Package package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return PackageDetailsWidget(package: package);
      },
    );
  }

  double getFocusedZoom() {
    return _currentZoom < 19 ? _currentZoom + 1 : _currentZoom;
  }

  void handleMarkerSelection(Package pckg) {
    setState(() {
      if (LatLng(pckg.coordinates[0], pckg.coordinates[1]) == _currentLatLng) {
        return;
      }
      _mapController.move(
        LatLng(pckg.coordinates[0], pckg.coordinates[1]), // מרכז חדש
        getFocusedZoom(),
      );
    });
    showPackageDetails(context, pckg);
  }

  @override
  Widget build(BuildContext context) {
    Marker buildMarker(Package pckg) {
      return MapMarker(
        pckg.packageId,
        LatLng(pckg.coordinates[0], pckg.coordinates[1]),
        () => handleMarkerSelection(pckg),
      ).toMarker();
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(32.1553, 34.898),
        initialZoom: _currentZoom,
        onPositionChanged: (position, hasGesture) {
          // Fill your stream when your position changes
          final zoom = position.zoom;
          _currentLatLng = position.center;
          if (zoom != null) {
            _currentZoom = zoom;
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        const MapCompass.cupertino(
          hideIfRotatedNorth: true,
        ),
        const MapCompass(
          icon: Icon(Icons.arrow_upward),
          hideIfRotatedNorth: true,
        ),
        MarkerLayer(
            markers: widget.packages.map((pckg) {
          return buildMarker(pckg);
        }).toList())
      ],
    );
  }
}
