import 'package:flutter/material.dart';
import 'pages/seller_home_page.dart';
import 'package:seller_panel/pages/seller_login_page.dart';

void main() {
  runApp(const SellerPanelApp());
}

class SellerPanelApp extends StatelessWidget {
  const SellerPanelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق صاحب المتجر',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SellerLoginPage(),
      routes: {
        '/sellerHome': (context) => const SellerHomePage(),
      },
    );
  }
}
