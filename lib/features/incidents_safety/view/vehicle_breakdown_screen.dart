import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// DR9 · Vehicle breakdown
class VehicleBreakdownScreen extends StatefulWidget {
  const VehicleBreakdownScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  State<VehicleBreakdownScreen> createState() => _VehicleBreakdownScreenState();
}

class _VehicleBreakdownScreenState extends State<VehicleBreakdownScreen> {
  String? _choice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IncidentColors.screenBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const IncidentHeader(
              title: 'Vehicle problem',
              subtitle: 'We’ll keep the order moving',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const Text(
                    'Can you continue?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: IncidentColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      IncidentChip(
                        label: 'I can continue shortly',
                        selected: _choice == 'continue',
                        onTap: () => setState(() => _choice = 'continue'),
                      ),
                      IncidentChip(
                        label: 'I can’t continue',
                        selected: _choice == 'stop',
                        onTap: () => setState(() => _choice = 'stop'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  IncidentPrimaryButton(
                    label: 'Report breakdown to dispatch',
                    onPressed: () {
                      if (_choice == null) {
                        showIncidentSnack(
                          context,
                          'Please select whether you can continue',
                        );
                        return;
                      }
                      showIncidentSnack(
                        context,
                        'Breakdown reported to dispatch',
                      );
                      Navigator.maybePop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.safetyHelp,
                      ),
                      child: const Text(
                        'If this is an emergency — open SOS',
                        style: TextStyle(
                          color: IncidentColors.danger,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
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
