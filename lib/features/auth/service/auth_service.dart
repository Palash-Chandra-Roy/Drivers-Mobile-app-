import 'package:yjeek_driver/features/auth/model/driver_model.dart';

class AuthService {
  static const String registeredPhone = '+1234567890';

  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return phone.replaceAll(RegExp(r'[\s\-]'), '') ==
        registeredPhone.replaceAll(RegExp(r'[\s\-]'), '');
  }

  Future<DriverModel?> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp == '123456') {
      return const DriverModel(
        id: 'DRV001',
        name: 'John Driver',
        phone: '+1234567890',
        email: 'john.driver@yjeek.com',
        vehicleType: 'Motorcycle',
        plateNumber: 'ABC-1234',
        rating: 4.8,
        isOnline: false,
      );
    }
    return null;
  }

  Future<bool> isPhoneRegistered(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return phone.contains('1234567890');
  }
}
