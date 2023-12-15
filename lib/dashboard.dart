// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'notificationExamples/ReceivedNotification.dart';
// import 'notificationExamples/SecondPage.dart';
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
//   StreamController<ReceivedNotification>.broadcast();
//   bool _notificationsEnabled = false;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _isAndroidPermissionGranted();
//     _requestPermissions();
//     _configureDidReceiveLocalNotificationSubject();
//     _configureSelectNotificationSubject();
//   }
//
//   Future<void> _isAndroidPermissionGranted() async {
//     if (Platform.isAndroid) {
//       final bool granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.areNotificationsEnabled() ??
//           false;
//
//       setState(() {
//         _notificationsEnabled = granted;
//       });
//     }
//   }
//
//   Future<void> _requestPermissions() async {
//     if (Platform.isIOS || Platform.isMacOS) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     } else if (Platform.isAndroid) {
//       final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//       flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//
//       final bool? grantedNotificationPermission =
//       await androidImplementation?.requestNotificationsPermission();
//       setState(() {
//         _notificationsEnabled = grantedNotificationPermission ?? false;
//       });
//     }
//   }
//
//   void _configureDidReceiveLocalNotificationSubject() {
//     didReceiveLocalNotificationStream.stream
//         .listen((ReceivedNotification receivedNotification) async {
//       await showDialog(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//           title: receivedNotification.title != null ? Text(receivedNotification.title!) : null,
//           content: receivedNotification.body != null ? Text(receivedNotification.body!) : null,
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               onPressed: () async {
//                 Navigator.of(context, rootNavigator: true).pop();
//                 await Navigator.of(context).push(
//                   MaterialPageRoute<void>(
//                     builder: (BuildContext context) => SecondPage(receivedNotification.payload),
//                   ),
//                 );
//               },
//               child: const Text('Ok'),
//             )
//           ],
//         ),
//       );
//     });
//   }
//
//   void _configureSelectNotificationSubject() {
//     selectNotificationStream.stream.listen((String? payload) async {
//       await Navigator.of(context).push(MaterialPageRoute<void>(
//         builder: (BuildContext context) => SecondPage(payload),
//       ));
//     });
//   }
//
//   @override
//   void dispose() {
//     didReceiveLocalNotificationStream.close();
//     selectNotificationStream.close();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Dashboard Exampe"),),
//       body:Column(
//         children: [
//           Text("We are configuiring push notifications"),
//           _InfoValueString(
//             title: 'Did notification launch app?',
//             value: widget.didNotificationLaunchApp,
//           ),
//           if (widget.didNotificationLaunchApp) ...<Widget>[
//             const Text('Launch notification details'),
//             _InfoValueString(
//                 title: 'Notification id',
//                 value: widget.notificationAppLaunchDetails!.notificationResponse?.id),
//             _InfoValueString(
//                 title: 'Action id',
//                 value: widget.notificationAppLaunchDetails!.notificationResponse?.actionId),
//             _InfoValueString(
//                 title: 'Input',
//                 value: widget.notificationAppLaunchDetails!.notificationResponse?.input),
//             _InfoValueString(
//               title: 'Payload:',
//               value: widget.notificationAppLaunchDetails!.notificationResponse?.payload,
//             ),
//           ],
//           PaddedElevatedButton(
//             buttonText: 'Show plain notification with payload',
//             onPressed: () async {
//               await _showNotification();
//             },
//           ),
//         ],
//       )
//     );
//
//   }
// }
