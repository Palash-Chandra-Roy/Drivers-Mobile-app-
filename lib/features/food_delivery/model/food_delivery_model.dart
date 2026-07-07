class FoodDeliveryModel {
  const FoodDeliveryModel({
    required this.id,
    required this.restaurantName,
    required this.customerName,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.items,
    required this.deliveryFee,
    required this.status,
    this.pickupInstructions,
    this.deliveryInstructions,
  });

  final String id;
  final String restaurantName;
  final String customerName;
  final String pickupAddress;
  final String dropoffAddress;
  final List<String> items;
  final double deliveryFee;
  final String status;
  final String? pickupInstructions;
  final String? deliveryInstructions;

  FoodDeliveryModel copyWith({String? status}) {
    return FoodDeliveryModel(
      id: id,
      restaurantName: restaurantName,
      customerName: customerName,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      items: items,
      deliveryFee: deliveryFee,
      status: status ?? this.status,
      pickupInstructions: pickupInstructions,
      deliveryInstructions: deliveryInstructions,
    );
  }
}
