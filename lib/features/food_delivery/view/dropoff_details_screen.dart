import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/food_delivery/provider/food_delivery_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class DropoffDetailsScreen extends StatelessWidget {
  const DropoffDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<FoodDeliveryProvider>().delivery;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Drop-off Details'),
      body: delivery == null
          ? const Center(child: Text('No delivery loaded'))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.person_outline, color: AppColors.primary),
                        title: Text(delivery.customerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(delivery.dropoffAddress),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    const Text('Delivery Instructions', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSizes.paddingSm),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        child: Text(delivery.deliveryInstructions ?? 'No special instructions'),
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      title: 'Confirm Delivery',
                      onPressed: () {
                        context.read<FoodDeliveryProvider>().confirmDelivery();
                        Navigator.pushReplacementNamed(context, RouteNames.deliverySuccess);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
