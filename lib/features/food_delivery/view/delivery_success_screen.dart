import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/food_delivery/provider/food_delivery_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class DeliverySuccessScreen extends StatelessWidget {
  const DeliverySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<FoodDeliveryProvider>().delivery;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.celebration_outlined, size: 80, color: AppColors.success),
              const SizedBox(height: AppSizes.paddingLg),
              const Text('Delivery Successful!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSizes.paddingMd),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  child: Column(
                    children: [
                      const Text('You earned', style: TextStyle(color: AppColors.textLight)),
                      const SizedBox(height: 8),
                      Text(
                        AppHelpers.formatCurrency(delivery?.deliveryFee ?? 0),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                title: 'Back to Home',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.mainNavigation,
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
