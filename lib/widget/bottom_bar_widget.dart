import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BottomNav({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                child: InkWell(
              onTap: () {
                print("open drawer");
                scaffoldKey.currentState!.openDrawer();
              },
              child: Image.asset(
                "assets/Menu.png",
                width: 40,
                height: 40,
              ),
            )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Notifications');
                },
                icon: Image.asset(
                  "assets/Bell.png",
                  width: 40,
                  height: 40,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/SearchAll');
                },
                icon: Image.asset(
                  "assets/MagnifyingGlass.png",
                  width: 40,
                  height: 40,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/socialfeed');
                },
                icon: Image.asset(
                  "assets/SocialFeed.png",
                  width: 40,
                  height: 40,
                )),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/StartRun');
              },
              icon: Image.asset(
                "assets/Run.png",
                width: 40,
                height: 40,
              ),
            )
          ],
        ));
  }
}
