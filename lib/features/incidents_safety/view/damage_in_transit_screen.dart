import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';

/// DR10 · Damage in transit
class DamageInTransitScreen extends StatefulWidget {
  const DamageInTransitScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  State<DamageInTransitScreen> createState() => _DamageInTransitScreenState();
}

class _DamageInTransitScreenState extends State<DamageInTransitScreen> {
  Uint8List? _photoBytes;

  Future<void> _pickPhoto() async {
    final bytes = await pickIncidentPhoto(context);
    if (!mounted || bytes == null) return;
    setState(() => _photoBytes = bytes);
  }

  void _submit() {
    if (_photoBytes == null) {
      showIncidentSnack(context, 'Please add a photo of the damage');
      return;
    }
    showIncidentSnack(context, 'Damage in transit reported');
    Navigator.maybePop(context);
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
              title: 'Damage in transit',
              subtitle: widget.args.orderId,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const Text(
                    'Pull over somewhere safe first, then photograph the damage.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: IncidentColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IncidentPhotoUpload(
                    hasPhoto: _photoBytes != null,
                    photoBytes: _photoBytes,
                    onTap: _pickPhoto,
                    helperText: 'Clear photo of the damage',
                  ),
                  const SizedBox(height: 16),
                  IncidentPrimaryButton(
                    label: 'Submit',
                    onPressed: _submit,
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
