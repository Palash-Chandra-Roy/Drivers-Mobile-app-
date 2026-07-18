import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yjeek_driver/core/constants/app_assets.dart';

/// Shared design tokens for the Earnings / Account / Documents screens.
class DocColors {
  DocColors._();

  static const Color screenBg = Color(0xFFF2F6F0);
  static const Color accountBg = Color(0xFFF2F7F2);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7B6E);
  static const Color textMuted = Color(0xFF737875);
  static const Color textField = Color(0xFF1F2121);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8DD);
  static const Color fieldBorder = Color(0xFFDEE3DE);
  static const Color dashedBorder = Color(0xFFC7CFC7);
  static const Color green = Color(0xFF4CAF50);
  static const Color greenDark = Color(0xFF2E7D32);
  static const Color greenDeep = Color(0xFF0F4D27);
  static const Color doneBg = Color(0xFFEAF3DE);
  static const Color warnBg = Color(0xFFFBEFE0);
  static const Color warnText = Color(0xFFE08A1E);
  static const Color reviewBg = Color(0xFFFFF2DB);
  static const Color reviewText = Color(0xFF996B0D);
  static const Color infoBg = Color(0xFFFCF0D4);
  static const Color infoText = Color(0xFF996B0D);
  static const Color gold = Color(0xFFC9A84C);
  static const Color tierBg = Color(0xFFF7F0DC);
  static const Color tierText = Color(0xFF8A6A12);
  static const Color pillGreen = Color(0xFF4DB04F);
  static const Color bannerGreen = Color(0xFFDBF0E0);
  static const Color bannerGreenText = Color(0xFF0F4D26);
  static const Color accountBorder = Color(0xFFDBE3DB);
}

/// Screen header with a white circular back button and bold title.
class DocHeader extends StatelessWidget {
  const DocHeader({super.key, required this.title, this.showBack = true});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      child: Row(
        children: [
          if (showBack) ...[
            Material(
              color: DocColors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.maybePop(context),
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: DocColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: DocColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Uppercase field label + bordered text field.
class DocTextField extends StatelessWidget {
  const DocTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: DocColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 46,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: DocColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DocColors.fieldBorder),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: DocColors.textField,
            ),
            cursorColor: DocColors.green,
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: DocColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Document upload box. Empty state: white dashed box with camera circle.
/// Uploaded state: pale green box with check circle + "Tap to replace".
class DocUploadBox extends StatelessWidget {
  const DocUploadBox({
    super.key,
    required this.title,
    required this.uploaded,
    required this.onTap,
    this.helper = 'Tap to capture or upload',
    this.height = 128,
    this.photoBytes,
  });

  final String title;
  final String helper;
  final bool uploaded;
  final double height;
  final Uint8List? photoBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (uploaded) {
      return Material(
        color: DocColors.doneBg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: DocColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  '$title · uploaded',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DocColors.greenDark,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Tap to replace',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: DocColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: DocColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: const DocDashedBorderPainter(),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: DocColors.doneBg,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    AppAssets.uploadCamera,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DocColors.textField,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  helper,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: DocColors.textMuted,
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

class DocDashedBorderPainter extends CustomPainter {
  const DocDashedBorderPainter({
    this.color = DocColors.dashedBorder,
    this.radius = 14,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    const dashWidth = 6.0;
    const dashGap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DocDashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

/// Pale-green tip banner with a bulb emoji.
class DocTipBanner extends StatelessWidget {
  const DocTipBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: DocColors.doneBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                height: 14 / 11.5,
                color: DocColors.greenDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width green save/submit button (radius 13).
class DocPrimaryButton extends StatelessWidget {
  const DocPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = DocColors.green,
    this.radius = 13,
    this.height = 50,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double radius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
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

/// Section header used inside long forms (e.g. Vehicle registration).
class DocSectionHeader extends StatelessWidget {
  const DocSectionHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: DocColors.textField,
      ),
    );
  }
}

Future<Uint8List?> pickDocPhoto(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: DocColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );

  if (source == null) return null;

  try {
    final picked =
        await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (picked == null) return null;
    return picked.readAsBytes();
  } on PlatformException {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to access photos. Please try again.')),
      );
    }
    return null;
  }
}

void showDocSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
