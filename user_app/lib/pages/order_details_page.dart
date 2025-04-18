import 'package:flutter/material.dart';
import 'package:user_app/services/order_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/order_model.dart';

class OrderDetailsPage extends ConsumerWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetailsState = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: orderDetailsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (order) {
          return _buildOrderDetails(context, order);
        },
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, OrderModel order) {
    final orderDate = order.createdAt.toDate();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(orderDate);
    final products = order.products;
    final totalPrice = order.total;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: ${order.id}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Date: $formattedDate',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
            'Products:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Quantity: ${product.quantity}, Price: \$${product.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Total Price: \$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

final orderDetailsProvider = StateNotifierProvider.family<OrderDetailsNotifier, AsyncValue<OrderModel>, String>((ref, orderId) {
  return OrderDetailsNotifier(ref)..fetchOrderDetails(orderId);
});

class OrderDetailsNotifier extends StateNotifier<AsyncValue<OrderModel>> {
  OrderDetailsNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;

  Future<void> fetchOrderDetails(String orderId) async {
    try {
      final order = await ref.read(orderServiceProvider).getOrderDetails(orderId);
      if (order == null) {
        state = AsyncValue.error('Order not found', StackTrace.current);
      } else {
        state = AsyncValue.data(order);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
