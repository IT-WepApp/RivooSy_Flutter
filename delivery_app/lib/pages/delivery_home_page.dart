import 'package:flutter/material.dart';
import 'package:shared_services/order_service.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:delivery_app/utils/delivery_constants.dart';
import 'package:shared_models/shared_models.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({super.key});

  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  List<OrderModel> assignedOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignedOrders();
  }

  Future<void> _loadAssignedOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Replace with actual logic to fetch orders assigned to the delivery person.
      assignedOrders = await OrderService().getOrdersByUser("someDeliveryId");
    } catch (e) {
      debugPrint("Error loading assigned orders: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(DeliveryConstants.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : assignedOrders.isEmpty
                ? const Text('No orders assigned to you.')
                : ListView.builder(
                    itemCount: assignedOrders.length,
                    itemBuilder: (context, index) {
                      final order = assignedOrders[index];
                      return ListTile(
                        title: Text('Order ID: ${order.id}'),
                        subtitle: Text('Status: ${order.status}'),
                      );
                    },
                  ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Text(
                'القائمة',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary), // إزالة const هنا
              title: const Text('الرئيسية'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary), // إزالة const هنا
              title: const Text('الملف الشخصي'),
              onTap: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}
