import 'package:firebaseflutterproject/MVVM/utils/routes/routes_name.dart';
import 'package:firebaseflutterproject/MVVM/utils/utils.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Login Screen"),),
      body:  Center(
        child: InkWell(
          onTap: (){
             //Utils.toastMessage("dff");
             Utils.flushErrorMessage("dff",context);
            // Navigator.pushNamed(context, RoutesName.login);
          },
          child: Text("click"),
        ),
      )
    );
  }
}

