import 'package:flutter/material.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';

class ClubProfile extends StatefulWidget {
  final int? index;
  final String? name;
  final String? imageName;
  final String? desc;
  final String? Id;
  final bool? isMember;

  const ClubProfile({Key? key, this.index, this.name, this.imageName, this.desc, this.Id, this.isMember}) : super(key: key);

  @override
  State<ClubProfile> createState() => _ClubProfileState();
}

class _ClubProfileState extends State<ClubProfile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List clubsMembers = [];
  bool isMember = false;
  bool isLoader = false;

  Future<void> clubMembers() async {
    try {
      final Map<String, dynamic> reqData = {'Club_ID': widget.Id};
      print("reqData is clubs memebers ${reqData}");
      GeneralResponse response = await AppUrl.apiService.clubmembers(reqData);
      print("Receiving Data from Dashboard: ${response.toString()}");
      setState(() {
        isLoader = true;
      });
      if (response.status == 1) {
        setState(() {
          isLoader = false;
        });
        print("Data Received Successfully from CLUB MEMEBRS: ${response.data}");
        clubsMembers = response.data as List;
        List CheckedMember = clubsMembers.where((element) => element['ID'].toString() == widget.Id.toString()).toList();

        // clubsMembers.forEach((element) {
        //   if (element['ID'].toString() == widget.Id.toString()) {
        //     print("Both are equal ${element}");
        //     setState(() {
        //       isMember = true;
        //     });
        //   }
        //   print("Both are not equal ${element}");
        // });

        setState(() {
          clubsMembers = response.data as List;
        });
        print("club list is  ${clubsMembers}");
        // UserPreferences.set_Profiledata(response.data);
      } else {
        setState(() {
          isLoader = false;
        });
        print("Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      clubMembers();
      print("${widget.name} - ${widget.isMember} - ${widget.Id} - ${widget.desc} - ${widget.imageName} - ${widget.index}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      appBar: AppBarWidget.textAppBar('CLUBS'),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.network("${widget.imageName}"),
              height: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${widget.name}",
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
            ),
            Text(
              "ID: ${widget.Id}",
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${widget.desc}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CLUB OFFERING:",
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Social Runs, Group Strength Sessions, Social Events, Courses and Seminars..",
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ],
            )),
            SizedBox(
              height: 30,
            ),
            //Members
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MEMBERS:",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                //MEMBERS
                Container(
                    height: size.height * 0.4,
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: isLoader == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: CustomColor.white,
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              itemCount: clubsMembers.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 3.0),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center, // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: clubsMembers[index]['ProfilePhoto'] == null
                                          ? Image.asset(
                                              "assets/raw_profile_pic.png",
                                              height: 50,
                                            )
                                          : Image.network(
                                              "${AppUrl.mediaUrl}${clubsMembers[index]['ProfilePhoto']}",
                                              width: 45,
                                              height: 45,
                                              fit: BoxFit.cover
                                            ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${clubsMembers[index]['FullName'].toString().substring(0,(clubsMembers[index]['FullName'].toString().length > 15 ? 15 : clubsMembers[index]['FullName'].toString().length))}",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10),
                                          ),
                                          Text(
                                            "${clubsMembers[index]['Type']}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                              }),
                    )),
                widget.isMember == true
                    ? Container(
                        alignment: Alignment.center,
                        child: ButtonWidget(
                          btnWidth: 250,
                          color: CustomColor.grey_color,
                          onPressed: () async {
                            try {
                              Map<String, dynamic> reqBody = {"Club_ID": "${widget.Id.toString()}", "Status": "Left"};
                              GeneralResponse response = await AppUrl.apiService.joinclub(reqBody);
                              if (response.status == 1) {
                                TopFunctions.showScaffold("${response.message}");
                              }
                            } catch (e) {
                              print("EXCEPTION JOIN CLUB");
                            }
                          },
                          text: "LEAVE CLUB",
                          textcolor: Colors.black,
                          fontweight: FontWeight.w800,
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: ButtonWidget(
                          btnWidth: 250,
                          color: CustomColor.grey_color,
                          onPressed: () async {
                            try {
                              Map<String, dynamic> reqBody = {"Club_ID": "${widget.Id.toString()}", "Status": "Pending"};
                              GeneralResponse response = await AppUrl.apiService.joinclub(reqBody);
                              if (response.status == 1) {
                                TopFunctions.showScaffold("${response.message}");
                              }
                            } catch (e) {
                              print("EXCEPTION JOIN CLUB");
                            }
                          },
                          text: "REQUEST TO JOIN CLUB",
                          textcolor: Colors.black,
                          fontweight: FontWeight.w800,
                        ),
                      ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}