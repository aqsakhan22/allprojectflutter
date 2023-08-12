import UIKit
import Flutter
import flutter_local_notifications
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
 
  FlutterLocalNotificationsPlugin.setPluginRegistrantCallback{(registry) in GeneratedPluginRegistrant.register(with: registry) }
     FirebaseApp.configure() //add this before the code below
    GeneratedPluginRegistrant.register(with: self)
//     if #available(iOS 10.0,*){
//     UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenter
//     }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
