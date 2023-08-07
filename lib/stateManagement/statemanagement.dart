import 'package:firebaseflutterproject/stateManagement/counter_example.dart';
import 'package:flutter/material.dart';
class Statemanagement extends StatefulWidget {
  const Statemanagement({Key? key}) : super(key: key);

  @override
  State<Statemanagement> createState() => _StatemanagementState();
}

class _StatemanagementState extends State<Statemanagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Statemanagement"),),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderEx()));

              }, child: const Text("Provider Example")),
        ],
      ),

    );
  }
}



