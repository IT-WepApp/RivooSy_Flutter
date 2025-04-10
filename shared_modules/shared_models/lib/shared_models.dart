library shared_models;

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class Order {
  final String id;
  final List<Product> products;

  Order({required this.id, required this.products});
}
