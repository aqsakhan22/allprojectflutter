import 'package:flutter/material.dart';
import 'package:flutterdevelopment/backgroundService/backMyApp.dart';
import 'package:flutterdevelopment/backgroundService/baclgroundScreen.dart';
import 'package:flutterdevelopment/lifeCycle.dart';
import 'package:flutterdevelopment/method_channeling.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HomeScreen"),),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LifeCycle()));
          }, child: Text("Life Cycle")),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => BackgroundServiceScreen()));
          }, child: Text("Background service")),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => backMyApp()));
          }, child: Text("backMyApp service")),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MethodChanneling()));
          }, child: Text("MethodChanneling IOS")),
        ],
      ),
    );
  }
}
