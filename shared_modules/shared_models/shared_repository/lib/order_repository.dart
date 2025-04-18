import 'package:shared_models/order_model.dart';
import 'package:shared_models/cart_item_model.dart';

abstract class OrderRepository {
  Future<void> placeOrder(String userId, List<CartItem> cartItems, double totalPrice);
  Future<List<OrderModel>> getOrdersForUser(String userId);
  Future<OrderModel?> getOrderDetails(String orderId);
}
