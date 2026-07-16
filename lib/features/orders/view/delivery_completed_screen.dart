import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/navigation/bottom_nav_bar.dart';
import 'package:yjeek_driver/navigation/orders_nav_signal.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class _DeliveryCompletedScale {
  static const Size _designSize = Size(390, 844);
  static Size _screenSize = _designSize;

  static void update(Size size) {
    if (size.width > 0 && size.height > 0) {
      _screenSize = size;
    }
  }

  static double width(num value) =>
      value.toDouble() * (_screenSize.width / _designSize.width);

  static double height(num value) =>
      value.toDouble() * (_screenSize.height / _designSize.height);
}

extension _DeliveryCompletedUnits on num {
  double get w => _DeliveryCompletedScale.width(this);

  double get h => _DeliveryCompletedScale.height(this);

  double get sp => _DeliveryCompletedScale.width(this);
}

/// Local UI-only “Delivery completed” success screen.
class DeliveryCompletedScreen extends StatelessWidget {
  const DeliveryCompletedScreen({super.key});

  static const Color _white = Color(0xFFFFFFFF);
  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF6B7B6E);
  static const Color _successGreen = Color(0xFF4CAF50);
  static const Color _earningsCardBg = Color(0xFFE8F5E9);
  static const Color _earningsGreen = Color(0xFF0F4D27);
  static const Color _earningsSubGreen = Color(0xFF2E7D32);
  static const Color _summaryBorder = Color(0xFFE0E0E0);
  static const Color _divider = Color(0xFFE8E8E8);
  static const Color _buttonGreen = Color(0xFF4CAF50);

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
    _DeliveryCompletedScale.update(MediaQuery.sizeOf(context));
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: _white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _screenBg,
        body: Column(
          children: [
            ColoredBox(
              color: _white,
              child: SizedBox(height: topInset),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 28.h),
                    _buildSuccessSection(),
                    SizedBox(height: 22.h),
                    _buildEarningsCard(),
                    SizedBox(height: 12.h),
                    _buildSummaryCard(),
                    const Spacer(),
                    SizedBox(height: 28.h),
                    _buildFindNextOrderButton(),
                    SizedBox(height: 20.h + bottomInset),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (index) => _handleBottomNavTap(context, index),
        ),
      ),
    );
  }

  Widget _buildSuccessSection() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: const BoxDecoration(
              color: _successGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: _white,
              size: 40.sp,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delivery completed 🎉',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              height: 1.2,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: _earningsCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            '+ BHD 2.300',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              color: _earningsGreen,
              height: 1.1,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Added to today · incl. BHD 0.300 tip',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: _earningsSubGreen,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _summaryBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _buildSummaryColumn('4.2 km', 'Distance')),
            Container(width: 1, color: _divider),
            Expanded(child: _buildSummaryColumn('22 min', 'Time')),
            Container(width: 1, color: _divider),
            Expanded(child: _buildSummaryColumn('Cash', 'BHD 8.500')),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: _textMuted,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildFindNextOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 49.h,
      child: Material(
        color: _buttonGreen,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.near_me_rounded,
                color: _white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Find next order',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: _white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
