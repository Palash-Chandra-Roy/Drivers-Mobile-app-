import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/features/notifications/provider/notification_provider.dart';
import 'package:yjeek_driver/navigation/bottom_nav_bar.dart';
import 'package:yjeek_driver/features/dashboard/view/dashboard_screen.dart';
import 'package:yjeek_driver/features/earnings/view/earnings_screen.dart';
import 'package:yjeek_driver/features/notifications/view/notifications_screen.dart';
import 'package:yjeek_driver/features/orders/view/orders_screen.dart';
import 'package:yjeek_driver/features/profile/view/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    OrdersScreen(),
    EarningsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
