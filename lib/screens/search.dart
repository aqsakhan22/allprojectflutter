import 'package:flutter/material.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

class SearchClubs extends StatefulWidget {
  const SearchClubs({Key? key}) : super(key: key);

  @override
  State<SearchClubs> createState() => _SearchClubsState();
}

class _SearchClubsState extends State<SearchClubs> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      drawer: MyNavigationDrawer(),
      appBar: AppBarWidget.textAppBar('COMMUNITY'),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TextFormField(
              //   style: TextStyle(color: Colors.black),
              //   decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //          borderSide: BorderSide(color: Colors.transparent)
              //       ),
              //       fillColor: Colors.white,
              //       filled: true,
              //     hintText: "Type your search here",
              //     hintStyle: TextStyle(fontSize: 14),
              //     suffixIcon: Icon(Icons.filter_alt_sharp,color: Colors.grey[400],)
              //   ),
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              Image.asset("assets/RunWith-WhiteLogo.png", width: 150),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonWidget(
                    onPressed: () {
                      Navigator.pushNamed(context, "/socialfeed");
                    },
                    size: size,
                    title: "SOCIAL FEED",
                  ),
                  buttonWidget(
                    size: size,
                    title: "CLUBS",
                    onPressed: () {
                      Navigator.pushNamed(context, "/Clubs");
                    },
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonWidget(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chatForum');
                    },
                    size: size,
                    title: "COMMUNITY",
                  ),
                  buttonWidget(
                      onPressed: () {
                        Navigator.pushNamed(context, "/RunningBuddies");
                      },
                      size: size,
                      title: "RUNNING BUDDIES")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class buttonWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;

  const buttonWidget({
    Key? key,
    this.title,
    this.onPressed,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: size.height * 0.1,
        width: size.width * 0.35,
        decoration: BoxDecoration(color: CustomColor.grey_color, borderRadius: BorderRadius.circular(10.0)),
        child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "${title}",
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.2, color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                ))),
      ),
    );
  }
}
