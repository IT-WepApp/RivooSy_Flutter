import 'package:flutter/material.dart';
import 'pages/seller_home_page.dart';
import 'package:seller_panel/pages/seller_login_page.dart';
import 'package:shared_widgets/theme/theme.dart'; // Import the shared theme

void main() {
  runApp(const SellerPanelApp());
}

class SellerPanelApp extends StatelessWidget {
  const SellerPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق صاحب المتجر', // Use the shared theme
      theme: AppTheme.lightTheme,
      home: const SellerLoginPage(),
      routes: {
        '/sellerHome': (context) => const SellerHomePage(),
      },
    );
  }
}
