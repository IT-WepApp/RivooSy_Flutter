import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProductItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  OrderProductItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderProductItem.fromJson(Map<String, dynamic> json) {
    return OrderProductItem(
      productId: json['productId'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String sellerId;
  final String? deliveryId;
  final List<OrderProductItem> products;
  final double total;
  final String status;
  final String address;
  final Timestamp createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.sellerId,
    this.deliveryId,
    required this.products,
    required this.total,
    required this.status,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sellerId': sellerId,
      'deliveryId': deliveryId,
      'products': products.map((item) => item.toJson()).toList(),
      'total': total,
      'status': status,
      'address': address,
      'createdAt': createdAt,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      sellerId: json['sellerId'],
      deliveryId: json['deliveryId'],
      products: (json['products'] as List)
          .map((item) => OrderProductItem.fromJson(item))
          .toList(),
      total: (json['total'] as num).toDouble(),
      status: json['status'],
      address: json['address'],
      createdAt: json['createdAt'] as Timestamp,
    );
  }
}