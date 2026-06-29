import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    let appInfoChannel = FlutterMethodChannel(
      name: "uk.guzek.okresownik/app_info",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    appInfoChannel.setMethodCallHandler { call, result in
      if call.method == "getVersion" {
        result(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
