// lib/pages/profile_page.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_app/services/user_service.dart';
import 'package:shared_models/user_model.dart';

/// مزوّد خدمة المستخدمين المحليّة
final userServiceProvider = Provider<UserService>((ref) => UserService());

/// مزوّد حالة الملف الشخصي
final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserModel>>(
  (ref) => ProfileNotifier(ref),
);

class ProfileNotifier extends StateNotifier<AsyncValue<UserModel>> {
  ProfileNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchProfile();
  }
  final Ref ref;

  Future<void> fetchProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      state = AsyncValue.error("لا يوجد مستخدم مسجل", StackTrace.current);
      return;
    }

    try {
      // 1) استدعاء getUserData بوضع الـ uid كوسيط موضعي
      final docSnapshot = await ref.read(userServiceProvider).getUserData(uid);
      final data = docSnapshot.data() as Map<String, dynamic>?;
      if (data == null) {
        state = AsyncValue.error("بيانات المستخدم غير موجودة", StackTrace.current);
        return;
      }

      // 2) بناء UserModel من الخريطة
      final userModel = UserModel(
        uid: uid,
        id: uid,
        name: data['name'] as String? ?? '',
        email: data['email'] as String? ?? '',
      );

      // 3) تحديث الحالة
      state = AsyncValue.data(userModel);
    } catch (e, st) {
      developer.log(
        'خطأ في جلب بيانات الملف الشخصي',
        error: e,
        stackTrace: st,
        name: 'ProfileNotifier',
      );
      state = AsyncValue.error('فشل في جلب البيانات: $e', st);
    }
  }
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: profileState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('خطأ: $error')),
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الاسم: ${user.name}', style: const TextStyle(fontSize: 18)),
              Text('البريد الإلكتروني: ${user.email}',
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
