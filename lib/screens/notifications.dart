import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwith/providers/notification_provider.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late NotificationProvider notificationProvider;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notificationProvider.getNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBarWidget.textAppBar('NOTIFICATION'),
      drawer: MyNavigationDrawer(),
      resizeToAvoidBottomInset: false,
      key: _key,
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: Container(
          child: Stack(
        children: [
          Container(
            child: Consumer<NotificationProvider>(
              builder: ((context, notificationData, child) {
                child = notificationData.notifications.isEmpty
                    ? Center(
                        child: Center(
                        child: Text(
                          "No Notifications",
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: notificationData.notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: ListTile(
                                onTap: () {
                                    if(notificationData.notifications[index]['Type'] == "FriendNotification"){
                                     Navigator.pushNamed(context, '/RunningBuddies');
                                    }
                                    if(notificationData.notifications[index]['Type'] == "ChatNotification"){
                                      Navigator.pushNamed(context, '/Chats');
                                    }
                                  },
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  child: Image.asset(
                                    "assets/RunWith_Icon.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  "${notificationData.notifications[index]['Title']}",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                subtitle: Text(
                                  "${notificationData.notifications[index]['Description']}",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                trailing: Icon(
                                  Icons.circle_notifications_rounded,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                              )
                              );
                        });
                return child;
              }),
            ),
          )
        ],
      )),
    );
  }
}
