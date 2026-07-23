import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted || status.isLimited;
  }

  Future<String> getPermissionStatus(String permission) async {
    switch (permission) {
      case 'location':
        return (await Permission.locationWhenInUse.status).name;
      case 'notification':
        return (await Permission.notification.status).name;
      default:
        return 'unknown';
    }
  }
}
