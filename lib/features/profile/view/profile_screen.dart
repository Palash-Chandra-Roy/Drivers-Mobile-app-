import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_assets.dart';
import 'package:yjeek_driver/features/auth/provider/auth_provider.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// DE4 · Account
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _autoAccept = false;

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: DocColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 12),
                    _buildInfoCard(),
                    const SizedBox(height: 12),
                    _buildAutoAcceptRow(),
                    const SizedBox(height: 12),
                    _buildSettingsCard(),
                    const SizedBox(height: 12),
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DocColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: DocColors.doneBg,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'MA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: DocColors.greenDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ahmed Khalid',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: DocColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star_rounded, size: 15, color: DocColors.gold),
                    SizedBox(width: 2),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: DocColors.gold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '240 Orders',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: DocColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: DocColors.doneBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'RPI 88 · Active',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: DocColors.greenDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DocColors.cardBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Champ ID',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: DocColors.textSecondary,
                  ),
                ),
                Text(
                  'YJK-DRV-0142',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: DocColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8EBE8)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const Text(
                  'Contact number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: DocColors.textSecondary,
                  ),
                ),
                const Spacer(),
                const Text(
                  '+973 3300 0000',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: DocColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: DocColors.doneBg,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.changeNumber),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: DocColors.greenDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoAcceptRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 20,
            color: DocColors.greenDark,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Auto-Accept orders',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: DocColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _autoAccept = !_autoAccept),
            child: Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _autoAccept
                    ? DocColors.green
                    : const Color(0xFFCCD1CC),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DocColors.cardBorder),
      ),
      child: Column(
        children: [
          _SettingsRow(
            iconAsset: AppAssets.accountDocuments,
            label: 'Documents',
            badge: 'Verified',
            onTap: () => Navigator.pushNamed(context, RouteNames.documents),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: Color(0xFFE8EBE8),
          ),
          _SettingsRow(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            onTap: () =>
                Navigator.pushNamed(context, RouteNames.notifications),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: Color(0xFFE8EBE8),
          ),
          _SettingsRow(
            icon: Icons.language_rounded,
            label: 'Language',
            badge: 'EN',
            onTap: () => Navigator.pushNamed(context, RouteNames.language),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Material(
      color: const Color(0xFFFBEAEC),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: _logout,
        child: Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFF2D4D7)),
          ),
          child: Row(
            children: [
              Image.asset(AppAssets.accountLogout, width: 18, height: 18),
              const SizedBox(width: 8),
              const Text(
                'Log out',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC0392B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.label,
    required this.onTap,
    this.icon,
    this.iconAsset,
    this.badge,
  });

  final IconData? icon;
  final String? iconAsset;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (iconAsset != null)
                Image.asset(iconAsset!, width: 19, height: 19)
              else
                Icon(icon, size: 19, color: DocColors.greenDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: DocColors.textPrimary,
                  ),
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: DocColors.doneBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: DocColors.greenDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: DocColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
