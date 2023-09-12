import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/clubs_provider.dart';
import 'package:runwith/screens/Clubs/club_profile.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/utility/ProvidersUtility.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

import '../../widget/app_bar_widget.dart';

class Clubs extends StatefulWidget {
  const Clubs({Key? key}) : super(key: key);

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> club_key = GlobalKey<ScaffoldState>();
  ClubsProvider? clubsProvider;
  List _foundClubs = [];
  bool isLoader = false;

  @override
  void initState() {
    clubsProvider = ProvidersUtility.clubProvider;
    setState(() {
      isLoader = true;
    });
    clubsProvider!.getClubs({"Search_ClubTitle": "", "Status": "All"}).then((value) {
      setState(() {
        isLoader = false;
        _foundClubs = clubsProvider!.clubsList;
      });
      print("All Clubs List = ${_foundClubs}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: club_key,
      drawer: MyNavigationDrawer(),
      appBar: AppBarWidget.textAppBar('ALL CLUBS'),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (enteredKeyword) {
                print("Search Value Is = ${enteredKeyword}");
                List results = [];
                if (enteredKeyword.isEmpty) {
                  // if the search field is empty or only contains white-space, we'll display all users
                  results = clubsProvider!.clubsList;
                }
                else {
                  results = clubsProvider!.clubsList
                      .where((user) => user["Title"].toLowerCase().contains(enteredKeyword.toLowerCase()))
                      .toList();
                  // we use the toLowerCase() method to make it case-insensitive
                }
                // Refresh the UI
                setState(() {
                  _foundClubs = results;
                });
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
                    Icons.filter_alt_sharp,
                    color: Colors.grey[400],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(child: Consumer<ClubsProvider>(builder: (context, clubsDetails, child) {
              isLoader == true
                  ? child = Center(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ))
                  : child = Expanded(
                      child: _foundClubs.isEmpty
                          ? Text(
                              'No results found',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                          : ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _foundClubs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ClubProfile(
                                                  index: index,
                                                  name: "${_foundClubs[index]['Title']}",
                                                  imageName: "${AppUrl.mediaUrl}${_foundClubs[index]['BannerImage']}",
                                                  desc: "${_foundClubs[index]['Description']}",
                                                  Id: "${_foundClubs[index]['ID']}",
                                                  isMember: _foundClubs[index]['JoinedUser_ID'] == null ? false :  true,
                                                )));
                                  },
                                  contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  minVerticalPadding: 0,
                                  horizontalTitleGap: 0,
                                  leading: Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage("${AppUrl.mediaUrl}${_foundClubs[index]['BannerImage']}"),
                                      )
                                      // Image.asset(
                                      //   "assets/raw_profile_pic.png",height: 45,
                                      // ),
                                      ),
                                  title: Container(
                                      padding: EdgeInsets.only(top: 18.0),
                                      child: Text(
                                        "${_foundClubs[index]['Title']}",
                                        style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                      )),
                                  subtitle: Text("${_foundClubs[index]['Description']}",
                                      style: TextStyle(fontSize: 12, color: Colors.white)),
                                  trailing: IconButton(
                                    onPressed: () {
                                    },
                                    icon: Icon(
                                      _foundClubs[index]['JoinedUser_ID'] == null ? Icons.remove_red_eye :  Icons.check
                                      ,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                );
                              },
                            )
                      // _foundClubs.isNotEmpty ?
                      // ListView.builder(
                      //   physics: ScrollPhysics(),
                      //   shrinkWrap: true,
                      //   padding: EdgeInsets.zero,
                      //   itemCount: clubsDetails.clubs.length,
                      //   itemBuilder: (BuildContext context,int index){
                      //     return
                      //       ListTile(
                      //         contentPadding: EdgeInsets.zero,
                      //         minVerticalPadding: 0,
                      //         horizontalTitleGap: 0,
                      //         leading: Container(
                      //             padding: EdgeInsets.only(right: 10),
                      //             child: CircleAvatar(
                      //               backgroundColor: Colors.transparent,
                      //               backgroundImage:  NetworkImage("${AppUrl.mediaUrl}${clubsDetails.clubs[index]['BannerImage']}"),
                      //             )
                      //           // Image.asset(
                      //           //   "assets/raw_profile_pic.png",height: 45,
                      //           // ),
                      //         ),
                      //         title: Container(
                      //             padding: EdgeInsets.only(top: 18.0),
                      //             child: Text("${clubsDetails.clubs[index]['Title']}",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),)),
                      //         subtitle:Text("${clubsDetails.clubs[index]['Description']}",style: TextStyle(fontSize: 12,color: Colors.white)),
                      //         trailing:  IconButton(onPressed: (){
                      //           Navigator.push(context, MaterialPageRoute(builder: (context) => ClubProfile(
                      //             index:index,
                      //             name:"${clubsDetails.clubs[index]['Title']}",
                      //             imageName:"${AppUrl.mediaUrl}${clubsDetails.clubs[index]['BannerImage']}",
                      //             desc:"${clubsDetails.clubs[index]['Description']}" ,
                      //             Id:"${clubsDetails.clubs[index]['ID']}" ,
                      //           )));
                      //         },
                      //           icon:Icon(Icons.remove_red_eye,color: Colors.white,size: 18,),),
                      //       )
                      //     ;
                      //   },
                      // )
                      //     :
                      //  Text(
                      //   'No results found',
                      //   style: TextStyle(color: Colors.white,fontSize: 18)
                      // ),
                      );
              return child;
            }))
          ],
        ),
      ),
    );
  }
}
