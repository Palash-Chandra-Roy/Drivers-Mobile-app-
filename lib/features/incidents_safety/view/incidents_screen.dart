import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      _MenuOption('Report an Issue', Icons.report_problem_outlined, RouteNames.reportIssue),
      _MenuOption('Wrong or Missing Items', Icons.inventory_2_outlined, RouteNames.wrongMissingItems),
      _MenuOption('Verify Handover', Icons.verified_user_outlined, RouteNames.verifyHandover),
      _MenuOption('Safety Help', Icons.shield_outlined, RouteNames.safetyHelp),
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Safety & Incidents'),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingSm),
        itemBuilder: (context, index) {
          final option = options[index];
          return Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(option.icon, color: AppColors.primary),
              ),
              title: Text(option.title, style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, option.route),
            ),
          );
        },
      ),
    );
  }
}

class _MenuOption {
  const _MenuOption(this.title, this.icon, this.route);
  final String title;
  final IconData icon;
  final String route;
}
