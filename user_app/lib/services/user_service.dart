import 'package:cloud_firestore/cloud_firestore.dart';

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
      print('Error fetching user type: \$e');
      return 'user';
    }
  }
}
