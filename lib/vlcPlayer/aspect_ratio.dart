
import 'package:flutter/material.dart';
class AspectRatioEx extends StatefulWidget {
  const AspectRatioEx({Key? key}) : super(key: key);

  @override
  State<AspectRatioEx> createState() => _AspectRatioExState();
}

class _AspectRatioExState extends State<AspectRatioEx> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("aspect ratio Example"),),
      body: Column(
        children: [
          AspectRatio(aspectRatio: 16 /9 ,

          child: Container(
            color: Colors.red,
            child: Text("jkg"),
          ),
          )
        ],
      ),
    );
  }
}
