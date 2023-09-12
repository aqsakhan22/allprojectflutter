import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

import '../../network/response/general_response.dart';
class PersonalChats extends StatefulWidget {
  final String? name;
  final String? Id;
  const PersonalChats({Key? key,  this.Id, this.name }) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late ChatProvider chatprovider;
  TextEditingController message= TextEditingController(text: "");
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  // File? theChosenImg;
  // Uint8List? uploadedImage;
  XFile? image;
  // XFile? pickedVideo;
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? cameraImage;
  int pageindex =1;
  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.show(status: 'Updating...');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatprovider.getPersonalChat(widget.Id!,pageindex);
      EasyLoading.dismiss();
    });

    // assetstoFile();
    super.initState();
  }
  void _onRefresh() async {
    // monitor network fetch

    // feeds!.Feeds(1);
    // feeds!.notifyListeners();

    await Future.delayed(Duration(seconds: 3));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    setState(() {
      pageindex++;
      chatprovider.getPersonalChat(widget.Id!,pageindex);
    });
    EasyLoading.show(status: 'Updating...');
    await Future.delayed(Duration(seconds: 3));
    if (chatprovider.forumChat.isEmpty) {
      print("social feed is empty means next page has no data so we have to load page=1 data");
      chatprovider.getPersonalChat(widget.Id!,1);
      chatprovider.notifyListeners();
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();

    // // print("multiple_feeds before length is ${multiple_feeds.length}");
    // //  // monitor network fetch
    //  await Future.delayed(Duration(seconds: 3));
    //  // if failed,use loadFailed(),if no data return,use LoadNodata()
    //
    //  if(feeds.socialFeeds.isNotEmpty){
    //    print("feeds.socialFeeds is not empty");
    //    for(var i=0;i< feeds.socialFeeds.length; i++){
    //      print("social feed data is ${ feeds.socialFeeds[i]}");
    //
    //      setState(() {
    //        multiple_feeds.add(feeds.socialFeeds[i]);
    //        feeds.notifyListeners();
    //      });
    //    }
    //
    //  }
    //
    //
    //
    //  if(mounted)
    //    setState(() {
    //
    //    });
    _refreshController.loadComplete();
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
    chatprovider=Provider.of<ChatProvider>(context);
    return Scaffold(
      key: _key,
      drawer: MyNavigationDrawer(),
      bottomNavigationBar: BottomNav(scaffoldKey: _key,),
      appBar: AppBarWidget.textAppBar("${widget.name}"),
      body: Container(
        child:


        Consumer<ChatProvider>(
          builder: (BuildContext context, chatsDetails, child){
            child= Stack(
              children: [
                Column(
                  children: [
                    chatsDetails.personalChat.isEmpty ?
                    child=Center(
                      child: Text("No Chat Found",textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                    )
                        :
                    Expanded(
                        child:
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount:chatsDetails.personalChat.length,
                            itemBuilder: (BuildContext context,int index){
                              return
                                Container(
                                  //  color: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      chatsDetails.personalChat[index]['Sender_ID'] == UserPreferences.get_Login()['ID'] ?
                                      Expanded(
                                          child: Container(
                                            width: size.width * 0.7,
                                            padding: EdgeInsets.symmetric(vertical: 15.0,),
                                            margin: EdgeInsets.only(right: 10.0),
                                            decoration: BoxDecoration(
                                                color: CustomColor.grey_color,
                                                borderRadius: BorderRadius.circular(10.0)
                                            ),

                                            child: Text("${chatsDetails.personalChat[index]['Message']}",textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                          ))
                                          :
                                      chatsDetails.personalChat[index]['ReceiverProfilePhoto'] != null ?
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                          NetworkImage(
                                              "${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['ReceiverProfilePhoto']}")



                                      )
                                          :
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                          AssetImage("assets/locationavatar.png")



                                      )
                                      ,
                                      //second part
                                      chatsDetails.personalChat[index]['Sender_ID'] == UserPreferences.get_Login()['ID'] ?
                                      chatsDetails.personalChat[index]['SenderProfilePhoto'] != null ?
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                          NetworkImage(
                                              "${AppUrl.mediaUrl}${chatsDetails.personalChat[index]['SenderProfilePhoto']}")



                                      )
                                          :
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                          AssetImage("assets/locationavatar.png")



                                      )
                                          :
                                      Container(
                                        width: size.width * 0.7,
                                        padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
                                        decoration: BoxDecoration(
                                            color: CustomColor.grey_color,
                                            borderRadius: BorderRadius.circular(10.0)
                                        ),

                                        child: Text(" ${chatsDetails.personalChat[index]['Message']}",textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                      )
                                    ],
                                  ),
                                );

                            })


                    )
                  ],
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                  // margin: EdgeInsets.only(bottom: 100.0),

                  child: Row(
                    children: [
                      IconButton(
                        padding:EdgeInsets.zero,
                        onPressed: () async{
                          image = (await _picker.pickImage(source: ImageSource.gallery));
                          pickedImage = File(image!.path);
                          cameraImage = pickedImage!.readAsBytesSync();
                          TopFunctions.showScaffold("Image selected");
                        },icon: Icon(Icons.camera_alt_rounded,color: CustomColor.grey_color,size: 32,),),
                      IconButton(
                        padding:EdgeInsets.zero,
                        onPressed: () async{
                          image = (await _picker.pickVideo(source: ImageSource.gallery));
                          pickedImage = File(image!.path);
                          TopFunctions.showScaffold("Video selected");
                        },icon: Icon(Icons.videocam,color: CustomColor.grey_color,size:32),),
                      Expanded(
                        child:  TextFormField(
                          controller: message,
                          onChanged: (value){

                          },
                          decoration: InputDecoration(
                              fillColor: CustomColor.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical:5.0,horizontal: 5.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(),
                              ),
                              suffixIcon: Container(
                                padding:
                                EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                                child:ButtonWidget(
                                  btnHeight: 30,
                                  onPressed: () async{

                                    File asset= File((await getImageFileFromAssets("locationavatar.png")).path);
                                    try {
                                      GeneralResponse response = await AppUrl.apiService.chatsendMedia(
                                          pickedImage == null ?
                                          asset
                                              :
                                          File(image!.path),
                                          "${widget.name == "CLUB CHATS" ? "Club" :"Personal" }",
                                          "${widget.Id}",
                                          "${message.text}"
                                      );
                                      if (response.status == 1) {
                                        chatprovider.getPersonalChat("${widget.Id}", 1);
                                        message.text="";
                                        chatsDetails.notifyListeners();

                                        TopFunctions.showScaffold("${response.message}");
                                      }
                                    }
                                    catch (e) {
                                      print("EXCEPTIOM OF chat IS ${e}");
                                    }

                                  },

                                  color: Colors.black,
                                  text: "Send",
                                  textcolor: CustomColor.white,
                                ),
                              )
                          ),


                        ),
                      )
                    ],
                  ),
                ),
              ],
            )


            ;

            return child;
          },
        ),



      ),
    );
  }
}
