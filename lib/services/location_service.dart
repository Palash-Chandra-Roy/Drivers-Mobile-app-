class LocationService {
  Future<String> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '123 Main Street, Downtown';
  }

  Future<bool> hasLocationPermission() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
