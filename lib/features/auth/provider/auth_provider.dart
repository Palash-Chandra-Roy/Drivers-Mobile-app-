import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/features/auth/model/driver_model.dart';
import 'package:yjeek_driver/features/auth/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _phone;
  DriverModel? _driver;
  String? _error;

  bool get isLoading => _isLoading;
  String? get phone => _phone;
  DriverModel? get driver => _driver;
  String? get error => _error;
  bool get isAuthenticated => _driver != null;

  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    _error = null;
    _phone = phone;
    notifyListeners();

    try {
      final isRegistered = await _authService.isPhoneRegistered(phone);
      if (!isRegistered) {
        _error = 'Phone not registered';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      await _authService.sendOtp(phone);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to send OTP';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (_phone == null) return false;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final driver = await _authService.verifyOtp(_phone!, otp);
      if (driver == null) {
        _error = 'Invalid OTP. Use 123456 for demo.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _driver = driver;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Verification failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _driver = null;
    _phone = null;
    notifyListeners();
  }
}
