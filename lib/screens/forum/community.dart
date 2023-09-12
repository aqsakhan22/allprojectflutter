import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/chat_provider.dart';
import 'package:runwith/screens/forum/forum_chats.dart';
import 'package:runwith/screens/forum/club_chats.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/screens/search.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/ProvidersUtility.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';

class ChatForum extends StatefulWidget {
  const ChatForum({Key? key}) : super(key: key);

  @override
  State<ChatForum> createState() => _ChatForumState();
}

class _ChatForumState extends State<ChatForum> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ChatProvider? chatprovider;
  TextEditingController message = TextEditingController(text: "");
  XFile? image;

  // XFile? pickedVideo;
  File? pickedImage;

  final ImagePicker _picker = ImagePicker();
  late final _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void initState() {
    // TODO: implement initState
    chatprovider = ProvidersUtility.chatsProvider;
    final Map<String, dynamic> reqData = {'Type': "Club"};
    EasyLoading.show(status: 'Fetching Data...');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatprovider!.getClubChatsData(reqData).then((value) {
        EasyLoading.dismiss();
      });
      chatprovider!.getForumChatsData().then((value) {
        EasyLoading.dismiss();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    chatprovider = Provider.of<ChatProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget.textAppBar("COMMUNITY"),
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: ButtonWidget(
              onPressed: () {
                Navigator.pushNamed(context, '/Clubs');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchClubs()));
              },
              btnHeight: 40,
              text: "JOIN CLUB",
              fontSize: 14,
              color: CustomColor.grey_color,
              fontweight: FontWeight.w800,
              textcolor: Colors.black,
              btnWidth: 150,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50.0),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: CustomColor.white,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(color: Colors.white, fontSize: 14),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.white,
                  tabs: [
                    Container(
                      child: Text("Community", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                    Container(
                      child: Text("Club", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: TabBarView(controller: _tabController, physics: NeverScrollableScrollPhysics(), children: [
                    //left
                    Container(
                      child: Consumer<ChatProvider>(builder: (BuildContext context, forums, child) {
                        forums.forumsData.isEmpty
                            ? child = Center(
                                child: Text(
                                "No Community",
                                style: TextStyle(color: Colors.white),
                              ))
                            : child = ListView.builder(
                                itemCount: forums.forumsData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForumChats(name: "FORUM CHATS", Id: forums.forumsData[index]['ID'])));
                                    },
                                    leading: Container(
                                        padding: EdgeInsets.only(right: 10),
                                        child: forums.forumsData[index]['Attachment'] == null
                                            ? CircleAvatar(
                                                radius: 22,
                                                backgroundColor: CustomColor.orangeColor,
                                                child: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: AssetImage("assets/locationavatar.png")

                                                    //AssetImage("assets/homeBack2.png")

                                                    ),
                                              )
                                            : CircleAvatar(
                                                radius: 22,
                                                backgroundColor: CustomColor.orangeColor,
                                                child: CircleAvatar(
                                                    backgroundColor: Colors.grey,
                                                    backgroundImage: NetworkImage(
                                                        "${AppUrl.mediaUrl}${forums.forumsData[index]['Attachment']}")),
                                              )),
                                    // Report Action Is Not Available In Forums
                                    // trailing: IconButton(
                                    //   padding: EdgeInsets.zero,
                                    //   onPressed: () async {
                                    //     await showMenu(
                                    //         context: context,
                                    //         position: RelativeRect.fromLTRB(20, 200, 0, 0),
                                    //         color: CustomColor.grey_color,
                                    //         // constraints:  BoxConstraints.tightForFinite(height: 30),
                                    //         items: [
                                    //           PopupMenuItem<String>(
                                    //             height: 30.0,
                                    //             child: const Text(
                                    //               'Delete',
                                    //               style: TextStyle(
                                    //                   color: CustomColor.primary, fontSize: 14, fontWeight: FontWeight.w400),
                                    //             ),
                                    //             value: 'Delete',
                                    //             onTap: () async {},
                                    //           ),
                                    //           PopupMenuItem<String>(
                                    //             height: 30.0,
                                    //             child: const Text(
                                    //               'Report',
                                    //               style: TextStyle(
                                    //                   color: CustomColor.primary, fontSize: 14, fontWeight: FontWeight.w400),
                                    //             ),
                                    //             value: 'Report',
                                    //             onTap: () {},
                                    //           ),
                                    //           PopupMenuItem<String>(
                                    //             height: 30.0,
                                    //             child: const Text(
                                    //               'Archive',
                                    //               style: TextStyle(
                                    //                   color: CustomColor.primary, fontSize: 14, fontWeight: FontWeight.w400),
                                    //             ),
                                    //             value: 'Archive',
                                    //             onTap: () {},
                                    //           ),
                                    //         ]);
                                    //   },
                                    //   icon: Icon(
                                    //     Icons.more_horiz,
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    title: Text(
                                      "${forums.forumsData[index]['Title']}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      "${forums.forumsData[index]['Body']}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                });
                        return child;
                      }),
                    ),
                    //right
                    Container(
                      child: Consumer<ChatProvider>(builder: (BuildContext context, clubsDetails, child) {
                        clubsDetails.clubsData.isEmpty
                            ? child = Center(
                                child: Text(
                                "No Clubs",
                                style: TextStyle(color: Colors.white),
                              ))
                            : child = clubsDetails.clubsData.isEmpty
                                ? Container(
                                    alignment: Alignment.topCenter,
                                    child: ButtonWidget(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchClubs()));
                                      },
                                      btnHeight: 40,
                                      text: "JOIN CLUB",
                                      fontSize: 14,
                                      color: CustomColor.grey_color,
                                      fontweight: FontWeight.w800,
                                      textcolor: Colors.black,
                                      btnWidth: 150,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: clubsDetails.clubsData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return clubsDetails.clubsData[index]['_DeletedAt'] == null
                                          ? ListTile(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ForumClubChats(
                                                            name: "CLUB CHATS", Id: clubsDetails.clubsData[index]['ID'])));
                                              },
                                              leading: Container(
                                                  padding: EdgeInsets.only(right: 10),
                                                  child: clubsDetails.clubsData[index]['BannerImage'] == null
                                                      ? CircleAvatar(
                                                          radius: 22,
                                                          backgroundColor: CustomColor.orangeColor,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              backgroundImage: AssetImage("assets/locationavatar.png")

                                                              //AssetImage("assets/homeBack2.png")

                                                              ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 22,
                                                          backgroundColor: CustomColor.orangeColor,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.grey,
                                                              backgroundImage: NetworkImage(
                                                                  "${AppUrl.mediaUrl}${clubsDetails.clubsData[index]['BannerImage']}")),
                                                        )),
                                              trailing: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  await showMenu(
                                                      context: context,
                                                      position: RelativeRect.fromLTRB(20, 200, 0, 0),
                                                      color: CustomColor.grey_color,
                                                      // constraints:  BoxConstraints.tightForFinite(height: 30),
                                                      items: [
                                                        PopupMenuItem<String>(
                                                          height: 30.0,
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: CustomColor.primary,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          value: 'Delete',
                                                          onTap: () {
                                                            clubsDetails.chatsStatus(
                                                                "${clubsDetails.clubsData[index]['ID']}", "DeletedAt");
                                                            clubsDetails.notifyListeners();
                                                          },
                                                        ),
                                                        PopupMenuItem<String>(
                                                          height: 30.0,
                                                          child: const Text(
                                                            'Report',
                                                            style: TextStyle(
                                                                color: CustomColor.primary,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          value: 'Report',
                                                          onTap: () {
                                                            clubsDetails.chatsStatus(
                                                                "${clubsDetails.clubsData[index]['ID']}", "ReportedAt");
                                                            clubsDetails.notifyListeners();
                                                          },
                                                        ),
                                                        PopupMenuItem<String>(
                                                          height: 30.0,
                                                          child: const Text(
                                                            'Archive',
                                                            style: TextStyle(
                                                                color: CustomColor.primary,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          value: 'Archive',
                                                          onTap: () {
                                                            clubsDetails.chatsStatus(
                                                                "${clubsDetails.clubsData[index]['ID']}", "ArchivedAt");
                                                            clubsDetails.notifyListeners();
                                                          },
                                                        ),
                                                      ]);
                                                },
                                                icon: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              title: Text(
                                                "${clubsDetails.clubsData[index]['Title']}",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                "Group Chat With All Members...",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            )
                                          : SizedBox();
                                    });
                        return child;
                      }),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
