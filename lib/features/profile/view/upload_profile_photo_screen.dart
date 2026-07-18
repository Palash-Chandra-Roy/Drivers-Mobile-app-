import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DU5 · Upload — Profile photo
class UploadProfilePhotoScreen extends StatefulWidget {
  const UploadProfilePhotoScreen({super.key});

  @override
  State<UploadProfilePhotoScreen> createState() =>
      _UploadProfilePhotoScreenState();
}

class _UploadProfilePhotoScreenState extends State<UploadProfilePhotoScreen> {
  Uint8List? _photoBytes;

  Future<void> _pick() async {
    final bytes = await pickDocPhoto(context);
    if (bytes != null) setState(() => _photoBytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DocHeader(title: 'Profile photo'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'A clear photo of your face — no sunglasses or hats.',
                      style: TextStyle(
                        fontSize: 13,
                        color: DocColors.textMuted,
                        height: 16 / 13,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: GestureDetector(
                        onTap: _pick,
                        child: Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              alignment: Alignment.center,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                color: DocColors.doneBg,
                                shape: BoxShape.circle,
                              ),
                              child: _photoBytes != null
                                  ? Image.memory(
                                      _photoBytes!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : const Text(
                                      '🙂',
                                      style: TextStyle(fontSize: 40),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to replace',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: DocColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    DocPrimaryButton(
                      label: 'Save',
                      onPressed: () {
                        showDocSnack(context, 'Profile photo saved');
                        Navigator.maybePop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
