import 'package:shared_models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUser(String id);
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
  // يمكنك إضافة المزيد من العمليات المتعلقة بالمستخدم إذا لزم الأمر
}
