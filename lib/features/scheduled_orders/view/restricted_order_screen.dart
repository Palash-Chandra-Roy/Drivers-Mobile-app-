import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class RestrictedOrderScreen extends StatelessWidget {
  const RestrictedOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Restricted Delivery'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.warning_amber_rounded, size: 80, color: AppColors.warning),
              const SizedBox(height: AppSizes.paddingLg),
              const Text(
                'Age-Restricted Delivery',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              const Text(
                'This order contains age-restricted items. You must verify the customer\'s ID before completing the delivery.',
                style: TextStyle(color: AppColors.textLight, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                title: 'Proceed to Age Verification',
                onPressed: () => Navigator.pushNamed(context, RouteNames.ageVerification),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
