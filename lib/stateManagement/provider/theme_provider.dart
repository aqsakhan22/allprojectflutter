import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  var _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setTheme(themeModeChange) {
    _themeMode = themeModeChange;
    notifyListeners();
  }
}
