import 'package:flutter/material.dart';
import '../widgets/user_custom_button.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق المستخدم'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً بك في متجرنا الإلكتروني'),
            const SizedBox(height: 20),
            UserCustomButton(
              label: 'تسجيل الدخول',
              onPressed: () {
                debugPrint('تسجيل دخول المستخدم');
              },
            ),
          ],
        ),
      ),
    );
  }
}
