class OtpScreenArgs {
  const OtpScreenArgs({
    required this.phone,
    required this.countryCode,
    required this.expiresInSeconds,
    this.debugDevCode,
  });

  final String phone;
  final String countryCode;
  final int expiresInSeconds;

  /// Debug-only OTP from API `devCode`. Never set/shown in release.
  final String? debugDevCode;

  String get phoneDisplay {
    final digits = phone.replaceAll(RegExp(r'\s'), '');
    if (digits.length == 8) {
      return '$countryCode ${digits.substring(0, 4)} ${digits.substring(4)}';
    }
    return '$countryCode $phone';
  }
}
