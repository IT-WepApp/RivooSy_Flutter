import 'package:flutter/material.dart';
import 'package:shared_widgets/theme/colors.dart';

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Seller Home'),
      ),
      body: const Center(
        child: Text('Placeholder for Seller Home Page'),
      ),
    );
  }
}