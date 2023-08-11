import 'package:firebaseflutterproject/user_intefaces/notification_services.dart';
import 'package:flutter/material.dart';
class Firebase_notify_screen extends StatefulWidget {
  const Firebase_notify_screen({Key? key}) : super(key: key);

  @override
  State<Firebase_notify_screen> createState() => _Firebase_notify_screenState();
}

class _Firebase_notify_screenState extends State<Firebase_notify_screen> {
  NotificationServices notificationServices=NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      print("FCM TOKEN IS ${value}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("nf"),
      ),

    );
  }
}
