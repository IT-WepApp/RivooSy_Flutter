import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_widgets/app_button.dart';
import 'package:shared_widgets/app_text_field.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:shared_widgets/theme/theme.dart';
import 'package:shared_services/secure_storage_service.dart';
import 'package:user_app/pages/order_details_page.dart';
import 'package:user_app/pages/store_details_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_app/pages/my_orders_page.dart';
import 'package:user_app/pages/order_confirmation_page.dart';
import 'package:user_app/services/notification_service.dart';
import 'package:user_app/widgets/home_page_wrapper.dart';
import 'package:user_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/utils/user_constants.dart';
import 'firebase_options.dart';
import 'package:user_app/utils/route_constants.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.showLocalNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  final _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
    _loadCredentials();
    getDeviceToken().then((_) {
      FirebaseMessaging.instance.subscribeToTopic('user');      
    });
  }

  Future<void> _setupFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened from notification: ${message.data}');
    });
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    setState(() {
      _emailController.text = email;
      _rememberMe = rememberMe;
    });

    if (_rememberMe && email.isNotEmpty) {
      final password = await _secureStorageService.read('password') ?? '';
      if (password.isNotEmpty) {
        _login(email: email, password: password);
      }
    }
  }

  Future<void> getDeviceToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $fcmToken");
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
    }
  }

  Future<void> _login({String? email, String? password}) async {
    if (_formKey.currentState?.validate() ?? true) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email ?? _emailController.text.trim(),
          password: password ?? _passwordController.text.trim(),
        );
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userService = UserService();
          final userType = await userService.getUserTypeFromDatabase(user.uid);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userType', userType);
          await NotificationService().subscribeToTopic(userType);
          await _saveCredentials();
        }
      } on FirebaseAuthException catch (e) {
        _handleAuthError(e);
      } catch (e) {
        _showErrorSnackBar('حدث خطأ: ${e.toString()}');
      }
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text.trim());
      await _secureStorageService.write('password', _passwordController.text.trim());
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.clear();
      await _secureStorageService.delete('password');
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String errorMessage;
    if (e.code == 'user-not-found') {
      errorMessage = 'البريد الإلكتروني غير مسجل';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'كلمة المرور غير صحيحة';
    } else {
      errorMessage = 'حدث خطأ: ${e.message}';
    }
    _showErrorSnackBar(errorMessage);
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
        backgroundColor: AppColors.primary,
        title: const Text(UserConstants.appTitle),
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
                "مرحباً بك!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 30),
              AppTextField(
                controller: _emailController,
                label: "البريد الإلكتروني",
              ),
              const SizedBox(height: 15),
              AppTextField(
                controller: _passwordController,
                obscureText: true,
                label: "كلمة المرور",
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text("تذكرني"),
                ],
              ),
              const SizedBox(height: 30),
              AppButton(
                onPressed: _login,
                text: "تسجيل الدخول",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: RouteConstants.home,
      routes: {
        RouteConstants.home: (context) => const AuthCheck(),
        RouteConstants.storeDetails: _storeDetailsRoute,
        RouteConstants.myOrders: (context) => const MyOrdersPage(),
        RouteConstants.orderDetails: _orderDetailsRoute,
        RouteConstants.login: (context) => const LoginPage(),
        RouteConstants.orderConfirmation: _orderConfirmationRoute,
      },
    );
  }

  static Widget _storeDetailsRoute(BuildContext context) {
    final storeId = ModalRoute.of(context)!.settings.arguments as String;
    return StoreDetailsPage(storeId: storeId);
  }

  static Widget _orderDetailsRoute(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    return OrderDetailsPage(orderId: orderId);
  }

  static Widget _orderConfirmationRoute(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return OrderConfirmationPage(
      cartItems: arguments['cartItems'],
      totalPrice: arguments['totalPrice'],
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginPage();
          }
          return const HomePageWrapper();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
