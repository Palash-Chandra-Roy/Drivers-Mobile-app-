import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class SafetyHelpScreen extends StatelessWidget {
  const SafetyHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Safety Help'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.emergency_outlined, size: 48, color: AppColors.error),
                    SizedBox(height: AppSizes.paddingMd),
                    Text(
                      'Emergency Support',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: AppSizes.paddingSm),
                    Text(
                      'If you are in immediate danger, call emergency services first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingLg),
              CustomButton(
                title: 'Call Support',
                backgroundColor: AppColors.error,
                onPressed: () => AppHelpers.showSnackBar(context, 'Calling support: +1-800-YJEEK'),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              CustomButton(
                title: 'Report Safety Issue',
                onPressed: () => Navigator.pushNamed(context, RouteNames.reportIssue),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              CustomButton(
                title: 'Open Dispatch Chat',
                outlined: true,
                onPressed: () => Navigator.pushNamed(context, RouteNames.dispatchChat),
              ),
              const SizedBox(height: AppSizes.paddingLg),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, RouteNames.incidents),
                child: const Text('View all incident options'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
