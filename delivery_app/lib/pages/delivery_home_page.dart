import 'package:flutter/material.dart';
import 'package:shared_modules/shared_services.dart';
import 'package:shared_modules/shared_models.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

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
      // Replace with actual logic to fetch orders assigned to the delivery person
      // For example, if you have a DeliveryService in shared_services:
      // assignedOrders = await DeliveryService().getAssignedOrders(deliveryPersonId);
      // Or using OrderService with a query:
      assignedOrders = await OrderService().getOrdersByDeliveryId("someDeliveryId");
    } catch (e) {
      debugPrint("Error loading assigned orders: $e");
      // Handle error appropriately, e.g., show a snackbar
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
        title: const Text('Delivery App'),
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
                        // Add more details or actions as needed
                      );
                    },
                  ),
      ),
    );
  }
}
