import 'package:flutter/material.dart';
import 'multiple_tab.dart';
import 'single_tab.dart';



class Videoplayer_Ex extends StatefulWidget {
  @override
  _Videoplayer_ExState createState() => _Videoplayer_ExState();
}

class _Videoplayer_ExState extends State<Videoplayer_Ex> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Vlc Player Example'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Single'),
              Tab(text: 'Multiple'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            SingleTab(),
            MultipleTab(),
          ],
        ),
      ),
    );
  }
}