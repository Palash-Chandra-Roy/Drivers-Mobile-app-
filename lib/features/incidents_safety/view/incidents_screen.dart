import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      _MenuOption(
        'Report — at pickup',
        Icons.storefront_outlined,
        RouteNames.reportAtPickup,
      ),
      _MenuOption(
        'Report — at drop-off',
        Icons.location_on_outlined,
        RouteNames.reportAtDropoff,
      ),
      _MenuOption(
        'Order not ready',
        Icons.timer_outlined,
        RouteNames.vendorNotReady,
      ),
      _MenuOption(
        'Damage at pickup',
        Icons.broken_image_outlined,
        RouteNames.damageAtPickup,
      ),
      _MenuOption(
        'Wrong / missing items',
        Icons.inventory_2_outlined,
        RouteNames.wrongMissingItems,
      ),
      _MenuOption(
        'Can’t reach customer',
        Icons.phone_disabled_outlined,
        RouteNames.cantReachCustomer,
      ),
      _MenuOption(
        'Can’t find address',
        Icons.map_outlined,
        RouteNames.cantFindAddress,
      ),
      _MenuOption(
        'Damage in transit',
        Icons.local_shipping_outlined,
        RouteNames.damageInTransit,
      ),
      _MenuOption(
        'Verify / OTP problem',
        Icons.verified_user_outlined,
        RouteNames.verifyHandover,
      ),
      _MenuOption(
        'Vehicle breakdown',
        Icons.two_wheeler_outlined,
        RouteNames.vehicleBreakdown,
      ),
      _MenuOption(
        'Dispatch chat',
        Icons.chat_outlined,
        RouteNames.dispatchCantReachChat,
      ),
      _MenuOption(
        'Safety Help / SOS',
        Icons.shield_outlined,
        RouteNames.safetyHelp,
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Safety & Incidents'),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingSm),
        itemBuilder: (context, index) {
          final option = options[index];
          return Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(option.icon, color: AppColors.primary),
              ),
              title: Text(
                option.title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, option.route),
            ),
          );
        },
      ),
    );
  }
}

class _MenuOption {
  const _MenuOption(this.title, this.icon, this.route);
  final String title;
  final IconData icon;
  final String route;
}
