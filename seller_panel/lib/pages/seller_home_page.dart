import 'package:flutter/material.dart';
import '../widgets/seller_custom_button.dart';

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة المتجر'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً بك في تطبيق صاحب المتجر'),
            const SizedBox(height: 20),
            SellerCustomButton(
              label: 'عرض الطلبات',
              onPressed: () {
                // مثال على إجراء عرض الطلبات
                debugPrint('عرض الطلبات');
              },
            ),
          ],
        ),
      ),
    );
  }
}
