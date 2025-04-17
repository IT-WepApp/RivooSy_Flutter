import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_modules/shared_models.dart';
import 'package:user_app/models/cart_item_model.dart'; // Assuming this model exists

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Places a new order for the user.
  Future<void> placeOrder(String userId, List<CartItem> cartItems) async {
    try {
      final totalPrice = cartItems.fold<double>(
          0.0, (sum, item) => sum + (item.price * item.quantity));

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
            ...doc.data() as Map<String, dynamic>,
          })).toList();
    } catch (e) {
      print('Error fetching orders for user: $e');
      return [];
    }
  }

  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      final docSnapshot =
          await _firestore.collection('orders').doc(orderId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        // Include the document ID as 'orderId'
        return {
          'orderId': docSnapshot.id,
          'userId': data['userId'] as String? ?? '',
          'orderDate': data['orderDate'] as Timestamp? ?? Timestamp.now(),
          'products': data['products'] as List<Map<String, dynamic>>? ?? [],
          'totalPrice': (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
        });
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
    return null;
  }
}

}