import 'package:shared_models/product_model.dart'; // تأكد من وجود هذا النموذج في shared_models

abstract class ProductRepository {
  Future<List<Product>> getProductsByStoreId(String storeId);
}
