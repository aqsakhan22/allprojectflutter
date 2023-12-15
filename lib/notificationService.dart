
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class NotificationService {
    final notification = FlutterLocalNotificationsPlugin();




  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher',);
    var initializeSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
         print("local notification is  id ${id}  title ${title}  body ${body} payload ${payload}");
        });
    var initializeSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializeSettingsIOS);
    final details = await notification.getNotificationAppLaunchDetails();

    // if (details != null && details.didNotificationLaunchApp) {
    //   print("we are in details ");
    // }
    // else{
    //   print("details is empty");
    // }
    await notification.initialize(
        initializeSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        print("notificationResponse  id ${notificationResponse.id} payload ${notificationResponse.payload} input ${notificationResponse.input}");
        final String? payload = notificationResponse.payload;
        if (notificationResponse.payload != null) {
          final String? payload = notificationResponse.payload;
          debugPrint('notification payload: ${payload} ');

          getNotificationAppLaunchDetails();
        }
        //  Navigator.push(
        //    GlobalKey<NavigatorState>().currentContext!,
        //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
        // );
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,



    );

    notification.getActiveNotifications().then((value) {
      print("notifications is ${value.length}");
    });
  }


  Future showNotification({required int id, required String title, required String body,  required String payload}) async {
    // print(" showNotification id is ${id}");
    // notification.getActiveNotifications().then((value) {
    //   print("notifications is ${value.length} ");
    //   value.forEach((e) {
    //
    //     print("notifications is ${e.payload} ${e.body} ${e.title} ${e.channelId} ${e.id} ${e.groupKey}");
    //   });
    // });
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await notification.show(id++, 'plain title', 'plain body', notificationDetails, payload: 'data with payload paramater');
    // return notification.show(id++, title, body, await notificationDetails());

  }

    void getNotificationAppLaunchDetails() async{
    await notification.getNotificationAppLaunchDetails().then((value){
      print("getNotificationAppLaunchDetails payload ${value!.notificationResponse!.payload} id  ${value!.notificationResponse!.id} ");
    });
}



  notificationDetails() {

    return const NotificationDetails(android:
    AndroidNotificationDetails(
        'channelId', 'channel name', importance: Importance.max,enableLights: true,), iOS: DarwinNotificationDetails());



  }

  @pragma('vm:entry-point')
  static  notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notificationTapBackground s(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print('notification action tapped with input: ${notificationResponse.input}');
    }
  }

    Future<void> _showNotificationWithActions() async {
      const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('...', '...',
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('id_1', 'Action 1'),
          AndroidNotificationAction('id_2', 'Action 2'),
          AndroidNotificationAction('id_3', 'Action 3'),
        ],
      );
      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
      await notification.show(0, '...', '...', notificationDetails);
    }


}
