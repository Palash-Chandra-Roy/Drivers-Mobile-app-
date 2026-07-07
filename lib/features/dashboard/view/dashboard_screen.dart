import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/constants/app_strings.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/core/widgets/section_header.dart';
import 'package:yjeek_driver/features/dashboard/provider/dashboard_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.driverHome),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().loadDashboard(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OnlineCard(dashboard: dashboard),
              const SizedBox(height: AppSizes.paddingMd),
              _MapPlaceholder(location: dashboard.currentLocation),
              const SizedBox(height: AppSizes.paddingMd),
              const SectionHeader(title: 'Today Summary'),
              Row(
                children: [
                  Expanded(child: _SummaryCard(
                    label: 'Today Earnings',
                    value: AppHelpers.formatCurrency(dashboard.todayEarnings),
                    icon: Icons.attach_money,
                    color: AppColors.primary,
                  )),
                  const SizedBox(width: AppSizes.paddingSm),
                  Expanded(child: _SummaryCard(
                    label: 'Completed',
                    value: '${dashboard.completedOrders}',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  )),
                ],
              ),
              const SizedBox(height: AppSizes.paddingSm),
              _SummaryCard(
                label: 'Acceptance Rate',
                value: '${dashboard.acceptanceRate.toStringAsFixed(0)}%',
                icon: Icons.trending_up,
                color: AppColors.primaryDark,
                fullWidth: true,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              _NewRequestCard(
                onTap: () => Navigator.pushNamed(context, RouteNames.newRequest),
              ),
              const SizedBox(height: AppSizes.paddingMd),
              CustomButton(
                title: AppStrings.goOnline,
                onPressed: () => Navigator.pushNamed(context, RouteNames.goOnline),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              CustomButton(
                title: AppStrings.viewOrders,
                outlined: true,
                onPressed: () => Navigator.pushNamed(context, RouteNames.orders),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              CustomButton(
                title: AppStrings.safetyHelp,
                backgroundColor: AppColors.warning,
                onPressed: () => Navigator.pushNamed(context, RouteNames.safetyHelp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnlineCard extends StatelessWidget {
  const _OnlineCard({required this.dashboard});
  final DashboardProvider dashboard;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dashboard.isOnline ? AppColors.success : AppColors.textLight,
              ),
            ),
            const SizedBox(width: AppSizes.paddingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dashboard.isOnline ? 'You are Online' : 'You are Offline',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(
                    dashboard.isOnline ? 'Receiving new orders' : 'Go online to receive orders',
                    style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                  ),
                ],
              ),
            ),
            Switch(
              value: dashboard.isOnline,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              activeThumbColor: AppColors.primary,
              onChanged: dashboard.isLoading ? null : (_) => dashboard.toggleOnlineStatus(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.location});
  final String location;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        height: 160,
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.map_outlined, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Current Location', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Center(
                child: Icon(Icons.location_on, size: 40, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(location, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewRequestCard extends StatelessWidget {
  const _NewRequestCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Row(
            children: [
              const Icon(Icons.delivery_dining, color: AppColors.primary, size: 36),
              const SizedBox(width: AppSizes.paddingMd),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('New Delivery Request', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Tap to view incoming order', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
