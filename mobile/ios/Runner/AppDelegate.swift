import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    let appInfoChannel = FlutterMethodChannel(
      name: "uk.guzek.okresownik/app_info",
      binaryMessenger: engineBridge.applicationRegistrar.messenger())
    appInfoChannel.setMethodCallHandler { call, result in
      if call.method == "getVersion" {
        result(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
