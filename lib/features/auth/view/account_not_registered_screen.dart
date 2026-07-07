import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/constants/app_strings.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class AccountNotRegisteredScreen extends StatelessWidget {
  const AccountNotRegisteredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.accountNotRegistered),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.person_off_outlined, size: 80, color: AppColors.warning.withValues(alpha: 0.8)),
              const SizedBox(height: AppSizes.paddingLg),
              const Text(
                'Driver Number Not Registered',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              const Text(
                'Your phone number is not registered as a Yjeek driver. Please contact support to register your account.',
                style: TextStyle(color: AppColors.textLight, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                title: AppStrings.contactSupport,
                onPressed: () => AppHelpers.showSnackBar(context, 'Support: support@yjeek.com'),
              ),
              const SizedBox(height: AppSizes.paddingMd),
              CustomButton(
                title: AppStrings.backToLogin,
                outlined: true,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.login,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
