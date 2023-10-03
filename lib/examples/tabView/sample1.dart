import 'package:flutter/material.dart';
class Simple1 extends StatefulWidget {
  const Simple1({Key? key}) : super(key: key);

  @override
  State<Simple1> createState() => _Simple1State();
}

class _Simple1State extends State<Simple1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Simple1")
        ],
      ),
    );
  }
}
