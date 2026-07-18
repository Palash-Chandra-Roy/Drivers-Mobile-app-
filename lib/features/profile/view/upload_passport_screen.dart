import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DU7 · Upload — Passport
class UploadPassportScreen extends StatefulWidget {
  const UploadPassportScreen({super.key});

  @override
  State<UploadPassportScreen> createState() => _UploadPassportScreenState();
}

class _UploadPassportScreenState extends State<UploadPassportScreen> {
  bool _photoUploaded = false;
  String? _nationality;
  final _numberController = TextEditingController(text: 'A0000000');

  static const _nationalities = [
    'Bahraini',
    'Bangladeshi',
    'Egyptian',
    'Filipino',
    'Indian',
    'Nepalese',
    'Pakistani',
    'Sri Lankan',
    'Other',
  ];

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final bytes = await pickDocPhoto(context);
    if (bytes != null) setState(() => _photoUploaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DocHeader(title: 'Passport'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Photo page of your passport.',
                      style: TextStyle(
                        fontSize: 13,
                        color: DocColors.textMuted,
                        height: 16 / 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DocUploadBox(
                      title: 'Passport photo page',
                      uploaded: _photoUploaded,
                      onTap: _pick,
                    ),
                    const SizedBox(height: 14),
                    _buildNationalityField(),
                    const SizedBox(height: 14),
                    DocTextField(
                      label: 'Passport number',
                      hint: 'A0000000',
                      controller: _numberController,
                    ),
                    const SizedBox(height: 14),
                    const DocTextField(
                      label: 'Expiry date',
                      hint: 'DD / MM / YYYY',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 14),
                    const DocTipBanner(
                      text: 'Passport must be valid for at least 6 months.',
                    ),
                    const SizedBox(height: 22),
                    DocPrimaryButton(
                      label: 'Save',
                      onPressed: () {
                        showDocSnack(context, 'Passport saved');
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

  Widget _buildNationalityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NATIONALITY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: DocColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: DocColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DocColors.fieldBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _nationality,
              isExpanded: true,
              hint: const Text(
                'Select nationality',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DocColors.textMuted,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: DocColors.textMuted,
              ),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: DocColors.textField,
              ),
              items: _nationalities
                  .map(
                    (n) => DropdownMenuItem<String>(value: n, child: Text(n)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _nationality = value),
            ),
          ),
        ),
      ],
    );
  }
}
