import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/view/usersscreen.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/viewmodel/userViewModel.dart';
import 'package:firebaseflutterproject/bflow/my_view_model.dart';
import 'package:firebaseflutterproject/examples/multiple_floating_buttons.dart';
import 'package:firebaseflutterproject/firebase_options.dart';
import 'package:firebaseflutterproject/firebase_services/fcm_controller.dart';
import 'package:firebaseflutterproject/socketLearning/socket_initialization.dart';
import 'package:firebaseflutterproject/stateManagement/provider/count_provider.dart';
import 'package:firebaseflutterproject/stateManagement/provider/example_one.dart';
import 'package:firebaseflutterproject/stateManagement/provider/favourite_provider.dart';
import 'package:firebaseflutterproject/stateManagement/provider/theme_provider.dart';
import 'package:firebaseflutterproject/user_intefaces/notification_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugDefaultTargetPlatformOverride = TargetPlatform.android;
  //  NotificationService().initNotification();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  //
  //
  // await listenToFCM();
  await askPermission();
  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //   //initialize socket
  //   SoccketIntegration().initSocket();
  // });
  runApp(const MyApp());
}

askPermission() async {
  print("Ask permission");

  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
    // Permission.locationWhenInUse,
    // Permission.locationAlways,
    Permission.location,
    Permission.camera,
    Permission.mediaLibrary,
    Permission.audio,
    // Permission.notification
  ].request();
  Permission.location.status.isDenied.then((value) async {
    print("locationWhenInUse ${statuses[Permission.locationWhenInUse]}");
    print("locationAlways ${statuses[Permission.locationAlways]}");
    print("location ${statuses[Permission.location]}");
    print("camera ${statuses[Permission.camera]}");
    print("mediaLibrary ${statuses[Permission.mediaLibrary]}");
    print("audio ${statuses[Permission.audio]}");
    print("notification ${statuses[Permission.notification]}");
  });
  if (await Permission.manageExternalStorage.request().isGranted) {
    print("manageExternalStorage Denied settings");
    // AppSettings.openAppSettings();
  }
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
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => MyViewModel()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeChanger = Provider.of<ThemeProvider>(context);

          return Sizer(builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {

            return         MaterialApp(
              title: 'Flutter Demo',
              themeMode: themeChanger.themeMode,
              theme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.red, primaryColor: Colors.purple),
              darkTheme: ThemeData(
                  primarySwatch: Colors.blue,
                  brightness: Brightness.dark,
                  primaryColor: Colors.red,
                  iconTheme: IconThemeData(color: Colors.red),
                  appBarTheme: AppBarTheme(
                    // color: Colors.blue,
                      backgroundColor: Colors.blue)),
              // home: LoginScreen(),
              home: UserScreen(),
              // initialRoute: RoutesName.login,
              // onGenerateRoute: Routes.generateRoute,
            );
          },

          );
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
