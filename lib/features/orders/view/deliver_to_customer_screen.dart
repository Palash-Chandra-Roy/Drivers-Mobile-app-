import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/features/orders/view/complete_delivery_screen.dart';

/// Screen-local `.h` scale (design height 812). No flutter_screenutil dependency.
extension _DeliverSu on num {
  double h(BuildContext context) =>
      this * MediaQuery.sizeOf(context).height / 812;
}

/// Local UI-only “Deliver to customer” screen (Instant Active → Continue).
/// Shown inside Orders tab so BottomNavigation stays on Orders.
class DeliverToCustomerScreen extends StatefulWidget {
  const DeliverToCustomerScreen({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  State<DeliverToCustomerScreen> createState() =>
      _DeliverToCustomerScreenState();
}

class _DeliverToCustomerScreenState extends State<DeliverToCustomerScreen> {
  static const Color _headerGreen = Color(0xFF4DB04F);
  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF757575);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _iconGreenBg = Color(0xFFE8F5E9);
  static const Color _iconGreen = Color(0xFF2E7D32);
  static const Color _codBg = Color(0xFFFFF3E8);
  static const Color _codOrange = Color(0xFFE67E22);
  static const Color _codOrangeDark = Color(0xFFD35400);
  static const Color _reportBg = Color(0xFFFFF8F3);
  static const Color _reportBorder = Color(0xFFF5A623);
  static const Color _navigateBlack = Color(0xFF1A1A1A);

  bool _showCompleteDelivery = false;

  void _openCompleteDelivery() {
    setState(() => _showCompleteDelivery = true);
  }

  void _closeCompleteDelivery() {
    setState(() => _showCompleteDelivery = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showCompleteDelivery) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: CompleteDeliveryScreen(
          onBack: _closeCompleteDelivery,
        ),
      );
    }

    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) widget.onBack();
        },
        child: ColoredBox(
          color: _screenBg,
          child: Column(
            children: [
              ColoredBox(
                color: Colors.white,
                child: SizedBox(height: topInset),
              ),
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _DeliveryMapPlaceholder(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      child: Column(
                        children: [
                          _buildCustomerCard(),
                          const SizedBox(height: 12),
                          _buildCodCard(),
                          const SizedBox(height: 14),
                          _buildReportNavigateRow(),
                          const SizedBox(height: 12),
                          _buildArrivedButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: _headerGreen,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.near_me_outlined,
              color: Colors.white.withValues(alpha: 0.95),
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver to customer',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '4.2 km · ~18 min',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFE8F5E9),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              'Drop-off',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconGreenBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: _iconGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sara A.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '+973 3300 0000',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _textMuted,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Adliya · Bldg 23, Road 2825, Flat 82',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _textMuted,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Note: “Leave at the door”',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconGreenBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.phone_rounded,
              color: _iconGreen,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _codBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.payments_outlined,
              color: _codOrange,
              size: 22,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collect cash on delivery',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _codOrangeDark,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Hand the order, collect BHD 8.500',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _codOrange,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportNavigateRow() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: Material(
              color: _reportBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: _reportBorder, width: 1.2),
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      color: _codOrange,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _codOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 48,
            child: Material(
              color: _navigateBlack,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.near_me,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Navigate',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrivedButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: _headerGreen,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: _openCompleteDelivery,
          borderRadius: BorderRadius.circular(14),
          child: const Center(
            child: Text(
              'Arrived at customer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Stylized map placeholder matching Figma (no maps SDK).
class _DeliveryMapPlaceholder extends StatelessWidget {
  const _DeliveryMapPlaceholder();

  static const Color _block = Color(0xFFDCE6DF);
  static const Color _road = Color(0xFFFFFFFF);
  static const Color _route = Color(0xFF4DB04F);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390.h(context),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ColoredBox(
            color: _road,
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: const _MapPainter(
                blockColor: _block,
                roadColor: _road,
                routeColor: _route,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.blockColor,
    required this.roadColor,
    required this.routeColor,
  });

  final Color blockColor;
  final Color roadColor;
  final Color routeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const cols = 5;
    const rows = 4;
    const roadW = 10.0;
    final blockW = (w - roadW * (cols + 1)) / cols;
    final blockH = (h - roadW * (rows + 1)) / rows;

    final blockPaint = Paint()..color = blockColor;
    canvas.drawRect(Offset.zero & size, Paint()..color = roadColor);

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final left = roadW + c * (blockW + roadW);
        final top = roadW + r * (blockH + roadW);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left, top, blockW, blockH),
            const Radius.circular(2),
          ),
          blockPaint,
        );
      }
    }

    final start = Offset(w * 0.18, h * 0.72);
    final end = Offset(w * 0.78, h * 0.28);
    final control1 = Offset(w * 0.28, h * 0.35);
    final control2 = Offset(w * 0.55, h * 0.78);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        end.dx,
        end.dy,
      );

    canvas.drawPath(
      path,
      Paint()
        ..color = routeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    _drawPin(canvas, start, const Color(0xFF4DB04F));
    _drawPin(canvas, end, const Color(0xFF1A1A1A));
  }

  void _drawPin(Canvas canvas, Offset tip, Color color) {
    const pinH = 28.0;
    const pinW = 20.0;

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..quadraticBezierTo(
        tip.dx - pinW * 0.55,
        tip.dy - pinH * 0.45,
        tip.dx - pinW * 0.5,
        tip.dy - pinH * 0.7,
      )
      ..arcToPoint(
        Offset(tip.dx + pinW * 0.5, tip.dy - pinH * 0.7),
        radius: const Radius.circular(pinW * 0.5),
        clockwise: true,
      )
      ..quadraticBezierTo(
        tip.dx + pinW * 0.55,
        tip.dy - pinH * 0.45,
        tip.dx,
        tip.dy,
      )
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(tip.dx, tip.dy - pinH * 0.72),
      4.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) =>
      oldDelegate.blockColor != blockColor ||
      oldDelegate.roadColor != roadColor ||
      oldDelegate.routeColor != routeColor;
}
