import 'package:firebaseflutterproject/stateManagement/statemanagement.dart';
import 'package:firebaseflutterproject/user_intefaces/notification_settings.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  NotificationService notify = NotificationService();
  String value = "Aqsa";

  showCreateTicketBottomSheet() {
    Size size = MediaQuery.of(context).size;
    // value="aqsa";
    showModalBottomSheet(
        //     backgroundColor: Colors.pink.withOpacity(0.5),
        barrierColor: Colors.black.withOpacity(0.5),
        isScrollControlled: true,
        context: context,
        enableDrag: true,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 200,
              // padding:
              // EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${value}"),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text("this is label"),
                        // hintText: "hint text"
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Splash Screen"),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  showCreateTicketBottomSheet();
                },
                child: Text("check bottom sheet")),
            ElevatedButton(
                onPressed: () {
                  NotificationService().showNotification(title: "sample title", body: "body");
                },
                child: const Text("Notification check")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Statemanagement()));
                },
                child: const Text("Statemanement Case Study")),
          ],
        ));
  }
}
