import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<List<Map<String, dynamic>>> getOrdersForUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Include the document ID as 'orderId'
        return {
          'orderId': doc.id,
          'userId': data['userId'] as String? ?? '',
          'orderDate': data['orderDate'] as Timestamp? ?? Timestamp.now(),
          'products': data['products'] as List<dynamic>? ?? [],
          'totalPrice': (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
        };
      }).toList();
    } catch (e) {
      print('Error fetching orders for user: $e');
      return [];
    }
  }

  /// Fetches details for a specific order.
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final docSnapshot = await _firestore.collection('orders').doc(orderId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        // Include the document ID as 'orderId'
        return {
          'orderId': docSnapshot.id,
          'userId': data['userId'] as String? ?? '',
          'orderDate': data['orderDate'] as Timestamp? ?? Timestamp.now(),
          'products': data['products'] as List<dynamic>? ?? [],
          'totalPrice': (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
        };
      } else {
        print('Order with ID: $orderId not found.');
        return {}; // Return an empty map if not found
      }
    } catch (e) {
      print('Error fetching order details: $e');
      return {}; // Return an empty map in case of error
    }
  }




}