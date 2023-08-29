
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:another_flushbar/flushbar.dart';
class Utils{


  static toastMessage(String message){
    Fluttertoast.showToast(msg: message,
      backgroundColor: Colors.red
    );
  }

  static flushErrorMessage(String message,BuildContext context){
    showFlushbar(context: context,
      flushbar: Flushbar(
        message: message,
        backgroundColor: Colors.black,
        forwardAnimationCurve: Curves.decelerate,
        margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        duration: Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
      )..show(context),



    );
  }
  static snackBar(String message,BuildContext context){

    SnackBar(
      backgroundColor: Colors.red,
      content: Text(message)

    );
  }
}