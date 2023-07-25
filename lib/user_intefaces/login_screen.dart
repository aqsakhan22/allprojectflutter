import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String value="Aqsa";
  showCreateTicketBottomSheet() {
    Size size = MediaQuery.of(context).size;
    // value="aqsa";
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        isScrollControlled: true,
        context: context,
        enableDrag: true,
        builder: (BuildContext context) {

      return  StatefulBuilder(builder: (context, setState){

        return     Container(
          height: 200,
          child: Column(
            children: [
              Text("${value}"),
              ElevatedButton(onPressed: (){
                setState(() {
                  value="klham";
                });
              }, child: Text("change the value")),

              ElevatedButton(onPressed: (){
                setState(() {
                  value="aqsa";
                });
              }, child: Text("change  aqsa")),


            ],
          ),
        );
      });

    }

    );



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Splash Screen"),),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: (){
            showCreateTicketBottomSheet();

          }, child: Text("check bottom sheet"))
        ],
      )
    );
  }
}

