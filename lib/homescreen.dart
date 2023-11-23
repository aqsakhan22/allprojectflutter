import 'package:blocprovider/bloc/validationBloc/signin/bloc/signin_bloc.dart';
import 'package:blocprovider/bloc/validationBloc/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeScree extends StatefulWidget {
  const HomeScree({Key? key}) : super(key: key);

  @override
  State<HomeScree> createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen"),
      ),
      
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) => SignIn() ,
                child: SignInScreen(),)
            ));
          }, child: Text("Sign Screen"))
        ],
      ),
    );
  }
}
