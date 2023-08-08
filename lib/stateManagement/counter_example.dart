import 'dart:async';

import 'package:firebaseflutterproject/stateManagement/provider/count_provider.dart';
import 'package:firebaseflutterproject/stateManagement/provider/example_one.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProviderEx extends StatefulWidget {
  const ProviderEx({Key? key}) : super(key: key);

  @override
  State<ProviderEx> createState() => _ProviderExState();
}

class _ProviderExState extends State<ProviderEx> {
  // late final countProvider;
  double value=1.0;
  late Timer timer;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final countProvider=Provider.of<CountProvider>(context,listen: false);
    timer=Timer.periodic(Duration(seconds: 1), (timer) {

      countProvider.setCount();
    });
    // countProvider=Provider.of<CountProvider>(context);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    final countProvider=Provider.of<CountProvider>(context,listen: false);
    final valueProvider=Provider.of<colorchange>(context,listen: false);
    print("build");
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title: Text("Provide"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
       Consumer<CountProvider>(builder: (BuildContext context,details,child){

         return  Center(
           child:   Text("${details.counter}",style: TextStyle(fontSize: 48),),
         );
       }),

       //    Consumer<colorchange>(builder: (BuildContext context,details,child){
       //
       //   return     Column(
       //     children: [
       //
       //       Slider(
       //           min: 0,
       //           max: 1,
       //           value: details.value, onChanged: (v){
       //         details.setValue(v);
       //
       //       }),
       //       Row(
       //         children: [
       //           Expanded(child: Container(
       //             color: Colors.red.withOpacity(details.value),
       //             child: Text("container 1 ${ details.value}"),
       //           ),
       //
       //
       //           ),
       //
       //           Expanded(child: Container(
       //             color: Colors.green.withOpacity(details.value),
       //             child: Text("container 3"),
       //           ),
       //
       //
       //           )
       //         ],
       //       ),
       //     ],
       //   );
       // }),



        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          countProvider.setCount();
        },
      ),
    );
  }
}