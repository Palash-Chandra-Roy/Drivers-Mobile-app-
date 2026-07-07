class PushNotificationService {
  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
