import 'package:yjeek_driver/features/scheduled_orders/model/scheduled_order_model.dart';

class ScheduledOrderService {
  Future<List<ScheduledOrderModel>> getScheduledOrders() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      ScheduledOrderModel(
        id: '#SCH-301',
        title: 'Grocery Delivery',
        pickupAddress: 'Fresh Mart, 78 Market Road',
        dropoffAddress: '99 Pine Street',
        scheduledDate: DateTime.now().add(const Duration(hours: 2)),
        status: 'Scheduled',
        customerName: 'Mike Johnson',
        price: 18.00,
      ),
      ScheduledOrderModel(
        id: '#SCH-302',
        title: 'Wine Delivery (18+)',
        pickupAddress: 'Wine & Spirits, 10 Valley Road',
        dropoffAddress: '33 Hill View',
        scheduledDate: DateTime.now().add(const Duration(hours: 5)),
        status: 'Scheduled',
        isRestricted: true,
        customerName: 'Tom Wilson',
        price: 22.00,
      ),
    ];
  }
}
