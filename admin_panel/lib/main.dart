import 'package:flutter/material.dart';
// استيراد صفحة البداية من الحزمة المشتركة
import 'package:shared_widgets/home_choice_page.dart';

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
      },
    );
  }
}

// صفحات تسجيل دخول مؤقتة لحتى تنشئ الملفات الحقيقية لاحقاً

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('تسجيل دخول المشرف')));
  }
}

class SellerLoginPage extends StatelessWidget {
  const SellerLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('تسجيل دخول البائع')));
  }
}

class DeliveryLoginPage extends StatelessWidget {
  const DeliveryLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('تسجيل دخول المندوب')));
  }
}

class UserLoginPage extends StatelessWidget {
  const UserLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('تسجيل دخول المستخدم')));
  }
}
