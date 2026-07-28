import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yjeek_driver/core/models/map_location.dart';

/// Map helpers: navigation deep links, bounds, polyline decode.
///
/// TODO(backend): Add a protected backend endpoint that calls Google Routes API
/// and return encoded polyline / route coordinates. Do not put a Maps web-service
/// key in the Flutter client.
class MapService {
  MapService._();

  static Future<bool> openDrivingNavigation({
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final hasCoords = latitude != null &&
        longitude != null &&
        latitude.isFinite &&
        longitude.isFinite;

    final Uri uri;
    if (hasCoords) {
      uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=$latitude,$longitude'
        '&travelmode=driving',
      );
    } else if (address != null && address.trim().isNotEmpty) {
      uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=${Uri.encodeComponent(address.trim())}'
        '&travelmode=driving',
      );
    } else {
      return false;
    }

    try {
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }

  static Future<void> openNavigationOrShowError(
    BuildContext context, {
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final opened = await openDrivingNavigation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Unable to open Google Maps navigation'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  static LatLngBounds? boundsFor(List<LatLng> points) {
    if (points.isEmpty) return null;
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;
    for (final p in points.skip(1)) {
      minLat = minLat < p.latitude ? minLat : p.latitude;
      maxLat = maxLat > p.latitude ? maxLat : p.latitude;
      minLng = minLng < p.longitude ? minLng : p.longitude;
      maxLng = maxLng > p.longitude ? maxLng : p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Decode Google encoded polyline algorithm (when backend provides one).
  static List<LatLng> decodePolyline(String encoded) {
    final coordinates = <LatLng>[];
    var index = 0;
    final len = encoded.length;
    var lat = 0;
    var lng = 0;

    while (index < len) {
      var result = 0;
      var shift = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      result = 0;
      shift = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      coordinates.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return coordinates;
  }
}

/// Interface for future protected backend Routes API integration.
abstract class RouteRepository {
  /// Returns decoded route points for pickup → dropoff when backend provides them.
  Future<List<LatLng>> fetchRoute({
    required MapLocation origin,
    required MapLocation destination,
  });
}

/// Stub until backend exposes a Routes proxy endpoint.
class PendingRouteRepository implements RouteRepository {
  @override
  Future<List<LatLng>> fetchRoute({
    required MapLocation origin,
    required MapLocation destination,
  }) async {
    // TODO(backend): Call protected `/drivers/routes` (or similar) that uses
    // Google Routes API server-side. Never embed a web-service key in the app.
    return const [];
  }
}
