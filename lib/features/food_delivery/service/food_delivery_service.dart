import 'package:yjeek_driver/features/food_delivery/model/food_delivery_model.dart';

class FoodDeliveryService {
  Future<FoodDeliveryModel> getCurrentDelivery() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const FoodDeliveryModel(
      id: '#FD-2001',
      restaurantName: 'Burger Palace',
      customerName: 'Sarah Ahmed',
      pickupAddress: 'Burger Palace, 45 Food Street',
      dropoffAddress: '12 Oak Avenue, Apt 3B',
      items: ['Classic Burger x1', 'Fries x1', 'Coke x1'],
      deliveryFee: 12.50,
      status: 'Accepted',
      pickupInstructions: 'Ask for order at counter. Show order ID.',
      deliveryInstructions: 'Leave at door if no answer. Ring bell.',
    );
  }
}
