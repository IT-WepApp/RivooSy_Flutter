import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_modules/shared_services.dart';
import 'package:overlay_support/overlay_support.dart';

const String userTypeKey = 'userType';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _requestPermissions();
    FirebaseMessaging.onMessage.listen(_handleIncomingMessage);
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
    print('User granted permission: ${settings.authorizationStatus}');
  }

  void _handleIncomingMessage(RemoteMessage message) async {
    String title = message.notification?.title ?? 'New Notification';
    String body = message.notification?.body ?? 'You have a new update!';

    showSimpleNotification(
      Text(title),
      subtitle: Text(body),
      background: Colors.blue.shade700,
      duration: const Duration(seconds: 5),
    );
  }

  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }

  
  }
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("================Background Message===================");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Data: ${message.data}");
  print("================================================");
}
}