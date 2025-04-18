import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/seller_home_page.dart';
import 'pages/seller_login_page.dart';
import 'package:shared_widgets/theme/theme.dart'; // Import the shared theme

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SellerPanelApp());
}

class SellerPanelApp extends StatelessWidget {
  const SellerPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق صاحب المتجر',
      theme: AppTheme.lightTheme,
      home: const SellerLoginPage(),
      routes: {
        '/sellerHome': (context) => const SellerHomePage(),
      },
    );
  }
}
