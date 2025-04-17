import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }
}