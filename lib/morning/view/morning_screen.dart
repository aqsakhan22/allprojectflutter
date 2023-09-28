import 'package:flutter/material.dart';
import '../morning.dart';

class MorningScreen extends StatelessWidget {
  const MorningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: MorningHeader(),
          ),
          Expanded(
            flex: 2,
            child: MorningBody(),
          ),
        ],
      ),
    );
  }
}
