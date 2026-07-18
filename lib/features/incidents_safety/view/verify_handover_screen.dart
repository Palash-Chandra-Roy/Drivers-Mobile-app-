import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';

/// DR5 · Verify handover / OTP problem
class VerifyHandoverScreen extends StatelessWidget {
  const VerifyHandoverScreen({
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
            const IncidentHeader(title: 'Verify / OTP problem'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const Text(
                    'This category needs verified handover. Don’t hand over without it.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: IncidentColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Resend code to the customer’s registered number',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: IncidentColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IncidentPrimaryButton(
                    label: 'Resend code to the customer',
                    color: IncidentColors.successGreen,
                    onPressed: () {
                      showIncidentSnack(
                        context,
                        'Verification code resent to customer',
                      );
                    },
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
