import 'package:flutter/material.dart';
import 'package:shared_modules/shared_services.dart';
import 'package:shared_modules/shared_models.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
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
    // Replace with actual logic to fetch delivery-related orders
    // For example, orders with status 'on_delivery' or assigned to a specific delivery person
    _orders = await _orderService.getAllOrders(); 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Delivery Home'),), body: _orders.isEmpty ? const Center(child: Text('No orders found.')) : ListView.builder(itemCount: _orders.length, itemBuilder: (context, index) {final order = _orders[index]; return ListTile(title: Text('Order ID: ${order.id}'), subtitle: Text('Status: ${order.status}'), // Add more relevant order information as needed onTap: () {// Navigate to order details page if needed},);},),
    );
  }
}