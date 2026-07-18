import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DU2 · Upload — Driving license
class UploadDrivingLicenseScreen extends StatefulWidget {
  const UploadDrivingLicenseScreen({super.key});

  @override
  State<UploadDrivingLicenseScreen> createState() =>
      _UploadDrivingLicenseScreenState();
}

class _UploadDrivingLicenseScreenState
    extends State<UploadDrivingLicenseScreen> {
  bool _frontUploaded = true;
  bool _backUploaded = true;
  final _expiryController = TextEditingController(text: '01 / 12 / 2028');

  @override
  void dispose() {
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _pick(void Function() markUploaded) async {
    final bytes = await pickDocPhoto(context);
    if (bytes != null) setState(markUploaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DocHeader(title: 'Driving license'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Front and back of your valid driving license.',
                      style: TextStyle(
                        fontSize: 13,
                        color: DocColors.textMuted,
                        height: 16 / 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DocUploadBox(
                      title: 'Front side',
                      uploaded: _frontUploaded,
                      height: 138,
                      onTap: () => _pick(() => _frontUploaded = true),
                    ),
                    const SizedBox(height: 14),
                    DocUploadBox(
                      title: 'Back side',
                      uploaded: _backUploaded,
                      height: 138,
                      onTap: () => _pick(() => _backUploaded = true),
                    ),
                    const SizedBox(height: 14),
                    DocTextField(
                      label: 'License expiry date',
                      hint: 'DD / MM / YYYY',
                      controller: _expiryController,
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 14),
                    const DocTipBanner(
                      text:
                          'License must be valid for at least 3 more months.',
                    ),
                    const SizedBox(height: 22),
                    DocPrimaryButton(
                      label: 'Save',
                      onPressed: () {
                        showDocSnack(context, 'Driving license saved');
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
