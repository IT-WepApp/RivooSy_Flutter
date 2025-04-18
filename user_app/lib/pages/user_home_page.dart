import 'package:flutter/material.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:user_app/utils/user_constants.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(UserConstants.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Welcome to the User App!'),
      ),
    );
  }
}