import 'package:flutter/material.dart';

class TopVariables {
  static GlobalKey<NavigatorState> appNavigationKey =
  GlobalKey<NavigatorState>();
  static Size mediaQuery = MediaQuery.of(appNavigationKey.currentContext!).size;
// static GlobalKey<FormState> formKey = GlobalKey<FormState>();
}