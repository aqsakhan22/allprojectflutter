import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/screens/signin.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/country_list.dart';
import 'package:runwith/utility/local.dart';
import 'package:runwith/utility/network.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/utility/validator.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:runwith/widget/input_textform_fields.dart';

import '../providers/auth_provider.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String password = '';
  String phoneNum = '';
  Local _platformVersion = Local(dialCode: '+92', countryCode: 'PK');
  bool isCountrySelected = false;
  String fname = "";
  String surname = "";
  String email = "";
  String confirmpassword = "";
  String countryName = "";
  late AuthProvider auth;

  @override
  void initState() {;
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getCountry();
    });
    super.initState();
  }

  void getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    (await n.getData().then((value) {
      print("http://ip-api.com/json ${value}");
      String locationx = jsonDecode(value)["countryCode"];
      _platformVersion.countryCode = locationx;
      setState(() {
        countryName = jsonDecode(value)["country"];
        _platformVersion.countryCode = locationx;
        _platformVersion.dialCode =
            "+" + countryList.firstWhere((element) => element.isoCode == locationx, orElse: () => countryList.first).phoneCode;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(""),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/RunWith-WhiteLogo.png",
                  width: 180,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //FirstName
              InputTextFormField(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                keyboardType: TextInputType.name,
                label: "First Name",
                validateData: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter First Name';
                  }
                  return null;
                },
                valueChange: (value) {
                  setState(() {
                    fname = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              //Surname
              InputTextFormField(
                keyboardType: TextInputType.name,
                label: "Surname",
                valueChange: (value) {
                  setState(() {
                    surname = value;
                  });
                },
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              SizedBox(
                height: 10,
              ),
              //Email
              InputTextFormField(
                keyboardType: TextInputType.emailAddress,
                label: "Email",
                validateData: validateEmail,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                valueChange: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              //Password
              InputTextFormField(
                label: "Password",
                validateData: validatePassword,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                valueChange: (String value) {
                  print("password is value ${value}");
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              //Confirm Password
              InputTextFormField(
                  label: "Confirm Password",
                  validateData: (value) => validateConfirm(password, value),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  valueChange: (value) {
                    print("confirm password is ${value}");
                  }),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                  padding: EdgeInsets.only(left: 5), //color: Colors.red,
                  child: CountryCodePicker(
                      textStyle: TextStyle(color: Colors.white),
                      flagWidth: 40.0,
                      onChanged: (countryCode) {
                        _platformVersion.countryCode = countryCode.code;
                        _platformVersion.dialCode = countryCode.dialCode;
                        _platformVersion.countryName = countryCode.name;
                        countryName = countryCode.name!;
                        isCountrySelected = true;
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: _platformVersion.countryCode!,
                      favorite: [_platformVersion.dialCode!, _platformVersion.countryCode!],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                      flagDecoration: BoxDecoration(
                        // border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      )),
                  //flex: 6,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Container(
                      child: TextFormField(
                        autofocus: false,
                        validator: (value) => value!.isEmpty ? 'Please enter Phone Number' : null,
                        onChanged: (value) {
                          phoneNum = _platformVersion.dialCode! + value;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          //contentPadding: EdgeInsets.only(top: 0.0,bottom: 0.0),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                        style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: ButtonWidget(
                  btnWidth: size.width * 0.4,
                  btnHeight: 40,
                  color: CustomColor.grey_color,
                  textcolor: Colors.black,
                  fontSize: 14,
                  fontweight: FontWeight.w800,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show(status: "Signin Up...");
                      final Map<String, dynamic> SignUpData = {
                        "Club_ID": "1",
                        'Email': email.toString(),
                        'Phone': phoneNum.toString(),
                        'UserName': fname.toString() + surname.toString(),
                        'UserPassword': password.toString(),
                        'Country': countryName.toString(),
                        'ReferralBy': "SuperAdmin",
                      };
                      final response = await AppUrl.apiService.signup(SignUpData);
                      EasyLoading.dismiss();
                      if (response.status == 1) {
                        // Auto Login after Signup
                        final Map<String, dynamic> LoginData = {
                          "UserName": fname.toString() + surname.toString(),
                          "UserPassword": password.toString()
                        };
                        final response = await AppUrl.apiService.login(LoginData);
                        if (response.status == 1) {
                          auth.update_login(response.data);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
                          TopFunctions.showScaffold(response.message);
                        } else {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
                          TopFunctions.showScaffold(response.message);
                        }
                        // Auto Login after Signup
                        TopFunctions.showScaffold(response.message);
                      } else {
                        TopFunctions.showScaffold(response.message);
                      }
                    }
                  },
                  text: 'Sign Up',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
