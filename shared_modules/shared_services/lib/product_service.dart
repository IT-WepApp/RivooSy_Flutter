import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_models/shared_models.dart'; // Assuming your shared_models package

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.id).set(product.toJson());
    } catch (e) {
      log('Error creating product: $e');
      rethrow;
    }
  }

  Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error getting product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.id).update(product.toJson());
    } catch (e) {
      log('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      log('Error deleting product: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsBySeller(String sellerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Error getting products by seller: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore.collection('products').get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Error getting all products: $e');
      rethrow;
    }
  }
}
