import 'package:blocprovider/cubit/intternetcubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class InternetCubitUI extends StatefulWidget {
  const InternetCubitUI({Key? key}) : super(key: key);

  @override
  State<InternetCubitUI> createState() => _InternetCubitUIState();
}

class _InternetCubitUIState extends State<InternetCubitUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("InternetCubitUI"),),
      body: BlocConsumer<InternetCubit,InternetStates>(
        listener: (context,state){
          // we used == because both are same
          if(state == InternetStates.Lost){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Connected")));
          }
         else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connected")));
          }
         },
        builder: (context,states){
          print("State is ${states}");
          if(states == InternetStates.Lost){
            return Text("Not Connected");
          }
          else{
            return Text("Connected");
          }


        },

      ),
    );
  }
}
