import 'package:flutter/material.dart';
import 'package:flutteranimations/AnimationExample.dart';
class AnimationChecking extends StatefulWidget {
  const AnimationChecking({Key? key}) : super(key: key);

  @override
  State<AnimationChecking> createState() => _AnimationCheckingState();
}

class _AnimationCheckingState extends State<AnimationChecking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("checking"),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AnimationExample()));
          }, child: Text("Example1"))
        ],
      ),
    );
  }
}
