import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DU8 · Upload — Visa
class UploadVisaScreen extends StatefulWidget {
  const UploadVisaScreen({super.key});

  @override
  State<UploadVisaScreen> createState() => _UploadVisaScreenState();
}

class _UploadVisaScreenState extends State<UploadVisaScreen> {
  bool _residenceUploaded = false;
  bool _workUploaded = false;

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
            const DocHeader(title: 'Visa'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your residence / work visa.',
                      style: TextStyle(
                        fontSize: 13,
                        color: DocColors.textMuted,
                        height: 16 / 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DocUploadBox(
                      title: 'Residence permit',
                      uploaded: _residenceUploaded,
                      onTap: () => _pick(() => _residenceUploaded = true),
                    ),
                    const SizedBox(height: 14),
                    DocUploadBox(
                      title: 'Work permit',
                      uploaded: _workUploaded,
                      onTap: () => _pick(() => _workUploaded = true),
                    ),
                    const SizedBox(height: 14),
                    const DocTextField(
                      label: 'Visa number',
                      hint: '000000000',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    const DocTextField(
                      label: 'Expiry date',
                      hint: 'DD / MM / YYYY',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 14),
                    const DocTipBanner(
                      text: 'Upload a valid visa. Expired visas are rejected.',
                    ),
                    const SizedBox(height: 22),
                    DocPrimaryButton(
                      label: 'Save',
                      onPressed: () {
                        showDocSnack(context, 'Visa saved');
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
