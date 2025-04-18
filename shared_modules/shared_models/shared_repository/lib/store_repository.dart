import 'package:shared_models/store_model.dart'; // تأكد من وجود هذا النموذج في shared_models

abstract class StoreRepository {
  Future<List<Store>> getStores();
  Future<Store?> getStoreDetails(String id);
}
