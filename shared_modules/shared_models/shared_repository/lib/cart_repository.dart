import 'package:shared_models/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems(String userId);
  Future<void> addToCart(String userId, CartItem cartItem);
  Future<void> updateCartItemQuantity(String userId, String productId, int quantity);
  Future<void> removeFromCart(String userId, String productId);
}
