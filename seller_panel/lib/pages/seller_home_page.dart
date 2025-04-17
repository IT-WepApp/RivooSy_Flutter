import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // or import 'package:shared_services/order_service.dart'; if you only need OrderService
import 'package:shared_models/shared_models.dart'; 

import 'package:shared_widgets/shared_widgets.dart'; // Assuming SharedButton is in shared_widgets

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({super.key});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      // Assuming you have a way to identify the seller (e.g., from logged-in user)
      const sellerId = 'some_seller_id'; // Replace with actual seller ID
      _orders = await _orderService.getOrdersBySeller(sellerId);
    } catch (e) {
      // Handle error appropriately, e.g., show a snackbar
      print('Error fetching orders: $e');
      // For now, setting to an empty list in case of error
      _orders = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('لوحة تاجر'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _orders.isEmpty
                ? const Center(child: Text('لا توجد طلبات'))
                : ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Order #${order.id}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('User ID: ${order.userId}'),
                              Text('Total: \$${order.total.toStringAsFixed(2)}'),
                              Text('Status: ${order.status}'),
                            ],
                          ),
                          // Add more details or actions as needed
                        ),
                      );
                    },
                  ));
  }
}
