import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/navigation/bottom_nav_bar.dart';
import 'package:yjeek_driver/navigation/orders_nav_signal.dart';
import 'package:yjeek_driver/routes/route_names.dart';

extension _GoToCustomerSu on num {
  double h(BuildContext context) =>
      this * MediaQuery.sizeOf(context).height / 812;
}

/// Local UI-only "Go to customer" screen for the instant delivery flow.
class GoToCustomerScreen extends StatelessWidget {
  const GoToCustomerScreen({super.key});

  static const Color _headerGreen = Color(0xFF4DB04F);
  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF6B7B6E);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _iconGreenBg = Color(0xFFE8F5E9);
  static const Color _iconGreen = Color(0xFF2E7D32);
  static const Color _codBg = Color(0xFFFFF0DE);
  static const Color _codOrange = Color(0xFFE67E22);
  static const Color _reportBg = Color(0xFFFFF8F3);
  static const Color _reportBorder = Color(0xFFF5A623);
  static const Color _navigateBlack = Color(0xFF1A1A1A);
  static const Color _mapBlock = Color(0xFFDCE6DF);
  static const Color _mapRoad = Color(0xFFFFFFFF);
  static const Color _mapRoute = Color(0xFF4DB04F);

  static const String _orderId = '#YJK-...41';
  static const String _customerName = 'Sara A.';
  static const String _customerPhone = '+973 3300 0000';
  static const String _customerAddress = 'Adliya · Bldg 23, Road 2825, Flat 82';
  static const String _deliveryNote = 'Leave at the door';
  static const String _cashIconAsset =
      'assets/images/cash_on_delivery_icon.png';

  void _handleBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.mainNavigation,
          (route) => false,
        );
        return;
      case 1:
        OrdersNavSignal.openInstant();
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.mainNavigation,
          (route) => false,
        );
        return;
      case 2:
        Navigator.pushNamed(context, RouteNames.earnings);
        return;
      case 3:
        Navigator.pushNamed(context, RouteNames.notifications);
        return;
      case 4:
        Navigator.pushNamed(context, RouteNames.profile);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (!didPop) Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: _screenBg,
          body: Column(
            children: [
              ColoredBox(
                color: Colors.white,
                child: SizedBox(height: topInset),
              ),
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const _GoToCustomerMap(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      child: Column(
                        children: [
                          _buildCustomerCard(),
                          const SizedBox(height: 10),
                          _buildCashCard(),
                          const SizedBox(height: 14),
                          _buildReportNavigateRow(context),
                          const SizedBox(height: 12),
                          _buildArrivedButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 1,
            onTap: (index) => _handleBottomNavTap(context, index),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _headerGreen,
      padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: Icon(
              Icons.near_me_outlined,
              color: Colors.white.withValues(alpha: 0.95),
              size: 22,
            ),
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver to customer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '4.2 km · ~18 min',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFCFE3D5),
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
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFFCFE3D5),
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
              Icons.person_outline_rounded,
              color: _iconGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  _customerPhone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _customerAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Note:  $_deliveryNote',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                    height: 1.25,
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

  Widget _buildCashCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _codBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SizedBox(
              width: 22,
              height: 13,
              child: Image.asset(
                _cashIconAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.payments_outlined,
                  color: _codOrange,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collect cash on delivery',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _codOrange,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Hand the order, collect BHD 8.500',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _codOrange,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportNavigateRow(BuildContext context) {
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
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.reportAtDropoff,
                  arguments: const {
                    'orderId': _orderId,
                    'customerName': _customerName,
                    'address': _customerAddress,
                  },
                ),
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

  Widget _buildArrivedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: _headerGreen,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, RouteNames.cashCompleteDelivery),
          borderRadius: BorderRadius.circular(14),
          child: const Center(
            child: Text(
              'Arrived at customer',
              style: TextStyle(
                fontSize: 15,
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

class _GoToCustomerMap extends StatelessWidget {
  const _GoToCustomerMap();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390.h(context),
      width: double.infinity,
      child: const CustomPaint(
        painter: _GoToCustomerMapPainter(),
      ),
    );
  }
}

class _GoToCustomerMapPainter extends CustomPainter {
  const _GoToCustomerMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const cols = 5;
    const rows = 4;
    const roadW = 10.0;
    final blockW = (w - roadW * (cols + 1)) / cols;
    final blockH = (h - roadW * (rows + 1)) / rows;

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = GoToCustomerScreen._mapRoad,
    );
    final blockPaint = Paint()..color = GoToCustomerScreen._mapBlock;

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
    final control1 = Offset(w * 0.31, h * 0.58);
    final control2 = Offset(w * 0.34, h * 0.40);
    final control3 = Offset(w * 0.47, h * 0.34);
    final control4 = Offset(w * 0.59, h * 0.22);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, control3.dx,
          control3.dy)
      ..cubicTo(control4.dx, control4.dy, w * 0.70, h * 0.24, end.dx, end.dy);

    canvas.drawPath(
      path,
      Paint()
        ..color = GoToCustomerScreen._mapRoute
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    _drawPin(canvas, start, GoToCustomerScreen._mapRoute);
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
  bool shouldRepaint(covariant _GoToCustomerMapPainter oldDelegate) => false;
}
