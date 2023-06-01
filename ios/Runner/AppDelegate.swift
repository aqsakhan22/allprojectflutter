import UIKit
import Flutter
import flutter_background_service_ios

enum ChannelName {
  static let battery = "samples.flutter.io/battery"
  static let charging = "samples.flutter.io/charging"
}




enum BatteryState {
  static let charging = "charging"
  static let discharging = "discharging"
}

enum MyFlutterErrorCode {
  static var unavailable = "UNAVAILABLE"
}
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,FlutterStreamHandler  {
    private var eventSink: FlutterEventSink?
    var name="Aqsa"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel=FlutterMethodChannel(name:"AqsaChannel",binaryMessenger: controller.binaryMessenger);
      let batteryChannel = FlutterMethodChannel(name: ChannelName.battery,binaryMessenger: controller.binaryMessenger)
      let chargingChannel = FlutterEventChannel(name: ChannelName.charging,binaryMessenger: controller.binaryMessenger)
      let cancelStream=FlutterMethodChannel(name:"cancelStream",binaryMessenger: controller.binaryMessenger);



       cancelStream.setMethodCallHandler({
                [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                guard call.method == "StreamCancel" else {
                  result(FlutterMethodNotImplemented)
                  return
                }
              self?.eventSink=nil
        
              })
      batteryChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          guard call.method == "getBatteryLevel" else {
            result(FlutterMethodNotImplemented)
            return
          }
          self?.receiveBatteryLevel(result: result)
        })



      channel.setMethodCallHandler(
        {
         [weak self] (call: FlutterMethodCall,result: FlutterResult) -> Void in
          //This method is invoked in the UI thread
          guard call.method == "showToast" else{
              result(FlutterMethodNotImplemented)
              return
          }
          self?.getMessage(result:result)

      }

      )

      channel.setMethodCallHandler(
        {
       (call: FlutterMethodCall,result: FlutterResult) -> Void in
          //This method is invoked in the UI thread
            guard let args = call.arguments as? [String : Any] else {return}
            var startTracking = args["name"] as! String

            print("start tracking is ",startTracking)
            if(call.method == "showName1"){
               // self?.getMessage1(result:result)
                
                print("call.arguments",call.arguments!)
                self.name = call.arguments as! String
//                print("self nam",self?.name)
                result(call.arguments!)
            }
            if(call.method == "showName2"){
             print("call.arguments showName2",call.arguments!)
                print("call.arguments showName2",startTracking)
                self.name=startTracking
                print("showName2 name",self.name)
                self.getMessage2()
                 result(startTracking)
            }
         
            
            else{
              result(FlutterMethodNotImplemented)
              return
          }
            
           

      })
  


      SwiftFlutterBackgroundServicePlugin.taskIdentifier = "dev.flutter.background.refresh"
    GeneratedPluginRegistrant.register(with: self)


     chargingChannel.setStreamHandler(self)
   
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func receiveBatteryLevel(result: FlutterResult) {
       let device = UIDevice.current
       device.isBatteryMonitoringEnabled = true
       guard device.batteryState != .unknown  else {
         result(FlutterError(code: MyFlutterErrorCode.unavailable,
                             message: "Battery info unavailable",
                             details: nil))
         return
       }
       result(Int(device.batteryLevel * 100))
     }

    @objc public func onListen(withArguments arguments: Any?,
                           eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        UIDevice.current.isBatteryMonitoringEnabled = true
        sendBatteryStateEvent()
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(AppDelegate.onBatteryStateDidChange),
          name: UIDevice.batteryStateDidChangeNotification,
          object: nil)
        return nil
      }

      @objc private func onBatteryStateDidChange(notification: NSNotification) {
        sendBatteryStateEvent()
      }

    private func sendBatteryStateEvent() {
        guard let eventSink = eventSink else {
          return
        }

        switch UIDevice.current.batteryState {
        case .full:
          eventSink(BatteryState.charging)
        case .charging:
          eventSink(BatteryState.charging)
        case .unplugged:
          eventSink(BatteryState.discharging)
        default:
          eventSink(FlutterError(code: MyFlutterErrorCode.unavailable,
                                 message: "Charging status unavailable",
                                 details: nil))
        }
      }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
      }


    private func getMessage(result: FlutterResult){
        let message = "Message from swift to dart";
        if message.isEmpty{
            result(FlutterError(code:"UnAVAILABLE",
                                message:"Message from swift is empty",
                                details:nil))
        }
        else{
            result(message)
        }
    }
    private func getMessage1(result: FlutterResult){

//        guard let args = call.arguments as? [String : Any] else {return}
       
//        let message = args["msg"]  as! String
        var message = "hello i am aqsa"
        
//        message.append( MyFlutterErrorCode.unavailable)
//         print("self name ", MyFlutterErrorCode.unavailable)

     
        if message.isEmpty{
            result(FlutterError(code:"UnAVAILABLE",
                                message:"Message from swift is empty",
                                details:nil))
        }
        else{
            result(message)
        }
    }

     private func getMessage2(){
   
     print("getMessage2",self.name)
    }








}
