import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
class MultipleFloatingBtns extends StatefulWidget {
  const MultipleFloatingBtns({Key? key}) : super(key: key);

  @override
  State<MultipleFloatingBtns> createState() => _MultipleFloatingBtnsState();
}

class _MultipleFloatingBtnsState extends State<MultipleFloatingBtns> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Multiple Floating Buttons"),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.scale,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.face,color: Colors.white,),
            label: 'Social Network',
            backgroundColor: Colors.red,
            onTap: () {
              print("Social Network pressed");
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.email,color: Colors.white,),
            label: 'Email',
            backgroundColor: Colors.green,
            onTap: () {/* Do something */},
          ),
          SpeedDialChild(
            child: const Icon(Icons.chat,color: Colors.white,),
            label: 'Message',
            backgroundColor: Colors.amberAccent,
            onTap: () {/* Do something */},
          ),
        ],


      ),

    );
  }
}
