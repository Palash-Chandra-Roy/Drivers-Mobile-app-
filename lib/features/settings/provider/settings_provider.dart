import 'package:flutter/foundation.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'English';
  bool _notificationsEnabled = true;

  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }
}
