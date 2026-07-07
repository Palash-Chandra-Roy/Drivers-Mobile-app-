import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/features/scheduled_orders/model/scheduled_order_model.dart';
import 'package:yjeek_driver/features/scheduled_orders/service/scheduled_order_service.dart';

class ScheduledOrderProvider extends ChangeNotifier {
  final ScheduledOrderService _service = ScheduledOrderService();

  bool _isLoading = false;
  List<ScheduledOrderModel> _orders = [];
  ScheduledOrderModel? _selectedOrder;
  bool _ageVerified = false;

  bool get isLoading => _isLoading;
  List<ScheduledOrderModel> get orders => _orders;
  ScheduledOrderModel? get selectedOrder => _selectedOrder;
  bool get ageVerified => _ageVerified;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    _orders = await _service.getScheduledOrders();
    _isLoading = false;
    notifyListeners();
  }

  void selectOrder(ScheduledOrderModel order) {
    _selectedOrder = order;
    notifyListeners();
  }

  void confirmAgeVerification() {
    _ageVerified = true;
    notifyListeners();
  }

  void resetAgeVerification() {
    _ageVerified = false;
    notifyListeners();
  }
}
