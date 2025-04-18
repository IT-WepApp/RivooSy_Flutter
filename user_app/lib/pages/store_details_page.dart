// store_details_page.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_models/product_model.dart';
import 'package:shared_models/cart_item_model.dart';
import 'package:user_app/pages/shopping_cart_page.dart' show shoppingCartProvider;
import 'package:user_app/services/product_service.dart';
import 'package:user_app/services/store_service.dart';
import 'package:user_app/services/cart_service.dart' show cartServiceProvider;

// Provider لجلب تفاصيل المتجر
final storeDetailsProvider = StateNotifierProvider
    .family<StoreDetailsNotifier, AsyncValue<Map<String, dynamic>>, String>(
  (ref, storeId) => StoreDetailsNotifier(ref)..fetchData(storeId),
);

class StoreDetailsNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref ref;
  StoreDetailsNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> fetchData(String storeId) async {
    try {
      final storeDoc =
          await ref.read(storeServiceProvider).getStoreDetails(storeId);
      final products =
          await ref.read(productServiceProvider).getProductsByStoreId(storeId);
      state = AsyncValue.data({
        'store': storeDoc.data(),
        'products': products,
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class StoreDetailsPage extends ConsumerWidget {
  final String storeId;
  const StoreDetailsPage({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeDetailsProvider(storeId));
    return Scaffold(
      appBar: AppBar(title: const Text('Store Details')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final storeData = data['store'] as Map<String, dynamic>?;
          final products = data['products'] as List<Product>?;

          if (storeData == null) {
            return const Center(child: Text('Store info missing'));
          }
          if (products == null || products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    storeData['name'] as String? ?? '',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text('No products available.', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return _buildStoreDetails(context, ref, storeData, products);
        },
      ),
    );
  }

  Widget _buildStoreDetails(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> storeData,
    List<Product> products,
  ) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(storeData['name'] as String? ?? ''),
            background: Image.network(
              storeData['imageUrl'] as String? ?? '',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final p = products[i];
              final price = double.tryParse(p.price) ?? 0.0;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: p.imageUrl.isNotEmpty
                      ? Image.network(p.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  title: Text(p.name),
                  subtitle: Text('\$${price.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () => _addToCart(context, ref, p),
                    child: const Text('Add to Cart'),
                  ),
                ),
              );
            },
            childCount: products.length,
          ),
        ),
      ],
    );
  }

  Future<void> _addToCart(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    // احفظ Messenger قبل أي await لتجنّب استخدام context عبر async gap
    final messenger = ScaffoldMessenger.of(context);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please log in to add to cart')),
      );
      return;
    }

    final price = double.tryParse(product.price) ?? 0.0;
    final item = CartItem(
      productId: product.id,
      name: product.name,
      quantity: 1,
      price: price,
    );

    try {
      await ref.read(cartServiceProvider).addToCart(userId, item);
      ref.invalidate(shoppingCartProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Added to cart!')),
      );
    } catch (e, st) {
      developer.log(
        'Error adding to cart',
        error: e,
        stackTrace: st,
        name: 'StoreDetailsPage',
      );
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }
}
