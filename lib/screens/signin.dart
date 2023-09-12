import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:runwith/dialog/progress_dialog.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/auth_provider.dart';
import 'package:runwith/screens/home.dart';
import 'package:runwith/screens/welcome.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/widget/button_widget.dart';

import '../utility/top_level_variables.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late AuthProvider auth;
  String userName = "";
  String password = "";
  String userEmail = "";
  bool enablPassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(""),
        elevation: 0.0,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/RunWith-WhiteLogo.png",
                      width: 200,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome back!\nSign in to continue your running journey.",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.2, color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      // height: 50,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter User Name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            userName = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          filled: true,
                          hintText: "UserName/Email/Phone",
                          hintStyle: TextStyle(color: CustomColor.grey_color, fontSize: 12),
                          // label: Text(
                          //   "User Name",
                          //   style: TextStyle(
                          //     color: CustomColor.grey_color,
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w100,
                          //   ),
                          // ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), //<-- SEE HERE
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      // height: 50,
                      child: TextFormField(
                        // keyboardType: TextInputType.visiblePassword,
                        obscureText: enablPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                enablPassword = !enablPassword;
                              });
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: CustomColor.grey_color,
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),

                          filled: true,
                          hintText: "Password",
                          hintStyle: TextStyle(color: CustomColor.grey_color, fontSize: 12),
                          // label: Text(
                          //   "User Name",
                          //   style: TextStyle(
                          //     color: CustomColor.grey_color,
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w100,
                          //   ),
                          // ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), //<-- SEE HERE
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    width: size.width * 0.6,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: CustomColor.grey_color,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show(status: "Signing In...");
                            final Map<String, dynamic> LoginData = {
                              "UserName": userName.toString(),
                              "UserPassword": password.toString()
                            };
                            final response = await AppUrl.apiService.login(LoginData);
                            EasyLoading.dismiss();
                            if (response.status == 1) {
                              auth.update_login(response.data);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
                              TopFunctions.showScaffold(response.message);
                            } else {
                              TopFunctions.showScaffold(response.message);
                            }
                          }
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              content: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Forgot Password",
                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            userEmail = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          label: Text("Email"),
                                          labelStyle: TextStyle(color: CustomColor.grey_color),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: CustomColor.grey_color),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Container(
                                    alignment: Alignment.center,
                                    child: ButtonWidget(
                                      onPressed: () async {
                                        EasyLoading.show(status: "Generating New Password Link...");
                                        final Map<String, dynamic> reqData = {
                                          "Email": userEmail.toString(),
                                        };
                                        final response = await AppUrl.apiService.forgetpassword(reqData);
                                        EasyLoading.dismiss();
                                        if (response.status == 1) {
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => WelcomeScreen()), (route) => false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("${response.message}")),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("${response.message}")),
                                          );
                                        }
                                      },
                                      color: CustomColor.grey_color,
                                      textcolor: Colors.black,
                                      text: "Confirm",
                                      fontweight: FontWeight.w600,
                                    ))
                              ],
                            );
                          });
                    },
                    child: Text("Forgot your password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
