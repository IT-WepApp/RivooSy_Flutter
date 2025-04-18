import 'package:flutter/material.dart';
import 'package:shared_widgets/app_button.dart';
import 'package:shared_widgets/theme/colors.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الإدارة'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'مرحباً بك في لوحة الإدارة',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'عرض التقارير',
              onPressed: () {
                // هنا بتضيف الكود الفعلي لما تضغط الزر
                // مثلاً: التنقل إلى صفحة التقارير
                // Navigator.pushNamed(context, '/reports');
              },
            ),
          ],
        ),
      ),
    );
  }
}
