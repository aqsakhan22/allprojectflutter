import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwith/dialog/progress_dialog.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/clubs_provider.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';

class RunningGear extends StatefulWidget {
  const RunningGear({Key? key}) : super(key: key);

  @override
  State<RunningGear> createState() => _RunningGearState();
}

class _RunningGearState extends State<RunningGear> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late ClubsProvider clubsProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      clubsProvider.myClubs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    clubsProvider = Provider.of<ClubsProvider>(context);
    return Scaffold(
        key: _key,
        drawer: MyNavigationDrawer(),
        appBar: AppBarWidget.textAppBar("MY ACCOUNT"),
        bottomNavigationBar: BottomNav(
          scaffoldKey: _key,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // My Joined Clubs
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Consumer<ClubsProvider>(
                    builder: (context, clubsDetails, child) {
                      if (clubsDetails.myClubsList.isNotEmpty) {
                        child = Container(
                          width: size.width * 1,
                          height: 50,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: clubsDetails.myClubsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 60,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 25,
                                    child: GestureDetector(
                                      onTap: () {
                                        CustomProgressDialog.showProDialog();
                                        Map<String, dynamic> reqBody = {"Club_ID": clubsDetails.myClubsList[index]['Club_ID']};
                                        clubsProvider!.clubActivate(reqBody).then((value) => CustomProgressDialog.hideProDialog());
                                      },
                                      child: CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: clubsDetails.myClubsList[index]['BannerImage'] != null
                                              ? NetworkImage("${AppUrl.mediaUrl}${clubsDetails.myClubsList[index]['BannerImage']}")
                                              : AssetImage('assets/logo.png') as ImageProvider,
                                      ),
                                           ),
                                    ),
                                );
                              }),
                        );
                      }
                      else{
                        child = Text("No Data",style: TextStyle(color: Colors.white),);

                      }
                      return child;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 40,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/raw_profile_pic.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Runs:",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "0 Km",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Followers:",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "0",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Following:",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "0",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Events:",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "0",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Running Level:",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "0",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: size.width * 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${UserPreferences.get_Profiledata()['FullName'] == null ? "UserName" : UserPreferences.get_Profiledata()['FullName']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          // ButtonWidget(
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, '/MyProfile');
                          //   },
                          //   text: "Edit Profile",
                          //   color: CustomColor.grey_color,
                          //   textcolor: Colors.black,
                          //   fontSize: 12,
                          //   fontweight: FontWeight.w800,
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${UserPreferences.get_Profiledata()['Designation'] ?? "" }",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RUNNING GEAR",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                    ButtonWidget(
                      btnWidth: size.width * 0.5,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/AddGear',
                        );
                      },
                      text: "ADD RUNNING GEAR",
                      color: CustomColor.grey_color,
                      textcolor: Colors.black,
                      fontSize: 12,
                      fontweight: FontWeight.w800,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/GearList');
                      },
                      child: Container(
                          height: 100,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(11.0),
                            image: DecorationImage(
                              opacity: 0.7,
                              image: AssetImage("assets/shoes.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'SHOES',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          )
                          ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/GearList');
                      },
                      child: Container(
                          height: 100,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(11.0),
                            image: DecorationImage(
                              opacity: 0.7,
                              image: AssetImage("assets/shirts.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'SHIRTS',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          )
                          ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/GearList');
                      },
                      child: Container(
                          height: 100,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(11.0),
                            image: DecorationImage(
                              opacity: 0.7,
                              image: AssetImage("assets/hydration.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'HYDRATION',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                          )
                          ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/GearList');
                      },
                      child: Container(
                          height: 100,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(11.0),
                            image: DecorationImage(
                              opacity: 0.7,
                              image: AssetImage("assets/shorts.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'SHORTS',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                          )
                          ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
