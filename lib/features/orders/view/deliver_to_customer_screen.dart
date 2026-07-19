import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/features/orders/view/complete_delivery_screen.dart';
import 'package:yjeek_driver/routes/route_names.dart';

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
  static const Color _screenBg = Color(0xFFF4F8F2);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF9E9E9E);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _prepaidBg = Color(0xFFE8F5E9);
  static const Color _prepaidText = Color(0xFF2E7D32);
  static const Color _reportText = Color(0xFFCFE3D5);
  static const Color _reportBg = Color(0xFFFFF8F3);
  static const Color _reportBorder = Color(0xFFF5A623);
  static const Color _reportOrange = Color(0xFFE67E22);
  static const Color _navigateBlack = Color(0xFF1A1A1A);

  bool _showCompleteDelivery = false;

  void _openCompleteDelivery() {
    Navigator.pushNamed(context, RouteNames.completeDelivery);
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
                    const _DeliveryMapPlaceholder(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      child: Column(
                        children: [
                          _buildDropOffCard(),
                          const SizedBox(height: 12),
                          _buildPrepaidBanner(),
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
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.22),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: widget.onBack,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _reportText,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: _reportText,
                  size: 13,
                ),
                SizedBox(width: 4),
                Text(
                  'Report',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _reportText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropOffCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Drop-off',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          _buildDetailRow('Customer', 'Sara A.'),
          const SizedBox(height: 10),
          _buildDetailRow('Phone', '+973 3300 0000'),
          const SizedBox(height: 10),
          _buildDetailRow('Address', 'Adliya · Bldg 23, Road 2825'),
          const SizedBox(height: 10),
          _buildDetailRow('Window', 'Today · 6–8 PM'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: _textMuted,
            height: 1.3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrepaidBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _prepaidBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_box_outlined, color: _prepaidText, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Prepaid order — no cash to collect.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _prepaidText,
                height: 1.35,
              ),
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
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.reportAtDropoff,
                ),
                borderRadius: BorderRadius.circular(14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      color: _reportOrange,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _reportOrange,
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

/// Simple map placeholder matching Figma (no maps SDK).
class _DeliveryMapPlaceholder extends StatelessWidget {
  const _DeliveryMapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: const Color(0xFFE8EFE4),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, color: Color(0xFF9E9E9E), size: 32),
          SizedBox(height: 6),
          Text(
            'map',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}
