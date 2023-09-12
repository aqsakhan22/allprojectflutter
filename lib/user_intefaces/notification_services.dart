import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("USER GRANTED PERMISSIONS");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("USER GRANTED PROVISIONAL PERMISSIONS");
    } else {
      print("USER Not give permssion");
      // AppSettings.openNotificationSettings(); //not running in ios so we have to remove
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

//if token is refersh in any case
  isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("FCM TOKEN IS Refersh");
    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      print("message is ${message.notification!.body.toString()} ${message.notification!.title.toString()} ${message.notification!.title.toString()} ");
      showNotification(message);
    });
  }

  void initLocalNotifications() async {
    var androidInit = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInit = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {});
    //@mipmap/ic_launcher
    //@drawable/ng_pro_splash
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channnel = AndroidNotificationChannel(Random.secure().nextInt(1000).toString(), "High", importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channnel.id.toString(), channnel.name.toString(), channelDescription: "desc", importance: Importance.high, priority: Priority.high, ticker: "toicket");

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(1, message.notification!.title.toString(), message.notification!.body.toString(), notificationDetails);
    });
  }
}
