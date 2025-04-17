import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final Timestamp createdAt;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    required this.createdAt,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'createdAt': createdAt,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      createdAt: json['createdAt'] as Timestamp,
      profileImageUrl: json['profileImageUrl'],
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String sellerId;
  final String? category;
  final int stock;
  final Timestamp createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sellerId,
    this.category,
    required this.stock,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'category': category,
      'stock': stock,
      'createdAt': createdAt,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      sellerId: json['sellerId'],
      category: json['category'],
      stock: json['stock'],
      createdAt: json['createdAt'] as Timestamp,
    );
  }
}

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
