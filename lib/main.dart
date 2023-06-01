import 'package:flutter/material.dart';
import 'package:flutterdevelopment/backgroundService/back_service.dart';
import 'package:flutterdevelopment/backgroundService/example_back_service.dart';

import 'package:flutterdevelopment/homeScreen.dart';


import 'package:flutterdevelopment/service_example.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    print("Notofication permission is ${value}");
    if(value){
      Permission.notification.request();

    }
  });
  // await initializeBackService();
  // await initializeExampleService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}


