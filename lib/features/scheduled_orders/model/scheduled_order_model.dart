class ScheduledOrderModel {
  const ScheduledOrderModel({
    required this.id,
    required this.title,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.scheduledDate,
    required this.status,
    this.isRestricted = false,
    this.customerName,
    this.price = 0.0,
  });

  final String id;
  final String title;
  final String pickupAddress;
  final String dropoffAddress;
  final DateTime scheduledDate;
  final String status;
  final bool isRestricted;
  final String? customerName;
  final double price;
}
