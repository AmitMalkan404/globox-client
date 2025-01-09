import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:globox/ui/widgets/map_item.dart';
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

  @override
  Widget build(BuildContext context) {
    Marker buildMarker(Package pckg) {
      return MapMarker(
        pckg.packageId,
        LatLng(pckg.coordinates[0], pckg.coordinates[1]),
        () {
          showPackageDetails(context, pckg);
        },
      ).toMarker();
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
