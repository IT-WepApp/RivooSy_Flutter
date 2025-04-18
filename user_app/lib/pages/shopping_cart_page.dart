// shopping_cart_page.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/cart_item_model.dart';
import 'package:user_app/services/cart_service.dart';

/// Provider for the CartService
final cartServiceProvider = Provider<CartService>((ref) => CartService());

/// StateNotifierProvider for the shopping cart
final shoppingCartProvider =
    StateNotifierProvider<ShoppingCartNotifier, AsyncValue<List<CartItem>>>(
  (ref) => ShoppingCartNotifier(ref),
);

class ShoppingCartNotifier extends StateNotifier<AsyncValue<List<CartItem>>> {
  ShoppingCartNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchCartItems();
  }

  final Ref ref;

  Future<void> fetchCartItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      final items = await ref.read(cartServiceProvider).getCartItems(userId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      developer.log(
        'Error fetching cart items',
        error: e,
        stackTrace: st,
        name: 'ShoppingCartNotifier',
      );
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateQuantity(CartItem item, int newQuantity) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      if (newQuantity > 0) {
        await ref
            .read(cartServiceProvider)
            .updateCartItemQuantity(userId, item.productId, newQuantity);
      } else {
        await ref.read(cartServiceProvider).removeFromCart(userId, item.productId);
      }
      await fetchCartItems();
    } catch (e, st) {
      developer.log(
        'Error updating quantity',
        error: e,
        stackTrace: st,
        name: 'ShoppingCartNotifier',
      );
    }
  }

  Future<void> removeItem(CartItem item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      await ref.read(cartServiceProvider).removeFromCart(userId, item.productId);
      await fetchCartItems();
    } catch (e, st) {
      developer.log(
        'Error removing item',
        error: e,
        stackTrace: st,
        name: 'ShoppingCartNotifier',
      );
    }
  }
}

class ShoppingCartPage extends ConsumerWidget {
  const ShoppingCartPage({super.key});

  double _calculateTotalPrice(List<CartItem> items) =>
      items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(shoppingCartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: cartState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }
          final total = _calculateTotalPrice(items);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => _buildCartItem(ctx, ref, items[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => _checkout(context, items, total),
                  child: const Text('Checkout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, WidgetRef ref, CartItem item) {
    final notifier = ref.read(shoppingCartProvider.notifier);
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('Quantity: ${item.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => notifier.updateQuantity(item, item.quantity - 1),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => notifier.updateQuantity(item, item.quantity + 1),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => notifier.removeItem(item),
            ),
          ],
        ),
      ),
    );
  }

  void _checkout(
    BuildContext context,
    List<CartItem> items,
    double totalPrice,
  ) {
    Navigator.pushNamed(
      context,
      '/order-confirmation',
      arguments: {
        'cartItems': items,
        'totalPrice': totalPrice,
      },
    );
  }
}
