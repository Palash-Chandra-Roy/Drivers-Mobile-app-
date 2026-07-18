import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// Verify number — opened after "Send code" on Change number.
class VerifyChangeNumberScreen extends StatefulWidget {
  const VerifyChangeNumberScreen({super.key, required this.phoneDisplay});

  final String phoneDisplay;

  @override
  State<VerifyChangeNumberScreen> createState() =>
      _VerifyChangeNumberScreenState();
}

class _VerifyChangeNumberScreenState extends State<VerifyChangeNumberScreen> {
  static const int _otpLength = 4;
  static const String _correctOtp = '5290';

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isWrongCode = false;
  int _resendSeconds = 24;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  int get _activeIndex {
    for (var i = 0; i < _otpLength; i++) {
      if (_controllers[i].text.isEmpty) return i;
    }
    return _otpLength - 1;
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendSeconds = 24;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _resendSeconds--);
    });
  }

  String get _timerText {
    final minutes = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onOtpChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value[value.length - 1];
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);
      value = _controllers[index].text;
    }

    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() => _isWrongCode = false);
  }

  void _onVerify() {
    final otp = _otpCode;
    if (otp.length < _otpLength || otp != _correctOtp) {
      setState(() => _isWrongCode = true);
      return;
    }

    showDocSnack(context, 'Number updated successfully');
    Navigator.pop(context, true);
  }

  void _onResendCode() {
    if (_resendSeconds > 0) return;
    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _isWrongCode = false);
    _startResendTimer();
    _focusNodes[0].requestFocus();
    showDocSnack(context, 'Verification code resent');
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeIndex;

    return Scaffold(
      backgroundColor: DocColors.accountBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const horizontalPadding = 20.0;
            const spacing = 14.0;
            final availableWidth =
                constraints.maxWidth - (horizontalPadding * 2);
            final boxWidth =
                ((availableWidth - (spacing * (_otpLength - 1))) / _otpLength)
                    .clamp(60.0, 78.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DocHeader(
                    title: _isWrongCode ? 'Wrong code' : 'Verify number',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isWrongCode
                        ? 'Incorrect code — please try again'
                        : 'Enter the 4-digit code',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _isWrongCode
                          ? const Color(0xFFD71920)
                          : DocColors.textPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sent by SMS to ${widget.phoneDisplay}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7C6B),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_otpLength, (index) {
                      return _OtpBox(
                        width: boxWidth,
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        isActive: index == activeIndex,
                        onChanged: (value) => _onOtpChanged(index, value),
                      );
                    }),
                  ),
                  const SizedBox(height: 18),
                  if (_isWrongCode || _resendSeconds <= 0)
                    Row(
                      children: [
                        const Text(
                          "Didn't get it? ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7C6B),
                          ),
                        ),
                        GestureDetector(
                          onTap: _onResendCode,
                          child: const Text(
                            'Resend code',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: DocColors.pillGreen,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        const Text(
                          'Resend code in ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7C6B),
                          ),
                        ),
                        Text(
                          _timerText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: DocColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 22),
                  DocPrimaryButton(
                    label: 'Verify & continue',
                    color: DocColors.pillGreen,
                    radius: 28,
                    height: 52,
                    onPressed: _onVerify,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.width,
    required this.controller,
    required this.focusNode,
    required this.isActive,
    required this.onChanged,
  });

  final double width;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isActive;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 62,
      child: Container(
        decoration: BoxDecoration(
          color: DocColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? DocColors.pillGreen : DocColors.accountBorder,
            width: isActive ? 2.5 : 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: DocColors.textPrimary,
            height: 1,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            isCollapsed: true,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
