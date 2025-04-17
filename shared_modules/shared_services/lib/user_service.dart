import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_models/shared_models.dart'; // ✅ تصحيح الاستيراد

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      print("Error creating user: $e");
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return UserModel.fromJson(data as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print("Error getting user: $e");
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
    } catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        if (data != null) {
          return UserModel.fromJson(data as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print("Error getting user by email: $e");
      rethrow;
    }
  }

  /// ✅ إضافية: طريقة `getUserData` القديمة بصيغة static إذا حابب
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }
}
