import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/lib/models/cart_item_model.dart'; // Assuming this model exists

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches the cart items for a given user from the 'users/{userId}/cart' subcollection.
  /// Returns a List<CartItem>.
  Future<List<CartItem>> getCartItems(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return CartItem(
          productId: data['productId'] ?? '',
          name: data['name'] ?? '',
          quantity: data['quantity'] ?? 0,
          price: (data['price'] ?? 0.0).toDouble(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching cart items: $e');
      return []; // Return an empty list in case of error
    }
  }

  /// Adds a CartItem to the user's cart.
  Future<void> addToCart(String userId, CartItem cartItem) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItem.productId)
          .set({
        'productId': cartItem.productId,
        'name': cartItem.name,
        'quantity': cartItem.quantity,
        'price': cartItem.price,
      });
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  /// Updates the quantity of a CartItem in the user's cart.
  Future<void> updateCartItem(String userId, CartItem cartItem) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItem.productId)
          .update({
        'quantity': cartItem.quantity,
      });
    } catch (e) {
      print('Error updating cart item: $e');
    }
  }

  /// Removes a CartItem from the user's cart.
  Future<void> removeFromCart(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }
}