import 'package:flutter/material.dart';
import 'package:user_app/models/cart_item_model.dart'; // Import CartItem
import 'package:user_app/services/order_service.dart'; // Import OrderService
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_widgets/theme/colors.dart'; // Import FirebaseAuth
import 'package:user_app/utils/user_constants.dart';
import 'package:shared_widgets/app_button.dart'; // Import AppButton

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
          const SnackBar(content: Text('You must be logged in to place an order.')));
      return;
    }

    final userId = user.uid;
    await OrderService().placeOrder(userId, widget.cartItems, widget.totalPrice);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    }
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/my-orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text(UserConstants.appTitle),
        backgroundColor: AppColors.primary,
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
                        subtitle: const Text('Quantity: \${item.quantity}, Price: \$\${item.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$\${widget.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                AppButton(
                  text: 'Confirm Order',
                  onPressed: _placeOrder,
                ),
              ],
            ),
    );
  }
}