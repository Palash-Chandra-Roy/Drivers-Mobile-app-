import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/food_delivery/provider/food_delivery_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class PickupDetailsScreen extends StatelessWidget {
  const PickupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<FoodDeliveryProvider>().delivery;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Pickup Details'),
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
                        leading: const Icon(Icons.restaurant, color: AppColors.primary),
                        title: Text(delivery.restaurantName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(delivery.pickupAddress),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    const Text('Pickup Instructions', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSizes.paddingSm),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        child: Text(delivery.pickupInstructions ?? 'No special instructions'),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    const Text('Items to Collect', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSizes.paddingSm),
                    Expanded(
                      child: ListView.builder(
                        itemCount: delivery.items.length,
                        itemBuilder: (_, i) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                              child: Text('${i + 1}', style: const TextStyle(color: AppColors.primary)),
                            ),
                            title: Text(delivery.items[i]),
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                      title: 'Confirm Pickup',
                      onPressed: () {
                        context.read<FoodDeliveryProvider>().confirmPickup();
                        AppHelpers.showSnackBar(context, 'Pickup confirmed!');
                        Navigator.pushNamed(context, RouteNames.dropoffDetails);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
