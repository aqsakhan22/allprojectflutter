import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/chat_provider.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:runwith/widget/single_video_player.dart';

import '../../network/response/general_response.dart';

class ForumClubChats extends StatefulWidget {
  final String? name;
  final String? Id;

  const ForumClubChats({Key? key, this.Id, this.name}) : super(key: key);

  @override
  State<ForumClubChats> createState() => _ForumClubChatsState();
}

class _ForumClubChatsState extends State<ForumClubChats> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late ChatProvider chatProvider;
  TextEditingController message = TextEditingController(text: "");
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ScrollController _scrollController = new ScrollController();
  XFile? image;
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? cameraImage;
  bool isLoader = false;
  int pageindex = 1;
  String fileType = "";

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.show(status: 'Updating...');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.clubChat = []; // Empty The List To Save Current Chat History Only Till You Are On This Chat
      chatProvider.getClubChat(widget.Id!, pageindex).then((value) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );
        EasyLoading.dismiss();
      });
    });
    super.initState();
  }

  void _onLoading() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      pageindex--;
    });
    if (pageindex != 0) {
      chatProvider.getClubChat(widget.Id!, pageindex).then((value) async {
        if (chatProvider.clubChat.isEmpty) {
          chatProvider.getClubChat(widget.Id!, 1);
          chatProvider.notifyListeners();
        }
      });
    } else {
      chatProvider.getClubChat(widget.Id!, 1);
    }
    // if failed,use refreshFailed()
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      pageindex++;
      chatProvider.getClubChat(widget.Id!, pageindex).then((value) async {
        if (chatProvider.clubChat.isEmpty) {
          pageindex--;
          chatProvider.getClubChat(widget.Id!, pageindex);
          chatProvider.notifyListeners();
        }
      });
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      key: _key,
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      appBar: AppBarWidget.textAppBar("${widget.name}"),
      body: Container(
        child: Consumer<ChatProvider>(
          builder: (BuildContext context, chatsDetails, child) {
            child = Column(
              children: [
                Expanded(
                    child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: chatsDetails.clubChat.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //First Part
                              chatsDetails.clubChat[index]['Sender_ID'] == UserPreferences.get_Login()['ID']
                                  ? Expanded(
                                      child: Container(
                                      width: size.width * 0.7,
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 5.0,
                                              right: 0.0,
                                            ),
                                            child: SizedBox(
                                                width: size.width,
                                                child: Text(
                                                  "${chatsDetails.clubChat[index]['FullName'] == "" ? 'Unknown' : chatsDetails.clubChat[index]['FullName']}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontSize: 10, color: CustomColor.white),
                                                )),
                                          ),
                                          chatsDetails.clubChat[index]['Message'] != ""
                                          ? Container(
                                            decoration: BoxDecoration(
                                                color: CustomColor.grey_color, borderRadius: BorderRadius.circular(10.0)),
                                            padding: const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                                            child: SizedBox(
                                              width: size.width,
                                              child: Text(
                                                "${chatsDetails.clubChat[index]['Message']}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          )
                                          : SizedBox(),
                                          chatsDetails.clubChat[index]['File'] != null &&
                                                  (chatsDetails.clubChat[index]['File'].toString().contains("jpg") ||
                                                      chatsDetails.clubChat[index]['File'].toString().contains("jpeg") ||
                                                      chatsDetails.clubChat[index]['File'].toString().contains("png"))
                                              ? Container(
                                                  // height: size.height * 0.2,
                                                  width: size.width,
                                                  child: Image.network(
                                                      "${AppUrl.mediaUrl}${chatsDetails.clubChat[index]['File']}",
                                                      fit: BoxFit.contain, loadingBuilder:
                                                          (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                loadingProgress.expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  }),
                                                )
                                              : SizedBox(),
                                          chatsDetails.clubChat[index]['File'] != null &&
                                                  (chatsDetails.clubChat[index]['File'].toString().contains("mp4"))
                                              ? Container(
                                                  // height: size.height * 0.2,
                                                  child: Container(
                                                      // width:  size.width,
                                                      //   alignment: Alignment
                                                      //       .topRight,
                                                      child: VideoPlaying(
                                                    mediaUrl: "${AppUrl.mediaUrl}${chatsDetails.clubChat[index]['File']}",
                                                  )),
                                                )
                                              : SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5.0, right: 00.0),
                                            child: SizedBox(
                                                width: size.width,
                                                child: Text(
                                                  "${chatsDetails.clubChat[index]['CreatedAt']}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontSize: 10, color: CustomColor.white),
                                                )),
                                          )
                                        ],
                                      ),
                                    ))
                                  : chatsDetails.clubChat[index]['ProfilePhoto'] != null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              "${AppUrl.mediaUrl}${chatsDetails.clubChat[index]['ProfilePhoto']}"))
                                      : CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage("assets/locationavatar.png")),
                              //Second part
                              chatsDetails.clubChat[index]['Sender_ID'] == UserPreferences.get_Login()['ID']
                                  ? chatsDetails.clubChat[index]['ProfilePhoto'] != null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              "${AppUrl.mediaUrl}${chatsDetails.clubChat[index]['ProfilePhoto']}"))
                                      : CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage("assets/locationavatar.png"))
                                  : Container(
                                      width: size.width * 0.7,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          chatsDetails.clubChat[index]['Message'] != ""
                                          ? Container(
                                            decoration: BoxDecoration(
                                                color: CustomColor.grey_color, borderRadius: BorderRadius.circular(10.0)),
                                            padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                            child: SizedBox(
                                              width: size.width,
                                              child: Text(
                                                "${chatsDetails.clubChat[index]['Message']}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          )
                                          : SizedBox(),
                                          chatsDetails.clubChat[index]['File'] != null &&
                                                  (chatsDetails.clubChat[index]['File'].toString().contains("jpg") ||
                                                      chatsDetails.clubChat[index]['File'].toString().contains("jpeg") ||
                                                      chatsDetails.clubChat[index]['File'].toString().contains("png"))
                                              ? Container(
                                                  //height: size.height * 0.2,
                                                  child: Image.network(
                                                      "${AppUrl.mediaUrl}${chatsDetails.clubChat[index]['File']}",
                                                      fit: BoxFit.contain, loadingBuilder:
                                                          (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                loadingProgress.expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  }),
                                                )
                                              : SizedBox(),
                                          chatsDetails.clubChat[index]['File'] != null &&
                                                  (chatsDetails.clubChat[index]['File'].toString().contains("mp4"))
                                              ? Container(
                                                  // height: size.height * 0.2,
                                                  child: Container(
                                                      child: VideoPlaying(
                                                    mediaUrl: "${AppUrl.mediaUrl}${chatsDetails.clubChat[index]['File']}",
                                                  )),
                                                )
                                              : SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5.0, right: 0.0),
                                            child: SizedBox(
                                                width: size.width,
                                                child: Text(
                                                  "${chatsDetails.clubChat[index]['CreatedAt']}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontSize: 10, color: CustomColor.white),
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        );
                      }),
                )),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                image = (await _picker.pickImage(source: ImageSource.gallery));
                                pickedImage = File(image!.path);
                                cameraImage = pickedImage!.readAsBytesSync();
                                setState(() {
                                  fileType = "Camera";
                                });
                                TopFunctions.showScaffold("Image selected");
                              },
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: CustomColor.grey_color,
                                size: 25,
                              ),
                            ),
                            fileType == "Camera"
                                ? Positioned(
                                    right: 5,
                                    top: 10,
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                      child: Icon(Icons.check, size: 14, color: CustomColor.white),
                                    ))
                                : SizedBox()
                          ],
                        ),
                        Stack(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                image = (await _picker.pickVideo(source: ImageSource.gallery));
                                pickedImage = File(image!.path);
                                setState(() {
                                  fileType = "Video";
                                });
                                TopFunctions.showScaffold("Video selected");
                              },
                              icon: Icon(Icons.videocam, color: CustomColor.grey_color, size: 30),
                            ),
                            fileType == "Video"
                                ? Positioned(
                                    right: 5,
                                    top: 10,
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                      child: Icon(Icons.check, size: 14, color: CustomColor.white),
                                    ))
                                : SizedBox()
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: message,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                                fillColor: CustomColor.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(),
                                ),
                                suffixIcon: Container(
                                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                                  child: ButtonWidget(
                                    btnHeight: 30,
                                    onPressed: () async {
                                      EasyLoading.show(status: "Posting...");
                                      setState(() {
                                        isLoader = true;
                                      });
                                      try {
                                        GeneralResponse response;
                                        if (pickedImage == null) {
                                          response = await AppUrl.apiService.chatsendMediaWithout(
                                              "${widget.name == "CLUB CHATS" ? "Club" : "Personal"}",
                                              "${widget.Id}",
                                              "${message.text}");
                                        } else {
                                          response = await AppUrl.apiService.chatsendMedia(
                                              File(image!.path),
                                              "${widget.name == "CLUB CHATS" ? "Club" : "Personal"}",
                                              "${widget.Id}",
                                              "${message.text}");
                                        }
                                        if (response.status == 1) {
                                          setState(() {
                                            isLoader = false;
                                            fileType = "";
                                            pickedImage = null;
                                            message.text = "";
                                          });
                                          chatProvider.getClubChat("${widget.Id}", 1).then((value) => EasyLoading.dismiss());
                                          chatProvider.notifyListeners();
                                          TopFunctions.showScaffold("${response.message}");
                                        }
                                      } catch (e) {
                                        setState(() {
                                          isLoader = false;
                                          fileType = "";
                                          pickedImage = null;
                                          message.text = "";
                                        });
                                        print("EXCEPTION OF CLUB CHATS IS ${e}");
                                        TopFunctions.showScaffold(e.toString());
                                      }
                                    },
                                    color: Colors.black,
                                    text: "Send",
                                    textcolor: CustomColor.white,
                                  ),
                                )),
                          ),
                        )
                      ],
                    ))
              ],
            );
            return child;
          },
        ),
      ),
    );
  }
}
