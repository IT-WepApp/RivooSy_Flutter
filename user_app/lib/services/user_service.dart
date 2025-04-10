class UserService {
  Future<String> fetchProducts() async {
    // مثال: استدعاء API لجلب قائمة المنتجات
    return Future.delayed(const Duration(seconds: 1), () => 'قائمة المنتجات');
  }
}
