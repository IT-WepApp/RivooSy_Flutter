// notification_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// دالة لمعالجة الرسائل الواردة عندما يكون التطبيق في الخلفية أو مغلقًا.
/// يجب أن تكون دالة عليا (ليست داخل أي كلاس) ومُشروحة بـ @pragma('vm:entry-point')
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // تهيئة Firebase إذا لم تكن مهيأة بالفعل
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  // منطق التعامل مع الرسالة
  print("📩 تم استلام رسالة في الخلفية: ${message.messageId}");

  // يمكنك هنا تنفيذ منطق إضافي مثل:
  // - عرض إشعار محلي باستخدام flutter_local_notifications
  // - حفظ البيانات في قاعدة بيانات محلية
  // - إرسال تقارير أو تسجيلات
}

// 👇 الأكواد الحالية في الملف (احتفظ بها كما هي)
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // طلب أذونات الإشعارات
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🛡️ حالة الإذن: ${settings.authorizationStatus}');

    // الاستماع للرسائل أثناء تشغيل التطبيق
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📬 رسالة واردة أثناء تشغيل التطبيق: ${message.messageId}');
      // منطق التعامل مع الرسالة أثناء التشغيل
    });

    // التعامل مع الرسائل عند فتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📨 تم فتح التطبيق من إشعار: ${message.messageId}');
      // منطق التنقل أو التحديث
    });
  }
}