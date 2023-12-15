import 'package:flutter/material.dart';
import 'package:notificationflutter/SplashScreen.dart';
import 'package:notificationflutter/dashboard.dart';
import 'package:notificationflutter/exampleNototifications.dart';




class MyRoute {
  Route<dynamic> generateRoute(RouteSettings settings) {
    print("RouteSettings is ${settings.name}");
    switch (settings.name) {

      case 'splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      // case 'DashboardScreen':
      //   return MaterialPageRoute(builder: (_) => const DashboardScreen());


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("no route found ${settings.name}"),
            ),
          ),
        );
    }
  }
}


