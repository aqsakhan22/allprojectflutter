import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runwith/screens/SpotifyExample/Debugging.dart';
import 'package:runwith/utility/shared_preference.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:runwith/providers/all_programs_provider.dart';
import 'package:runwith/providers/audioqueues_provider.dart';
import 'package:runwith/providers/auth_provider.dart';
import 'package:runwith/providers/chat_provider.dart';
import 'package:runwith/providers/clubs_provider.dart';
import 'package:runwith/providers/notification_provider.dart';
import 'package:runwith/providers/quotes_provider.dart';
import 'package:runwith/providers/run_provider.dart';
import 'package:runwith/providers/running_buddies.dart';
import 'package:runwith/providers/running_program_provider.dart';
import 'package:runwith/providers/socila_feeds_provider.dart';
import 'package:runwith/screens/Clubs/all_clubs.dart';
import 'package:runwith/screens/events.dart';
import 'package:runwith/screens/RunningBuddies/running_buddies.dart';
import 'package:runwith/screens/add_gear.dart';
import 'package:runwith/screens/chats/chats.dart';
import 'package:runwith/screens/chats/personal_chats.dart';
import 'package:runwith/screens/edit_gear.dart';
import 'package:runwith/screens/feedback.dart';
import 'package:runwith/screens/forum/community.dart';
import 'package:runwith/screens/gear_list.dart';
import 'package:runwith/screens/home.dart';
import 'package:runwith/screens/my_profile.dart';
import 'package:runwith/screens/notifications.dart';
import 'package:runwith/screens/privacy_policy.dart';
import 'package:runwith/screens/run_history.dart';
import 'package:runwith/screens/runing_gear.dart';
import 'package:runwith/screens/running_program.dart';
import 'package:runwith/screens/search.dart';
import 'package:runwith/screens/search_all.dart';
import 'package:runwith/screens/signin.dart';
import 'package:runwith/screens/signup.dart';
import 'package:runwith/screens/socialfeed/social_feeds.dart';
import 'package:runwith/screens/start_run.dart';
import 'package:runwith/screens/thankyou.dart';
import 'package:runwith/screens/welcome.dart';
import 'package:runwith/services/background.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:runwith/screens/RunningBuddies/find_running_buddies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await askPermission();
  await initializePreferences();
  // await initializeService();
  await dotenv.load(fileName: '.env');
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.white.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  runApp(const MyApp());
}

askPermission() async {
  print("Ask permission");
  Permission.location.status.isDenied.then((value) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.contacts,
      Permission.sms,
      Permission.phone,
      Permission.microphone,
      Permission.camera,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.mediaLibrary,
      Permission.audio,
      Permission.locationAlways
    ].request();
    print(statuses[Permission.notification]);
    print(statuses[Permission.location]);
    print(statuses[Permission.camera]);
    print(statuses[Permission.bluetooth]);
    print(statuses[Permission.audio]);
    //Navigator.pop(context);
  });
  // if (await Permission.camera.isPermanentlyDenied || await Permission.camera.isDenied ) {
  //
  //   print("Denied settings");
  //
  //   // The user opted to never again see the permission request dialog for this
  //   // app. The only way to change the permission's status now is to let the
  //   // user manually enable it in the system settings.
  //   AppSettings.openAppSettings();
  // }
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            // ChangeNotifierProvider(create: (_) => RunProvider()),
            ChangeNotifierProvider(create: (_) => ClubsProvider()),
            ChangeNotifierProvider(create: (_) => RunningBuddiesProvider()),
            ChangeNotifierProvider(create: (_) => AllPrograms()),
            ChangeNotifierProvider(create: (_) => ChatProvider()),
            ChangeNotifierProvider(create: (_) => SocialfeedsProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => RunningProgramProvider()),
            ChangeNotifierProvider(create: (_) => QuoteProvider()),
            ChangeNotifierProvider(create: (_) => AudioQueuesProvider()),
          ],
          child: RefreshConfiguration(
              headerBuilder: () => WaterDropHeader(),
              footerBuilder:  () => ClassicFooter(),        // Configure default bottom indicator
              headerTriggerDistance: 100.0,        // header trigger refresh trigger distance
              springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // custom spring back animate,the props meaning see the flutter api
              maxOverScrollExtent :150, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
              maxUnderScrollExtent:200, // Maximum dragging range at the bottom
              enableScrollWhenRefreshCompleted: true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
              enableLoadingWhenFailed : true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
              hideFooterWhenNotFull: false, // Disable pull-up to load more functionality when Viewport is less than one screen
              enableBallisticLoad: true,
              child: MaterialApp(
                title: 'Run With',
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.black,
                  fontFamily: 'Inter',
                  appBarTheme: AppBarTheme(
                    iconTheme: IconThemeData(color: Colors.white),
                    color: Colors.black,
                  ),
                  // This is the theme of your application.
                  //
                  // Try running your application with "flutter run". You'll see the
                  // application has a blue toolbar. Then, without quitting the app, try
                  // changing the primarySwatch below to Colors.green and then invoke
                  // "hot reload" (press "r" in the console where you ran "flutter run",
                  // or simply save your changes to "hot reload" in a Flutter IDE).
                  // Notice that the counter didn't reset back to zero; the application
                  // is not restarted.
                  primarySwatch: Colors.blue,
                ),
                navigatorKey: TopVariables.appNavigationKey,
                initialRoute: '/',
                builder: EasyLoading.init(),
                home: UserPreferences.AuthToken.isEmpty ? WelcomeScreen() : SpotifyExample(),
                // routes: {
                //   // '/': (context) => const Home(),
                //   '/privaypolicy': (context) => PrivacyPolicy(),
                //   '/SignIn': (context) => SignIn(),
                //   '/SignUp': (context) => SignUp(),
                //   '/Home': (context) => Home(),
                //   '/MyProfile': (context) => MyProfile(),
                //   '/StartRun': (context) => StartRun(),
                //   '/RunHistory': (context) => RunHistory(),
                //   '/Feedback': (context) => Feedbackscreen(),
                //   '/SearchClubs': (context) => SearchClubs(),
                //   '/Clubs': (context) => Clubs(),
                //   '/RunningGear': (context) => RunningGear(),
                //   '/AddGear': (context) => AddGear(),
                //   '/EditGear': (context) => EditGear(),
                //   '/Notifications': (context) => NotificationScreen(),
                //   '/RunningProgram': (context) => RunningProgram(),
                //   '/GearList': (context) => GearList(),
                //   '/RunningBuddies': (context) => RunningBuddies(),
                //   '/FindBuddies': (context) => FindBuddies(),
                //   '/SearchAll': (context) => SearchAll(),
                //   '/Chats': (context) => Chats(),
                //   '/personalChats': (context) => PersonalChats(),
                //   '/chatForum': (context) => ChatForum(),
                //   '/socialfeed': (context) => SocialFeeds(),
                //   '/ViewEvents': (context) => Events(),
                //   '/Thankyou': (context) => ThankYou(),
                // },
                debugShowCheckedModeBanner: false,
              )
          )
      ),
    );
  }
}