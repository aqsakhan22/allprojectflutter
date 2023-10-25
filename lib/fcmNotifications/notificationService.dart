import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


// Fcm Notification service with image
//https://stackoverflow.com/questions/71053724/flutter-local-notifications-plugin-not-showing-the-big-image-in-notification

class FcmNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher');
    var initializeSettingsIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true, onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
    var initializeSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializeSettingsIOS);
    await notificationsPlugin.initialize(initializeSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  Future showNotification({int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }







  notificationDetails() async{
    final String largeIconPath = await _downloadAndSaveFile(
      'https://miro.medium.com/v2/resize:fit:1400/format:webp/1*kivF0sVd3ixwWNa98oGqtg.png',
      'largeIcon',
    );
    final String bigPicturePath = await _downloadAndSaveFile(
      "https://miro.medium.com/v2/resize:fit:1400/format:webp/1*kivF0sVd3ixwWNa98oGqtg.png",
      'bigPicture',
    );

    return  NotificationDetails(android:
    AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      // channelDescription: 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: false,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true,
      ),
    ),
        iOS: DarwinNotificationDetails());
  }
}


Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory? directory = await getExternalStorageDirectory();
  final String filePath = '${directory!.path}/$fileName.png';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}