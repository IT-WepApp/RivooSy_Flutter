// lib/services/product_service.dart

import 'package:shared_models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// خدمة جلب المنتجات من Firestore
class ProductService {
  /// يجلب قائمة المنتجات الخاصة بمتجر معيّن
  Future<List<Product>> getProductsByStoreId(String storeId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('storeId', isEqualTo: storeId)
        .get();

    final products = querySnapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();

    return products;
  }
}

/// Riverpod provider لحقن ProductService في التطبيق
final productServiceProvider =
    Provider<ProductService>((ref) => ProductService());
