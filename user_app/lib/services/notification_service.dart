import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<String> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString(userTypeKey) ?? 'user';
    print("==============NotificationService==================");
    print("userType: $userType");
    print("================================================");
    return userType;
  }

  Future<void> subscribeToTopic(String userType) async {
    String topic;
    switch (userType) {
      case 'user':
        topic = 'user_notifications';
        break;
      case 'store':
        topic = 'store_notifications';
        break;
      case 'delivery':
        topic = 'delivery_notifications';
        break;
      case 'admin':
        topic = 'admin_notifications';
        break;
      default:
        print('Invalid user type: $userType');
        return;
    }

    await _fcm.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }
}