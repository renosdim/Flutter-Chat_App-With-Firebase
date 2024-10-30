import UIKit
import Flutter
import AppCenter  // Base App Center framework
import AppCenterAnalytics  // Analytics module
import AppCenterCrashes  // Crashes module

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // Initialize App Center with the manually set app secret and selected services
      MSAppCenter.start("a68fac47fcd362df1f3432d7678e0d23c1645e58", withServices: [
        MSAnalytics.self,  // Note the "MS" prefix for manually integrated SDKs
        MSCrashes.self
      ])

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
