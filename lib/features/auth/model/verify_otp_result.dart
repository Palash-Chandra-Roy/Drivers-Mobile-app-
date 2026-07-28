class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.phone,
    required this.countryCode,
    required this.role,
    required this.status,
    this.email,
    this.phoneVerifiedAt,
    this.createdAt,
    this.driverProfile,
  });

  final String id;
  final String phone;
  final String countryCode;
  final String role;
  final String status;
  final String? email;
  final String? phoneVerifiedAt;
  final String? createdAt;
  final DriverProfileModel? driverProfile;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['driverProfile'];
    return AuthUserModel(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '',
      email: json['email']?.toString(),
      role: json['role']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      phoneVerifiedAt: json['phoneVerifiedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      driverProfile: profile is Map
          ? DriverProfileModel.fromJson(Map<String, dynamic>.from(profile))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'countryCode': countryCode,
      'email': email,
      'role': role,
      'status': status,
      'phoneVerifiedAt': phoneVerifiedAt,
      'createdAt': createdAt,
      'driverProfile': driverProfile?.toJson(),
    };
  }

  String get displayName {
    final profile = driverProfile;
    if (profile == null) return phone;
    final name = '${profile.firstName} ${profile.lastName}'.trim();
    return name.isEmpty ? phone : name;
  }
}

class DriverProfileModel {
  const DriverProfileModel({
    required this.id,
    required this.champId,
    required this.firstName,
    required this.lastName,
    required this.accountStatus,
    required this.status,
    this.avatarUrl,
    this.averageRating = 0,
    this.walletBalance = '0',
  });

  final String id;
  final String champId;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String accountStatus;
  final String status;
  final double averageRating;
  final String walletBalance;

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    final wallet = json['wallet'];
    final ratingRaw = json['averageRating'];
    final rating = ratingRaw is num
        ? ratingRaw.toDouble()
        : double.tryParse(ratingRaw?.toString() ?? '') ?? 0;

    return DriverProfileModel(
      id: json['id']?.toString() ?? '',
      champId: json['champId']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      accountStatus: json['accountStatus']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      averageRating: rating,
      walletBalance: wallet is Map
          ? (wallet['balance']?.toString() ?? '0')
          : '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'champId': champId,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'accountStatus': accountStatus,
      'status': status,
      'averageRating': averageRating.toString(),
      'wallet': {'balance': walletBalance},
    };
  }
}

class VerifyOtpResult {
  const VerifyOtpResult({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUserModel user;

  factory VerifyOtpResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) {
      throw const FormatException('Invalid verify-otp response');
    }

    final map = Map<String, dynamic>.from(data);
    final accessToken = map['accessToken']?.toString() ?? '';
    final refreshToken = map['refreshToken']?.toString() ?? '';
    final userRaw = map['user'];

    if (accessToken.isEmpty || refreshToken.isEmpty || userRaw is! Map) {
      throw const FormatException('Invalid verify-otp response');
    }

    return VerifyOtpResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: AuthUserModel.fromJson(Map<String, dynamic>.from(userRaw)),
    );
  }
}
