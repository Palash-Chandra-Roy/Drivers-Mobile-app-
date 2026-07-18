import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';

/// DR2 · Vendor not ready
class VendorNotReadyScreen extends StatefulWidget {
  const VendorNotReadyScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  State<VendorNotReadyScreen> createState() => _VendorNotReadyScreenState();
}

class _VendorNotReadyScreenState extends State<VendorNotReadyScreen> {
  late Duration _elapsed;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _elapsed = const Duration(minutes: 4, seconds: 12);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IncidentColors.screenBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            IncidentHeader(
              title: 'Order not ready',
              subtitle: widget.args.pickupSubtitle,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  IncidentCard(
                    child: Column(
                      children: [
                        const Text(
                          'You’ve been waiting',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: IncidentColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _timerText,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: IncidentColors.timerOrange,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Auto-flagged at 4 min',
                          style: TextStyle(
                            fontSize: 11,
                            color: IncidentColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const IncidentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What happens when you report',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: IncidentColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Dispatch contacts the vendor and logs the wait\n'
                          '• Your wait time is excluded from your RPI',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.35,
                            color: IncidentColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  IncidentPrimaryButton(
                    label: 'Report wait to dispatch',
                    onPressed: () {
                      showIncidentSnack(context, 'Wait reported to dispatch');
                      Navigator.maybePop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  IncidentOutlinedButton(
                    label: 'Keep waiting',
                    onPressed: () => Navigator.maybePop(context),
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
