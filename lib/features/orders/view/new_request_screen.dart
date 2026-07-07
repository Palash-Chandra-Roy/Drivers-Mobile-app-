import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/app_loader.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/orders/provider/order_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  int _timer = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadNewRequest();
    });
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _timer = (_timer - 1).clamp(0, 60));
      return _timer > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final request = provider.newRequest;

    return Scaffold(
      appBar: const CustomAppBar(title: 'New Request'),
      body: provider.isLoading || request == null
          ? const AppLoader(message: 'Loading request...')
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer_outlined, color: AppColors.warning),
                          const SizedBox(width: 8),
                          Text('Expires in ${_timer}s', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.warning)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingLg),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _DetailCard(
                              icon: Icons.store,
                              title: 'Pickup',
                              address: request.pickupAddress,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: AppSizes.paddingMd),
                            _DetailCard(
                              icon: Icons.location_on,
                              title: 'Drop-off',
                              address: request.dropoffAddress,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: AppSizes.paddingLg),
                            Row(
                              children: [
                                Expanded(child: _StatBox(label: 'Distance', value: AppHelpers.formatDistance(request.distance))),
                                const SizedBox(width: AppSizes.paddingMd),
                                Expanded(child: _StatBox(label: 'Earning', value: AppHelpers.formatCurrency(request.price))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
                      title: 'Accept Order',
                      onPressed: () {
                        provider.acceptOrder();
                        Navigator.pushReplacementNamed(context, RouteNames.acceptOrder);
                      },
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    CustomButton(
                      title: 'Reject',
                      outlined: true,
                      backgroundColor: AppColors.error,
                      onPressed: () {
                        provider.rejectOrder();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.icon, required this.title, required this.address, required this.color});
  final IconData icon;
  final String title;
  final String address;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(address, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDark)),
          ],
        ),
      ),
    );
  }
}
