import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificationflutter/exampleNototifications.dart';
import 'package:notificationflutter/utility/topVariable.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Future<void> notify() async{
    print("notify called");
    WidgetsFlutterBinding.ensureInitialized();

    NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
      // move to pdf screen
      Navigator.push(TopVariables.appNavigationKey.currentContext!,
          MaterialPageRoute(builder: (context) => SecondPage(selectedNotificationPayload)));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

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

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
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
    final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
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
    Future.delayed(
      const Duration(seconds: 1),
          (){
        Navigator.push(TopVariables.appNavigationKey.currentContext!,
            MaterialPageRoute(builder: (context) => HomePage(notificationAppLaunchDetails)));
      },
    );
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      notify();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("SplashScreen"),),
      body: const Column(
        children: [
          Text("SplashScreen")
        ],
      ),
    );
  }
}
