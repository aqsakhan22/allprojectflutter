import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseflutterproject/firebase_options.dart';
import 'package:firebaseflutterproject/firebase_services/fcm_controller.dart';
import 'package:firebaseflutterproject/stateManagement/provider/count_provider.dart';
import 'package:firebaseflutterproject/stateManagement/provider/example_one.dart';
import 'package:firebaseflutterproject/stateManagement/provider/favourite_provider.dart';
import 'package:firebaseflutterproject/stateManagement/provider/theme_provider.dart';
import 'package:firebaseflutterproject/user_intefaces/FavouriteScreen.dart';
import 'package:firebaseflutterproject/user_intefaces/dart_theme.dart';
import 'package:firebaseflutterproject/user_intefaces/firebase_notify_screen.dart';
import 'package:firebaseflutterproject/user_intefaces/notification_settings.dart';
import 'package:firebaseflutterproject/user_intefaces/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await listenToFCM();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  //  final themeChanger=Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountProvider()),
        ChangeNotifierProvider(create: (_) => colorchange()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(
        builder: (BuildContext context){
          final themeChanger=Provider.of<ThemeProvider>(context);

          return MaterialApp(
              title: 'Flutter Demo',
              themeMode: themeChanger.themeMode,
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.red,
                  primaryColor: Colors.purple
              ),
              darkTheme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: Brightness.dark,
                primaryColor: Colors.red,
                iconTheme: IconThemeData(
                  color: Colors.red
                ),
                appBarTheme: AppBarTheme(
                  // color: Colors.blue,
                  backgroundColor: Colors.blue
                )
              ),
              home: Firebase_notify_screen());
        },
      ),
    );
  }
}
// ChangeNotifierProvider(
// create: (_) => CountProvider(), // thius is for single provider
// child:      MaterialApp(
// title: 'Flutter Demo',
// theme: ThemeData(
//
// // This is the theme of your application.
// //
// // Try running your application with "flutter run". You'll see the
// // application has a blue toolbar. Then, without quitting the app, try
// // changing the primarySwatch below to Colors.green and then invoke
// // "hot reload" (press "r" in the console where you ran "flutter run",
// // or simply save your changes to "hot reload" in a Flutter IDE).
// // Notice that the counter didn't reset back to zero; the application
// // is not restarted.
// primarySwatch: Colors.pink,
// ),
// home: SplashScreen()
// ),
// )
