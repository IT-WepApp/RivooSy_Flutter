import 'package:flutter/material.dart';
import 'pages/delivery_home_page.dart';
import 'package:shared_widgets/theme/theme.dart';

void main() {
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق التوصيل',
      theme: AppTheme.lightTheme,
      home: const DeliveryHomePage(),
      routes: {
        '/deliveryHome': (context) => const DeliveryHomePage(),
      },
    );
  }
}
