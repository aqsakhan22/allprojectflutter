import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
class SocialFeeds extends StatefulWidget {
  const SocialFeeds({Key? key}) : super(key: key);

  @override
  State<SocialFeeds> createState() => _SocialFeedsState();
}

class _SocialFeedsState extends State<SocialFeeds> {
  late  SocialfeedsProvider feeds;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int pageindex=1;
  List multiple_feeds=[];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController message= TextEditingController(text: "");
  TextEditingController comments= TextEditingController(text: "");
  XFile? image;
  // XFile? pickedVideo;
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? cameraImage;
  bool isPinned=false;
  bool isLoader=false;
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
  void _onLoading() async{
    setState(() {
      pageindex++;
      feeds.Feeds(pageindex);
      print("pageindex ${pageindex}");
      print("socialFeeds on loading ${feeds.socialFeeds}");

    });
    print("multiple_feeds before length is ${multiple_feeds.length}");
    //  // monitor network fetch
    await Future.delayed(Duration(seconds: 3));
    // if failed,use loadFailed(),if no data return,use LoadNodata()




    if(feeds.socialFeeds.isNotEmpty){
      print("feeds.socialFeeds is not empty");
      for(var i=0;i< feeds.socialFeeds.length; i++){
        print("social feed data is ${ feeds.socialFeeds[i]}");

        setState(() {
          multiple_feeds.add(feeds.socialFeeds[i]);
          feeds.notifyListeners();
        });
      }
      print("multiple_feeds after length is ${multiple_feeds.length}");
    }



    if(mounted)
      setState(() {

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      feeds.Feeds(pageindex);
      Future.delayed(Duration(seconds: 2),(){
        setState(() {
          multiple_feeds=feeds.socialFeeds;
        });
      });
      print("Multiple feeds is ${multiple_feeds}");
    });

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
    feeds = Provider.of<SocialfeedsProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _key,
        drawer: MyNavigationDrawer(),
        bottomNavigationBar:BottomNav(scaffoldKey: _key,),
        appBar: AppBarWidget.textAppBar("SOCIAL FEED"),
        body:SafeArea(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 22,
                      backgroundColor: CustomColor.grey_color,
                      backgroundImage: AssetImage("assets/locationavatar.png"),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 6,
                      child:
                      TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                            suffixIcon: Container(
                              // padding:
                              // EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                                child:IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async{
                                    print("pressed send");
                                    setState((){
                                      isLoader=true;
                                    });
                                    File asset= File((await getImageFileFromAssets("locationavatar.png")).path);
                                    try {
                                      GeneralResponse response = await AppUrl.apiService.feedsend(

                                        "${isPinned == false ? "NO" : "Yes"}",
                                        message.text,
                                        pickedImage == null ?
                                        asset
                                            :
                                        File(image!.path),

                                      );
                                      print("message is ${message.text} pickeddata is ${pickedImage}");
                                      if (response.status == 1) {
                                        setState((){
                                          isLoader=false;
                                        });
                                        feeds.Feeds(pageindex);
                                        feeds.notifyListeners();
                                        setState(() {
                                          multiple_feeds=feeds.socialFeeds;
                                        });

                                        TopFunctions.showScaffold("${response.message}");
                                      }
                                      else{
                                        setState((){
                                          isLoader=false;
                                        });
                                      }
                                    }
                                    catch (e) {
                                      setState((){
                                        isLoader=false;
                                      });
                                      print("EXCEPTIOM OF chat IS ${e}");
                                    }


                                  },
                                  icon: Icon(Icons.send_sharp,color: Colors.black,),
                                )

                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                            hintStyle: TextStyle(color: Colors.black,fontSize: 14,fontStyle: FontStyle.italic,),
                            hintText: "What’s on your mind?",
                            fillColor: Colors.white),
                      ),),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: () async{
                        print("Camera pressed");
                        image = (await _picker.pickImage(source: ImageSource.gallery));
                        pickedImage = File(image!.path);
                        cameraImage = pickedImage!.readAsBytesSync();
                        print("Picked image is ${pickedImage}");
                        TopFunctions.showScaffold("Image selected");
                      },
                      child:  Container(
                        child: Icon(Icons.camera_alt,color: CustomColor.grey_color,size: 30,),
                      ),
                    ),
                    InkWell(
                      onTap: () async{
                        image = (await _picker.pickVideo(source: ImageSource.gallery));
                        pickedImage = File(image!.path);
                        cameraImage = pickedImage!.readAsBytesSync();
                        print("Picked video is ${pickedImage}");
                        TopFunctions.showScaffold("Video selected");

                      },
                      child:  Container(
                        child: Icon(Icons.videocam,color: CustomColor.grey_color,size: 30,),
                      ),
                    ),
                    Checkbox(
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        //  overlayColor: MaterialStateProperty.all(Colors.red),
                        fillColor: MaterialStateProperty.all(Colors.white),


                        value: isPinned,
                        onChanged:(bool? value){
                          print("value is ${value}");
                          setState(() {
                            isPinned=value!;
                          });
                        }
                    )





                  ],
                ),
              ),

              Container(
                  height: size.height * 0.65,
                  margin: EdgeInsets.only(top: 80),
                  child:Consumer<SocialfeedsProvider>(builder: (context,feedsData1,child){
                    child=Center(
                        child:Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CircularProgressIndicator(color: Colors.white,),
                        )
                    );
                    child= SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: Stack(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount:multiple_feeds.length ,
                                itemBuilder: (BuildContext context,int index){
                                  return
                                    multiple_feeds[index]['_DeletedAt'] == null
                                        ?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading:
                                            multiple_feeds[index]['ProfilePhoto'] != null ?
                                            CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              backgroundImage:  NetworkImage("${AppUrl.mediaUrl}${multiple_feeds[index]['ProfilePhoto']}"),

                                              //AssetImage("assets/homeBack2.png")

                                            )
                                                :
                                            CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: AssetImage("assets/locationavatar.png")


                                            )

                                            ,
                                            title: Padding(
                                              padding: const EdgeInsets.only(top: 15.0),
                                              child: Text("${multiple_feeds[index]['FullName']}", style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontWeight: FontWeight.w300,fontSize: 14),),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: Text("${DateTime.now().difference(DateTime.parse(multiple_feeds[index]['CreatedAt'])).inHours} hours ago",style: TextStyle(color: CustomColor.lightgrey,fontStyle: FontStyle.italic,fontWeight: FontWeight.w300,fontSize: 10),),
                                            ),
                                            trailing:  IconButton(
                                              padding: EdgeInsets.zero,

                                              onPressed: () async{
                                                await showMenu(
                                                    context: context,
                                                    position: RelativeRect.fromLTRB(20, 150, 0, 0),
                                                    color: CustomColor.grey_color,
                                                    // constraints:  BoxConstraints.tightForFinite(height: 30),
                                                    items: [
                                                      PopupMenuItem<String>(
                                                        height: 30.0,
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(color: CustomColor.primary,fontSize: 14,fontWeight: FontWeight.w400),
                                                        ),
                                                        value: 'Delete',
                                                        onTap: () async{
                                                          try {
                                                            GeneralResponse response = await AppUrl.apiService.feedstatus(

                                                                {
                                                                  "Feed_ID":multiple_feeds[index]['ID'],
                                                                  "Type":"DeletedAt"
                                                                }


                                                            );
                                                            print("Social feeds status ${response.message} ${multiple_feeds[index]['ID']}");
                                                            if (response.status == 1) {


                                                              TopFunctions.showScaffold("${response.message}");
                                                            }
                                                          }
                                                          catch (e) {
                                                            print("EXCEPTIOM OF chat IS ${e}");
                                                          }


                                                        },
                                                      ),
                                                      PopupMenuItem<String>(
                                                        height: 30.0,
                                                        child: const Text(
                                                          'Report',
                                                          style: TextStyle(color: CustomColor.primary,fontSize: 14,fontWeight: FontWeight.w400),
                                                        ),
                                                        value: 'Report',
                                                        onTap: () async{
                                                          try {
                                                            GeneralResponse response = await AppUrl.apiService.feedstatus(

                                                                {
                                                                  "Feed_ID":multiple_feeds[index]['ID'],
                                                                  "Type":"ReportedAt"
                                                                }


                                                            );
                                                            print("Social feeds status ${response.message}");
                                                            if (response.status == 1) {


                                                              TopFunctions.showScaffold("${response.message}");
                                                            }
                                                          }
                                                          catch (e) {
                                                            print("EXCEPTIOM OF chat IS ${e}");
                                                          }
                                                        },
                                                      ),
                                                      PopupMenuItem<String>(
                                                        height: 30.0,
                                                        child: const Text(
                                                          'Archive',
                                                          style: TextStyle(color: CustomColor.primary,fontSize: 14,fontWeight: FontWeight.w400),
                                                        ),
                                                        value: 'Archive',
                                                        onTap: () async{
                                                          try {
                                                            GeneralResponse response = await AppUrl.apiService.feedstatus(

                                                                {
                                                                  "Feed_ID":multiple_feeds[index]['ID'],
                                                                  "Type":"ArchivedAt"
                                                                }


                                                            );
                                                            print("Social feeds status ${response.message}");
                                                            if (response.status == 1) {


                                                              TopFunctions.showScaffold("${response.message}");
                                                            }
                                                          }
                                                          catch (e) {
                                                            print("EXCEPTIOM OF chat IS ${e}");
                                                          }

                                                        },
                                                      ),




                                                    ]);

                                              },icon: Icon(Icons.more_horiz,color: Colors.white,size: 30,),),
                                          ),
                                        ),
                                        SizedBox(height:5,),
                                        Container(

                                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Text("${multiple_feeds[index]['Body']}",
                                            textAlign: TextAlign.left ,
                                            style: TextStyle( color: Colors.white,fontStyle: FontStyle.normal,fontSize: 12),),
                                        ),
                                        SizedBox(height:5,),




                                        multiple_feeds[index]['Attachment'].toString().split(".").last  == "mp4" ?
                                        Container(

                                          child: VideoPlaying(
                                            mediaUrl: "${AppUrl.mediaUrl}${multiple_feeds[index]['Attachment']}"
                                            ,

                                          ),

                                          // child:controller.value.isInitialized ?
                                          // VideoPlayer(controller)
                                          // :
                                          // Text("this is video section",style: TextStyle(color: Colors.white),)
                                        )
                                            :
                                        Container(
                                            height: 220,
                                            child: multiple_feeds[index]['Attachment'] == null ?
                                            CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: AssetImage("assets/locationavatar.png")


                                            )

                                                :


                                            Image.network('${AppUrl.mediaUrl}${multiple_feeds[index]['Attachment']}',fit: BoxFit.cover,
                                                loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress){
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                      value: loadingProgress.expectedTotalBytes != null ?
                                                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                }

                                            )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () async{
                                                  print("LikedByMe ${multiple_feeds[index]['LikedByMe']}");
                                                  if(multiple_feeds[index]['LikedByMe']=="0" || multiple_feeds[index]['LikedByMe'] == null ){

                                                    try {
                                                      GeneralResponse response = await AppUrl.apiService.feedsocial(

                                                          {
                                                            "Feed_ID":multiple_feeds[index]['ID']
                                                          }


                                                      );
                                                      print("Social feeds like ${response.message}");
                                                      if (response.status == 1) {

                                                        setState(() {

                                                          feedsData1.Feeds(pageindex);
                                                          print("feedsData1 ${feedsData1.socialFeeds}");
                                                          multiple_feeds=feedsData1.socialFeeds;
                                                          feedsData1.notifyListeners();
                                                          feeds.notifyListeners();
                                                          multiple_feeds[index]['LikedByMe']="1";


                                                        });

                                                        TopFunctions.showScaffold("${response.message}");
                                                      }
                                                    }
                                                    catch (e) {
                                                      print("EXCEPTIOM OF chat IS ${e}");
                                                    }
                                                  }
                                                  else{
                                                    TopFunctions.showScaffold("Already Liked");
                                                  }
                                                },
                                                child:Stack(
                                                  children: [
                                                    Icon(Icons.thumb_up_alt_sharp,color: multiple_feeds[index]['LikedByMe'] == "1" ? Colors.blue : Colors.white),

                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 3,),
                                              InkWell(
                                                  onTap: (){},
                                                  child:Icon(Icons.chat_bubble,color: Colors.white,)),

                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,right: 10.0,top:5.0),
                                          child:  InkWell(
                                            child: Text("${multiple_feeds[index]['LikeCount']} Likes",style: TextStyle(color: Colors.white, fontSize: 12),),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
                                            child:
                                            multiple_feeds[index]['Comments'] != "{}" ?
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch ,
                                              children: [
                                                Container(
                                                  //  height: 20,
                                                  child:  ListView.builder(
                                                      shrinkWrap: true ,
                                                      itemCount: (multiple_feeds[index]['Comments'] as List).length,
                                                      itemBuilder:(BuildContext context,int commentIndex){
                                                        return Container(
                                                          padding: EdgeInsets.only(bottom: 2.0),
                                                          //  height: 20,
                                                          child:
                                                          RichText(
                                                              text: TextSpan(
                                                                // Note: Styles for TextSpans must be explicitly defined.
                                                                // Child text spans will inherit styles from parent
                                                                style: const TextStyle(
                                                                  fontSize: 12.0,
                                                                  color: Colors.white,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(text: '${(multiple_feeds[index]['Comments'] as List)[commentIndex]['FullName']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                  TextSpan(text: '  ${ (multiple_feeds[index]['Comments'] as List)[commentIndex]['Body']}'),

                                                                ],

                                                              )
                                                            // Text("Lucas Meadowcroft I was there too, finished at 51st!",
                                                            //   style: TextStyle(color: Colors.white,fontSize: 10,fontStyle: FontStyle.italic),),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                                // InkWell(
                                                //   onTap: (){
                                                //     showDialog(
                                                //         context: context,
                                                //         builder: (BuildContext context){
                                                //           return AlertDialog(
                                                //             insetPadding: EdgeInsets.all(10.0),
                                                //             shape: shape10(),
                                                //             content: Container(
                                                //               width: size.width * 1,
                                                //               child: Column(
                                                //                 mainAxisSize: MainAxisSize.min,
                                                //                 children: [
                                                //                   Text("Comments",style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold),),
                                                //                   ListView.builder(
                                                //                     padding: EdgeInsets.symmetric(vertical: 10.0),
                                                //                       shrinkWrap: true ,
                                                //                       itemCount: (multiple_feeds[index]['Comments'] as List).length,
                                                //                       itemBuilder:(BuildContext context,int commentIndex){
                                                //                         return   RichText(
                                                //                             text: TextSpan(
                                                //                               // Note: Styles for TextSpans must be explicitly defined.
                                                //                               // Child text spans will inherit styles from parent
                                                //                               style: const TextStyle(
                                                //                                 fontSize: 12.0,
                                                //                                 color: Colors.white,
                                                //                               ),
                                                //                               children: <TextSpan>[
                                                //                                 TextSpan(text: '${(multiple_feeds[index]['Comments'] as List)[commentIndex]['FullName']}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                //                                 TextSpan(text: '  ${(multiple_feeds[index]['Comments'] as List)[commentIndex]['Body']}',style: TextStyle(color: Colors.black)),
                                                //
                                                //                               ],
                                                //
                                                //                             )
                                                //                           // Text("Lucas Meadowcroft I was there too, finished at 51st!",
                                                //                           //   style: TextStyle(color: Colors.white,fontSize: 10,fontStyle: FontStyle.italic),),
                                                //                         );
                                                //                       }),
                                                //                 ],
                                                //               ),
                                                //             ),
                                                //           );
                                                //         }
                                                //
                                                //     );
                                                //   },
                                                //   child:   Container(
                                                //   //  padding: EdgeInsets.symmetric(horizontal: 10.0) ,
                                                //     child: Text("More",style: TextStyle(
                                                //         color: Colors.white,
                                                //         decoration: TextDecoration.underline,
                                                //         fontSize: 12
                                                //
                                                //     ),),
                                                //   ),
                                                // ),
                                              ],
                                            )
                                                :
                                            SizedBox()
                                        ),



                                        TextFormField(
                                          controller: comments ,
                                          style: TextStyle(color: Colors.white) ,
                                          decoration: InputDecoration(

                                              suffixIcon: Container(
                                                // padding:
                                                // EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                                                  child:IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () async{
                                                      print("comments pressed send ${comments.text} ${multiple_feeds[index]['ID']}");

                                                      try {
                                                        GeneralResponse response = await AppUrl.apiService.feedcommentsend(
                                                            {
                                                              "Feed_ID":multiple_feeds[index]['ID'],
                                                              "Body":comments.text
                                                            }


                                                        );
                                                        print("message is ${message.text} pickeddata is ${pickedImage}");
                                                        if (response.status == 1) {


                                                          feedsData1.Feeds(1);
                                                          setState(() {
                                                            multiple_feeds=feedsData1.socialFeeds;
                                                            feeds.notifyListeners();
                                                            comments.text="";
                                                          });

                                                          print("Socialfeeds is ${multiple_feeds}");
                                                          TopFunctions.showScaffold("${response.message}");

                                                        }
                                                      }
                                                      catch (e) {
                                                        print("EXCEPTIOM OF chat IS ${e}");
                                                      }


                                                    },
                                                    icon: Icon(Icons.send_sharp,color: Colors.white,size: 22,),
                                                  )

                                              ),

                                              enabled: true,
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white
                                                  )
                                                // borderRadius: BorderRadius.circular(50.0),
                                              ),
                                              filled: false,
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                              hintStyle: TextStyle(color: Colors.white,fontSize: 10,fontStyle: FontStyle.italic,),
                                              hintText: "Add a comment....",
                                              fillColor: Colors.white),
                                        ),
                                        SizedBox(height: 10.0,),

                                      ],
                                    )
                                        :
                                    SizedBox()
                                  ;


                                }),
                            isLoader == true ?
                            Center(child: CircularProgressIndicator(
                              color: Colors.white,
                            ),)
                                :
                            SizedBox()
                          ],

                        )



                    );


                    return child;

                  })
              )
            ],
          ),
        )

    );
  }
}
