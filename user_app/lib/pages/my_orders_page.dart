import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:user_app/services/order_service.dart';
import 'package:shared_models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_widgets/app_card.dart';
import 'package:user_app/utils/user_constants.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final OrderService _orderService = OrderService();
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<OrderModel>> _fetchOrders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return _orderService.getOrdersForUser(userId);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UserConstants.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data;
          if (orders != null && orders.isNotEmpty) {
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
                  child: AppCard(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Order Date: $formattedDate'),
                      subtitle: Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                    ),
                  )
                );
              },
            );
          }
          return const Center(child: Text('You have no orders yet.'));
        },
      ),
    );
  }
}
