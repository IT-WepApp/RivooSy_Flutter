import 'package:shared_services/auth_service.dart';

class AuthenticationRepository {
  final _authService = AuthService();

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> hasRefreshToken() async {
    return _authService.hasRefreshToken();
  }

  // يمكنك إضافة دوال أخرى ذات صلة بالمصادقة هنا، مثل:
  // - إعادة تعيين كلمة المرور
  // - التحقق من حالة المصادقة الحالية
  // - إدارة رموز التحديث
}
