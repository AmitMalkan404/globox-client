import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:globox/services/internal/app_state.dart';
import 'package:globox/services/internal/map_utils.dart';
import 'package:globox/ui/items/map_card_item.dart';
import 'package:globox/ui/items/map_items_scroller.dart';
import 'package:globox/ui/widgets/marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../models/classes/package.dart';

class PackageMapView extends StatefulWidget {
  const PackageMapView({super.key, required this.packages});

  final List<Package> packages;

  @override
  State<StatefulWidget> createState() => _PackageMapView();
}

class _PackageMapView extends State<PackageMapView> {
  late AppState appState;
  LatLng? _mapCenter;
  LatLng? _currentPosition;
  double _currentZoom = 15.0;
  final MapController _mapController =
      MapController(); // MapController to control map
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      appState = Provider.of<AppState>(context, listen: false);

      if (appState.currentPosition == null) return;

      _mapCenter = appState.currentPosition;
      _currentPosition = appState.currentPosition;
      _isInitialized = true;
    }
  }

  Future<void> _handleLocationChange() async {
    LatLng latLng = await getCurrentLocation();
    setState(() {
      _mapCenter = latLng;
      _currentPosition = latLng;
      _mapController.move(
        latLng, // מרכז חדש
        _currentZoom,
      );
    });
  }

  void showPackageDetails(BuildContext context, List<Package> packages) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return HorizontalCardScroller(packagesForSingleLocation: packages);
      },
    );
  }

  double getFocusedZoom() {
    return _currentZoom < 19 ? _currentZoom + 1 : _currentZoom;
  }

  void handleGroupMarkerSelection(List<Package> packages) {
    final first = packages.first;
    final center = LatLng(first.coordinates[0], first.coordinates[1]);

    setState(() {
      if (_mapCenter != center) {
        _mapController.move(center, getFocusedZoom());
      }
    });

    showPackageDetails(context, packages);
  }

  @override
  Widget build(BuildContext context) {
    _mapCenter = appState.currentPosition;
    _currentPosition = appState.currentPosition;

    if (_mapCenter == null || _currentPosition == null) {
      return const SizedBox(); // אפשר גם CircularProgressIndicator()
    }

    final groupedPackages = groupPackagesByCoordinates(widget.packages);

    List<Marker> markers = groupedPackages.entries.map((entry) {
      final coordinateParts = entry.key.split(',');
      final lat = double.parse(coordinateParts[0]);
      final lng = double.parse(coordinateParts[1]);

      return MapMarker(
        entry.value.first.packageId,
        LatLng(lat, lng),
        () => handleGroupMarkerSelection(entry.value),
      ).toMarker();
    }).toList();

    // ➕ הוספת המיקום הנוכחי של המשתמש (העיגול הכחול)
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: _currentPosition!,
          width: 80,
          height: 80,
          child: const Icon(
            Icons.album_outlined,
            size: 40,
            color: Colors.blue,
          ),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _mapCenter!,
        initialZoom: _currentZoom,
        onPositionChanged: (position, hasGesture) {
          // Fill your stream when your position changes
          final zoom = position.zoom;
          _mapCenter = position.center;
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
        MarkerLayer(markers: markers),
        Positioned(
          bottom: 20,
          left: 20,
          child: ElevatedButton(
            onPressed: _handleLocationChange,
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent, // הסרת הצללים
                elevation: 0, // הסרת האפקט של הרמה
                padding: EdgeInsets.all(8)),
            child: const Icon(
              Icons.gps_fixed,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }
}
