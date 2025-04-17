import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_services/user_service.dart';
import 'package:shared_models/shared_models.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) { // تحقق من صحة النموذج
      try { // ابدأ محاولة تسجيل الدخول
        await FirebaseAuth.instance.signInWithEmailAndPassword( // حاول تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        final user = FirebaseAuth.instance.currentUser; // احصل على المستخدم الحالي
        if (user != null) { // إذا كان هناك مستخدم مسجل الدخول
          final uid = user.uid; // احصل على معرف المستخدم
          final userData = await UserService().getUser(uid); // احصل على بيانات المستخدم من خدمة المستخدم
          if (userData != null && userData.role == 'admin') { // إذا كانت بيانات المستخدم موجودة والدور هو 'admin'
            Navigator.pushReplacementNamed(context, '/adminHome'); // انتقل إلى الصفحة الرئيسية للمشرف
          } else { // إذا لم يكن لديه الصلاحيات
            _showErrorSnackBar('Unauthorized: Admins only.'); // اعرض رسالة خطأ
            await FirebaseAuth.instance.signOut(); // قم بتسجيل خروج المستخدم
          }
        } else {
          _showErrorSnackBar('Authentication error.');
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'Admin email not found.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect admin password.';
        } else {
          errorMessage = 'Login error: ${e.message}';
        }
        _showErrorSnackBar(errorMessage);
      } catch (e) {
        _showErrorSnackBar('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.blue.shade50],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Welcome, Admin!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your admin email",
                  prefixIcon: Icon(Icons.email, color: Colors.blue.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // حدود الحقل دائرية
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIcon: Icon(Icons.lock, color: Colors.blue.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
