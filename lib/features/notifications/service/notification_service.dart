import 'package:yjeek_driver/features/notifications/model/notification_model.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 'N1',
        title: 'New Order Available',
        body: 'A new delivery request is waiting for you nearby.',
        type: 'order',
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        id: 'N2',
        title: 'Payment Processed',
        body: 'Your payout of \$125.00 has been processed.',
        type: 'payment',
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: 'N3',
        title: 'Account Update',
        body: 'Your vehicle documents have been verified.',
        type: 'account',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: 'N4',
        title: 'Safety Alert',
        body: 'Heavy rain expected in your area. Drive safely.',
        type: 'safety',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }
}
