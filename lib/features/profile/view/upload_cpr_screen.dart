import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DU1 · Upload — CPR / National ID
class UploadCprScreen extends StatefulWidget {
  const UploadCprScreen({super.key});

  @override
  State<UploadCprScreen> createState() => _UploadCprScreenState();
}

class _UploadCprScreenState extends State<UploadCprScreen> {
  bool _frontUploaded = true;
  bool _backUploaded = true;
  final _cprNumberController = TextEditingController(text: '000000000');

  @override
  void dispose() {
    _cprNumberController.dispose();
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
            const DocHeader(title: 'CPR / National ID'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload clear photos of the front and back of your CPR.',
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
                      label: 'CPR number',
                      hint: '000000000',
                      controller: _cprNumberController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    const DocTextField(
                      label: 'CPR expiry date',
                      hint: 'DD / MM / YYYY',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 14),
                    const DocTextField(
                      label: 'Birth date',
                      hint: 'DD / MM / YYYY',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 22),
                    DocPrimaryButton(
                      label: 'Save',
                      onPressed: () {
                        showDocSnack(context, 'CPR / National ID saved');
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
