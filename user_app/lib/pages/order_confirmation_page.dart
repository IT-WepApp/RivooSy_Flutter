import 'package:flutter/material.dart';
import 'package:user_app/models/cart_item_model.dart'; // Import CartItem
import 'package:user_app/services/order_service.dart'; // Import OrderService
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class OrderConfirmationPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const OrderConfirmationPage({super.key, required this.cartItems, required this.totalPrice});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to place an order.')),
      );
      return;
    }

    final userId = user.uid;
    await OrderService().placeOrder(userId, widget.cartItems, widget.totalPrice);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
    Navigator.pushReplacementNamed(context, '/my-orders');
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
                        subtitle: Text('Quantity: \${item.quantity}, Price: \$\${item.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$\${widget.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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