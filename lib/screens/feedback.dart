import 'package:flutter/material.dart';
import 'package:runwith/dialog/progress_dialog.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/screens/thankyou.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';

import '../network/app_url.dart';
import '../widget/app_bar_widget.dart';

class Feedbackscreen extends StatefulWidget {
  const Feedbackscreen({Key? key}) : super(key: key);

  @override
  State<Feedbackscreen> createState() => _FeedbackscreenState();
}

class _FeedbackscreenState extends State<Feedbackscreen> {
  final _formkey = GlobalKey<FormState>();
  String feedback = "";
  bool feedbackClick = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.textAppBar('FEEDBACK'),
      bottomNavigationBar: BottomNav(scaffoldKey: _key,),
      key: _key,
      drawer: MyNavigationDrawer(),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: Text(
                    "We’d love to hear your feedback! Your opinion helps us improve your app experience more. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, height: 1.3, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: Colors.black, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      hintText: "Type in your feedback here",
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter feedback";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    feedback = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: ButtonWidget(
                    btnHeight: 35,
                    btnWidth: MediaQuery.of(context).size.width * 0.25,
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        CustomProgressDialog.showProDialog();
                        setState(() {
                          feedbackClick = !feedbackClick;
                        });
                        if (true) {
                          final Map<String, dynamic> LoginData = {
                            "Message": feedback.toString(),
                          };
                          final response = await AppUrl.apiService.feedback(LoginData);
                          if (response.status == 1) {
                            CustomProgressDialog.hideProDialog();
                            setState(() {
                              feedback = "";
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ThankYou()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.message)),
                            );
                          } else {
                            CustomProgressDialog.hideProDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.message)),
                            );
                          }
                        }
                      }
                    },
                    color: feedbackClick == false ? CustomColor.grey_color : CustomColor.orangeColor,
                    textcolor: Colors.black,
                    text: "SUBMIT",
                    fontSize: 14,
                    fontweight: FontWeight.w600,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
