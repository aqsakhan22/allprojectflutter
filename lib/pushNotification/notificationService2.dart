import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificationflutter/utility/topVariable.dart';

import '../notificationGit/ReceivedNotification.dart';
import '../notificationGit/SecondPage.dart';


class NotificationServiceEx {

// initilzation of flutter notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();
  // This is not woprking and no need we have to attach this
  @pragma('vm:entry-point')
  static notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notificationTapBackground(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print('notification action tapped with input: ${notificationResponse.input}');
    }
  }
  /// Defines a iOS/MacOS notification category for text input actions.
  String darwinNotificationCategoryText = 'textCategory';
  /// Defines a iOS/MacOS notification category for plain actions.
  String darwinNotificationCategoryPlain = 'plainCategory';
   String navigationActionId = 'id_3';
  String? selectedNotificationPayload;
  final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();



  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher');


    final List<DarwinNotificationCategory> darwinNotificationCategories =
    <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        print("onDidReceiveNotificationResponse ${notificationResponse.notificationResponseType} ${notificationResponse.payload}");
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            // PersistentNavBarNavigator.pushNewScreen(
            //   TopVariables.appNavigationKey.currentContext!,
            //   screen: PDFCheck(fileUrl: "http://15.206.35.78/uploads/research/", imageUrl: "", docpath: '4009742751702365599.pdf',
            //
            //   ),
            //   withNavBar: false,
            //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
            // );
            Navigator.push(TopVariables.appNavigationKey.currentContext!,
                MaterialPageRoute(builder: (context) => SecondPage(notificationResponse.payload)));
            print("selectedNotificationPayload ${selectedNotificationPayload} ${notificationResponse.payload}");

            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> showNewNotification(int id,String title,String body) async {
    print("Id is ${id} title ${title} body ${body}");


    const NotificationDetails notificationDetails =
           NotificationDetails(
        android:AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'),
        iOS:DarwinNotificationDetails()

           );
    await flutterLocalNotificationsPlugin.show(id++, title, body, notificationDetails, payload: "{'hello':world}${title}");

  }


}