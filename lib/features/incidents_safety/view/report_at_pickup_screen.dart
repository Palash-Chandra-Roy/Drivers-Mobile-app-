import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_assets.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// DR1a · Report — at pickup
class ReportAtPickupScreen extends StatelessWidget {
  const ReportAtPickupScreen({
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
              title: 'Report — at pickup',
              subtitle: args.pickupSubtitle,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentOrderFood,
                    title: 'Order not ready',
                    subtitle: 'Vendor hasn’t handed it over',
                    iconBg: const Color(0xFFFFF2DB),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.vendorNotReady,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentDamage,
                    title: 'Damaged / spilled',
                    iconBg: const Color(0xFFFFEBEB),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.damageAtPickup,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentBox,
                    title: 'Wrong / missing items',
                    iconBg: const Color(0xFFEDFFF3),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.wrongMissingItems,
                      arguments: args,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IncidentMenuRow(
                    iconAsset: AppAssets.incidentStore,
                    title: 'Can’t find the vendor',
                    subtitle: 'Wrong or closed store',
                    iconBg: const Color(0xFFEBF2FF),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.cantFindAddress,
                      arguments: args,
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
                  const SizedBox(height: 20),
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
