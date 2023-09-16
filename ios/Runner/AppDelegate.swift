
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      NSLog("AppDelegate Inside ")
      

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let appIconChannel = FlutterMethodChannel(name: "appIconChannel", binaryMessenger: controller as! FlutterBinaryMessenger)
    
    appIconChannel.setMethodCallHandler({
        [weak self](call: FlutterMethodCall, result: FlutterResult) -> Void in
        guard call.method == "changeIcon" else {
            print("AppDelegate Inside FlutterMethodNotImplemented ")
            result(FlutterMethodNotImplemented)
            return
        }
        self?.changeAppIcon(call: call)
    })
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
    application.applicationIconBadgeNumber = 0
                let center = UNUserNotificationCenter.current()
                center.removeAllDeliveredNotifications()
                center.removeAllPendingNotificationRequests()

  //UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func changeAppIcon(call: FlutterMethodCall){

        print("AppDelegate changeAppIcon ")

        if #available(iOS 10.3, *) {
            
            guard UIApplication.shared.supportsAlternateIcons else {
                   print("AppDelegate UIApplication.shared.supportsAlternateIcons else exec ")
                return
            }
                
                let arguments : String = call.arguments as! String
                
                  print("AppDelegate args=> "+arguments)

                if arguments == "BKInternational" {
                    print("AppDelegate BKInternational")
                    UIApplication.shared.setAlternateIconName("BKInternational")
                } else if arguments == "KG"{
                     print("AppDelegate KG")
                    UIApplication.shared.setAlternateIconName("KGC")
                } else {
                     print("AppDelegate nil")
                    UIApplication.shared.setAlternateIconName(nil)
                }
                

        } else {
             print("AppDelegate changeAppIcon Fallback on earlier versions ")
            // Fallback on earlier versions
        }
        
    }
}
