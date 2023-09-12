import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/providers/running_buddies.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/ProvidersUtility.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';

class RunningBuddies extends StatefulWidget {
  const RunningBuddies({Key? key}) : super(key: key);

  @override
  State<RunningBuddies> createState() => _RunningBuddiesState();
}

class _RunningBuddiesState extends State<RunningBuddies>
    with SingleTickerProviderStateMixin {
   RunningBuddiesProvider? RBprovider;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoader=false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoader=true;
    });
    RBprovider = ProvidersUtility.buddiesProvider;
    RBprovider!.getRunningBuddies({}).then((value) {
      setState(() {
        isLoader=false;
      });  ;
    });
    RBprovider!.getRunningBuddiesFriends().then((value) {
      setState(() {
        isLoader=false;
      });  ;
    });

    super.initState();
  }

  late final _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget.textAppBar("RUNNING BUDDIES"),
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      key: _key,
      body: Container(
          // padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: CustomColor.white,
            labelStyle: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(color: Colors.white, fontSize: 14),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.white,
            tabs: [
              Container(
                child: Text("By Persons",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
              Container(
                child: Text("Request",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            // height: size.height * 0.8,
            child: TabBarView(controller: _tabController, children: [
              //left

              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(child: Consumer<RunningBuddiesProvider>(
                        builder: (context, buddiesDetails, child) {
                         isLoader == true ?
                        child= Center(
                           child: Padding(
                             padding: const EdgeInsets.only(top: 10.0),
                             child: CircularProgressIndicator(
                               color: Colors.white,
                             ),
                           ),
                         )
                             :

                          buddiesDetails.Acceptfriends.isEmpty
                              ? child = Center(
                                  child: Text(
                                    "No Friends",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : child = Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          buddiesDetails.Acceptfriends.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        print("Image is ${buddiesDetails.Acceptfriends[index]['ProfilePhoto']}");
                                        //Status
                                        return buddiesDetails.Acceptfriends[index]['Status'] == "Accept"
                                            ?

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Flexible(
                                                    flex:6,
                                                    // flex: 2,
                                                    child: Container(
                                                      height: 100,
                                                      width:110,
                                                      color:Colors.grey,
                                                      child: buddiesDetails.Acceptfriends[
                                                      index][
                                                      'ProfilePhoto'] ==
                                                          null
                                                          ?

                                                      Image.asset("assets/default_image.jpg",)
                                                          :
                                                      Image.network("${AppUrl.mediaUrl}${buddiesDetails.Acceptfriends[index]['ProfilePhoto']}",
                                                        fit: BoxFit.cover,
                                                        // width: 80,

                                                      )

                                                    ),),

                                                  Flexible(
                                                    flex:8,

                                                    child:
                                                    Container(

                                                      width: size.width * 0.5,
                                                      padding: EdgeInsets.only(top: 5.0,left: 10.0),
                                                      child:
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                            "${buddiesDetails.Acceptfriends[index]['UserName']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                        SizedBox(height: 5,),
                                                        Text(
                                                            "${buddiesDetails.Acceptfriends[index]['City']} ${buddiesDetails.Buddies[index]['Country']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                        SizedBox(height: 5,),
                                                        Text(
                                                            "${buddiesDetails.Acceptfriends[index]['Points']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                      ],
                                                    ),
                                                  ),
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(top: 5.0,left: 15.0),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                15.0),
                                                            backgroundColor:
                                                            CustomColor
                                                                .grey_color,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    100.0))),
                                                        onPressed: () {
                                                          //personal screen chat
                                                        Navigator.pushNamed(context, '/Chats');
                                                        },
                                                        child: Text("MESSAGE",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                                  ),

                                                  

                                                 
                                                ],
                                              ),
                                            )



                                            : SizedBox();
                                      }));

                          return child;
                        },
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      ButtonWidget(
                        btnWidth: size.width * 0.7,
                        onPressed: () {
                          Navigator.pushNamed(context, '/FindBuddies');
                        },
                        color: CustomColor.grey_color,
                        textcolor: Colors.black,
                        fontSize: 14,
                        fontweight: FontWeight.w600,
                        text: "FIND RUNNING BUDDY",
                      ),
                    ],
                  )),
              //right
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        child: Consumer<RunningBuddiesProvider>(
                            builder: (context, FriendsDetails, child) {
                              isLoader == true ?
                              child= Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              :
                          FriendsDetails.RequestFriends.isEmpty
                              ? child = Text(
                                  "No Request",
                                  style: TextStyle(color: Colors.white),
                                )

                              //     Center(
                              //     child:Padding(
                              //       padding: const EdgeInsets.only(top: 10.0),
                              //       child: CircularProgressIndicator(color: Colors.white,),
                              //     )
                              // ) :
                              : child = Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          FriendsDetails.RequestFriends.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return FriendsDetails
                                                        .RequestFriends[index]
                                                    ['Status'] ==
                                                "Request"
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: FriendsDetails
                                                                            .RequestFriends[index]
                                                                        [
                                                                        'ProfilePhoto'] ==
                                                                    null
                                                                ? DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/raw_profile_pic.png"),
                                                                    fit: BoxFit
                                                                        .cover)
                                                                : DecorationImage(
                                                                    image: NetworkImage(
                                                                        "${AppUrl.mediaUrl}${FriendsDetails.RequestFriends[index]['ProfilePhoto']}"),
                                                                    fit: BoxFit
                                                                        .fill),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                            "${FriendsDetails.RequestFriends[index]['UserName']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        FriendsDetails.RequestFriends[
                                                                        index][
                                                                    'Direction'] ==
                                                                "Sent"
                                                            ? Container(
                                                                height: 30,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            padding: EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    15.0),
                                                                            backgroundColor: CustomColor
                                                                                .grey_color,
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    100.0))),
                                                                        onPressed:
                                                                            () {
                                                                          TopFunctions.showScaffold(
                                                                              "Waiting to Accept from your Friend Side");
                                                                        },
                                                                        child: Text(
                                                                            "WAITING",
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w600))),
                                                              )
                                                            : SizedBox(),
                                                        FriendsDetails.RequestFriends[
                                                                        index][
                                                                    'Direction'] ==
                                                                "Receive"
                                                            ? Container(
                                                                height: 30,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            padding: EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    15.0),
                                                                            backgroundColor: CustomColor
                                                                                .grey_color,
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    100.0))),
                                                                        onPressed:
                                                                            () async {
                                                                          try {
                                                                            final Map<String, dynamic>
                                                                                reqData =
                                                                                {
                                                                              "Friend_ID": FriendsDetails.RequestFriends[index]['ID'],
                                                                              "Status": "Accept"
                                                                            };
                                                                            print("resuest ${reqData}");
                                                                            GeneralResponse
                                                                                response =
                                                                                await AppUrl.apiService.friendrequest(reqData);
                                                                            print("Receiving Data from FRIENDSREQUEST: ${response.toString()}");
                                                                            if (response.status ==
                                                                                1) {
                                                                              FriendsDetails.getRunningBuddiesFriends();
                                                                              RBprovider!.notifyListeners();
                                                                              FriendsDetails.notifyListeners();
                                                                              TopFunctions.showScaffold("${response.message}");
                                                                            } else {
                                                                              print("Data Received Didn't Successfully from Friends: ${response.toString()}");
                                                                            }
                                                                          } catch (e) {
                                                                            print("Friendt Request ${e}");
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                            "Accept",
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w600))),
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              15.0),
                                                                  backgroundColor:
                                                                      CustomColor
                                                                          .grey_color,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100.0))),
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  final Map<
                                                                          String,
                                                                          dynamic>
                                                                      reqData =
                                                                      {
                                                                    "Friend_ID":
                                                                        FriendsDetails.RequestFriends[index]
                                                                            [
                                                                            'ID'],
                                                                    "Status":
                                                                        "Reject"
                                                                  };
                                                                  print(
                                                                      "resuest ${reqData}");
                                                                  GeneralResponse
                                                                      response =
                                                                      await AppUrl
                                                                          .apiService
                                                                          .friendrequest(
                                                                              reqData);
                                                                  if (response
                                                                          .status ==
                                                                      1) {
                                                                    FriendsDetails
                                                                        .getRunningBuddiesFriends();
                                                                    FriendsDetails
                                                                        .notifyListeners();
                                                                    TopFunctions
                                                                        .showScaffold(
                                                                            "${response.message}");
                                                                  } else {
                                                                    print(
                                                                        "Data Received Didn't Successfully from Friends: ${response.toString()}");
                                                                  }
                                                                } catch (e) {
                                                                  print(
                                                                      "Friendt Request ${e}");
                                                                }
                                                              },
                                                              child: Text(
                                                                  "DECLINE",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600))),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            : SizedBox();
                                      }));

                          return child;
                        }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ButtonWidget(
                        btnWidth: size.width * 0.7,
                        onPressed: () {
                          Navigator.pushNamed(context, '/FindBuddies');
                        },
                        color: CustomColor.grey_color,
                        textcolor: Colors.black,
                        fontSize: 14,
                        fontweight: FontWeight.w600,
                        text: "FIND RUNNING BUDDY",
                      ),
                    ],
                  ))
            ]),
          )
        ],
      )),
    );
  }
}
