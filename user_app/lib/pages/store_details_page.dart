import 'package:shared_widgets/app_button.dart';
import 'package:shared_widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:user_app/models/product_model.dart';
import 'package:user_app/services/product_service.dart';
import 'package:user_app/services/store_service.dart';
import 'package:user_app/services/cart_service.dart';
import 'package:user_app/models/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_widgets/theme/colors.dart';
import 'package:user_app/utils/user_constants.dart';
class StoreDetailsPage extends StatefulWidget {
  final String storeId;

  const StoreDetailsPage({super.key, required this.storeId});

  @override
  State<StoreDetailsPage> createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  late Future<Map<String, dynamic>> _dataFuture;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<void> _addToCart(Product product) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add items to your cart.')),
      );
      return;
    }

    // parse price as double (product.price is always String)
    final price = double.tryParse(product.price) ?? 0.0;

    final cartItem = CartItem(
      productId: product.id,
      name: product.name,
      quantity: 1,
      price: price,
    );

    try {
      await _cartService.addToCart(userId, cartItem);
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart!')),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      debugPrint("Error adding to cart: $e");
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final storeDetails = await StoreService().getStoreDetails(widget.storeId);
    final products = await ProductService().getProductsByStoreId(widget.storeId);
    return {
      'store': storeDetails.data(),
      'products': products,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text(UserConstants.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Store details not found'));
          }

          final storeData = snapshot.data!['store'] as Map<String, dynamic>?;
          final products = snapshot.data!['products'] as List<Product>?;

          if (storeData == null) {
            return const Center(child: Text('Store information is missing'));
          }

          if (products == null || products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    storeData['name'] as String? ?? 'Store Name Not Available',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text('No products available for this store.', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(
                    storeData['name'] as String? ?? 'Store Name Not Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  background: Image.network(
                    storeData['imageUrl'] as String? ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final product = products[index];
                      // parse price once
                      final price = double.tryParse(product.price) ?? 0.0;
                      return AppCard(child: ListTile(
                          leading: product.imageUrl.isNotEmpty
                              ? Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                              : null,
                          title: Text(product.name),
                          subtitle: Text('Price: \$${price.toStringAsFixed(2)}'),
                          trailing: AppButton(
                            onPressed: () => _addToCart(product),
                            text: 'Add to Cart',
                          ),
                        ),
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
