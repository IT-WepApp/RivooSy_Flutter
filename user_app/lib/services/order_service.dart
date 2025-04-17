import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_models/order_model.dart'; 
import 'package:user_app/models/cart_item_model.dart'; // Assuming this model exists

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Places a new order for the user.
  Future<void> placeOrder(String userId, List<CartItem> cartItems, double totalPrice) async {
    try {
      await _firestore.collection('orders').add({
        'userId': userId,
        'orderDate': Timestamp.now(),
        'products': cartItems.map((item) => {
              'productId': item.productId,
              'name': item.name,
              'quantity': item.quantity,
              'price': item.price,
            }).toList(),
        'totalPrice': totalPrice,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error placing order: $e');
    }
  }

  /// Fetches orders for a specific user.
  Future<List<OrderModel>> getOrdersForUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) => OrderModel.fromJson({
            'id': doc.id,
            ...doc.data(),
          })).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching orders for user: $e');
      return [];
    }
  }

  /// Fetches a specific order's details.
  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      final docSnapshot = await _firestore.collection('orders').doc(orderId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        data['id'] = docSnapshot.id; // include order ID in the data
        return OrderModel.fromJson(data);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching order details: $e');
    }
    return null;
  }
}