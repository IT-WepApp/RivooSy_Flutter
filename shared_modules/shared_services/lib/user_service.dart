import 'dart:developer'; // ✅ استيراد log
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_models/shared_models.dart'; // ✅ تصحيح الاستيراد

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersCollection =
      _firestore.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      log("Error creating user: $e");
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>?;
      return data == null ? null : UserModel.fromJson(data);
    } catch (e) {
      log("Error getting user: $e");
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
    } catch (e) {
      log("Error updating user: $e");
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      log("Error deleting user: $e");
      rethrow;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final snapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      final data = snapshot.docs.first.data() as Map<String, dynamic>?;
      return data == null ? null : UserModel.fromJson(data);
    } catch (e) {
      log("Error getting user by email: $e");
      rethrow;
    }
  }

  /// ✅ طريقة بديلة (static) إذا احتجتها في أماكن أخرى:
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
  }
}
