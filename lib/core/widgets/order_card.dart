import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/status_badge.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orderId,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.price,
    required this.status,
    this.onTap,
  });

  final String orderId;
  final String pickupAddress;
  final String dropoffAddress;
  final double price;
  final String status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderId,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  StatusBadge(status: status),
                ],
              ),
              const SizedBox(height: AppSizes.paddingMd),
              _AddressRow(
                icon: Icons.store_outlined,
                color: AppColors.primary,
                address: pickupAddress,
              ),
              const SizedBox(height: AppSizes.paddingSm),
              _AddressRow(
                icon: Icons.location_on_outlined,
                color: AppColors.error,
                address: dropoffAddress,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              Text(
                AppHelpers.formatCurrency(price),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.icon,
    required this.color,
    required this.address,
  });

  final IconData icon;
  final Color color;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSizes.paddingSm),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(color: AppColors.textLight, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
