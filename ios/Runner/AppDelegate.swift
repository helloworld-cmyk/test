import Flutter
import UIKit
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    guard let registrar = registrar(forPlugin: "NativeViewFactory") else {
      assertionFailure("Could not create registrar for NativeViewFactory")
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    registrar.register(NativeViewFactory(), withId: "native-swift-view")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
