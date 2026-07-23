class SendOtpResult {
  const SendOtpResult({
    required this.message,
    required this.phone,
    required this.expiresInSeconds,
    this.devCode,
  });

  final String message;
  final String phone;
  final int expiresInSeconds;

  /// Present only in development API responses. Never display or log in release.
  final String? devCode;

  factory SendOtpResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) {
      throw const FormatException('Invalid send-otp response');
    }

    final map = Map<String, dynamic>.from(data);
    final expires = map['expiresInSeconds'];
    final expiresInSeconds = expires is int
        ? expires
        : int.tryParse(expires?.toString() ?? '') ?? 300;

    return SendOtpResult(
      message: map['message']?.toString() ?? 'Verification code sent',
      phone: map['phone']?.toString() ?? '',
      expiresInSeconds: expiresInSeconds,
      devCode: map['devCode']?.toString(),
    );
  }
}
