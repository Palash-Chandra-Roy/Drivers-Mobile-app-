import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_assets.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// DR4 · Can’t reach customer
class CantReachCustomerScreen extends StatefulWidget {
  const CantReachCustomerScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  State<CantReachCustomerScreen> createState() =>
      _CantReachCustomerScreenState();
}

class _CantReachCustomerScreenState extends State<CantReachCustomerScreen> {
  late Duration _waiting;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _waiting = const Duration(minutes: 3, seconds: 10);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _waiting += const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = _waiting.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _waiting.inSeconds.remainder(60).toString().padLeft(2, '0');
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
              title: 'Can’t reach customer',
              subtitle: widget.args.dropoffSubtitle,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  IncidentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Two documented attempts required',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: IncidentColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _AttemptRow(
                          title: 'Attempt 1 · Call',
                          subtitle: 'Logged 13:42',
                        ),
                        const SizedBox(height: 10),
                        _AttemptRow(
                          title: 'Attempt 2 · In-app message',
                          subtitle: 'Logged 13:44',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  IncidentCard(
                    child: Column(
                      children: [
                        const Text(
                          'Waiting at door',
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: IncidentOutlinedButton(
                          label: 'Call',
                          leading: const Icon(
                            Icons.call,
                            size: 18,
                            color: IncidentColors.textPrimary,
                          ),
                          onPressed: () =>
                              showIncidentSnack(context, 'Calling customer…'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: IncidentOutlinedButton(
                          label: 'Message',
                          leading: Image.asset(
                            AppAssets.incidentMessage,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                          onPressed: () =>
                              showIncidentSnack(context, 'Message sent'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  IncidentPrimaryButton(
                    label: 'Mark as unable to deliver',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.dispatchCantReachChat,
                        arguments: widget.args,
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

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: IncidentColors.successGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: IncidentColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: IncidentColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
