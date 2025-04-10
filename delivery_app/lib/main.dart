import 'package:flutter/material.dart';
import 'pages/delivery_home_page.dart';

void main() {
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق التوصيل',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DeliveryHomePage(),
    );
  }
}
