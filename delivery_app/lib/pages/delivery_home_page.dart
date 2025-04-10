import 'package:flutter/material.dart';
import '../widgets/delivery_custom_button.dart';

class DeliveryHomePage extends StatelessWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق التوصيل'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً بك في تطبيق التوصيل'),
            const SizedBox(height: 20),
            DeliveryCustomButton(
              label: 'تتبع الطلب',
              onPressed: () {
                debugPrint('تتبع الطلب');
              },
            ),
          ],
        ),
      ),
    );
  }
}
