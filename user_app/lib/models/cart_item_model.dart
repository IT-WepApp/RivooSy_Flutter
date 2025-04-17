class CartItem {
  final String productId;
  final String name;
  int quantity;
  final double price;

  CartItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });
}