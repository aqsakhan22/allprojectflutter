import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../notificationGit/ReceivedNotification.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}

final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
StreamController<ReceivedNotification>.broadcast();
String? selectedNotificationPayload;
/// Defines a iOS/MacOS notification category for text input actions.
String darwinNotificationCategoryText = 'textCategory';
/// Defines a iOS/MacOS notification category for plain actions.
String darwinNotificationCategoryPlain = 'plainCategory';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';