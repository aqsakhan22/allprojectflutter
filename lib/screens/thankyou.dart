import 'package:flutter/material.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../widget/app_bar_widget.dart';

class ThankYou extends StatefulWidget {
  const ThankYou({Key? key}) : super(key: key);

  @override
  State<ThankYou> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      key: _key,
      bottomNavigationBar: BottomNav(scaffoldKey: _key,),
      appBar: AppBarWidget.textAppBar('THANK YOU'),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.red,
                      // height: 100,
                      alignment: Alignment.center,
                      child: Image.asset("assets/RunWith-WhiteLogo.png",height: 100,)),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(width: 50, child: Image.asset("assets/thankyou.png")),
                  SizedBox(
                    height:size.height * 0.02 ,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Thank You!",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
                      )),
                  SizedBox(
                    height:size.height * 0.1 ,
                  ),
                  Text(
                    "Share this app with your buddy",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Share.share("Share This RunWith App With Your Friends To Join Club");
                        },
                        child: Image.asset("assets/facebookbtn.png", width:40, height:40,),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Share.share("Share This RunWith App With Your Friends To Join Club");
                        },
                        child: Image.asset("assets/instagrambtn.png", width:40, height:40,),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Share.share("Share This RunWith App With Your Friends To Join Club");
                        },
                        child: Image.asset("assets/twitterbtn.png", width:40, height:40,),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Share.share("Share This RunWith App With Your Friends To Join Club");
                        },
                        child: Image.asset("assets/linkedinbtn.png", width:40, height:40,),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Share.share("Share This RunWith App With Your Friends To Join Club");
                        },
                        child: Image.asset("assets/ShareMessenger.png", width:35, height:35,),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Share.share("Share This RunWith App With Your Friends To Join Club");
                        },
                        child: Image.asset("assets/ShareSMS.png", width:40, height:40,),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
