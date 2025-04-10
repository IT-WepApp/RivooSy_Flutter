import 'package:flutter/material.dart';
import '../widgets/admin_custom_button.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الإدارة'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً بك في لوحة الإدارة'),
            const SizedBox(height: 20),
            AdminCustomButton(
              label: 'عرض التقارير',
              onPressed: () {
                // مثال: تنفيذ عملية عرض التقارير
                debugPrint('عرض التقارير');
              },
            ),
          ],
        ),
      ),
    );
  }
}
