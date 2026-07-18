import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';

/// DR3 · Damage at pickup
class DamageAtPickupScreen extends StatefulWidget {
  const DamageAtPickupScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  State<DamageAtPickupScreen> createState() => _DamageAtPickupScreenState();
}

class _DamageAtPickupScreenState extends State<DamageAtPickupScreen> {
  static const _issues = [
    'Leaking / spilled',
    'Broken seal',
    'Crushed / damaged',
    'Wrong packaging',
  ];

  final _selected = <String>{};
  bool _declining = true;
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
    if (_selected.isEmpty) {
      showIncidentSnack(context, 'Please select what’s wrong');
      return;
    }
    showIncidentSnack(context, 'Damage reported — items declined');
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
            const IncidentHeader(
              title: 'Damage at pickup',
              subtitle: 'Photograph before you leave',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  IncidentPhotoUpload(
                    hasPhoto: _photoBytes != null,
                    photoBytes: _photoBytes,
                    onTap: _pickPhoto,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'What’s wrong?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: IncidentColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _issues.map((issue) {
                      final selected = _selected.contains(issue);
                      return IncidentChip(
                        label: issue,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selected.remove(issue);
                            } else {
                              _selected.add(issue);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  IncidentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'I’m declining these items',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: IncidentColors.textPrimary,
                                ),
                              ),
                            ),
                            _DeclineToggle(
                              value: _declining,
                              onChanged: (v) =>
                                  setState(() => _declining = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Vendor must re-pack or re-prepare before you take it.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.35,
                            color: IncidentColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  IncidentPrimaryButton(
                    label: 'Submit & decline items',
                    onPressed: _declining ? _submit : null,
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

/// 24px circular control matching the design: a red ring (red circle with
/// white 20px center) when on, grey ring when off.
class _DeclineToggle extends StatelessWidget {
  const _DeclineToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: value ? IncidentColors.danger : const Color(0xFFD9DDD9),
          shape: BoxShape.circle,
        ),
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: IncidentColors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
