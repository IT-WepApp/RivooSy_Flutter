import 'package:flutter/material.dart';
import 'pages/user_home_page.dart';

void main() {
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق المستخدم',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const UserHomePage(),
    );
  }
}
