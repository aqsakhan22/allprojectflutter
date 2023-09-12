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
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:runwith/widget/single_video_player.dart';

import '../../network/response/general_response.dart';
import '../../widget/bottom_bar_widget.dart';

class ForumChats extends StatefulWidget {
  final String? name;
  final String? Id;

  const ForumChats({Key? key, this.Id, this.name}) : super(key: key);

  @override
  State<ForumChats> createState() => _ForumChatsState();
}

class _ForumChatsState extends State<ForumChats> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late ChatProvider chatsProvider;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController message = TextEditingController(text: "");
  ScrollController _scrollController = new ScrollController();
  XFile? image;
  int pageindex = 1;
  String fileType = "";
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? cameraImage;

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.show(status: 'Updating...');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatsProvider.forumChat = []; // Empty The List To Save Current Chat History Only Till You Are On This Chat
      chatsProvider.getForumChat(widget.Id!, 1).then((value) {
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
    setState(() {
      pageindex--;
    });
    if (pageindex != 0) {
      chatsProvider.getForumChat(widget.Id!, pageindex).then((value) async {
        if (chatsProvider.forumChat.isEmpty) {
          chatsProvider.getForumChat(widget.Id!, 1);
          chatsProvider.notifyListeners();
        }
      });
    } else {
      chatsProvider.getForumChat(widget.Id!, 1);
    }
    // if failed,use refreshFailed()
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    EasyLoading.show(status: "Updating");
    setState(() {
      pageindex++;
      chatsProvider.getForumChat(widget.Id!, pageindex).then((value) async {
        EasyLoading.dismiss();
        if (chatsProvider.forumChat.isEmpty) {
          print("social feed is empty means next page has no data so we have to load page=1 data");
          chatsProvider.getForumChat(widget.Id!, 1);
          chatsProvider.notifyListeners();
        }
      });
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    chatsProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      key: _key,
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      appBar: AppBarWidget.textAppBar("${widget.name}"),
      body: SizedBox(
        child: Consumer<ChatProvider>(
          builder: (BuildContext context, forumReply, child) {
            if (forumReply.forumChat.isEmpty) {
              child = Center(
                child: Text(
                  "No Data",
                  style: TextStyle(color: CustomColor.white),
                ),
              );
            }
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
                      shrinkWrap: true,
                      itemCount: forumReply.forumChat.length,
                      itemBuilder: (BuildContext context, int index) {
                        print("TEST IF BODY AVAILABLE ${forumReply.forumChat[index]['Body'].toString().length}");
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              forumReply.forumChat[index]['ProfilePhoto'] != null
                                  ? CircleAvatar(
                                      radius: 27,
                                      backgroundImage: NetworkImage(
                                        "${AppUrl.mediaUrl}${forumReply.forumChat[index]['ProfilePhoto']}",
                                      ))
                                  : CircleAvatar(
                                      radius: 27,
                                      backgroundImage: AssetImage(
                                        "assets/locationavatar.png",
                                      )),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                    // height: (forumReply.forumsReply[index]['Attachment'] == null || forumReply.forumsReply[index]['Attachment'].toString().isEmpty)
                                    //     ? (double.parse(forumReply.forumsReply[index]['Body'].toString().length.toString()) + 85)
                                    //     : size.height * 0.3,
                                    width: size.width * 0.1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 5.0,
                                            right: 0.0,
                                          ),
                                          child: SizedBox(
                                              width: size.width,
                                              child: Text(
                                                "${forumReply.forumChat[index]['FullName'] == "" ? 'Unknown' : forumReply.forumChat[index]['FullName']}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontSize: 10, color: CustomColor.white),
                                              )),
                                        ),
                                        forumReply.forumChat[index]['Body'].toString().length > 0
                                            ? Container(
                                                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                    color: CustomColor.grey_color, borderRadius: BorderRadius.circular(10.0)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text(
                                                      "${forumReply.forumChat[index]['Body']}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        forumReply.forumChat[index]['Attachment'] != null &&
                                                (forumReply.forumChat[index]['Attachment'].toString().contains("jpg") ||
                                                    forumReply.forumChat[index]['Attachment'].toString().contains("jpeg") ||
                                                    forumReply.forumChat[index]['Attachment'].toString().contains("png"))
                                            ? Container(
                                                // height: size.height * 0.2,
                                                child: Image.network(
                                                    "${AppUrl.mediaUrl}${forumReply.forumChat[index]['Attachment']}",
                                                    fit: BoxFit.fill, loadingBuilder:
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
                                        (forumReply.forumChat[index]['Attachment'] != null &&
                                                forumReply.forumChat[index]['Attachment'].toString().contains("mp4"))
                                            ? Expanded(
                                                child: Container(
                                                    // width:  size.width,
                                                    alignment: Alignment.topRight,
                                                    child: VideoPlaying(
                                                      mediaUrl:
                                                          "${AppUrl.mediaUrl}${forumReply.forumChat[index]['Attachment']}",
                                                    )))
                                            : SizedBox(),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            "${forumReply.forumChat[index]['CreatedAt']}",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(color: Colors.white, fontSize: 10),
                                          ),
                                        )
                                      ],
                                    )),
                              )
                            ],
                          ),
                        );
                      }),
                )),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                              size: 27,
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
                              TopFunctions.showScaffold("Video Selected");
                            },
                            icon: Icon(Icons.videocam, color: CustomColor.grey_color, size: 35),
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
                                    try {
                                      GeneralResponse response;
                                      if (pickedImage == null) {
                                        response = await AppUrl.apiService.forumsendMediaWithout("${widget.Id}", message.text);
                                      } else {
                                        response = await AppUrl.apiService
                                            .forumsendMedia(File(image!.path), "${widget.Id}", message.text);
                                      }
                                      if (response.status == 1) {
                                        setState(() {
                                          fileType = "";
                                          pickedImage = null;
                                          message.text = "";
                                        });
                                        forumReply.getForumChat("${widget.Id}", 1).then((value) => EasyLoading.dismiss());;
                                        forumReply.notifyListeners();
                                        TopFunctions.showScaffold("${response.message}");
                                      }
                                    } catch (e) {
                                      setState(() {
                                        fileType = "";
                                        pickedImage = null;
                                        message.text = "";
                                      });
                                      print("EXCEPTION OF FORUM CHATS IS ${e}");
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
                  ),
                ),
              ],
            );
            return child;
          },
        ),
      ),
    );
  }
}
