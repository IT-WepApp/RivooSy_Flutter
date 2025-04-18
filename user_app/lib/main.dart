import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:user_app/pages/store_details_page.dart';
import 'package:user_app/utils/route_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_app/pages/my_orders_page.dart';
import 'package:user_app/pages/order_confirmation_page.dart';
import 'package:user_app/services/notification_service.dart';
import 'package:user_app/widgets/home_page_wrapper.dart';
import 'package:user_app/services/user_service.dart';
import 'firebase_options.dart';
import 'package:user_app/pages/order_details_page.dart';

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
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
    getDeviceToken().then((_) {
      FirebaseMessaging.instance.subscribeToTopic('user');
    });
    _loadCredentials();
  }

  Future<void> _setupFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    // استخدم interpolation الصحيحة هنا
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from notification: ${message.data}');
    });
  }

  Future<void> _loadCredentials() async {
    final email = await _storage.read(key: 'email') ?? '';
    final password = await _storage.read(key: 'password') ?? '';
    final rememberMe = await _storage.read(key: 'rememberMe') ?? 'false';

    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _rememberMe = rememberMe == 'true';
    });

    if (_rememberMe && email.isNotEmpty && password.isNotEmpty) {
      _login(email: email, password: password);
    }
  }

  Future<void> getDeviceToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $fcmToken");
    } catch (e) {
      print("Error getting FCM token: $e");
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
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('userType', userType);

          await NotificationService().subscribeToTopic(userType);
          _saveCredentials();
        }
      } on FirebaseAuthException catch (e) {
        _handleAuthError(e);
      } catch (e) {
        // صححنا interpolation هنا أيضاً
        _showErrorSnackBar('حدث خطأ: ${e.toString()}');
      }
    }
  }

  Future<void> _saveCredentials() async {
    if (_rememberMe) {
      await _storage.write(key: 'email', value: _emailController.text.trim());
      await _storage.write(key: 'password', value: _passwordController.text.trim());
      await _storage.write(key: 'rememberMe', value: 'true');
    } else {
      await _storage.deleteAll();
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String errorMessage;
    if (e.code == 'user-not-found') {
      errorMessage = 'البريد الإلكتروني غير مسجل';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'كلمة المرور غير صحيحة';
    } else {
      // صححنا interpolation هنا أيضاً
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
        title: const Text("تسجيل الدخول"),
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
                "مرحباً بك!",
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
                  labelText: "البريد الإلكتروني",
                  hintText: "أدخل بريدك الإلكتروني",
                  prefixIcon: Icon(Icons.email, color: Colors.blue.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue.shade700, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال البريد الإلكتروني";
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return "الرجاء إدخال بريد إلكتروني صحيح";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "كلمة المرور",
                  hintText: "أدخل كلمة المرور",
                  prefixIcon: Icon(Icons.lock, color: Colors.blue.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue.shade700, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال كلمة المرور";
                  }
                  if (value.length < 6) {
                    return "يجب أن تكون كلمة المرور 6 أحرف على الأقل";
                  }
                  return null;
                },
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
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "تسجيل الدخول",
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق المستخدم',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
