import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/features/orders/view/scheduled_delivery_order.dart';
import 'package:yjeek_driver/features/orders/view/scheduled_delivery_shared.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// Local UI-only “Deliver to customer” screen for scheduled On Track deliveries.
class ScheduledDeliverToCustomerScreen extends StatelessWidget {
  const ScheduledDeliverToCustomerScreen({
    super.key,
    required this.order,
  });

  final ScheduledDeliveryOrder order;

  static const Color _headerGreen = Color(0xFF4DB04F);
  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF757575);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _iconGreenBg = Color(0xFFE8F5E9);
  static const Color _iconGreen = Color(0xFF2E7D32);
  static const Color _prepaidBg = Color(0xFFE8F5E9);
  static const Color _prepaidHeading = Color(0xFF2E7D32);
  static const Color _codBg = Color(0xFFFFF3E8);
  static const Color _codOrange = Color(0xFFE67E22);
  static const Color _codOrangeDark = Color(0xFFD35400);
  static const String _cashIconAsset =
      'assets/images/cash_on_delivery_icon.png';

  @override
  Widget build(BuildContext context) {
    ScheduledDeliveryScale.update(MediaQuery.sizeOf(context));
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const ScheduledMapPlaceholder(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        16.sw,
                        14.sh,
                        16.sw,
                        24.sh + bottomInset,
                      ),
                      child: Column(
                        children: [
                          _buildCustomerCard(),
                          SizedBox(height: 12.sh),
                          order.isPrepaid
                              ? _buildPrepaidCard()
                              : _buildCashCard(),
                          SizedBox(height: 14.sh),
                          scheduledReportNavigateRow(),
                          SizedBox(height: 12.sh),
                          _buildArrivedButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: scheduledBottomNav(context),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: _headerGreen,
      padding: EdgeInsets.fromLTRB(16.sw, 14.sh, 16.sw, 14.sh),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.sh),
            child: Icon(
              Icons.near_me_outlined,
              color: Colors.white.withValues(alpha: 0.95),
              size: 22.ssp,
            ),
          ),
          SizedBox(width: 10.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver to customer',
                  style: TextStyle(
                    fontSize: 17.ssp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3.sh),
                Text(
                  order.deliveryDistanceEtaLabel,
                  style: TextStyle(
                    fontSize: 13.ssp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFE8F5E9),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.sh),
            child: Text(
              'Drop-off',
              style: TextStyle(
                fontSize: 13.ssp,
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
      padding: EdgeInsets.fromLTRB(12.sw, 12.sh, 12.sw, 12.sh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.sw,
            height: 40.sw,
            decoration: BoxDecoration(
              color: _iconGreenBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.person_rounded, color: _iconGreen, size: 22.ssp),
          ),
          SizedBox(width: 10.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: TextStyle(
                    fontSize: 15.ssp,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 3.sh),
                Text(
                  order.customerPhone,
                  style: TextStyle(
                    fontSize: 13.ssp,
                    fontWeight: FontWeight.w400,
                    color: _textMuted,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 2.sh),
                Text(
                  order.customerAddress,
                  style: TextStyle(
                    fontSize: 13.ssp,
                    fontWeight: FontWeight.w400,
                    color: _textMuted,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 2.sh),
                Text(
                  order.scheduledWindow,
                  style: TextStyle(
                    fontSize: 13.ssp,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.sw),
          Container(
            width: 40.sw,
            height: 40.sw,
            decoration: BoxDecoration(
              color: _iconGreenBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.phone_rounded, color: _iconGreen, size: 20.ssp),
          ),
        ],
      ),
    );
  }

  Widget _buildPrepaidCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.sw, vertical: 14.sh),
      decoration: BoxDecoration(
        color: _prepaidBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: _prepaidHeading, size: 22.ssp),
          SizedBox(width: 10.sw),
          Expanded(
            child: Text(
              'Prepaid order — no cash to collect.',
              style: TextStyle(
                fontSize: 14.ssp,
                fontWeight: FontWeight.w600,
                color: _prepaidHeading,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.sw, vertical: 14.sh),
      decoration: BoxDecoration(
        color: _codBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.sh),
            child: SizedBox(
              width: 22,
              height: 13,
              child: Image.asset(
                _cashIconAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.payments_outlined,
                  color: _codOrange,
                  size: 22.ssp,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collect cash on delivery',
                  style: TextStyle(
                    fontSize: 14.ssp,
                    fontWeight: FontWeight.w700,
                    color: _codOrangeDark,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 3.sh),
                Text(
                  'Hand the order, collect ${order.cashAmount ?? ''}',
                  style: TextStyle(
                    fontSize: 13.ssp,
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

  Widget _buildArrivedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.sh,
      child: Material(
        color: _headerGreen,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.scheduledCompleteDelivery,
              arguments: order,
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Text(
              'Arrived at customer',
              style: TextStyle(
                fontSize: 16.ssp,
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
