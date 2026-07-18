import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_assets.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// D4 · Documents
class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DocHeader(title: 'Documents'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    _buildProgressCard(),
                    const SizedBox(height: 14),
                    _DocumentRow(
                      iconAsset: AppAssets.docCpr,
                      title: 'CPR / National ID',
                      helper: 'Front & back uploaded',
                      status: _DocStatus.done,
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.uploadCpr),
                    ),
                    const SizedBox(height: 14),
                    _DocumentRow(
                      iconAsset: AppAssets.docPassport,
                      title: 'Passport',
                      helper: 'Photo page · number · expiry',
                      status: _DocStatus.required_,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.uploadPassport),
                    ),
                    const SizedBox(height: 14),
                    _DocumentRow(
                      iconAsset: AppAssets.docVisa,
                      title: 'Visa',
                      helper: 'Number · expiry date',
                      status: _DocStatus.required_,
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.uploadVisa),
                    ),
                    const SizedBox(height: 14),
                    _DocumentRow(
                      iconAsset: AppAssets.docDrivingLicense,
                      title: 'Driving license',
                      helper: 'Valid until 2028',
                      status: _DocStatus.underReview,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.uploadDrivingLicense),
                    ),
                    const SizedBox(height: 14),
                    _DocumentRow(
                      iconAsset: AppAssets.docVehicle,
                      title: 'Vehicle registration',
                      helper: 'Card · details · photos · insurance',
                      status: _DocStatus.done,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.uploadVehicleRegistration),
                    ),
                    const SizedBox(height: 14),
                    _DocumentRow(
                      iconAsset: AppAssets.docProfilePhoto,
                      title: 'Profile photo',
                      helper: 'Clear face photo',
                      status: _DocStatus.done,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.uploadProfilePhoto),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: DocPrimaryButton(
                label: 'Submit for review',
                onPressed: () {
                  showDocSnack(context, 'Documents submitted for review');
                  Navigator.maybePop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DocColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DocColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '4 of 7 completed',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: DocColors.textPrimary,
                ),
              ),
              Text(
                'Almost there',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: DocColors.greenDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 4 / 7,
              minHeight: 8,
              backgroundColor: DocColors.doneBg,
              valueColor: AlwaysStoppedAnimation<Color>(DocColors.green),
            ),
          ),
        ],
      ),
    );
  }
}

enum _DocStatus { done, required_, underReview }

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({
    required this.title,
    required this.helper,
    required this.status,
    required this.onTap,
    required this.iconAsset,
  });

  final String iconAsset;
  final String title;
  final String helper;
  final _DocStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DocColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: DocColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DocColors.doneBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(iconAsset, width: 22, height: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: DocColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      helper,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: DocColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(),
              const SizedBox(width: 6),
              const Text(
                '›',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF99A199),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge() {
    final (String label, Color bg, Color fg) = switch (status) {
      _DocStatus.done => ('Done', DocColors.doneBg, DocColors.greenDark),
      _DocStatus.required_ =>
        ('Required', DocColors.warnBg, DocColors.warnText),
      _DocStatus.underReview =>
        ('Under review', DocColors.reviewBg, DocColors.reviewText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == _DocStatus.done) ...[
            Icon(Icons.check, size: 11, color: fg),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
