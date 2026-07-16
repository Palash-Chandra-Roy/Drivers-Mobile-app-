import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yjeek_driver/features/orders/view/delivery_completed_screen.dart';
import 'package:yjeek_driver/navigation/bottom_nav_bar.dart';
import 'package:yjeek_driver/navigation/orders_nav_signal.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class _CompleteDeliveryScale {
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

extension _CompleteDeliveryUnits on num {
  double get w => _CompleteDeliveryScale.width(this);

  double get h => _CompleteDeliveryScale.height(this);

  double get sp => _CompleteDeliveryScale.width(this);
}

/// Local UI-only “Complete delivery” screen (Deliver to customer → Arrived).
class CompleteDeliveryScreen extends StatefulWidget {
  const CompleteDeliveryScreen({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  State<CompleteDeliveryScreen> createState() => _CompleteDeliveryScreenState();
}

class _CompleteDeliveryScreenState extends State<CompleteDeliveryScreen> {
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF6B7B6E);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _iconGreenBg = Color(0xFFE8F5E9);
  static const Color _iconGreen = Color(0xFF2E7D32);
  static const Color _checkGreen = Color(0xFF4CAF50);
  static const Color _cashCardBg = Color(0xFFFFF0DE);
  static const Color _cashHeading = Color(0xFF9A6A1E);
  static const Color _cashAmount = Color(0xFFE08A1E);
  static const Color _cashRowBorder = Color(0xFFE8D5C4);
  static const Color _uploadBg = Color(0xFFF5F5F5);
  static const Color _uploadBorder = Color(0xFFBDBDBD);
  static const Color _uploadIcon = Color(0xFF9E9E9E);
  static const Color _confirmGreen = Color(0xFF4CAF50);
  static const Color _radioEmpty = Color(0xFFBDBDBD);

  static const String _cashIconAsset =
      'assets/images/cash_on_delivery_icon.png';

  static const String _customerName = 'Sara A.';
  static const String _orderInfo = 'Adliya · Order #YJK-...41';
  static const String _cashAmountText = 'BHD 8.500';

  bool _cashCollected = false;
  bool _hasProofPhoto = false;
  bool _showDeliveryCompleted = false;
  Uint8List? _proofPhotoBytes;
  final ImagePicker _imagePicker = ImagePicker();

  bool get _canComplete => _cashCollected && _hasProofPhoto;

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

  Future<void> _selectProofPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: _white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take photo'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || source == null) return;

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (!mounted || picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      setState(() {
        _proofPhotoBytes = bytes;
        _hasProofPhoto = true;
      });
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to access photos. Please try again.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo selection failed. Please try again.'),
        ),
      );
    }
  }

  void _completeDelivery() {
    if (!_canComplete) return;
    setState(() => _showDeliveryCompleted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_showDeliveryCompleted) {
      return const DeliveryCompletedScreen();
    }

    _CompleteDeliveryScale.update(MediaQuery.sizeOf(context));
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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) widget.onBack();
        },
        child: Scaffold(
          backgroundColor: _screenBg,
          body: Column(
            children: [
              ColoredBox(
                color: _white,
                child: SizedBox(height: topInset),
              ),
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    16.h,
                    16.w,
                    16.h + bottomInset,
                  ),
                  children: [
                    _buildCustomerCard(),
                    SizedBox(height: 14.h),
                    _buildCashCard(),
                    SizedBox(height: 18.h),
                    _buildProofHeading(),
                    SizedBox(height: 10.h),
                    _buildUploadArea(),
                    SizedBox(height: 20.h),
                    _buildCompleteButton(),
                    if (!_canComplete) ...[
                      SizedBox(height: 8.h),
                      Text(
                        'Select cash collected and add proof photo to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _textMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
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
      color: _white,
      padding: EdgeInsets.fromLTRB(4.w, 8.h, 16.w, 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _textPrimary,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              'Complete delivery',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
                height: 1.2,
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
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
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
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _customerName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  _orderInfo,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
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

  Widget _buildCashCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: _cashCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collect cash',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: _cashHeading,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _cashAmountText,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: _cashAmount,
                        height: 1.1,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: SizedBox(
                  width: 28,
                  height: 18,
                  child: Image.asset(
                    _cashIconAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.payments_outlined,
                      color: _cashHeading,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Material(
            color: _white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => setState(() => _cashCollected = !_cashCollected),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cashRowBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      _cashCollected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: _cashCollected ? _checkGreen : _radioEmpty,
                      size: 22.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Cash collected from customer',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProofHeading() {
    return Text(
      'Proof of delivery',
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
        height: 1.2,
      ),
    );
  }

  Widget _buildUploadArea() {
    final hasImage = _hasProofPhoto && _proofPhotoBytes != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _selectProofPhoto,
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: _uploadBorder,
            radius: 14,
            strokeWidth: 1.5,
            dashWidth: 6,
            dashGap: 4,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              height: 120.h,
              color: _uploadBg,
              child: hasImage
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(
                          _proofPhotoBytes!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildUploadPlaceholder(),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Change photo',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: _white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildUploadPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              color: _uploadIcon,
              size: 28.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Add pickup photo · required',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return Opacity(
      opacity: _canComplete ? 1 : 0.45,
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: Material(
          color: _confirmGreen,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: _canComplete ? _completeDelivery : null,
            borderRadius: BorderRadius.circular(28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outlined,
                  color: _white,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    'Complete delivery',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: _white,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          next.clamp(0, metric.length),
        );
        canvas.drawPath(extractPath, paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth;
}
