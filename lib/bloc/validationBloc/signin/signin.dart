import 'package:blocprovider/bloc/validationBloc/signin/bloc/sign_event.dart';
import 'package:blocprovider/bloc/validationBloc/signin/bloc/signin_bloc.dart';
import 'package:blocprovider/bloc/validationBloc/signin/bloc/signin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController email=TextEditingController(text: '');
  TextEditingController password=TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ValidationBlocUI"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BlocBuilder<SignIn,SignInState>(

              builder: (BuildContext context, state) {

      if(state is SignInErrorState){
        return Text("${state.errorMessage}",style: TextStyle(color: Colors.red),);

      }
else {
  return Container();
      }

              },


            ),
            TextFormField(
               controller: email ,
              onChanged: (value){
                BlocProvider.of<SignIn>(context).add(SignInTextChangedEvent(email.text,password.text));
              },
              decoration: InputDecoration(
                  hintText: "Enter Email"
              ),
            ),
            TextFormField(
              controller: password ,
              decoration: InputDecoration(
                  hintText: "Enter Password"
              ),
              onChanged: (value){
                BlocProvider.of<SignIn>(context).add(SignInTextChangedEvent(email.text,password.text));
              },
            ),
            BlocBuilder<SignIn,SignInState>(

              builder: (BuildContext context, state) {

                if(state is  SignInLoading){
                  return CircularProgressIndicator(color: Colors.purple,);

                }
        else{
                  return  ElevatedButton(

                      onPressed: (state is SignInValidState)  ? (){
                        BlocProvider.of<SignIn>(context).add(SignInSubmittedBtn(email.text,password.text));
                      } : null ,
                      child: Text("Sign in"));
                }


              },


            ),

          ],
        ),
      )
    );
  }
}
