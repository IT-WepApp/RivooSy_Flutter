import 'package:flutter/material.dart';
import 'package:shared_widgets/home_choice_page.dart';
import 'package:shared_widgets/theme/theme.dart';

import 'pages/admin_home_page.dart';
import 'pages/delivery_home_page.dart';
import 'pages/delivery_login_page.dart';
import 'pages/login/login_page.dart'; // Correct import
import 'pages/seller_home_page.dart';
import 'pages/seller_login_page.dart';
import 'pages/user_home_page.dart';
import 'pages/user_login_page.dart';

void main() {
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام متكامل',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeChoicePage(), // Correct import
        '/adminLogin': (context) => const AdminLoginPage(), // Now using the moved class
        '/sellerLogin': (context) => const SellerLoginPage(),
        '/deliveryLogin': (context) => const DeliveryLoginPage(),
        '/userLogin': (context) => const UserLoginPage(),
        '/adminHome': (context) => const AdminHomePage(),
        '/sellerHome': (context) => const SellerHomePage(),
        '/deliveryHome': (context) => const DeliveryHomePage(),
        '/userHome': (context) => const UserHomePage(),
      },
    );
  }
}