import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yjeek_driver/features/orders/view/scheduled_delivery_order.dart';
import 'package:yjeek_driver/features/orders/view/scheduled_delivery_shared.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// Local UI-only “Complete delivery” screen for scheduled On Track deliveries.
class ScheduledCompleteDeliveryScreen extends StatefulWidget {
  const ScheduledCompleteDeliveryScreen({
    super.key,
    required this.order,
  });

  final ScheduledDeliveryOrder order;

  @override
  State<ScheduledCompleteDeliveryScreen> createState() =>
      _ScheduledCompleteDeliveryScreenState();
}

class _ScheduledCompleteDeliveryScreenState
    extends State<ScheduledCompleteDeliveryScreen> {
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF6B7B6E);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _iconGreenBg = Color(0xFFE8F5E9);
  static const Color _iconGreen = Color(0xFF2E7D32);
  static const Color _summaryBg = Color(0xFFF5F5F5);
  static const Color _reportOrange = Color(0xFFE67E22);
  static const Color _uploadBg = Color(0xFFF5F5F5);
  static const Color _uploadBorder = Color(0xFFBDBDBD);
  static const Color _uploadIcon = Color(0xFF9E9E9E);
  static const Color _confirmGreen = Color(0xFF4CAF50);

  bool _hasProofPhoto = false;
  Uint8List? _proofPhotoBytes;
  final ImagePicker _imagePicker = ImagePicker();

  ScheduledDeliveryOrder get order => widget.order;

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
    if (!_hasProofPhoto) return;
    Navigator.pushNamed(
      context,
      RouteNames.scheduledDeliveryCompleted,
      arguments: order,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScheduledDeliveryScale.update(MediaQuery.sizeOf(context));
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
          if (!didPop) Navigator.pop(context);
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
                    16.sw,
                    16.sh,
                    16.sw,
                    16.sh + bottomInset,
                  ),
                  children: [
                    _buildHandoverSummary(),
                    SizedBox(height: 18.sh),
                    _buildProofHeading(),
                    SizedBox(height: 10.sh),
                    _buildUploadArea(),
                    SizedBox(height: 20.sh),
                    _buildCompleteButton(),
                    if (!_hasProofPhoto) ...[
                      SizedBox(height: 8.sh),
                      Text(
                        'Add proof photo to complete delivery.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.ssp,
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
          bottomNavigationBar: scheduledBottomNav(context),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: _white,
      padding: EdgeInsets.fromLTRB(4.sw, 8.sh, 16.sw, 12.sh),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _textPrimary,
              size: 20.ssp,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete delivery',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17.ssp,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.sh),
                Text(
                  '${order.customerName} · ${order.orderId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.ssp,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.sh),
            child: Text(
              'Report',
              style: TextStyle(
                fontSize: 13.ssp,
                fontWeight: FontWeight.w700,
                color: _reportOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandoverSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.sw, 14.sh, 14.sw, 14.sh),
      decoration: BoxDecoration(
        color: _summaryBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.sw,
                height: 40.sw,
                decoration: BoxDecoration(
                  color: _iconGreenBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: _iconGreen,
                  size: 22.ssp,
                ),
              ),
              SizedBox(width: 10.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.customerName} · ${order.orderId}',
                      style: TextStyle(
                        fontSize: 14.ssp,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 6.sh),
                    Text(
                      'Handover summary',
                      style: TextStyle(
                        fontSize: 13.ssp,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sh),
          _buildSummaryRow(
            icon: Icons.inventory_2_outlined,
            label: '${order.itemCount} items',
          ),
          SizedBox(height: 8.sh),
          _buildSummaryRow(
            icon: Icons.payments_outlined,
            label: order.paymentSummary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 18.ssp, color: _textMuted),
        SizedBox(width: 8.sw),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.ssp,
              fontWeight: FontWeight.w500,
              color: _textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProofHeading() {
    return Text(
      'Proof of delivery',
      style: TextStyle(
        fontSize: 14.ssp,
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
          painter: ScheduledDashedBorderPainter(
            color: _uploadBorder,
            radius: 14,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              height: 120.sh,
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
                          top: 8.sh,
                          right: 8.sw,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.sw,
                              vertical: 4.sh,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Change photo',
                              style: TextStyle(
                                fontSize: 11.ssp,
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
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_camera_outlined, color: _uploadIcon, size: 28.ssp),
            SizedBox(height: 8.sh),
            Text(
              'Add delivery photo · required',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.ssp,
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
      opacity: _hasProofPhoto ? 1 : 0.45,
      child: SizedBox(
        width: double.infinity,
        height: 52.sh,
        child: Material(
          color: _confirmGreen,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: _hasProofPhoto ? _completeDelivery : null,
            borderRadius: BorderRadius.circular(28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outlined, color: _white, size: 20.ssp),
                SizedBox(width: 8.sw),
                Flexible(
                  child: Text(
                    'Complete delivery',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.ssp,
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
