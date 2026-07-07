import 'package:yjeek_driver/features/profile/model/profile_model.dart';

class ProfileService {
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const ProfileModel(
      name: 'John Driver',
      phone: '+1234567890',
      email: 'john.driver@yjeek.com',
      vehicleType: 'Motorcycle',
      plateNumber: 'ABC-1234',
      licenseNumber: 'DL-987654',
      licenseStatus: 'Verified',
      rating: 4.8,
    );
  }

  Future<bool> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
