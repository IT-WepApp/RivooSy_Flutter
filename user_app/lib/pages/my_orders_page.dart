import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_app/services/order_service.dart';
import 'package:shared_models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(myOrdersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ordersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (orders) {
          if (orders.isNotEmpty) {
            return _buildOrderList(context, orders);
          } else {
            return const Center(child: Text('You have no orders yet.'));
          }
        },
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<OrderModel> orders) {
    return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final orderDate = order.createdAt.toDate();
                final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(orderDate);
                final totalPrice = order.total;

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/order-details',
                      arguments: order.id,
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Order Date: $formattedDate'),
                      subtitle: Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                    ),
                  ),
                );
              },
            );  
}
}

final myOrdersProvider = StateNotifierProvider<MyOrdersNotifier,
    AsyncValue<List<OrderModel>>>((ref) {
  return MyOrdersNotifier(ref);
});

class MyOrdersNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  MyOrdersNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchOrders();
  }
  final Ref ref;

  Future<void> fetchOrders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      final orders = await ref.read(orderServiceProvider).getOrdersForUser(userId);
      state = AsyncValue.data(orders);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
