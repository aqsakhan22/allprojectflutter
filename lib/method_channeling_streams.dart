import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodShannelingStreatms extends StatefulWidget {
  const MethodShannelingStreatms({Key? key}) : super(key: key);

  @override
  State<MethodShannelingStreatms> createState() => _MethodShannelingStreatmsState();
}

class _MethodShannelingStreatmsState extends State<MethodShannelingStreatms> {


   final EventChannel chargingStream = const EventChannel('chargingModule');
   final EventChannel _stream = const EventChannel('locationStatusStream');
   final EventChannel message = const EventChannel('message');
   static const stream = EventChannel('com.chamelalaboratory.demo.flutter_event_channel/eventChannel');
   late StreamSubscription _streamSubscription;
   double _currentValue = 0.0;
   String chargingLevel="getting charging value";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _handleLocationChanges();
 //   onStreamBattery();
 //    onStreamMessages();

  }

   void _startListener() {
     _streamSubscription = stream.receiveBroadcastStream().listen(_listenStream);
   }

   void _cancelListener() {
     _streamSubscription.cancel();
     setState(() {
       _currentValue = 0;
     });
   }

   void _listenStream(value) {
     debugPrint("Received From Native:  $value\n");
     setState(() {
       _currentValue = value;
     });
   }
   void onStreamBattery() {
     _streamSubscription=chargingStream.receiveBroadcastStream().listen((event) {
       print("stream value is ${event}");
       setState(() {
         chargingLevel="${event}";
       });

     });

   }

   void onStreamMessages() {
  print("onStreamMessages()");

     message.receiveBroadcastStream({'name':"aqwsa"}).listen((event) {
       print("stream value is ${event}");
       setState(() {
         chargingLevel="${event}";
       });

     });

   }
   void _handleLocationChanges() {

print("_handleLocationChanges");
     _streamSubscription=_stream.receiveBroadcastStream().listen((onData) {
       setState(() {
         chargingLevel=onData();
       });
       print("On data is ${onData}");
       print("LOCATION ACCESS IS NOW ${onData ? 'On' : 'Off'}");
       if (onData == false) {
         // Request Permission Access
       }
     });
   }
   @override
   void dispose() {
    // TODO: implement dispose
     _streamSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MethodShannelingStreatms"),
      ),
      body: Container(
        child: Column(children: [

Text("${chargingLevel}"),

          // Value in text
          Text("Received Stream From Native:  $_currentValue".toUpperCase(),
              textAlign: TextAlign.justify),
          const SizedBox(
            height: 50,
          ),

          //Start Btn
          TextButton(
            onPressed: () => _startListener(),
            child: Text("Start Counter".toUpperCase()),
          ),
          const SizedBox(
            height: 50,
          ),

          //Cancel Btn
          TextButton(
            onPressed: () => _cancelListener(),
            child: Text("Cancel Counter".toUpperCase()),
          ),


        ],),
      ),
    );
  }


}


class EventChannelTutorial {
  static const MethodChannel _channel =
  const MethodChannel('event_channel_tutorial');

  // New for stream we use Event Channel
  static const EventChannel _randomNumberChannel = const EventChannel('random_number_channel');



  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // New
  static Stream<int> get getRandomNumberStream {
    return _randomNumberChannel.receiveBroadcastStream().cast();
  }
}