import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/features/food_delivery/model/food_delivery_model.dart';
import 'package:yjeek_driver/features/food_delivery/service/food_delivery_service.dart';

class FoodDeliveryProvider extends ChangeNotifier {
  final FoodDeliveryService _service = FoodDeliveryService();

  bool _isLoading = false;
  FoodDeliveryModel? _delivery;

  bool get isLoading => _isLoading;
  FoodDeliveryModel? get delivery => _delivery;

  Future<void> loadDelivery() async {
    _isLoading = true;
    notifyListeners();
    _delivery = await _service.getCurrentDelivery();
    _isLoading = false;
    notifyListeners();
  }

  void confirmPickup() {
    if (_delivery != null) {
      _delivery = _delivery!.copyWith(status: 'Picked Up');
      notifyListeners();
    }
  }

  void confirmDelivery() {
    if (_delivery != null) {
      _delivery = _delivery!.copyWith(status: 'Delivered');
      notifyListeners();
    }
  }
}
