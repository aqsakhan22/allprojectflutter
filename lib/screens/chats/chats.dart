import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/chat_provider.dart';
import 'package:runwith/screens/chats/personal_chats.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/ProvidersUtility.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ChatProvider? chatProvider;
  bool isLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.show(status: 'Updating...');
    chatProvider = ProvidersUtility.chatsProvider;
    final Map<String, dynamic> reqData = {"Type": "Personal"};
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider!.getPersonalChatsData(reqData).then((value) {
        EasyLoading.dismiss();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      appBar: AppBarWidget.textAppBar("Chats"),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (enteredKeyword) {
                  Map<String, dynamic> searchChat = {"Type": "Personal", "Search_Chat": enteredKeyword.toLowerCase().toString()};
                  chatProvider!.getPersonalChatsData(searchChat);
                  chatProvider!.notifyListeners();
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.transparent)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Type your search here",
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<ChatProvider>(
                builder: (BuildContext context, chatsDetails, child) {
                  chatsDetails.personalsData.isEmpty
                      ? child = Text(
                          "No Chats, Please Add Friends To Start Chatting.",
                          style: TextStyle(color: Colors.white),
                        )
                      : child = Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: chatsDetails.personalsData.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                return chatsDetails.personalsData[index]['_DeletedAt'] == null
                                    ? ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => PersonalChats(
                                                      name:
                                                          "${UserPreferences.get_Login()['ID'] == chatsDetails.personalsData[index]['Sender_ID'] ? chatsDetails.personalsData[index]['ReceiverFullName'] : chatsDetails.personalsData[index]['SenderFullName']}",
                                                      Id: "${chatsDetails.personalsData[index]['ID']}")));
                                        },
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                    leading: Container(
                                            padding: EdgeInsets.only(right: 10),
                                            child: UserPreferences.get_Login()['ID'] == chatsDetails.personalsData[index]['Sender_ID']
                                                ? chatsDetails.personalsData[index]['ReceiverProfilePhoto'] != null
                                                    ? CircleAvatar(
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: NetworkImage(""
                                                            "${AppUrl.mediaUrl}${chatsDetails.personalsData[index]['ReceiverProfilePhoto']}"),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: AssetImage("assets/locationavatar.png"))
                                                : chatsDetails.personalsData[index]['SenderProfilePhoto'] != null
                                                    ? CircleAvatar(
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: NetworkImage(""
                                                            "${AppUrl.mediaUrl}${chatsDetails.personalsData[index]['SenderProfilePhoto']}"),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: AssetImage("assets/locationavatar.png"))),
                                        title: UserPreferences.get_Login()['ID'] == chatsDetails.personalsData[index]['Sender_ID']
                                            ? Text(
                                                "${chatsDetails.personalsData[index]['ReceiverFullName'] == '' ? 'Unknown' : chatsDetails.personalsData[index]['ReceiverFullName']} ",
                                                style: TextStyle(color: Colors.white),
                                              )
                                            : Text(
                                                "${chatsDetails.personalsData[index]['SenderFullName'] == '' ? 'Unknown' : chatsDetails.personalsData[index]['SenderFullName']}",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                        trailing: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            await showMenu(
                                                context: context,
                                                position: RelativeRect.fromLTRB(20, 100, 0, 0),
                                                color: CustomColor.grey_color,
                                                items: [
                                                  PopupMenuItem<String>(
                                                    height: 30.0,
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: CustomColor.primary, fontSize: 14, fontWeight: FontWeight.w400),
                                                    ),
                                                    value: 'Delete',
                                                    onTap: () async {
                                                      chatsDetails.chatsStatus(
                                                          "${chatsDetails.personalsData[index]['ID']}", "DeletedAt");
                                                      chatsDetails.notifyListeners();
                                                    },
                                                  ),
                                                  PopupMenuItem<String>(
                                                    height: 30.0,
                                                    child: const Text(
                                                      'Report',
                                                      style: TextStyle(
                                                          color: CustomColor.primary, fontSize: 14, fontWeight: FontWeight.w400),
                                                    ),
                                                    value: 'Report',
                                                    onTap: () {
                                                      chatsDetails.chatsStatus(
                                                          "${chatsDetails.personalsData[index]['ID']}", "ReportedAt");
                                                      chatsDetails.notifyListeners();
                                                    },
                                                  ),
                                                  PopupMenuItem<String>(
                                                    height: 30.0,
                                                    child: const Text(
                                                      'Archive',
                                                      style: TextStyle(
                                                          color: CustomColor.primary, fontSize: 14, fontWeight: FontWeight.w400),
                                                    ),
                                                    value: 'Archive',
                                                    onTap: () {
                                                      chatsDetails.chatsStatus("${chatsDetails.personalsData[index]['ID']}", "ArchivedAt");
                                                      final Map<String, dynamic> reqData = {"Type": "Personal"};
                                                      chatProvider!.getPersonalChatsData(reqData);
                                                      chatsDetails.notifyListeners();
                                                    },
                                                  ),
                                                ]);
                                          },
                                          icon: Icon(
                                            Icons.more_horiz,
                                            color: Colors.white,
                                          ),
                                        ))
                                    : SizedBox();
                              }));
                  return child;
                },
              )
            ],
          )),
    );
  }
}
