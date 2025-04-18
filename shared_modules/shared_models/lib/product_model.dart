
class Product {
  String id;
  String name;
  String price;
  String imageUrl; // ✅ مضاف لعرض الصور

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['id'] as String,
      name: data['name'] as String,
      price: data['price'] as String, imageUrl: data['imageUrl'] as String,
    );
  }
}