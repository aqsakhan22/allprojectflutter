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

class PersonalChats extends StatefulWidget {
  final String? name;
  final String? Id;

  const PersonalChats({Key? key, this.Id, this.name}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late ChatProvider chatProvider;
  TextEditingController message = TextEditingController(text: "");
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ScrollController _scrollController = new ScrollController();
  XFile? image;
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? cameraImage;
  int pageIndex = 1;
  String fileType = "";

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.show(status: 'Updating...');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.personalChat = []; // Empty The List To Save Current Chat History Only Till You Are On This Chat
      chatProvider.getPersonalChat(widget.Id!, pageIndex).then((value) {
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

  // Bottom Refresh
  void _onLoading() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      pageIndex--;
    });
    if (pageIndex != 0) {
      chatProvider.getPersonalChat(widget.Id!, pageIndex).then((value) async {
        if (chatProvider.personalChat.isEmpty) {
          chatProvider.getPersonalChat(widget.Id!, 1);
        }
      });
    } else {
      chatProvider.getPersonalChat(widget.Id!, 1);
    }
    // if failed,use refreshFailed()
    _refreshController.loadComplete();
  }

  // Top Refresh
  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      pageIndex++;
      chatProvider.getPersonalChat(widget.Id!, pageIndex).then((value) async {
        if (chatProvider.personalChat.isEmpty) {
          print("social feed is empty means next page has no data so we have to load page=1 data");
          pageIndex--;
          chatProvider.getPersonalChat(widget.Id!, pageIndex);
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
            return Column(
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
                          itemCount: chatsDetails.personalChat.length,
                          itemBuilder: (BuildContext context, int index) {
                            print("Chat No ${index} Is By ReceiverID ${chatsDetails.personalChat[index]['Receiver_ID']}");
                            print("Chat No ${index} Is By SenderID ${chatsDetails.personalChat[index]['Sender_ID']}");
                            print("Chat No ${index} Is By UserID ${UserPreferences.get_Login()['ID']}");
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                              child: chatsDetails.personalChat[index]['Sender_ID'] == UserPreferences.get_Login()['ID']
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.75,
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0, right: 0.0,),
                                          child: SizedBox(
                                              width: size.width,
                                              child: Text(
                                                "${chatsDetails.personalChat[index]['SenderFullName'] == "" ? 'Unknown' : chatsDetails.personalChat[index]['SenderFullName']}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 10, color: CustomColor.white),
                                              )),
                                        ),
                                        chatsDetails.personalChat[index]['Message'] != ""
                                            ? Container(
                                          decoration: BoxDecoration(
                                              color: CustomColor.grey_color, borderRadius: BorderRadius.circular(10.0)),
                                          padding: const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                                          child: SizedBox(
                                            width: size.width,
                                            child: Text(
                                              "${chatsDetails.personalChat[index]['Message']}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        )
                                            : SizedBox(),
                                        chatsDetails.personalChat[index]['File'] != null &&
                                            (chatsDetails.personalChat[index]['File'].toString().contains("jpg") ||
                                                chatsDetails.personalChat[index]['File'].toString().contains("jpeg") ||
                                                chatsDetails.personalChat[index]['File'].toString().contains("png"))
                                            ? Container(
                                          // height: size.height * 0.2,
                                          width: size.width,
                                          child: Image.network(
                                              "${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['File']}",
                                              fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent? loadingProgress) {
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
                                        chatsDetails.personalChat[index]['File'] != null &&
                                            (chatsDetails.personalChat[index]['File'].toString().contains("mp4"))
                                            ? Container(
                                          // height: size.height * 0.2,
                                          child: Container(
                                            // width:  size.width,
                                            //   alignment: Alignment
                                            //       .topRight,
                                              child: VideoPlaying(
                                                mediaUrl: "${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['File']}",
                                              )),
                                        )
                                            : SizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0, right: 00.0),
                                          child: SizedBox(
                                              width: size.width,
                                              child: Text(
                                                "${chatsDetails.personalChat[index]['CreatedAt']}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 10, color: CustomColor.white),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: chatsDetails.personalChat[index]['SenderProfilePhoto'] != null ? NetworkImage("${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['SenderProfilePhoto']}") : AssetImage("assets/locationavatar.png") as ImageProvider,
                                  ),
                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: chatsDetails.personalChat[index]['SenderProfilePhoto'] != null ? NetworkImage("${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['SenderProfilePhoto']}") : AssetImage("assets/locationavatar.png") as ImageProvider,
                                  ),
                                  Container(
                                    width: size.width * 0.75,
                                    margin: EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0, right: 0.0,),
                                          child: SizedBox(
                                              width: size.width,
                                              child: Text(
                                                "${chatsDetails.personalChat[index]['SenderFullName'] == "" ? 'Unknown' : chatsDetails.personalChat[index]['SenderFullName']}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontSize: 10, color: CustomColor.white),
                                              )),
                                        ),
                                        chatsDetails.personalChat[index]['Message'] != ""
                                          ? Container(
                                          decoration: BoxDecoration(
                                              color: CustomColor.grey_color, borderRadius: BorderRadius.circular(10.0)),
                                          padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                          child: SizedBox(
                                            width: size.width,
                                            child: Text(
                                              "${chatsDetails.personalChat[index]['Message']}",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        )
                                          : SizedBox(),
                                        chatsDetails.personalChat[index]['File'] != null &&
                                            (chatsDetails.personalChat[index]['File'].toString().contains("jpg") ||
                                                chatsDetails.personalChat[index]['File'].toString().contains("jpeg") ||
                                                chatsDetails.personalChat[index]['File'].toString().contains("png"))
                                            ? Container(
                                          // height: size.height * 0.2,
                                          child: Image.network(
                                              "${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['File']}",
                                              fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent? loadingProgress) {
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
                                        chatsDetails.personalChat[index]['File'] != null &&
                                            (chatsDetails.personalChat[index]['File'].toString().contains("mp4"))
                                            ? Container(
                                          // height: size.height * 0.2,
                                          child: Container(
                                              child: VideoPlaying(
                                                mediaUrl: "${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['File']}",
                                              )),
                                        )
                                            : SizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0, right: 0.0),
                                          child: SizedBox(
                                              width: size.width,
                                              child: Text(
                                                "${chatsDetails.personalChat[index]['CreatedAt']}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 10, color: CustomColor.white),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          ),
                    )),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                              size: 30,
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
                            icon: Icon(Icons.videocam, color: CustomColor.grey_color, size: 32),
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
                                        response = await AppUrl.apiService.chatsendMediaWithout(
                                            "${widget.name == "CLUB CHATS" ? "Club" : "Personal"}",
                                            "${widget.Id}",
                                            "${message.text}");
                                      }
                                      else {
                                        response = await AppUrl.apiService.chatsendMedia(
                                            File(image!.path),
                                            "${widget.name == "CLUB CHATS" ? "Club" : "Personal"}",
                                            "${widget.Id}",
                                            "${message.text}");
                                      }
                                      EasyLoading.dismiss();
                                      if (response.status == 1) {
                                        setState(() {
                                          fileType = "";
                                          pickedImage = null;
                                          message.text = "";
                                          EasyLoading.show(status: "Posting...");
                                          chatProvider.getPersonalChat("${widget.Id}", 1).then((value) => EasyLoading.dismiss());
                                        });
                                        TopFunctions.showScaffold("${response.message}");
                                      }
                                    } catch (e) {
                                      setState(() {
                                        fileType = "";
                                        image = null;
                                        message.text = "";
                                      });
                                      print("EXCEPTION OF PERSONAL CHATS IS  ${e}");
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
          },
        ),
      ),
    );
  }
}
