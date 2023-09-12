import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/screens/SpotifyExample/OldDebugging.dart';
import 'package:runwith/screens/welcome.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/shared_preference.dart';

import '../utility/top_level_variables.dart';
import 'SpotifyExample/Debugging.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  ImagePicker imagePicker = ImagePicker();
  String sampleimage = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      width: 250,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: size.width * 1,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Logo
                Container(
                    padding: EdgeInsets.only(top: 40, left: 10), height: 70, child: Image.asset('assets/RunWith-BlackLogo.png')),
                //Profile Pic
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(TopVariables.appNavigationKey.currentState!.context, '/MyProfile');
                  },
                  child: ClipOval(
                    child: Material(
                      child: UserPreferences.get_Profiledata()['ProfilePhoto'] == null
                          ? Image.asset(
                              "assets/raw_profile_pic.png",
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                          : Image.network('${AppUrl.mediaUrl}${UserPreferences.get_Profiledata()['ProfilePhoto']}',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }),
                    ),
                  ),
                ),
                //Username/Email
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        UserPreferences.get_Login()['UserName'],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12),
                      ),
                      Text(
                        UserPreferences.get_Login()['Email'],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                //Menu List
                Container(
                  color: CustomColor.grey_color,
                  height: size.height * 1,
                  child: Column(
                    children: [
                      //Home
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/Home');
                        },
                        horizontalTitleGap: 5,
                        leading: Image.asset(
                          'assets/Home.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Home",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      //Running Buddies
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () {
                          Navigator.pushNamed(context, '/RunningBuddies');
                        },
                        leading: Image.asset(
                          'assets/Run-Black.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Running Buddies",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      //Share
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () {
                          Navigator.pushNamed(context, '/Thankyou');
                        },
                        leading: Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Share",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      //Subscription
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () {
                          Navigator.pushNamed(context, '/Home');
                        },
                        leading: Image.asset(
                          'assets/Subscription.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Subscription",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Run History
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () {
                          Navigator.pushNamed(context, "/RunningProgram");
                        },
                        leading: Image.asset(
                          'assets/MyRunHistory.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "My Program",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      //Run Events
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () {
                          Navigator.pushNamed(context, "/RunHistory");
                        },
                        leading: Image.asset(
                          'assets/MyRunHistory.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "My Runs History",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Policy
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () {
                          Navigator.pushNamed(context, "/privaypolicy");
                        },
                        leading: Image.asset(
                          'assets/Policy.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Policies",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Policy
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () {
                          Navigator.pushNamed(context, "/Feedback");
                        },
                        leading: Image.asset(
                          'assets/Feedback.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Leave us Feedback",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      //Logout
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () async {
                          final response = await AppUrl.apiService.logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${response.message}")),
                          );
                          if (response.status == 1) {
                            TopVariables.service.invoke('stopService');
                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (context) => WelcomeScreen()), (route) => false);
                          }
                        },
                        leading: Image.asset(
                          'assets/Logout.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Logout",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),

                      //Debugging
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () async {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => SpotifyExample()), (route) => false);
                        },
                        leading: Image.asset(
                          'assets/Logout.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Debugging",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      //Debugging
                      ListTile(
                        horizontalTitleGap: 5,
                        onTap: () async {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => OldDebugging()), (route) => false);
                        },
                        leading: Image.asset(
                          'assets/Logout.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          "Old Debugging",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
