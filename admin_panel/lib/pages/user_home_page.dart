import 'package:flutter/material.dart';
import 'package:shared_widgets/theme/colors.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('User Home'),
      ),
      body: const Center(
        child: Text('User Home Page Content'),
      ),
    );
  }
}