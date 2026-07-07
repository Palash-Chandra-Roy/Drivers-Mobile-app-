import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/orders/provider/order_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class OrderCompletedScreen extends StatelessWidget {
  const OrderCompletedScreen({super.key, this.earning = 0});

  final double earning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 64, color: AppColors.success),
              ),
              const SizedBox(height: AppSizes.paddingLg),
              const Text(
                'Delivery Completed!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              const Text('Great job! You earned', style: TextStyle(color: AppColors.textLight)),
              const SizedBox(height: AppSizes.paddingSm),
              Text(
                AppHelpers.formatCurrency(earning),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
              ),
              const Spacer(),
              CustomButton(
                title: 'Back to Home',
                onPressed: () {
                  context.read<OrderProvider>().resetDelivery();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.mainNavigation,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
