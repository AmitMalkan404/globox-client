import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globox/providers/location_provider.dart';
import 'package:globox/services/internal/map_utils.dart';
import 'package:globox/ui/items/map_items_scroller.dart';
import 'package:globox/ui/widgets/marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/classes/package.dart';

// ---------------------------------------------------------------------------
// Public widget — accepts packages from the parent.
// ---------------------------------------------------------------------------

class PackageMapView extends ConsumerWidget {
  const PackageMapView({super.key, required this.packages});

  final List<Package> packages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);

    return locationAsync.when(
      // ── Loading ────────────────────────────────────────────────────────────
      loading: () => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Finding your location…'),
          ],
        ),
      ),

      // ── Error ──────────────────────────────────────────────────────────────
      error: (error, _) => _LocationErrorView(error: error),

      // ── Data ───────────────────────────────────────────────────────────────
      data: (currentPosition) {
        if (currentPosition == null) {
          // getCurrentLocation returned null (all retries exhausted, no crash).
          return _LocationErrorView(
            error: const LocationServiceDisabledError(),
            message: 'Could not obtain your location after several attempts.',
          );
        }
        return _MapBody(
          packages: packages,
          initialPosition: currentPosition,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Error / retry view — shown whenever location is unavailable.
// ---------------------------------------------------------------------------

class _LocationErrorView extends ConsumerWidget {
  const _LocationErrorView({required this.error, this.message});

  final Object error;
  final String? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, title, body, showSettingsButton) = _errorContent(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? body,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            // ── Primary action: retry ─────────────────────────────────────
            FilledButton.icon(
              onPressed: () => ref.read(locationProvider.notifier).retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
            // ── Secondary action: open Settings (only for permission errors)
            if (showSettingsButton) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _openAppSettings(context),
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Open Settings'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns (icon, title, body, showSettingsButton) for each error type.
  (IconData, String, String, bool) _errorContent(Object error) {
    if (error is LocationServiceDisabledError) {
      return (
        Icons.location_off_outlined,
        'Location Services Off',
        'Please enable location services in your device settings, then tap '
            '"Try Again".',
        false,
      );
    }
    if (error is LocationPermissionDeniedForeverError) {
      return (
        Icons.lock_outline,
        'Location Permission Required',
        'You permanently denied location access. Open Settings and allow '
            'location for Globox, then tap "Try Again".',
        true, // show Settings button
      );
    }
    if (error is LocationPermissionDeniedError) {
      return (
        Icons.location_disabled_outlined,
        'Permission Denied',
        'Globox needs your location to show the map. Tap "Try Again" to '
            'grant permission.',
        false,
      );
    }
    // Generic / unknown error.
    return (
      Icons.warning_amber_outlined,
      'Something Went Wrong',
      'We couldn\'t get your location. Please try again.',
      false,
    );
  }

  void _openAppSettings(BuildContext context) async {
    // permission_handler provides a cross-platform openAppSettings().
    final opened = await openAppSettings();
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please open Settings and allow location for Globox.'),
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// The actual map — only rendered when we have a position.
// ---------------------------------------------------------------------------

class _MapBody extends ConsumerStatefulWidget {
  const _MapBody({
    required this.packages,
    required this.initialPosition,
  });

  final List<Package> packages;
  final LatLng initialPosition;

  @override
  ConsumerState<_MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends ConsumerState<_MapBody> {
  late LatLng _mapCenter;
  late LatLng _currentPosition;
  double _currentZoom = 15.0;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _mapCenter = widget.initialPosition;
    _currentPosition = widget.initialPosition;
  }

  /// Refreshes the user's current location by triggering a retry on the
  /// provider. The map re-renders automatically once the new position arrives.
  Future<void> _handleLocationChange() async {
    await ref.read(locationProvider.notifier).retry();

    final newPosition = ref.read(locationProvider).valueOrNull;
    if (newPosition == null) return;

    if (!mounted) return;
    setState(() {
      _mapCenter = newPosition;
      _currentPosition = newPosition;
      _mapController.move(newPosition, _currentZoom);
    });
  }

  void _showPackageDetails(BuildContext context, List<Package> packages) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) =>
          HorizontalCardScroller(packagesForSingleLocation: packages),
    );
  }

  double _getFocusedZoom() =>
      _currentZoom < 19 ? _currentZoom + 1 : _currentZoom;

  void _handleGroupMarkerSelection(List<Package> packages) {
    final first = packages.first;
    final center = LatLng(first.coordinates[0], first.coordinates[1]);
    setState(() => _mapController.move(center, _getFocusedZoom()));
    _showPackageDetails(context, packages);
  }

  @override
  Widget build(BuildContext context) {
    final groupedPackages = groupPackagesByCoordinates(widget.packages);

    final List<Marker> markers = groupedPackages.entries.map((entry) {
      final parts = entry.key.split(',');
      return MapMarker(
        entry.value.first.packageId,
        LatLng(double.parse(parts[0]), double.parse(parts[1])),
        () => _handleGroupMarkerSelection(entry.value),
      ).toMarker();
    }).toList();

    // User's current-position indicator (blue circle).
    markers.add(
      Marker(
        point: _currentPosition,
        width: 80,
        height: 80,
        child: const Icon(Icons.album_outlined, size: 40, color: Colors.blue),
      ),
    );

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _mapCenter,
        initialZoom: _currentZoom,
        onPositionChanged: (position, _) {
          _mapCenter = position.center;
          _currentZoom = position.zoom;
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.globox.app',
        ),
        const MapCompass.cupertino(hideIfRotatedNorth: true),
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
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.all(8),
              backgroundColor: Colors.white,
            ),
            child: const Icon(Icons.gps_fixed, size: 50),
          ),
        ),
      ],
    );
  }
}
