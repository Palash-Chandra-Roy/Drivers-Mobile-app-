class EarningModel {
  const EarningModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.status,
  });

  final String id;
  final double amount;
  final String type;
  final DateTime date;
  final String status;
}
