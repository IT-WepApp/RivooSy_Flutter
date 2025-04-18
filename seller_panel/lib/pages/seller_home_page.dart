import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_widgets/app_card.dart';
import 'package:seller_panel/utils/seller_constants.dart';

class SellerHomePage extends StatefulWidget {
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
      const sellerId = 'some_seller_id'; // استبدل بالمعرف الحقيقي
      final orders = await _orderService.getOrdersBySeller(sellerId);
      if (mounted) {
        setState(() => _orders = orders);
      }
    } catch (e, st) {
      developer.log(
        'Error fetching orders',
        error: e,
        stackTrace: st,
        name: 'SellerHomePage',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في جلب الطلبات')),
        );
        setState(() => _orders = []);
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(SellerConstants.appTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('لا توجد طلبات'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return AppCard(
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
                      ),
                    );
                  },
                ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Text(
                'Foodie',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: AppColors.primary),
              title: Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
