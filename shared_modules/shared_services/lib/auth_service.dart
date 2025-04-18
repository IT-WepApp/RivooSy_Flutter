import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

  Future<bool> hasRefreshToken() async {
    final user = _auth.currentUser;
    return user != null;
  }

  // أي دوال مساعدة أخرى مثل إعادة تعيين كلمة المرور…
}
