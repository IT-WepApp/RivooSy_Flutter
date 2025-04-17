import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<String> getUserTypeFromDatabase(String userId) async {
    try {
      final userType = await _fetchUserTypeFromDatabase(userId);
      return userType;
    } catch (e) {
      print('Error fetching user type: $e');
      return 'user';
    }
  }

  Future<String> _fetchUserTypeFromDatabase(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return (doc.data()!['type'] as String?) ?? 'user';
      }
      return 'user';
    } catch (e) {
      print('Error fetching user type from Firestore: $e');
      return 'user';
    }
  }
}
