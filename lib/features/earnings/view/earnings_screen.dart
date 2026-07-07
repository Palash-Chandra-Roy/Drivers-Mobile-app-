import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/app_loader.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/earnings/provider/earnings_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EarningsProvider>().loadEarnings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EarningsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: provider.isLoading
          ? const AppLoader()
          : RefreshIndicator(
              onRefresh: () => provider.loadEarnings(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  children: [
                    Card(
                      color: AppColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingLg),
                        child: Column(
                          children: [
                            const Text('Total Balance', style: TextStyle(color: AppColors.white70, fontSize: 14)),
                            const SizedBox(height: 8),
                            Text(
                              AppHelpers.formatCurrency(provider.totalBalance),
                              style: const TextStyle(color: AppColors.white, fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    Row(
                      children: [
                        Expanded(child: _EarningTile('Today', provider.todayEarning)),
                        const SizedBox(width: AppSizes.paddingSm),
                        Expanded(child: _EarningTile('This Week', provider.weeklyEarning)),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    _EarningTile('This Month', provider.monthlyEarning, fullWidth: true),
                    const SizedBox(height: AppSizes.paddingLg),
                    CustomButton(
                      title: 'Request Payout',
                      onPressed: () => Navigator.pushNamed(context, RouteNames.payout),
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    CustomButton(
                      title: 'Transaction History',
                      outlined: true,
                      onPressed: () => Navigator.pushNamed(context, RouteNames.transactionHistory),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _EarningTile extends StatelessWidget {
  const _EarningTile(this.label, this.amount, {this.fullWidth = false});
  final String label;
  final double amount;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              AppHelpers.formatCurrency(amount),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDark),
            ),
          ],
        ),
      ),
    );
  }
}
