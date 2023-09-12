import 'package:firebaseflutterproject/MVVM/utils/routes/routes_name.dart';
import 'package:firebaseflutterproject/MVVM/view/home_screen.dart';
import 'package:firebaseflutterproject/MVVM/view/login_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => LoginScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No Routes Defined"),
            ),
          );
        });
    }
  }
}
