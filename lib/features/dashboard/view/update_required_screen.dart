import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  static const Color _textDark = Color(0xFF1E1E1E);
  static const Color _subtitleColor = Color(0xFF8A958A);
  static const Color _headerGreen = Color(0xFF2E7D32);
  static const Color _buttonGreen = Color(0xFF4CAF50);
  static const Color _requiredGreen = Color(0xFF2E7D32);
  static const Color _cardBorder = Color(0xFFE0E5E0);
  static const Color _iconPillBg = Color(0xFFE8F5E9);
  static const Color _iconPillBorder = Color(0xFFC8E6C9);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _headerGreen,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: _headerGreen,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update required',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Before you go online',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFC8E6C9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _iconPillBg,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: _iconPillBorder),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/icon-arrow-up-lines.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                          color: _headerGreen,
                          colorBlendMode: BlendMode.srcIn,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.system_update_alt_rounded,
                            size: 28,
                            color: _headerGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'A mandatory update is required before you can go online.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: _subtitleColor,
                          height: 1.45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Installed',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _subtitleColor,
                                  ),
                                ),
                                Text(
                                  'v3.1.0',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: _textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Required',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _subtitleColor,
                                  ),
                                ),
                                Text(
                                  'v3.2.0',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: _requiredGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening store to update…'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _buttonGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Update now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
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
      ),
    );
  }
}
