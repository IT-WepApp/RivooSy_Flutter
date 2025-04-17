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
}