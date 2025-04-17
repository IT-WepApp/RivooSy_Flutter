import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_models/shared_models.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final orders = await _orderService.getAllOrders();
    if (!mounted) return;
    setState(() => _orders = orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Home')),
      body: _orders.isEmpty
          ? const Center(child: Text('No orders found.'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return ListTile(
                  title: Text('Order ID: ${order.id}'),
                  subtitle: Text('Status: ${order.status}'),
                  onTap: () {
                    // Navigate to order details page if needed
                  },
                );
              },
            ),
    );
  }
}
