import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runwith/widget/button_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GlobalKey _textKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => askPermission(context));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            child: RichText(
                key: _textKey,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                      text: "By signing up, you agree to Run With’s "),
                  TextSpan(
                      style: TextStyle(color: Color(0xff5EA7FF), fontSize: 14, fontWeight: FontWeight.w400),
                      text: "Terms of Service and Privacy Policy",
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, "/privaypolicy")),
                ])),
          ),
          elevation: 0,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/RunWith-WhiteLogo.png",
              width: 200,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: size.width * 0.8,
              alignment: Alignment.center,
              child: Text(
                "No matter where you are in the world, there's a large community of runners ready to run with you",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.2, color: Colors.white, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ButtonWidget(
              btnWidth: size.width * 0.7,
              btnHeight: 40,
              onPressed: () {
                Navigator.pushNamed(context, "/SignUp");
              },
              color: Colors.white,
              text: "New Account Creation",
              textcolor: Colors.black,
              fontSize: 16,
              fontweight: FontWeight.w600,
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/SignIn");
              },
              child: Text(
                "Already have an account?",
                style: TextStyle(
                    color: Colors.white, decoration: TextDecoration.underline, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            )
          ],
        )));
  }
  //
  // askPermission(BuildContext context) async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.notification,
  //     Permission.location,
  //     Permission.mediaLibrary,
  //     Permission.scheduleExactAlarm,
  //     Permission.locationAlways,
  //     Permission.accessMediaLocation,
  //     Permission.locationWhenInUse,
  //     Permission.audio
  //   ].request();
  //   print("PERMISSION OF notification IS ${statuses[Permission.notification]}");
  //   print("PERMISSION OF location IS ${statuses[Permission.location]}");
  //   print("PERMISSION OF mediaLibrary IS ${statuses[Permission.mediaLibrary]}");
  //   print("PERMISSION OF scheduleExactAlarm IS ${statuses[Permission.scheduleExactAlarm]}");
  //   print("PERMISSION OF locationAlways IS ${statuses[Permission.locationAlways]}");
  //   print("PERMISSION OF accessMediaLocation IS ${statuses[Permission.accessMediaLocation]}");
  //   print("PERMISSION OF locationWhenInUse IS ${statuses[Permission.locationWhenInUse]}");
  //   print("PERMISSION OF audio IS ${statuses[Permission.audio]}");
  //
  // }
}
