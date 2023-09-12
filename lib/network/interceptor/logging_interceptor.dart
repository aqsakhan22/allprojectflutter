import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runwith/dialog/progress_dialog.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/theme/color.dart';
import '/utility/shared_preference.dart';
import '/utility/top_level_variables.dart';
import '../../dialog/error_dialog.dart';

class Logging extends Interceptor {
  String endpoint = "";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    endpoint = options.path;
    print('REQUEST[${options.path}] => DATA: ${options.data}');
    TopFunctions.internetConnectivityStatus().then((value) {
      if (value == false) {
        print("API is not Connected to the Internet.");
        return false;
      }
    });
    if (options.path != '/login' && options.path != '/register') {
      options.headers.addEntries([MapEntry("AuthToken", UserPreferences.AuthToken)]);

    }
    if (options.path == '/updateprofile' || options.path == '/updateprofile' ) {
      options.contentType = 'multipart/form-data';
    }
    print('Currently Hit Complete API URL:\t\t${options.baseUrl}${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.requestOptions.path}] => DATA: ${response.toString()}',);
    if (response.data['message'] == 'User Is Not Logged In') {
      _tokenExpiredDialog(TopVariables.appNavigationKey.currentContext!);
    } else if (response.data['status'] == 0) {
      showErrorDialog(response.data['message'].toString());
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    CustomProgressDialog.hideProDialog();
    print('ERROR[${err.requestOptions.path}] => DATA: ${err.toString()}',);
    if (err.response?.statusCode == 101) {
      showErrorDialog('Network Is Unreachable');
    } else if (err.response?.statusCode == 404) {
      showErrorDialog(err.error);
    } else {
      Fluttertoast.showToast(
          msg: err.error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: CustomColor.primary,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    //print("[ERROR CODE] ${err.error.statusCode}");
    //return super.onError(err, handler);
  }

  _tokenExpiredDialog(BuildContext context) async {
    return showDialog<void>(
      context: context, barrierDismissible: false, // User Must Tap Button
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                // title: Container(
                //     padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.only(
                //           topRight: Radius.circular(20.0),
                //           topLeft: Radius.circular(20.0)),
                //       color: CustomColor.primary,
                //     ),
                //     child: const Text(
                //       'Authentication Expired',
                //       style: TextStyle(color: CustomColor.white),
                //     )),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Authentication Expired",
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your Authentication Has Been Expired. Please Login Again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: ButtonWidget(
                        onPressed: () async {
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          await preferences.clear();
                          Navigator.of(context).pushNamedAndRemoveUntil('/SignIn', (Route<dynamic> route) => false);
                        },
                        color: CustomColor.grey_color,
                        textcolor: Colors.black,
                        text: "OK",
                        fontweight: FontWeight.w600,
                      ))
                ]));
      },
    );
  }
}
