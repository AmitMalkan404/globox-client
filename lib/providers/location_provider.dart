import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:globox/services/internal/map_utils.dart';

// ---------------------------------------------------------------------------
// Typed error states — lets the UI react specifically to each case.
// ---------------------------------------------------------------------------

/// Location services (GPS) are disabled in device settings.
class LocationServiceDisabledError implements Exception {
  const LocationServiceDisabledError();
}

/// The user has permanently denied location permission.
class LocationPermissionDeniedForeverError implements Exception {
  const LocationPermissionDeniedForeverError();
}

/// The user denied location permission (but not permanently — can request again).
class LocationPermissionDeniedError implements Exception {
  const LocationPermissionDeniedError();
}

// ---------------------------------------------------------------------------
// AsyncNotifier — replaces the bare FutureProvider.
// ---------------------------------------------------------------------------

class LocationNotifier extends AsyncNotifier<LatLng?> {
  @override
  Future<LatLng?> build() => _resolve();

  /// Public method — call from the UI to retry after an error or permission
  /// denial. Re-runs the full resolution logic and updates state accordingly.
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_resolve);
  }

  Future<LatLng?> _resolve() async {
    // Check whether the device's location service is turned on.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledError();
    }

    // Check / request permission.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedForeverError();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationPermissionDeniedError();
    }

    // All good — delegate to the shared utility which handles retries internally.
    return getCurrentLocation(maxRetries: 3);
  }
}

final locationProvider =
    AsyncNotifierProvider<LocationNotifier, LatLng?>(LocationNotifier.new);
