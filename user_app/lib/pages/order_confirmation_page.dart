import 'package:flutter/material.dart';
import 'package:user_app/models/cart_item_model.dart'; // Import CartItem
import 'package:user_app/services/order_service.dart'; // Import OrderService
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

// Make sure to create OrderService and its methods as described
class OrderConfirmationPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const OrderConfirmationPage({super.key, required this.cartItems});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  double _calculateTotalPrice() {
    return widget.cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to place an order.')),
      );
      return;
    }

    final userId = user.uid;
    final totalPrice = _calculateTotalPrice();

    // Assuming you have an OrderService instance
    await OrderService().placeOrder(userId, widget.cartItems, totalPrice);

    // Display confirmation and navigate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
    Navigator.pushReplacementNamed(context, '/my-orders'); // Replace with your MyOrdersPage route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order'),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Quantity: ${item.quantity}, Price: \$${item.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Change color as needed
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    'Confirm Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}
