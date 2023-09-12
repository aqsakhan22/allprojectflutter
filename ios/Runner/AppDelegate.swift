import UIKit
import Flutter
import flutter_background_service_ios // add this
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

        // Google API for IOS
      GMSServices.provideAPIKey("AIzaSyBHxmOZ-ie3JPqsALAvGfmbDS8OQRlZLG8")
      // FlutterBackgroundServicePlugin for IOS
      SwiftFlutterBackgroundServicePlugin.taskIdentifier = "dev.flutter.background.refresh"

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
