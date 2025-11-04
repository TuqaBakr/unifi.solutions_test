import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let nativeChannel = FlutterMethodChannel(name: "com.app/native_utils", binaryMessenger: controller.binaryMessenger)

    nativeChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else { return }

      switch call.method {
      case "getStorageInfo":
          self.getStorageInfo(result: result)
      case "requestCameraPermission":
          self.requestCameraPermission(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getStorageInfo(result: FlutterResult) {
    do {
      let fileURL = URL(fileURLWithPath: NSHomeDirectory())
      let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey])

      guard let totalCapacity = values.volumeTotalCapacity,
            let availableCapacity = values.volumeAvailableCapacity else {
          result(FlutterError(code: "STORAGE_ERROR", message: "Failed to read storage capacity values.", details: nil))
          return
      }

      result([
        "totalBytes": totalCapacity,
        "freeBytes": availableCapacity
      ])

    } catch {
      result(FlutterError(code: "STORAGE_ERROR", message: "Failed to access file system for storage info.", details: error.localizedDescription))
    }
  }

  private func requestCameraPermission(result: @escaping FlutterResult) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      result("granted")

    case .denied:
      result("denied")

    case .restricted:
      result("restricted")

    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
          if granted {
            result("granted")
          } else {
            result("denied")
          }
        }
      }

    @unknown default:

      result("unknown")
    }
  }
}
