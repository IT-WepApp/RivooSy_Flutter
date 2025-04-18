import 'package:delivery_app/utils/delivery_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_services/user_service.dart';
import 'package:shared_widgets/app_text_field.dart';
import 'package:shared_widgets/app_button.dart';
import 'package:shared_services/secure_storage_service.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:shared_widgets/utils/error_handling.dart';

class DeliveryLoginPage extends StatefulWidget {
  const DeliveryLoginPage({super.key});

  @override
  State<DeliveryLoginPage> createState() => _DeliveryLoginPageState();
}

class _DeliveryLoginPageState extends State<DeliveryLoginPage> {
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

      const refreshTokenObtained = true;
      if (refreshTokenObtained) {
        await _secureStorageService.delete('password');
        if (!mounted) return;
      }

      if (user == null) {
        showErrorSnackBar(context, 'Authentication failed.');
        return;
      }

      final userData = await UserService().getUser(user.uid);
      if (!mounted) return;

      if (userData != null && userData.role == 'delivery') {
        Navigator.pushReplacementNamed(context, '/deliveryHome');
      } else {
        showErrorSnackBar(context, 'Unauthorized: Delivery persons only.');
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final errorMessage = (e.code == 'user-not-found')
          ? 'Email not found.'
          : (e.code == 'wrong-password')
              ? 'Wrong password.'
              : 'Login error: ${e.message}';
      showErrorSnackBar(context, errorMessage);
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(DeliveryConstants.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                controller: _emailController,
                label: 'Email',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Please enter password'
                    : (v.length < 6)
                        ? 'Password must be at least 6 characters'
                        : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : AppButton(onPressed: _login, text: 'Login'),
            ],
          ),
        ),
      ),
    );
  }
}
