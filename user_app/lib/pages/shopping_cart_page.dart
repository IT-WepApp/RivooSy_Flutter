import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_app/services/cart_service.dart';
import 'package:user_app/models/cart_item_model.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:shared_widgets/app_button.dart';
import 'package:shared_widgets/app_card.dart';
import 'package:user_app/utils/user_constants.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  late Future<List<CartItem>> _cartItemsFuture;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchCartItems();
  }

  Future<List<CartItem>> _fetchCartItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return _cartService.getCartItems(userId);
    } else {
      return [];
    }
  }

  double _calculateTotalPrice(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UserConstants.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: \${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final cartItems = snapshot.data!;
            final totalPrice = _calculateTotalPrice(cartItems);
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(item);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$\${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton(
                    text: 'Checkout',
                    onPressed: () => _checkout(cartItems, totalPrice),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Your cart is empty.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return AppCard(
      child: ListTile(
          title: Text(item.name),
          subtitle: Text('Quantity: ${item.quantity}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => _updateQuantity(item, item.quantity - 1),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _updateQuantity(item, item.quantity + 1),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeItem(item),
              ),
            ],
          ),
        ),
    );
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please log in.'),
      ));
      return;
    }

    if (newQuantity > 0) {
      try {
        await _cartService.updateCartItemQuantity(
            userId, item.productId, newQuantity);
        setState(() {
          _cartItemsFuture = _fetchCartItems();
        });
      } catch (e) {
        debugPrint('Error updating quantity: $e');
      }
    }else {
      try {
        await _cartService.removeCartItem(userId, item.productId);
        setState(() {
          _cartItemsFuture = _fetchCartItems();
        });
      } catch (e) {
        debugPrint('Error removing item: $e');
      }
    }
  }

  Future<void> _removeItem(CartItem item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please log in.'),
      ));
      return;
    }

    try {
      await _cartService.removeCartItem(userId, item.productId);
      setState(() {
        _cartItemsFuture = _fetchCartItems();
      });
    } catch (e) {
      debugPrint('Error removing item: $e');
    }
  }

  Future<void> _checkout(List<CartItem> cartItems, double totalPrice) async {
    Navigator.pushNamed(
      context,
      '/order-confirmation',
      arguments: {
        'cartItems': cartItems,
        'totalPrice': totalPrice,
      },
    );
  }
}