class DriverModel {
  const DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.vehicleType,
    this.plateNumber,
    this.rating = 0.0,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? vehicleType;
  final String? plateNumber;
  final double rating;
  final bool isOnline;

  DriverModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? vehicleType,
    String? plateNumber,
    double? rating,
    bool? isOnline,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      vehicleType: vehicleType ?? this.vehicleType,
      plateNumber: plateNumber ?? this.plateNumber,
      rating: rating ?? this.rating,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
