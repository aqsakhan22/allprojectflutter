import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initNotification() async{
    AndroidInitializationSettings initializationSettingsAndroid=const AndroidInitializationSettings('ng_pro_splash');
    var initializeSettingsIOS=DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id,String? title,String? body,String? payload)
      async{

      }


    );
    var initializeSettings=InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializeSettingsIOS
    );

   await notificationsPlugin.initialize(
       initializeSettings,
     onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async{}

   );

  }
  Future showNotification({int id=0,String? title,String? body,String? payload}) async{
    return notificationsPlugin.show(id, title, body, await notificationDetails());

  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId','channelName',importance: Importance.max),
      iOS: DarwinNotificationDetails()
    );
  }

}