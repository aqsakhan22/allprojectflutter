import 'package:flutter/material.dart';
import 'package:animations/animations.dart';


class AnimationExample extends StatefulWidget {
  const AnimationExample({Key? key}) : super(key: key);

  @override
  State<AnimationExample> createState() => _AnimationExampleState();
}

class _AnimationExampleState extends State<AnimationExample> {
  bool _slowAnimations = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello  ANimations"),
      ),
      body: Column(
        children: [

          
          // AnimatedCrossFade(
          //     firstChild: const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0),
          //     secondChild: const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
          //     crossFadeState: CrossFadeState.showFirst,
          //     duration: Duration(seconds: 3))

         // AnimatedContainer(
         //   color: Colors.red,
         //   curve: Curves.bounceInOut,
         //     alignment: AlignmentDirectional.topCenter,
         //     duration: Duration(seconds: 2),
         //   child: Container(
         //     alignment: Alignment.center,
         //       padding: EdgeInsets.all(50.0),
         //
         //       child: Text("AnimatedContainer")),
         //
         // )
        ],
      ),
    );
  }
}
