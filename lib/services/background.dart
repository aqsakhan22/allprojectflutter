import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:runwith/providers/run_provider.dart';

import '../utility/top_level_variables.dart';

const String actionStartBGServices = 'startBGServices';
const String actionRunningProgress = 'runningProgress';
const String actionStartRunning = 'startRunning';

Future<void> initializeService() async {
  //final FlutterBackgroundService flutterBackgroundService = FlutterBackgroundService();
  await TopVariables.service.configure(
    androidConfiguration: AndroidConfiguration(
      // This will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // Auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  TopVariables.service.startService().then((value) {
    TopVariables.service.invoke(actionStartBGServices);
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  print('IOS FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on(actionStartBGServices).listen((event) {
      print("Background Service Notification Started In Android");
      service.setForegroundNotificationInfo(
        title: "RunWith",
        content: "Join The Running Community",
      );
    });
  }

  service.on('stopService').listen((event) {
    print("service has been stopped");
    service.stopSelf();
    RunProvider.counter=0;
    RunProvider().setCounter();
  });

  service.on(actionRunningProgress).listen((event) {
    // Call Function
    print("Update Run API Called In Backend");
    RunProvider().updateRun();
  });

  service.on(actionStartRunning).listen((event) {
    // Keep Session Timer Running At BG
    print("Update Interval Time In Sec: ${event!['updateInterval']}");
    int updateInterval = event['updateInterval'].toInt() ?? 0;
    int sec = 0;
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
      if (service is AndroidServiceInstance) {
        print("Android Background Service Notification Started On Run Start");
        service.setForegroundNotificationInfo(
          title: "RunWith",
          content: "Running Since ${sec} sec",
        );
      }
      sec++;
      //print("Time Remaining in Background: ${sec}");
      if (sec % updateInterval == 0) {
        //print("Background Location Sent At Every 5 Sec");
        service.invoke(actionRunningProgress);
      }
    });
    // Keep Session Timer Running At BG
  });

}
