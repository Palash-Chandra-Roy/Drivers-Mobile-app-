import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/date_formatter.dart';
import 'package:yjeek_driver/core/widgets/app_loader.dart';
import 'package:yjeek_driver/core/widgets/empty_state_widget.dart';
import 'package:yjeek_driver/features/notifications/provider/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.delivery_dining;
      case 'payment':
        return Icons.payment;
      case 'account':
        return Icons.person_outline;
      case 'safety':
        return Icons.shield_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'order':
        return AppColors.primary;
      case 'payment':
        return AppColors.success;
      case 'account':
        return AppColors.primaryDark;
      case 'safety':
        return AppColors.warning;
      default:
        return AppColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllAsRead(),
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: provider.isLoading
          ? const AppLoader()
          : provider.notifications.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.notifications_none_outlined,
                  title: 'No notifications',
                  subtitle: 'You\'re all caught up!',
                )
              : RefreshIndicator(
                  onRefresh: () => provider.loadNotifications(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    itemCount: provider.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = provider.notifications[index];
                      return Card(
                        color: notification.isRead ? AppColors.white : AppColors.primary.withValues(alpha: 0.04),
                        margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                        child: ListTile(
                          onTap: () => provider.markAsRead(notification.id),
                          leading: CircleAvatar(
                            backgroundColor: _colorForType(notification.type).withValues(alpha: 0.12),
                            child: Icon(_iconForType(notification.type), color: _colorForType(notification.type), size: 20),
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(notification.body),
                              const SizedBox(height: 4),
                              Text(
                                DateFormatter.formatRelative(notification.createdAt),
                                style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
