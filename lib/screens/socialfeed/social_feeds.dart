import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/providers/socila_feeds_provider.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/single_video_player.dart';

import '../../utility/ProvidersUtility.dart';

class SocialFeeds extends StatefulWidget {
  const SocialFeeds({Key? key}) : super(key: key);

  @override
  State<SocialFeeds> createState() => _SocialFeedsState();
}

class _SocialFeedsState extends State<SocialFeeds> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  SocialfeedsProvider? feeds;
  final tooltipController = JustTheController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController message = TextEditingController(text: "");
  TextEditingController comments = TextEditingController(text: "");
  int pageindex = 1;
  XFile? image;
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? cameraImage;
  bool isPinned = false;
  bool isLoader = false;

  void _onRefresh() async {
    if(pageindex != 1){
      EasyLoading.show(status: 'Updating...');
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        pageindex--;
        feeds!.Feeds(pageindex).then((value) async {
          if (feeds!.socialFeeds.isEmpty) {
            pageindex--;
            feeds!.Feeds(pageindex);
            feeds!.notifyListeners();
          }
          await Future.delayed(Duration(seconds: 3), () {
            EasyLoading.dismiss();
          });
        });
      });
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    EasyLoading.show(status: 'Updating...');
    setState(() {
      pageindex++;
      feeds!.Feeds(pageindex).then((value) async {
        if (feeds!.socialFeeds.isEmpty) {
          pageindex--;
          feeds!.Feeds(pageindex);
          feeds!.notifyListeners();
        }
        await Future.delayed(Duration(seconds: 3), () {
          EasyLoading.dismiss();
        });
      });
    });
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    print("All feeds are");
    feeds = ProvidersUtility.socialProvider;
    EasyLoading.show(status: 'Updating...');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      feeds!.Feeds(pageindex).then((value) {
        EasyLoading.dismiss();
      });
    });

    print(" ${feeds!.socialFeeds}");
    super.initState();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _key,
        drawer: MyNavigationDrawer(),
        bottomNavigationBar: BottomNav(
          scaffoldKey: _key,
        ),
        appBar: AppBarWidget.textAppBar("SOCIAL FEED"),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   radius: 22,
                    //   backgroundColor: CustomColor.grey_color,
                    //   backgroundImage: AssetImage("assets/locationavatar.png"),
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                            suffixIcon: Container(
                                // padding:
                                // EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                                child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                print("pressed send");
                                setState(() {
                                  isLoader = true;
                                });
                                File asset = File((await getImageFileFromAssets("locationavatar.png")).path);
                                try {
                                  GeneralResponse response;
                                  if (pickedImage == null) {
                                    response = await AppUrl.apiService.feedsendWithoutFile(
                                      "No",
                                      message.text,
                                    );
                                  } else {
                                    response = await AppUrl.apiService.feedsend(
                                      "No",
                                      message.text,
                                      pickedImage == null ? asset : File(image!.path),
                                    );
                                  }

                                  if (response.status == 1) {
                                    setState(() {
                                      isLoader = false;
                                      message.text = "";
                                    });
                                    feeds!.Feeds(1);
                                    feeds!.notifyListeners();

                                    TopFunctions.showScaffold("${response.message}");
                                  } else {
                                    setState(() {
                                      isLoader = false;
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    isLoader = false;
                                  });
                                  print("EXCEPTIOM OF chat IS ${e}");
                                }
                              },
                              icon: Icon(
                                Icons.send_sharp,
                                color: Colors.black,
                              ),
                            )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                            hintText: "What’s on your mind?",
                            fillColor: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () async {
                        print("Camera pressed");
                        image = (await _picker.pickImage(source: ImageSource.gallery));
                        pickedImage = File(image!.path);
                        cameraImage = pickedImage!.readAsBytesSync();
                        print("Picked image is ${pickedImage}");
                        TopFunctions.showScaffold("Image selected");
                      },
                      child: Container(
                        child: Icon(
                          Icons.camera_alt,
                          color: CustomColor.grey_color,
                          size: 30,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        image = (await _picker.pickVideo(source: ImageSource.gallery));
                        pickedImage = File(image!.path);
                        cameraImage = pickedImage!.readAsBytesSync();
                        print("Picked video is ${pickedImage}");
                        TopFunctions.showScaffold("Video selected");
                      },
                      child: Container(
                        child: Icon(
                          Icons.videocam,
                          color: CustomColor.grey_color,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: size.height * 0.65,
                  margin: EdgeInsets.only(top: 80),
                  child: Consumer<SocialfeedsProvider>(builder: (context, feedsData, child) {
                    // child = Center(
                    //     child: Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: CircularProgressIndicator(
                    //     color: Colors.white,
                    //   ),
                    // ));
                    child = SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: Stack(
                          children: [
                            feedsData.socialFeeds.isEmpty
                                ? Center(
                                    child: Text(
                                      "No Feeds",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: feedsData.socialFeeds.length,
                                    itemBuilder: (BuildContext context, int Parentindex) {
                                      return (feedsData.socialFeeds[Parentindex]['_DeletedAt'] == null ||
                                              feedsData.socialFeeds[Parentindex]['_DeletedAt'].toString().isEmpty)
                                          ? Row(
                                            children: [
                                              Expanded(
                                                  flex: 8,
                                                  child: Container(
                                                    // height:size.height * 0.7,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                                                          child: ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            leading: feedsData.socialFeeds[Parentindex]['ProfilePhoto'] != null
                                                                ? CircleAvatar(
                                                                    backgroundColor: Colors.transparent,
                                                                    backgroundImage: NetworkImage(
                                                                        "${AppUrl.mediaUrl}${feedsData.socialFeeds[Parentindex]['ProfilePhoto']}"),

                                                                    //AssetImage("assets/homeBack2.png")
                                                                  )
                                                                : CircleAvatar(
                                                                    backgroundColor: Colors.transparent,
                                                                    backgroundImage: AssetImage("assets/locationavatar.png")),
                                                            title: Padding(
                                                              padding: const EdgeInsets.only(top: 15.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "${feedsData.socialFeeds[Parentindex]['FullName']}",
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontStyle: FontStyle.italic,
                                                                        fontWeight: FontWeight.w300,
                                                                        fontSize: 14),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  feedsData.socialFeeds[Parentindex]['IsPinned'] == "Yes"
                                                                      ? Icon(
                                                                          Icons.push_pin,
                                                                          color: Colors.white,
                                                                          size: 18,
                                                                        )
                                                                      : SizedBox()
                                                                ],
                                                              ),
                                                            ),
                                                            subtitle: Padding(
                                                              padding: const EdgeInsets.only(top: 5.0),
                                                              //DateTime.now().difference(DateTime.parse(feedsData.socialFeeds[Parentindex]['CreatedAt'])).inHours} hours ago
                                                              child: Text(
                                                                "${feedsData.socialFeeds[Parentindex]['CreatedAt']}",
                                                                style: TextStyle(
                                                                    color: CustomColor.lightgrey,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontWeight: FontWeight.w300,
                                                                    fontSize: 10),
                                                              ),
                                                            ),
                                                            trailing: JustTheTooltip(
                                                              controller: tooltipController,
                                                              isModal: true,
                                                              triggerMode: TooltipTriggerMode.tap,
                                                              onShow: () {
                                                                print('onShow');
                                                              },
                                                              onDismiss: () {
                                                                print('onDismiss');
                                                              },
                                                              content: Container(
                                                                height: size.height * 0.15,
                                                                width: size.height * 0.12,
                                                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        try {
                                                                          GeneralResponse response = await AppUrl.apiService
                                                                              .feedstatus({
                                                                            "Feed_ID": feedsData.socialFeeds[Parentindex]['ID'],
                                                                            "Type": "DeletedAt"
                                                                          });

                                                                          if (response.status == 1) {
                                                                            TopFunctions.showScaffold("${response.message}");
                                                                          }
                                                                        } catch (e) {
                                                                          print("EXCEPTIOM OF chat IS ${e}");
                                                                        }
                                                                      },
                                                                      child: Text("Delete"),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        try {
                                                                          GeneralResponse response = await AppUrl.apiService
                                                                              .feedstatus({
                                                                            "Feed_ID": feedsData.socialFeeds[Parentindex]['ID'],
                                                                            "Type": "ReportedAt"
                                                                          });
                                                                          print("Social feeds status ${response.message}");
                                                                          if (response.status == 1) {
                                                                            TopFunctions.showScaffold("${response.message}");
                                                                          }
                                                                        } catch (e) {
                                                                          print("EXCEPTIOM OF chat IS ${e}");
                                                                        }
                                                                      },
                                                                      child: Text("Report"),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        try {
                                                                          GeneralResponse response = await AppUrl.apiService
                                                                              .feedstatus({
                                                                            "Feed_ID": feedsData.socialFeeds[Parentindex]['ID'],
                                                                            "Type": "ArchivedAt"
                                                                          });
                                                                          print("Social feeds status ${response.message}");
                                                                          if (response.status == 1) {
                                                                            TopFunctions.showScaffold("${response.message}");
                                                                          }
                                                                        } catch (e) {
                                                                          print("EXCEPTIOM OF chat IS ${e}");
                                                                        }
                                                                      },
                                                                      child: Text("Archive"),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        try {
                                                                          final reqBody = {
                                                                            "Feed_ID": feedsData.socialFeeds[Parentindex]['ID'],
                                                                            "IsPinned":
                                                                                "${feedsData.socialFeeds[Parentindex]['IsPinned'] == "Yes" ? "No" : "Yes"}"
                                                                          };
                                                                          print("req Body is ${reqBody}");
                                                                          GeneralResponse response =
                                                                              await AppUrl.apiService.feedpinstatus(reqBody);
                                                                          print("Pinned feeds status is ${response.message}");
                                                                          if (response.status == 1) {
                                                                            TopFunctions.showScaffold("${response.message}");
                                                                            feedsData.Feeds(1);
                                                                            feedsData.notifyListeners();
                                                                          }
                                                                        } catch (e) {
                                                                          TopFunctions.showScaffold("${e}");
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          "${feedsData.socialFeeds[Parentindex]['IsPinned'] == "Yes" ? "UnPin" : "Pin It"}"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.more_horiz,
                                                                size: 24,
                                                                color: CustomColor.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                                                          child: Text(
                                                            "${feedsData.socialFeeds[Parentindex]['Body']}",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                                color: Colors.white, fontStyle: FontStyle.normal, fontSize: 12),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        feedsData.socialFeeds[Parentindex]['Attachment'].toString().isNotEmpty
                                                            ? feedsData.socialFeeds[Parentindex]['Attachment']
                                                                        .toString()
                                                                        .split(".")
                                                                        .last ==
                                                                    "mp4"
                                                                ? Container(
                                                                    height: 300,
                                                                    child: VideoPlaying(
                                                                      mediaUrl:
                                                                          "${AppUrl.mediaUrl}${feedsData.socialFeeds[Parentindex]['Attachment']}",
                                                                    ),
                                                                    // child:controller.value.isInitialized ?
                                                                    // VideoPlayer(controller)
                                                                    // :
                                                                    // Text("this is video section",style: TextStyle(color: Colors.white),)
                                                                  )
                                                                : Container(
                                                                    height: 300,
                                                                    child: Image.network(
                                                                        '${AppUrl.mediaUrl}${feedsData.socialFeeds[Parentindex]['Attachment']}',
                                                                        // fit: BoxFit.contain,
                                                                        loadingBuilder: (BuildContext context, Widget child,
                                                                            ImageChunkEvent? loadingProgress) {
                                                                      if (loadingProgress == null) return child;
                                                                      return Center(
                                                                        child: CircularProgressIndicator(
                                                                          color: Colors.white,
                                                                          value: loadingProgress.expectedTotalBytes != null
                                                                              ? loadingProgress.cumulativeBytesLoaded /
                                                                                  loadingProgress.expectedTotalBytes!
                                                                              : null,
                                                                        ),
                                                                      );
                                                                    }))
                                                            : SizedBox(),
                                                        //Like bt me
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  print(
                                                                      "LikedByMe ${feedsData.socialFeeds[Parentindex]['LikedByMe']}");
                                                                  if (feedsData.socialFeeds[Parentindex]['LikedByMe'] == "0" ||
                                                                      feedsData.socialFeeds[Parentindex]['LikedByMe'] == null) {
                                                                    try {
                                                                      GeneralResponse response = await AppUrl.apiService.feedsocial(
                                                                          {"Feed_ID": feedsData.socialFeeds[Parentindex]['ID']});
                                                                      print("Social feeds like ${response.message}");
                                                                      if (response.status == 1) {
                                                                        setState(() {
                                                                          feedsData.Feeds(pageindex);
                                                                          print("feedsData1 ${feedsData.socialFeeds}");

                                                                          feedsData.notifyListeners();
                                                                          feedsData.socialFeeds[Parentindex]['LikedByMe'] = "1";
                                                                        });

                                                                        TopFunctions.showScaffold("${response.message}");
                                                                      }
                                                                    } catch (e) {
                                                                      print("EXCEPTIOM OF chat IS ${e}");
                                                                    }
                                                                  } else {
                                                                    TopFunctions.showScaffold("Already Liked");
                                                                  }
                                                                },
                                                                child: Stack(
                                                                  children: [
                                                                    Icon(Icons.thumb_up_alt_sharp,
                                                                        color: feedsData.socialFeeds[Parentindex]['LikedByMe'] == "1"
                                                                            ? Colors.blue
                                                                            : Colors.white),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                              InkWell(
                                                                  onTap: () {},
                                                                  child: Icon(
                                                                    Icons.chat_bubble,
                                                                    color: Colors.white,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            try {
                                                              GeneralResponse response = await AppUrl.apiService.feedsociallist({
                                                                "Feed_ID": feedsData.socialFeeds[Parentindex]['ID'],
                                                              });
                                                              if (response.status == 1) {
                                                                if (feedsData.socialFeeds[Parentindex]['LikeCount'] != "0") {
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContextcontext) {
                                                                        return AlertDialog(
                                                                            contentPadding: EdgeInsets.zero,
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0)),
                                                                            content: Container(
                                                                              height: 300.0,
                                                                              width: 100.0,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                    vertical: 10.0, horizontal: 10.0),
                                                                                child: ListView.builder(
                                                                                    shrinkWrap: true,
                                                                                    itemCount: (response.data as List).length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 5.0),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text(
                                                                                              "See Who Liked This",
                                                                                              style: TextStyle(fontSize: 13),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Image.network(
                                                                                                    '${AppUrl.mediaUrl}${(response.data as List)[index]['ProfilePhoto']}',
                                                                                                    fit: BoxFit.cover,
                                                                                                    width: 30,
                                                                                                    height: 30, loadingBuilder:
                                                                                                        (BuildContext context,
                                                                                                            Widget child,
                                                                                                            ImageChunkEvent?
                                                                                                                loadingProgress) {
                                                                                                  if (loadingProgress == null)
                                                                                                    return child;
                                                                                                  return Center(
                                                                                                    child: CircularProgressIndicator(
                                                                                                      value: loadingProgress
                                                                                                                  .expectedTotalBytes !=
                                                                                                              null
                                                                                                          ? loadingProgress
                                                                                                                  .cumulativeBytesLoaded /
                                                                                                              loadingProgress
                                                                                                                  .expectedTotalBytes!
                                                                                                          : null,
                                                                                                    ),
                                                                                                  );
                                                                                                }),
                                                                                                SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                Text(
                                                                                                  "${(response.data as List)[index]['FullName']}",
                                                                                                  style: TextStyle(fontSize: 12),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }),
                                                                              ),
                                                                            ));
                                                                      });
                                                                }
                                                              } else {
                                                                TopFunctions.showScaffold("${response.message}");
                                                              }
                                                            } catch (e) {
                                                              TopFunctions.showScaffold("${e}");
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                                                            child: Text(
                                                              "${feedsData.socialFeeds[Parentindex]['LikeCount']} Likes",
                                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                                            ),
                                                          ),
                                                        ),

                                                        //comment section
                                                        Padding(
                                                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                                            child: feedsData.socialFeeds[Parentindex]['Comments'] != "{}"
                                                                ? Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                    children: [
                                                                      Container(
                                                                        //  height: 20,
                                                                        child: ListView.builder(
                                                                            shrinkWrap: true,
                                                                            itemCount: (feedsData.socialFeeds[Parentindex]['Comments']
                                                                                    as List)
                                                                                .length,
                                                                            itemBuilder: (BuildContext context, int commentIndex) {
                                                                              return Container(
                                                                                padding: EdgeInsets.only(bottom: 2.0), //  height: 20,
                                                                                child: RichText(
                                                                                    text: TextSpan(
                                                                                  // Note: Styles for TextSpans must be explicitly defined.
                                                                                  // Child text spans will inherit styles from parent
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12.0,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  children: <TextSpan>[
                                                                                    TextSpan(
                                                                                        text:
                                                                                            '${(feedsData.socialFeeds[Parentindex]['Comments'] as List)[commentIndex]['FullName']}',
                                                                                        style: const TextStyle(
                                                                                            fontWeight: FontWeight.bold)),
                                                                                    TextSpan(
                                                                                        text:
                                                                                            '  ${(feedsData.socialFeeds[Parentindex]['Comments'] as List)[commentIndex]['Body']}'),
                                                                                  ],
                                                                                )
                                                                                    // Text("Lucas Meadowcroft I was there too, finished at 51st!",
                                                                                    //   style: TextStyle(color: Colors.white,fontSize: 10,fontStyle: FontStyle.italic),),
                                                                                    ),
                                                                              );
                                                                            }),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox()),

                                                        TextFormField(
                                                          controller: comments,
                                                          style: TextStyle(color: Colors.white),
                                                          decoration: InputDecoration(
                                                              suffixIcon: Container(
                                                                  // padding:
                                                                  // EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                                                                  child: IconButton(
                                                                padding: EdgeInsets.zero,
                                                                onPressed: () async {
                                                                  try {
                                                                    GeneralResponse response = await AppUrl.apiService
                                                                        .feedcommentsend({
                                                                      "Feed_ID": feedsData.socialFeeds[Parentindex]['ID'],
                                                                      "Body": comments.text
                                                                    });
                                                                    print("message is ${message.text} pickeddata is ${pickedImage}");
                                                                    if (response.status == 1) {
                                                                      feedsData.Feeds(1);
                                                                      setState(() {
                                                                        feedsData.notifyListeners();
                                                                        comments.text = "";
                                                                      });

                                                                      TopFunctions.showScaffold("${response.message}");
                                                                    }
                                                                  } catch (e) {
                                                                    print("EXCEPTIOM OF chat IS ${e}");
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                  Icons.send_sharp,
                                                                  color: Colors.white,
                                                                  size: 22,
                                                                ),
                                                              )),
                                                              enabled: true,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)
                                                                      // borderRadius: BorderRadius.circular(50.0),
                                                                      ),
                                                              filled: false,
                                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                              hintStyle: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 10,
                                                                fontStyle: FontStyle.italic,
                                                              ),
                                                              hintText: "Add a comment....",
                                                              fillColor: Colors.white),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )
                                          : SizedBox();
                                    }),
                            isLoader == true
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : SizedBox(
                                    width: 0,
                                  )
                          ],
                        ));
                    return child;
                  }))
            ],
          ),
        ));
  }
}
