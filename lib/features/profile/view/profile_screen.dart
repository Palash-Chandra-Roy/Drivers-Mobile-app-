import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/constants/app_strings.dart';
import 'package:yjeek_driver/core/widgets/app_loader.dart';
import 'package:yjeek_driver/features/auth/provider/auth_provider.dart';
import 'package:yjeek_driver/features/profile/provider/profile_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: provider.isLoading || profile == null
          ? const AppLoader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            child: Text(
                              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'D',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingMd),
                          Text(profile.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(profile.phone, style: const TextStyle(color: AppColors.textLight)),
                          const SizedBox(height: AppSizes.paddingMd),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: AppColors.warning, size: 20),
                              const SizedBox(width: 4),
                              Text('${profile.rating} Rating', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingMd),
                  _ProfileTile(
                    icon: Icons.two_wheeler_outlined,
                    title: 'Vehicle',
                    subtitle: '${profile.vehicleType ?? 'N/A'} · ${profile.plateNumber ?? 'N/A'}',
                  ),
                  _ProfileMenuItem(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: () => Navigator.pushNamed(context, RouteNames.editProfile),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.directions_car_outlined,
                    title: 'Vehicle Info',
                    onTap: () => Navigator.pushNamed(context, RouteNames.vehicleInfo),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () => Navigator.pushNamed(context, RouteNames.settings),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.shield_outlined,
                    title: 'Safety & Incidents',
                    onTap: () => Navigator.pushNamed(context, RouteNames.incidents),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    color: AppColors.error,
                    onTap: _logout,
                  ),
                ],
              ),
            ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title, style: TextStyle(color: color)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
