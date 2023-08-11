
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_settings/app_settings.dart';

class NotificationServices{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  void requestNotificationPermission() async{
    NotificationSettings settings= await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,

    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("USER GRANTED PERMISSIONS");
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("USER GRANTED PROVISIONAL PERMISSIONS");
    }
    else{
      print("USER Not give permssion");
      AppSettings.openNotificationSettings();
    }
  }

  Future<String> getDeviceToken() async{
    String? token=await messaging.getToken();
    return token!;
  }



}