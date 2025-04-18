import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_widgets/utils/error_handling.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://68027bdb0a99cb7408e9bb97.mockapi.io/api/v1/orders'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _orders = jsonDecode(response.body);
          });
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, 'Failed to load orders. Please try again later.');
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        logError('An error occurred while loading orders', error: e, stackTrace: stackTrace);
        showErrorSnackBar(
          context,
          e is http.ClientException
              ? 'Failed to connect to the server. Please check your internet connection and try again.'
              : 'An unexpected error occurred. Please try again later.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse('https://68027bdb0a99cb7408e9bb97.mockapi.io/api/v1/orders/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          await _loadOrders();
          if (!mounted) return;
          showErrorSnackBar(context, 'Order status updated', color: Colors.green);
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, 'Failed to update order status. Please try again later.');
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        logError('An error occurred while updating order status', error: e, stackTrace: stackTrace);
        showErrorSnackBar(
          context,
          e is http.ClientException
              ? 'Failed to connect to the server. Please check your internet connection and try again.'
              : 'An unexpected error occurred. Please try again later.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: ${order['id']}'),
                            Text('Customer: ${order['customerName']}'),
                            Text('Date: ${order['createdAt']}'),
                            Text('Total Price: \$${order['totalPrice']}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status: ${order['status']}'),
                                DropdownButton<String>(
                                  value: order['status'],
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _updateOrderStatus(order['id'], newValue);
                                    }
                                  },
                                  items: <String>[
                                    'pending',
                                    'confirmed',
                                    'shipped',
                                    'delivered',
                                    'cancelled'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
