import 'package:blocprovider/bloc/internetConnectivity/internet_bloc.dart';
import 'package:blocprovider/bloc/internetConnectivity/internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class InternetUI extends StatelessWidget {
  const InternetUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Internet UI"),),
      // bloc receiving event and emit state
      // builder UI banany k loye kam ata hai
      // listener If we want to do some background task
      body:      Center(
        child:
        BlocConsumer<InternetBloc,InternetState>(
          listener: (context,state){
            if(state is InternetGainedState){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connected")));
            }
            else if(state is InternetLostState){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Connected")));
            }

          },
          builder: (context,state){
            if(state is InternetGainedState){
              return Text("Connected");
            }
            else if(state is InternetLostState){
              return Text("Not Connected");
            }
            else{
              return Text("Loading");

            }

          },

        ),
      )

      // BlocBuilder<InternetBloc,InternetState>(
      //   builder: (BuildContext context, state) {
      //     // for checking data type we using is
      //     //if(a is int)
      //     // if(a == 2)
      //     if(state is InternetGainedState){
      //       return Text("Connected ${state}");
      //     }
      //     else if(state is InternetLostState){
      //       return Text("Not Connected");
      //     }
      //     else{
      //       return Text("Loading");
      //
      //     }
      //
      // },),

    );
  }
}
