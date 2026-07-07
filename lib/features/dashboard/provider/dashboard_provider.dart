import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/services/location_service.dart';

class DashboardProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  bool _isOnline = false;
  bool _isLoading = false;
  String _currentLocation = 'Fetching location...';
  final double _todayEarnings = 45.25;
  final int _completedOrders = 6;
  final double _acceptanceRate = 92.0;

  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  String get currentLocation => _currentLocation;
  double get todayEarnings => _todayEarnings;
  int get completedOrders => _completedOrders;
  double get acceptanceRate => _acceptanceRate;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();
    _currentLocation = await _locationService.getCurrentLocation();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleOnlineStatus() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isOnline = !_isOnline;
    _isLoading = false;
    notifyListeners();
  }

  void setOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }
}
