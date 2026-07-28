import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:yjeek_driver/core/models/map_location.dart';

/// Real device location via Geolocator + permission_handler.
class LocationService {
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<bool> hasLocationPermission() async {
    final status = await ph.Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  /// Returns true if granted. Opens app settings when permanently denied.
  Future<ph.PermissionStatus> requestLocationPermission() async {
    var status = await ph.Permission.locationWhenInUse.status;
    if (status.isGranted) return status;

    if (status.isPermanentlyDenied) {
      await ph.openAppSettings();
      return ph.Permission.locationWhenInUse.status;
    }

    status = await ph.Permission.locationWhenInUse.request();
    return status;
  }

  Future<MapLocation?> getCurrentMapLocation() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    final permitted = await hasLocationPermission();
    if (!permitted) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return MapLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        kind: MapLocationKind.driver,
        label: 'You',
      );
    } catch (_) {
      return null;
    }
  }

  /// Human-readable label for UI (legacy callers). Prefer [getCurrentMapLocation].
  Future<String> getCurrentLocation() async {
    final location = await getCurrentMapLocation();
    if (location == null) return 'Location unavailable';
    return '${location.latitude.toStringAsFixed(5)}, '
        '${location.longitude.toStringAsFixed(5)}';
  }

  Stream<Position> positionStream({
    int distanceFilterMeters = 15,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }
}
