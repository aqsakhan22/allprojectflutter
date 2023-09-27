import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppSnackBar {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void toastMessage(String? msg) {
    Fluttertoast.showToast(
      msg: msg ?? "",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
