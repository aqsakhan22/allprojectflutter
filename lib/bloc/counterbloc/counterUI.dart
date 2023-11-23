import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CounterUI extends StatefulWidget {
  const CounterUI({Key? key}) : super(key: key);

  @override
  State<CounterUI> createState() => _CounterUIState();
}

class _CounterUIState extends State<CounterUI> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter UI"),),
      body:const Column(
        children: [

        ],
      ),
    );
  }
}
