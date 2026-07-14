import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/features/auth/view/account_not_registered_screen.dart';
import 'package:yjeek_driver/features/auth/view/login_screen.dart';
import 'package:yjeek_driver/features/auth/view/otp_screen.dart';
import 'package:yjeek_driver/features/chat/view/dispatch_chat_screen.dart';
import 'package:yjeek_driver/features/dashboard/view/cant_go_online_screen.dart';
import 'package:yjeek_driver/features/dashboard/view/dashboard_screen.dart';
import 'package:yjeek_driver/features/dashboard/view/go_online_screen.dart';
import 'package:yjeek_driver/features/dashboard/view/update_required_screen.dart';
import 'package:yjeek_driver/features/earnings/view/earnings_screen.dart';
import 'package:yjeek_driver/features/earnings/view/payout_screen.dart';
import 'package:yjeek_driver/features/earnings/view/transaction_history_screen.dart';
import 'package:yjeek_driver/features/food_delivery/view/delivery_success_screen.dart';
import 'package:yjeek_driver/features/food_delivery/view/dropoff_details_screen.dart';
import 'package:yjeek_driver/features/food_delivery/view/food_delivery_screen.dart';
import 'package:yjeek_driver/features/food_delivery/view/pickup_details_screen.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incidents_screen.dart';
import 'package:yjeek_driver/features/incidents_safety/view/report_issue_screen.dart';
import 'package:yjeek_driver/features/incidents_safety/view/safety_help_screen.dart';
import 'package:yjeek_driver/features/incidents_safety/view/verify_handover_screen.dart';
import 'package:yjeek_driver/features/incidents_safety/view/wrong_missing_items_screen.dart';
import 'package:yjeek_driver/features/notifications/view/notifications_screen.dart';
import 'package:yjeek_driver/features/orders/view/accept_order_screen.dart';
import 'package:yjeek_driver/features/orders/view/new_request_screen.dart';
import 'package:yjeek_driver/features/orders/view/order_completed_screen.dart';
import 'package:yjeek_driver/features/orders/view/order_details_screen.dart';
import 'package:yjeek_driver/features/orders/view/orders_screen.dart';
import 'package:yjeek_driver/features/profile/view/edit_profile_screen.dart';
import 'package:yjeek_driver/features/profile/view/profile_screen.dart';
import 'package:yjeek_driver/features/profile/view/vehicle_info_screen.dart';
import 'package:yjeek_driver/features/scheduled_orders/view/age_verification_screen.dart';
import 'package:yjeek_driver/features/scheduled_orders/view/restricted_order_screen.dart';
import 'package:yjeek_driver/features/scheduled_orders/view/scheduled_order_details_screen.dart';
import 'package:yjeek_driver/features/scheduled_orders/view/scheduled_orders_screen.dart';
import 'package:yjeek_driver/features/settings/view/language_screen.dart';
import 'package:yjeek_driver/features/settings/view/privacy_policy_screen.dart';
import 'package:yjeek_driver/features/settings/view/settings_screen.dart';
import 'package:yjeek_driver/features/splash/view/splash_screen.dart';
import 'package:yjeek_driver/navigation/main_navigation_screen.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _page(const SplashScreen());
      case RouteNames.login:
        return _page(const LoginScreen());
      case RouteNames.otp:
        final phoneDisplay = settings.arguments as String?;
        return _page(OtpScreen(phoneDisplay: phoneDisplay));
      case RouteNames.accountNotRegistered:
        return _page(const AccountNotRegisteredScreen());
      case RouteNames.mainNavigation:
        return _page(const MainNavigationScreen());
      case RouteNames.dashboard:
        return _page(const DashboardScreen());
      case RouteNames.goOnline:
        return _page(const GoOnlineScreen());
      case RouteNames.cantGoOnline:
        return _page(const CantGoOnlineScreen());
      case RouteNames.updateRequired:
        return _page(const UpdateRequiredScreen());
      case RouteNames.orders:
        return _page(const OrdersScreen());
      case RouteNames.orderDetails:
        final args = settings.arguments as String?;
        return _page(OrderDetailsScreen(orderId: args));
      case RouteNames.newRequest:
        return _page(const NewRequestScreen());
      case RouteNames.acceptOrder:
        return _page(const AcceptOrderScreen());
      case RouteNames.orderCompleted:
        final args = settings.arguments as double?;
        return _page(OrderCompletedScreen(earning: args ?? 0));
      case RouteNames.foodDelivery:
        return _page(const FoodDeliveryScreen());
      case RouteNames.pickupDetails:
        return _page(const PickupDetailsScreen());
      case RouteNames.dropoffDetails:
        return _page(const DropoffDetailsScreen());
      case RouteNames.deliverySuccess:
        return _page(const DeliverySuccessScreen());
      case RouteNames.scheduledOrders:
        return _page(const ScheduledOrdersScreen());
      case RouteNames.scheduledOrderDetails:
        return _page(const ScheduledOrderDetailsScreen());
      case RouteNames.restrictedOrder:
        return _page(const RestrictedOrderScreen());
      case RouteNames.ageVerification:
        return _page(const AgeVerificationScreen());
      case RouteNames.notifications:
        return _page(const NotificationsScreen());
      case RouteNames.earnings:
        return _page(const EarningsScreen());
      case RouteNames.payout:
        return _page(const PayoutScreen());
      case RouteNames.transactionHistory:
        return _page(const TransactionHistoryScreen());
      case RouteNames.incidents:
        return _page(const IncidentsScreen());
      case RouteNames.reportIssue:
        return _page(const ReportIssueScreen());
      case RouteNames.wrongMissingItems:
        return _page(const WrongMissingItemsScreen());
      case RouteNames.verifyHandover:
        return _page(const VerifyHandoverScreen());
      case RouteNames.safetyHelp:
        return _page(const SafetyHelpScreen());
      case RouteNames.dispatchChat:
        return _page(const DispatchChatScreen());
      case RouteNames.profile:
        return _page(const ProfileScreen());
      case RouteNames.editProfile:
        return _page(const EditProfileScreen());
      case RouteNames.vehicleInfo:
        return _page(const VehicleInfoScreen());
      case RouteNames.settings:
        return _page(const SettingsScreen());
      case RouteNames.language:
        return _page(const LanguageScreen());
      case RouteNames.privacyPolicy:
        return _page(const PrivacyPolicyScreen());
      default:
        return _page(const UnknownRouteScreen());
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.textLight.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text('The page you are looking for does not exist.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.mainNavigation,
                (route) => false,
              ),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
