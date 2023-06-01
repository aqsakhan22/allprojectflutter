import 'dart:async';

import 'package:flutter/material.dart';
class LifeCycle extends StatefulWidget {
  const LifeCycle({Key? key}) : super(key: key);

  @override
  State<LifeCycle> createState() => _LifeCycleState();
}

class _LifeCycleState extends State<LifeCycle> with WidgetsBindingObserver {
  int counter=0;
  late Timer timer;
  bool active=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
WidgetsBinding.instance.addObserver(this);
    timer=Timer.periodic(Duration(seconds: 1), (timer) {
      // print("Timer is runnning ${counter}");

     if(active){
       setState(() {
         counter +=1;
       });
     }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print("calling observcer ${state}");
    switch(state){

      case  AppLifecycleState.resumed:
        print("resumed"); // in foreground Responding to user
        //means App is in foreground

        break;
      case  AppLifecycleState.inactive:
        print("inactive");
        //app is partially visible not focused
        //App is inactive and user can't interact

        break;
      case AppLifecycleState.paused:
      //App is in background
      //not visible , no response , background
        print('Paused');

        break;
      case AppLifecycleState.detached:
        print('Detached');
        //vuew destroyed
        //App closed
        //.destroyed

        break;

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LifeCycle"),),
      body: Center(child: Text("${counter}",style: TextStyle(fontSize: 32),)),
    );
  }
}
