import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Screen-local ScreenUtil-compatible scale (design size 375×812).
/// Avoids adding flutter_screenutil for this screen-only requirement.
class _SU {
  _SU._(this._scaleW, this._scaleH, this._scaleR);

  factory _SU.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scaleW = size.width / 375;
    final scaleH = size.height / 812;
    final scaleR = math.min(scaleW, scaleH);
    return _SU._(scaleW, scaleH, scaleR);
  }

  final double _scaleW;
  final double _scaleH;
  final double _scaleR;

  double w(num v) => v * _scaleW;
  double h(num v) => v * _scaleH;
  double r(num v) => v * _scaleR;
}

/// Local UI-only screen for releasing a scheduled order.
/// Shown inside Orders tab so BottomNavigation stays on Orders.
class ReleaseScheduledOrderScreen extends StatefulWidget {
  const ReleaseScheduledOrderScreen({
    super.key,
    required this.orderId,
    required this.onBack,
    required this.onKeepOrder,
    required this.onSubmitRelease,
  });

  final String orderId;
  final VoidCallback onBack;
  final VoidCallback onKeepOrder;
  final void Function(String reason, String note) onSubmitRelease;

  @override
  State<ReleaseScheduledOrderScreen> createState() =>
      _ReleaseScheduledOrderScreenState();
}

class _ReleaseScheduledOrderScreenState
    extends State<ReleaseScheduledOrderScreen> {
  static const Color _headerGreen = Color(0xFF4DB04F);
  static const Color _screenBg = Color(0xFFF5F5F5);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF9E9E9E);
  static const Color _textSecondary = Color(0xFF757575);
  static const Color _border = Color(0xFFE0E0E0);
  static const Color _submitRed = Color(0xFFE53935);
  static const Color _radioSelected = Color(0xFF4DB04F);

  static const _reasons = [
    'Vehicle / bike breakdown',
    'Personal emergency',
    'Schedule conflict',
    'Distance too far',
    'Safety concern',
    'Other (please specify)',
  ];

  int? _selectedReason;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _selectedReason != null;

  void _submit() {
    if (!_canSubmit) return;
    widget.onSubmitRelease(
      _reasons[_selectedReason!],
      _noteController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final su = _SU.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _headerGreen,
        statusBarIconBrightness: Brightness.light,
      ),
      child: ColoredBox(
        color: _screenBg,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24 + bottomInset,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  const Text(
                    'Reason (required)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildReasonsCard(),
                  const SizedBox(height: 14),
                  _buildNoteCard(),
                  const SizedBox(height: 20),
                  Center(
                    child: _ActionOutlineButton(
                      label: 'Submit release',
                      textColor: _submitRed,
                      enabled: _canSubmit,
                      onTap: _submit,
                      width: su.w(358),
                      height: su.h(52),
                      radius: su.r(28),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ActionOutlineButton(
                    label: 'Keep the order',
                    textColor: _textPrimary,
                    enabled: true,
                    onTap: widget.onKeepOrder,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: _headerGreen,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Release this order',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  widget.orderId,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFEDF2EF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _reasons.length; i++) ...[
            if (i > 0) const Divider(height: 1, thickness: 1, color: _border),
            InkWell(
              onTap: () => setState(() => _selectedReason = i),
              borderRadius: BorderRadius.vertical(
                top: i == 0 ? const Radius.circular(12) : Radius.zero,
                bottom: i == _reasons.length - 1
                    ? const Radius.circular(12)
                    : Radius.zero,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _reasons[i],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                    _RadioDot(selected: _selectedReason == i),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add a note (optional)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 3,
              minLines: 2,
              cursorColor: _textPrimary,
              style: const TextStyle(
                fontSize: 14,
                color: _textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: 'Tell us more about why you’re releasing...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: _textMuted,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? _ReleaseScheduledOrderScreenState._radioSelected
              : const Color(0xFFBDBDBD),
          width: selected ? 6 : 1.5,
        ),
        color: selected ? Colors.white : Colors.transparent,
      ),
    );
  }
}

class _ActionOutlineButton extends StatelessWidget {
  const _ActionOutlineButton({
    required this.label,
    required this.textColor,
    required this.enabled,
    required this.onTap,
    this.width,
    this.height,
    this.radius,
  });

  final String label;
  final Color textColor;
  final bool enabled;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? double.infinity;
    final buttonHeight = height ?? 50;
    final buttonRadius = radius ?? 12;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(buttonRadius),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
