import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/widgets/app_loader.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/status_badge.dart';
import 'package:yjeek_driver/features/profile/provider/profile_provider.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  @override
  void initState() {
    super.initState();
    if (context.read<ProfileProvider>().profile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProfileProvider>().loadProfile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profile;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Vehicle Info'),
      body: provider.isLoading && profile == null
          ? const AppLoader()
          : profile == null
              ? const Center(child: Text('No profile data'))
              : ListView(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.two_wheeler, color: AppColors.primary, size: 32),
                        title: const Text('Vehicle Type'),
                        subtitle: Text(profile.vehicleType ?? 'Not set', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
                        title: const Text('Plate Number'),
                        subtitle: Text(profile.plateNumber ?? 'Not set', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.badge_outlined, color: AppColors.primary),
                        title: const Text('License Number'),
                        subtitle: Text(profile.licenseNumber ?? 'Not set'),
                        trailing: StatusBadge(status: profile.licenseStatus),
                      ),
                    ),
                  ],
                ),
    );
  }
}
