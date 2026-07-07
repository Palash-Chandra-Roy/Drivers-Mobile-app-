import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/features/profile/model/profile_model.dart';
import 'package:yjeek_driver/features/profile/service/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  bool _isLoading = false;
  ProfileModel? _profile;

  bool get isLoading => _isLoading;
  ProfileModel? get profile => _profile;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    _profile = await _service.getProfile();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(ProfileModel updated) async {
    _isLoading = true;
    notifyListeners();
    final success = await _service.updateProfile(updated);
    if (success) _profile = updated;
    _isLoading = false;
    notifyListeners();
    return success;
  }
}
