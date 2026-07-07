import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/features/orders/model/order_model.dart';
import 'package:yjeek_driver/features/orders/service/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool _isLoading = false;
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  OrderModel? _newRequest;
  String _filter = 'Active';
  int _deliveryStep = 0;

  static const List<String> deliverySteps = [
    'Go to pickup',
    'Picked up',
    'Go to drop-off',
    'Delivered',
  ];

  bool get isLoading => _isLoading;
  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  OrderModel? get newRequest => _newRequest;
  String get filter => _filter;
  int get deliveryStep => _deliveryStep;
  String get currentStepLabel => deliverySteps[_deliveryStep.clamp(0, deliverySteps.length - 1)];

  List<OrderModel> get filteredOrders {
    if (_filter == 'All') return _orders;
    return _orders.where((o) => o.status.toLowerCase() == _filter.toLowerCase()).toList();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    _orders = await _orderService.getOrders();
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> loadNewRequest() async {
    _isLoading = true;
    notifyListeners();
    _newRequest = await _orderService.getNewRequest();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadOrderById(String id) async {
    _isLoading = true;
    notifyListeners();
    _currentOrder = await _orderService.getOrderById(id);
    _isLoading = false;
    notifyListeners();
  }

  void acceptOrder() {
    if (_newRequest != null) {
      _currentOrder = _newRequest!.copyWith(status: 'Accepted');
      _deliveryStep = 0;
      notifyListeners();
    }
  }

  void rejectOrder() {
    _newRequest = null;
    notifyListeners();
  }

  void advanceDeliveryStep() {
    if (_deliveryStep < deliverySteps.length - 1) {
      _deliveryStep++;
      notifyListeners();
    }
  }

  void resetDelivery() {
    _deliveryStep = 0;
    _currentOrder = null;
    _newRequest = null;
    notifyListeners();
  }
}
