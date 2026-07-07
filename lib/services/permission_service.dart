class PermissionService {
  Future<bool> requestLocationPermission() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<bool> requestNotificationPermission() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<String> getPermissionStatus(String permission) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 'granted';
  }
}
