import 'package:flutter/material.dart';
// استيراد صفحة البداية من الحزمة المشتركة
import 'package:shared_widgets/home_choice_page.dart';
import 'pages/admin_login_page.dart';
import 'pages/seller_login_page.dart';
import 'pages/delivery_login_page.dart';
import 'pages/admin_home_page.dart';
import 'pages/seller_home_page.dart';
import 'pages/delivery_home_page.dart';
import 'pages/user_home_page.dart';
import 'pages/user_login_page.dart';


void main() {
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام متكامل',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeChoicePage(),
        '/adminLogin': (context) => const AdminLoginPage(),
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
