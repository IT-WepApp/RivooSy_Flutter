import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_models/shared_models.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toJson());
    } catch (e, st) {
      developer.log(
        'Error creating order',
        error: e,
        stackTrace: st,
        name: 'OrderService',
      );
      rethrow;
    }
  }

  Future<OrderModel?> getOrder(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e, st) {
      developer.log(
        'Error getting order',
        error: e,
        stackTrace: st,
        name: 'OrderService',
      );
      rethrow;
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).update(order.toJson());
    } catch (e, st) {
      developer.log(
        'Error updating order',
        error: e,
        stackTrace: st,
        name: 'OrderService',
      );
      rethrow;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e, st) {
      developer.log(
        'Error deleting order',
        error: e,
        stackTrace: st,
        name: 'OrderService',
      );
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    } catch (e, st) {
      developer.log(
        'Error getting orders by user',
        error: e,
        stackTrace: st,
        name: 'OrderService',
      );
      rethrow;
    }
  }

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final querySnapshot = await _firestore.collection('orders').get();
      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    } catch (e, st) {
      developer.log(
        'Error getting all orders',
        error: e,
        stackTrace: st,
        name: 'OrderService',
      );
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrdersBySeller(String sellerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();
      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    } catch (e, st) {
      developer.log(
        'Error getting orders by seller',
        error: e,
        stackTrace: st,
        name: 'OrderService',
      );
      rethrow;
    }
  }
}
