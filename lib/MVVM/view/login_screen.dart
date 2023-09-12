import 'package:firebaseflutterproject/MVVM/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  ValueNotifier<bool> obsecurePassword = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen"),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                focusNode: emailFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusNode(context, emailFocusNode, passwordFocusNode);
                },
              ),
              ValueListenableBuilder(
                  valueListenable: obsecurePassword,
                  builder: (context, value, child) {
                    return TextFormField(
                      controller: password,
                      obscureText: obsecurePassword.value,
                      obscuringCharacter: '*',
                      focusNode: passwordFocusNode,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                obsecurePassword.value = !obsecurePassword.value;
                              },
                              icon: Icon(obsecurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_rounded))),
                      onFieldSubmitted: (value) {
                        // FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                    );
                  }),
              SizedBox(
                height: height * .1,
              )
            ],
          ),
        )
        // Center(
        //   child: InkWell(
        //     onTap: (){
        //        //Utils.toastMessage("dff");
        //        Utils.flushErrorMessage("dff",context);
        //       // Navigator.pushNamed(context, RoutesName.login);
        //     },
        //     child: Text("click"),
        //   ),
        // )
        );
  }
}
