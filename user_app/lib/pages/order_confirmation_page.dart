import 'package:flutter/material.dart';
import 'package:shared_models/cart_item_model.dart'; // Import CartItem
import 'package:user_app/services/order_service.dart'; // Import OrderService
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderConfirmationPage extends ConsumerStatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const OrderConfirmationPage({super.key, required this.cartItems, required this.totalPrice});

  @override
  ConsumerState<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends ConsumerState<OrderConfirmationPage> {

  @override
  Widget build(BuildContext context) {
    final orderPlacementState = ref.watch(orderPlacementProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order'),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : _buildOrderSummary(context, orderPlacementState),
    );
  }

  Widget _buildOrderSummary(BuildContext context, AsyncValue<void> orderPlacementState) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              final item = widget.cartItems[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('Quantity: ${item.quantity}, Price: \$${item.price.toStringAsFixed(2)}'),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total: \$${widget.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildOrderButton(context, ref, orderPlacementState),
      ],
    );
  }

  Widget _buildOrderButton(BuildContext context, WidgetRef ref, AsyncValue<void> state) {
    return state.when(
      data: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));
          Navigator.pushReplacementNamed(context, '/my-orders');
          ref.read(orderPlacementProvider.notifier).reset(); // Reset the state
        });
        return const SizedBox.shrink(); // Return an empty widget as the UI has been updated
      },
      error: (error, _) => ElevatedButton(
        onPressed: () => ref.read(orderPlacementProvider.notifier).placeOrder(widget.cartItems, widget.totalPrice),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, textStyle: const TextStyle(fontSize: 16)),
        child: const Text('Confirm Order', style: TextStyle(color: Colors.white)),
      ),
      loading: () => ElevatedButton(
        onPressed: null, // Disable the button while loading
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, textStyle: const TextStyle(fontSize: 16)),
        child: const Text('Placing Order...', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class OrderPlacementNotifier extends StateNotifier<AsyncValue<void>> {
  OrderPlacementNotifier(this.ref) : super(const AsyncValue.data(null));
  Future<void> placeOrder(List<CartItem> cartItems, double totalPrice) async {
      state = const AsyncValue.loading();
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        state = AsyncValue.error("You must be logged in to place an order.", StackTrace.current);
        return;
      }
      await ref.read(orderServiceProvider).placeOrder(userId, cartItems, totalPrice);
      state = const AsyncValue.data(null);
  }
    final Ref ref;  void reset() {
    state = const AsyncValue.data(null);
  }
}

final orderPlacementProvider = StateNotifierProvider<OrderPlacementNotifier, AsyncValue<void>>((ref) => OrderPlacementNotifier(ref));