import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DE1 · Earnings
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _selectedPeriod = 1; // 0 Today, 1 This week, 2 This month

  static const _periods = ['Today', 'This week', 'This month'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Earnings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: DocColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSegmentedControl(),
                    const SizedBox(height: 14),
                    _buildSummaryCard(),
                    const SizedBox(height: 14),
                    _buildEstimateNote(),
                    const SizedBox(height: 14),
                    _buildBreakdownCard(),
                    const SizedBox(height: 14),
                    _buildCodCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFE7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(_periods.length, (i) {
          final selected = i == _selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = i),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? DocColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _periods[i],
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? DocColors.textPrimary
                        : DocColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DocColors.greenDeep,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This week · earnings',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFCFE3D5),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'BHD 86.400',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text(
                '32 trips',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCFE3D5),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '·',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCFE3D5),
                  ),
                ),
              ),
              Text(
                '18h 20m online',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCFE3D5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstimateNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: DocColors.infoBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'ⓘ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: DocColors.infoText,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Amounts shown are estimates and may not be final. '
              'Your earnings are confirmed after settlement.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: DocColors.infoText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DocColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Breakdown',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: DocColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          _BreakdownRow(label: 'Trip fares', value: 'BHD 72.000'),
          SizedBox(height: 10),
          _BreakdownRow(
            label: 'Tips',
            value: 'BHD 6.400',
            valueColor: DocColors.greenDark,
          ),
          SizedBox(height: 10),
          _BreakdownRow(
            label: 'Incentives & bonuses',
            value: 'BHD 8.000',
            valueColor: DocColors.greenDark,
          ),
          SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: DocColors.cardBorder),
          SizedBox(height: 12),
          _BreakdownRow(label: 'Total', value: 'BHD 86.400', bold: true),
        ],
      ),
    );
  }

  Widget _buildCodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DocColors.warnBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'COD to settle',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9A6A1E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'BHD 24.500',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: DocColors.warnText,
                  ),
                ),
              ],
            ),
          ),
          const _CodIcon(),
        ],
      ),
    );
  }
}

/// Rounded square with a centered circle, matching the design's COD icon.
class _CodIcon extends StatelessWidget {
  const _CodIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: DocColors.warnText, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          border: Border.all(color: DocColors.warnText, width: 2),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: bold ? DocColors.textPrimary : DocColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? DocColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
