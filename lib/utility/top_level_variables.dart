import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '/network/api_service.dart';
import '../network/app_url.dart';

class TopVariables{
  ///
  /// VARIABLES
  ///
  ///
  ApiService apiService = ApiService(dio.Dio(),AppUrl.baseUrl);
  static final GlobalKey<NavigatorState> appNavigationKey = GlobalKey<NavigatorState>();
  static bool IsLogin = false;
  static FlutterBackgroundService service = FlutterBackgroundService();
  // static final GoogleApiKey="AIzaSyDNwo40jR5VlmKsTI1_FgTDdDVkUMZWoxU"; // Old RunWithKT Google Account
  static final GoogleApiKey="AIzaSyBHxmOZ-ie3JPqsALAvGfmbDS8OQRlZLG8";
  static String clientID="706d9e380ba24143abd75b7e3fc1f5bc";
  static String RedirectURi="comspotifytestsdk://app.runwith.io/spotify.php";
// New RunWith Google Account
}

class TopFunctions{
  ///
  /// FUNCTIONS
  ///
  ///
  static showScaffold(String toastMsg){
    ScaffoldMessenger.of(TopVariables.appNavigationKey.currentContext!).showSnackBar(SnackBar(content: Text(toastMsg)),);
  }

  static Future<bool> internetConnectivityStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Internet Status = Connected');
        return true;
      } else {
        print('Internet Status = Not Connected');
        return false;
      }
    } on SocketException catch (_) {
      print('Internet Status = Not Connected');
      return false;
    }
  }
}
