import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/utils/validators.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/core/widgets/custom_text_field.dart';

class VerifyHandoverScreen extends StatefulWidget {
  const VerifyHandoverScreen({super.key});

  @override
  State<VerifyHandoverScreen> createState() => _VerifyHandoverScreenState();
}

class _VerifyHandoverScreenState extends State<VerifyHandoverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    AppHelpers.showSnackBar(context, 'Handover verified successfully!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify Handover'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ask the customer for their order verification code to confirm handover.',
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(height: AppSizes.paddingLg),
                CustomTextField(
                  controller: _codeController,
                  labelText: 'Order Code',
                  hintText: 'Enter 4-digit code',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.pin_outlined),
                  validator: (v) => Validators.required(v, fieldName: 'Order code'),
                ),
                const Spacer(),
                CustomButton(title: 'Confirm Handover', onPressed: _confirm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
