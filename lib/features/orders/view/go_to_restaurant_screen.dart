import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/navigation/bottom_nav_bar.dart';
import 'package:yjeek_driver/navigation/orders_nav_signal.dart';
import 'package:yjeek_driver/features/orders/view/confirm_pickup_screen.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// Screen-local `.h` scale (design height 812). No flutter_screenutil dependency.
extension _GoToRestaurantSu on num {
  double h(BuildContext context) =>
      this * MediaQuery.sizeOf(context).height / 812;
}

/// Route arguments for [GoToRestaurantScreen].
class GoToRestaurantArgs {
  const GoToRestaurantArgs({
    required this.orderId,
    required this.restaurantName,
    required this.pickupLocation,
    required this.distance,
    required this.estimatedTime,
  });

  final String orderId;
  final String restaurantName;
  final String pickupLocation;
  final String distance;
  final String estimatedTime;

  String get distanceLabel => '$distance · $estimatedTime';
}

/// Local UI-only “Go to restaurant” screen (Order Delivery → Accept).
class GoToRestaurantScreen extends StatelessWidget {
  const GoToRestaurantScreen({
    super.key,
    required this.onBack,
    required this.args,
  });

  final VoidCallback onBack;
  final GoToRestaurantArgs args;

  static const Color _headerGreen = Color(0xFF4DB04F);
  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF6B7B6E);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _iconGreenBg = Color(0xFFE8F5E9);
  static const Color _iconGreen = Color(0xFF2E7D32);
  static const Color _codOrange = Color(0xFFEC74D00);
  static const Color _reportBg = Color(0xFFFFF8F3);
  static const Color _reportBorder = Color(0xFFF5A623);
  static const Color _navigateBlack = Color(0xFF1A1A1A);
  static const String _restaurantIconAsset = 'assets/images/Frame (1).png';

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
          if (!didPop) onBack();
        },
        child: Scaffold(
          backgroundColor: _screenBg,
          body: Column(
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
                    const _PickupMapPlaceholder(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      child: Column(
                        children: [
                          _buildRestaurantCard(),
                          const SizedBox(height: 14),
                          _buildReportNavigateRow(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: _headerGreen,
      padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: Icon(
              Icons.near_me_outlined,
              color: Colors.white.withValues(alpha: 0.95),
              size: 22,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Go to restaurant',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  args.distanceLabel,
                  style: const TextStyle(
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
              'Pickup',
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

  Widget _buildRestaurantCard() {
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
            child: Center(
              child: Image.asset(
                _restaurantIconAsset,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.storefront_rounded,
                  color: _iconGreen,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.restaurantName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${args.pickupLocation} · Order ${args.orderId}',
                  style: const TextStyle(
                    fontSize: 12,
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
                        fontWeight: FontWeight.w600,
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
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.confirmPickup,
              arguments: ConfirmPickupArgs(
                orderId: args.orderId,
                restaurantName: args.restaurantName,
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: const Center(
            child: Text(
              'Arrived at restaurant',
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

/// Stylized map placeholder matching Figma (no maps SDK).
class _PickupMapPlaceholder extends StatelessWidget {
  const _PickupMapPlaceholder();

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
