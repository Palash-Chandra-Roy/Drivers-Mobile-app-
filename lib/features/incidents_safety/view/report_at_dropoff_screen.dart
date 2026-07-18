import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_assets.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// DR1b · Report — at drop-off
class ReportAtDropoffScreen extends StatelessWidget {
  const ReportAtDropoffScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IncidentColors.screenBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            IncidentHeader(
              title: 'Report — at drop-off',
              subtitle: args.dropoffSubtitle,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  IncidentMenuRow(
                    emoji: '📵',
                    title: 'Can’t reach customer',
                    subtitle: 'More than two attempts',
                    iconBg: const Color(0xFFEBF2FF),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.cantReachCustomer,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    emoji: '📍',
                    title: 'Can’t find the address',
                    subtitle: 'Wrong or unclear location',
                    iconBg: const Color(0xFFFFF2DB),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.cantFindAddress,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentDamage,
                    title: 'Damage in transit',
                    iconBg: const Color(0xFFFFEBEB),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.damageInTransit,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentLock,
                    title: 'Verify / OTP problem',
                    subtitle: 'Pharmacy, electronics, luxury',
                    iconBg: const Color(0xFFEDF5ED),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.verifyHandover,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentRefuse,
                    title: 'Customer refuses the order',
                    iconBg: const Color(0xFFEDFFF3),
                    onTap: () => showIncidentSnack(
                      context,
                      'Return flow will be started with dispatch.',
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentBike,
                    title: 'Vehicle / breakdown',
                    iconBg: const Color(0xFFEDF5ED),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.vehicleBreakdown,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reports route automatically — most are resolved without a call.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: IncidentColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IncidentPrimaryButton(
                    label: 'SOS',
                    leading: const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.safetyHelp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
