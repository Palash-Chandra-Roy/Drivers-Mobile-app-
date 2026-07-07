import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/constants/app_strings.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/dashboard/provider/dashboard_provider.dart';

class GoOnlineScreen extends StatelessWidget {
  const GoOnlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Online Status'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dashboard.isOnline
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.textLight.withValues(alpha: 0.15),
                ),
                child: Icon(
                  dashboard.isOnline ? Icons.wifi_tethering : Icons.wifi_tethering_off,
                  size: 56,
                  color: dashboard.isOnline ? AppColors.success : AppColors.textLight,
                ),
              ),
              const SizedBox(height: AppSizes.paddingLg),
              Text(
                dashboard.isOnline ? 'You are Online' : 'You are Offline',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              Text(
                'Location: ${dashboard.currentLocation}',
                style: const TextStyle(color: AppColors.textLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary),
                      const SizedBox(width: AppSizes.paddingMd),
                      const Expanded(
                        child: Text(
                          'Location permission is required to go online. (Placeholder — not connected yet)',
                          style: TextStyle(color: AppColors.textLight, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                title: dashboard.isOnline ? AppStrings.goOffline : AppStrings.goOnline,
                isLoading: dashboard.isLoading,
                backgroundColor: dashboard.isOnline ? AppColors.error : AppColors.primary,
                onPressed: () async {
                  await dashboard.toggleOnlineStatus();
                  if (context.mounted) {
                    AppHelpers.showSnackBar(
                      context,
                      dashboard.isOnline ? 'You are now online!' : 'You are now offline.',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
