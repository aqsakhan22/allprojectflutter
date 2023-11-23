import 'package:blocprovider/bloc/internetConnectivity/internet_bloc.dart';
import 'package:blocprovider/bloc/internetConnectivity/internet_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class FlutterDocUI extends StatefulWidget {
  const FlutterDocUI({Key? key}) : super(key: key);

  @override
  State<FlutterDocUI> createState() => _FlutterDocUIState();
}

class _FlutterDocUIState extends State<FlutterDocUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: (){
            BlocProvider.of<InternetBloc>(context).add(InternetLostEvent());
          }, child: Text("add"))
        ],
      ),
    );
  }
}
