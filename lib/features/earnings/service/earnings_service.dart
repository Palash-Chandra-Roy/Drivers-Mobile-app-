import 'package:yjeek_driver/features/earnings/model/earning_model.dart';

class EarningsService {
  Future<List<EarningModel>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return [
      EarningModel(
        id: 'TXN-001',
        amount: 12.50,
        type: 'Delivery',
        date: now.subtract(const Duration(hours: 2)),
        status: 'Completed',
      ),
      EarningModel(
        id: 'TXN-002',
        amount: 9.75,
        type: 'Delivery',
        date: now.subtract(const Duration(hours: 5)),
        status: 'Completed',
      ),
      EarningModel(
        id: 'TXN-003',
        amount: 125.00,
        type: 'Payout',
        date: now.subtract(const Duration(days: 2)),
        status: 'Paid',
      ),
      EarningModel(
        id: 'TXN-004',
        amount: 18.00,
        type: 'Delivery',
        date: now.subtract(const Duration(days: 3)),
        status: 'Completed',
      ),
    ];
  }

  Future<Map<String, double>> getEarningsSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'totalBalance': 342.50,
      'today': 45.25,
      'weekly': 198.75,
      'monthly': 1245.00,
    };
  }
}
