// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMethods {
  MyMethods._internal();

  static final MyMethods _instance = MyMethods._internal();

  factory MyMethods() => _instance;

  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void toastMessage(String? msg) {
    Fluttertoast.showToast(
      msg: msg ?? "",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  final Uri _dialerUrl = Uri.parse('tel://+92 21 111262872');

  final Uri _youtubeUrl = Uri.parse(
      'https://www.youtube.com/watch?v=0A1DUDqe5kE&ab_channel=BMACapital');

  void launchDialer() async {
    if (!await launchUrl(_dialerUrl)) throw 'Could not launch $_dialerUrl';
  }

  void launchYoutube() async {
    if (!await launchUrl(_youtubeUrl)) throw 'Could not launch $_youtubeUrl';
  }

  String dateParsing(String createdAt) {
    String aDate =
        createdAt.substring(0, 10) + ' ' + createdAt.substring(11, 23);

    var dateTime = DateTime.parse(aDate);
    return DateFormat("EEE, d MMM yyyy HH:mm:ss").format(dateTime);
  }

  // void trackScreen(String screenTitle) {
  //   analytics.setCurrentScreen(
  //     screenName: screenTitle,
  //     screenClassOverride: screenTitle,
  //   );
  // }
}
