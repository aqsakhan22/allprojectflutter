import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/running_buddies.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

import '../providers/all_programs_provider.dart';
import '../providers/clubs_provider.dart';

class SearchAll extends StatefulWidget {
  const SearchAll({Key? key}) : super(key: key);

  @override
  State<SearchAll> createState() => _SearchAllState();
}

class _SearchAllState extends State<SearchAll> {
  late RunningBuddiesProvider RBprovider;
  late ClubsProvider clubsProvider;
  late AllPrograms allprograms;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List searchAll = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RBprovider.getRunningBuddies({});
      clubsProvider.getClubs({"Search_ClubTitle": "", "Status": "All"});
      allprograms.Allprograms({});
      searchAll = RBprovider.Buddies;
    });
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    print("entered value is ${enteredKeyword}");
    List results = [];
    if (enteredKeyword.isEmpty) {
      print("Keyword is empty");
      // if the search field is empty or only contains white-space, we'll display all users
      results = RBprovider.Buddies;
      searchAll = RBprovider.Buddies;
    } else {
      results = searchAll.where((user) {
        return user["UserName"].toLowerCase().contains(enteredKeyword.toLowerCase());
      }).toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchAll = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    RBprovider = Provider.of<RunningBuddiesProvider>(context);
    clubsProvider = Provider.of<ClubsProvider>(context);
    allprograms = Provider.of<AllPrograms>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      appBar: AppBarWidget.textAppBar("SEARCH"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onChanged: (value) {
                Map<String, dynamic> runners = {"Search_RunnerTitle": value.toLowerCase().toString()};
                Map<String, dynamic> clubs = {"Search_ClubTitle": value.toLowerCase().toString(), "Status": "All"};
                Map<String, dynamic> programs = {"Search_ProgramTitle": value.toLowerCase().toString()};
                RBprovider.getRunningBuddies(runners);
                clubsProvider.getClubs(clubs);
                allprograms.Allprograms(programs);
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.transparent)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Type your search here",
                  hintStyle: TextStyle(fontSize: 14),
                  suffixIcon: Icon(
                    Icons.filter_alt,
                    color: CustomColor.grey_color,
                  )
                  ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Persons",
              style: TextStyle(color: CustomColor.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Consumer<RunningBuddiesProvider>(builder: (context, buddiesDetails, child) {
                buddiesDetails.Buddies.isEmpty
                    ? child = Text(
                        "No Buddies",
                        style: TextStyle(color: Colors.white),
                      )
                    : child = Container(
                        height: 150,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: buddiesDetails.Buddies.length,
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap:(){
                                  Navigator.pushNamed(context, '/RunningBuddies');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                        width: 120,
                                        height: 120,
                                        margin: EdgeInsets.only(right: 5.0),
                                        padding: EdgeInsets.only(right: 5.0),
                                        child: buddiesDetails.Buddies[index]['ProfilePhoto'] != null
                                            ? Image.network(
                                                "${AppUrl.mediaUrl}${buddiesDetails.Buddies[index]['ProfilePhoto']}",
                                                height: 120,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return const Center(
                                                      child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                                    child: CircularProgressIndicator(
                                                      color: CustomColor.white,
                                                    ),
                                                  ));
                                                },
                                              )
                                            : Image.asset(
                                                "assets/default_image.jpg", height: 120, fit: BoxFit.cover,
                                                //height: 100,
                                              )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        width: 120,
                                        child: Text(
                                          "${buddiesDetails.Buddies[index]['UserName']}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: CustomColor.white, fontWeight: FontWeight.w700, fontSize: 10),
                                        ))
                                  ],
                                ),
                              );
                            })
                        );
                return child;
              }),
            ),
            Text(
              "Clubs",
              style: TextStyle(color: CustomColor.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Consumer<ClubsProvider>(builder: (context, clubsDetails, child) {
                clubsDetails.clubsList.isEmpty
                    ? child = Text(
                        "No Clubs",
                        style: TextStyle(color: Colors.white),
                      )
                    : child = Container(
                        height: 150,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: clubsDetails.clubsList.length,
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap:(){
                                  Navigator.pushNamed(context, '/Clubs');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                        width: 120,
                                        height: 120,
                                        margin: EdgeInsets.only(right: 5.0),
                                        padding: EdgeInsets.only(right: 5.0),
                                        child: clubsDetails.clubsList[index]['ProfilePhoto'] != null
                                            ? Image.network(
                                                "${AppUrl.mediaUrl}${clubsDetails.clubsList[index]['BannerImage']}",
                                                height: 120,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return const Center(
                                                      child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                                    child: CircularProgressIndicator(
                                                      color: CustomColor.white,
                                                    ),
                                                  ));
                                                },
                                              )
                                            : Image.asset(
                                                "assets/default_image.jpg",
                                                height: 120,
                                                fit: BoxFit.cover,
                                              )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        width: 120,
                                        child: Text(
                                          "${clubsDetails.clubsList[index]['Title']}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: CustomColor.white, fontWeight: FontWeight.w700, fontSize: 10),
                                        ))
                                  ],
                                ),
                              );
                            }));
                return child;
              }),
            ),
            Text(
              "Programs",
              style: TextStyle(color: CustomColor.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(child: Consumer<AllPrograms>(builder: (context, programs, child) {
              programs.Programs.isEmpty
                  ? child = Text(
                      "No Programs",
                      style: TextStyle(color: Colors.white),
                    )
                  : child = Container(
                      height: 150,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: programs.Programs.length,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap:(){
                                Navigator.pushNamed(context, '/RunningProgram');
                              },
                              child: Column(
                                children: [
                                  Container(
                                      width: 120,
                                      height: 120,
                                      margin: EdgeInsets.only(right: 5.0),
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: programs.Programs[index]['Banner'] != null
                                          ? Image.network(
                                              "${AppUrl.mediaUrl}${programs.Programs[index]['Banner']}",
                                              height: 120,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return const Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                                  child: CircularProgressIndicator(
                                                    color: CustomColor.white,
                                                  ),
                                                ));
                                              },
                                            )
                                          : Image.asset(
                                              "assets/default_image.jpg", height: 120, fit: BoxFit.cover,
                                              //height: 100,
                                            )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      width: 120,
                                      child: Text(
                                        "${programs.Programs[index]['Title']}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: CustomColor.white, fontWeight: FontWeight.w700, fontSize: 10),
                                      ))
                                ],
                              ),
                            );
                          }),
                    );
              return child;
            }))
          ],
        ),
      ),
    );
  }
}
