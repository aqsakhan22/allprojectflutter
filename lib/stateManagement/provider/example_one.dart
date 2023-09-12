import 'package:flutter/foundation.dart';

class colorchange with ChangeNotifier {
  double value = 0;

  double get getvalue => value; // set get
  void setValue(double v) {
    value = v;
    notifyListeners();
  }
}
