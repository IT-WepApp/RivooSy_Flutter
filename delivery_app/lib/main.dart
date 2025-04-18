import 'package:flutter/material.dart';
import 'pages/delivery_home_page.dart';
import 'package:delivery_app/pages/delivery_login_page.dart';

void main() {
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق التوصيل',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DeliveryLoginPage(),
      routes: {
        '/deliveryHome': (context) => const DeliveryHomePage(),
      },
    );
  }
}
