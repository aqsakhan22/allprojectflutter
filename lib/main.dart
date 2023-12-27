


import 'package:flutter/material.dart';
import 'package:notificationflutter/router.dart';
import 'package:notificationflutter/utility/topVariable.dart';
import 'package:permission_handler/permission_handler.dart';
// https://firebase.flutter.dev/docs/messaging/notifications/
// f_dGTikRSYiTX87l9d8OAG:APA91bE9rp4wKuX2o0sWTRemt3IKybkGgHhIbOY-HPaQxSOugT204v670fzKOfp3Sc4M4bKZCqgaxzr-ClWpyILh7FaAJVk8zEmi21hs3ateSw3raDyFjHi9xlcjYObFM3E80wvG0S3u

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await askPermission();
  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute:'splash' ,
        onGenerateRoute:MyRoute().generateRoute,
        debugShowCheckedModeBanner: false,

        navigatorKey: TopVariables.appNavigationKey,


      )
  );
}

askPermission() async {

  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
    // Permission.notification
  ].request();



}


