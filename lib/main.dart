import 'package:flutter/material.dart';
import 'package:flutterdevelopment/background_service_learning.dart';

import 'package:flutterdevelopment/service_example.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initializeService();
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
      home: const BackgroundServiceExample(),
    );
  }
}


