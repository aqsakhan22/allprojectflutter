import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdevelopment/top_level_variables.dart';
class MethodChanneling extends StatefulWidget {
  const MethodChanneling({Key? key}) : super(key: key);

  @override
  State<MethodChanneling> createState() => _MethodChannelingState();
}

class _MethodChannelingState extends State<MethodChanneling> {

  var channel=const MethodChannel("AqsaChannel");
  var Batterychannel=const MethodChannel("samples.flutter.io/battery");
  var StreamCancel=const MethodChannel("cancelStream");
  EventChannel eventChannel = EventChannel('samples.flutter.io/charging');


  String message="hello ";
  String Name="What is my name ";
  int getBatteryLevel=0;
  String _chargingStatus = 'Battery status: unknown.';
  //methid channel it should be unique
 Future<void> showToast() async{
   String messageFromNativeCode="";
    print("press show toast");
    //what method u want to invoke
    try{
     messageFromNativeCode=await channel.invokeMethod("showToast",{
        'message':"Subscribe my channel"
      });
     print("shpw taos message ${messageFromNativeCode}");
    } on PlatformException catch(e){
messageFromNativeCode="Failed to get meesage ${e.message}";
    }

    setState(() {
      message=messageFromNativeCode;
    });
  }

  Future<void> showName() async{
   String messageFromNativeCode="";
    print("press show name");
    //what method u want to invoke
    try{
      messageFromNativeCode=await channel.invokeMethod("showName1","askhjhgj");
     // messageFromNativeCode=await channel.invokeMethod("showName1",{
     //   "msg":"hello world"
     // });
     print("showName message ${messageFromNativeCode}");
    } on PlatformException catch(e){
messageFromNativeCode="Failed to get Name ${e.message}";
    }

    setState(() {
      Name=messageFromNativeCode;
    });
  }

  Future<void> sendingMap() async{
   String messageFromNativeCode="";
    print("press show name");
    //what method u want to invoke
    try{
      messageFromNativeCode=await channel.invokeMethod("showName2",{"name":"aqsa khan"});
     // messageFromNativeCode=await channel.invokeMethod("showName1",{
     //   "msg":"hello world"
     // });
     print("showName message ${messageFromNativeCode}");
    } on PlatformException catch(e){
messageFromNativeCode="Failed to get Name ${e.message}";
    }

    setState(() {
      Name=messageFromNativeCode;
    });
  }

  Future<void> getBattery() async{
   int messageFromNativeCode=0;
    print("press show toast");
    //what method u want to invoke
    try{
     messageFromNativeCode=await Batterychannel.invokeMethod("getBatteryLevel");
    } on PlatformException catch(e){
messageFromNativeCode=0;
    }

    setState(() {
      getBatteryLevel=messageFromNativeCode;
    });
  }

  void _onEvent(Object? event) {
    setState(() {
      _chargingStatus =
      "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = 'Battery status: unknown.';
    });
  }

  Future<void> cancelStream() async{

    try{
     await StreamCancel.invokeMethod("StreamCancel");

    } on PlatformException catch(e){
       print("Cancel Stream ${e}");
    }

  }



  @override
  void initState() {
    // TODO: implement initState
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);


    // TopVariables.service.startService().then((value) {
    //   //Run After Service Start
    //   print("Background Service Started In Foreground In Home");
    //
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("MethodChanneling"),
      ) ,
      body: Container(
        child:Column(
          children: [
            Text("${message}"),
            ElevatedButton(onPressed: (){
              showToast();

            }, child: Text("show toast using Native code")),
             ElevatedButton(onPressed: (){
              showName();

            }, child: Text("show tName")),

            ElevatedButton(onPressed: (){
              sendingMap();

            }, child: Text("sendingMap")),

            Text("${Name}"),

            Text("_chargingStatus ${_chargingStatus}"),


            ElevatedButton(onPressed: (){
              cancelStream();

            }, child: Text("Cancel stream")),

          ],
        ),
      ),
    );
  }
}
