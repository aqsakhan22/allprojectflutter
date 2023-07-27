
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseflutterproject/user_intefaces/notification_settings.dart';

Future<void> listenToFCM() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCMToken $fcmToken");
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.instance.getToken().then((value) {
    print("fcm value is ${value}");
  });
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true, sound: true,
  );
  print('FCM User Granted Permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message)
  {

    //
    // Map<String,dynamic> data=jsonDecode(message.notification!.body.toString());
    // print("hello  ${data}");
    // print("_handleMessage  ${jsonDecode(message.notification!.body.toString())['name']}");
    NotificationService().showNotification(title: "sample title",body: message.notification!.body);
  });
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  FirebaseMessaging.onBackgroundMessage(_handleMessage);

}

Future<void> _handleMessage(RemoteMessage message) async {
print("_handleMessage ${message.data} ${jsonDecode(message.data.toString())['name']}");
NotificationService().showNotification(title: "sample title",body: message.data.toString());
  if (message.notification != null) {
    print('Message Also Contained A Notification: ${message.notification}');
  }
}