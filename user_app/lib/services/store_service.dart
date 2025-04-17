import 'package:user_app/models/store_model.dart'; // Assuming this model exists
import 'package:cloud_firestore/cloud_firestore.dart';


class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches a list of stores from the 'stores' collection.
  ///
  /// Each store document should have at least 'name' and 'image' fields.
  Future<List<Store>> getStores() async {
    try {
      final querySnapshot = await _firestore.collection('stores').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Store(
          id: doc.id,
          name: data['name'] ?? 'Unnamed Store',
          image: data['image'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching stores: $e');
      return []; // Return an empty list in case of error
    }
  }

  /// Fetches details of a specific store from the 'stores' collection.
  ///
  /// Takes a [storeId] as a parameter.
  Future<DocumentSnapshot<Map<String, dynamic>>> getStoreDetails(String storeId) async {
    return await _firestore.collection('stores').doc(storeId).get();
  }
}