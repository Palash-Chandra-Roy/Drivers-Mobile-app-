import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// DA2 · Change number
class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  String get _formattedPhone {
    final digits = _numberController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '+973 3300 0000';
    if (digits.length <= 4) return '+973 $digits';
    return '+973 ${digits.substring(0, 4)} ${digits.substring(4)}';
  }

  Future<void> _sendCode() async {
    final digits = _numberController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      showDocSnack(context, 'Please enter a valid phone number');
      return;
    }

    FocusScope.of(context).unfocus();
    final verified = await Navigator.pushNamed(
      context,
      RouteNames.verifyChangeNumber,
      arguments: _formattedPhone,
    );

    if (!mounted) return;
    if (verified == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.accountBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DocHeader(title: 'Change number'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentNumberCard(),
                    const SizedBox(height: 14),
                    const Text(
                      'New number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: DocColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildNewNumberField(),
                    const SizedBox(height: 14),
                    _buildInfoBanner(),
                    const SizedBox(height: 22),
                    DocPrimaryButton(
                      label: 'Send code',
                      color: DocColors.pillGreen,
                      radius: 28,
                      height: 52,
                      onPressed: _sendCode,
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

  Widget _buildCurrentNumberCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DocColors.accountBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Current number',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B756E),
            ),
          ),
          SizedBox(height: 6),
          Text(
            '+973 3300 0000',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: DocColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewNumberField() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DocColors.accountBorder, width: 1.2),
      ),
      child: Row(
        children: [
          const Text('🇧🇭', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          const Text(
            '+973',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: DocColors.textPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 24, color: DocColors.accountBorder),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: DocColors.textPrimary,
              ),
              cursorColor: DocColors.pillGreen,
              decoration: const InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '3XXX XXXX',
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: Color(0xFF99A199),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: DocColors.bannerGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'i',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'We\u2019ll send a 4-digit verification code to the new number.',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                height: 15 / 12.5,
                color: DocColors.bannerGreenText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
