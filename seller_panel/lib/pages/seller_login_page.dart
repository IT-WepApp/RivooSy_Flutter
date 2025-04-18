import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/seller_constants.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:shared_services/user_service.dart';
import 'package:shared_services/secure_storage_service.dart';
import 'package:shared_widgets/app_text_field.dart';
import 'package:shared_widgets/app_button.dart';
import 'package:shared_widgets/utils/error_handling.dart';

class SellerLoginPage extends StatefulWidget {
  const SellerLoginPage({super.key});

  @override
  State<SellerLoginPage> createState() => _SellerLoginPageState();
}

class _SellerLoginPageState extends State<SellerLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _secureStorageService = SecureStorageService();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final creds = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      final user = creds.user;

      const refreshTokenObtained = true; // Replace with actual check
      if (refreshTokenObtained) {
        await _secureStorageService.delete('password');
      }

      if (user == null) {
       if (!mounted) return;
       showErrorSnackBar(context, 'Authentication failed.');
       return;
      }


      final userData = await UserService().getUser(user.uid);
      if (!mounted) return;

      if (userData != null && userData.role == 'seller') {
        Navigator.pushReplacementNamed(context, '/sellerHome');
      } else {
        showErrorSnackBar(context, 'Unauthorized: Sellers only.');
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final errorMessage = switch (e.code) {
        'user-not-found' => 'Email not found.',
        'wrong-password' => 'Wrong password.',
        'network-request-failed' => 'No internet connection.',
        _ => 'Login error: ${e.message}',
      };
      showErrorSnackBar(context, errorMessage);
    } catch (e) {
      if (!mounted) return;
      final isNetworkError = e.toString().contains('network') || e.toString().contains('unreachable');
      showErrorSnackBar(
        context,
        isNetworkError
            ? 'Network error. Please check your connection and try again.'
            : 'Unexpected error: $e',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SellerConstants.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(controller: _emailController, label: "Email"),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : AppButton(onPressed: _login, text: "Login"),
            ],
          ),
        ),
      ),
    );
  }
}
