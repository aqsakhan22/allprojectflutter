import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initializeBackService() async{


  final service=FlutterBackgroundService();
  await service.configure(

      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground:  onIosBackground,
        autoStart: true, // this will be executed when app is in foreground in separated isolate
      ), androidConfiguration: AndroidConfiguration(
      onStart: onStart, isForegroundMode: true,
      autoStart: true

  )


  );

}
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  print('IOS FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  return true;
}
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async{
  //A simple answer is that if Flutter needs to call native code before calling runApp
  WidgetsFlutterBinding.ensureInitialized();
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  if(service is AndroidServiceInstance){
    service.on('setAsForeground').listen((event) {
     service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
     service.setAsBackgroundService();
    });
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  }

  service.on('BGServices').listen((event) {
    Timer.periodic(const Duration(seconds: 1), (timer) async {

      if(service is AndroidServiceInstance){
        if(await service.isForegroundService()){
          service.setForegroundNotificationInfo(title: "Flutter development", content: "Background service ");
          print("foreground service running ${timer.tick}");

        }



      }
      print("background service running ${timer.tick}");
      service.invoke("update",{
        "current_date": DateTime.now().toIso8601String(),
      });

    });
  });






}