import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DE2 · Performance
class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

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
                'Performance',
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
                  children: [
                    _buildRpiCard(),
                    const SizedBox(height: 14),
                    const _StatCard(
                      value: '284',
                      label: 'Total orders',
                      centered: true,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(value: '92%', label: 'Acceptance'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            value: '98%',
                            label: 'Completion',
                            valueColor: DocColors.greenDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            value: '4.9★',
                            label: 'Rating',
                            valueColor: DocColors.gold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(value: '95%', label: 'On-time'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildGoldTierCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRpiCard() {
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
          SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: _RpiGaugePainter(progress: 0.88),
              ),
            ),
          ),
          SizedBox(height: 18),
          Center(
            child: Text(
              '88',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: DocColors.greenDeep,
                height: 1.1,
              ),
            ),
          ),
          Center(
            child: Text(
              'RPI score',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: DocColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Great standing',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: DocColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Keep RPI ≥ 82 to stay in priority dispatch and receive more orders.',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: DocColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildGoldTierCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DocColors.tierBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star_outline_rounded,
            size: 26,
            color: DocColors.tierText,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Gold tier · weekly bonus unlocked',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: DocColors.tierText,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '32 / 30 trips this week · BHD 8 bonus earned',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: DocColors.tierText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.valueColor = DocColors.textPrimary,
    this.centered = false,
  });

  final String value;
  final String label;
  final Color valueColor;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DocColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: DocColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RpiGaugePainter extends CustomPainter {
  const _RpiGaugePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 13.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = DocColors.cardBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, track);

    // Four short green dashes evenly spaced with wide grey gaps,
    // matching the dashed ring in the design.
    const dashes = 4;
    const gap = 0.8; // radians of grey visible between dashes
    const dashSweep = (2 * math.pi / dashes) - gap;

    final arc = Paint()
      ..color = DocColors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    var start = -math.pi / 2 - dashSweep / 2;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect, start, dashSweep, false, arc);
      start += dashSweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _RpiGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
