import 'dart:async';

import 'package:flutter/material.dart';
class StreamSubEx extends StatefulWidget {
  const StreamSubEx({Key? key}) : super(key: key);

  @override
  State<StreamSubEx> createState() => _StreamSubExState();
}

class _StreamSubExState extends State<StreamSubEx> {
  final streamController = StreamController<DateTime>.broadcast();
  late StreamSubscription<DateTime> subscription;
  late StreamSubscription sub;
  final unsubscribeAt = DateTime.now().add(Duration(seconds: 10));
   Timer? timer;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
    timer!.cancel();
   streamController.close();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();




    timer=Timer.periodic(Duration(seconds: 1), (timer) {
      print("isClosed ${streamController.isClosed}");

      if(streamController.isClosed == false){
        streamController.add(DateTime.now());

      }



    }
    );


    subscription= streamController.stream.listen((event) async{
      print("stream event is ${event} ${streamController.isClosed}");
      // if (event.isAfter(unsubscribeAt)) {
      //   print("It's after ${unsubscribeAt}, cleaning up the stream");
      //
      //   await streamController.close();
      //   await subscription!.cancel();
      //   // subscription.pause();
      //   // subscription.resume();
      //   // subscription.cancel();
      // }
    },


        onError: (err, stack){
          print('the stream had an error :(');
        }, onDone: () {
          print('the stream is done :)');
        }
    );


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("StreamSubEx"),),
      body:    StreamBuilder(
          stream: streamController.stream,
          builder: (context, AsyncSnapshot<DateTime> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            return Column(
              children: [
                Text("${snapshot.data!.hour} : ${snapshot.data!.minute} : ${snapshot.data!.second}",textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 50, color: Colors.blue),
                ),

                ElevatedButton(onPressed: (){
                  // push events
                  // streamController.sink.add(1);
                  // streamController.sink.add(100);
                   subscription.cancel();
                   streamController.close();
                   timer!.cancel();


                }, child: Text("Cancel "))
              ],
            );

          })
    );
  }
}
