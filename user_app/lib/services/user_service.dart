import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUserTypeFromDatabase(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data()?['role'] ?? 'user';
      } else {
        return 'user';
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user type: \$e');
      return 'user';
    }
  }

  getUserData(String userId) {}
}

final userServiceProvider = Provider<UserService>((ref) => UserService());
